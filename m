Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C08A3F6636
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240350AbhHXRVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240625AbhHXRTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:19:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5891C61AE4;
        Tue, 24 Aug 2021 17:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824584;
        bh=AdB+6W+BrgRqFYWEcJ3RARVB1zXAwLFpkSeDwRHFgpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gkkBjpNsTm4Cux/JIQCXfz3LhQGjDqQH0CTIBk5VJnefzLzU6/3Yh9j1ij06KhAHh
         I4urbFsGKOg8wvChnF3g45wvMAVrJ/LxMhP2Ls++eCEwh6kBVCIdkgW/wmPD9SbrcV
         aTOXL/uv8kSPOgPPRR0FSBW3koIuceZtgjHGaEbdYl1MTES6v2XB7O48pUy6bZRRSk
         q0z7HLZxavKVZVpceu/S2EvlmW83QkXiXOYgHggjq9n+pbu/wBocBTS3yQgiudfaS4
         fma4sHc9b57rjBAf0YsrDJ7UHVb+cmh5HAuBVriYc44y03BsZMe4Im1BLdI29xg64F
         s8BqDObGXr0bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/84] ASoC: cs42l42: Fix LRCLK frame start edge
Date:   Tue, 24 Aug 2021 13:01:38 -0400
Message-Id: <20210824170250.710392-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 0c2f2ad4f16a58879463d0979a54293f8f296d6f ]

An I2S frame starts on the falling edge of LRCLK so ASP_STP must
be 0.

At the same time, move other format settings in the same register
from cs42l42_pll_config() to cs42l42_set_dai_fmt() where you'd
expect to find them, and merge into a single write.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 2c394ca79604 ("ASoC: Add support for CS42L42 codec")
Link: https://lore.kernel.org/r/20210805161111.10410-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index fb12fcf88878..4cb3e11c66af 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -659,15 +659,6 @@ static int cs42l42_pll_config(struct snd_soc_component *component)
 					CS42L42_FSYNC_PULSE_WIDTH_MASK,
 					CS42L42_FRAC1_VAL(fsync - 1) <<
 					CS42L42_FSYNC_PULSE_WIDTH_SHIFT);
-			snd_soc_component_update_bits(component,
-					CS42L42_ASP_FRM_CFG,
-					CS42L42_ASP_5050_MASK,
-					CS42L42_ASP_5050_MASK);
-			/* Set the frame delay to 1.0 SCLK clocks */
-			snd_soc_component_update_bits(component, CS42L42_ASP_FRM_CFG,
-					CS42L42_ASP_FSD_MASK,
-					CS42L42_ASP_FSD_1_0 <<
-					CS42L42_ASP_FSD_SHIFT);
 			/* Set the sample rates (96k or lower) */
 			snd_soc_component_update_bits(component, CS42L42_FS_RATE_EN,
 					CS42L42_FS_EN_MASK,
@@ -763,6 +754,18 @@ static int cs42l42_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 	/* interface format */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
+		/*
+		 * 5050 mode, frame starts on falling edge of LRCLK,
+		 * frame delayed by 1.0 SCLKs
+		 */
+		snd_soc_component_update_bits(component,
+					      CS42L42_ASP_FRM_CFG,
+					      CS42L42_ASP_STP_MASK |
+					      CS42L42_ASP_5050_MASK |
+					      CS42L42_ASP_FSD_MASK,
+					      CS42L42_ASP_5050_MASK |
+					      (CS42L42_ASP_FSD_1_0 <<
+						CS42L42_ASP_FSD_SHIFT));
 		break;
 	default:
 		return -EINVAL;
-- 
2.30.2

