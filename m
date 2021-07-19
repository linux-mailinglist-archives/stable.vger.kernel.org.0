Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09E43CDAA4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244168AbhGSOgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:36:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244309AbhGSOfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:35:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2FCD61186;
        Mon, 19 Jul 2021 15:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707780;
        bh=4ZnzUUKSz85sl/IAufS0xM2QhkVjHpaSanDIfksVdXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CYyq+h46OSytvVxrnO5/GtMOmt3Kv8OaqznEWYQ3nT5fac0G0NR74/ovFLGk9FvOu
         DtpJ7ATW4ZZz0E7Dxvp8D8qUmdXVF35CoMOxjnJqgORqki7FFK0tpVEUEMClWWYu9N
         6NYmDa3S/NPV3ZDMFvvaZ3P/UIVh8N3GKDz3cibM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 053/315] crypto: shash - avoid comparing pointers to exported functions under CFI
Date:   Mon, 19 Jul 2021 16:49:02 +0200
Message-Id: <20210719144944.608777891@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 22ca9f4aaf431a9413dcc115dd590123307f274f ]

crypto_shash_alg_has_setkey() is implemented by testing whether the
.setkey() member of a struct shash_alg points to the default version,
called shash_no_setkey(). As crypto_shash_alg_has_setkey() is a static
inline, this requires shash_no_setkey() to be exported to modules.

Unfortunately, when building with CFI, function pointers are routed
via CFI stubs which are private to each module (or to the kernel proper)
and so this function pointer comparison may fail spuriously.

Let's fix this by turning crypto_shash_alg_has_setkey() into an out of
line function.

Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/shash.c                 | 18 +++++++++++++++---
 include/crypto/internal/hash.h |  8 +-------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index a04145e5306a..55e7a2f63b34 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -25,12 +25,24 @@
 
 static const struct crypto_type crypto_shash_type;
 
-int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
-		    unsigned int keylen)
+static int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
+			   unsigned int keylen)
 {
 	return -ENOSYS;
 }
-EXPORT_SYMBOL_GPL(shash_no_setkey);
+
+/*
+ * Check whether an shash algorithm has a setkey function.
+ *
+ * For CFI compatibility, this must not be an inline function.  This is because
+ * when CFI is enabled, modules won't get the same address for shash_no_setkey
+ * (if it were exported, which inlining would require) as the core kernel will.
+ */
+bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
+{
+	return alg->setkey != shash_no_setkey;
+}
+EXPORT_SYMBOL_GPL(crypto_shash_alg_has_setkey);
 
 static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
 				  unsigned int keylen)
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 27040a46d50a..556b40fee2d1 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -82,13 +82,7 @@ int ahash_register_instance(struct crypto_template *tmpl,
 			    struct ahash_instance *inst);
 void ahash_free_instance(struct crypto_instance *inst);
 
-int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
-		    unsigned int keylen);
-
-static inline bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
-{
-	return alg->setkey != shash_no_setkey;
-}
+bool crypto_shash_alg_has_setkey(struct shash_alg *alg);
 
 bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg);
 
-- 
2.30.2



