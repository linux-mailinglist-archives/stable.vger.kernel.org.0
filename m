Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4A3498E59
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347267AbiAXTkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:40:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57292 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354617AbiAXTgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:36:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7007B8119D;
        Mon, 24 Jan 2022 19:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B55AC340E7;
        Mon, 24 Jan 2022 19:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053010;
        bh=OZWrIYlmNnJeEG49q0gkOrjQAqbKYs8wTiNAlmZYCOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/6rC2AADJeNwy/1WEL5C6PawFECLFilfmEAhJVXJsKKcIIP6WWgM3wszNxVxqJvr
         7yf/I1LLZaMMFLS1AacRYtQi8Lh1u9JmvEYN0FfypNlMaIj5cW0SjtxJs9i3zK55aD
         ij6aLFJhQ+lapsy61Y0nNCA+3wYq2vZz9Izjgv/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Lionel Debieve <lionel.debieve@st.com>,
        Nicolas Toromanoff <nicolas.toromanoff@st.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
Subject: [PATCH 5.4 247/320] crypto: stm32/crc32 - Fix kernel BUG triggered in probe()
Date:   Mon, 24 Jan 2022 19:43:51 +0100
Message-Id: <20220124184002.395346406@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

commit 29009604ad4e3ef784fd9b9fef6f23610ddf633d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/stm32/stm32-crc32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
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


