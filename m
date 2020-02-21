Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF331672A9
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731838AbgBUIFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:05:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:39120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731834AbgBUIFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:05:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F14CF20801;
        Fri, 21 Feb 2020 08:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272333;
        bh=j6vTk5xwIZQxMl0N+87vCz7J+K5hKkkEZIizq5rdXXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGVf+wmipJgxtEfZUHGox91rvAzpW4bitpfG6LwyVxAV0+RW9+5hf9A02gSXkNv+L
         X5mb9yXjMQqu0/63Q5KRDcvRow6NW3fOPgg1Umu5ieuq1cl4Ale+WIhHObjOzAOcf1
         MIlvPovuHIx/QccjWYuLpOwG5T4ug7l93faZXIZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>,
        Jairaj Arava <jairaj.arava@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/344] ASoC: intel: sof_rt5682: Add support for tgl-max98357a-rt5682
Date:   Fri, 21 Feb 2020 08:38:21 +0100
Message-Id: <20200221072358.195116953@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>

[ Upstream commit 6605f0ca3af3b964635287ec7c9dadc812b78eb0 ]

This patch adds the driver data and updates quirk info
for tgl with max98357a speaker amp and ALC5682 headset codec.

Signed-off-by: Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>
Signed-off-by: Jairaj Arava <jairaj.arava@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191126143205.21987-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_rt5682.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/soc/intel/boards/sof_rt5682.c b/sound/soc/intel/boards/sof_rt5682.c
index 377ff17dedb98..9441ddfeea5e6 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -589,6 +589,9 @@ static int sof_audio_probe(struct platform_device *pdev)
 	if (!ctx)
 		return -ENOMEM;
 
+	if (pdev->id_entry && pdev->id_entry->driver_data)
+		sof_rt5682_quirk = (unsigned long)pdev->id_entry->driver_data;
+
 	dmi_check_system(sof_rt5682_quirk_table);
 
 	if (soc_intel_is_byt() || soc_intel_is_cht()) {
@@ -680,6 +683,21 @@ static int sof_rt5682_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct platform_device_id board_ids[] = {
+	{
+		.name = "sof_rt5682",
+	},
+	{
+		.name = "tgl_max98357a_rt5682",
+		.driver_data = (kernel_ulong_t)(SOF_RT5682_MCLK_EN |
+					SOF_RT5682_SSP_CODEC(0) |
+					SOF_SPEAKER_AMP_PRESENT |
+					SOF_RT5682_SSP_AMP(1) |
+					SOF_RT5682_NUM_HDMIDEV(4)),
+	},
+	{ }
+};
+
 static struct platform_driver sof_audio = {
 	.probe = sof_audio_probe,
 	.remove = sof_rt5682_remove,
@@ -687,6 +705,7 @@ static struct platform_driver sof_audio = {
 		.name = "sof_rt5682",
 		.pm = &snd_soc_pm_ops,
 	},
+	.id_table = board_ids,
 };
 module_platform_driver(sof_audio)
 
@@ -696,3 +715,4 @@ MODULE_AUTHOR("Bard Liao <bard.liao@intel.com>");
 MODULE_AUTHOR("Sathya Prakash M R <sathya.prakash.m.r@intel.com>");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:sof_rt5682");
+MODULE_ALIAS("platform:tgl_max98357a_rt5682");
-- 
2.20.1



