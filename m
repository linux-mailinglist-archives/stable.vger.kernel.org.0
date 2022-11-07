Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE5661F7BF
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbiKGPfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiKGPfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:35:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E3EC35
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 07:35:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DC706090B
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 15:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEE1C433D6;
        Mon,  7 Nov 2022 15:35:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GOCo5F0W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667835300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mExtcoYhJMoCLqx21YbsynviZd1Yl09W55tzkj9rMB8=;
        b=GOCo5F0W7TlWmQSsybgGMs940AKPQQ6P04y7LiusWoWdEhILeZWEnAkgxBe1xdlPMRS/ee
        y5Iv8r3NNOt1KX9JWORrDoHg6/buk17D4XFYqfBhe3pl/4wKd7Sq1kh9VUFegttYpR/VDf
        ekgJblM87WTW1yolCNUOIPe4eSAa3Mg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fcb65fcf (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 7 Nov 2022 15:34:59 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     gregkh@linuxfoundation.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH 4.19.y] efi: random: reduce seed size to 32 bytes
Date:   Mon,  7 Nov 2022 16:34:44 +0100
Message-Id: <20221107153444.21657-1-Jason@zx2c4.com>
In-Reply-To: <1667834910140236@kroah.com>
References: <1667834910140236@kroah.com>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit 161a438d730dade2ba2b1bf8785f0759aba4ca5f upstream.

We no longer need at least 64 bytes of random seed to permit the early
crng init to complete. The RNG is now based on Blake2s, so reduce the
EFI seed size to the Blake2s hash size, which is sufficient for our
purposes.

While at it, drop the READ_ONCE(), which was supposed to prevent size
from being evaluated after seed was unmapped. However, this cannot
actually happen, so READ_ONCE() is unnecessary here. [stable:
READ_ONCE() wasn't backported in the first place.]

Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/firmware/efi/efi.c | 2 +-
 include/linux/efi.h        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 7098744f9276..f0ef2643b70e 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -556,7 +556,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 
 		seed = early_memremap(efi.rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = seed->size;
+			size = min(seed->size, EFI_RANDOM_SEED_SIZE);
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ec89e8bcc92f..789a194e18a4 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1655,7 +1655,7 @@ efi_status_t efi_exit_boot_services(efi_system_table_t *sys_table,
 				    void *priv,
 				    efi_exit_boot_map_processing priv_func);
 
-#define EFI_RANDOM_SEED_SIZE		64U
+#define EFI_RANDOM_SEED_SIZE		32U // BLAKE2S_HASH_SIZE
 
 struct linux_efi_random_seed {
 	u32	size;
-- 
2.38.1

