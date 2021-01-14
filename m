Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F112F692A
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 19:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbhANSLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 13:11:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727812AbhANSLB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 13:11:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7176823A50;
        Thu, 14 Jan 2021 18:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610647820;
        bh=iPvInt/18wfenfRpRIABpAVRrPwDeqjsfuBcYxosZKM=;
        h=From:To:Cc:Subject:Date:From;
        b=G25lc5MHzetvBLQLWTMT58pZnwi0c9h4Ta+BjQnSfKRUDuORlUP8pPfpGyeMYNOVj
         di+r6Ypnm5LSzmIAdPt598PoBh3l4T9/AS/OHhZQ8HP5yrDBJbZsgQubB2Gxj7wwvb
         6c7F6Z1/RrnS6IHvjYDcq0QZ/pYyOa7mno3fKrVOfuveTGC3tefBFFdBOqbQV097S1
         82r2wwMHmNtlrItj/Kg6m0D2ic3Bsrbja5XvoILMKNnkcsk4/qO26UZTKJ3uaKkSYD
         b2HIZmXDITP4UIqmidAaiI81XMx7vuzDXME7W5CfiBdJWjX2IBSnrR1c0Og9p186qb
         5x3ChjLNKXfQg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] crypto: arm64/sha - add missing module aliases
Date:   Thu, 14 Jan 2021 19:10:10 +0100
Message-Id: <20210114181010.17187-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The accelerated, instruction based implementations of SHA1, SHA2 and
SHA3 are autoloaded based on CPU capabilities, given that the code is
modest in size, and widely used, which means that resolving the algo
name, loading all compatible modules and picking the one with the
highest priority is taken to be suboptimal.

However, if these algorithms are requested before this CPU feature
based matching and autoloading occurs, these modules are not even
considered, and we end up with suboptimal performance.

So add the missing module aliases for the various SHA implementations.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/sha1-ce-glue.c   | 1 +
 arch/arm64/crypto/sha2-ce-glue.c   | 2 ++
 arch/arm64/crypto/sha3-ce-glue.c   | 4 ++++
 arch/arm64/crypto/sha512-ce-glue.c | 2 ++
 4 files changed, 9 insertions(+)

diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index c93121bcfdeb..c1362861765f 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -19,6 +19,7 @@
 MODULE_DESCRIPTION("SHA1 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("sha1");
 
 struct sha1_ce_state {
 	struct sha1_state	sst;
diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index 31ba3da5e61b..ded3a6488f81 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -19,6 +19,8 @@
 MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("sha224");
+MODULE_ALIAS_CRYPTO("sha256");
 
 struct sha256_ce_state {
 	struct sha256_state	sst;
diff --git a/arch/arm64/crypto/sha3-ce-glue.c b/arch/arm64/crypto/sha3-ce-glue.c
index e5a2936f0886..7288d3046354 100644
--- a/arch/arm64/crypto/sha3-ce-glue.c
+++ b/arch/arm64/crypto/sha3-ce-glue.c
@@ -23,6 +23,10 @@
 MODULE_DESCRIPTION("SHA3 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("sha3-224");
+MODULE_ALIAS_CRYPTO("sha3-256");
+MODULE_ALIAS_CRYPTO("sha3-384");
+MODULE_ALIAS_CRYPTO("sha3-512");
 
 asmlinkage void sha3_ce_transform(u64 *st, const u8 *data, int blocks,
 				  int md_len);
diff --git a/arch/arm64/crypto/sha512-ce-glue.c b/arch/arm64/crypto/sha512-ce-glue.c
index faa83f6cf376..a6b1adf31c56 100644
--- a/arch/arm64/crypto/sha512-ce-glue.c
+++ b/arch/arm64/crypto/sha512-ce-glue.c
@@ -23,6 +23,8 @@
 MODULE_DESCRIPTION("SHA-384/SHA-512 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("sha384");
+MODULE_ALIAS_CRYPTO("sha512");
 
 asmlinkage void sha512_ce_transform(struct sha512_state *sst, u8 const *src,
 				    int blocks);
-- 
2.17.1

