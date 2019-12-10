Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBE81193DA
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbfLJVLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:11:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:33358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728662AbfLJVLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:11:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B407246A8;
        Tue, 10 Dec 2019 21:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012262;
        bh=nuqvFH6o9KTF0TEHIY1C0M5A+8Bghp+L12mrY80vDl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F3330VBDkI55YiODWR+yShfqNpLluAq4hcmmm3w9S3K4+PDSm4Ndz4Dwy1BiT/EXG
         J0xgg66YM3vBX08sb4pX7F9gPCbwqYx08rpsCyFp2VTvBHVxLqf5CfqNj1I243THn4
         1aaEJu9zBVHdh/dyJKxrwTpAn9gFNppqUR3mrqvg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 208/350] ASoC: SOF: topology: set trigger order for FE DAI link
Date:   Tue, 10 Dec 2019 16:05:13 -0500
Message-Id: <20191210210735.9077-169-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 5eee2b3f60065a2530d13f28e771be48b989eb4c ]

Set trigger order for FE DAI links to SND_SOC_DPCM_TRIGGER_POST
to trigger the BE DAI's before the FE DAI's. This prevents the
xruns seen on playback pipelines using the link DMA.

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191104224812.3393-3-ranjani.sridharan@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 4452594c2e17a..fa299e0781561 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -2828,6 +2828,10 @@ static int sof_link_load(struct snd_soc_component *scomp, int index,
 	if (!link->no_pcm) {
 		link->nonatomic = true;
 
+		/* set trigger order */
+		link->trigger[0] = SND_SOC_DPCM_TRIGGER_POST;
+		link->trigger[1] = SND_SOC_DPCM_TRIGGER_POST;
+
 		/* nothing more to do for FE dai links */
 		return 0;
 	}
-- 
2.20.1

