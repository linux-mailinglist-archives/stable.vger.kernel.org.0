Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE8131579AA
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgBJNRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:17:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728143AbgBJMiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:04 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 247942051A;
        Mon, 10 Feb 2020 12:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338283;
        bh=oZWgGWMTJO4VBuXABYTgRaCWpCOwWoCwPgFYd+YLD7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxT8VjHnxm7P3/SXBfHF7Y/Rz4NmUkME1bQo/9GWZpH69JwAb6C750yTXpRXtY5wN
         HY89NRYyIndZyhut0WAQJirnnlxmXDl2GLLEdpTFXEuE4EIMYyvj3Ogg1BC5jTAEg/
         BB8Q4U1HVfQrG6UDLHfeQaPG6/wueeh3zHvnPfr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Curtis Malainey <cujomalainey@chromium.org>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/309] ASoC: SOF: Introduce state machine for FW boot
Date:   Mon, 10 Feb 2020 04:31:31 -0800
Message-Id: <20200210122419.339985648@linuxfoundation.org>
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

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 6ca5cecbd1c1758666ab79446f19e0e61ed11444 ]

Add a state machine for FW boot to track the
different stages of FW boot and replace the boot_complete
field with fw_state field in struct snd_sof_dev.
This will be used to determine the actions to be performed
during system suspend.

One of the main motivations for adding this change is the
fact that errors during the top-level SOF device probe cannot
be propagated and therefore suspending the SOF device normally
during system suspend could potentially run into errors.
For example, with the current flow, if the FW boot failed
for some reason and the system suspends, the SOF device
suspend could fail because the CTX_SAVE IPC would be attempted
even though the FW never really booted successfully causing it
to time out. Another scenario that the state machine fixes
is when the runtime suspend for the SOF device fails and
the DSP is powered down nevertheless, the CTX_SAVE IPC during
system suspend would timeout because the DSP is already
powered down.

Reviewed-by: Curtis Malainey <cujomalainey@chromium.org>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191218002616.7652-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/core.c             | 50 +++++++++++++++++++++++++++++++-
 sound/soc/sof/intel/hda-loader.c |  1 -
 sound/soc/sof/intel/hda.c        |  4 +--
 sound/soc/sof/ipc.c              | 17 ++++-------
 sound/soc/sof/loader.c           | 19 ++++++++----
 sound/soc/sof/pm.c               | 21 +++++++++++++-
 sound/soc/sof/sof-priv.h         | 11 ++++++-
 7 files changed, 99 insertions(+), 24 deletions(-)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index 075b80698477e..f9ebdf2cfc31d 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -288,6 +288,46 @@ static int sof_machine_check(struct snd_sof_dev *sdev)
 #endif
 }
 
+/*
+ *			FW Boot State Transition Diagram
+ *
+ *    +-----------------------------------------------------------------------+
+ *    |									      |
+ * ------------------	     ------------------				      |
+ * |		    |	     |		      |				      |
+ * |   BOOT_FAILED  |	     |  READY_FAILED  |-------------------------+     |
+ * |		    |	     |	              |				|     |
+ * ------------------	     ------------------				|     |
+ *	^			    ^					|     |
+ *	|			    |					|     |
+ * (FW Boot Timeout)		(FW_READY FAIL)				|     |
+ *	|			    |					|     |
+ *	|			    |					|     |
+ * ------------------		    |		   ------------------	|     |
+ * |		    |		    |		   |		    |	|     |
+ * |   IN_PROGRESS  |---------------+------------->|    COMPLETE    |	|     |
+ * |		    | (FW Boot OK)   (FW_READY OK) |		    |	|     |
+ * ------------------				   ------------------	|     |
+ *	^						|		|     |
+ *	|						|		|     |
+ * (FW Loading OK)			       (System Suspend/Runtime Suspend)
+ *	|						|		|     |
+ *	|						|		|     |
+ * ------------------		------------------	|		|     |
+ * |		    |		|		 |<-----+		|     |
+ * |   PREPARE	    |		|   NOT_STARTED  |<---------------------+     |
+ * |		    |		|		 |<---------------------------+
+ * ------------------		------------------
+ *    |	    ^			    |	   ^
+ *    |	    |			    |	   |
+ *    |	    +-----------------------+	   |
+ *    |		(DSP Probe OK)		   |
+ *    |					   |
+ *    |					   |
+ *    +------------------------------------+
+ *	(System Suspend/Runtime Suspend)
+ */
+
 static int sof_probe_continue(struct snd_sof_dev *sdev)
 {
 	struct snd_sof_pdata *plat_data = sdev->pdata;
@@ -303,6 +343,8 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 		return ret;
 	}
 
+	sdev->fw_state = SOF_FW_BOOT_PREPARE;
+
 	/* check machine info */
 	ret = sof_machine_check(sdev);
 	if (ret < 0) {
@@ -342,7 +384,12 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 		goto fw_load_err;
 	}
 
