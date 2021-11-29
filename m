Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8ED46252B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhK2Wfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbhK2WfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:35:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC0BC1A197E;
        Mon, 29 Nov 2021 10:37:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A04CB815C5;
        Mon, 29 Nov 2021 18:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56154C53FAD;
        Mon, 29 Nov 2021 18:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211076;
        bh=K+v0fhxbG+DRlI0ShAwX/vZhp+cxE7tsdtwMVwD8Jso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRkvPd5BNhYNU72tusU9YAzyGjWUyiwi185y5r28Uk1cJs/QdTvVJfabDn0/iVuKE
         U8fK1GQvs6fOZdMzwAU8b3u4oHZPESvJVq1cnAC+twQFV7ALOv+LucWvHUjNZhLONH
         ST76/3nIYkT4agVqa+R2Oc6j3rw5bIPjestFhYwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/179] ASoC: SOF: Intel: hda: fix hotplug when only codec is suspended
Date:   Mon, 29 Nov 2021 19:17:38 +0100
Message-Id: <20211129181721.063374592@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit fd572393baf0350835e8d822db588f679dc7bcb8 ]

If codec is in runtime suspend, but controller is not, hotplug events
are missed as the codec has no way to alert the controller. Problem does
not occur if both controller and codec are active, or when both are
suspended.

An easy way to reproduce is to play an audio stream on one codec (e.g.
to HDMI/DP display codec), wait for other HDA codec to go to runtime
suspend, and then plug in a headset to the suspended codec. The jack
event is not reported correctly in this case. Another way to reproduce
is to force controller to stay active with
"snd_sof_pci.sof_pci_debug=0x1"

Fix the issue by reconfiguring the WAKEEN register when powering up/down
individual links, and handling control events in the interrupt handler.

Fixes: 87fc20e4a0cb ("ASoC: SOF: Intel: hda: use hdac_ext fine-grained link management")
Reported-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20211105111655.668777-1-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-bus.c | 17 +++++++++++++++++
 sound/soc/sof/intel/hda-dsp.c |  3 +--
 sound/soc/sof/intel/hda.c     | 16 ++++++++++++++++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/intel/hda-bus.c b/sound/soc/sof/intel/hda-bus.c
index 30025d3c16b6e..0862ff8b66273 100644
--- a/sound/soc/sof/intel/hda-bus.c
+++ b/sound/soc/sof/intel/hda-bus.c
@@ -10,6 +10,8 @@
 #include <linux/io.h>
 #include <sound/hdaudio.h>
 #include <sound/hda_i915.h>
+#include <sound/hda_codec.h>
+#include <sound/hda_register.h>
 #include "../sof-priv.h"
 #include "hda.h"
 
@@ -21,6 +23,18 @@
 #endif
 
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA)
+static void update_codec_wake_enable(struct hdac_bus *bus, unsigned int addr, bool link_power)
+{
+	unsigned int mask = snd_hdac_chip_readw(bus, WAKEEN);
+
+	if (link_power)
+		mask &= ~BIT(addr);
+	else
+		mask |= BIT(addr);
+
+	snd_hdac_chip_updatew(bus, WAKEEN, STATESTS_INT_MASK, mask);
+}
+
 static void sof_hda_bus_link_power(struct hdac_device *codec, bool enable)
 {
 	struct hdac_bus *bus = codec->bus;
@@ -41,6 +55,9 @@ static void sof_hda_bus_link_power(struct hdac_device *codec, bool enable)
 	 */
 	if (codec->addr == HDA_IDISP_ADDR && !enable)
 		snd_hdac_display_power(bus, HDA_CODEC_IDX_CONTROLLER, false);
+
+	/* WAKEEN needs to be set for disabled links */
+	update_codec_wake_enable(bus, codec->addr, enable);
 }
 
 static const struct hdac_bus_ops bus_core_ops = {
diff --git a/sound/soc/sof/intel/hda-dsp.c b/sound/soc/sof/intel/hda-dsp.c
index 623cf291e2074..262a70791a8f8 100644
--- a/sound/soc/sof/intel/hda-dsp.c
+++ b/sound/soc/sof/intel/hda-dsp.c
@@ -623,8 +623,7 @@ static int hda_suspend(struct snd_sof_dev *sdev, bool runtime_suspend)
 	hda_dsp_ipc_int_disable(sdev);
 
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA)
-	if (runtime_suspend)
-		hda_codec_jack_wake_enable(sdev, true);
+	hda_codec_jack_wake_enable(sdev, runtime_suspend);
 
 	/* power down all hda link */
 	snd_hdac_ext_bus_link_power_down_all(bus);
diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index f60e2c57d3d0c..ef92cca7ae01e 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -696,6 +696,20 @@ static int hda_init_caps(struct snd_sof_dev *sdev)
 	return 0;
 }
 
+static void hda_check_for_state_change(struct snd_sof_dev *sdev)
+{
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA)
+	struct hdac_bus *bus = sof_to_bus(sdev);
+	unsigned int codec_mask;
+
+	codec_mask = snd_hdac_chip_readw(bus, STATESTS);
+	if (codec_mask) {
+		hda_codec_jack_check(sdev);
+		snd_hdac_chip_writew(bus, STATESTS, codec_mask);
+	}
+#endif
+}
+
 static irqreturn_t hda_dsp_interrupt_handler(int irq, void *context)
 {
 	struct snd_sof_dev *sdev = context;
@@ -737,6 +751,8 @@ static irqreturn_t hda_dsp_interrupt_thread(int irq, void *context)
 	if (hda_sdw_check_wakeen_irq(sdev))
 		hda_sdw_process_wakeen(sdev);
 
+	hda_check_for_state_change(sdev);
+
 	/* enable GIE interrupt */
 	snd_sof_dsp_update_bits(sdev, HDA_DSP_HDA_BAR,
 				SOF_HDA_INTCTL,
-- 
2.33.0



