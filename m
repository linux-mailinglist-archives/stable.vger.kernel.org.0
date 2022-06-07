Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B4C535F72
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351474AbiE0LiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351491AbiE0LiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:38:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E9D12698E;
        Fri, 27 May 2022 04:38:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B4BCB824D9;
        Fri, 27 May 2022 11:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C191C385A9;
        Fri, 27 May 2022 11:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651479;
        bh=TdM9kCbzO9r9RHTkFH3ggT2WNkeIKCbHj5t/HggTyXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyaleu/Fi5+7oUffh1+z30ee3YGEPhlP5G5CNXcmRJo4yF2Os8Nj3mbnSBNMv9NGK
         ercFltSTA4MPTpayyjqrGUcSEMvj6a4s8pUCUY2dnJlV6J83NqGAEFM9OnY470bIdo
         fIcsNY+eJlvM37XJbL8olwKf8aQEefl7uOgoUeLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kbuild@vger.kernel.org, linux-crypto@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 007/145] lib/crypto: blake2s: include as built-in
Date:   Fri, 27 May 2022 10:48:28 +0200
Message-Id: <20220527084851.561294196@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 6048fdcc5f269c7f31d774c295ce59081b36e6f9 upstream.

In preparation for using blake2s in the RNG, we change the way that it
is wired-in to the build system. Instead of using ifdefs to select the
right symbol, we use weak symbols. And because ARM doesn't need the
generic implementation, we make the generic one default only if an arch
library doesn't need it already, and then have arch libraries that do
need it opt-in. So that the arch libraries can remain tristate rather
than bool, we then split the shash part from the glue code.

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: linux-kbuild@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/crypto/Makefile          |    4 +
 arch/arm/crypto/blake2s-core.S    |    8 +--
 arch/arm/crypto/blake2s-glue.c    |   73 ------------------------------------
 arch/arm/crypto/blake2s-shash.c   |   75 +++++++++++++++++++++++++++++++++++++
 arch/x86/crypto/Makefile          |    4 +
 arch/x86/crypto/blake2s-glue.c    |   68 ++-------------------------------
 arch/x86/crypto/blake2s-shash.c   |   77 ++++++++++++++++++++++++++++++++++++++
 crypto/Kconfig                    |    3 -
 drivers/net/Kconfig               |    1 
 include/crypto/internal/blake2s.h |    6 +-
 lib/crypto/Kconfig                |   23 ++---------
 lib/crypto/Makefile               |    9 +---
 lib/crypto/blake2s-generic.c      |    6 ++
 lib/crypto/blake2s.c              |    6 --
 14 files changed, 189 insertions(+), 174 deletions(-)
 create mode 100644 arch/arm/crypto/blake2s-shash.c
 create mode 100644 arch/x86/crypto/blake2s-shash.c

--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_CRYPTO_SHA1_ARM_NEON) += sh
 obj-$(CONFIG_CRYPTO_SHA256_ARM) += sha256-arm.o
 obj-$(CONFIG_CRYPTO_SHA512_ARM) += sha512-arm.o
 obj-$(CONFIG_CRYPTO_BLAKE2S_ARM) += blake2s-arm.o
+obj-$(if $(CONFIG_CRYPTO_BLAKE2S_ARM),y) += libblake2s-arm.o
 obj-$(CONFIG_CRYPTO_BLAKE2B_NEON) += blake2b-neon.o
 obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha-neon.o
 obj-$(CONFIG_CRYPTO_POLY1305_ARM) += poly1305-arm.o
