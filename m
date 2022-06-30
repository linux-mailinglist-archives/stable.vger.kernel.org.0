Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB787561D14
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbiF3OEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbiF3OEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:04:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7A96B27D;
        Thu, 30 Jun 2022 06:53:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43332B82AEE;
        Thu, 30 Jun 2022 13:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C31C34115;
        Thu, 30 Jun 2022 13:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597202;
        bh=NOK3deyzweTmP82SyMHgjmHQOLCgzeZos9q8gyVnXY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRF6+dicSDywdS0f3NbMHeiUo41yEfOfdYctdpdX+CtiR5eR/6Dfhx4fmgG1UVQJT
         SL05N/85jX2znXOqie/C5H8ljkV3GO464qmBpWa0Rd5uFOYO8d3dE1mCEaa4WLTtbI
         xqp2d3ZEM8x4qaIXUkEKTxwD7WxmmtVvBbrcjWUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.4 15/16] crypto: arm - use Kconfig based compiler checks for crypto opcodes
Date:   Thu, 30 Jun 2022 15:47:09 +0200
Message-Id: <20220630133231.387361480@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133230.936488203@linuxfoundation.org>
References: <20220630133230.936488203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit b4d0c0aad57ac3bd1b5141bac5ab1ab1d5e442b3 upstream

Instead of allowing the Crypto Extensions algorithms to be selected when
using a toolchain that does not support them, and complain about it at
build time, use the information we have about the compiler to prevent
them from being selected in the first place. Users that are stuck with
a GCC version <4.8 are unlikely to care about these routines anyway, and
it cleans up the Makefile considerably.

While at it, add explicit 'armv8-a' CPU specifiers to the code that uses
the 'crypto-neon-fp-armv8' FPU specifier so we don't regress Clang, which
will complain about this in version 10 and later.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/crypto/Kconfig             |   14 ++++++++------
 arch/arm/crypto/Makefile            |   32 ++++++--------------------------
 arch/arm/crypto/crct10dif-ce-core.S |    2 +-
 arch/arm/crypto/ghash-ce-core.S     |    1 +
 arch/arm/crypto/sha1-ce-core.S      |    1 +
 arch/arm/crypto/sha2-ce-core.S      |    1 +
 6 files changed, 18 insertions(+), 33 deletions(-)

--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -30,7 +30,7 @@ config CRYPTO_SHA1_ARM_NEON
 
 config CRYPTO_SHA1_ARM_CE
 	tristate "SHA1 digest algorithm (ARM v8 Crypto Extensions)"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
 	select CRYPTO_SHA1_ARM
 	select CRYPTO_HASH
 	help
@@ -39,7 +39,7 @@ config CRYPTO_SHA1_ARM_CE
 
 config CRYPTO_SHA2_ARM_CE
 	tristate "SHA-224/256 digest algorithm (ARM v8 Crypto Extensions)"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
 	select CRYPTO_SHA256_ARM
 	select CRYPTO_HASH
 	help
@@ -96,7 +96,7 @@ config CRYPTO_AES_ARM_BS
 
 config CRYPTO_AES_ARM_CE
 	tristate "Accelerated AES using ARMv8 Crypto Extensions"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_LIB_AES
 	select CRYPTO_SIMD
@@ -106,7 +106,7 @@ config CRYPTO_AES_ARM_CE
 
 config CRYPTO_GHASH_ARM_CE
 	tristate "PMULL-accelerated GHASH using NEON/ARMv8 Crypto Extensions"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
 	select CRYPTO_HASH
 	select CRYPTO_CRYPTD
 	select CRYPTO_GF128MUL
@@ -118,12 +118,14 @@ config CRYPTO_GHASH_ARM_CE
 
 config CRYPTO_CRCT10DIF_ARM_CE
 	tristate "CRCT10DIF digest algorithm using PMULL instructions"
-	depends on KERNEL_MODE_NEON && CRC_T10DIF
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
+	depends on CRC_T10DIF
 	select CRYPTO_HASH
 
 config CRYPTO_CRC32_ARM_CE
 	tristate "CRC32(C) digest algorithm using CRC and/or PMULL instructions"
-	depends on KERNEL_MODE_NEON && CRC32
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
+	depends on CRC32
 	select CRYPTO_HASH
 
 config CRYPTO_CHACHA20_NEON
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -12,32 +12,12 @@ obj-$(CONFIG_CRYPTO_SHA512_ARM) += sha51
 obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha-neon.o
 obj-$(CONFIG_CRYPTO_NHPOLY1305_NEON) += nhpoly1305-neon.o
 
-ce-obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_SHA2_ARM_CE) += sha2-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_CRCT10DIF_ARM_CE) += crct10dif-arm-ce.o
-crc-obj-$(CONFIG_CRYPTO_CRC32_ARM_CE) += crc32-arm-ce.o
-
-ifneq ($(crc-obj-y)$(crc-obj-m),)
-ifeq ($(call as-instr,.arch armv8-a\n.arch_extension crc,y,n),y)
-ce-obj-y += $(crc-obj-y)
-ce-obj-m += $(crc-obj-m)
-else
-$(warning These CRC Extensions modules need binutils 2.23 or higher)
-$(warning $(crc-obj-y) $(crc-obj-m))
-endif
-endif
-
-ifneq ($(ce-obj-y)$(ce-obj-m),)
-ifeq ($(call as-instr,.fpu crypto-neon-fp-armv8,y,n),y)
-obj-y += $(ce-obj-y)
-obj-m += $(ce-obj-m)
-else
-$(warning These ARMv8 Crypto Extensions modules need binutils 2.23 or higher)
-$(warning $(ce-obj-y) $(ce-obj-m))
-endif
-endif
+obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
+obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
+obj-$(CONFIG_CRYPTO_SHA2_ARM_CE) += sha2-arm-ce.o
+obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
+obj-$(CONFIG_CRYPTO_CRCT10DIF_ARM_CE) += crct10dif-arm-ce.o
+obj-$(CONFIG_CRYPTO_CRC32_ARM_CE) += crc32-arm-ce.o
 
 aes-arm-y	:= aes-cipher-core.o aes-cipher-glue.o
 aes-arm-bs-y	:= aes-neonbs-core.o aes-neonbs-glue.o
--- a/arch/arm/crypto/crct10dif-ce-core.S
+++ b/arch/arm/crypto/crct10dif-ce-core.S
@@ -72,7 +72,7 @@
 #endif
 
 	.text
-	.arch		armv7-a
+	.arch		armv8-a
 	.fpu		crypto-neon-fp-armv8
 
 	init_crc	.req	r0
--- a/arch/arm/crypto/ghash-ce-core.S
+++ b/arch/arm/crypto/ghash-ce-core.S
@@ -88,6 +88,7 @@
 	T3_H		.req	d17
 
 	.text
+	.arch		armv8-a
 	.fpu		crypto-neon-fp-armv8
 
 	.macro		__pmull_p64, rd, rn, rm, b1, b2, b3, b4
--- a/arch/arm/crypto/sha1-ce-core.S
+++ b/arch/arm/crypto/sha1-ce-core.S
@@ -10,6 +10,7 @@
 #include <asm/assembler.h>
 
 	.text
+	.arch		armv8-a
 	.fpu		crypto-neon-fp-armv8
 
 	k0		.req	q0
--- a/arch/arm/crypto/sha2-ce-core.S
+++ b/arch/arm/crypto/sha2-ce-core.S
@@ -10,6 +10,7 @@
 #include <asm/assembler.h>
 
 	.text
+	.arch		armv8-a
 	.fpu		crypto-neon-fp-armv8
 
 	k0		.req	q7


