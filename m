Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53C4915BF60
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 14:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbgBMNb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 08:31:59 -0500
Received: from foss.arm.com ([217.140.110.172]:46636 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729901AbgBMNb7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 08:31:59 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 77F861FB;
        Thu, 13 Feb 2020 05:31:58 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E74B73F6CF;
        Thu, 13 Feb 2020 05:31:57 -0800 (PST)
Date:   Thu, 13 Feb 2020 13:31:56 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Samuel Holland <samuel@sholland.org>
Cc:     alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.com>
Subject: Applied "ASoC: codec2codec: avoid invalid/double-free of pcm runtime" to the asoc tree
In-Reply-To: <20200213061147.29386-2-samuel@sholland.org>
Message-Id: <applied-20200213061147.29386-2-samuel@sholland.org>
X-Patchwork-Hint: ignore
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   ASoC: codec2codec: avoid invalid/double-free of pcm runtime

has been applied to the asoc tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-5.6

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

From b6570fdb96edf45bcf71884bd2644bd73d348d1a Mon Sep 17 00:00:00 2001
From: Samuel Holland <samuel@sholland.org>
Date: Thu, 13 Feb 2020 00:11:44 -0600
Subject: [PATCH] ASoC: codec2codec: avoid invalid/double-free of pcm runtime

The PCM runtime was freed during PMU in the case that the event hook
encountered an error. However, it is also unconditionally freed during
PMD. Avoid a double-free by dropping the call to kfree in the PMU hook.

Fixes: a72706ed8208 ("ASoC: codec2codec: remove ephemeral variables")
Cc: stable@vger.kernel.org
Signed-off-by: Samuel Holland <samuel@sholland.org>
Link: https://lore.kernel.org/r/20200213061147.29386-2-samuel@sholland.org
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/soc-dapm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index bc20ad9abf8b..8b24396675ec 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3916,9 +3916,6 @@ snd_soc_dai_link_event_pre_pmu(struct snd_soc_dapm_widget *w,
 	runtime->rate = params_rate(params);
 
 out:
-	if (ret < 0)
-		kfree(runtime);
-
 	kfree(params);
 	return ret;
 }
-- 
2.20.1

