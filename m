Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E664B664CBD
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 20:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjAJTp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 14:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbjAJTp4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 14:45:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470F16146
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 11:45:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 950DDCE1923
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 19:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DD0C433D2;
        Tue, 10 Jan 2023 19:45:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SnYL9fMn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1673379945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7mINv3yHC5N4R161aSNr9+oQMj3ZvQvduGZPlCXo4mk=;
        b=SnYL9fMnZKtZevaAUe7xALW0aOld6GmBYq110B8Hv7isW/VXiULwxNkI8Tl8T1JBEO0b4k
        GgtO4j0Ni7OkYQ4basggS4qwdvWzfrm+xkoNcCmNxaVCLZ8SD72GxsFf6IYZvv86/InwSz
        uxQHK7lLpnqfcW/3QifygZebcQjR/mU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b792022e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 10 Jan 2023 19:45:44 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH stable 5.4.y] efi: random: combine bootloader provided RNG seed with RNG protocol output
Date:   Tue, 10 Jan 2023 20:45:40 +0100
Message-Id: <20230110194540.463983-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9oomMCxw=OQZpSp+hwLM78hZV+gNyn8ZPJgN99s2e=tuw@mail.gmail.com>
References: <CAHmME9oomMCxw=OQZpSp+hwLM78hZV+gNyn8ZPJgN99s2e=tuw@mail.gmail.com>
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
---
 arch/x86/boot/compressed/eboot.c       |  3 +
 drivers/firmware/efi/efi.c             |  4 +-
 drivers/firmware/efi/libstub/Makefile  |  5 +-
 drivers/firmware/efi/libstub/efistub.h |  3 +-
 drivers/firmware/efi/libstub/random.c  | 86 +++++++++++++++++++++-----
 include/linux/efi.h                    |  2 +
 6 files changed, 83 insertions(+), 20 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 82bc60c8acb2..68945c5700bf 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -782,6 +782,9 @@ efi_main(struct efi_config *c, struct boot_params *boot_params)
 
 	/* Ask the firmware to clear memory on unclean shutdown */
 	efi_enable_reset_attack_mitigation(sys_table);
+
+	efi_random_get_seed(sys_table);
+
 	efi_retrieve_tpm2_eventlog(sys_table);
 
 	setup_graphics(boot_params);
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index ac9fb336c80f..f4be4ac7d3aa 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -546,7 +546,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 
 		seed = early_memremap(efi.rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = min(seed->size, EFI_RANDOM_SEED_SIZE);
+			size = min_t(u32, seed->size, SZ_1K); // sanity check
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
@@ -555,8 +555,8 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 			seed = early_memremap(efi.rng_seed,
 					      sizeof(*seed) + size);
 			if (seed != NULL) {
-				pr_notice("seeding entropy pool\n");
 				add_bootloader_randomness(seed->bits, size);
+				memzero_explicit(seed->bits, size);
 				early_memunmap(seed, sizeof(*seed) + size);
 			} else {
 				pr_err("Could not map UEFI random seed!\n");
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 8c5b5529dbc0..d943d59ff54c 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -39,7 +39,8 @@ OBJECT_FILES_NON_STANDARD	:= y
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
 KCOV_INSTRUMENT			:= n
 
-lib-y				:= efi-stub-helper.o gop.o secureboot.o tpm.o
+lib-y				:= efi-stub-helper.o gop.o secureboot.o tpm.o \
+				   random.o
 
 # include the stub's generic dependencies from lib/ when building for ARM/arm64
 arm-deps-y := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c
@@ -48,7 +49,7 @@ arm-deps-$(CONFIG_ARM64) += sort.c
 $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
-lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o string.o random.o \
+lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o string.o \
 				   $(patsubst %.c,lib-%.o,$(arm-deps-y))
 
 lib-$(CONFIG_ARM)		+= arm32-stub.o
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 7f1556fd867d..4ebf02b99c1b 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -34,6 +34,7 @@ extern int __pure novamap(void);
 } while (0)
 
 #define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
+#define pr_efi_warn(sys_table, msg) efi_printk(sys_table, "EFI stub: WARNING: "msg)
 
 void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
@@ -63,8 +64,6 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 
 efi_status_t check_platform_features(efi_system_table_t *sys_table_arg);
 
-efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg);
-
 void *get_efi_config_table(efi_system_table_t *sys_table, efi_guid_t guid);
 
 /* Helper macros for the usual case of using simple C variables: */
diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index b4b1d1dcb5fd..c8b1e0088895 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -9,12 +9,22 @@
 
 #include "efistub.h"
 
-struct efi_rng_protocol {
+typedef struct efi_rng_protocol {
 	efi_status_t (*get_info)(struct efi_rng_protocol *,
 				 unsigned long *, efi_guid_t *);
 	efi_status_t (*get_rng)(struct efi_rng_protocol *,
 				efi_guid_t *, unsigned long, u8 *out);
-};
+} efi_rng_protocol_t;
+
+typedef struct {
+	u32 get_info;
+	u32 get_rng;
+} efi_rng_protocol_32_t;
+
+typedef struct {
+	u64 get_info;
+	u64 get_rng;
+} efi_rng_protocol_64_t;
 
 efi_status_t efi_get_random_bytes(efi_system_table_t *sys_table_arg,
 				  unsigned long size, u8 *out)
