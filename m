Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838541F6730
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 13:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgFKLvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 07:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbgFKLvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 07:51:40 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72ABEC08C5C1
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 04:51:40 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id j1so2580439pfe.4
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 04:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cantona-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d9Q/bNkudx/YR8T/B5Qf2u+kTeExsliJmsxeBA26Blw=;
        b=JKGaHrcf2jc9qy+g5pQeMoevubkdV/zG02pyqPwKWK4rz/OUqyT2TOpF6FwZfNIpCe
         pHOm5C4qToDAzCmIyC8AhTRiJ4j63/UNOQ0KHMj1ZKZvOwoU2kyhiojEXcBrx/V9tWqV
         9+3SFthgS3XB98Ut8JWVVA9g9all0AXqyZd7Ny5n4cTyFEe/ONXF9RVCHLMgJCXAtmla
         HHVVbOpeWibgfQXq/ggZBDGO5vDss7N7IFok7Nt8c9VRCnpBRJ3BVoR2c6deicaoL5gq
         KbjF5ImxoCd8jf+P911IhCPmXNKFxcEb71las8aY/UPEfsQmm8112xoYw+k9ov9CqZ98
         KL9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d9Q/bNkudx/YR8T/B5Qf2u+kTeExsliJmsxeBA26Blw=;
        b=AQMv+PLSs3eGyUmnU5PgWhlqIM/Pyf8eAYTFQ97ao50k7aBwlUuPsiFM9p6j1bhtvu
         Y9QK/SDV8qTIhmAaN7SlitzjZU46lSFU7ovU6A+e5/MqYtOSEqjQm4BLJk2M66Vt33Sg
         SjCBf2+yUTlFBEKuS2+oeypUjPL+ntdvgGh+XN2l9GchZlvpLrTfUh4BEx0eQHtzZtPK
         clLdnOQMeUZPy2ocqxCTjuAR/kktfqbZ19sjMAougv5Z4fabfSlGAxf4Xw6chuB6oOYi
         w+8ciIhQbzziHV3aaxpr32aqtQEkudPqV/nToU5CiCi6fxl3aYt+WBXz6nqQw1BtyLTQ
         pD+g==
X-Gm-Message-State: AOAM5327a5XgRlyx/LctTuJSghHRGQgqHa4008ljeFa3JbD2nygb+AaO
        cuIj7yLKZrXooIdZO5JRsV46mg==
X-Google-Smtp-Source: ABdhPJz00MVpj1U5fsaTtfPOKDam7osjU7/Rl6iXaxC3mlR38BMRaavOXsHXIuqaNDWewtELx2LZCQ==
X-Received: by 2002:a62:6385:: with SMTP id x127mr6790482pfb.49.1591876299934;
        Thu, 11 Jun 2020 04:51:39 -0700 (PDT)
Received: from localhost.localdomain (059148043022.ctinets.com. [59.148.43.22])
        by smtp.googlemail.com with ESMTPSA id t186sm1511342pfc.39.2020.06.11.04.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 04:51:39 -0700 (PDT)
From:   Su Kang Yin <cantona@cantona.net>
To:     gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        christophe.leroy@c-s.fr, stable@vger.kernel.org
Cc:     Su Kang Yin <cantona@cantona.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2] crypto: talitos - fix ECB and CBC algs ivsize
Date:   Thu, 11 Jun 2020 19:50:47 +0800
Message-Id: <20200611115048.21677-1-cantona@cantona.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cantona@cantona.net>
References: <cantona@cantona.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e1de42fdfc6a ("crypto: talitos - fix ECB algs ivsize")
wrongly modified CBC algs ivsize instead of ECB aggs ivsize.

This restore the CBC algs original ivsize of removes ECB's ones.

Fixes: e1de42fdfc6a ("crypto: talitos - fix ECB algs ivsize")
Signed-off-by: Su Kang Yin <cantona@cantona.net>
---
Patch for 4.9 upstream.
---
 drivers/crypto/talitos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 8b383d3d21c2..059c2d4ad18f 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2631,17 +2631,16 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_name = "ecb(aes)",
 			.cra_driver_name = "ecb-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
 				     CRYPTO_ALG_ASYNC,
 			.cra_ablkcipher = {
 				.min_keysize = AES_MIN_KEY_SIZE,
 				.max_keysize = AES_MAX_KEY_SIZE,
-				.ivsize = AES_BLOCK_SIZE,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
 				     DESC_HDR_SEL0_AESU,
 	},
 	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.alg.crypto = {
 			.cra_name = "cbc(aes)",
@@ -2665,16 +2664,17 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_name = "ctr(aes)",
 			.cra_driver_name = "ctr-aes-talitos",
 			.cra_blocksize = 1,
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
 				     CRYPTO_ALG_ASYNC,
 			.cra_ablkcipher = {
 				.min_keysize = AES_MIN_KEY_SIZE,
 				.max_keysize = AES_MAX_KEY_SIZE,
+				.ivsize = AES_BLOCK_SIZE,
 				.setkey = ablkcipher_aes_setkey,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_AESU_CTR_NONSNOOP |
 				     DESC_HDR_SEL0_AESU |
 				     DESC_HDR_MODE0_AESU_CTR,
 	},
 	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-- 
2.21.0

