Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2110B2F6B9
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388890AbfE3E6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727745AbfE3DJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:46 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FADE2447C;
        Thu, 30 May 2019 03:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185784;
        bh=jRbH94i8EEbsYSk00/p/DOZAUYbkLLbNDdJOKu9f+1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGdYiR8iOWjuRslxAGYtV4xXyLOHEVZIaonIeEK/aCT2D/I9l0uogCzSJQCyZXI5v
         A/w8xdaX85GBVLlABwhx7IiRZSD3fJuyUfJK0eo9E01wOtEQOscxOuknBfAmwvAGs4
         e2ds9YmBM/M8TkEAhp5cPsBKDlQ89HPBwkSXyUqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.1 009/405] crypto: hash - fix incorrect HASH_MAX_DESCSIZE
Date:   Wed, 29 May 2019 20:00:07 -0700
Message-Id: <20190530030540.874518385@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit e1354400b25da645c4764ed6844d12f1582c3b66 upstream.

The "hmac(sha3-224-generic)" algorithm has a descsize of 368 bytes,
which is greater than HASH_MAX_DESCSIZE (360) which is only enough for
sha3-224-generic.  The check in shash_prepare_alg() doesn't catch this
because the HMAC template doesn't set descsize on the algorithms, but
rather sets it on each individual HMAC transform.

This causes a stack buffer overflow when SHASH_DESC_ON_STACK() is used
with hmac(sha3-224-generic).

Fix it by increasing HASH_MAX_DESCSIZE to the real maximum.  Also add a
sanity check to hmac_init().

This was detected by the improved crypto self-tests in v5.2, by loading
the tcrypt module with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y enabled.  I
didn't notice this bug when I ran the self-tests by requesting the
algorithms via AF_ALG (i.e., not using tcrypt), probably because the
stack layout differs in the two cases and that made a difference here.

KASAN report:

    BUG: KASAN: stack-out-of-bounds in memcpy include/linux/string.h:359 [inline]
    BUG: KASAN: stack-out-of-bounds in shash_default_import+0x52/0x80 crypto/shash.c:223
    Write of size 360 at addr ffff8880651defc8 by task insmod/3689

    CPU: 2 PID: 3689 Comm: insmod Tainted: G            E     5.1.0-10741-g35c99ffa20edd #11
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
    Call Trace:
     __dump_stack lib/dump_stack.c:77 [inline]
     dump_stack+0x86/0xc5 lib/dump_stack.c:113
     print_address_description+0x7f/0x260 mm/kasan/report.c:188
     __kasan_report+0x144/0x187 mm/kasan/report.c:317
     kasan_report+0x12/0x20 mm/kasan/common.c:614
     check_memory_region_inline mm/kasan/generic.c:185 [inline]
     check_memory_region+0x137/0x190 mm/kasan/generic.c:191
     memcpy+0x37/0x50 mm/kasan/common.c:125
     memcpy include/linux/string.h:359 [inline]
     shash_default_import+0x52/0x80 crypto/shash.c:223
     crypto_shash_import include/crypto/hash.h:880 [inline]
     hmac_import+0x184/0x240 crypto/hmac.c:102
     hmac_init+0x96/0xc0 crypto/hmac.c:107
     crypto_shash_init include/crypto/hash.h:902 [inline]
     shash_digest_unaligned+0x9f/0xf0 crypto/shash.c:194
     crypto_shash_digest+0xe9/0x1b0 crypto/shash.c:211
     generate_random_hash_testvec.constprop.11+0x1ec/0x5b0 crypto/testmgr.c:1331
     test_hash_vs_generic_impl+0x3f7/0x5c0 crypto/testmgr.c:1420
     __alg_test_hash+0x26d/0x340 crypto/testmgr.c:1502
     alg_test_hash+0x22e/0x330 crypto/testmgr.c:1552
     alg_test.part.7+0x132/0x610 crypto/testmgr.c:4931
     alg_test+0x1f/0x40 crypto/testmgr.c:4952

Fixes: b68a7ec1e9a3 ("crypto: hash - Remove VLA usage")
Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: <stable@vger.kernel.org> # v4.20+
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/hmac.c         |    2 ++
 include/crypto/hash.h |    8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -168,6 +168,8 @@ static int hmac_init_tfm(struct crypto_t
 
 	parent->descsize = sizeof(struct shash_desc) +
 			   crypto_shash_descsize(hash);
+	if (WARN_ON(parent->descsize > HASH_MAX_DESCSIZE))
+		return -EINVAL;
 
 	ctx->hash = hash;
 	return 0;
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -152,7 +152,13 @@ struct shash_desc {
 };
 
 #define HASH_MAX_DIGESTSIZE	 64
-#define HASH_MAX_DESCSIZE	360
+
+/*
+ * Worst case is hmac(sha3-224-generic).  Its context is a nested 'shash_desc'
+ * containing a 'struct sha3_state'.
+ */
+#define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 360)
+
 #define HASH_MAX_STATESIZE	512
 
 #define SHASH_DESC_ON_STACK(shash, ctx)				  \


