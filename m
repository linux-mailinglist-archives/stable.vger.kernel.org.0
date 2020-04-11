Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5FAC1A5814
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbgDKXLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729917AbgDKXL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:11:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2C9C216FD;
        Sat, 11 Apr 2020 23:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646689;
        bh=hHPZfCy20/ddSIEcwbHJISx27Bkvb5pkwUltPXI+ee0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pwo14994xaWSzYpxJXRi/D3pSt4jOp3veW3sLTIJ+LYB/q1l/vswNPVltjeHkCLeU
         o0ga7X2myA9MOYs0hRkXn9Hqg7+yp50zDfzKg8jB91ggZIT9awZ7wXHj6SIv7LMss+
         qcKmC2Essifbqvi0xlsRMs8kpHLKRGi/LqwIen24=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rohit Maheshwari <rohitm@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 084/108] crypto/chtls: Fix chtls crash in connection cleanup
Date:   Sat, 11 Apr 2020 19:09:19 -0400
Message-Id: <20200411230943.24951-84-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>

[ Upstream commit 3a0a978389234995b64a8b8fbe343115bffb1551 ]

There is a possibility that cdev is removed before CPL_ABORT_REQ_RSS
is fully processed, so it's better to save it in skb.

Added checks in handling the flow correctly, which suggests connection reset
request is sent to HW, wait for HW to respond.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 29 +++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index dffa2aa855fdd..bcfe3a71a88b7 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -445,6 +445,7 @@ void chtls_destroy_sock(struct sock *sk)
 	chtls_purge_write_queue(sk);
 	free_tls_keyid(sk);
 	kref_put(&csk->kref, chtls_sock_release);
+	csk->cdev = NULL;
 	sk->sk_prot = &tcp_prot;
 	sk->sk_prot->destroy(sk);
 }
@@ -759,8 +760,10 @@ static void chtls_release_resources(struct sock *sk)
 		csk->l2t_entry = NULL;
 	}
 
-	cxgb4_remove_tid(tids, csk->port_id, tid, sk->sk_family);
-	sock_put(sk);
+	if (sk->sk_state != TCP_SYN_SENT) {
+		cxgb4_remove_tid(tids, csk->port_id, tid, sk->sk_family);
+		sock_put(sk);
+	}
 }
 
 static void chtls_conn_done(struct sock *sk)
@@ -1716,6 +1719,9 @@ static void chtls_peer_close(struct sock *sk, struct sk_buff *skb)
 {
 	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
 
+	if (csk_flag_nochk(csk, CSK_ABORT_RPL_PENDING))
+		goto out;
+
 	sk->sk_shutdown |= RCV_SHUTDOWN;
 	sock_set_flag(sk, SOCK_DONE);
 
@@ -1748,6 +1754,7 @@ static void chtls_peer_close(struct sock *sk, struct sk_buff *skb)
 		else
 			sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
 	}
+out:
 	kfree_skb(skb);
 }
 
@@ -1758,6 +1765,10 @@ static void chtls_close_con_rpl(struct sock *sk, struct sk_buff *skb)
 	struct tcp_sock *tp;
 
 	csk = rcu_dereference_sk_user_data(sk);
+
+	if (csk_flag_nochk(csk, CSK_ABORT_RPL_PENDING))
+		goto out;
+
 	tp = tcp_sk(sk);
 
 	tp->snd_una = ntohl(rpl->snd_nxt) - 1;  /* exclude FIN */
@@ -1787,6 +1798,7 @@ static void chtls_close_con_rpl(struct sock *sk, struct sk_buff *skb)
 	default:
 		pr_info("close_con_rpl in bad state %d\n", sk->sk_state);
 	}
+out:
 	kfree_skb(skb);
 }
 
@@ -1896,6 +1908,7 @@ static void chtls_send_abort_rpl(struct sock *sk, struct sk_buff *skb,
 	}
 
 	set_abort_rpl_wr(reply_skb, tid, status);
+	kfree_skb(skb);
 	set_wr_txq(reply_skb, CPL_PRIORITY_DATA, queue);
 	if (csk_conn_inline(csk)) {
 		struct l2t_entry *e = csk->l2t_entry;
@@ -1906,7 +1919,6 @@ static void chtls_send_abort_rpl(struct sock *sk, struct sk_buff *skb,
 		}
 	}
 	cxgb4_ofld_send(cdev->lldi->ports[0], reply_skb);
-	kfree_skb(skb);
 }
 
 /*
@@ -2008,7 +2020,8 @@ static void chtls_abort_req_rss(struct sock *sk, struct sk_buff *skb)
 		chtls_conn_done(sk);
 	}
 
-	chtls_send_abort_rpl(sk, skb, csk->cdev, rst_status, queue);
+	chtls_send_abort_rpl(sk, skb, BLOG_SKB_CB(skb)->cdev,
+			     rst_status, queue);
 }
 
 static void chtls_abort_rpl_rss(struct sock *sk, struct sk_buff *skb)
@@ -2042,6 +2055,7 @@ static int chtls_conn_cpl(struct chtls_dev *cdev, struct sk_buff *skb)
 	struct cpl_peer_close *req = cplhdr(skb) + RSS_HDR;
 	void (*fn)(struct sock *sk, struct sk_buff *skb);
 	unsigned int hwtid = GET_TID(req);
+	struct chtls_sock *csk;
 	struct sock *sk;
 	u8 opcode;
 
@@ -2051,6 +2065,8 @@ static int chtls_conn_cpl(struct chtls_dev *cdev, struct sk_buff *skb)
 	if (!sk)
 		goto rel_skb;
 
+	csk = sk->sk_user_data;
+
 	switch (opcode) {
 	case CPL_PEER_CLOSE:
 		fn = chtls_peer_close;
@@ -2059,6 +2075,11 @@ static int chtls_conn_cpl(struct chtls_dev *cdev, struct sk_buff *skb)
 		fn = chtls_close_con_rpl;
 		break;
 	case CPL_ABORT_REQ_RSS:
+		/*
+		 * Save the offload device in the skb, we may process this
+		 * message after the socket has closed.
+		 */
+		BLOG_SKB_CB(skb)->cdev = csk->cdev;
 		fn = chtls_abort_req_rss;
 		break;
 	case CPL_ABORT_RPL_RSS:
-- 
2.20.1

