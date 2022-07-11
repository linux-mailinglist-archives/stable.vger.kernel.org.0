Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335E956FCDB
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbiGKJsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiGKJsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:48:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1824AC046;
        Mon, 11 Jul 2022 02:23:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49415612FB;
        Mon, 11 Jul 2022 09:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5932FC34115;
        Mon, 11 Jul 2022 09:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531404;
        bh=+2dRXOeAnlD/vyR6PU7WTgRs5uidsGKSRXNCXxva60s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pjfqYZsAjIeeit7w3E3VtcBeQ4H07pYufgttHj2XPV89VxORjRhykkeuwB221DTIM
         W1vcab7oUl74gz++ogX2P1oar9XIa45FFO5HwQvXdf6SEjLdSquvpkCPmXVr+a1Scv
         PMmqWqBEva3vk4EpHEcnFEVNqxpI9K2NnoobIyqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Derek Fang <derek.fang@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/230] ASoC: rt5682: Avoid the unexpected IRQ event during going to suspend
Date:   Mon, 11 Jul 2022 11:05:09 +0200
Message-Id: <20220711090605.584904593@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 6ad3159eceb9..949b5638db29 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -48,6 +48,7 @@ static const struct reg_sequence patch_list[] = {
 	{RT5682_SAR_IL_CMD_6, 0x0110},
 	{RT5682_CHARGE_PUMP_1, 0x0210},
 	{RT5682_HP_LOGIC_CTRL_2, 0x0007},
+	{RT5682_SAR_IL_CMD_2, 0xac00},
 };
 
 void rt5682_apply_patch_list(struct rt5682_priv *rt5682, struct device *dev)
@@ -2969,9 +2970,6 @@ static int rt5682_suspend(struct snd_soc_component *component)
 	cancel_delayed_work_sync(&rt5682->jack_detect_work);
 	cancel_delayed_work_sync(&rt5682->jd_check_work);
 	if (rt5682->hs_jack && rt5682->jack_type == SND_JACK_HEADSET) {
-		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
-			RT5682_MB1_PATH_MASK | RT5682_MB2_PATH_MASK,
-			RT5682_CTRL_MB1_REG | RT5682_CTRL_MB2_REG);
 		val = snd_soc_component_read(component,
 				RT5682_CBJ_CTRL_2) & RT5682_JACK_TYPE_MASK;
 
@@ -2993,10 +2991,15 @@ static int rt5682_suspend(struct snd_soc_component *component)
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
2.35.1



