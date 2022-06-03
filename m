Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371DB53CF38
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiFCRxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346561AbiFCRvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:51:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864465520E;
        Fri,  3 Jun 2022 10:48:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 494D8B8241D;
        Fri,  3 Jun 2022 17:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9546FC385A9;
        Fri,  3 Jun 2022 17:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278514;
        bh=UJYQLVdpOQK+wV5KF+SBi3wrp+2pt2j7/nnYiN29v3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=moQ5wZpeqw4KKNs7aGM1MeNSDpfthuKG8heYj3sLPTjG86QGwyL/ukKMgtX9yUNj1
         fjnB5O7ikbs98RieOfQSf6cqCtmM/HTJgRdN4C2HHqlzxBLufovxcdEuY7PtCSS4Dt
         LzmFI4ptCU/RKJTKFYlpP8dBvFT/fZsqF/YKeKe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        "Justin M. Forbes" <jforbes@fedoraproject.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 24/53] lib/crypto: add prompts back to crypto libraries
Date:   Fri,  3 Jun 2022 19:43:09 +0200
Message-Id: <20220603173819.429401098@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173818.716010877@linuxfoundation.org>
References: <20220603173818.716010877@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Justin M. Forbes" <jforbes@fedoraproject.org>

commit e56e18985596617ae426ed5997fb2e737cffb58b upstream.

Commit 6048fdcc5f269 ("lib/crypto: blake2s: include as built-in") took
away a number of prompt texts from other crypto libraries. This makes
values flip from built-in to module when oldconfig runs, and causes
problems when these crypto libs need to be built in for thingslike
BIG_KEYS.

Fixes: 6048fdcc5f269 ("lib/crypto: blake2s: include as built-in")
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
[Jason: - moved menu into submenu of lib/ instead of root menu
        - fixed chacha sub-dependencies for CONFIG_CRYPTO]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/Kconfig     |    2 --
 lib/Kconfig        |    2 ++
 lib/crypto/Kconfig |   17 ++++++++++++-----
 3 files changed, 14 insertions(+), 7 deletions(-)

--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1941,5 +1941,3 @@ source "crypto/asymmetric_keys/Kconfig"
 source "certs/Kconfig"
 
 endif	# if CRYPTO
-
-source "lib/crypto/Kconfig"
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -101,6 +101,8 @@ config INDIRECT_PIO
 
 	  When in doubt, say N.
 
+source "lib/crypto/Kconfig"
+
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+menu "Crypto library routines"
+
 config CRYPTO_LIB_AES
 	tristate
 
@@ -31,7 +33,7 @@ config CRYPTO_ARCH_HAVE_LIB_CHACHA
 
 config CRYPTO_LIB_CHACHA_GENERIC
 	tristate
-	select CRYPTO_ALGAPI
+	select XOR_BLOCKS
 	help
 	  This symbol can be depended upon by arch implementations of the
 	  ChaCha library interface that require the generic code as a
@@ -40,7 +42,8 @@ config CRYPTO_LIB_CHACHA_GENERIC
 	  of CRYPTO_LIB_CHACHA.
 
 config CRYPTO_LIB_CHACHA
-	tristate
+	tristate "ChaCha library interface"
+	depends on CRYPTO
 	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
 	select CRYPTO_LIB_CHACHA_GENERIC if CRYPTO_ARCH_HAVE_LIB_CHACHA=n
 	help
@@ -65,7 +68,7 @@ config CRYPTO_LIB_CURVE25519_GENERIC
 	  of CRYPTO_LIB_CURVE25519.
 
 config CRYPTO_LIB_CURVE25519
-	tristate
+	tristate "Curve25519 scalar multiplication library"
 	depends on CRYPTO_ARCH_HAVE_LIB_CURVE25519 || !CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	select CRYPTO_LIB_CURVE25519_GENERIC if CRYPTO_ARCH_HAVE_LIB_CURVE25519=n
 	help
@@ -100,7 +103,7 @@ config CRYPTO_LIB_POLY1305_GENERIC
 	  of CRYPTO_LIB_POLY1305.
 
 config CRYPTO_LIB_POLY1305
-	tristate
+	tristate "Poly1305 library interface"
 	depends on CRYPTO_ARCH_HAVE_LIB_POLY1305 || !CRYPTO_ARCH_HAVE_LIB_POLY1305
 	select CRYPTO_LIB_POLY1305_GENERIC if CRYPTO_ARCH_HAVE_LIB_POLY1305=n
 	help
@@ -109,11 +112,15 @@ config CRYPTO_LIB_POLY1305
 	  is available and enabled.
 
 config CRYPTO_LIB_CHACHA20POLY1305
-	tristate
+	tristate "ChaCha20-Poly1305 AEAD support (8-byte nonce library version)"
 	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
 	depends on CRYPTO_ARCH_HAVE_LIB_POLY1305 || !CRYPTO_ARCH_HAVE_LIB_POLY1305
+	depends on CRYPTO
 	select CRYPTO_LIB_CHACHA
 	select CRYPTO_LIB_POLY1305
+	select CRYPTO_ALGAPI
 
 config CRYPTO_LIB_SHA256
 	tristate
+
+endmenu


