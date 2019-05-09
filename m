Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B084C191E2
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbfEISuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:50:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728447AbfEISuf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:50:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5E732183F;
        Thu,  9 May 2019 18:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427834;
        bh=UybR7+64MctBP4TSmvRsvq3QhxyQyi/1HhQQ7WoABHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFUH/uYfL+E7vf8ttcSdu4VecVFXgKXRQZFl5aVu0stCyT0twjYDuGULSkaZT/I3d
         zlC19WTgr0UruicLeuHssLTYMJmVg010VuFyv+S/aD1YAEw8WYUDAJ3iH4NyacxeHY
         AY0/EvXjjjTZXvw6wliq+qYDxGzvwQic28TGrEF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuming Fan <shumingf@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 21/95] ASoC: rt5682: fix jack type detection issue
Date:   Thu,  9 May 2019 20:41:38 +0200
Message-Id: <20190509181310.821993471@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 675212bfb23394514b7f68ebf3954ba936281ccc ]

The jack type detection needs the main bias power of analog.
The modification makes sure the main bias power on/off while jack plug/unplug.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index 49ff5e52db584..9331c13d2017a 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -909,7 +909,8 @@ static int rt5682_headset_detect(struct snd_soc_component *component,
 	if (jack_insert) {
 
 		snd_soc_component_update_bits(component, RT5682_PWR_ANLG_1,
-			RT5682_PWR_VREF2, RT5682_PWR_VREF2);
+			RT5682_PWR_VREF2 | RT5682_PWR_MB,
+			RT5682_PWR_VREF2 | RT5682_PWR_MB);
 		snd_soc_component_update_bits(component,
 				RT5682_PWR_ANLG_1, RT5682_PWR_FV2, 0);
 		usleep_range(15000, 20000);
@@ -946,7 +947,7 @@ static int rt5682_headset_detect(struct snd_soc_component *component,
 		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
 			RT5682_TRIG_JD_MASK, RT5682_TRIG_JD_LOW);
 		snd_soc_component_update_bits(component, RT5682_PWR_ANLG_1,
-			RT5682_PWR_VREF2, 0);
+			RT5682_PWR_VREF2 | RT5682_PWR_MB, 0);
 		snd_soc_component_update_bits(component, RT5682_PWR_ANLG_3,
 			RT5682_PWR_CBJ, 0);
 
@@ -2295,16 +2296,13 @@ static int rt5682_set_bias_level(struct snd_soc_component *component,
 	switch (level) {
 	case SND_SOC_BIAS_PREPARE:
 		regmap_update_bits(rt5682->regmap, RT5682_PWR_ANLG_1,
-			RT5682_PWR_MB | RT5682_PWR_BG,
-			RT5682_PWR_MB | RT5682_PWR_BG);
+			RT5682_PWR_BG, RT5682_PWR_BG);
 		regmap_update_bits(rt5682->regmap, RT5682_PWR_DIG_1,
 			RT5682_DIG_GATE_CTRL | RT5682_PWR_LDO,
 			RT5682_DIG_GATE_CTRL | RT5682_PWR_LDO);
 		break;
 
 	case SND_SOC_BIAS_STANDBY:
-		regmap_update_bits(rt5682->regmap, RT5682_PWR_ANLG_1,
-			RT5682_PWR_MB, RT5682_PWR_MB);
 		regmap_update_bits(rt5682->regmap, RT5682_PWR_DIG_1,
 			RT5682_DIG_GATE_CTRL, RT5682_DIG_GATE_CTRL);
 		break;
@@ -2312,7 +2310,7 @@ static int rt5682_set_bias_level(struct snd_soc_component *component,
 		regmap_update_bits(rt5682->regmap, RT5682_PWR_DIG_1,
 			RT5682_DIG_GATE_CTRL | RT5682_PWR_LDO, 0);
 		regmap_update_bits(rt5682->regmap, RT5682_PWR_ANLG_1,
-			RT5682_PWR_MB | RT5682_PWR_BG, 0);
+			RT5682_PWR_BG, 0);
 		break;
 
 	default:
-- 
2.20.1



