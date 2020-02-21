Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6EC3167473
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387634AbgBUIVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:21:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:32786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730858AbgBUIVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:21:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E47520578;
        Fri, 21 Feb 2020 08:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273290;
        bh=vijHEoPGBeRlPYdehiBChsYQ5jsjMYwDJb0k6rhJrOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HcprrQ8DDmrWkGa4Iaj/JR9G2KJ1Tk0N5X0Of1YoaSFiybRz/dQoFNviR164aruwn
         90TibR0I6iCvedFR2N+DigsNIJxr6Al9zp45SX+3a3oRRUQ/MiX5LODEJSzCuqD+oZ
         p71ZspZSadu7XMlhu8PZnrwwj599DkcTgGZZJzdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/191] crypto: chtls - Fixed memory leak
Date:   Fri, 21 Feb 2020 08:41:01 +0100
Message-Id: <20200221072301.691523468@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8b749c721c871..28d24118c6450 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -731,6 +731,14 @@ static int chtls_close_listsrv_rpl(struct chtls_dev *cdev, struct sk_buff *skb)
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
@@ -745,6 +753,11 @@ static void chtls_release_resources(struct sock *sk)
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
@@ -1714,6 +1727,7 @@ static void chtls_peer_close(struct sock *sk, struct sk_buff *skb)
 		else
 			sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
 	}
+	kfree_skb(skb);
 }
 
 static void chtls_close_con_rpl(struct sock *sk, struct sk_buff *skb)
@@ -2041,19 +2055,6 @@ rel_skb:
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
index 78eb3afa3a80d..4282d8a4eae48 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.h
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.h
@@ -188,6 +188,12 @@ static inline void chtls_kfree_skb(struct sock *sk, struct sk_buff *skb)
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
@@ -200,4 +206,19 @@ static inline void enqueue_wr(struct chtls_sock *csk, struct sk_buff *skb)
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
index 4909607558644..64d24823c65aa 100644
--- a/drivers/crypto/chelsio/chtls/chtls_hw.c
+++ b/drivers/crypto/chelsio/chtls/chtls_hw.c
@@ -361,6 +361,7 @@ int chtls_setkey(struct chtls_sock *csk, u32 keylen, u32 optname)
 	kwr->sc_imm.cmd_more = cpu_to_be32(ULPTX_CMD_V(ULP_TX_SC_IMM));
 	kwr->sc_imm.len = cpu_to_be32(klen);
 
+	lock_sock(sk);
 	/* key info */
 	kctx = (struct _key_ctx *)(kwr + 1);
 	ret = chtls_key_info(csk, kctx, keylen, optname);
@@ -399,8 +400,10 @@ int chtls_setkey(struct chtls_sock *csk, u32 keylen, u32 optname)
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



