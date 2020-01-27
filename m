Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 164E914A976
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 19:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgA0SLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 13:11:33 -0500
Received: from foss.arm.com ([217.140.110.172]:47886 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgA0SLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jan 2020 13:11:33 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEF2C101E;
        Mon, 27 Jan 2020 10:11:32 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1329E3F67D;
        Mon, 27 Jan 2020 10:11:30 -0800 (PST)
Date:   Mon, 27 Jan 2020 18:11:29 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     alsa-devel@alsa-project.org, broonie@kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, stable@vger.kernel.org,
        tiwai@suse.de
Subject: Applied "ASoC: SOF: core: free trace on errors" to the asoc tree
In-Reply-To: <20200124213625.30186-3-pierre-louis.bossart@linux.intel.com>
Message-Id: <applied-20200124213625.30186-3-pierre-louis.bossart@linux.intel.com>
X-Patchwork-Hint: ignore
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   ASoC: SOF: core: free trace on errors

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

From 37e97e6faeabda405d0c4319f8419dcc3da14b2b Mon Sep 17 00:00:00 2001
From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Date: Fri, 24 Jan 2020 15:36:20 -0600
Subject: [PATCH] ASoC: SOF: core: free trace on errors

free_trace() is not called on probe errors, fix

Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200124213625.30186-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
---
 sound/soc/sof/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index 44f9c04d54aa..f517ab448a1d 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -224,12 +224,12 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 	if (ret < 0) {
 		dev_err(sdev->dev,
 			"error: failed to register DSP DAI driver %d\n", ret);
-		goto fw_run_err;
+		goto fw_trace_err;
 	}
 
 	ret = snd_sof_machine_register(sdev, plat_data);
 	if (ret < 0)
-		goto fw_run_err;
+		goto fw_trace_err;
 
 	/*
 	 * Some platforms in SOF, ex: BYT, may not have their platform PM
@@ -245,6 +245,8 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 	return 0;
 
 #if !IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE)
+fw_trace_err:
+	snd_sof_free_trace(sdev);
 fw_run_err:
 	snd_sof_fw_unload(sdev);
 fw_load_err:
@@ -262,6 +264,7 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 	 * snd_sof_device_remove() when the PCI/ACPI device is removed
 	 */
 
+fw_trace_err:
 fw_run_err:
 fw_load_err:
 ipc_err:
-- 
2.20.1

