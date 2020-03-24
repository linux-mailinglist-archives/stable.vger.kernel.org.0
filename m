Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B994F191694
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 17:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgCXQhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 12:37:07 -0400
Received: from foss.arm.com ([217.140.110.172]:38054 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727768AbgCXQhH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 12:37:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9EAFF1FB;
        Tue, 24 Mar 2020 09:37:06 -0700 (PDT)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 20F393F52E;
        Tue, 24 Mar 2020 09:37:05 -0700 (PDT)
Date:   Tue, 24 Mar 2020 16:37:04 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Jonghwan Choi <charlie.jh@kakaocorp.com>
Cc:     alsa-devel@alsa-project.org, Dan Murphy <dmurphy@ti.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.com>
Subject: Applied "ASoC: tas2562: Fixed incorrect amp_level setting." to the asoc tree
In-Reply-To:  <20200319140043.GA6688@jhbirdchoi-MS-7B79>
Message-Id:  <applied-20200319140043.GA6688@jhbirdchoi-MS-7B79>
X-Patchwork-Hint: ignore
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   ASoC: tas2562: Fixed incorrect amp_level setting.

has been applied to the asoc tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git 

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

From eedf8a126629bf9db8ad3a2a5dc9dc1798fb2302 Mon Sep 17 00:00:00 2001
From: Jonghwan Choi <charlie.jh@kakaocorp.com>
Date: Thu, 19 Mar 2020 23:00:44 +0900
Subject: [PATCH] ASoC: tas2562: Fixed incorrect amp_level setting.

According to the tas2562 datasheet,the bits[5:1] represents the amp_level value.
So to set the amp_level value correctly,the shift value should be set to 1.

Signed-off-by: Jonghwan Choi <charlie.jh@kakaocorp.com>
Acked-by: Dan Murphy <dmurphy@ti.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200319140043.GA6688@jhbirdchoi-MS-7B79
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/codecs/tas2562.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2562.c b/sound/soc/codecs/tas2562.c
index be52886a5edb..fb2233ca9103 100644
--- a/sound/soc/codecs/tas2562.c
+++ b/sound/soc/codecs/tas2562.c
@@ -409,7 +409,7 @@ static const struct snd_kcontrol_new vsense_switch =
 			1, 1);
 
 static const struct snd_kcontrol_new tas2562_snd_controls[] = {
-	SOC_SINGLE_TLV("Amp Gain Volume", TAS2562_PB_CFG1, 0, 0x1c, 0,
+	SOC_SINGLE_TLV("Amp Gain Volume", TAS2562_PB_CFG1, 1, 0x1c, 0,
 		       tas2562_dac_tlv),
 };
 
-- 
2.20.1

