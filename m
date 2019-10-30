Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08C86E9FAC
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfJ3PvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbfJ3PvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:51:00 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6842C20656;
        Wed, 30 Oct 2019 15:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450658;
        bh=qBIHlVIiMD+DatNMRp0koo/R95x0y31dpttHdv2ls+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RpMoQTCCslTa/plW4IeE75GJlcT31kvayuV4uNOMSdEmxW/0lC0tY2yPD+Jbl8xcz
         IvfpLeNNT3WKfKt+Po3fFEhS22riWK2m/D+WfpQRfRS/DGmyVb/ph0CH1r4WVgmt7N
         EE35VuFqXRvG+4l/YDjtlnsu+4PsZMFr99W+YUGU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 16/81] ASoC: SOF: Intel: hda: Disable DMI L1 entry during capture
Date:   Wed, 30 Oct 2019 11:48:22 -0400
Message-Id: <20191030154928.9432-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 43b2ab9009b13bfff47fcc1893de9244b39bdd54 ]

There is a known issue on some Intel platforms which causes
pause/release to run into xrun's during capture usecases.
The suggested workaround to address the issue is to
disable the entry of lower power L1 state in the physical
DMI link when there is a capture stream open.

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190927200538.660-14-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/Kconfig      | 10 +++++++
 sound/soc/sof/intel/hda-ctrl.c   | 12 +++------
 sound/soc/sof/intel/hda-stream.c | 45 +++++++++++++++++++++++++++-----
 sound/soc/sof/intel/hda.h        |  5 +++-
 4 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/sound/soc/sof/intel/Kconfig b/sound/soc/sof/intel/Kconfig
index dd14ce92fe102..a5fd356776ee9 100644
--- a/sound/soc/sof/intel/Kconfig
+++ b/sound/soc/sof/intel/Kconfig
@@ -241,6 +241,16 @@ config SND_SOC_SOF_HDA_AUDIO_CODEC
 	  Say Y if you want to enable HDAudio codecs with SOF.
 	  If unsure select "N".
 
+config SND_SOC_SOF_HDA_ALWAYS_ENABLE_DMI_L1
+	bool "SOF enable DMI Link L1"
+	help
+	  This option enables DMI L1 for both playback and capture
+	  and disables known workarounds for specific HDaudio platforms.
+	  Only use to look into power optimizations on platforms not
+	  affected by DMI L1 issues. This option is not recommended.
+	  Say Y if you want to enable DMI Link L1
+	  If unsure, select "N".
+
 endif ## SND_SOC_SOF_HDA_COMMON
 
 config SND_SOC_SOF_HDA_LINK_BASELINE
diff --git a/sound/soc/sof/intel/hda-ctrl.c b/sound/soc/sof/intel/hda-ctrl.c
index ea63f83a509bb..760094d49f18f 100644
--- a/sound/soc/sof/intel/hda-ctrl.c
+++ b/sound/soc/sof/intel/hda-ctrl.c
@@ -139,20 +139,16 @@ void hda_dsp_ctrl_misc_clock_gating(struct snd_sof_dev *sdev, bool enable)
  */
 int hda_dsp_ctrl_clock_power_gating(struct snd_sof_dev *sdev, bool enable)
 {
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA)
-	struct hdac_bus *bus = sof_to_bus(sdev);
-#endif
 	u32 val;
 
 	/* enable/disable audio dsp clock gating */
 	val = enable ? PCI_CGCTL_ADSPDCGE : 0;
 	snd_sof_pci_update_bits(sdev, PCI_CGCTL, PCI_CGCTL_ADSPDCGE, val);
 
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA)
-	/* enable/disable L1 support */
-	val = enable ? SOF_HDA_VS_EM2_L1SEN : 0;
-	snd_hdac_chip_updatel(bus, VS_EM2, SOF_HDA_VS_EM2_L1SEN, val);
-#endif
+	/* enable/disable DMI Link L1 support */
+	val = enable ? HDA_VS_INTEL_EM2_L1SEN : 0;
+	snd_sof_dsp_update_bits(sdev, HDA_DSP_HDA_BAR, HDA_VS_INTEL_EM2,
+				HDA_VS_INTEL_EM2_L1SEN, val);
 
 	/* enable/disable audio dsp power gating */
 	val = enable ? 0 : PCI_PGCTL_ADSPPGD;
