Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A2B2F794A
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731797AbhAOMeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:34:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:41120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387494AbhAOMea (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:34:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19D192339D;
        Fri, 15 Jan 2021 12:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714054;
        bh=wArVPqu7u4jdsB9XswA5aIzFktyXZOVFPjwD+o/DLG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PaJxwOf0vP4JW3IyCqeTeWbR1mtmnr8R/iDz9eWs9ZbwtpY9rf+rZHwl0MGGzLEI5
         RyROwzNNZXZCOzpub4OC5tYT5z+TD9/a1BN1iBuwh6KoNPKd1AdqJCTUlwBfG4ECED
         7ryQSNnnc50n3Kcy/FObySKi7uURza30ZiabI27g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 26/62] chtls: Fix chtls resources release sequence
Date:   Fri, 15 Jan 2021 13:27:48 +0100
Message-Id: <20210115121959.667437476@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

[ Upstream commit 15ef6b0e30b354253e2c10b3836bc59767eb162b ]

CPL_ABORT_RPL is sent after releasing the resources by calling
chtls_release_resources(sk); and chtls_conn_done(sk);
eventually causing kernel panic. Fixing it by calling release
in appropriate order.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1905,9 +1905,9 @@ static void bl_abort_syn_rcv(struct sock
 	queue = csk->txq_idx;
 
 	skb->sk	= NULL;
-	do_abort_syn_rcv(child, lsk);
 	chtls_send_abort_rpl(child, skb, BLOG_SKB_CB(skb)->cdev,
 			     CPL_ABORT_NO_RST, queue);
+	do_abort_syn_rcv(child, lsk);
 }
 
 static int abort_syn_rcv(struct sock *sk, struct sk_buff *skb)
@@ -1937,8 +1937,8 @@ static int abort_syn_rcv(struct sock *sk
 	if (!sock_owned_by_user(psk)) {
 		int queue = csk->txq_idx;
 
-		do_abort_syn_rcv(sk, psk);
 		chtls_send_abort_rpl(sk, skb, cdev, CPL_ABORT_NO_RST, queue);
+		do_abort_syn_rcv(sk, psk);
 	} else {
 		skb->sk = sk;
 		BLOG_SKB_CB(skb)->backlog_rcv = bl_abort_syn_rcv;
@@ -1981,12 +1981,11 @@ static void chtls_abort_req_rss(struct s
 
 		if (sk->sk_state == TCP_SYN_RECV && !abort_syn_rcv(sk, skb))
 			return;
-
-		chtls_release_resources(sk);
-		chtls_conn_done(sk);
 	}
 
 	chtls_send_abort_rpl(sk, skb, csk->cdev, rst_status, queue);
+	chtls_release_resources(sk);
+	chtls_conn_done(sk);
 }
 
 static void chtls_abort_rpl_rss(struct sock *sk, struct sk_buff *skb)


