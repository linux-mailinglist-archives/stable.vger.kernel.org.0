Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36145205DA5
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388673AbgFWUPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:15:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388463AbgFWUPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:15:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE4302073E;
        Tue, 23 Jun 2020 20:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943308;
        bh=ZI3jyfKpUxlm+XB6Bob+pEEMgPi+7cqCeL52nl3BHlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mHCHt14gLSbcSRKNKVBp0Rzl8vMmfq/nTZxO6h90KMomwZylbF3+D8IytdR5G8bLw
         0Rz6/4LGaoEO04lXTUhKSID4JnMpWHFV+k3TM2sU8XZtKGDB+8LCzQn6RQgf6KQnui
         svwUjPZD1nSul1cl59U1qx7RJWfWxnvOiau0ynQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Hui Wang <hui.wang@canonical.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 300/477] ASoC: SOF: Intel: hda: fix generic hda codec support
Date:   Tue, 23 Jun 2020 21:54:57 +0200
Message-Id: <20200623195421.731494966@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 89d73ccab20a684d8446cea4d8ac6a2608c8d390 ]

Add support for using generic codec driver with SOF. Generic driver
is used if:
 - snd_sof_intel_hda_common.hda_model="generic" is set, or
 - fallback if no other codec driver is found

The implementation is aligned with snd-hda-intel driver, and fixes audio
support for systems like Acer Swift 3 SF314-57G, on which this issue was
originally reported.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Hui Wang <hui.wang@canonical.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
BugLink: https://github.com/thesofproject/linux/issues/1807
BugLink: https://bugs.launchpad.net/bugs/1877757
Link: https://lore.kernel.org/r/20200529160358.12134-1-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-codec.c | 51 +++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
index 3041fbbb010a2..ea021db697b8a 100644
--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -24,19 +24,44 @@
 #define IDISP_VID_INTEL	0x80860000
 
 /* load the legacy HDA codec driver */
-static int hda_codec_load_module(struct hda_codec *codec)
+static int request_codec_module(struct hda_codec *codec)
 {
 #ifdef MODULE
 	char alias[MODULE_NAME_LEN];
-	const char *module = alias;
+	const char *mod = NULL;
 
-	snd_hdac_codec_modalias(&codec->core, alias, sizeof(alias));
-	dev_dbg(&codec->core.dev, "loading codec module: %s\n", module);
-	request_module(module);
+	switch (codec->probe_id) {
+	case HDA_CODEC_ID_GENERIC:
+#if IS_MODULE(CONFIG_SND_HDA_GENERIC)
+		mod = "snd-hda-codec-generic";
 #endif
+		break;
+	default:
+		snd_hdac_codec_modalias(&codec->core, alias, sizeof(alias));
+		mod = alias;
+		break;
+	}
+
+	if (mod) {
+		dev_dbg(&codec->core.dev, "loading codec module: %s\n", mod);
+		request_module(mod);
+	}
+#endif /* MODULE */
 	return device_attach(hda_codec_dev(codec));
 }
 
+static int hda_codec_load_module(struct hda_codec *codec)
+{
+	int ret = request_codec_module(codec);
+
+	if (ret <= 0) {
+		codec->probe_id = HDA_CODEC_ID_GENERIC;
+		ret = request_codec_module(codec);
+	}
+
+	return ret;
+}
+
 /* enable controller wake up event for all codecs with jack connectors */
 void hda_codec_jack_wake_enable(struct snd_sof_dev *sdev)
 {
@@ -78,6 +103,13 @@ void hda_codec_jack_check(struct snd_sof_dev *sdev) {}
 EXPORT_SYMBOL_NS(hda_codec_jack_wake_enable, SND_SOC_SOF_HDA_AUDIO_CODEC);
 EXPORT_SYMBOL_NS(hda_codec_jack_check, SND_SOC_SOF_HDA_AUDIO_CODEC);
 
+#if IS_ENABLED(CONFIG_SND_HDA_GENERIC)
+#define is_generic_config(bus) \
+	((bus)->modelname && !strcmp((bus)->modelname, "generic"))
+#else
+#define is_generic_config(x)	0
+#endif
+
 /* probe individual codec */
 static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
 			   bool hda_codec_use_common_hdmi)
@@ -87,6 +119,7 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
 #endif
 	struct hda_bus *hbus = sof_to_hbus(sdev);
 	struct hdac_device *hdev;
+	struct hda_codec *codec;
 	u32 hda_cmd = (address << 28) | (AC_NODE_ROOT << 20) |
 		(AC_VERB_PARAMETERS << 8) | AC_PAR_VENDOR_ID;
 	u32 resp = -1;
@@ -108,6 +141,7 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
 
 	hda_priv->codec.bus = hbus;
 	hdev = &hda_priv->codec.core;
+	codec = &hda_priv->codec;
 
 	ret = snd_hdac_ext_bus_device_init(&hbus->core, address, hdev);
 	if (ret < 0)
@@ -122,6 +156,11 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
 		hda_priv->need_display_power = true;
 	}
 
+	if (is_generic_config(hbus))
+		codec->probe_id = HDA_CODEC_ID_GENERIC;
+	else
+		codec->probe_id = 0;
+
 	/*
 	 * if common HDMI codec driver is not used, codec load
 	 * is skipped here and hdac_hdmi is used instead
@@ -129,7 +168,7 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
 	if (hda_codec_use_common_hdmi ||
 	    (resp & 0xFFFF0000) != IDISP_VID_INTEL) {
 		hdev->type = HDA_DEV_LEGACY;
-		ret = hda_codec_load_module(&hda_priv->codec);
+		ret = hda_codec_load_module(codec);
 		/*
 		 * handle ret==0 (no driver bound) as an error, but pass
 		 * other return codes without modification
-- 
2.25.1



