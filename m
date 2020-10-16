Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB21290186
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405818AbgJPJP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390131AbgJPJJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:09:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACD7A20878;
        Fri, 16 Oct 2020 09:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839333;
        bh=TELGC6cfu/rM5mOXC+Ob7K1VpYWyMe9eY6RM6o1LL/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dw7EptNiz/73lv3mBg25JyzO1HvSsPVjdRGNGyKAllsL9Etb2ODJx5GRIJQvZ8wYy
         3hYTtB4CkSDXAe6V+6uEna9HDMRxykGqULY1TwUtyrlR3FRF+bjVW7OlL/ilss5Hhp
         u1lcwxC3wGyCae2+2xq0ytouTZ7Yraq4Hnlo9t+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, =?UTF-8?q?kiyin ?= <kiyin@tencent.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 17/18] crypto: bcm - Verify GCM/CCM key length in setkey
Date:   Fri, 16 Oct 2020 11:07:27 +0200
Message-Id: <20201016090438.131874539@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.265805669@linuxfoundation.org>
References: <20201016090437.265805669@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 10a2f0b311094ffd45463a529a410a51ca025f27 upstream.

The setkey function for GCM/CCM algorithms didn't verify the key
length before copying the key and subtracting the salt length.

This patch delays the copying of the key til after the verification
has been done.  It also adds checks on the key length to ensure
that it's at least as long as the salt.

Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
Cc: <stable@vger.kernel.org>
Reported-by: kiyin(尹亮) <kiyin@tencent.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/bcm/cipher.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2981,7 +2981,6 @@ static int aead_gcm_ccm_setkey(struct cr
 
 	ctx->enckeylen = keylen;
 	ctx->authkeylen = 0;
-	memcpy(ctx->enckey, key, ctx->enckeylen);
 
 	switch (ctx->enckeylen) {
 	case AES_KEYSIZE_128:
@@ -2997,6 +2996,8 @@ static int aead_gcm_ccm_setkey(struct cr
 		goto badkey;
 	}
 
+	memcpy(ctx->enckey, key, ctx->enckeylen);
+
 	flow_log("  enckeylen:%u authkeylen:%u\n", ctx->enckeylen,
 		 ctx->authkeylen);
 	flow_dump("  enc: ", ctx->enckey, ctx->enckeylen);
@@ -3057,6 +3058,10 @@ static int aead_gcm_esp_setkey(struct cr
 	struct iproc_ctx_s *ctx = crypto_aead_ctx(cipher);
 
 	flow_log("%s\n", __func__);
+
+	if (keylen < GCM_ESP_SALT_SIZE)
+		return -EINVAL;
+
 	ctx->salt_len = GCM_ESP_SALT_SIZE;
 	ctx->salt_offset = GCM_ESP_SALT_OFFSET;
 	memcpy(ctx->salt, key + keylen - GCM_ESP_SALT_SIZE, GCM_ESP_SALT_SIZE);
@@ -3085,6 +3090,10 @@ static int rfc4543_gcm_esp_setkey(struct
 	struct iproc_ctx_s *ctx = crypto_aead_ctx(cipher);
 
 	flow_log("%s\n", __func__);
+
+	if (keylen < GCM_ESP_SALT_SIZE)
+		return -EINVAL;
+
 	ctx->salt_len = GCM_ESP_SALT_SIZE;
 	ctx->salt_offset = GCM_ESP_SALT_OFFSET;
 	memcpy(ctx->salt, key + keylen - GCM_ESP_SALT_SIZE, GCM_ESP_SALT_SIZE);
@@ -3114,6 +3123,10 @@ static int aead_ccm_esp_setkey(struct cr
 	struct iproc_ctx_s *ctx = crypto_aead_ctx(cipher);
 
 	flow_log("%s\n", __func__);
+
+	if (keylen < CCM_ESP_SALT_SIZE)
+		return -EINVAL;
+
 	ctx->salt_len = CCM_ESP_SALT_SIZE;
 	ctx->salt_offset = CCM_ESP_SALT_OFFSET;
 	memcpy(ctx->salt, key + keylen - CCM_ESP_SALT_SIZE, CCM_ESP_SALT_SIZE);


