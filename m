Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0FB31A4FA8
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgDKMKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgDKMKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:10:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBB982084D;
        Sat, 11 Apr 2020 12:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607034;
        bh=j6WLdnM+vDOgzwjNOl0Wp0iHgW1fh1z8mov5TytIjm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvdZHsnOIG7r++4ZEnB8OFujMz997/YIQwaQHJhNV3HjyjuXDGHqimkH475WGaB9K
         VJaWwOXuMHKzAPZC9N5E7gH5KE0pq3PMSwj87oUzPR7XsoKKKyy7Qo4m4rerBFsUJk
         GMC8dUwet4gtOSl9SpK0KPJeKtQo9eiHspJ4mRy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gao Feng <fgao@ikuai8.com>,
        Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.4 10/29] l2tp: Refactor the codes with existing macros instead of literal number
Date:   Sat, 11 Apr 2020 14:08:40 +0200
Message-Id: <20200411115409.384010341@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115407.651296755@linuxfoundation.org>
References: <20200411115407.651296755@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Feng <fgao@ikuai8.com>

commit 54c151d9ed1321e6e623c80ffe42cd2eb1571744 upstream.

Use PPP_ALLSTATIONS, PPP_UI, and SEND_SHUTDOWN instead of 0xff,
0x03, and 2 separately.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
Acked-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ppp.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -177,7 +177,7 @@ static int pppol2tp_recv_payload_hook(st
 	if (!pskb_may_pull(skb, 2))
 		return 1;
 
-	if ((skb->data[0] == 0xff) && (skb->data[1] == 0x03))
+	if ((skb->data[0] == PPP_ALLSTATIONS) && (skb->data[1] == PPP_UI))
 		skb_pull(skb, 2);
 
 	return 0;
@@ -297,7 +297,6 @@ static void pppol2tp_session_sock_put(st
 static int pppol2tp_sendmsg(struct socket *sock, struct msghdr *m,
 			    size_t total_len)
 {
-	static const unsigned char ppph[2] = { 0xff, 0x03 };
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	int error;
@@ -327,7 +326,7 @@ static int pppol2tp_sendmsg(struct socke
 	error = -ENOMEM;
 	skb = sock_wmalloc(sk, NET_SKB_PAD + sizeof(struct iphdr) +
 			   uhlen + session->hdr_len +
-			   sizeof(ppph) + total_len,
+			   2 + total_len, /* 2 bytes for PPP_ALLSTATIONS & PPP_UI */
 			   0, GFP_KERNEL);
 	if (!skb)
 		goto error_put_sess_tun;
@@ -340,8 +339,8 @@ static int pppol2tp_sendmsg(struct socke
 	skb_reserve(skb, uhlen);
 
 	/* Add PPP header */
-	skb->data[0] = ppph[0];
-	skb->data[1] = ppph[1];
+	skb->data[0] = PPP_ALLSTATIONS;
+	skb->data[1] = PPP_UI;
 	skb_put(skb, 2);
 
 	/* Copy user data into skb */
@@ -384,7 +383,6 @@ error:
  */
 static int pppol2tp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 {
-	static const u8 ppph[2] = { 0xff, 0x03 };
 	struct sock *sk = (struct sock *) chan->private;
 	struct sock *sk_tun;
 	struct l2tp_session *session;
@@ -413,14 +411,14 @@ static int pppol2tp_xmit(struct ppp_chan
 		   sizeof(struct iphdr) + /* IP header */
 		   uhlen +		/* UDP header (if L2TP_ENCAPTYPE_UDP) */
 		   session->hdr_len +	/* L2TP header */
-		   sizeof(ppph);	/* PPP header */
+		   2;			/* 2 bytes for PPP_ALLSTATIONS & PPP_UI */
 	if (skb_cow_head(skb, headroom))
 		goto abort_put_sess_tun;
 
 	/* Setup PPP header */
-	__skb_push(skb, sizeof(ppph));
-	skb->data[0] = ppph[0];
-	skb->data[1] = ppph[1];
+	__skb_push(skb, 2);
+	skb->data[0] = PPP_ALLSTATIONS;
+	skb->data[1] = PPP_UI;
 
 	local_bh_disable();
 	l2tp_xmit_skb(session, skb, session->hdr_len);
@@ -455,7 +453,7 @@ static void pppol2tp_session_close(struc
 	BUG_ON(session->magic != L2TP_SESSION_MAGIC);
 
 	if (sock) {
-		inet_shutdown(sock, 2);
+		inet_shutdown(sock, SEND_SHUTDOWN);
 		/* Don't let the session go away before our socket does */
 		l2tp_session_inc_refcount(session);
 	}


