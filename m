Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA63817FD3E
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgCJN0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729327AbgCJMzs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:55:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6150020674;
        Tue, 10 Mar 2020 12:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844947;
        bh=b93qjLrP7kBdG7uaRgYsfgoCaOfZGJ8AZBEVQjuy4/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oakv7ZfwEWyB2/To9U5URmbQ3pg9dQf8SKHGbxLFca/0FWMxjSA1cEtwd2xofx2dx
         DggX3m+JMKasscjpGOxyWsmW7WqgOe2vPqtfAXJBGhdMCknRzr9t44cU6iCIFbDS2Y
         LuShnDFJZpyMMzMAHgeAzLP2dioGRLql/j8nGaEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 001/189] ASoC: intel/skl/hda - export number of digital microphones via control components
Date:   Tue, 10 Mar 2020 13:37:18 +0100
Message-Id: <20200310123639.732775259@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

[ Upstream commit 8cd9956f61c65022209ce6d1e55ed12aea12357d ]

It is required for the auto-detection in the user space (for UCM).

Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20191204211556.12671-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/skl_hda_dsp_generic.c | 8 ++++++++
 sound/soc/sof/intel/hda.c                    | 3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/skl_hda_dsp_generic.c b/sound/soc/intel/boards/skl_hda_dsp_generic.c
index 4e45901e3a2f1..11eaee9ae41f7 100644
--- a/sound/soc/intel/boards/skl_hda_dsp_generic.c
+++ b/sound/soc/intel/boards/skl_hda_dsp_generic.c
@@ -100,6 +100,8 @@ static struct snd_soc_card hda_soc_card = {
 	.late_probe = skl_hda_card_late_probe,
 };
 
+static char hda_soc_components[30];
+
 #define IDISP_DAI_COUNT		3
 #define HDAC_DAI_COUNT		2
 #define DMIC_DAI_COUNT		2
@@ -183,6 +185,12 @@ static int skl_hda_audio_probe(struct platform_device *pdev)
 	hda_soc_card.dev = &pdev->dev;
 	snd_soc_card_set_drvdata(&hda_soc_card, ctx);
 
+	if (mach->mach_params.dmic_num > 0) {
+		snprintf(hda_soc_components, sizeof(hda_soc_components),
+				"cfg-dmics:%d", mach->mach_params.dmic_num);
+		hda_soc_card.components = hda_soc_components;
+	}
+
 	return devm_snd_soc_register_card(&pdev->dev, &hda_soc_card);
 }
 
diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 82ecadda886c6..a1780259292fa 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -351,7 +351,7 @@ static int hda_init_caps(struct snd_sof_dev *sdev)
 	const char *tplg_filename;
 	const char *idisp_str;
 	const char *dmic_str;
-	int dmic_num;
+	int dmic_num = 0;
 	int codec_num = 0;
 	int i;
 #endif
@@ -472,6 +472,7 @@ static int hda_init_caps(struct snd_sof_dev *sdev)
 		mach_params->codec_mask = bus->codec_mask;
 		mach_params->platform = dev_name(sdev->dev);
 		mach_params->common_hdmi_codec_drv = hda_codec_use_common_hdmi;
+		mach_params->dmic_num = dmic_num;
 	}
 
 	/* create codec instances */
-- 
2.20.1



