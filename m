Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7EB019C81B
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 19:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390052AbgDBRdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 13:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390035AbgDBRdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 13:33:09 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63FCB2078B;
        Thu,  2 Apr 2020 17:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585848787;
        bh=xFeRDbN2a95z8dOx3Yw7IxgeW9E7HAdR3W5kLcO7yiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWf52ruKxrYtqs74aKsmpaftse3RRFbTBcKV34jI7HGR2Vig86TKZMHxOwfPjf/u9
         Yy9HzSOpsy34CqQQBQHiSIZLwkq/qX8RpbhxqvfJenHg7slL0Fvd1i9GYlHS5aXnHi
         ul0ZCn/ducKVPvMfBfjgzVivc+Mrs+hlQQ4NUSpA=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, g.nault@alphalink.fr,
        Gao Feng <fgao@ikuai8.com>,
        "David S . Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 6/8] l2tp: Refactor the codes with existing macros instead of literal number
Date:   Thu,  2 Apr 2020 18:32:48 +0100
Message-Id: <20200402173250.7858-7-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200402173250.7858-1-will@kernel.org>
References: <20200402173250.7858-1-will@kernel.org>
MIME-Version: 1.0
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
---
 net/l2tp/l2tp_ppp.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 97155145c0c5..98d4fa47b6a5 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -177,7 +177,7 @@ static int pppol2tp_recv_payload_hook(struct sk_buff *skb)
 	if (!pskb_may_pull(skb, 2))
 		return 1;
 
-	if ((skb->data[0] == 0xff) && (skb->data[1] == 0x03))
+	if ((skb->data[0] == PPP_ALLSTATIONS) && (skb->data[1] == PPP_UI))
 		skb_pull(skb, 2);
 
 	return 0;
@@ -297,7 +297,6 @@ static void pppol2tp_session_sock_put(struct l2tp_session *session)
 static int pppol2tp_sendmsg(struct socket *sock, struct msghdr *m,
 			    size_t total_len)
 {
-	static const unsigned char ppph[2] = { 0xff, 0x03 };
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	int error;
@@ -327,7 +326,7 @@ static int pppol2tp_sendmsg(struct socket *sock, struct msghdr *m,
 	error = -ENOMEM;
 	skb = sock_wmalloc(sk, NET_SKB_PAD + sizeof(struct iphdr) +
 			   uhlen + session->hdr_len +
-			   sizeof(ppph) + total_len,
+			   2 + total_len, /* 2 bytes for PPP_ALLSTATIONS & PPP_UI */
 			   0, GFP_KERNEL);
 	if (!skb)
 		goto error_put_sess_tun;
@@ -340,8 +339,8 @@ static int pppol2tp_sendmsg(struct socket *sock, struct msghdr *m,
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
@@ -413,14 +411,14 @@ static int pppol2tp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
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
@@ -455,7 +453,7 @@ static void pppol2tp_session_close(struct l2tp_session *session)
 	BUG_ON(session->magic != L2TP_SESSION_MAGIC);
 
 	if (sock) {
-		inet_shutdown(sock, 2);
+		inet_shutdown(sock, SEND_SHUTDOWN);
 		/* Don't let the session go away before our socket does */
 		l2tp_session_inc_refcount(session);
 	}
-- 
2.26.0.rc2.310.g2932bb562d-goog

