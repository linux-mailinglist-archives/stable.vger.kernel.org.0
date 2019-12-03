Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E45111BEC
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfLCWid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:38:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728017AbfLCWic (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:38:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FB5820684;
        Tue,  3 Dec 2019 22:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412711;
        bh=L1VuuR2aHnGuXPFOaUKF5kxM3+Aapq+94Dmtx7408LA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hadJVSH5fjb94Hecd9eiBXrfbndaEkHDSVCyzwYYPQyV2tjxfZN04AN0dvYvQazOo
         5FUvNBoyDp8N1k3tfS18bVBV5Yfat8idNPE0jyLkb5Kz0N9/YKSPrFFiMDlf9Hua1E
         955GRSox5UjicRFFIl9WVbyTvQzj+B65m20YunHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 34/46] net/tls: use sg_next() to walk sg entries
Date:   Tue,  3 Dec 2019 23:35:54 +0100
Message-Id: <20191203212754.733031040@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203212705.175425505@linuxfoundation.org>
References: <20191203212705.175425505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit c5daa6cccdc2f94aca2c9b3fa5f94e4469997293 ]

Partially sent record cleanup path increments an SG entry
directly instead of using sg_next(). This should not be a
problem today, as encrypted messages should be always
allocated as arrays. But given this is a cleanup path it's
easy to miss was this ever to change. Use sg_next(), and
simplify the code.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tls.h  |    2 +-
 net/tls/tls_main.c |   13 ++-----------
 net/tls/tls_sw.c   |    3 ++-
 3 files changed, 5 insertions(+), 13 deletions(-)

--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -395,7 +395,7 @@ int tls_push_sg(struct sock *sk, struct
 		int flags);
 int tls_push_partial_record(struct sock *sk, struct tls_context *ctx,
 			    int flags);
-bool tls_free_partial_record(struct sock *sk, struct tls_context *ctx);
+void tls_free_partial_record(struct sock *sk, struct tls_context *ctx);
 
 static inline struct tls_msg *tls_msg(struct sk_buff *skb)
 {
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -209,24 +209,15 @@ int tls_push_partial_record(struct sock
 	return tls_push_sg(sk, ctx, sg, offset, flags);
 }
 
-bool tls_free_partial_record(struct sock *sk, struct tls_context *ctx)
+void tls_free_partial_record(struct sock *sk, struct tls_context *ctx)
 {
 	struct scatterlist *sg;
 
-	sg = ctx->partially_sent_record;
-	if (!sg)
-		return false;
-
-	while (1) {
+	for (sg = ctx->partially_sent_record; sg; sg = sg_next(sg)) {
 		put_page(sg_page(sg));
 		sk_mem_uncharge(sk, sg->length);
-
-		if (sg_is_last(sg))
-			break;
-		sg++;
 	}
 	ctx->partially_sent_record = NULL;
-	return true;
 }
 
 static void tls_write_space(struct sock *sk)
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2084,7 +2084,8 @@ void tls_sw_release_resources_tx(struct
 	/* Free up un-sent records in tx_list. First, free
 	 * the partially sent record if any at head of tx_list.
 	 */
-	if (tls_free_partial_record(sk, tls_ctx)) {
+	if (tls_ctx->partially_sent_record) {
+		tls_free_partial_record(sk, tls_ctx);
 		rec = list_first_entry(&ctx->tx_list,
 				       struct tls_rec, list);
 		list_del(&rec->list);


