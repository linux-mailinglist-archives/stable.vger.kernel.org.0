Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E443ED5EE
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239533AbhHPNP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:15:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239965AbhHPNOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:14:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79C57632CF;
        Mon, 16 Aug 2021 13:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119519;
        bh=YyzlmPWgNXITyVKGTec3nyFpOcV4xni7HRKf2xe/YGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbYNAV8v5g0ie6A1TvjiAiOa8UNtjy9nuKrrkcJ6PszrhzthxEpLXwTK0+v+1k8w4
         uvoldLF17hzZV0ivS6QktpLVLCf9kqE0Yq0Wm2pmUsHcQGt5RYUEWPJ+27+aS6pfkB
         W7bOUKZllmBYHWjWCzY78FnxFf7rOqJLd8CkjsyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 056/151] ASoC: cs42l42: Fix mono playback
Date:   Mon, 16 Aug 2021 15:01:26 +0200
Message-Id: <20210816125445.910989644@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit e5ada3f6787a4d6234adc6f2f3ae35c6d5b71ba0 ]

I2S always has two LRCLK phases and both CH1 and CH2 of the RX
must be enabled (corresponding to the low and high phases of LRCLK.)
The selection of the valid data channels is done by setting the DAC
CHA_SEL and CHB_SEL. CHA_SEL is always the first (left) channel,
CHB_SEL depends on the number of active channels.

Previously for mono ASP CH2 was not enabled, the result was playing
mono data would not produce any audio output.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 621d65f3b868 ("ASoC: cs42l42: Provide finer control on playback path")
Link: https://lore.kernel.org/r/20210805161111.10410-4-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 15 +++++++++++++--
 sound/soc/codecs/cs42l42.h |  2 ++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 0c8cdfe78d96..e0a524f8e16c 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -459,8 +459,8 @@ static const struct snd_soc_dapm_widget cs42l42_dapm_widgets[] = {
 	SND_SOC_DAPM_OUTPUT("HP"),
 	SND_SOC_DAPM_DAC("DAC", NULL, CS42L42_PWR_CTL1, CS42L42_HP_PDN_SHIFT, 1),
 	SND_SOC_DAPM_MIXER("MIXER", CS42L42_PWR_CTL1, CS42L42_MIXER_PDN_SHIFT, 1, NULL, 0),
-	SND_SOC_DAPM_AIF_IN("SDIN1", NULL, 0, CS42L42_ASP_RX_DAI0_EN, CS42L42_ASP_RX0_CH1_SHIFT, 0),
-	SND_SOC_DAPM_AIF_IN("SDIN2", NULL, 1, CS42L42_ASP_RX_DAI0_EN, CS42L42_ASP_RX0_CH2_SHIFT, 0),
+	SND_SOC_DAPM_AIF_IN("SDIN1", NULL, 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_IN("SDIN2", NULL, 1, SND_SOC_NOPM, 0, 0),
 
 	/* Playback Requirements */
 	SND_SOC_DAPM_SUPPLY("ASP DAI0", CS42L42_PWR_CTL1, CS42L42_ASP_DAI_PDN_SHIFT, 1, NULL, 0),
@@ -837,6 +837,17 @@ static int cs42l42_pcm_hw_params(struct snd_pcm_substream *substream,
 		snd_soc_component_update_bits(component, CS42L42_ASP_RX_DAI0_CH2_AP_RES,
 							 CS42L42_ASP_RX_CH_AP_MASK |
 							 CS42L42_ASP_RX_CH_RES_MASK, val);
+
+		/* Channel B comes from the last active channel */
+		snd_soc_component_update_bits(component, CS42L42_SP_RX_CH_SEL,
+					      CS42L42_SP_RX_CHB_SEL_MASK,
+					      (channels - 1) << CS42L42_SP_RX_CHB_SEL_SHIFT);
+
+		/* Both LRCLK slots must be enabled */
+		snd_soc_component_update_bits(component, CS42L42_ASP_RX_DAI0_EN,
+					      CS42L42_ASP_RX0_CH_EN_MASK,
+					      BIT(CS42L42_ASP_RX0_CH1_SHIFT) |
+					      BIT(CS42L42_ASP_RX0_CH2_SHIFT));
 		break;
 	default:
 		break;
diff --git a/sound/soc/codecs/cs42l42.h b/sound/soc/codecs/cs42l42.h
index 38fd91a168ae..10cf2e4c8ead 100644
--- a/sound/soc/codecs/cs42l42.h
+++ b/sound/soc/codecs/cs42l42.h
@@ -653,6 +653,8 @@
 
 /* Page 0x25 Audio Port Registers */
 #define CS42L42_SP_RX_CH_SEL		(CS42L42_PAGE_25 + 0x01)
+#define CS42L42_SP_RX_CHB_SEL_SHIFT	2
+#define CS42L42_SP_RX_CHB_SEL_MASK	(3 << CS42L42_SP_RX_CHB_SEL_SHIFT)
 
 #define CS42L42_SP_RX_ISOC_CTL		(CS42L42_PAGE_25 + 0x02)
 #define CS42L42_SP_RX_RSYNC_SHIFT	6
-- 
2.30.2



