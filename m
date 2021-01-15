Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4DC2F799E
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732954AbhAOMix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:38:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387679AbhAOMix (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:38:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33603207C4;
        Fri, 15 Jan 2021 12:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714292;
        bh=FNrhpOdubO+fp4vxObvCDZgzZdoszJ8dvnmgI4H6wkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IE0Qxc99/9a1U4Zq8sSB016eYg2lpMsNH3Dl/v+Meuhg8RNvBdPDgHOGQKGJ07NPF
         yx1Lp9LOFeBYSsGYNBaFWk1M4g2SVoMMDQsKFl7vwScc33+EaevlkDqQyBebaGEOWz
         5Sh9lciKryysaLo1kT3zn8phKidwZnIjnf6AojZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohit Maheshwari <rohitm@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 029/103] chtls: Fix hardware tid leak
Date:   Fri, 15 Jan 2021 13:27:22 +0100
Message-Id: <20210115122007.469592165@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

[ Upstream commit 717df0f4cdc9044c415431a3522b3e9ccca5b4a3 ]

send_abort_rpl() is not calculating cpl_abort_req_rss offset and
ends up sending wrong TID with abort_rpl WR causng tid leaks.
Replaced send_abort_rpl() with chtls_send_abort_rpl() as it is
redundant.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c |   39 ------------
 1 file changed, 3 insertions(+), 36 deletions(-)

--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1996,39 +1996,6 @@ static void t4_defer_reply(struct sk_buf
 	spin_unlock_bh(&cdev->deferq.lock);
 }
 
-static void send_abort_rpl(struct sock *sk, struct sk_buff *skb,
-			   struct chtls_dev *cdev, int status, int queue)
-{
-	struct cpl_abort_req_rss *req = cplhdr(skb);
-	struct sk_buff *reply_skb;
-	struct chtls_sock *csk;
-
-	csk = rcu_dereference_sk_user_data(sk);
-
-	reply_skb = alloc_skb(sizeof(struct cpl_abort_rpl),
-			      GFP_KERNEL);
-
-	if (!reply_skb) {
-		req->status = (queue << 1);
-		t4_defer_reply(skb, cdev, send_defer_abort_rpl);
-		return;
-	}
-
-	set_abort_rpl_wr(reply_skb, GET_TID(req), status);
-	kfree_skb(skb);
-
-	set_wr_txq(reply_skb, CPL_PRIORITY_DATA, queue);
-	if (csk_conn_inline(csk)) {
-		struct l2t_entry *e = csk->l2t_entry;
-
-		if (e && sk->sk_state != TCP_SYN_RECV) {
-			cxgb4_l2t_send(csk->egress_dev, reply_skb, e);
-			return;
-		}
-	}
-	cxgb4_ofld_send(cdev->lldi->ports[0], reply_skb);
-}
-
 static void chtls_send_abort_rpl(struct sock *sk, struct sk_buff *skb,
 				 struct chtls_dev *cdev,
 				 int status, int queue)
@@ -2078,8 +2045,8 @@ static void bl_abort_syn_rcv(struct sock
 
 	skb->sk	= NULL;
 	do_abort_syn_rcv(child, lsk);
-	send_abort_rpl(child, skb, BLOG_SKB_CB(skb)->cdev,
-		       CPL_ABORT_NO_RST, queue);
+	chtls_send_abort_rpl(child, skb, BLOG_SKB_CB(skb)->cdev,
+			     CPL_ABORT_NO_RST, queue);
 }
 
 static int abort_syn_rcv(struct sock *sk, struct sk_buff *skb)
@@ -2110,7 +2077,7 @@ static int abort_syn_rcv(struct sock *sk
 		int queue = csk->txq_idx;
 
 		do_abort_syn_rcv(sk, psk);
-		send_abort_rpl(sk, skb, cdev, CPL_ABORT_NO_RST, queue);
+		chtls_send_abort_rpl(sk, skb, cdev, CPL_ABORT_NO_RST, queue);
 	} else {
 		skb->sk = sk;
 		BLOG_SKB_CB(skb)->backlog_rcv = bl_abort_syn_rcv;


