Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B681319D7
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 21:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgAFUu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 15:50:59 -0500
Received: from foss.arm.com ([217.140.110.172]:49196 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbgAFUu6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jan 2020 15:50:58 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A151DA7;
        Mon,  6 Jan 2020 12:50:58 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5CF73F534;
        Mon,  6 Jan 2020 12:50:57 -0800 (PST)
Date:   Mon, 06 Jan 2020 20:50:56 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     alsa-devel@alsa-project.org,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        russianneuromancer@ya.ru, stable@vger.kernel.org
Subject: Applied "ASoC: Intel: bytcht_es8316: Fix Irbis NB41 netbook quirk" to the asoc tree
In-Reply-To: <20200106113903.279394-1-hdegoede@redhat.com>
Message-Id: <applied-20200106113903.279394-1-hdegoede@redhat.com>
X-Patchwork-Hint: ignore
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   ASoC: Intel: bytcht_es8316: Fix Irbis NB41 netbook quirk

has been applied to the asoc tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-5.5

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From 869bced7a055665e3ddb1ba671a441ce6f997bf1 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Mon, 6 Jan 2020 12:39:03 +0100
Subject: [PATCH] ASoC: Intel: bytcht_es8316: Fix Irbis NB41 netbook quirk

When a quirk for the Irbis NB41 netbook was added, to override the defaults
for this device, I forgot to add/keep the BYT_CHT_ES8316_SSP0 part of the
defaults, completely breaking audio on this netbook.

This commit adds the BYT_CHT_ES8316_SSP0 flag to the Irbis NB41 netbook
quirk, making audio work again.

Cc: stable@vger.kernel.org
Cc: russianneuromancer@ya.ru
Fixes: aa2ba991c420 ("ASoC: Intel: bytcht_es8316: Add quirk for Irbis NB41 netbook")
Reported-and-tested-by: russianneuromancer@ya.ru
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200106113903.279394-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/intel/boards/bytcht_es8316.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boards/bytcht_es8316.c
index 46612331f5ea..54e97455d7f6 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -442,7 +442,8 @@ static const struct dmi_system_id byt_cht_es8316_quirk_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "IRBIS"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "NB41"),
 		},
-		.driver_data = (void *)(BYT_CHT_ES8316_INTMIC_IN2_MAP
+		.driver_data = (void *)(BYT_CHT_ES8316_SSP0
+					| BYT_CHT_ES8316_INTMIC_IN2_MAP
 					| BYT_CHT_ES8316_JD_INVERTED),
 	},
 	{	/* Teclast X98 Plus II */
-- 
2.20.1