-	/* boot the firmware */
+	sdev->fw_state = SOF_FW_BOOT_IN_PROGRESS;
+
+	/*
+	 * Boot the firmware. The FW boot status will be modified
+	 * in snd_sof_run_firmware() depending on the outcome.
+	 */
 	ret = snd_sof_run_firmware(sdev);
 	if (ret < 0) {
 		dev_err(sdev->dev, "error: failed to boot DSP firmware %d\n",
@@ -450,6 +497,7 @@ int snd_sof_device_probe(struct device *dev, struct snd_sof_pdata *plat_data)
 
 	sdev->pdata = plat_data;
 	sdev->first_boot = true;
+	sdev->fw_state = SOF_FW_BOOT_NOT_STARTED;
 	dev_set_drvdata(dev, sdev);
 
 	/* check all mandatory ops */
diff --git a/sound/soc/sof/intel/hda-loader.c b/sound/soc/sof/intel/hda-loader.c
index 65c2af3fcaab7..356bb134ae93a 100644
--- a/sound/soc/sof/intel/hda-loader.c
+++ b/sound/soc/sof/intel/hda-loader.c
@@ -278,7 +278,6 @@ int hda_dsp_cl_boot_firmware(struct snd_sof_dev *sdev)
 
 	/* init for booting wait */
 	init_waitqueue_head(&sdev->boot_wait);
-	sdev->boot_complete = false;
 
 	/* prepare DMA for code loader stream */
 	tag = cl_stream_prepare(sdev, 0x40, stripped_firmware.size,
diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 5a5163eef2ef4..3c4b604412f0e 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -166,7 +166,7 @@ void hda_dsp_dump_skl(struct snd_sof_dev *sdev, u32 flags)
 	panic = snd_sof_dsp_read(sdev, HDA_DSP_BAR,
 				 HDA_ADSP_ERROR_CODE_SKL + 0x4);
 
-	if (sdev->boot_complete) {
+	if (sdev->fw_state == SOF_FW_BOOT_COMPLETE) {
 		hda_dsp_get_registers(sdev, &xoops, &panic_info, stack,
 				      HDA_DSP_STACK_DUMP_SIZE);
 		snd_sof_get_status(sdev, status, panic, &xoops, &panic_info,
@@ -193,7 +193,7 @@ void hda_dsp_dump(struct snd_sof_dev *sdev, u32 flags)
 				  HDA_DSP_SRAM_REG_FW_STATUS);
 	panic = snd_sof_dsp_read(sdev, HDA_DSP_BAR, HDA_DSP_SRAM_REG_FW_TRACEP);
 
-	if (sdev->boot_complete) {
+	if (sdev->fw_state == SOF_FW_BOOT_COMPLETE) {
 		hda_dsp_get_registers(sdev, &xoops, &panic_info, stack,
 				      HDA_DSP_STACK_DUMP_SIZE);
 		snd_sof_get_status(sdev, status, panic, &xoops, &panic_info,
diff --git a/sound/soc/sof/ipc.c b/sound/soc/sof/ipc.c
index 7b6d69783e16a..8984d965037de 100644
--- a/sound/soc/sof/ipc.c
+++ b/sound/soc/sof/ipc.c
@@ -348,19 +348,12 @@ void snd_sof_ipc_msgs_rx(struct snd_sof_dev *sdev)
 		break;
 	case SOF_IPC_FW_READY:
 		/* check for FW boot completion */
-		if (!sdev->boot_complete) {
+		if (sdev->fw_state == SOF_FW_BOOT_IN_PROGRESS) {
 			err = sof_ops(sdev)->fw_ready(sdev, cmd);
-			if (err < 0) {
-				/*
-				 * this indicates a mismatch in ABI
-				 * between the driver and fw
-				 */
-				dev_err(sdev->dev, "error: ABI mismatch %d\n",
-					err);
-			} else {
-				/* firmware boot completed OK */
-				sdev->boot_complete = true;
-			}
+			if (err < 0)
+				sdev->fw_state = SOF_FW_BOOT_READY_FAILED;
+			else
+				sdev->fw_state = SOF_FW_BOOT_COMPLETE;
 
 			/* wake up firmware loader */
 			wake_up(&sdev->boot_wait);
diff --git a/sound/soc/sof/loader.c b/sound/soc/sof/loader.c
index a041adf0669de..ce114df5e4fce 100644
--- a/sound/soc/sof/loader.c
+++ b/sound/soc/sof/loader.c
@@ -511,7 +511,6 @@ int snd_sof_run_firmware(struct snd_sof_dev *sdev)
 	int init_core_mask;
 
 	init_waitqueue_head(&sdev->boot_wait);
-	sdev->boot_complete = false;
 
 	/* create read-only fw_version debugfs to store boot version info */
 	if (sdev->first_boot) {
@@ -543,19 +542,27 @@ int snd_sof_run_firmware(struct snd_sof_dev *sdev)
 
 	init_core_mask = ret;
 
-	/* now wait for the DSP to boot */
-	ret = wait_event_timeout(sdev->boot_wait, sdev->boot_complete,
+	/*
+	 * now wait for the DSP to boot. There are 3 possible outcomes:
+	 * 1. Boot wait times out indicating FW boot failure.
+	 * 2. FW boots successfully and fw_ready op succeeds.
+	 * 3. FW boots but fw_ready op fails.
+	 */
+	ret = wait_event_timeout(sdev->boot_wait,
+				 sdev->fw_state > SOF_FW_BOOT_IN_PROGRESS,
 				 msecs_to_jiffies(sdev->boot_timeout));
 	if (ret == 0) {
 		dev_err(sdev->dev, "error: firmware boot failure\n");
 		snd_sof_dsp_dbg_dump(sdev, SOF_DBG_REGS | SOF_DBG_MBOX |
 			SOF_DBG_TEXT | SOF_DBG_PCI);
-		/* after this point FW_READY msg should be ignored */
-		sdev->boot_complete = true;
+		sdev->fw_state = SOF_FW_BOOT_FAILED;
 		return -EIO;
 	}
 
-	dev_info(sdev->dev, "firmware boot complete\n");
+	if (sdev->fw_state == SOF_FW_BOOT_COMPLETE)
+		dev_info(sdev->dev, "firmware boot complete\n");
+	else
+		return -EIO; /* FW boots but fw_ready op failed */
 
 	/* perform post fw run operations */
 	ret = snd_sof_dsp_post_fw_run(sdev);
diff --git a/sound/soc/sof/pm.c b/sound/soc/sof/pm.c
index e23beaeefe005..e9fbac38d9238 100644
--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -283,6 +283,8 @@ static int sof_resume(struct device *dev, bool runtime_resume)
 		return ret;
 	}
 
+	sdev->fw_state = SOF_FW_BOOT_PREPARE;
+
 	/* load the firmware */
 	ret = snd_sof_load_firmware(sdev);
 	if (ret < 0) {
@@ -292,7 +294,12 @@ static int sof_resume(struct device *dev, bool runtime_resume)
 		return ret;
 	}
 
-	/* boot the firmware */
+	sdev->fw_state = SOF_FW_BOOT_IN_PROGRESS;
+
+	/*
+	 * Boot the firmware. The FW boot status will be modified
+	 * in snd_sof_run_firmware() depending on the outcome.
+	 */
 	ret = snd_sof_run_firmware(sdev);
 	if (ret < 0) {
 		dev_err(sdev->dev,
@@ -338,6 +345,9 @@ static int sof_suspend(struct device *dev, bool runtime_suspend)
 	if (!sof_ops(sdev)->suspend)
 		return 0;
 
+	if (sdev->fw_state != SOF_FW_BOOT_COMPLETE)
+		goto power_down;
+
 	/* release trace */
 	snd_sof_release_trace(sdev);
 
@@ -375,6 +385,12 @@ static int sof_suspend(struct device *dev, bool runtime_suspend)
 			 ret);
 	}
 
+power_down:
+
+	/* return if the DSP was not probed successfully */
+	if (sdev->fw_state == SOF_FW_BOOT_NOT_STARTED)
+		return 0;
+
 	/* power down all DSP cores */
 	if (runtime_suspend)
 		ret = snd_sof_dsp_runtime_suspend(sdev);
@@ -385,6 +401,9 @@ static int sof_suspend(struct device *dev, bool runtime_suspend)
 			"error: failed to power down DSP during suspend %d\n",
 			ret);
 
+	/* reset FW state */
+	sdev->fw_state = SOF_FW_BOOT_NOT_STARTED;
+
 	return ret;
 }
 
diff --git a/sound/soc/sof/sof-priv.h b/sound/soc/sof/sof-priv.h
index 730f3259dd027..7b329bd99674f 100644
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -356,6 +356,15 @@ struct snd_sof_dai {
 	struct list_head list;	/* list in sdev dai list */
 };
 
+enum snd_sof_fw_state {
+	SOF_FW_BOOT_NOT_STARTED = 0,
+	SOF_FW_BOOT_PREPARE,
+	SOF_FW_BOOT_IN_PROGRESS,
+	SOF_FW_BOOT_FAILED,
+	SOF_FW_BOOT_READY_FAILED, /* firmware booted but fw_ready op failed */
+	SOF_FW_BOOT_COMPLETE,
+};
+
 /*
  * SOF Device Level.
  */
@@ -372,7 +381,7 @@ struct snd_sof_dev {
 
 	/* DSP firmware boot */
 	wait_queue_head_t boot_wait;
-	u32 boot_complete;
+	enum snd_sof_fw_state fw_state;
 	u32 first_boot;
 
 	/* work queue in case the probe is implemented in two steps */
-- 
2.20.1



