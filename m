Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BE4395F2A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhEaOIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233157AbhEaOGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:06:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E26BB61458;
        Mon, 31 May 2021 13:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468337;
        bh=dPH8jfCynb71gmIZShaBaJy5/X+Me3+uHCk3gGdP82U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZ+qMPeu2dzWK3lWhE+cftPvVt/tyw98qjcKjCWF/faawR/FxNaTwRTJIa78835BC
         Hav9MexMnspr1V4a7BcHeLulbvo1Xk6eh5XncEWu7HEQr8ABmVgus0fa4SVRmTWZLH
         N/9tUWvMcideypjRvtN/q4dSCHT8SmKc1dnNYhW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Ma <majinjing3@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 206/252] tls splice: check SPLICE_F_NONBLOCK instead of MSG_DONTWAIT
Date:   Mon, 31 May 2021 15:14:31 +0200
Message-Id: <20210531130705.013320213@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Ma <majinjing3@gmail.com>

[ Upstream commit 974271e5ed45cfe4daddbeb16224a2156918530e ]

In tls_sw_splice_read, checkout MSG_* is inappropriate, should use
SPLICE_*, update tls_wait_data to accept nonblock arguments instead
of flags for recvmsg and splice.

Fixes: c46234ebb4d1 ("tls: RX path for ktls")
Signed-off-by: Jim Ma <majinjing3@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 845c628ac1b2..3abe5257f757 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -37,6 +37,7 @@
 
 #include <linux/sched/signal.h>
 #include <linux/module.h>
+#include <linux/splice.h>
 #include <crypto/aead.h>
 
 #include <net/strparser.h>
@@ -1282,7 +1283,7 @@ int tls_sw_sendpage(struct sock *sk, struct page *page,
 }
 
 static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
-				     int flags, long timeo, int *err)
+				     bool nonblock, long timeo, int *err)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
@@ -1307,7 +1308,7 @@ static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
 		if (sock_flag(sk, SOCK_DONE))
 			return NULL;
 
-		if ((flags & MSG_DONTWAIT) || !timeo) {
+		if (nonblock || !timeo) {
 			*err = -EAGAIN;
 			return NULL;
 		}
@@ -1787,7 +1788,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		bool async_capable;
 		bool async = false;
 
-		skb = tls_wait_data(sk, psock, flags, timeo, &err);
+		skb = tls_wait_data(sk, psock, flags & MSG_DONTWAIT, timeo, &err);
 		if (!skb) {
 			if (psock) {
 				int ret = __tcp_bpf_recvmsg(sk, psock,
@@ -1991,9 +1992,9 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 
 	lock_sock(sk);
 
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+	timeo = sock_rcvtimeo(sk, flags & SPLICE_F_NONBLOCK);
 
-	skb = tls_wait_data(sk, NULL, flags, timeo, &err);
+	skb = tls_wait_data(sk, NULL, flags & SPLICE_F_NONBLOCK, timeo, &err);
 	if (!skb)
 		goto splice_read_end;
 
-- 
2.30.2



