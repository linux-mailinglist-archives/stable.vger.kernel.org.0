Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB6462140C
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbiKHN4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234817AbiKHN4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:56:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6596623A5
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:56:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 560B961515
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E53C433C1;
        Tue,  8 Nov 2022 13:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915807;
        bh=a+oZS8Qk8ClCr4S2cnwlG4KUf11RjR1Gpjw63P9dD1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKxcYVT7IodWXZah582kSQhYCzfRu8pRAcyhwa699HMagSsJ6OdIShiCAcrqfCb1X
         jv63jpFUpQ30FVcMAM3zPjWf15rZ/HhM875ydh047tFe5N3+NMtQIbFud20O37qCiV
         oIioF2+XlXHsxJWYIVGIudDSDXOvsCG4hhVHM+D0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH 5.10 097/118] efi: random: reduce seed size to 32 bytes
Date:   Tue,  8 Nov 2022 14:39:35 +0100
Message-Id: <20221108133344.899219323@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
actually happen, so READ_ONCE() is unnecessary here.

Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/efi.c |    2 +-
 include/linux/efi.h        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -590,7 +590,7 @@ int __init efi_config_parse_tables(const
 
 		seed = early_memremap(efi_rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = READ_ONCE(seed->size);
+			size = min(seed->size, EFI_RANDOM_SEED_SIZE);
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1161,7 +1161,7 @@ void efi_retrieve_tpm2_eventlog(void);
 	arch_efi_call_virt_teardown();					\
 })
 
-#define EFI_RANDOM_SEED_SIZE		64U
+#define EFI_RANDOM_SEED_SIZE		32U // BLAKE2S_HASH_SIZE
 
 struct linux_efi_random_seed {
 	u32	size;


