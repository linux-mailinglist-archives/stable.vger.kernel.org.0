Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0571B29C1BE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1819035AbgJ0R0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780050AbgJ0Oxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:53:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 142DD22284;
        Tue, 27 Oct 2020 14:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810422;
        bh=Oky0kQbUmdVT7RxWFVQPDpHpT3abUf6UOiboywpHHQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rxqhk7UCEyPhhgz8opaVDUIk2B0GEO3xpSBbbPuERDHnvxBUd+UJkmN7TeurxI1ni
         a7qr+Oyv+vQunzOTyVzmHEHU+ob0o5WxIx3F/Yj4+RZ/1GhpIdJiI3Gnobz9kQIe56
         Ft377yUFYWPTiDS3oUy5f3J1mZI6RB65lDIDAdxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Toromanoff <nicolas.toromanoff@st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 133/633] crypto: stm32/crc32 - Avoid lock if hardware is already used
Date:   Tue, 27 Oct 2020 14:47:56 +0100
Message-Id: <20201027135528.927823983@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Toromanoff <nicolas.toromanoff@st.com>

[ Upstream commit bbf2cb1ea1e1428589d7f4d652bed15b265ce92d ]

If STM32 CRC device is already in use, calculate CRC by software.

This will release CPU constraint for a concurrent access to the
hardware, and avoid masking irqs during the whole block processing.

Fixes: 7795c0baf5ac ("crypto: stm32/crc32 - protect from concurrent accesses")

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/Kconfig       |  1 +
 drivers/crypto/stm32/stm32-crc32.c | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/stm32/Kconfig b/drivers/crypto/stm32/Kconfig
index 4ef3eb11361c2..4a4c3284ae1f3 100644
--- a/drivers/crypto/stm32/Kconfig
+++ b/drivers/crypto/stm32/Kconfig
@@ -3,6 +3,7 @@ config CRYPTO_DEV_STM32_CRC
 	tristate "Support for STM32 crc accelerators"
 	depends on ARCH_STM32
 	select CRYPTO_HASH
+	select CRC32
 	help
 	  This enables support for the CRC32 hw accelerator which can be found
 	  on STMicroelectronics STM32 SOC.
diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index 3ba41148c2a46..2c13f5214d2cf 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -6,6 +6,7 @@
 
 #include <linux/bitrev.h>
 #include <linux/clk.h>
+#include <linux/crc32.h>
 #include <linux/crc32poly.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
@@ -147,7 +148,6 @@ static int burst_update(struct shash_desc *desc, const u8 *d8,
 	struct stm32_crc_desc_ctx *ctx = shash_desc_ctx(desc);
 	struct stm32_crc_ctx *mctx = crypto_shash_ctx(desc->tfm);
 	struct stm32_crc *crc;
-	unsigned long flags;
 
 	crc = stm32_crc_get_next_crc();
 	if (!crc)
@@ -155,7 +155,15 @@ static int burst_update(struct shash_desc *desc, const u8 *d8,
 
 	pm_runtime_get_sync(crc->dev);
 
-	spin_lock_irqsave(&crc->lock, flags);
+	if (!spin_trylock(&crc->lock)) {
+		/* Hardware is busy, calculate crc32 by software */
+		if (mctx->poly == CRC32_POLY_LE)
+			ctx->partial = crc32_le(ctx->partial, d8, length);
+		else
+			ctx->partial = __crc32c_le(ctx->partial, d8, length);
+
+		goto pm_out;
+	}
 
 	/*
 	 * Restore previously calculated CRC for this context as init value
@@ -195,8 +203,9 @@ static int burst_update(struct shash_desc *desc, const u8 *d8,
 	/* Store partial result */
 	ctx->partial = readl_relaxed(crc->regs + CRC_DR);
 
-	spin_unlock_irqrestore(&crc->lock, flags);
+	spin_unlock(&crc->lock);
 
+pm_out:
 	pm_runtime_mark_last_busy(crc->dev);
 	pm_runtime_put_autosuspend(crc->dev);
 
-- 
2.25.1