@@ -31,7 +32,8 @@ sha256-arm-neon-$(CONFIG_KERNEL_MODE_NEO
 sha256-arm-y	:= sha256-core.o sha256_glue.o $(sha256-arm-neon-y)
 sha512-arm-neon-$(CONFIG_KERNEL_MODE_NEON) := sha512-neon-glue.o
 sha512-arm-y	:= sha512-core.o sha512-glue.o $(sha512-arm-neon-y)
-blake2s-arm-y   := blake2s-core.o blake2s-glue.o
+blake2s-arm-y   := blake2s-shash.o
+libblake2s-arm-y:= blake2s-core.o blake2s-glue.o
 blake2b-neon-y  := blake2b-neon-core.o blake2b-neon-glue.o
 sha1-arm-ce-y	:= sha1-ce-core.o sha1-ce-glue.o
 sha2-arm-ce-y	:= sha2-ce-core.o sha2-ce-glue.o
--- a/arch/arm/crypto/blake2s-core.S
+++ b/arch/arm/crypto/blake2s-core.S
@@ -167,8 +167,8 @@
 .endm
 
 //
-// void blake2s_compress_arch(struct blake2s_state *state,
-//			      const u8 *block, size_t nblocks, u32 inc);
+// void blake2s_compress(struct blake2s_state *state,
+//			 const u8 *block, size_t nblocks, u32 inc);
 //
 // Only the first three fields of struct blake2s_state are used:
 //	u32 h[8];	(inout)
@@ -176,7 +176,7 @@
 //	u32 f[2];	(in)
 //
 	.align		5
-ENTRY(blake2s_compress_arch)
+ENTRY(blake2s_compress)
 	push		{r0-r2,r4-r11,lr}	// keep this an even number
 
 .Lnext_block:
@@ -303,4 +303,4 @@ ENTRY(blake2s_compress_arch)
 	str		r3, [r12], #4
 	bne		1b
 	b		.Lcopy_block_done
-ENDPROC(blake2s_compress_arch)
+ENDPROC(blake2s_compress)
--- a/arch/arm/crypto/blake2s-glue.c
+++ b/arch/arm/crypto/blake2s-glue.c
@@ -1,78 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * BLAKE2s digest algorithm, ARM scalar implementation
- *
- * Copyright 2020 Google LLC
- */
 
 #include <crypto/internal/blake2s.h>
-#include <crypto/internal/hash.h>
-
 #include <linux/module.h>
 
 /* defined in blake2s-core.S */
-EXPORT_SYMBOL(blake2s_compress_arch);
-
-static int crypto_blake2s_update_arm(struct shash_desc *desc,
-				     const u8 *in, unsigned int inlen)
-{
-	return crypto_blake2s_update(desc, in, inlen, blake2s_compress_arch);
-}
-
-static int crypto_blake2s_final_arm(struct shash_desc *desc, u8 *out)
-{
-	return crypto_blake2s_final(desc, out, blake2s_compress_arch);
-}
-
-#define BLAKE2S_ALG(name, driver_name, digest_size)			\
-	{								\
-		.base.cra_name		= name,				\
-		.base.cra_driver_name	= driver_name,			\
-		.base.cra_priority	= 200,				\
-		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,	\
-		.base.cra_blocksize	= BLAKE2S_BLOCK_SIZE,		\
-		.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx), \
-		.base.cra_module	= THIS_MODULE,			\
-		.digestsize		= digest_size,			\
-		.setkey			= crypto_blake2s_setkey,	\
-		.init			= crypto_blake2s_init,		\
-		.update			= crypto_blake2s_update_arm,	\
-		.final			= crypto_blake2s_final_arm,	\
-		.descsize		= sizeof(struct blake2s_state),	\
-	}
-
-static struct shash_alg blake2s_arm_algs[] = {
-	BLAKE2S_ALG("blake2s-128", "blake2s-128-arm", BLAKE2S_128_HASH_SIZE),
-	BLAKE2S_ALG("blake2s-160", "blake2s-160-arm", BLAKE2S_160_HASH_SIZE),
-	BLAKE2S_ALG("blake2s-224", "blake2s-224-arm", BLAKE2S_224_HASH_SIZE),
-	BLAKE2S_ALG("blake2s-256", "blake2s-256-arm", BLAKE2S_256_HASH_SIZE),
-};
-
-static int __init blake2s_arm_mod_init(void)
-{
-	return IS_REACHABLE(CONFIG_CRYPTO_HASH) ?
-		crypto_register_shashes(blake2s_arm_algs,
-					ARRAY_SIZE(blake2s_arm_algs)) : 0;
-}
-
-static void __exit blake2s_arm_mod_exit(void)
-{
-	if (IS_REACHABLE(CONFIG_CRYPTO_HASH))
-		crypto_unregister_shashes(blake2s_arm_algs,
-					  ARRAY_SIZE(blake2s_arm_algs));
-}
-
-module_init(blake2s_arm_mod_init);
-module_exit(blake2s_arm_mod_exit);
-
-MODULE_DESCRIPTION("BLAKE2s digest algorithm, ARM scalar implementation");
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Eric Biggers <ebiggers@google.com>");
-MODULE_ALIAS_CRYPTO("blake2s-128");
-MODULE_ALIAS_CRYPTO("blake2s-128-arm");
-MODULE_ALIAS_CRYPTO("blake2s-160");
-MODULE_ALIAS_CRYPTO("blake2s-160-arm");
-MODULE_ALIAS_CRYPTO("blake2s-224");
-MODULE_ALIAS_CRYPTO("blake2s-224-arm");
-MODULE_ALIAS_CRYPTO("blake2s-256");
-MODULE_ALIAS_CRYPTO("blake2s-256-arm");
+EXPORT_SYMBOL(blake2s_compress);
--- /dev/null
+++ b/arch/arm/crypto/blake2s-shash.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * BLAKE2s digest algorithm, ARM scalar implementation
+ *
+ * Copyright 2020 Google LLC
+ */
+
+#include <crypto/internal/blake2s.h>
+#include <crypto/internal/hash.h>
+
+#include <linux/module.h>
+
+static int crypto_blake2s_update_arm(struct shash_desc *desc,
+				     const u8 *in, unsigned int inlen)
+{
+	return crypto_blake2s_update(desc, in, inlen, blake2s_compress);
+}
+
+static int crypto_blake2s_final_arm(struct shash_desc *desc, u8 *out)
+{
+	return crypto_blake2s_final(desc, out, blake2s_compress);
+}
+
+#define BLAKE2S_ALG(name, driver_name, digest_size)			\
+	{								\
+		.base.cra_name		= name,				\
+		.base.cra_driver_name	= driver_name,			\
+		.base.cra_priority	= 200,				\
+		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,	\
+		.base.cra_blocksize	= BLAKE2S_BLOCK_SIZE,		\
+		.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx), \
+		.base.cra_module	= THIS_MODULE,			\
+		.digestsize		= digest_size,			\
+		.setkey			= crypto_blake2s_setkey,	\
+		.init			= crypto_blake2s_init,		\
+		.update			= crypto_blake2s_update_arm,	\
+		.final			= crypto_blake2s_final_arm,	\
+		.descsize		= sizeof(struct blake2s_state),	\
+	}
+
+static struct shash_alg blake2s_arm_algs[] = {
+	BLAKE2S_ALG("blake2s-128", "blake2s-128-arm", BLAKE2S_128_HASH_SIZE),
+	BLAKE2S_ALG("blake2s-160", "blake2s-160-arm", BLAKE2S_160_HASH_SIZE),
+	BLAKE2S_ALG("blake2s-224", "blake2s-224-arm", BLAKE2S_224_HASH_SIZE),
+	BLAKE2S_ALG("blake2s-256", "blake2s-256-arm", BLAKE2S_256_HASH_SIZE),
+};
+
+static int __init blake2s_arm_mod_init(void)
+{
+	return IS_REACHABLE(CONFIG_CRYPTO_HASH) ?
+		crypto_register_shashes(blake2s_arm_algs,
+					ARRAY_SIZE(blake2s_arm_algs)) : 0;
+}
+
+static void __exit blake2s_arm_mod_exit(void)
+{
+	if (IS_REACHABLE(CONFIG_CRYPTO_HASH))
+		crypto_unregister_shashes(blake2s_arm_algs,
+					  ARRAY_SIZE(blake2s_arm_algs));
+}
+
+module_init(blake2s_arm_mod_init);
+module_exit(blake2s_arm_mod_exit);
+
+MODULE_DESCRIPTION("BLAKE2s digest algorithm, ARM scalar implementation");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Eric Biggers <ebiggers@google.com>");
+MODULE_ALIAS_CRYPTO("blake2s-128");
+MODULE_ALIAS_CRYPTO("blake2s-128-arm");
+MODULE_ALIAS_CRYPTO("blake2s-160");
+MODULE_ALIAS_CRYPTO("blake2s-160-arm");
+MODULE_ALIAS_CRYPTO("blake2s-224");
+MODULE_ALIAS_CRYPTO("blake2s-224-arm");
+MODULE_ALIAS_CRYPTO("blake2s-256");
+MODULE_ALIAS_CRYPTO("blake2s-256-arm");
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -62,7 +62,9 @@ obj-$(CONFIG_CRYPTO_SHA512_SSSE3) += sha
 sha512-ssse3-y := sha512-ssse3-asm.o sha512-avx-asm.o sha512-avx2-asm.o sha512_ssse3_glue.o
 
 obj-$(CONFIG_CRYPTO_BLAKE2S_X86) += blake2s-x86_64.o
