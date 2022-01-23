Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10424972FB
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 17:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiAWQXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 11:23:02 -0500
Received: from phobos.denx.de ([85.214.62.61]:56550 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234470AbiAWQXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Jan 2022 11:23:02 -0500
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 9DF7A801FB;
        Sun, 23 Jan 2022 17:22:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1642954980;
        bh=mbsdXXgIXdMdv7JB7X9Uf0bxUsnnUq6EoJ9wXuDyG4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XfQzBwRgqo3Brq0Fa73ype5OaoYQIVj3d70oN1jvIu5DI6TQKEaYDUgavLsJFxbKY
         Us4SpS7g6AtF+Pno0VU57aZB4By22TNIX/fSuZXLltRzdLQmU+a9cSu8dQ+TKUoZGF
         TW1xuZBpoo8HTIIA3aDCAolvfA4R1YtrYhpZTaPWVveUEF6Gl7kPSOaCq84lsvFyKa
         3bYKnhgqjLcyUJnG2B0z6StFIDiEKfx3SAnkSU+ylnUSPRSLnHMBOBmq47HhxlCEKv
         fezYNpuAdFA/DHNImaU4AnILS/C6Jy4+bXdznIZ/KKzMyfdI8Yr69npUm4YfZTrAvD
         tC3cPZaA43cMw==
From:   Marek Vasut <marex@denx.de>
To:     stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Lionel Debieve <lionel.debieve@st.com>,
        Nicolas Toromanoff <nicolas.toromanoff@st.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
Subject: [PATCH] crypto: stm32/crc32 - Fix kernel BUG triggered in probe()
Date:   Sun, 23 Jan 2022 17:22:40 +0100
Message-Id: <20220123162240.5532-1-marex@denx.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <16429542415161@kroah.com>
References: <16429542415161@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The include/linux/crypto.h struct crypto_alg field cra_driver_name description
states "Unique name of the transformation provider. " ... " this contains the
name of the chip or provider and the name of the transformation algorithm."

In case of the stm32-crc driver, field cra_driver_name is identical for all
registered transformation providers and set to the name of the driver itself,
which is incorrect. This patch fixes it by assigning a unique cra_driver_name
to each registered transformation provider.

The kernel crash is triggered when the driver calls crypto_register_shashes()
which calls crypto_register_shash(), which calls crypto_register_alg(), which
calls __crypto_register_alg(), which returns -EEXIST, which is propagated
back through this call chain. Upon -EEXIST from crypto_register_shash(), the
crypto_register_shashes() starts unregistering the providers back, and calls
crypto_unregister_shash(), which calls crypto_unregister_alg(), and this is
where the BUG() triggers due to incorrect cra_refcnt.

Fixes: b51dbe90912a ("crypto: stm32 - Support for STM32 CRC32 crypto module")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: <stable@vger.kernel.org> # 4.12+
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Fabien Dessenne <fabien.dessenne@st.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lionel Debieve <lionel.debieve@st.com>
Cc: Nicolas Toromanoff <nicolas.toromanoff@st.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-crypto@vger.kernel.org
Acked-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
Backport on 4.19.225, likely works on 4.14 too.
The patch likely failed to apply because the hit 5.3:
fdbd643a74efb ("crypto: stm32/crc32 - rename driver file")
and renamed drivers/crypto/stm32/stm32{-,_}crc32.c
---
 drivers/crypto/stm32/stm32_crc32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32_crc32.c b/drivers/crypto/stm32/stm32_crc32.c
index 47d31335c2d42..6848f34a9e66a 100644
--- a/drivers/crypto/stm32/stm32_crc32.c
+++ b/drivers/crypto/stm32/stm32_crc32.c
@@ -230,7 +230,7 @@ static struct shash_alg algs[] = {
 		.digestsize     = CHKSUM_DIGEST_SIZE,
 		.base           = {
 			.cra_name               = "crc32",
-			.cra_driver_name        = DRIVER_NAME,
+			.cra_driver_name        = "stm32-crc32-crc32",
 			.cra_priority           = 200,
 			.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 			.cra_blocksize          = CHKSUM_BLOCK_SIZE,
@@ -252,7 +252,7 @@ static struct shash_alg algs[] = {
 		.digestsize     = CHKSUM_DIGEST_SIZE,
 		.base           = {
 			.cra_name               = "crc32c",
-			.cra_driver_name        = DRIVER_NAME,
+			.cra_driver_name        = "stm32-crc32-crc32c",
 			.cra_priority           = 200,
 			.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 			.cra_blocksize          = CHKSUM_BLOCK_SIZE,
-- 
2.34.1

