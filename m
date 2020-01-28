Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7114F14B74A
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbgA1ONF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:34636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729613AbgA1ONF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:13:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5683524688;
        Tue, 28 Jan 2020 14:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220783;
        bh=iXKHg8AI2lhYsrb8qwRHgUKD5z5qP7ReisWmw8br7Zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XD/LqgL+Gw2UrRsUgVXtE1kN7jVsG7B1FiIB/v2krF4pyf52/rlM45MZF31+hbwod
         1oj51uZUEx4REHElMTr2lojTJe2SieTHciKud5xnmjXCha7DQs/N8LjS1HM/7ekymW
         npde/66l0oFvQeaVEAVjKQaGSihkUfTr8de//+F8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 144/183] llc: fix another potential sk_buff leak in llc_ui_sendmsg()
Date:   Tue, 28 Jan 2020 15:06:03 +0100
Message-Id: <20200128135844.142972039@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit fc8d5db10cbe1338a52ebc74e7feab9276721774 ]

All callers of llc_conn_state_process() except llc_build_and_send_pkt()
(via llc_ui_sendmsg() -> llc_ui_send_data()) assume that it always
consumes a reference to the skb.  Fix this caller to do the same.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/llc/af_llc.c   | 34 ++++++++++++++++++++--------------
 net/llc/llc_conn.c |  2 ++
 net/llc/llc_if.c   | 12 ++++++++----
 3 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index c153fc2883a86..69f1558dfcb74 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -111,22 +111,26 @@ static inline u8 llc_ui_header_len(struct sock *sk, struct sockaddr_llc *addr)
  *
  *	Send data via reliable llc2 connection.
  *	Returns 0 upon success, non-zero if action did not succeed.
+ *
+ *	This function always consumes a reference to the skb.
  */
 static int llc_ui_send_data(struct sock* sk, struct sk_buff *skb, int noblock)
 {
 	struct llc_sock* llc = llc_sk(sk);
-	int rc = 0;
 
 	if (unlikely(llc_data_accept_state(llc->state) ||
 		     llc->remote_busy_flag ||
 		     llc->p_flag)) {
 		long timeout = sock_sndtimeo(sk, noblock);
+		int rc;
 
 		rc = llc_ui_wait_for_busy_core(sk, timeout);
+		if (rc) {
+			kfree_skb(skb);
+			return rc;
+		}
 	}
-	if (unlikely(!rc))
-		rc = llc_build_and_send_pkt(sk, skb);
-	return rc;
+	return llc_build_and_send_pkt(sk, skb);
 }
 
 static void llc_ui_sk_init(struct socket *sock, struct sock *sk)
@@ -896,7 +900,7 @@ static int llc_ui_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	DECLARE_SOCKADDR(struct sockaddr_llc *, addr, msg->msg_name);
 	int flags = msg->msg_flags;
 	int noblock = flags & MSG_DONTWAIT;
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
 	size_t size = 0;
 	int rc = -EINVAL, copied = 0, hdrlen;
 
@@ -905,10 +909,10 @@ static int llc_ui_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	lock_sock(sk);
 	if (addr) {
 		if (msg->msg_namelen < sizeof(*addr))
-			goto release;
+			goto out;
 	} else {
 		if (llc_ui_addr_null(&llc->addr))
-			goto release;
+			goto out;
 		addr = &llc->addr;
 	}
 	/* must bind connection to sap if user hasn't done it. */
@@ -916,7 +920,7 @@ static int llc_ui_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		/* bind to sap with null dev, exclusive. */
 		rc = llc_ui_autobind(sock, addr);
 		if (rc)
-			goto release;
+			goto out;
 	}
 	hdrlen = llc->dev->hard_header_len + llc_ui_header_len(sk, addr);
 	size = hdrlen + len;
@@ -925,12 +929,12 @@ static int llc_ui_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	copied = size - hdrlen;
 	rc = -EINVAL;
 	if (copied < 0)
-		goto release;
+		goto out;
 	release_sock(sk);
 	skb = sock_alloc_send_skb(sk, size, noblock, &rc);
 	lock_sock(sk);
 	if (!skb)
