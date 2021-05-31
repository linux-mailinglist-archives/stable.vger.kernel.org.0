Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C813960A1
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhEaOal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233195AbhEaO1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:27:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B773A61A33;
        Mon, 31 May 2021 13:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468829;
        bh=hCXrfYHR/s9m/pN/ieWCvVdVEhpJY0hz/QoMEBN18pY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbThuDVIjA+HmeoclPR2fAFWGPLYvByGD/VogFC5U35FcurSZjGHjmdLVCcQZRtsa
         F23F1UqslvgG++jJXqeUdrypGC2m3fgqOU3gr4DmUDYyp7LITGf9PhrCsWAy/r5aiK
         UyEiYyckjFJGJWnykXZwaSobhIvSS6AU40NWYJcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Ma <majinjing3@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 144/177] tls splice: check SPLICE_F_NONBLOCK instead of MSG_DONTWAIT
Date:   Mon, 31 May 2021 15:15:01 +0200
Message-Id: <20210531130652.912117996@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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
index 0d524ef0d8c8..cdb65aa54be7 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -37,6 +37,7 @@
 
 #include <linux/sched/signal.h>
 #include <linux/module.h>
+#include <linux/splice.h>
 #include <crypto/aead.h>
 
 #include <net/strparser.h>
@@ -1278,7 +1279,7 @@ int tls_sw_sendpage(struct sock *sk, struct page *page,
 }
 
 static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
-				     int flags, long timeo, int *err)
+				     bool nonblock, long timeo, int *err)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
@@ -1303,7 +1304,7 @@ static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
 		if (sock_flag(sk, SOCK_DONE))
 			return NULL;
 
-		if ((flags & MSG_DONTWAIT) || !timeo) {
+		if (nonblock || !timeo) {
 			*err = -EAGAIN;
 			return NULL;
 		}
@@ -1781,7 +1782,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		bool async_capable;
 		bool async = false;
 
-		skb = tls_wait_data(sk, psock, flags, timeo, &err);
+		skb = tls_wait_data(sk, psock, flags & MSG_DONTWAIT, timeo, &err);
 		if (!skb) {
 			if (psock) {
 				int ret = __tcp_bpf_recvmsg(sk, psock,
@@ -1985,9 +1986,9 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 
 	lock_sock(sk);
 
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+	timeo = sock_rcvtimeo(sk, flags & SPLICE_F_NONBLOCK);
 
-	skb = tls_wait_data(sk, NULL, flags, timeo, &err);
+	skb = tls_wait_data(sk, NULL, flags & SPLICE_F_NONBLOCK, timeo, &err);
 	if (!skb)
 		goto splice_read_end;
 
-- 
2.30.2



