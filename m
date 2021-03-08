Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF8A330E22
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhCHMfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231864AbhCHMfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:35:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8086651C9;
        Mon,  8 Mar 2021 12:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206913;
        bh=YDVCP2lX8XkTA53jIjKsJ0XzxGvlpkbhjDHf1OVepeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LhcbSqSXfd2HcXhfiqfOJ8s0/JJcpZetfYcnufefvuw2CKilEONZfWHpR6zNRU1mG
         1xy+gUT4K6Cw8On5Jc/UuUUasVJ/p3oAmVXsZiV4IdeUu1SvEa2rvM7tMQ8ii4AgX3
         ruZSDvF4s5brOeUerejRwh0c4ggj7o4YPEwxBkUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 23/42] crypto - shash: reduce minimum alignment of shash_desc structure
Date:   Mon,  8 Mar 2021 13:30:49 +0100
Message-Id: <20210308122719.264148779@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 660d2062190db131d2feaf19914e90f868fe285c upstream.

Unlike many other structure types defined in the crypto API, the
'shash_desc' structure is permitted to live on the stack, which
implies its contents may not be accessed by DMA masters. (This is
due to the fact that the stack may be located in the vmalloc area,
which requires a different virtual-to-physical translation than the
one implemented by the DMA subsystem)

Our definition of CRYPTO_MINALIGN_ATTR is based on ARCH_KMALLOC_MINALIGN,
which may take DMA constraints into account on architectures that support
non-cache coherent DMA such as ARM and arm64. In this case, the value is
chosen to reflect the largest cacheline size in the system, in order to
ensure that explicit cache maintenance as required by non-coherent DMA
masters does not affect adjacent, unrelated slab allocations. On arm64,
this value is currently set at 128 bytes.

This means that applying CRYPTO_MINALIGN_ATTR to struct shash_desc is both
unnecessary (as it is never used for DMA), and undesirable, given that it
wastes stack space (on arm64, performing the alignment costs 112 bytes in
the worst case, and the hole between the 'tfm' and '__ctx' members takes
up another 120 bytes, resulting in an increased stack footprint of up to
232 bytes.) So instead, let's switch to the minimum SLAB alignment, which
does not take DMA constraints into account.

Note that this is a no-op for x86.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/crypto/hash.h  |    8 ++++----
 include/linux/crypto.h |    9 ++++++---
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -149,7 +149,7 @@ struct ahash_alg {
 
 struct shash_desc {
 	struct crypto_shash *tfm;
-	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+	void *__ctx[] __aligned(ARCH_SLAB_MINALIGN);
 };
 
 #define HASH_MAX_DIGESTSIZE	 64
@@ -162,9 +162,9 @@ struct shash_desc {
 
 #define HASH_MAX_STATESIZE	512
 
-#define SHASH_DESC_ON_STACK(shash, ctx)				  \
-	char __##shash##_desc[sizeof(struct shash_desc) +	  \
-		HASH_MAX_DESCSIZE] CRYPTO_MINALIGN_ATTR; \
+#define SHASH_DESC_ON_STACK(shash, ctx)					     \
+	char __##shash##_desc[sizeof(struct shash_desc) + HASH_MAX_DESCSIZE] \
+		__aligned(__alignof__(struct shash_desc));		     \
 	struct shash_desc *shash = (struct shash_desc *)__##shash##_desc
 
 /**
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -151,9 +151,12 @@
  * The macro CRYPTO_MINALIGN_ATTR (along with the void * type in the actual
  * declaration) is used to ensure that the crypto_tfm context structure is
  * aligned correctly for the given architecture so that there are no alignment
- * faults for C data types.  In particular, this is required on platforms such
- * as arm where pointers are 32-bit aligned but there are data types such as
- * u64 which require 64-bit alignment.
+ * faults for C data types.  On architectures that support non-cache coherent
+ * DMA, such as ARM or arm64, it also takes into account the minimal alignment
+ * that is required to ensure that the context struct member does not share any
+ * cachelines with the rest of the struct. This is needed to ensure that cache
+ * maintenance for non-coherent DMA (cache invalidation in particular) does not
+ * affect data that may be accessed by the CPU concurrently.
  */
 #define CRYPTO_MINALIGN ARCH_KMALLOC_MINALIGN
 