@@ -28,7 +38,7 @@ efi_status_t efi_get_random_bytes(efi_system_table_t *sys_table_arg,
 	if (status != EFI_SUCCESS)
 		return status;
 
-	return rng->get_rng(rng, NULL, size, out);
+	return efi_call_proto(efi_rng_protocol, get_rng, rng, NULL, size, out);
 }
 
 /*
@@ -141,13 +151,27 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 	return status;
 }
 
+/**
+ * efi_random_get_seed() - provide random seed as configuration table
+ *
+ * The EFI_RNG_PROTOCOL is used to read random bytes. These random bytes are
+ * saved as a configuration table which can be used as entropy by the kernel
+ * for the initialization of its pseudo random number generator.
+ *
+ * If the EFI_RNG_PROTOCOL is not available or there are not enough random bytes
+ * available, the configuration table will not be installed and an error code
+ * will be returned.
+ *
+ * Return:	status code
+ */
 efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg)
 {
 	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
 	efi_guid_t rng_algo_raw = EFI_RNG_ALGORITHM_RAW;
 	efi_guid_t rng_table_guid = LINUX_EFI_RANDOM_SEED_TABLE_GUID;
-	struct efi_rng_protocol *rng;
-	struct linux_efi_random_seed *seed;
+	struct linux_efi_random_seed *prev_seed, *seed = NULL;
+	int prev_seed_size = 0, seed_size = EFI_RANDOM_SEED_SIZE;
+	struct efi_rng_protocol *rng = NULL;
 	efi_status_t status;
 
 	status = efi_call_early(locate_protocol, &rng_proto, NULL,
@@ -155,34 +179,68 @@ efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg)
 	if (status != EFI_SUCCESS)
 		return status;
 
-	status = efi_call_early(allocate_pool, EFI_RUNTIME_SERVICES_DATA,
-				sizeof(*seed) + EFI_RANDOM_SEED_SIZE,
+	/*
+	 * Check whether a seed was provided by a prior boot stage. In that
+	 * case, instead of overwriting it, let's create a new buffer that can
+	 * hold both, and concatenate the existing and the new seeds.
+	 * Note that we should read the seed size with caution, in case the
+	 * table got corrupted in memory somehow.
+	 */
+	prev_seed = get_efi_config_table(sys_table_arg, LINUX_EFI_RANDOM_SEED_TABLE_GUID);
+	if (prev_seed && prev_seed->size <= 512U) {
+		prev_seed_size = prev_seed->size;
+		seed_size += prev_seed_size;
+	}
+
+	/*
+	 * Use EFI_ACPI_RECLAIM_MEMORY here so that it is guaranteed that the
+	 * allocation will survive a kexec reboot (although we refresh the seed
+	 * beforehand)
+	 */
+	status = efi_call_early(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
+				struct_size(seed, bits, seed_size),
 				(void **)&seed);
-	if (status != EFI_SUCCESS)
-		return status;
+	if (status != EFI_SUCCESS) {
+		pr_efi_warn(sys_table_arg, "Failed to allocate memory for RNG seed.\n");
+		goto err_warn;
+	}
 
-	status = rng->get_rng(rng, &rng_algo_raw, EFI_RANDOM_SEED_SIZE,
-			      seed->bits);
+	status = efi_call_proto(efi_rng_protocol, get_rng, rng, &rng_algo_raw,
+				EFI_RANDOM_SEED_SIZE, seed->bits);
 	if (status == EFI_UNSUPPORTED)
 		/*
 		 * Use whatever algorithm we have available if the raw algorithm
 		 * is not implemented.
 		 */
-		status = rng->get_rng(rng, NULL, EFI_RANDOM_SEED_SIZE,
-				      seed->bits);
+		status = efi_call_proto(efi_rng_protocol, get_rng, rng, NULL,
+					EFI_RANDOM_SEED_SIZE, seed->bits);
 
 	if (status != EFI_SUCCESS)
 		goto err_freepool;
 
-	seed->size = EFI_RANDOM_SEED_SIZE;
+	seed->size = seed_size;
+	if (prev_seed_size)
+		memcpy(seed->bits + EFI_RANDOM_SEED_SIZE, prev_seed->bits,
+		       prev_seed_size);
+
 	status = efi_call_early(install_configuration_table, &rng_table_guid,
 				seed);
 	if (status != EFI_SUCCESS)
 		goto err_freepool;
 
+	if (prev_seed_size) {
+		/* wipe and free the old seed if we managed to install the new one */
+		memzero_explicit(prev_seed->bits, prev_seed_size);
+		efi_call_early(free_pool, prev_seed);
+	}
 	return EFI_SUCCESS;
 
 err_freepool:
+	memzero_explicit(seed, struct_size(seed, bits, seed_size));
 	efi_call_early(free_pool, seed);
+	pr_efi_warn(sys_table_arg, "Failed to obtain seed from EFI_RNG_PROTOCOL\n");
+err_warn:
+	if (prev_seed)
+		pr_efi_warn(sys_table_arg, "Retaining bootloader-supplied seed only");
 	return status;
 }
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 880cd86c829d..d68c96dee81d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1653,6 +1653,8 @@ static inline void
 efi_enable_reset_attack_mitigation(efi_system_table_t *sys_table_arg) { }
 #endif
 
+efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg);
+
 void efi_retrieve_tpm2_eventlog(efi_system_table_t *sys_table);
 
 /*
-- 
2.39.0

