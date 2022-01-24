Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB28498D09
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344773AbiAXT1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346809AbiAXTXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:23:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D5AC061244;
        Mon, 24 Jan 2022 11:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00AD36121F;
        Mon, 24 Jan 2022 19:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCC4C340E5;
        Mon, 24 Jan 2022 19:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051421;
        bh=WO3Y96d8ujRmduRbZRHZ6fINYqgCWEHggCq4NSV+Gr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=120WpT3DMAm5gwTtnDcLqpTrylMDnHHv2SCS5IVegT57QiGZUqCGGfY53BFDfEp+f
         DhwVq9WwZ76FAx4GjwiWEssvIgWxGmZKszJ+y5cK0FE3/G2biqzSq4KeanhgYgNUSm
         NYJ5ZLH8fZXy9B/oA9TuNUgf/M1J49/GUF41dq40=
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
Subject: [PATCH 4.14 157/186] crypto: stm32/crc32 - Fix kernel BUG triggered in probe()
Date:   Mon, 24 Jan 2022 19:43:52 +0100
Message-Id: <20220124183942.146431609@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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
 drivers/crypto/stm32/stm32_crc32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/stm32/stm32_crc32.c
+++ b/drivers/crypto/stm32/stm32_crc32.c
@@ -206,7 +206,7 @@ static struct shash_alg algs[] = {
 		.digestsize     = CHKSUM_DIGEST_SIZE,
 		.base           = {
 			.cra_name               = "crc32",
-			.cra_driver_name        = DRIVER_NAME,
+			.cra_driver_name        = "stm32-crc32-crc32",
 			.cra_priority           = 200,
 			.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 			.cra_blocksize          = CHKSUM_BLOCK_SIZE,
@@ -228,7 +228,7 @@ static struct shash_alg algs[] = {
 		.digestsize     = CHKSUM_DIGEST_SIZE,
 		.base           = {
 			.cra_name               = "crc32c",
-			.cra_driver_name        = DRIVER_NAME,
+			.cra_driver_name        = "stm32-crc32-crc32c",
 			.cra_priority           = 200,
 			.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 			.cra_blocksize          = CHKSUM_BLOCK_SIZE,


