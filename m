Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72FFE150CF1
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730959AbgBCQfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:35:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731058AbgBCQfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:35:32 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53C4F2051A;
        Mon,  3 Feb 2020 16:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747731;
        bh=VliAeT8Po/eV+MTczlUWIup6JgY6fmjh0jhjULFIku0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COp8Fg/H+MrDBis/u1I5Al6CMYpxWHI84guu2o/oQhFHxExIQe5NNy9NLlHUHIU7C
         bo8M3T19BfdDEJrHqaFuh9nxRX4f9PdEWhFAOjFd/WX/3FvPy+DIuTQXqNEsgbsCKt
         kNqRU74K8J9EMryPJTaOmyxG8RTPH2fq/REFLmQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/90] ASoC: SOF: Intel: fix HDA codec driver probe with multiple controllers
Date:   Mon,  3 Feb 2020 16:19:48 +0000
Message-Id: <20200203161923.547205729@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