-blake2s-x86_64-y := blake2s-core.o blake2s-glue.o
+blake2s-x86_64-y := blake2s-shash.o
+obj-$(if $(CONFIG_CRYPTO_BLAKE2S_X86),y) += libblake2s-x86_64.o
+libblake2s-x86_64-y := blake2s-core.o blake2s-glue.o
 
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
--- a/arch/x86/crypto/blake2s-glue.c
+++ b/arch/x86/crypto/blake2s-glue.c
@@ -5,7 +5,6 @@
 
 #include <crypto/internal/blake2s.h>
 #include <crypto/internal/simd.h>
-#include <crypto/internal/hash.h>
 
 #include <linux/types.h>
 #include <linux/jump_label.h>
@@ -28,9 +27,8 @@ asmlinkage void blake2s_compress_avx512(
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(blake2s_use_ssse3);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(blake2s_use_avx512);
 
-void blake2s_compress_arch(struct blake2s_state *state,
-			   const u8 *block, size_t nblocks,
-			   const u32 inc)
+void blake2s_compress(struct blake2s_state *state, const u8 *block,
+		      size_t nblocks, const u32 inc)
 {
 	/* SIMD disables preemption, so relax after processing each page. */
 	BUILD_BUG_ON(SZ_4K / BLAKE2S_BLOCK_SIZE < 8);
@@ -56,49 +54,12 @@ void blake2s_compress_arch(struct blake2
 		block += blocks * BLAKE2S_BLOCK_SIZE;
 	} while (nblocks);
 }
-EXPORT_SYMBOL(blake2s_compress_arch);
-
-static int crypto_blake2s_update_x86(struct shash_desc *desc,
-				     const u8 *in, unsigned int inlen)
-{
-	return crypto_blake2s_update(desc, in, inlen, blake2s_compress_arch);
-}
-
-static int crypto_blake2s_final_x86(struct shash_desc *desc, u8 *out)
-{
-	return crypto_blake2s_final(desc, out, blake2s_compress_arch);
-}
-
-#define BLAKE2S_ALG(name, driver_name, digest_size)			\
-	{								\
-		.base.cra_name		= name,				\
-		.base.cra_driver_name	= driver_name,			\
-		.base.cra_priority	= 200,				\
-		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,	\
-		.base.cra_blocksize	= BLAKE2S_BLOCK_SIZE,		\
-		.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx), \
-		.base.cra_module	= THIS_MODULE,			\
-		.digestsize		= digest_size,			\
-		.setkey			= crypto_blake2s_setkey,	\
-		.init			= crypto_blake2s_init,		\
-		.update			= crypto_blake2s_update_x86,	\
-		.final			= crypto_blake2s_final_x86,	\
-		.descsize		= sizeof(struct blake2s_state),	\
-	}
-
-static struct shash_alg blake2s_algs[] = {
-	BLAKE2S_ALG("blake2s-128", "blake2s-128-x86", BLAKE2S_128_HASH_SIZE),
-	BLAKE2S_ALG("blake2s-160", "blake2s-160-x86", BLAKE2S_160_HASH_SIZE),
-	BLAKE2S_ALG("blake2s-224", "blake2s-224-x86", BLAKE2S_224_HASH_SIZE),
-	BLAKE2S_ALG("blake2s-256", "blake2s-256-x86", BLAKE2S_256_HASH_SIZE),
-};
+EXPORT_SYMBOL(blake2s_compress);
 
 static int __init blake2s_mod_init(void)
 {
-	if (!boot_cpu_has(X86_FEATURE_SSSE3))
-		return 0;
-
-	static_branch_enable(&blake2s_use_ssse3);
+	if (boot_cpu_has(X86_FEATURE_SSSE3))
+		static_branch_enable(&blake2s_use_ssse3);
 
 	if (IS_ENABLED(CONFIG_AS_AVX512) &&
 	    boot_cpu_has(X86_FEATURE_AVX) &&
@@ -109,26 +70,9 @@ static int __init blake2s_mod_init(void)
 			      XFEATURE_MASK_AVX512, NULL))
 		static_branch_enable(&blake2s_use_avx512);
 
