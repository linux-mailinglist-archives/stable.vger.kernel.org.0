Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7DD31579A8
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgBJNRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:17:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:32770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729005AbgBJMiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:04 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AF3C2467B;
        Mon, 10 Feb 2020 12:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338283;
        bh=zFwTXLAAapvhvHXX5fTRrTFBKk4WkgZcYPAfNe+/4Mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0CUBqTxPuYbnsYka40IunRBkSCAj+68fd1Prsx7jMd7yWY8+cCB1wTxTVQkX/IIqY
         Az2jBAzTLpmzGvNXbIEWAVwUvgbKYSHp8DbjckRO9+aoMzR7KEQ3Fnq8piLB7afjPM
         HUHeJn+r8m5r/+wSsIvATZFnsDpkBVuNDXjCI/q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/309] ASoC: SOF: core: release resources on errors in probe_continue
Date:   Mon, 10 Feb 2020 04:31:32 -0800
Message-Id: <20200210122419.431608102@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 410e5e55c9c1c9c0d452ac5b9adb37b933a7747e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/core.c | 32 +++++++++++---------------------
 sound/soc/sof/pm.c   |  4 ++++
 2 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index f9ebdf2cfc31d..12aec140819a2 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -440,7 +440,6 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 
 	return 0;
 
-#if !IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE)
 fw_trace_err:
 	snd_sof_free_trace(sdev);
 fw_run_err:
@@ -451,22 +450,10 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 	snd_sof_free_debug(sdev);
 dbg_err:
 	snd_sof_remove(sdev);
-#else
-
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
 
-#endif
+	/* all resources freed, update state to match */
+	sdev->fw_state = SOF_FW_BOOT_NOT_STARTED;
+	sdev->first_boot = true;
 
 	return ret;
 }
@@ -545,10 +532,12 @@ int snd_sof_device_remove(struct device *dev)
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
@@ -564,7 +553,8 @@ int snd_sof_device_remove(struct device *dev)
 	 * scheduled on, when they are unloaded. Therefore, the DSP must be
 	 * removed only after the topology has been unloaded.
 	 */
-	snd_sof_remove(sdev);
+	if (sdev->fw_state > SOF_FW_BOOT_NOT_STARTED)
+		snd_sof_remove(sdev);
 
 	/* release firmware */
 	release_firmware(pdata->fw);
diff --git a/sound/soc/sof/pm.c b/sound/soc/sof/pm.c
index e9fbac38d9238..195af259e78e3 100644
--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -269,6 +269,10 @@ static int sof_resume(struct device *dev, bool runtime_resume)
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



