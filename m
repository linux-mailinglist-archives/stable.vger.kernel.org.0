Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83BEE38E972
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbhEXOtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233326AbhEXOs2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:48:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A1D2613B6;
        Mon, 24 May 2021 14:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867620;
        bh=Myo0OzaoMPDK2v0dbEFHWTxeSMSFdgX4JF++vJTCP0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcBdUsYlpqEP4F1UCP/CJh5u81oHkkzSLJTozXMWJ/pv9gJrE7LKiPl1pwDjK2cDf
         BKyvVmHzz/qZEwKWXopNf3LecnSGxcCzvU+1PPCHlA7Py4cke4ohsWU7FMNKiJ0Dxb
         Dyz2uWL/N3+FWm6OJw9eVLn5hdKgI97puy3nupKHuIElj0cKhNnLGxlozV/R2KcG/2
         wPYx1eswgD3mps+iXdfWrUFVl1xaN9J3YH8vAeY0YGMOgFoNKkMMNsYVHz+PYx3gWE
         DqW9zinIj7OFTrQ1oqMaHD9htthZEQqm0VgVcW+FmZkXC4/Eyr6UbkWw0nU+/Idf+L
         BYqS/fgLPAB9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phillip Potter <phil@philpotter.co.uk>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 30/63] ASoC: rt5645: add error checking to rt5645_probe function
Date:   Mon, 24 May 2021 10:45:47 -0400
Message-Id: <20210524144620.2497249-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
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
index ab06133a85da..85ab33bdcdec 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3364,30 +3364,44 @@ static int rt5645_probe(struct snd_soc_component *component)
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
 
@@ -3395,9 +3409,17 @@ static int rt5645_probe(struct snd_soc_component *component)
 
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
@@ -3407,7 +3429,15 @@ static int rt5645_probe(struct snd_soc_component *component)
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

