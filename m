Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8194E46371B
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242396AbhK3OvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:51:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45046 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236373AbhK3OvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:51:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A22E9B81A23;
        Tue, 30 Nov 2021 14:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55990C53FD1;
        Tue, 30 Nov 2021 14:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283668;
        bh=0Krd4E4woD+Cc38qkD/E7iviZwZsDMe3h4W69+poasw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fOVdSDAjEQRoLFIzdPjbZiw13NX+1jVz9wjh8GAAVW1ZJpDaTOW2LslJ9cPoO4RnO
         BQFcOehc6PB01I6TACPi8rvrKGREGXHqZQvu5WSXGW5Xib6EQmM4anU+wMizauIInX
         Ylj+4jpJXoSUfL0lgahgQOgYQkN7QIcTXHHfT6tYkp5gI0XEMih5CFO3MVwzQ/zz1i
         uAEUtpTaZjVm6JYayymAYRKeseuLtPxeO5ATEU+aK++p3YuIX2wCGVqfX7350QnJCB
         j8IUx70sXEO3LCESfProQ5Nx2SzwDL+uPraOWrCb2ZY8ChqdLs/HbmS8MAsm0ebdNO
         rqEtwj35zCz/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Derek Fang <derek.fang@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 11/68] ASoC: rt5682: Avoid the unexpected IRQ event during going to suspend
Date:   Tue, 30 Nov 2021 09:46:07 -0500
Message-Id: <20211130144707.944580-11-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Derek Fang <derek.fang@realtek.com>

[ Upstream commit a3774a2a6544a7a4a85186e768afc07044aa507f ]

When the system suspends, the codec driver will set SAR to
power saving mode if a headset is plugged in.
There is a chance to generate an unexpected IRQ, and leads to
issues after resuming such as noise from OMTP type headsets.

Signed-off-by: Derek Fang <derek.fang@realtek.com>
Link: https://lore.kernel.org/r/20211109095450.12950-1-derek.fang@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index d550c0705c28b..cfa284855c84e 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -48,6 +48,7 @@ static const struct reg_sequence patch_list[] = {
 	{RT5682_SAR_IL_CMD_6, 0x0110},
 	{RT5682_CHARGE_PUMP_1, 0x0210},
 	{RT5682_HP_LOGIC_CTRL_2, 0x0007},
+	{RT5682_SAR_IL_CMD_2, 0xac00},
 };
 
 void rt5682_apply_patch_list(struct rt5682_priv *rt5682, struct device *dev)
@@ -2961,9 +2962,6 @@ static int rt5682_suspend(struct snd_soc_component *component)
 	cancel_delayed_work_sync(&rt5682->jack_detect_work);
 	cancel_delayed_work_sync(&rt5682->jd_check_work);
 	if (rt5682->hs_jack && rt5682->jack_type == SND_JACK_HEADSET) {
-		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
-			RT5682_MB1_PATH_MASK | RT5682_MB2_PATH_MASK,
-			RT5682_CTRL_MB1_REG | RT5682_CTRL_MB2_REG);
 		val = snd_soc_component_read(component,
 				RT5682_CBJ_CTRL_2) & RT5682_JACK_TYPE_MASK;
 
@@ -2985,10 +2983,15 @@ static int rt5682_suspend(struct snd_soc_component *component)
 		/* enter SAR ADC power saving mode */
 		snd_soc_component_update_bits(component, RT5682_SAR_IL_CMD_1,
 			RT5682_SAR_BUTT_DET_MASK | RT5682_SAR_BUTDET_MODE_MASK |
-			RT5682_SAR_BUTDET_RST_MASK | RT5682_SAR_SEL_MB1_MB2_MASK, 0);
+			RT5682_SAR_SEL_MB1_MB2_MASK, 0);
+		usleep_range(5000, 6000);
+		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
+			RT5682_MB1_PATH_MASK | RT5682_MB2_PATH_MASK,
+			RT5682_CTRL_MB1_REG | RT5682_CTRL_MB2_REG);
+		usleep_range(10000, 12000);
 		snd_soc_component_update_bits(component, RT5682_SAR_IL_CMD_1,
-			RT5682_SAR_BUTT_DET_MASK | RT5682_SAR_BUTDET_MODE_MASK | RT5682_SAR_BUTDET_RST_MASK,
-			RT5682_SAR_BUTT_DET_EN | RT5682_SAR_BUTDET_POW_SAV | RT5682_SAR_BUTDET_RST_NORMAL);
+			RT5682_SAR_BUTT_DET_MASK | RT5682_SAR_BUTDET_MODE_MASK,
+			RT5682_SAR_BUTT_DET_EN | RT5682_SAR_BUTDET_POW_SAV);
 	}
 
 	regcache_cache_only(rt5682->regmap, true);
-- 
2.33.0

