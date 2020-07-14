Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862AB21FBFB
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbgGNTF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730646AbgGNSxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:53:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E16322C9F;
        Tue, 14 Jul 2020 18:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752828;
        bh=rAToyATJmJzHZQyIyJDmhYm9QwhloqEv1gMsff5kCjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3YAPKGHq7sizyNm2bTdadJj/7z0PurMUrJJmhCDT+fLcJSeDxM3hFIB3uBP2GF6H
         +NSKngx7tA09NW4DQmrC11AI1DI5T6fy5wWEtiiVcY1lTZN7axzxv7ne1rv7HK/Vgd
         vFw3Y7F4MIChMRBuwTOIaXl01sNufbM1UGWFOU/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Daniel Baluta <daniel.baluta@gmail.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Rander Wang <rander.wang@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 016/166] ASoC: hdac_hda: fix memleak with regmap not freed on remove
Date:   Tue, 14 Jul 2020 20:43:01 +0200
Message-Id: <20200714184116.677181721@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit a94eaccefea1186947c5c5451fcae2245dd7e714 ]

kmemleak throws error reports on module load/unload tests, add
snd_hdac_regmap_exit() in .remove().

While we are at it, also fix the error handling flow in .probe() to
use snd_hdac_regmap_exit() if needed.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Daniel Baluta <daniel.baluta@gmail.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20200617164144.17859-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hda.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index de003acb1951f..473efe9ef998a 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -441,13 +441,13 @@ static int hdac_hda_codec_probe(struct snd_soc_component *component)
 	ret = snd_hda_codec_set_name(hcodec, hcodec->preset->name);
 	if (ret < 0) {
 		dev_err(&hdev->dev, "name failed %s\n", hcodec->preset->name);
-		goto error;
+		goto error_pm;
 	}
 
 	ret = snd_hdac_regmap_init(&hcodec->core);
 	if (ret < 0) {
 		dev_err(&hdev->dev, "regmap init failed\n");
-		goto error;
+		goto error_pm;
 	}
 
 	patch = (hda_codec_patch_t)hcodec->preset->driver_data;
@@ -455,7 +455,7 @@ static int hdac_hda_codec_probe(struct snd_soc_component *component)
 		ret = patch(hcodec);
 		if (ret < 0) {
 			dev_err(&hdev->dev, "patch failed %d\n", ret);
-			goto error;
+			goto error_regmap;
 		}
 	} else {
 		dev_dbg(&hdev->dev, "no patch file found\n");
@@ -467,7 +467,7 @@ static int hdac_hda_codec_probe(struct snd_soc_component *component)
 	ret = snd_hda_codec_parse_pcms(hcodec);
 	if (ret < 0) {
 		dev_err(&hdev->dev, "unable to map pcms to dai %d\n", ret);
-		goto error;
+		goto error_regmap;
 	}
 
 	/* HDMI controls need to be created in machine drivers */
@@ -476,7 +476,7 @@ static int hdac_hda_codec_probe(struct snd_soc_component *component)
 		if (ret < 0) {
 			dev_err(&hdev->dev, "unable to create controls %d\n",
 				ret);
-			goto error;
+			goto error_regmap;
 		}
 	}
 
@@ -496,7 +496,9 @@ static int hdac_hda_codec_probe(struct snd_soc_component *component)
 
 	return 0;
 
-error:
+error_regmap:
+	snd_hdac_regmap_exit(hdev);
+error_pm:
 	pm_runtime_put(&hdev->dev);
 error_no_pm:
 	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
@@ -518,6 +520,8 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 
 	pm_runtime_disable(&hdev->dev);
 	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
+
+	snd_hdac_regmap_exit(hdev);
 }
 
 static const struct snd_soc_dapm_route hdac_hda_dapm_routes[] = {
-- 
2.25.1



