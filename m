Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21909592E96
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 14:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbiHOMBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 08:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHOMBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 08:01:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0A522B3F
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 05:01:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF74AB80E87
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 12:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A611C433D6;
        Mon, 15 Aug 2022 12:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660564890;
        bh=KoO9nrZJtkLNtpZ/FUYGogaPcABcfd+c9Ov+iJ8mna0=;
        h=Subject:To:Cc:From:Date:From;
        b=CCMqkFOT/Q/CfZ+0PmUzjq1ZjFtu5/ksj5uplRYCHLQMaCOt+NK7t9co4wDztZt7U
         1vcGYW4HdWd2j+115nYTtyzRx1GynaINC9UhK07sFO+dgAY0kD34j5Ie3gE21PJChT
         DW05blmy/jc2o1zLXD7zUipGMNcgCfQk/MXGfbKc=
Subject: FAILED: patch "[PATCH] crypto: memneq - move into lib/" failed to apply to 5.18-stable tree
To:     Jason@zx2c4.com, ebiggers@google.com, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, zhengbin13@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 14:01:19 +0200
Message-ID: <166056487953203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 920b0442b9f884f55f4745b53430c80e71e90275 Mon Sep 17 00:00:00 2001
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 28 May 2022 12:24:29 +0200
Subject: [PATCH] crypto: memneq - move into lib/

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
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9b654984de79..6e30e8138057 100644
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
index 3bbc0dd49160..1f529704fe80 100644
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
index ea54294d73bf..f99bf61f8bbc 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -251,6 +251,7 @@ obj-$(CONFIG_DIMLIB) += dim/
 obj-$(CONFIG_SIGNATURE) += digsig.o
 
 lib-$(CONFIG_CLZ_TAB) += clz_tab.o
+lib-$(CONFIG_LIB_MEMNEQ) += memneq.o
 
 obj-$(CONFIG_GENERIC_STRNCPY_FROM_USER) += strncpy_from_user.o
 obj-$(CONFIG_GENERIC_STRNLEN_USER) += strnlen_user.o
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 9856e291f414..2082af43d51f 100644
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

