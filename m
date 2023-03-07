Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E2F6AEE41
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbjCGSKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjCGSKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630CFC666
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:05:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BE94B819BC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A357C433D2;
        Tue,  7 Mar 2023 18:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212300;
        bh=3DwLHOYp38wdLyy+Ft282z31473iRxPK0HdVsTsI04U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+EpMxRYwIpop+1Jyxec645RLudcjIrPsm+4hy8wvL5F6LSpc1LriQFmICNSPAhIF
         vmIYqDBjPbbtSRXtuOaZVmD5TaWdowwHQ9ze1cdscyF3T7JTFOHXscmutVkKFazpVP
         7DebBTo+o260AAVoTuT3G02G3KguzQCcI7ExAeL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/885] crypto: x86/ghash - fix unaligned access in ghash_setkey()
Date:   Tue,  7 Mar 2023 17:51:14 +0100
Message-Id: <20230307170007.937934874@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 116db2704c193fff6d73ea6c2219625f0c9bdfc8 ]

The key can be unaligned, so use the unaligned memory access helpers.

Fixes: 8ceee72808d1 ("crypto: ghash-clmulni-intel - use C implementation for setkey()")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/ghash-clmulni-intel_glue.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 1f1a95f3dd0ca..c0ab0ff4af655 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -19,6 +19,7 @@
 #include <crypto/internal/simd.h>
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
+#include <asm/unaligned.h>
 
 #define GHASH_BLOCK_SIZE	16
 #define GHASH_DIGEST_SIZE	16
@@ -54,15 +55,14 @@ static int ghash_setkey(struct crypto_shash *tfm,
 			const u8 *key, unsigned int keylen)
 {
 	struct ghash_ctx *ctx = crypto_shash_ctx(tfm);
-	be128 *x = (be128 *)key;
 	u64 a, b;
 
 	if (keylen != GHASH_BLOCK_SIZE)
 		return -EINVAL;
 
 	/* perform multiplication by 'x' in GF(2^128) */
-	a = be64_to_cpu(x->a);
-	b = be64_to_cpu(x->b);
+	a = get_unaligned_be64(key);
+	b = get_unaligned_be64(key + 8);
 
 	ctx->shash.a = (b << 1) | (a >> 63);
 	ctx->shash.b = (a << 1) | (b >> 63);
-- 
2.39.2



