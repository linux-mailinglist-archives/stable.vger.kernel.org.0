Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A0838EBB1
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbhEXPGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233932AbhEXPCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:02:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D516D61607;
        Mon, 24 May 2021 14:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867822;
        bh=SyMMuXLcx27bcQBCzQYCvdsU4Yhzpb00nzquy4ej+v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nNfr+xdGc+CYLMHu88cpJzlWME6wMHkdNaE3SaDSRlouxuCxH2Y0chPPAhVv+30ys
         ZNVadgHukGoEBBnvx7+OTBocY7M1VccnYKT6lHvEsBS/aELL98trHlW15vcY9/cr9S
         MZNobVNEIltzD1mbeLJPecuRkLU1mVSqDOE8A3UWwJa5BzLZtyR1b/+ZL8xrX6GdYh
         hqtSQQL7l9cBj3NqaR0GEjx11D5X//kReyRr42+EHrFoM69sok6cCZLCzcQN0MP+AB
         /GQzf8Gh9odXCsoaICjxkcay5Pq+TKC8QNZvmHJ/3lL6uzS0ubvyIEfnM5Oa+1nKlB
         tbOm3Ykj28rZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phillip Potter <phil@philpotter.co.uk>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 11/25] ASoC: rt5645: add error checking to rt5645_probe function
Date:   Mon, 24 May 2021 10:49:54 -0400
Message-Id: <20210524145008.2499049-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145008.2499049-1-sashal@kernel.org>
References: <20210524145008.2499049-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

[ Upstream commit 5e70b8e22b64eed13d5bbebcb5911dae65bf8c6b ]

Check for return value from various snd_soc_dapm_* calls, as many of
them can return errors and this should be handled. Also, reintroduce
the allocation failure check for rt5645->eq_param as well. Make all
areas where return values are checked lead to the end of the function
in the case of an error. Finally, introduce a comment explaining how
resources here are actually eventually cleaned up by the caller.

Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://lore.kernel.org/r/20210503115736.2104747-56-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5645.c | 48 +++++++++++++++++++++++++++++++--------
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index 9185bd7c5a6d..d8b941bb9f8a 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3413,30 +3413,44 @@ static int rt5645_probe(struct snd_soc_component *component)
 {
 	struct snd_soc_dapm_context *dapm = snd_soc_component_get_dapm(component);
 	struct rt5645_priv *rt5645 = snd_soc_component_get_drvdata(component);
+	int ret = 0;
 
 	rt5645->component = component;
 
 	switch (rt5645->codec_type) {
 	case CODEC_TYPE_RT5645:
-		snd_soc_dapm_new_controls(dapm,
+		ret = snd_soc_dapm_new_controls(dapm,
 			rt5645_specific_dapm_widgets,
 			ARRAY_SIZE(rt5645_specific_dapm_widgets));
-		snd_soc_dapm_add_routes(dapm,
+		if (ret < 0)
+			goto exit;
+
+		ret = snd_soc_dapm_add_routes(dapm,
 			rt5645_specific_dapm_routes,
 			ARRAY_SIZE(rt5645_specific_dapm_routes));
+		if (ret < 0)
+			goto exit;
+
 		if (rt5645->v_id < 3) {
-			snd_soc_dapm_add_routes(dapm,
+			ret = snd_soc_dapm_add_routes(dapm,
 				rt5645_old_dapm_routes,
 				ARRAY_SIZE(rt5645_old_dapm_routes));
+			if (ret < 0)
+				goto exit;
 		}
 		break;
 	case CODEC_TYPE_RT5650:
-		snd_soc_dapm_new_controls(dapm,
+		ret = snd_soc_dapm_new_controls(dapm,
 			rt5650_specific_dapm_widgets,
 			ARRAY_SIZE(rt5650_specific_dapm_widgets));
-		snd_soc_dapm_add_routes(dapm,
+		if (ret < 0)
+			goto exit;
+
+		ret = snd_soc_dapm_add_routes(dapm,
 			rt5650_specific_dapm_routes,
 			ARRAY_SIZE(rt5650_specific_dapm_routes));
+		if (ret < 0)
+			goto exit;
 		break;
 	}
 
@@ -3444,9 +3458,17 @@ static int rt5645_probe(struct snd_soc_component *component)
 
 	/* for JD function */
 	if (rt5645->pdata.jd_mode) {
-		snd_soc_dapm_force_enable_pin(dapm, "JD Power");
-		snd_soc_dapm_force_enable_pin(dapm, "LDO2");
-		snd_soc_dapm_sync(dapm);
+		ret = snd_soc_dapm_force_enable_pin(dapm, "JD Power");
+		if (ret < 0)
+			goto exit;
+
+		ret = snd_soc_dapm_force_enable_pin(dapm, "LDO2");
+		if (ret < 0)
+			goto exit;
+
+		ret = snd_soc_dapm_sync(dapm);
+		if (ret < 0)
+			goto exit;
 	}
 
 	if (rt5645->pdata.long_name)
@@ -3456,7 +3478,15 @@ static int rt5645_probe(struct snd_soc_component *component)
 		RT5645_HWEQ_NUM, sizeof(struct rt5645_eq_param_s),
 		GFP_KERNEL);
 
-	return 0;
+	if (!rt5645->eq_param)
+		ret = -ENOMEM;
+exit:
+	/*
+	 * If there was an error above, everything will be cleaned up by the
+	 * caller if we return an error here.  This will be done with a later
+	 * call to rt5645_remove().
+	 */
+	return ret;
 }
 
 static void rt5645_remove(struct snd_soc_component *component)
-- 
2.30.2

