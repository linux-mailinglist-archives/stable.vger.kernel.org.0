Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320DE62CFD1
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 01:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiKQAj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 19:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiKQAj0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 19:39:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DE25E3C7;
        Wed, 16 Nov 2022 16:39:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68E8C62058;
        Thu, 17 Nov 2022 00:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E1FC433D6;
        Thu, 17 Nov 2022 00:39:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="OONheRID"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1668645562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+pE/PDpqUGWm9YPw3i5SbJNyth4UL2h68LUIQrGryCE=;
        b=OONheRIDgpqYGbe4JgymzvfpkCwtkCRPlc3qWKOXmmygXcg9iixQt6/RHkN6Z5Cs7mASiI
        TuaGV0fgap+CivkR87p9BnjR+m3gQ42jT2/X+EByJ0LMvT6W5iTsj3+f/DQbGzwLx0n+jH
        5OqXKK8DkLkJ4is+X48K3GXWo98a+rI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1bff5b32 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 17 Nov 2022 00:39:22 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-efi@vger.kernel.org, ardb@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH v2] efi: random: zero out secret after use and do not take minimum
Date:   Thu, 17 Nov 2022 01:39:15 +0100
Message-Id: <20221117003915.2092851-1-Jason@zx2c4.com>
In-Reply-To: <Y3WA2BU0vtsOu6pJ@zx2c4.com>
References: <Y3WA2BU0vtsOu6pJ@zx2c4.com>
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
Changes v1->v2:
- Cap size to 1k.
 drivers/firmware/efi/efi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index a46df5d1d094..c7c7178902c2 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -611,7 +611,7 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 
 		seed = early_memremap(efi_rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = min(seed->size, EFI_RANDOM_SEED_SIZE);
+			size = min_t(u32, SZ_1K, seed->size);
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
@@ -622,6 +622,7 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 			if (seed != NULL) {
 				pr_notice("seeding entropy pool\n");
 				add_bootloader_randomness(seed->bits, size);
+				memzero_explicit(seed->bits, size);
 				early_memunmap(seed, sizeof(*seed) + size);
 			} else {
 				pr_err("Could not map UEFI random seed!\n");
-- 
2.38.1

