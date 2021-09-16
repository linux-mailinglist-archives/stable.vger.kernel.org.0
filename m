Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CAF40E008
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239745AbhIPQQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237200AbhIPQNA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:13:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 576C461381;
        Thu, 16 Sep 2021 16:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808581;
        bh=9apz7idIxDy+44QrOdSGvr+lOz8rYBuGfzSTpeH8J1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHj2DHfXUU2IRvRBqA37w4/ltmWAevMnWTiXEngekEBb5rcsuWjES7kwKdJ2NnmnO
         +OqF/1UfsBzMwjpPCOuMuBko8vo/sabLiPKwwExB/kBD+8N4feTdlFiS9rShyyj6gr
         Ya7SIlqrXuK9BgCpoNefVGEnJO93YLT7qs73hZmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/306] ASoC: atmel: ATMEL drivers dont need HAS_DMA
Date:   Thu, 16 Sep 2021 17:57:37 +0200
Message-Id: <20210916155757.895547495@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index 142373ec411a..89210048e6c2 100644
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



