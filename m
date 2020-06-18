Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCDA1FE7C7
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgFRBLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:11:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728741AbgFRBLc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:11:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A19D820B1F;
        Thu, 18 Jun 2020 01:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442692;
        bh=ZYAJ00KFqyy/tvH5dMqM3Tjkm+Yhg3s3YaLpmyGJbto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KESwxvfTZmm/vtKve9biDYZHrYPEdeqPRLfwTyMRdNzG1VffTo2UX8BfKyjHsA6MA
         HqbR2AadqymL8kvSEwIw2FWRAL5oaRqCMgVdf8vMPk4g331BQO9MAmFu9UeOB+je8z
         ac1scu7ZBnwWME1yqLaTPe/TpWjP1mhooWTeGXYo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.7 157/388] ASoC: rt5682: fix I2C/Soundwire dependencies
Date:   Wed, 17 Jun 2020 21:04:14 -0400
Message-Id: <20200618010805.600873-157-sashal@kernel.org>
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

[ Upstream commit fd443a20c2f0950f3c31765a08f7dd49b3bc69cb ]

If one of the two is a loadable module, the combined driver must
not be built-in:

aarch64-linux-ld: sound/soc/codecs/rt5682.o: in function `rt5682_sdw_hw_free':
rt5682.c:(.text+0xb34): undefined reference to `sdw_stream_remove_slave'
aarch64-linux-ld: sound/soc/codecs/rt5682.o: in function `rt5682_sdw_hw_params':
rt5682.c:(.text+0xe78): undefined reference to `sdw_stream_add_slave'

In particular, the soundwire driver must not be built-in if
CONFIG_I2C=m.

Fixes: 5549ea647997 ("ASoC: rt5682: fix unmet dependencies")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20200428214642.3925004-1-arnd@arndb.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 7d2cbed55a9d..4c643d2e6d6b 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -1136,10 +1136,13 @@ config SND_SOC_RT5677_SPI
 config SND_SOC_RT5682
 	tristate
 	depends on I2C || SOUNDWIRE
+	depends on SOUNDWIRE || !SOUNDWIRE
+	depends on I2C || !I2C
 
 config SND_SOC_RT5682_SDW
 	tristate "Realtek RT5682 Codec - SDW"
 	depends on SOUNDWIRE
+	depends on I2C || !I2C
 	select SND_SOC_RT5682
 	select REGMAP_SOUNDWIRE
 
-- 
2.25.1

