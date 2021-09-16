Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9E040E320
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242984AbhIPQp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243347AbhIPQmt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:42:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E7D861A4E;
        Thu, 16 Sep 2021 16:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809498;
        bh=e0YyQ89vhZJrfRip3kDvSsTUPtWMNrFtRZ/S2IQUvJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yX+C7ZidXvgkC7Oqw64HsVCL7xxxOMa9xnklHPXJGOvf6J285+MjPyWwpO60nn6XR
         1HO6utnd6oF9RFjhSxGqLLqPCDrqc4+9DSFpkSMNbMvxqlHvJ8VTdQkX+NQ2RecS4L
         4dUTBH+xAsnXlJEviXurkTLiWyGdrJs+lVn9MsQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 145/380] ASoC: atmel: ATMEL drivers dont need HAS_DMA
Date:   Thu, 16 Sep 2021 17:58:22 +0200
Message-Id: <20210916155808.993072588@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 6c5c659dfe3f02e08054a6c20019e3886618b512 ]

On a config (such as arch/sh/) which does not set HAS_DMA when MMU
is not set, several ATMEL ASoC drivers select symbols that cause
kconfig warnings. There is one "depends on HAS_DMA" which is no longer
needed. Dropping it eliminates the kconfig warnings and still builds
with no problems reported.

Fix the following kconfig warnings:

WARNING: unmet direct dependencies detected for SND_ATMEL_SOC_PDC
  Depends on [n]: SOUND [=m] && !UML && SND [=m] && SND_SOC [=m] && SND_ATMEL_SOC [=m] && HAS_DMA [=n]
  Selected by [m]:
  - SND_ATMEL_SOC_SSC [=m] && SOUND [=m] && !UML && SND [=m] && SND_SOC [=m] && SND_ATMEL_SOC [=m]
  - SND_ATMEL_SOC_SSC_PDC [=m] && SOUND [=m] && !UML && SND [=m] && SND_SOC [=m] && SND_ATMEL_SOC [=m] && ATMEL_SSC [=m]

WARNING: unmet direct dependencies detected for SND_ATMEL_SOC_SSC_PDC
  Depends on [n]: SOUND [=m] && !UML && SND [=m] && SND_SOC [=m] && SND_ATMEL_SOC [=m] && ATMEL_SSC [=m] && HAS_DMA [=n]
  Selected by [m]:
  - SND_AT91_SOC_SAM9G20_WM8731 [=m] && SOUND [=m] && !UML && SND [=m] && SND_SOC [=m] && SND_ATMEL_SOC [=m] && (ARCH_AT91 || COMPILE_TEST [=y]) && ATMEL_SSC [=m] && SND_SOC_I2C_AND_SPI [=m]

WARNING: unmet direct dependencies detected for SND_ATMEL_SOC_SSC
  Depends on [n]: SOUND [=m] && !UML && SND [=m] && SND_SOC [=m] && SND_ATMEL_SOC [=m] && HAS_DMA [=n]
  Selected by [m]:
  - SND_ATMEL_SOC_SSC_DMA [=m] && SOUND [=m] && !UML && SND [=m] && SND_SOC [=m] && SND_ATMEL_SOC [=m] && ATMEL_SSC [=m]

WARNING: unmet direct dependencies detected for SND_ATMEL_SOC_SSC_DMA
  Depends on [n]: SOUND [=m] && !UML && SND [=m] && SND_SOC [=m] && SND_ATMEL_SOC [=m] && ATMEL_SSC [=m] && HAS_DMA [=n]
  Selected by [m]:
  - SND_ATMEL_SOC_WM8904 [=m] && SOUND [=m] && !UML && SND [=m] && SND_SOC [=m] && SND_ATMEL_SOC [=m] && (ARCH_AT91 || COMPILE_TEST [=y]) && ATMEL_SSC [=m] && I2C [=m]
  - SND_AT91_SOC_SAM9X5_WM8731 [=m] && SOUND [=m] && !UML && SND [=m] && SND_SOC [=m] && SND_ATMEL_SOC [=m] && (ARCH_AT91 || COMPILE_TEST [=y]) && ATMEL_SSC [=m] && SND_SOC_I2C_AND_SPI [=m]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210707214752.3831-1-rdunlap@infradead.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/atmel/Kconfig b/sound/soc/atmel/Kconfig
index ec04e3386bc0..8617793ed955 100644
--- a/sound/soc/atmel/Kconfig
+++ b/sound/soc/atmel/Kconfig
@@ -11,7 +11,6 @@ if SND_ATMEL_SOC
 
 config SND_ATMEL_SOC_PDC
 	bool
-	depends on HAS_DMA
 
 config SND_ATMEL_SOC_DMA
 	bool
-- 
2.30.2



