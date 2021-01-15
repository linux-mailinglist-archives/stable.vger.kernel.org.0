Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A162F7A0F
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733236AbhAOMiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:38:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388150AbhAOMiT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:38:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 722A1221F7;
        Fri, 15 Jan 2021 12:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714283;
        bh=E9yV9H5V0DohqWW+sryS238VRVXE6o6G4E9pDVgrqZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OY2c+twudyHbIF68Ge3a5wa9UESyPJdmaExYtxn0ks6h9sjbAZdcgOl/IugEvTpK3
         Hemvxx5cp07yizDnGeqj+wmqfEFpZwxitxO3FemO660ap0z9zlsNxbSi/PlstB/Yss
         UldJHkH0CQ4i2lSlqXBULSZTcRflXLTF0w30RXx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 035/103] chtls: Fix chtls resources release sequence
Date:   Fri, 15 Jan 2021 13:27:28 +0100
Message-Id: <20210115122007.758041210@linuxfoundation.org>
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
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -2057,9 +2057,9 @@ static void bl_abort_syn_rcv(struct sock
 	queue = csk->txq_idx;
 
 	skb->sk	= NULL;
-	do_abort_syn_rcv(child, lsk);
 	chtls_send_abort_rpl(child, skb, BLOG_SKB_CB(skb)->cdev,
 			     CPL_ABORT_NO_RST, queue);
+	do_abort_syn_rcv(child, lsk);
 }
 
 static int abort_syn_rcv(struct sock *sk, struct sk_buff *skb)
@@ -2089,8 +2089,8 @@ static int abort_syn_rcv(struct sock *sk
 	if (!sock_owned_by_user(psk)) {
 		int queue = csk->txq_idx;
 
-		do_abort_syn_rcv(sk, psk);
 		chtls_send_abort_rpl(sk, skb, cdev, CPL_ABORT_NO_RST, queue);
+		do_abort_syn_rcv(sk, psk);
 	} else {
 		skb->sk = sk;
 		BLOG_SKB_CB(skb)->backlog_rcv = bl_abort_syn_rcv;
@@ -2134,12 +2134,12 @@ static void chtls_abort_req_rss(struct s
 		if (sk->sk_state == TCP_SYN_RECV && !abort_syn_rcv(sk, skb))
 			return;
 
-		chtls_release_resources(sk);
-		chtls_conn_done(sk);
 	}
 
 	chtls_send_abort_rpl(sk, skb, BLOG_SKB_CB(skb)->cdev,
 			     rst_status, queue);
+	chtls_release_resources(sk);
+	chtls_conn_done(sk);
 }
 
 static void chtls_abort_rpl_rss(struct sock *sk, struct sk_buff *skb)