diff --git a/sound/soc/sof/intel/hda-stream.c b/sound/soc/sof/intel/hda-stream.c
index ad8d41f22e92d..2c74471884025 100644
--- a/sound/soc/sof/intel/hda-stream.c
+++ b/sound/soc/sof/intel/hda-stream.c
@@ -185,6 +185,17 @@ hda_dsp_stream_get(struct snd_sof_dev *sdev, int direction)
 			direction == SNDRV_PCM_STREAM_PLAYBACK ?
 			"playback" : "capture");
 
+	/*
+	 * Disable DMI Link L1 entry when capture stream is opened.
+	 * Workaround to address a known issue with host DMA that results
+	 * in xruns during pause/release in capture scenarios.
+	 */
+	if (!IS_ENABLED(SND_SOC_SOF_HDA_ALWAYS_ENABLE_DMI_L1))
+		if (stream && direction == SNDRV_PCM_STREAM_CAPTURE)
+			snd_sof_dsp_update_bits(sdev, HDA_DSP_HDA_BAR,
+						HDA_VS_INTEL_EM2,
+						HDA_VS_INTEL_EM2_L1SEN, 0);
+
 	return stream;
 }
 
@@ -193,23 +204,43 @@ int hda_dsp_stream_put(struct snd_sof_dev *sdev, int direction, int stream_tag)
 {
 	struct hdac_bus *bus = sof_to_bus(sdev);
 	struct hdac_stream *s;
+	bool active_capture_stream = false;
+	bool found = false;
 
 	spin_lock_irq(&bus->reg_lock);
 
-	/* find used stream */
+	/*
+	 * close stream matching the stream tag
+	 * and check if there are any open capture streams.
+	 */
 	list_for_each_entry(s, &bus->stream_list, list) {
-		if (s->direction == direction &&
-		    s->opened && s->stream_tag == stream_tag) {
+		if (!s->opened)
+			continue;
+
+		if (s->direction == direction && s->stream_tag == stream_tag) {
 			s->opened = false;
-			spin_unlock_irq(&bus->reg_lock);
-			return 0;
+			found = true;
+		} else if (s->direction == SNDRV_PCM_STREAM_CAPTURE) {
+			active_capture_stream = true;
 		}
 	}
 
 	spin_unlock_irq(&bus->reg_lock);
 
-	dev_dbg(sdev->dev, "stream_tag %d not opened!\n", stream_tag);
-	return -ENODEV;
+	/* Enable DMI L1 entry if there are no capture streams open */
+	if (!IS_ENABLED(SND_SOC_SOF_HDA_ALWAYS_ENABLE_DMI_L1))
+		if (!active_capture_stream)
+			snd_sof_dsp_update_bits(sdev, HDA_DSP_HDA_BAR,
+						HDA_VS_INTEL_EM2,
+						HDA_VS_INTEL_EM2_L1SEN,
+						HDA_VS_INTEL_EM2_L1SEN);
+
+	if (!found) {
+		dev_dbg(sdev->dev, "stream_tag %d not opened!\n", stream_tag);
+		return -ENODEV;
+	}
+
+	return 0;
 }
 
 int hda_dsp_stream_trigger(struct snd_sof_dev *sdev,
diff --git a/sound/soc/sof/intel/hda.h b/sound/soc/sof/intel/hda.h
index d9c17146200b3..2cc789f0e83c4 100644
--- a/sound/soc/sof/intel/hda.h
+++ b/sound/soc/sof/intel/hda.h
@@ -39,7 +39,6 @@
 #define SOF_HDA_WAKESTS			0x0E
 #define SOF_HDA_WAKESTS_INT_MASK	((1 << 8) - 1)
 #define SOF_HDA_RIRBSTS			0x5d
-#define SOF_HDA_VS_EM2_L1SEN            BIT(13)
 
 /* SOF_HDA_GCTL register bist */
 #define SOF_HDA_GCTL_RESET		BIT(0)
@@ -228,6 +227,10 @@
 #define HDA_DSP_REG_HIPCIE		(HDA_DSP_IPC_BASE + 0x0C)
 #define HDA_DSP_REG_HIPCCTL		(HDA_DSP_IPC_BASE + 0x10)
 
+/* Intel Vendor Specific Registers */
+#define HDA_VS_INTEL_EM2		0x1030
+#define HDA_VS_INTEL_EM2_L1SEN		BIT(13)
+
 /*  HIPCI */
 #define HDA_DSP_REG_HIPCI_BUSY		BIT(31)
 #define HDA_DSP_REG_HIPCI_MSG_MASK	0x7FFFFFFF
-- 
2.20.1

