Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62AC2E3D7F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440769AbgL1OQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:16:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440758AbgL1OP4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 602BB206D4;
        Mon, 28 Dec 2020 14:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164915;
        bh=McX3MUokFltlpXln2uNqUzzILleat18UODOFSqGWzX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkiv5FJyHqtiZy2EenPfwkRxVItVJ1cjiCKodReSLMvScdukkAjkEUGNIWDUeIBQL
         0OuWEyAeN+z34X4frFEgJuO6hmAqgUc3/KnvgbUiQRC+Rnuhcx9hpgoCTFlCXOJBzd
         GvLb6YhqrELj3YY9WRceyQAwm8ZaWsD8lEM94iwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 313/717] ASoC: atmel: mchp-spdifrx needs COMMON_CLK
Date:   Mon, 28 Dec 2020 13:45:11 +0100
Message-Id: <20201228125036.028019749@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 29275309b0e32bb838d67158c6b6e687275f43e9 ]

Compile-testing this driver on an older platform without CONFIG_COMMON_CLK fails with

ERROR: modpost: "clk_set_min_rate" [sound/soc/atmel/snd-soc-mchp-spdifrx.ko] undefined!

Make this is a strict dependency.

Fixes: ef265c55c1ac ("ASoC: mchp-spdifrx: add driver for SPDIF RX")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Link: https://lore.kernel.org/r/20201203223815.1353451-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/atmel/Kconfig b/sound/soc/atmel/Kconfig
index bd8854bfd2ee4..142373ec411ad 100644
--- a/sound/soc/atmel/Kconfig
+++ b/sound/soc/atmel/Kconfig
@@ -148,6 +148,7 @@ config SND_MCHP_SOC_SPDIFTX
 config SND_MCHP_SOC_SPDIFRX
 	tristate "Microchip ASoC driver for boards using S/PDIF RX"
 	depends on OF && (ARCH_AT91 || COMPILE_TEST)
+	depends on COMMON_CLK
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 	select REGMAP_MMIO
 	help
-- 
2.27.0



