Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A800C20D9AE
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388145AbgF2Ttm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387744AbgF2Tkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B1902489C;
        Mon, 29 Jun 2020 15:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444395;
        bh=ZsO/Gz2btHq/e4G43/KKmYyVu0Zy/snV+DU8BBNW4Mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxV7QZpmf5SaKrzpNPHLg03NRdFGgeLPgRMwdH+xQZ0SnQgn4JLklroAp2/EDlFsF
         lJmFSzJF7qpqZI0yn6Q61XHdsC7T6lsbk5jZc9rmyqzrVMGFKu51HmsE0N7v9//l/E
         wkwSSegyEU+gzTG7IyvLSt0FTnOH6wWU4snV45f0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shengjiu Wang <shengjiu.wang@nxp.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/178] ASoC: fsl_ssi: Fix bclk calculation for mono channel
Date:   Mon, 29 Jun 2020 11:23:37 -0400
Message-Id: <20200629152523.2494198-73-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit ed1220df6e666500ebf58c4f2fccc681941646fb ]

For mono channel, SSI will switch to Normal mode.

In Normal mode and Network mode, the Word Length Control bits
control the word length divider in clock generator, which is
different with I2S Master mode (the word length is fixed to
32bit), it should be the value of params_width(hw_params).

The condition "slots == 2" is not good for I2S Master mode,
because for Network mode and Normal mode, the slots can also
be 2. Then we need to use (ssi->i2s_net & SSI_SCR_I2S_MODE_MASK)
to check if it is I2S Master mode.

So we refine the formula for mono channel, otherwise there
will be sound issue for S24_LE.

Fixes: b0a7043d5c2c ("ASoC: fsl_ssi: Caculate bit clock rate using slot number and width")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Nicolin Chen <nicoleotsuka@gmail.com>
Link: https://lore.kernel.org/r/034eff1435ff6ce300b6c781130cefd9db22ab9a.1592276147.git.shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_ssi.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index 537dc69256f0e..a4ebd6ddaba10 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -678,8 +678,9 @@ static int fsl_ssi_set_bclk(struct snd_pcm_substream *substream,
 	struct regmap *regs = ssi->regs;
 	u32 pm = 999, div2, psr, stccr, mask, afreq, factor, i;
 	unsigned long clkrate, baudrate, tmprate;
-	unsigned int slots = params_channels(hw_params);
-	unsigned int slot_width = 32;
+	unsigned int channels = params_channels(hw_params);
+	unsigned int slot_width = params_width(hw_params);
+	unsigned int slots = 2;
 	u64 sub, savesub = 100000;
 	unsigned int freq;
 	bool baudclk_is_used;
@@ -688,10 +689,14 @@ static int fsl_ssi_set_bclk(struct snd_pcm_substream *substream,
 	/* Override slots and slot_width if being specifically set... */
 	if (ssi->slots)
 		slots = ssi->slots;
-	/* ...but keep 32 bits if slots is 2 -- I2S Master mode */
-	if (ssi->slot_width && slots != 2)
+	if (ssi->slot_width)
 		slot_width = ssi->slot_width;
 
+	/* ...but force 32 bits for stereo audio using I2S Master Mode */
+	if (channels == 2 &&
+	    (ssi->i2s_net & SSI_SCR_I2S_MODE_MASK) == SSI_SCR_I2S_MODE_MASTER)
+		slot_width = 32;
+
 	/* Generate bit clock based on the slot number and slot width */
 	freq = slots * slot_width * params_rate(hw_params);
 
-- 
2.25.1