-	return IS_REACHABLE(CONFIG_CRYPTO_HASH) ?
-		crypto_register_shashes(blake2s_algs,
-					ARRAY_SIZE(blake2s_algs)) : 0;
-}
-
-static void __exit blake2s_mod_exit(void)
-{
-	if (IS_REACHABLE(CONFIG_CRYPTO_HASH) && boot_cpu_has(X86_FEATURE_SSSE3))
-		crypto_unregister_shashes(blake2s_algs, ARRAY_SIZE(blake2s_algs));
+	return 0;
 }
 
 module_init(blake2s_mod_init);
-module_exit(blake2s_mod_exit);
 
-MODULE_ALIAS_CRYPTO("blake2s-128");
-MODULE_ALIAS_CRYPTO("blake2s-128-x86");
-MODULE_ALIAS_CRYPTO("blake2s-160");
-MODULE_ALIAS_CRYPTO("blake2s-160-x86");
-MODULE_ALIAS_CRYPTO("blake2s-224");
-MODULE_ALIAS_CRYPTO("blake2s-224-x86");
-MODULE_ALIAS_CRYPTO("blake2s-256");
-MODULE_ALIAS_CRYPTO("blake2s-256-x86");
 MODULE_LICENSE("GPL v2");
--- /dev/null
+++ b/arch/x86/crypto/blake2s-shash.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0 OR MIT
+/*
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#include <crypto/internal/blake2s.h>
+#include <crypto/internal/simd.h>
+#include <crypto/internal/hash.h>
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sizes.h>
+
+#include <asm/cpufeature.h>
+#include <asm/processor.h>
+
+static int crypto_blake2s_update_x86(struct shash_desc *desc,
+				     const u8 *in, unsigned int inlen)
+{
+	return crypto_blake2s_update(desc, in, inlen, blake2s_compress);
+}
+
+static int crypto_blake2s_final_x86(struct shash_desc *desc, u8 *out)
+{
+	return crypto_blake2s_final(desc, out, blake2s_compress);
+}
+
+#define BLAKE2S_ALG(name, driver_name, digest_size)			\
+	{								\
+		.base.cra_name		= name,				\
+		.base.cra_driver_name	= driver_name,			\
+		.base.cra_priority	= 200,				\
+		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,	\
+		.base.cra_blocksize	= BLAKE2S_BLOCK_SIZE,		\
+		.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx), \
+		.base.cra_module	= THIS_MODULE,			\
+		.digestsize		= digest_size,			\
+		.setkey			= crypto_blake2s_setkey,	\
+		.init			= crypto_blake2s_init,		\
+		.update			= crypto_blake2s_update_x86,	\
+		.final			= crypto_blake2s_final_x86,	\
+		.descsize		= sizeof(struct blake2s_state),	\
+	}
+
+static struct shash_alg blake2s_algs[] = {
+	BLAKE2S_ALG("blake2s-128", "blake2s-128-x86", BLAKE2S_128_HASH_SIZE),
+	BLAKE2S_ALG("blake2s-160", "blake2s-160-x86", BLAKE2S_160_HASH_SIZE),
+	BLAKE2S_ALG("blake2s-224", "blake2s-224-x86", BLAKE2S_224_HASH_SIZE),
+	BLAKE2S_ALG("blake2s-256", "blake2s-256-x86", BLAKE2S_256_HASH_SIZE),
+};
+
+static int __init blake2s_mod_init(void)
+{
+	if (IS_REACHABLE(CONFIG_CRYPTO_HASH) && boot_cpu_has(X86_FEATURE_SSSE3))
+		return crypto_register_shashes(blake2s_algs, ARRAY_SIZE(blake2s_algs));
+	return 0;
+}
+
+static void __exit blake2s_mod_exit(void)
+{
+	if (IS_REACHABLE(CONFIG_CRYPTO_HASH) && boot_cpu_has(X86_FEATURE_SSSE3))
+		crypto_unregister_shashes(blake2s_algs, ARRAY_SIZE(blake2s_algs));
+}
+
+module_init(blake2s_mod_init);
+module_exit(blake2s_mod_exit);
+
+MODULE_ALIAS_CRYPTO("blake2s-128");
+MODULE_ALIAS_CRYPTO("blake2s-128-x86");
+MODULE_ALIAS_CRYPTO("blake2s-160");
+MODULE_ALIAS_CRYPTO("blake2s-160-x86");
+MODULE_ALIAS_CRYPTO("blake2s-224");
+MODULE_ALIAS_CRYPTO("blake2s-224-x86");
+MODULE_ALIAS_CRYPTO("blake2s-256");
+MODULE_ALIAS_CRYPTO("blake2s-256-x86");
+MODULE_LICENSE("GPL v2");
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1919,9 +1919,10 @@ config CRYPTO_STATS
 config CRYPTO_HASH_INFO
 	bool
 
-source "lib/crypto/Kconfig"
 source "drivers/crypto/Kconfig"
 source "crypto/asymmetric_keys/Kconfig"
 source "certs/Kconfig"
 
 endif	# if CRYPTO
+
+source "lib/crypto/Kconfig"
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -81,7 +81,6 @@ config WIREGUARD
 	select CRYPTO
 	select CRYPTO_LIB_CURVE25519
 	select CRYPTO_LIB_CHACHA20POLY1305
-	select CRYPTO_LIB_BLAKE2S
 	select CRYPTO_CHACHA20_X86_64 if X86 && 64BIT
 	select CRYPTO_POLY1305_X86_64 if X86 && 64BIT
 	select CRYPTO_BLAKE2S_X86 if X86 && 64BIT
--- a/include/crypto/internal/blake2s.h
+++ b/include/crypto/internal/blake2s.h
@@ -11,11 +11,11 @@
 #include <crypto/internal/hash.h>
 #include <linux/string.h>
 
-void blake2s_compress_generic(struct blake2s_state *state,const u8 *block,
+void blake2s_compress_generic(struct blake2s_state *state, const u8 *block,
 			      size_t nblocks, const u32 inc);
 
-void blake2s_compress_arch(struct blake2s_state *state,const u8 *block,
-			   size_t nblocks, const u32 inc);
+void blake2s_compress(struct blake2s_state *state, const u8 *block,
+		      size_t nblocks, const u32 inc);
 
 bool blake2s_selftest(void);
 
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -1,7 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 
-comment "Crypto library routines"
-
 config CRYPTO_LIB_AES
 	tristate
 
@@ -9,14 +7,14 @@ config CRYPTO_LIB_ARC4
 	tristate
 
 config CRYPTO_ARCH_HAVE_LIB_BLAKE2S
-	tristate
+	bool
 	help
 	  Declares whether the architecture provides an arch-specific
 	  accelerated implementation of the Blake2s library interface,
 	  either builtin or as a module.
 
 config CRYPTO_LIB_BLAKE2S_GENERIC
-	tristate
+	def_bool !CRYPTO_ARCH_HAVE_LIB_BLAKE2S
 	help
 	  This symbol can be depended upon by arch implementations of the
 	  Blake2s library interface that require the generic code as a
@@ -24,15 +22,6 @@ config CRYPTO_LIB_BLAKE2S_GENERIC
 	  implementation is enabled, this implementation serves the users
 	  of CRYPTO_LIB_BLAKE2S.
 
-config CRYPTO_LIB_BLAKE2S
-	tristate "BLAKE2s hash function library"
-	depends on CRYPTO_ARCH_HAVE_LIB_BLAKE2S || !CRYPTO_ARCH_HAVE_LIB_BLAKE2S
-	select CRYPTO_LIB_BLAKE2S_GENERIC if CRYPTO_ARCH_HAVE_LIB_BLAKE2S=n
-	help
-	  Enable the Blake2s library interface. This interface may be fulfilled
-	  by either the generic implementation or an arch-specific one, if one
-	  is available and enabled.
-
 config CRYPTO_ARCH_HAVE_LIB_CHACHA
 	tristate
 	help
@@ -51,7 +40,7 @@ config CRYPTO_LIB_CHACHA_GENERIC
 	  of CRYPTO_LIB_CHACHA.
 
 config CRYPTO_LIB_CHACHA
-	tristate "ChaCha library interface"
+	tristate
 	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
 	select CRYPTO_LIB_CHACHA_GENERIC if CRYPTO_ARCH_HAVE_LIB_CHACHA=n
 	help
@@ -76,7 +65,7 @@ config CRYPTO_LIB_CURVE25519_GENERIC
 	  of CRYPTO_LIB_CURVE25519.
 
 config CRYPTO_LIB_CURVE25519
-	tristate "Curve25519 scalar multiplication library"
+	tristate
 	depends on CRYPTO_ARCH_HAVE_LIB_CURVE25519 || !CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	select CRYPTO_LIB_CURVE25519_GENERIC if CRYPTO_ARCH_HAVE_LIB_CURVE25519=n
 	help
@@ -111,7 +100,7 @@ config CRYPTO_LIB_POLY1305_GENERIC
 	  of CRYPTO_LIB_POLY1305.
 
 config CRYPTO_LIB_POLY1305
-	tristate "Poly1305 library interface"
+	tristate
 	depends on CRYPTO_ARCH_HAVE_LIB_POLY1305 || !CRYPTO_ARCH_HAVE_LIB_POLY1305
 	select CRYPTO_LIB_POLY1305_GENERIC if CRYPTO_ARCH_HAVE_LIB_POLY1305=n
 	help
@@ -120,7 +109,7 @@ config CRYPTO_LIB_POLY1305
 	  is available and enabled.
 
 config CRYPTO_LIB_CHACHA20POLY1305
-	tristate "ChaCha20-Poly1305 AEAD support (8-byte nonce library version)"
+	tristate
 	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
 	depends on CRYPTO_ARCH_HAVE_LIB_POLY1305 || !CRYPTO_ARCH_HAVE_LIB_POLY1305
 	select CRYPTO_LIB_CHACHA
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -10,11 +10,10 @@ libaes-y					:= aes.o
 obj-$(CONFIG_CRYPTO_LIB_ARC4)			+= libarc4.o
 libarc4-y					:= arc4.o
 
-obj-$(CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC)	+= libblake2s-generic.o
-libblake2s-generic-y				+= blake2s-generic.o
-
-obj-$(CONFIG_CRYPTO_LIB_BLAKE2S)		+= libblake2s.o
-libblake2s-y					+= blake2s.o
+# blake2s is used by the /dev/random driver which is always builtin
+obj-y						+= libblake2s.o
+libblake2s-y					:= blake2s.o
+libblake2s-$(CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC)	+= blake2s-generic.o
 
 obj-$(CONFIG_CRYPTO_LIB_CHACHA20POLY1305)	+= libchacha20poly1305.o
 libchacha20poly1305-y				+= chacha20poly1305.o
--- a/lib/crypto/blake2s-generic.c
+++ b/lib/crypto/blake2s-generic.c
@@ -37,7 +37,11 @@ static inline void blake2s_increment_cou
 	state->t[1] += (state->t[0] < inc);
 }
 
-void blake2s_compress_generic(struct blake2s_state *state,const u8 *block,
+void blake2s_compress(struct blake2s_state *state, const u8 *block,
+		      size_t nblocks, const u32 inc)
+		      __weak __alias(blake2s_compress_generic);
+
+void blake2s_compress_generic(struct blake2s_state *state, const u8 *block,
 			      size_t nblocks, const u32 inc)
 {
 	u32 m[16];
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -16,12 +16,6 @@
 #include <linux/init.h>
 #include <linux/bug.h>
 
-#if IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S)
-#  define blake2s_compress blake2s_compress_arch
-#else
-#  define blake2s_compress blake2s_compress_generic
-#endif
-
 void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen)
 {
 	__blake2s_update(state, in, inlen, blake2s_compress);