-		goto release;
+		goto out;
 	skb->dev      = llc->dev;
 	skb->protocol = llc_proto_type(addr->sllc_arphrd);
 	skb_reserve(skb, hdrlen);
@@ -940,29 +944,31 @@ static int llc_ui_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	if (sk->sk_type == SOCK_DGRAM || addr->sllc_ua) {
 		llc_build_and_send_ui_pkt(llc->sap, skb, addr->sllc_mac,
 					  addr->sllc_sap);
+		skb = NULL;
 		goto out;
 	}
 	if (addr->sllc_test) {
 		llc_build_and_send_test_pkt(llc->sap, skb, addr->sllc_mac,
 					    addr->sllc_sap);
+		skb = NULL;
 		goto out;
 	}
 	if (addr->sllc_xid) {
 		llc_build_and_send_xid_pkt(llc->sap, skb, addr->sllc_mac,
 					   addr->sllc_sap);
+		skb = NULL;
 		goto out;
 	}
 	rc = -ENOPROTOOPT;
 	if (!(sk->sk_type == SOCK_STREAM && !addr->sllc_ua))
 		goto out;
 	rc = llc_ui_send_data(sk, skb, noblock);
+	skb = NULL;
 out:
-	if (rc) {
-		kfree_skb(skb);
-release:
+	kfree_skb(skb);
+	if (rc)
 		dprintk("%s: failed sending from %02X to %02X: %d\n",
 			__func__, llc->laddr.lsap, llc->daddr.lsap, rc);
-	}
 	release_sock(sk);
 	return rc ? : copied;
 }
diff --git a/net/llc/llc_conn.c b/net/llc/llc_conn.c
index d861b74ad068c..5d653f5261c55 100644
--- a/net/llc/llc_conn.c
+++ b/net/llc/llc_conn.c
@@ -55,6 +55,8 @@ int sysctl_llc2_busy_timeout = LLC2_BUSY_TIME * HZ;
  *	(executing it's actions and changing state), upper layer will be
  *	indicated or confirmed, if needed. Returns 0 for success, 1 for
  *	failure. The socket lock has to be held before calling this function.
+ *
+ *	This function always consumes a reference to the skb.
  */
 int llc_conn_state_process(struct sock *sk, struct sk_buff *skb)
 {
diff --git a/net/llc/llc_if.c b/net/llc/llc_if.c
index 6daf391b3e847..fc4d2bd8816f5 100644
--- a/net/llc/llc_if.c
+++ b/net/llc/llc_if.c
@@ -38,6 +38,8 @@
  *	closed and -EBUSY when sending data is not permitted in this state or
  *	LLC has send an I pdu with p bit set to 1 and is waiting for it's
  *	response.
+ *
+ *	This function always consumes a reference to the skb.
  */
 int llc_build_and_send_pkt(struct sock *sk, struct sk_buff *skb)
 {
@@ -46,20 +48,22 @@ int llc_build_and_send_pkt(struct sock *sk, struct sk_buff *skb)
 	struct llc_sock *llc = llc_sk(sk);
 
 	if (unlikely(llc->state == LLC_CONN_STATE_ADM))
-		goto out;
+		goto out_free;
 	rc = -EBUSY;
 	if (unlikely(llc_data_accept_state(llc->state) || /* data_conn_refuse */
 		     llc->p_flag)) {
 		llc->failed_data_req = 1;
-		goto out;
+		goto out_free;
 	}
 	ev = llc_conn_ev(skb);
 	ev->type      = LLC_CONN_EV_TYPE_PRIM;
 	ev->prim      = LLC_DATA_PRIM;
 	ev->prim_type = LLC_PRIM_TYPE_REQ;
 	skb->dev      = llc->dev;
-	rc = llc_conn_state_process(sk, skb);
-out:
+	return llc_conn_state_process(sk, skb);
+
+out_free:
+	kfree_skb(skb);
 	return rc;
 }
 
-- 
2.20.1



