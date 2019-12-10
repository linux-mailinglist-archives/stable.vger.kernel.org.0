Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C7F119545
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbfLJVMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:12:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728918AbfLJVMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66712246A8;
        Tue, 10 Dec 2019 21:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012338;
        bh=hpI3x1KQBGanvKU3gE981T5ZKcILSbMyCMdBEjfE7jQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mk5P++PJKfEBPmq2ws3BsSn7k7GxnSKPDZiz6Cz7mWzVAo1Th52Ir7FFYT97rX5aN
         8KdsA1DJj/gBfV5+c8o6eUKK4Mc7kizFdmttEUtrqETNXhwy+i0Kl99iHZgFP0v192
         EzQHiMUc9e2Y9dQX/YF/DrLwMyYZRVltqzhlk3gk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu-Hsuan Hsu <yuhsuan@chromium.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 269/350] ASoC: Intel: kbl_rt5663_rt5514_max98927: Add dmic format constraint
Date:   Tue, 10 Dec 2019 16:06:14 -0500
Message-Id: <20191210210735.9077-230-sashal@kernel.org>
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

From: Yu-Hsuan Hsu <yuhsuan@chromium.org>

[ Upstream commit e2db787bdcb4f2722ecf410168f0583764634e45 ]

On KBL platform, the microphone is attached to external codec(rt5514)
instead of PCH. However, TDM slot between PCH and codec is 16 bits only.
In order to avoid setting wrong format, we should add a constraint to
force to use 16 bits format forever.

Signed-off-by: Yu-Hsuan Hsu <yuhsuan@chromium.org>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190923162940.199580-1-yuhsuan@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c b/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
index 74dda8784f1a0..67b276a65a8d2 100644
--- a/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
+++ b/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
@@ -400,6 +400,9 @@ static int kabylake_dmic_startup(struct snd_pcm_substream *substream)
 	snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_CHANNELS,
 			dmic_constraints);
 
+	runtime->hw.formats = SNDRV_PCM_FMTBIT_S16_LE;
+	snd_pcm_hw_constraint_msbits(runtime, 0, 16, 16);
+
 	return snd_pcm_hw_constraint_list(substream->runtime, 0,
 			SNDRV_PCM_HW_PARAM_RATE, &constraints_rates);
 }
-- 
2.20.1

