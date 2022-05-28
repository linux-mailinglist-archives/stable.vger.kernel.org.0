Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B90536C4B
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 12:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbiE1KYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 06:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiE1KYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 06:24:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC902618;
        Sat, 28 May 2022 03:24:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8992360DB6;
        Sat, 28 May 2022 10:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329ECC34100;
        Sat, 28 May 2022 10:24:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="l7vpP9LP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1653733489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ilJONe0tMPd3rARKJSnYcnn/Wg6UEmJQnFGT2GeNaZw=;
        b=l7vpP9LPLvjnDaqvYkk9EqgjqdfbJkS4hSmHGgANqR18oYZuupTKWoss8ZFgcGNKt20q/T
        qbvr9DZU+KlHqtzfY1G0vh5nNcWR26BJiura9Nix+vYUxT6Fx8C0y7Rss+QD48Et6/75hk
        RZqJxDBE1GeyfTVsHzNIP+5u6AV4stQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 68b8dd6e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 28 May 2022 10:24:49 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Zheng Bin <zhengbin13@huawei.com>,
        Eric Biggers <ebiggers@kernel.org>, stable@vger.kernel.org
Subject: [PATCH crypto] crypto: memneq - move into lib/
Date:   Sat, 28 May 2022 12:24:29 +0200
Message-Id: <20220528102429.189731-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9rWfUnUmHR5xo_+WdS0Wgv8yXQb+LqAo24XdoQQR4Wn8w@mail.gmail.com>
References: <CAHmME9rWfUnUmHR5xo_+WdS0Wgv8yXQb+LqAo24XdoQQR4Wn8w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is used by code that doesn't need CONFIG_CRYPTO, so move this into
lib/ with a Kconfig option so that it can be selected by whatever needs
it.

This fixes a linker error Zheng pointed out when
CRYPTO_MANAGER_DISABLE_TESTS!=y and CRYPTO=m:

  lib/crypto/curve25519-selftest.o: In function `curve25519_selftest':
  curve25519-selftest.c:(.init.text+0x60): undefined reference to `__crypto_memneq'
  curve25519-selftest.c:(.init.text+0xec): undefined reference to `__crypto_memneq'
  curve25519-selftest.c:(.init.text+0x114): undefined reference to `__crypto_memneq'
  curve25519-selftest.c:(.init.text+0x154): undefined reference to `__crypto_memneq'

Reported-by: Zheng Bin <zhengbin13@huawei.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org
Fixes: aa127963f1ca ("crypto: lib/curve25519 - re-add selftests")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
I'm traveling over the next week, and there are a few ways to skin this
cat, so if somebody here sees issue, feel free to pick this v1 up and
fashion a v2 out of it.

 crypto/Kconfig           | 1 +
 crypto/Makefile          | 2 +-
 lib/Kconfig              | 3 +++
 lib/Makefile             | 1 +
 lib/crypto/Kconfig       | 1 +
 {crypto => lib}/memneq.c | 0
 6 files changed, 7 insertions(+), 1 deletion(-)
 rename {crypto => lib}/memneq.c (100%)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index f567271ed10d..38601a072b99 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -15,6 +15,7 @@ source "crypto/async_tx/Kconfig"
 #
 menuconfig CRYPTO
 	tristate "Cryptographic API"
+	select LIB_MEMNEQ
 	help
 	  This option provides the core Cryptographic API.
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 40d4c2690a49..dbfa53567c92 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -4,7 +4,7 @@
 #
 
 obj-$(CONFIG_CRYPTO) += crypto.o
-crypto-y := api.o cipher.o compress.o memneq.o
+crypto-y := api.o cipher.o compress.o
 
 obj-$(CONFIG_CRYPTO_ENGINE) += crypto_engine.o
 obj-$(CONFIG_CRYPTO_FIPS) += fips.o
diff --git a/lib/Kconfig b/lib/Kconfig
index 6a843639814f..eaaad4d85bf2 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -120,6 +120,9 @@ config INDIRECT_IOMEM_FALLBACK
 
 source "lib/crypto/Kconfig"
 
+config LIB_MEMNEQ
+	bool
+
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
diff --git a/lib/Makefile b/lib/Makefile
index 89fcae891361..f01023cda508 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -251,6 +251,7 @@ obj-$(CONFIG_DIMLIB) += dim/
 obj-$(CONFIG_SIGNATURE) += digsig.o
 
 lib-$(CONFIG_CLZ_TAB) += clz_tab.o
+lib-$(CONFIG_LIB_MEMNEQ) += memneq.o
 
 obj-$(CONFIG_GENERIC_STRNCPY_FROM_USER) += strncpy_from_user.o
 obj-$(CONFIG_GENERIC_STRNLEN_USER) += strnlen_user.o
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 7ee13c08c970..337d6852643a 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -71,6 +71,7 @@ config CRYPTO_LIB_CURVE25519
 	tristate "Curve25519 scalar multiplication library"
 	depends on CRYPTO_ARCH_HAVE_LIB_CURVE25519 || !CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	select CRYPTO_LIB_CURVE25519_GENERIC if CRYPTO_ARCH_HAVE_LIB_CURVE25519=n
+	select LIB_MEMNEQ
 	help
 	  Enable the Curve25519 library interface. This interface may be
 	  fulfilled by either the generic implementation or an arch-specific
diff --git a/crypto/memneq.c b/lib/memneq.c
similarity index 100%
rename from crypto/memneq.c
rename to lib/memneq.c
-- 
2.35.1

