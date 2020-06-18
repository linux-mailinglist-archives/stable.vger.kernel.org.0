Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA26F1FDAD5
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgFRBIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:08:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbgFRBIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:08:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E22221D7E;
        Thu, 18 Jun 2020 01:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442513;
        bh=mmt5ndiFij10gOStOvriPpqYvAFtLsVIaRIzJBlMHF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5Zl3YYtDAtqIg5Bp60iwr1hbdnPKb+bwg7S7LOuaR0s+WbQxhoCWosEX+xeQFcYq
         qAKg1OsG5zG/FicEoZFaVUjFGNC+CWMb9gpII5TtCnW/YyDe8Cv80eHRSx9rY64FIO
         jI/jBwyO6+PsPdcgAfuiwI62Ua2FMlE0lAB8a+qo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.7 020/388] ASoC: codecs: wm97xx: fix ac97 dependency
Date:   Wed, 17 Jun 2020 21:01:57 -0400
Message-Id: <20200618010805.600873-20-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit ee2cbe06935bfa58f1fe07dc2a2283945f4b97dc ]

A recent build fix got the dependency slightly wrong, breaking
builds with CONFIG_AC97_BUS_NEW:

WARNING: unmet direct dependencies detected for SND_SOC_WM9713
  Depends on [n]: SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && SND_SOC_AC97_BUS [=n]
  Selected by [m]:
  - SND_SOC_ZYLONITE [=m] && SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && SND_PXA2XX_SOC [=m] && MACH_ZYLONITE [=y] && AC97_BUS [=n]=n

WARNING: unmet direct dependencies detected for SND_SOC_WM9712
  Depends on [n]: SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && SND_SOC_AC97_BUS [=n]
  Selected by [m]:
  - SND_PXA2XX_SOC_EM_X270 [=m] && SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && SND_PXA2XX_SOC [=m] && (MACH_EM_X270 [=n] || MACH_EXEDA [=n] || MACH_CM_X300 [=y]) && AC97_BUS [=n]=n

Change the dependency to allow either version of the AC97 library
code.

Fixes: 5a309875787d ("ASoC: Fix SND_SOC_ALL_CODECS imply ac97 fallout")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20200428212721.2877627-1-arnd@arndb.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index e60e0b6a689c..8cdc68c141dc 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -1620,19 +1620,19 @@ config SND_SOC_WM9090
 
 config SND_SOC_WM9705
 	tristate
-	depends on SND_SOC_AC97_BUS
+	depends on SND_SOC_AC97_BUS || AC97_BUS_NEW
 	select REGMAP_AC97
 	select AC97_BUS_COMPAT if AC97_BUS_NEW
 
 config SND_SOC_WM9712
 	tristate
-	depends on SND_SOC_AC97_BUS
+	depends on SND_SOC_AC97_BUS || AC97_BUS_NEW
 	select REGMAP_AC97
 	select AC97_BUS_COMPAT if AC97_BUS_NEW
 
 config SND_SOC_WM9713
 	tristate
-	depends on SND_SOC_AC97_BUS
+	depends on SND_SOC_AC97_BUS || AC97_BUS_NEW
 	select REGMAP_AC97
 	select AC97_BUS_COMPAT if AC97_BUS_NEW
 
-- 
2.25.1

