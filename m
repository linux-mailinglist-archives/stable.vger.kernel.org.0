Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58C41BFC90
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgD3OGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 10:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728502AbgD3Nwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:52:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 650C924962;
        Thu, 30 Apr 2020 13:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254766;
        bh=t4pVoz7J8jkAn/McnyM5UibjHvcOHSChe4RvxUmvIPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1L6XItPMQGZH89D+v6QbeY1nfH0wyMvryGUwysLP/B97McMSDTa1fEutjt+Ila9L
         yOPej5OSjhQ36zq09htXXXGJioy4MugVn+571FryCSS61nJpHtWn1C+rq/CTrysm1y
         IG0gJZf9xFYGt3d710OHYqMbReluO+Lbmk5Hfdcw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 24/57] ASoC: SOF: Intel: add min/max channels for SSP on Baytrail/Broadwell
Date:   Thu, 30 Apr 2020 09:51:45 -0400
Message-Id: <20200430135218.20372-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135218.20372-1-sashal@kernel.org>
References: <20200430135218.20372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 8c05246c0b58cbe80580ea4be05f6d51228af8a9 ]

Major regressions were detected by SOF CI on CherryTrail and Broadwell:

[   25.705750]  SSP2-Codec: ASoC: no backend playback stream
[   27.923378]  SSP2-Codec: ASoC: no users playback at close - state

This is root-caused to the introduction of the DAI capability checks
with snd_soc_dai_stream_valid(). Its use in soc-pcm.c makes it a
requirement for all DAIs to report at least a non-zero min_channels
field.

For some reason the SSP structures used for SKL+ did provide this
information but legacy platforms didn't.

Fixes: 9b5db059366ae2 ("ASoC: soc-pcm: dpcm: Only allow playback/capture if supported")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200417172014.11760-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/bdw.c | 16 +++++++++++++
 sound/soc/sof/intel/byt.c | 48 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/sound/soc/sof/intel/bdw.c b/sound/soc/sof/intel/bdw.c
index 80e2826fb447b..8ede5fd0d0c0f 100644
--- a/sound/soc/sof/intel/bdw.c
+++ b/sound/soc/sof/intel/bdw.c
@@ -520,9 +520,25 @@ static int bdw_probe(struct snd_sof_dev *sdev)
 static struct snd_soc_dai_driver bdw_dai[] = {
 {
 	.name = "ssp0-port",
+	.playback = {
+		.channels_min = 1,
+		.channels_max = 8,
+	},
+	.capture = {
+		.channels_min = 1,
+		.channels_max = 8,
+	},
 },
 {
 	.name = "ssp1-port",
+	.playback = {
+		.channels_min = 1,
+		.channels_max = 8,
+	},
+	.capture = {
+		.channels_min = 1,
+		.channels_max = 8,
+	},
 },
 };
 
diff --git a/sound/soc/sof/intel/byt.c b/sound/soc/sof/intel/byt.c
index 41008c974ac6c..cdffdc5d40759 100644
--- a/sound/soc/sof/intel/byt.c
+++ b/sound/soc/sof/intel/byt.c
@@ -366,21 +366,69 @@ static int byt_reset(struct snd_sof_dev *sdev)
 static struct snd_soc_dai_driver byt_dai[] = {
 {
 	.name = "ssp0-port",
+	.playback = {
+		.channels_min = 1,
+		.channels_max = 8,
+	},
+	.capture = {
+		.channels_min = 1,
+		.channels_max = 8,
+	},
 },
 {
 	.name = "ssp1-port",
+	.playback = {
+		.channels_min = 1,
+		.channels_max = 8,
+	},
+	.capture = {
+		.channels_min = 1,
+		.channels_max = 8,
+	},
 },
 {
 	.name = "ssp2-port",
+	.playback = {
+		.channels_min = 1,
+		.channels_max = 8,
+	},
+	.capture = {
+		.channels_min = 1,
+		.channels_max = 8,
+	}
 },
 {
 	.name = "ssp3-port",
+	.playback = {
+		.channels_min = 1,
+		.channels_max = 8,
+	},
+	.capture = {
+		.channels_min = 1,
+		.channels_max = 8,
+	},
 },
 {
 	.name = "ssp4-port",
+	.playback = {
+		.channels_min = 1,
+		.channels_max = 8,
+	},
+	.capture = {
+		.channels_min = 1,
+		.channels_max = 8,
+	},
 },
 {
 	.name = "ssp5-port",
+	.playback = {
+		.channels_min = 1,
+		.channels_max = 8,
+	},
+	.capture = {
+		.channels_min = 1,
+		.channels_max = 8,
+	},
 },
 };
 
-- 
2.20.1

