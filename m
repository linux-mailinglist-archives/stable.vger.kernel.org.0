Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4500D14A975
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 19:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgA0SL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 13:11:29 -0500
Received: from foss.arm.com ([217.140.110.172]:47878 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgA0SL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jan 2020 13:11:29 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A735106F;
        Mon, 27 Jan 2020 10:11:29 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 781663F67D;
        Mon, 27 Jan 2020 10:11:28 -0800 (PST)
Date:   Mon, 27 Jan 2020 18:11:26 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     alsa-devel@alsa-project.org, broonie@kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, tiwai@suse.de
Subject: Applied "ASoC: SOF: core: release resources on errors in probe_continue" to the asoc tree
In-Reply-To: <20200124213625.30186-4-pierre-louis.bossart@linux.intel.com>
Message-Id: <applied-20200124213625.30186-4-pierre-louis.bossart@linux.intel.com>
X-Patchwork-Hint: ignore
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   ASoC: SOF: core: release resources on errors in probe_continue

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

From 410e5e55c9c1c9c0d452ac5b9adb37b933a7747e Mon Sep 17 00:00:00 2001
From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Date: Fri, 24 Jan 2020 15:36:21 -0600
Subject: [PATCH] ASoC: SOF: core: release resources on errors in
 probe_continue

The initial intent of releasing resources in the .remove does not work
well with HDaudio codecs. If the probe_continue() fails in a work
queue, e.g. due to missing firmware or authentication issues, we don't
release any resources, and as a result the kernel oopses during
suspend operations.

The suggested fix is to release all resources during errors in
probe_continue(), and use fw_state to track resource allocation
state, so that .remove does not attempt to release the same
hardware resources twice. PM operations are also modified so that
no action is done if DSP resources have been freed due to
an error at probe.

Reported-by: Takashi Iwai <tiwai@suse.de>
Co-developed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Bugzilla:  http://bugzilla.suse.com/show_bug.cgi?id=1161246
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20200124213625.30186-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
---
 sound/soc/sof/core.c | 33 ++++++++++++---------------------
 sound/soc/sof/pm.c   |  4 ++++
 2 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index f517ab448a1d..34cefbaf2d2a 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -244,7 +244,6 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 
 	return 0;
 
-#if !IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE)
 fw_trace_err:
 	snd_sof_free_trace(sdev);
 fw_run_err:
@@ -255,22 +254,10 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 	snd_sof_free_debug(sdev);
 dbg_err:
 	snd_sof_remove(sdev);
-#else
 
-	/*
-	 * when the probe_continue is handled in a work queue, the
-	 * probe does not fail so we don't release resources here.
-	 * They will be released with an explicit call to
-	 * snd_sof_device_remove() when the PCI/ACPI device is removed
-	 */
-
-fw_trace_err:
-fw_run_err:
-fw_load_err:
-ipc_err:
-dbg_err:
-
-#endif
+	/* all resources freed, update state to match */
+	sdev->fw_state = SOF_FW_BOOT_NOT_STARTED;
+	sdev->first_boot = true;
 
 	return ret;
 }
@@ -353,10 +340,12 @@ int snd_sof_device_remove(struct device *dev)
 	if (IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE))
 		cancel_work_sync(&sdev->probe_work);
 
-	snd_sof_fw_unload(sdev);
-	snd_sof_ipc_free(sdev);
-	snd_sof_free_debug(sdev);
-	snd_sof_free_trace(sdev);
+	if (sdev->fw_state > SOF_FW_BOOT_NOT_STARTED) {
+		snd_sof_fw_unload(sdev);
+		snd_sof_ipc_free(sdev);
+		snd_sof_free_debug(sdev);
+		snd_sof_free_trace(sdev);
+	}
 
 	/*
 	 * Unregister machine driver. This will unbind the snd_card which
@@ -364,13 +353,15 @@ int snd_sof_device_remove(struct device *dev)
 	 * before freeing the snd_card.
 	 */
 	snd_sof_machine_unregister(sdev, pdata);
+
 	/*
 	 * Unregistering the machine driver results in unloading the topology.
 	 * Some widgets, ex: scheduler, attempt to power down the core they are
 	 * scheduled on, when they are unloaded. Therefore, the DSP must be
 	 * removed only after the topology has been unloaded.
 	 */
-	snd_sof_remove(sdev);
+	if (sdev->fw_state > SOF_FW_BOOT_NOT_STARTED)
+		snd_sof_remove(sdev);
 
 	/* release firmware */
 	release_firmware(pdata->fw);
diff --git a/sound/soc/sof/pm.c b/sound/soc/sof/pm.c
index 84290bbeebdd..a0cde053b61a 100644
--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -56,6 +56,10 @@ static int sof_resume(struct device *dev, bool runtime_resume)
 	if (!sof_ops(sdev)->resume || !sof_ops(sdev)->runtime_resume)
 		return 0;
 
+	/* DSP was never successfully started, nothing to resume */
+	if (sdev->first_boot)
+		return 0;
+
 	/*
 	 * if the runtime_resume flag is set, call the runtime_resume routine
 	 * or else call the system resume routine
-- 
2.20.1

