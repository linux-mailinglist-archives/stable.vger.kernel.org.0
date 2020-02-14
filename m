Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB3E215F3A5
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404156AbgBNSNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:13:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731030AbgBNPwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:52:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1147924686;
        Fri, 14 Feb 2020 15:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695560;
        bh=LsO3erdrUgkkKVMYNWXfDkFZw7NLd8nvZFbGJDdSyS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=brZJyh2rOV+Jarqj+Daq0qebZQjjIQkU0Oz0EvVWVPJE5WBKgDebXcmg+DQbfvYjY
         /bAffHHDlr3IOAlD0Uq745rp/APdyxYCMmhB1tFEBQUdg00r+xVZtqQ7+RDuscMVPJ
         5h3GQ4/7G7/kZDk03M9yQFXZkb/q0sVmm5FgO39c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>,
        Jairaj Arava <jairaj.arava@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.5 174/542] ASoC: intel: sof_rt5682: Add support for tgl-max98357a-rt5682
Date:   Fri, 14 Feb 2020 10:42:46 -0500
Message-Id: <20200214154854.6746-174-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 57adadacbf436..ad8a2b4bc7092 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -598,6 +598,9 @@ static int sof_audio_probe(struct platform_device *pdev)
 	if (!ctx)
 		return -ENOMEM;
 
+	if (pdev->id_entry && pdev->id_entry->driver_data)
+		sof_rt5682_quirk = (unsigned long)pdev->id_entry->driver_data;
+
 	dmi_check_system(sof_rt5682_quirk_table);
 
 	if (soc_intel_is_byt() || soc_intel_is_cht()) {
@@ -691,6 +694,21 @@ static int sof_rt5682_remove(struct platform_device *pdev)
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
@@ -698,6 +716,7 @@ static struct platform_driver sof_audio = {
 		.name = "sof_rt5682",
 		.pm = &snd_soc_pm_ops,
 	},
+	.id_table = board_ids,
 };
 module_platform_driver(sof_audio)
 
@@ -707,3 +726,4 @@ MODULE_AUTHOR("Bard Liao <bard.liao@intel.com>");
 MODULE_AUTHOR("Sathya Prakash M R <sathya.prakash.m.r@intel.com>");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:sof_rt5682");
+MODULE_ALIAS("platform:tgl_max98357a_rt5682");
-- 
2.20.1

