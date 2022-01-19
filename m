Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD30F4931AB
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 01:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346757AbiASAO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 19:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238348AbiASAO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 19:14:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B04EC061574;
        Tue, 18 Jan 2022 16:14:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 163E061489;
        Wed, 19 Jan 2022 00:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE91C340E1;
        Wed, 19 Jan 2022 00:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642551295;
        bh=SsyiJsyKHLG9jWlDR0kR8q+NK2KWbgrDYm6dQJO1vt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJGKbyZB/KRECA3IgjPEJHLsCLYTuKaM3ImJziIV70OUCC3e8PufLRKWmM/gTTaoo
         1r+wlbOfwunPV1kQCyX9nbiuT3f3IBi7o5Us4bghywJSAQdtLRQ4ZwVLMxdOQzNuu/
         IOrTnRTYcoytePCAFfR516cVSF6+EASlRSEKsgyAzwGTELpheeVlnmTH2fbMiB+UiZ
         n6d3cOZz4LXAeIQuwP4i8A4yaH5hDGLPRby3HMDlbmhZ7MX6weyNFTDaWtXBSeoKCY
         optd4QzVx1ZyU6QdOM0Ye1+fMnFke8x5m/QVHt27kqvGG+22Ha57elpCQFyNuTiikg
         gqHTfCm3dUS4g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     keyrings@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Denis Kenzior <denkenz@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/5] crypto: rsa-pkcs1pad - only allow with rsa
Date:   Tue, 18 Jan 2022 16:13:02 -0800
Message-Id: <20220119001306.85355-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119001306.85355-1-ebiggers@kernel.org>
References: <20220119001306.85355-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The pkcs1pad template can be instantiated with an arbitrary akcipher
algorithm, which doesn't make sense; it is specifically an RSA padding
scheme.  Make it check that the underlying algorithm really is RSA.

Fixes: 3d5b1ecdea6f ("crypto: rsa - RSA padding algorithm")
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/rsa-pkcs1pad.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 8ac3e73e8ea65..1b35457814258 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -621,6 +621,11 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	rsa_alg = crypto_spawn_akcipher_alg(&ctx->spawn);
 
+	if (strcmp(rsa_alg->base.cra_name, "rsa") != 0) {
+		err = -EINVAL;
+		goto err_free_inst;
+	}
+
 	err = -ENAMETOOLONG;
 	hash_name = crypto_attr_alg_name(tb[2]);
 	if (IS_ERR(hash_name)) {
-- 
2.34.1

