Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1936649B3
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239314AbjAJSX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239144AbjAJSXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:23:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F34810FD5
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:21:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38FD461865
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D24C433D2;
        Tue, 10 Jan 2023 18:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374862;
        bh=Ct/bgKycpYWxzxoDdzyIIYlq2VcDmnixPsOH4PVJ/xA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ky/kn8iVwFgEc0KHlVqxD9OdfHkIjL5c/5dH7HrQm19KvseoT5NtMzfpZFaRqkZzo
         Fomkqokw8HbgtNIiiPZAROa4dXkqXmC4Al9P8ArbaZsEtGVMS9H2Zt/PptGJyEDaVx
         NqB2tBzw5Sm/ONjA3FVJQ9p+o9J0TAXEwCxSwjHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 158/159] efi: random: combine bootloader provided RNG seed with RNG protocol output
Date:   Tue, 10 Jan 2023 19:05:06 +0100
Message-Id: <20230110180023.619459181@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

commit 196dff2712ca5a2e651977bb2fe6b05474111a83 upstream.

Instead of blindly creating the EFI random seed configuration table if
the RNG protocol is implemented and works, check whether such a EFI
configuration table was provided by an earlier boot stage and if so,
concatenate the existing and the new seeds, leaving it up to the core
code to mix it in and credit it the way it sees fit.

This can be used for, e.g., systemd-boot, to pass an additional seed to
Linux in a way that can be consumed by the kernel very early. In that
case, the following definitions should be used to pass the seed to the
EFI stub:

struct linux_efi_random_seed {
      u32     size; // of the 'seed' array in bytes
      u8      seed[];
};

The memory for the struct must be allocated as EFI_ACPI_RECLAIM_MEMORY
pool memory, and the address of the struct in memory should be installed
as a EFI configuration table using the following GUID:

LINUX_EFI_RANDOM_SEED_TABLE_GUID        1ce1e5bc-7ceb-42f2-81e5-8aadf180f57b

Note that doing so is safe even on kernels that were built without this
patch applied, but the seed will simply be overwritten with a seed
derived from the EFI RNG protocol, if available. The recommended seed
size is 32 bytes, and seeds larger than 512 bytes are considered
corrupted and ignored entirely.

