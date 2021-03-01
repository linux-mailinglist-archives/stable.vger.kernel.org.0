Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F11328954
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238397AbhCARzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:55:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238970AbhCARtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:49:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19CAD650E6;
        Mon,  1 Mar 2021 16:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617989;
        bh=sTMTOH1a9bWdZBA7rXXjxIeWPEp360MpiNzx+8H/OqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBjEEqunkFnrylwFGuAv9YebB+n/fc9snMUgS1WBTmgZC/vRvGtbK6sUekCnLHrwL
         zY8aDSBRFFqBaFHxmEyZKKZOFPU/30C9TuLQnqt8kJ8n9oTa4JC8oJP9p6B+1Fr9j9
         C8HU1Aa3PEcYw+Mz+MmTlsgDhtshzeHVqSh+KNu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 269/340] crypto: arm64/sha - add missing module aliases
Date:   Mon,  1 Mar 2021 17:13:33 +0100
Message-Id: <20210301161101.535399037@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 0df07d8117c3576f1603b05b84089742a118d10a upstream.

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
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/crypto/sha1-ce-glue.c   |    1 +
 arch/arm64/crypto/sha2-ce-glue.c   |    2 ++
 arch/arm64/crypto/sha3-ce-glue.c   |    4 ++++
 arch/arm64/crypto/sha512-ce-glue.c |    2 ++
 4 files changed, 9 insertions(+)

--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -19,6 +19,7 @@
 MODULE_DESCRIPTION("SHA1 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("sha1");
 
 struct sha1_ce_state {
 	struct sha1_state	sst;
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


