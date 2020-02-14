Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14D9E15ED28
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390287AbgBNRcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:32:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390095AbgBNQGr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:06:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1352D2187F;
        Fri, 14 Feb 2020 16:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696405;
        bh=w8l2u3DsDpEHt9S27ap6vMdI80qogU2aYfovpE+ynkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqEuNvbMzBannCJ3f2QbMx8ji0NEQ0LJqyyaw8P6T574aXpdVUwoKYe4p7POEPu0m
         +LU7tJy2EMzZb+TzX2UQomPQpTcDgtFIIjPBO50ET6/44OydV1x4zOg4pBJ+a0mdQ5
         KfcWaFxUp32Gsy2/IL0OXwNB1vk05BmySOlL8HQE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 229/459] crypto: chtls - Fixed memory leak
Date:   Fri, 14 Feb 2020 10:57:59 -0500
Message-Id: <20200214160149.11681-229-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

[ Upstream commit 93e23eb2ed6c11b4f483c8111ac155ec2b1f3042 ]

Freed work request skbs when connection terminates.
enqueue_wr()/ dequeue_wr() is shared between softirq
and application contexts, should be protected by socket
lock. Moved dequeue_wr() to appropriate file.

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 27 +++++++++++++------------
 drivers/crypto/chelsio/chtls/chtls_cm.h | 21 +++++++++++++++++++
 drivers/crypto/chelsio/chtls/chtls_hw.c |  3 +++
 3 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index aca75237bbcf8..dffa2aa855fdd 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -727,6 +727,14 @@ static int chtls_close_listsrv_rpl(struct chtls_dev *cdev, struct sk_buff *skb)
 	return 0;
 }
 
+static void chtls_purge_wr_queue(struct sock *sk)
+{
+	struct sk_buff *skb;
+
+	while ((skb = dequeue_wr(sk)) != NULL)
+		kfree_skb(skb);
+}
+
 static void chtls_release_resources(struct sock *sk)
 {
 	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
@@ -741,6 +749,11 @@ static void chtls_release_resources(struct sock *sk)
 	kfree_skb(csk->txdata_skb_cache);
 	csk->txdata_skb_cache = NULL;
 
+	if (csk->wr_credits != csk->wr_max_credits) {
+		chtls_purge_wr_queue(sk);
+		chtls_reset_wr_list(csk);
+	}
+
 	if (csk->l2t_entry) {
 		cxgb4_l2t_release(csk->l2t_entry);
 		csk->l2t_entry = NULL;
@@ -1735,6 +1748,7 @@ static void chtls_peer_close(struct sock *sk, struct sk_buff *skb)
 		else
 			sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
 	}
+	kfree_skb(skb);
 }
 
 static void chtls_close_con_rpl(struct sock *sk, struct sk_buff *skb)
@@ -2062,19 +2076,6 @@ static int chtls_conn_cpl(struct chtls_dev *cdev, struct sk_buff *skb)
 	return 0;
 }
 
-static struct sk_buff *dequeue_wr(struct sock *sk)
-{
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
-	struct sk_buff *skb = csk->wr_skb_head;
-
-	if (likely(skb)) {
-	/* Don't bother clearing the tail */
-		csk->wr_skb_head = WR_SKB_CB(skb)->next_wr;
-		WR_SKB_CB(skb)->next_wr = NULL;
-	}
-	return skb;
-}
-
 static void chtls_rx_ack(struct sock *sk, struct sk_buff *skb)
 {
 	struct cpl_fw4_ack *hdr = cplhdr(skb) + RSS_HDR;
diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.h b/drivers/crypto/chelsio/chtls/chtls_cm.h
index 129d7ac649a93..3fac0c74a41fa 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.h
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.h
@@ -185,6 +185,12 @@ static inline void chtls_kfree_skb(struct sock *sk, struct sk_buff *skb)
 	kfree_skb(skb);
 }
 
+static inline void chtls_reset_wr_list(struct chtls_sock *csk)
+{
+	csk->wr_skb_head = NULL;
+	csk->wr_skb_tail = NULL;
+}
+
 static inline void enqueue_wr(struct chtls_sock *csk, struct sk_buff *skb)
 {
 	WR_SKB_CB(skb)->next_wr = NULL;
@@ -197,4 +203,19 @@ static inline void enqueue_wr(struct chtls_sock *csk, struct sk_buff *skb)
 		WR_SKB_CB(csk->wr_skb_tail)->next_wr = skb;
 	csk->wr_skb_tail = skb;
 }
+
+static inline struct sk_buff *dequeue_wr(struct sock *sk)
+{
+	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct sk_buff *skb = NULL;
+
+	skb = csk->wr_skb_head;
+
+	if (likely(skb)) {
+	 /* Don't bother clearing the tail */
+		csk->wr_skb_head = WR_SKB_CB(skb)->next_wr;
+		WR_SKB_CB(skb)->next_wr = NULL;
+	}
+	return skb;
+}
 #endif
diff --git a/drivers/crypto/chelsio/chtls/chtls_hw.c b/drivers/crypto/chelsio/chtls/chtls_hw.c
index 2a34035d3cfbc..a217fe72602d4 100644
--- a/drivers/crypto/chelsio/chtls/chtls_hw.c
+++ b/drivers/crypto/chelsio/chtls/chtls_hw.c
@@ -350,6 +350,7 @@ int chtls_setkey(struct chtls_sock *csk, u32 keylen, u32 optname)
 	kwr->sc_imm.cmd_more = cpu_to_be32(ULPTX_CMD_V(ULP_TX_SC_IMM));
 	kwr->sc_imm.len = cpu_to_be32(klen);
 
+	lock_sock(sk);
 	/* key info */
 	kctx = (struct _key_ctx *)(kwr + 1);
 	ret = chtls_key_info(csk, kctx, keylen, optname);
@@ -388,8 +389,10 @@ int chtls_setkey(struct chtls_sock *csk, u32 keylen, u32 optname)
 		csk->tlshws.txkey = keyid;
 	}
 
+	release_sock(sk);
 	return ret;
 out_notcb:
+	release_sock(sk);
 	free_tls_keyid(sk);
 out_nokey:
 	kfree_skb(skb);
-- 
2.20.1

