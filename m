Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD871486E6
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391578AbgAXOTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:19:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391518AbgAXOTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C2E120838;
        Fri, 24 Jan 2020 14:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875559;
        bh=VliAeT8Po/eV+MTczlUWIup6JgY6fmjh0jhjULFIku0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQF6eejBL21HMrBLloIcOE1RUwIudjS34LONfAivMIRtCwrLVEtcikKflKJmvf/0T
         lDVPwERfhVH6ZqoI3ymU4AXs0kJQU+Z6m5HPlOvewRDE6a2PCnDk2j4sYVO/eC6xyp
         umSkp1NzdD23pvsxdHbX1zCK051pF/MHBv07kXVI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 053/107] ASoC: SOF: Intel: fix HDA codec driver probe with multiple controllers
Date:   Fri, 24 Jan 2020 09:17:23 -0500
Message-Id: <20200124141817.28793-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 2c63bea714780f8e1fc9cb7bc10deda26fada25b ]

In case system has multiple HDA controllers, it can happen that
same HDA codec driver is used for codecs of multiple controllers.
In this case, SOF may fail to probe the HDA driver and SOF
initialization fails.

SOF HDA code currently relies that a call to request_module() will
also run device matching logic to attach driver to the codec instance.
However if driver for another HDA controller was already loaded and it
already loaded the HDA codec driver, this breaks current logic in SOF.
In this case the request_module() SOF does becomes a no-op and HDA
Codec driver is not attached to the codec instance sitting on the HDA
bus SOF is controlling. Typical scenario would be a system with both
external and internal GPUs, with driver of the external GPU loaded
first.

Fix this by adding similar logic as is used in legacy HDA driver
where an explicit device_attach() call is done after request_module().

Also add logic to propagate errors reported by device_attach() back
to caller. This also works in the case where drivers are not built
as modules.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200110235751.3404-8-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-codec.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
index 3ca6795a89ba3..9e8233c10d860 100644
--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -24,19 +24,18 @@
 #define IDISP_VID_INTEL	0x80860000
 
 /* load the legacy HDA codec driver */
-#ifdef MODULE
-static void hda_codec_load_module(struct hda_codec *codec)
+static int hda_codec_load_module(struct hda_codec *codec)
 {
+#ifdef MODULE
 	char alias[MODULE_NAME_LEN];
 	const char *module = alias;
 
 	snd_hdac_codec_modalias(&codec->core, alias, sizeof(alias));
 	dev_dbg(&codec->core.dev, "loading codec module: %s\n", module);
 	request_module(module);
-}
-#else
-static void hda_codec_load_module(struct hda_codec *codec) {}
 #endif
+	return device_attach(hda_codec_dev(codec));
+}
 
 /* enable controller wake up event for all codecs with jack connectors */
 void hda_codec_jack_wake_enable(struct snd_sof_dev *sdev)
@@ -116,10 +115,16 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address)
 	/* use legacy bus only for HDA codecs, idisp uses ext bus */
 	if ((resp & 0xFFFF0000) != IDISP_VID_INTEL) {
 		hdev->type = HDA_DEV_LEGACY;
-		hda_codec_load_module(&hda_priv->codec);
+		ret = hda_codec_load_module(&hda_priv->codec);
+		/*
+		 * handle ret==0 (no driver bound) as an error, but pass
+		 * other return codes without modification
+		 */
+		if (ret == 0)
+			ret = -ENOENT;
 	}
 
-	return 0;
+	return ret;
 #else
 	hdev = devm_kzalloc(sdev->dev, sizeof(*hdev), GFP_KERNEL);
 	if (!hdev)
-- 
2.20.1

