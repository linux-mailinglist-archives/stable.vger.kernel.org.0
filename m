Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451E84624FC
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhK2Wdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbhK2WdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:33:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9CDC07E5F3;
        Mon, 29 Nov 2021 10:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1694B815CC;
        Mon, 29 Nov 2021 18:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C94C53FAD;
        Mon, 29 Nov 2021 18:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211216;
        bh=dDkI2zj3bBh1yrIAXEy608BKOxsow0pb+LG3yHfQsc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8I6JYWC4ue1jVXG8rSUSfU29IzQfblDM/JWMWCKz0YmydNle7sfpC/OaLaA0nF/+
         gWL96Qfjb9vVr/qz5Uq+EcfN6EjugRiGr8SDgc/CcJ8m/znZQYTeSCqb/OHo8dzZwP
         iTtTsaMLnLlE/IBCQ25JdTrmqmnHqY4zOQL3pvZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/179] tls: splice_read: fix accessing pre-processed records
Date:   Mon, 29 Nov 2021 19:18:58 +0100
Message-Id: <20211129181723.688074423@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e062fe99cccd9ff9f232e593d163ecabd244fae8 ]

recvmsg() will put peek()ed and partially read records onto the rx_list.
splice_read() needs to consult that list otherwise it may miss data.
Align with recvmsg() and also put partially-read records onto rx_list.
tls_sw_advance_skb() is pretty pointless now and will be removed in
net-next.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 1715e793c04ba..b0cdcea101806 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1993,6 +1993,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	ssize_t copied = 0;
+	bool from_queue;
 	int err = 0;
 	long timeo;
 	int chunk;
@@ -2002,14 +2003,20 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 
 	timeo = sock_rcvtimeo(sk, flags & SPLICE_F_NONBLOCK);
 
-	skb = tls_wait_data(sk, NULL, flags & SPLICE_F_NONBLOCK, timeo, &err);
-	if (!skb)
-		goto splice_read_end;
+	from_queue = !skb_queue_empty(&ctx->rx_list);
+	if (from_queue) {
+		skb = __skb_dequeue(&ctx->rx_list);
+	} else {
+		skb = tls_wait_data(sk, NULL, flags & SPLICE_F_NONBLOCK, timeo,
+				    &err);
+		if (!skb)
+			goto splice_read_end;
 
-	err = decrypt_skb_update(sk, skb, NULL, &chunk, &zc, false);
-	if (err < 0) {
-		tls_err_abort(sk, -EBADMSG);
-		goto splice_read_end;
+		err = decrypt_skb_update(sk, skb, NULL, &chunk, &zc, false);
+		if (err < 0) {
+			tls_err_abort(sk, -EBADMSG);
+			goto splice_read_end;
+		}
 	}
 
 	/* splice does not support reading control messages */
@@ -2025,7 +2032,17 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	if (copied < 0)
 		goto splice_read_end;
 
-	tls_sw_advance_skb(sk, skb, copied);
+	if (!from_queue) {
+		ctx->recv_pkt = NULL;
+		__strp_unpause(&ctx->strp);
+	}
+	if (chunk < rxm->full_len) {
+		__skb_queue_head(&ctx->rx_list, skb);
+		rxm->offset += len;
+		rxm->full_len -= len;
+	} else {
+		consume_skb(skb);
+	}
 
 splice_read_end:
 	release_sock(sk);
-- 
2.33.0



