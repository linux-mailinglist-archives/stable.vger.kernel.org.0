Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0A3E1E579
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 01:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfENXOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 19:14:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbfENXOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 19:14:49 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9468420873;
        Tue, 14 May 2019 23:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557875688;
        bh=62wRBq+vd5/3w97GewxX5Jxc2LoBBdS+JqDvjbZG5RQ=;
        h=From:To:Cc:Subject:Date:From;
        b=byZseif7A6jI4T+UQ/x6vute/lg0qIVNK4Bt5OH7qEXCduhxKfGkfnPskAYTmxeg1
         l0jUNlybRTmFoeeD4XggfBHvC+foTdSD8ocMr6hhr0o2STCRfCd4H07LWZ35ydWPoQ
         cP1dR2GFfWJf4UY2cUHHyysPkxknJSFumQRCWrVM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] crypto: hash - fix incorrect HASH_MAX_DESCSIZE
Date:   Tue, 14 May 2019 16:13:15 -0700
Message-Id: <20190514231315.7729-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

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
---
 crypto/hmac.c         | 2 ++
 include/crypto/hash.h | 8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index a68c1266121f5..241b1868c1d01 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -157,6 +157,8 @@ static int hmac_init_tfm(struct crypto_tfm *tfm)
 
 	parent->descsize = sizeof(struct shash_desc) +
 			   crypto_shash_descsize(hash);
+	if (WARN_ON(parent->descsize > HASH_MAX_DESCSIZE))
+		return -EINVAL;
 
 	ctx->hash = hash;
 	return 0;
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index d21bea2c43829..d6702b4a457f9 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -150,7 +150,13 @@ struct shash_desc {
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
-- 
2.21.0.1020.gf2820cf01a-goog

