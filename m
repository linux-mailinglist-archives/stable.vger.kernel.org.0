Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739764972E1
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 17:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238460AbiAWQKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 11:10:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33858 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbiAWQKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 11:10:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15B2860F54
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 16:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6277C340E2;
        Sun, 23 Jan 2022 16:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642954253;
        bh=C0J7dQO2IJ4QV7si2ABh+D+2A8d4U7gfZDE1f5VdpBw=;
        h=Subject:To:Cc:From:Date:From;
        b=cou7N7G+OuB1ti+6Ld3vtEzTCKYfjjjCBfcoYsqoX9ias2WL7DYFzRk3a94Mrfdyu
         UsRJN03LxQLpnv23soJzj2E3ChkzO+lG+Zo9WKwzNZ2thH9+KYQcUgkH3lpqBYOUhC
         jmggczEa0Nlp7NxJGw3GEB1kt/iBBE8ypTE1HKl8=
Subject: FAILED: patch "[PATCH] crypto: stm32/crc32 - Fix kernel BUG triggered in probe()" failed to apply to 4.14-stable tree
To:     marex@denx.de, alexandre.torgue@foss.st.com,
        fabien.dessenne@st.com, herbert@gondor.apana.org.au,
        lionel.debieve@st.com, nicolas.toromanoff@foss.st.com,
        nicolas.toromanoff@st.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 17:10:42 +0100
Message-ID: <164295424225123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 29009604ad4e3ef784fd9b9fef6f23610ddf633d Mon Sep 17 00:00:00 2001
From: Marek Vasut <marex@denx.de>
Date: Mon, 20 Dec 2021 20:50:22 +0100
Subject: [PATCH] crypto: stm32/crc32 - Fix kernel BUG triggered in probe()

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

diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index 75867c0b0017..be1bf39a317d 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -279,7 +279,7 @@ static struct shash_alg algs[] = {
 		.digestsize     = CHKSUM_DIGEST_SIZE,
 		.base           = {
 			.cra_name               = "crc32",
-			.cra_driver_name        = DRIVER_NAME,
+			.cra_driver_name        = "stm32-crc32-crc32",
 			.cra_priority           = 200,
 			.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 			.cra_blocksize          = CHKSUM_BLOCK_SIZE,
@@ -301,7 +301,7 @@ static struct shash_alg algs[] = {
 		.digestsize     = CHKSUM_DIGEST_SIZE,
 		.base           = {
 			.cra_name               = "crc32c",
-			.cra_driver_name        = DRIVER_NAME,
+			.cra_driver_name        = "stm32-crc32-crc32c",
 			.cra_priority           = 200,
 			.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 			.cra_blocksize          = CHKSUM_BLOCK_SIZE,