In order to preserve forward secrecy, seeds from previous bootloaders
are memzero'd out, and in order to preserve memory, those older seeds
are also freed from memory. Freeing from memory without first memzeroing
is not safe to do, as it's possible that nothing else will ever
overwrite those pages used by EFI.

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
[ardb: incorporate Jason's followup changes to extend the maximum seed
       size on the consumer end, memzero() it and drop a needless printk]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/efi.c             |    4 +--
 drivers/firmware/efi/libstub/efistub.h |    2 +
 drivers/firmware/efi/libstub/random.c  |   42 ++++++++++++++++++++++++++++-----
 include/linux/efi.h                    |    2 -
 4 files changed, 40 insertions(+), 10 deletions(-)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -611,7 +611,7 @@ int __init efi_config_parse_tables(const
 
 		seed = early_memremap(efi_rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = min(seed->size, EFI_RANDOM_SEED_SIZE);
+			size = min_t(u32, seed->size, SZ_1K); // sanity check
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
@@ -620,8 +620,8 @@ int __init efi_config_parse_tables(const
 			seed = early_memremap(efi_rng_seed,
 					      sizeof(*seed) + size);
 			if (seed != NULL) {
-				pr_notice("seeding entropy pool\n");
 				add_bootloader_randomness(seed->bits, size);
+				memzero_explicit(seed->bits, size);
 				early_memunmap(seed, sizeof(*seed) + size);
 			} else {
 				pr_err("Could not map UEFI random seed!\n");
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -882,6 +882,8 @@ efi_status_t efi_get_random_bytes(unsign
 efi_status_t efi_random_alloc(unsigned long size, unsigned long align,
 			      unsigned long *addr, unsigned long random_seed);
 
+efi_status_t efi_random_get_seed(void);
+
 efi_status_t check_platform_features(void);
 
 void *get_efi_config_table(efi_guid_t guid);
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -67,8 +67,9 @@ efi_status_t efi_random_get_seed(void)
 	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
 	efi_guid_t rng_algo_raw = EFI_RNG_ALGORITHM_RAW;
 	efi_guid_t rng_table_guid = LINUX_EFI_RANDOM_SEED_TABLE_GUID;
+	struct linux_efi_random_seed *prev_seed, *seed = NULL;
+	int prev_seed_size = 0, seed_size = EFI_RANDOM_SEED_SIZE;
 	efi_rng_protocol_t *rng = NULL;
-	struct linux_efi_random_seed *seed = NULL;
 	efi_status_t status;
 
 	status = efi_bs_call(locate_protocol, &rng_proto, NULL, (void **)&rng);
@@ -76,18 +77,33 @@ efi_status_t efi_random_get_seed(void)
 		return status;
 
 	/*
+	 * Check whether a seed was provided by a prior boot stage. In that
+	 * case, instead of overwriting it, let's create a new buffer that can
+	 * hold both, and concatenate the existing and the new seeds.
+	 * Note that we should read the seed size with caution, in case the
+	 * table got corrupted in memory somehow.
+	 */
+	prev_seed = get_efi_config_table(LINUX_EFI_RANDOM_SEED_TABLE_GUID);
+	if (prev_seed && prev_seed->size <= 512U) {
+		prev_seed_size = prev_seed->size;
+		seed_size += prev_seed_size;
+	}
+
+	/*
 	 * Use EFI_ACPI_RECLAIM_MEMORY here so that it is guaranteed that the
 	 * allocation will survive a kexec reboot (although we refresh the seed
 	 * beforehand)
 	 */
 	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
-			     sizeof(*seed) + EFI_RANDOM_SEED_SIZE,
+			     struct_size(seed, bits, seed_size),
 			     (void **)&seed);
-	if (status != EFI_SUCCESS)
-		return status;
+	if (status != EFI_SUCCESS) {
+		efi_warn("Failed to allocate memory for RNG seed.\n");
+		goto err_warn;
+	}
 
 	status = efi_call_proto(rng, get_rng, &rng_algo_raw,
-				 EFI_RANDOM_SEED_SIZE, seed->bits);
+				EFI_RANDOM_SEED_SIZE, seed->bits);
 
 	if (status == EFI_UNSUPPORTED)
 		/*
@@ -100,14 +116,28 @@ efi_status_t efi_random_get_seed(void)
 	if (status != EFI_SUCCESS)
 		goto err_freepool;
 
-	seed->size = EFI_RANDOM_SEED_SIZE;
+	seed->size = seed_size;
+	if (prev_seed_size)
+		memcpy(seed->bits + EFI_RANDOM_SEED_SIZE, prev_seed->bits,
+		       prev_seed_size);
+
 	status = efi_bs_call(install_configuration_table, &rng_table_guid, seed);
 	if (status != EFI_SUCCESS)
 		goto err_freepool;
 
+	if (prev_seed_size) {
+		/* wipe and free the old seed if we managed to install the new one */
+		memzero_explicit(prev_seed->bits, prev_seed_size);
+		efi_bs_call(free_pool, prev_seed);
+	}
 	return EFI_SUCCESS;
 
 err_freepool:
+	memzero_explicit(seed, struct_size(seed, bits, seed_size));
 	efi_bs_call(free_pool, seed);
+	efi_warn("Failed to obtain seed from EFI_RNG_PROTOCOL\n");
+err_warn:
+	if (prev_seed)
+		efi_warn("Retaining bootloader-supplied seed only");
 	return status;
 }
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1170,8 +1170,6 @@ void efi_check_for_embedded_firmwares(vo
 static inline void efi_check_for_embedded_firmwares(void) { }
 #endif
 
-efi_status_t efi_random_get_seed(void);
-
 #define arch_efi_call_virt(p, f, args...)	((p)->f(args))
 
 /*


