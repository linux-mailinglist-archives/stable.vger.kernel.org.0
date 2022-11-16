Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7159662C98A
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 21:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiKPUGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 15:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbiKPUGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 15:06:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD87065873;
        Wed, 16 Nov 2022 12:06:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66E0DB81BF7;
        Wed, 16 Nov 2022 20:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D30CC433D6;
        Wed, 16 Nov 2022 20:06:04 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="oxQyELCE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1668629162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/ZQ1zlvLJF9Q7KMxrIh+EfNGNfjl2XLiuujpmH/eJ2Q=;
        b=oxQyELCE1CiwOjstbYKTYgsIMnyfOcQqpDpsSjvDYvzxVpsMYH4U+KjmwCRR5AQMmYr1f1
        Ru3CKRmn+9ZHuPYSGFXSPHRbxCR1ydTGsp4d3slIj7tWIFJ+oksRpwdqkbuduJlywXKTu5
        5vQDBTLU5MZB2qyKVHIUjWXUYYw8R7M=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id cfcff2b4 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 16 Nov 2022 20:06:01 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-efi@vger.kernel.org, ardb@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH] efi: random: zero out secret after use and do not take minimum
Date:   Wed, 16 Nov 2022 21:05:55 +0100
Message-Id: <20221116200555.2046552-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Taking the minimum is wrong, if the bootloader or EFI stub is actually
passing on a bunch of bytes that it expects the kernel to hash itself.
Ideally, a bootloader will hash it for us, but STUB won't do that, so we
should map all the bytes. Also, all those bytes must be zeroed out after
use to preserve forward secrecy.

Fixes: 161a438d730d ("efi: random: reduce seed size to 32 bytes")
Cc: stable@vger.kernel.org # v4.14+
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/firmware/efi/efi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index f73709f7589a..819409b7b43b 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -630,7 +630,7 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 
 		seed = early_memremap(efi_rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = min(seed->size, EFI_RANDOM_SEED_SIZE);
+			size = seed->size;
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
@@ -641,6 +641,7 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 			if (seed != NULL) {
 				pr_notice("seeding entropy pool\n");
 				add_bootloader_randomness(seed->bits, size);
+				memzero_explicit(seed->bits, size);
 				early_memunmap(seed, sizeof(*seed) + size);
 			} else {
 				pr_err("Could not map UEFI random seed!\n");
-- 
2.38.1

