Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6E82E413F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439428AbgL1PE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:04:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438548AbgL1OLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DDCF205CB;
        Mon, 28 Dec 2020 14:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164667;
        bh=tXW7QV4c1Q+aqAklPVE0TP/deYlYUF6726RyfvlR2Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6a73Ggq60Us0Fg7m3wCNSeR3uGM3U9IkrNzZ99U0urbfNSCw6ajdSHwBz+X1Dxkd
         xw+x9/OLZRQyG8P0Dq04sGB3xeR+HcWTn/Ltrlta+hbYinTaOdc46VSBrO4+nMmjBS
         A9uuYuYZ0bRDbej4xYGmUpHe/Dwp1CUIP+wbSRyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 256/717] ASoC: Intel: Boards: tgl_max98373: update TDM slot_width
Date:   Mon, 28 Dec 2020 13:44:14 +0100
Message-Id: <20201228125033.253055748@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>

[ Upstream commit 0d7f2459ae926a964ab211aac413d72074131727 ]

Speaker amp's SSP bclk configuration was changed in the topology file to be
based on 12.288MHz and dai_ops->hw_params is based on s32le format.
But, the TDM slot size remained set to 24 bits.
This inconsistency created audible noises and needs to be corrected.
This patch updates TDM slot width to 32.

Fixes: bc7477fc2ab4 ("ASoC: Intel: Boards: tgl_max98373: Update TDM configuration in hw_params")

Signed-off-by: Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20201201211150.433472-1-ranjani.sridharan@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_maxim_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/boards/sof_maxim_common.c b/sound/soc/intel/boards/sof_maxim_common.c
index b6e63ea13d64e..c2a9757181fe1 100644
--- a/sound/soc/intel/boards/sof_maxim_common.c
+++ b/sound/soc/intel/boards/sof_maxim_common.c
@@ -49,11 +49,11 @@ static int max98373_hw_params(struct snd_pcm_substream *substream,
 	for_each_rtd_codec_dais(rtd, j, codec_dai) {
 		if (!strcmp(codec_dai->component->name, MAX_98373_DEV0_NAME)) {
 			/* DEV0 tdm slot configuration */
-			snd_soc_dai_set_tdm_slot(codec_dai, 0x03, 3, 8, 24);
+			snd_soc_dai_set_tdm_slot(codec_dai, 0x03, 3, 8, 32);
 		}
 		if (!strcmp(codec_dai->component->name, MAX_98373_DEV1_NAME)) {
 			/* DEV1 tdm slot configuration */
-			snd_soc_dai_set_tdm_slot(codec_dai, 0x0C, 3, 8, 24);
+			snd_soc_dai_set_tdm_slot(codec_dai, 0x0C, 3, 8, 32);
 		}
 	}
 	return 0;
-- 
2.27.0



