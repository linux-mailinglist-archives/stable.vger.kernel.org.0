Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A713139626B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhEaO40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232626AbhEaOyC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:54:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F4DD61CAC;
        Mon, 31 May 2021 13:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469555;
        bh=kEqZaRDMA6nbc5KtPc99Zqt3YTBcosbI8H0fk5s158A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOETWC48/LX2zlr2AI88OPcyood/tdLfr504mzM7YVx1TXQnwIjY1wbqO5bqJ4g/V
         HHHrX0kEHMoP4xKnV19ckIyeb4znqPaFBRWq5qlHcThZ/bCdLRmnpOpO2znrMX9aqG
         4PyI2z2M9kwN9mCZgSC+zHOjssuvhw5z/vJy8Jnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Ma <majinjing3@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 241/296] tls splice: check SPLICE_F_NONBLOCK instead of MSG_DONTWAIT
Date:   Mon, 31 May 2021 15:14:56 +0200
Message-Id: <20210531130711.896742931@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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
index 01d933ae5f16..6086cf4f10a7 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -37,6 +37,7 @@
 
 #include <linux/sched/signal.h>
 #include <linux/module.h>
+#include <linux/splice.h>
 #include <crypto/aead.h>
 
 #include <net/strparser.h>
@@ -1281,7 +1282,7 @@ int tls_sw_sendpage(struct sock *sk, struct page *page,
 }
 
 static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
-				     int flags, long timeo, int *err)
+				     bool nonblock, long timeo, int *err)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
@@ -1306,7 +1307,7 @@ static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
 		if (sock_flag(sk, SOCK_DONE))
 			return NULL;
 
-		if ((flags & MSG_DONTWAIT) || !timeo) {
+		if (nonblock || !timeo) {
 			*err = -EAGAIN;
 			return NULL;
 		}
@@ -1786,7 +1787,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		bool async_capable;
 		bool async = false;
 
-		skb = tls_wait_data(sk, psock, flags, timeo, &err);
+		skb = tls_wait_data(sk, psock, flags & MSG_DONTWAIT, timeo, &err);
 		if (!skb) {
 			if (psock) {
 				int ret = __tcp_bpf_recvmsg(sk, psock,
@@ -1990,9 +1991,9 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 
 	lock_sock(sk);
 
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+	timeo = sock_rcvtimeo(sk, flags & SPLICE_F_NONBLOCK);
 
-	skb = tls_wait_data(sk, NULL, flags, timeo, &err);
+	skb = tls_wait_data(sk, NULL, flags & SPLICE_F_NONBLOCK, timeo, &err);
 	if (!skb)
 		goto splice_read_end;
 
-- 
2.30.2



