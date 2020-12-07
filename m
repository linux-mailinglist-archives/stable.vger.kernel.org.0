Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF4F2D1787
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 18:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgLGR1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 12:27:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42642 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbgLGR1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 12:27:24 -0500
Received: from 2.general.dannf.us.vpn ([10.172.65.1] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <dann.frazier@canonical.com>)
        id 1kmKHZ-0008TW-08; Mon, 07 Dec 2020 17:26:41 +0000
From:   dann frazier <dann.frazier@canonical.com>
To:     stable@vger.kernel.org, Michael Schaller <misch@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Matthew Garrett <matthew.garrett@nebula.com>,
        Jeremy Kerr <jk@ozlabs.org>, linux-efi@vger.kernel.org
Subject: [PATCH 4.4] Revert "crypto: arm64/sha - avoid non-standard inline asm tricks"
Date:   Mon,  7 Dec 2020 10:26:25 -0700
Message-Id: <20201207172625.2888810-1-dann.frazier@canonical.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <X8yoWHNzfl7vHVRA@kroah.com>
References: <X8yoWHNzfl7vHVRA@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit c042dd600f4e89b6e7bdffa00aea4d1d3c1e9686.

This caused the build to emit ADR_PREL_PG_HI21 relocations in the sha{1,2}_ce
modules. This relocation type is not supported by the linux-4.4.y kernel
module loader when CONFIG_ARM64_ERRATUM_843419=y, which we have enabled, so
these modules now fail to load:

  [   37.866250] module sha1_ce: unsupported RELA relocation: 275

This issue does not exist with the backport to 4.9+. Bisection shows that
this is due to those kernels also having a backport of
commit 41c066f ("arm64: assembler: make adr_l work in modules under KASLR")

Signed-off-by: dann frazier <dann.frazier@canonical.com>
---
 arch/arm64/crypto/sha1-ce-core.S |  6 ++----
 arch/arm64/crypto/sha1-ce-glue.c | 11 ++++++++---
 arch/arm64/crypto/sha2-ce-core.S |  6 ++----
 arch/arm64/crypto/sha2-ce-glue.c | 13 ++++++++-----
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/crypto/sha1-ce-core.S b/arch/arm64/crypto/sha1-ce-core.S
index 8550408735a0..c98e7e849f06 100644
--- a/arch/arm64/crypto/sha1-ce-core.S
+++ b/arch/arm64/crypto/sha1-ce-core.S
@@ -82,8 +82,7 @@ ENTRY(sha1_ce_transform)
 	ldr		dgb, [x0, #16]
 
 	/* load sha1_ce_state::finalize */
-	ldr_l		w4, sha1_ce_offsetof_finalize, x4
-	ldr		w4, [x0, x4]
+	ldr		w4, [x0, #:lo12:sha1_ce_offsetof_finalize]
 
 	/* load input */
 0:	ld1		{v8.4s-v11.4s}, [x1], #64
@@ -133,8 +132,7 @@ CPU_LE(	rev32		v11.16b, v11.16b	)
 	 * the padding is handled by the C code in that case.
 	 */
 	cbz		x4, 3f
-	ldr_l		w4, sha1_ce_offsetof_count, x4
-	ldr		x4, [x0, x4]
+	ldr		x4, [x0, #:lo12:sha1_ce_offsetof_count]
 	movi		v9.2d, #0
 	mov		x8, #0x80000000
 	movi		v10.2d, #0
diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index 1b7b4684c35b..01e48b8970b1 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -17,6 +17,9 @@
 #include <linux/crypto.h>
 #include <linux/module.h>
 
+#define ASM_EXPORT(sym, val) \
+	asm(".globl " #sym "; .set " #sym ", %0" :: "I"(val));
+
 MODULE_DESCRIPTION("SHA1 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
@@ -29,9 +32,6 @@ struct sha1_ce_state {
 asmlinkage void sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
 				  int blocks);
 
-const u32 sha1_ce_offsetof_count = offsetof(struct sha1_ce_state, sst.count);
-const u32 sha1_ce_offsetof_finalize = offsetof(struct sha1_ce_state, finalize);
-
 static int sha1_ce_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
@@ -52,6 +52,11 @@ static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
 	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
 	bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE) && len;
 
+	ASM_EXPORT(sha1_ce_offsetof_count,
+		   offsetof(struct sha1_ce_state, sst.count));
+	ASM_EXPORT(sha1_ce_offsetof_finalize,
+		   offsetof(struct sha1_ce_state, finalize));
+
 	/*
 	 * Allow the asm code to perform the finalization if there is no
 	 * partial data and the input is a round multiple of the block size.
diff --git a/arch/arm64/crypto/sha2-ce-core.S b/arch/arm64/crypto/sha2-ce-core.S
index 679c6c002f4f..01cfee066837 100644
--- a/arch/arm64/crypto/sha2-ce-core.S
+++ b/arch/arm64/crypto/sha2-ce-core.S
@@ -88,8 +88,7 @@ ENTRY(sha2_ce_transform)
 	ld1		{dgav.4s, dgbv.4s}, [x0]
 
 	/* load sha256_ce_state::finalize */
-	ldr_l		w4, sha256_ce_offsetof_finalize, x4
-	ldr		w4, [x0, x4]
+	ldr		w4, [x0, #:lo12:sha256_ce_offsetof_finalize]
 
 	/* load input */
 0:	ld1		{v16.4s-v19.4s}, [x1], #64
@@ -137,8 +136,7 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 	 * the padding is handled by the C code in that case.
 	 */
 	cbz		x4, 3f
-	ldr_l		w4, sha256_ce_offsetof_count, x4
-	ldr		x4, [x0, x4]
+	ldr		x4, [x0, #:lo12:sha256_ce_offsetof_count]
 	movi		v17.2d, #0
 	mov		x8, #0x80000000
 	movi		v18.2d, #0
diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index 356ca9397a86..7a7f95b94869 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -17,6 +17,9 @@
 #include <linux/crypto.h>
 #include <linux/module.h>
 
+#define ASM_EXPORT(sym, val) \
+	asm(".globl " #sym "; .set " #sym ", %0" :: "I"(val));
+
 MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
@@ -29,11 +32,6 @@ struct sha256_ce_state {
 asmlinkage void sha2_ce_transform(struct sha256_ce_state *sst, u8 const *src,
 				  int blocks);
 
-const u32 sha256_ce_offsetof_count = offsetof(struct sha256_ce_state,
-					      sst.count);
-const u32 sha256_ce_offsetof_finalize = offsetof(struct sha256_ce_state,
-						 finalize);
-
 static int sha256_ce_update(struct shash_desc *desc, const u8 *data,
 			    unsigned int len)
 {
@@ -54,6 +52,11 @@ static int sha256_ce_finup(struct shash_desc *desc, const u8 *data,
 	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
 	bool finalize = !sctx->sst.count && !(len % SHA256_BLOCK_SIZE) && len;
 
+	ASM_EXPORT(sha256_ce_offsetof_count,
+		   offsetof(struct sha256_ce_state, sst.count));
+	ASM_EXPORT(sha256_ce_offsetof_finalize,
+		   offsetof(struct sha256_ce_state, finalize));
+
 	/*
 	 * Allow the asm code to perform the finalization if there is no
 	 * partial data and the input is a round multiple of the block size.
-- 
2.29.2

