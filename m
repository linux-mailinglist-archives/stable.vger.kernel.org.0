Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8DD2FC6BB
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 02:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbhATB0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 20:26:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:46118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbhATB0q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:26:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B291B2311C;
        Wed, 20 Jan 2021 01:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105965;
        bh=Zgo+Eu0ONQsyiqmfFfZYOd5kp7Y4SaoXFo9SIbMhikc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQTgPSkDXD2XGBV51bqnnGia53i4mqGktyvR39ch7S47YP1Xf8C8d7NeI7Mh2xtPJ
         60ruQHF4tf3Mvh/55lNWFPfw/ri2YfafA6iO6OQPrrmEnRDJtFy6Pjq9yfc+Wo/Hqp
         HcQfokKbtM2nJHJj4O/Qv2v5uflchYgLwRnjYS9O+u84o+c9itVIWq9fdowwQof8jF
         Ig6S6Q2IXaDoyPHbpzepgjxnZOTXazIzJBZZncHCrTtECadYFR2jcShHQinldk5f8x
         M6+KFKapuGJyoasCH3rHqRVPZPoPS/iS5FC8P5F+QctS4sTxTB96NvDxKh7cNCB2iP
         7n7/M9UCXR3Og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuming Fan <shumingf@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 02/45] ASoC: rt711: mutex between calibration and power state changes
Date:   Tue, 19 Jan 2021 20:25:19 -0500
Message-Id: <20210120012602.769683-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 6108f990c0887d3e8f1db2d13c7012e40a061f28 ]

To avoid calibration time-out, this patch adds the mutex between calibration and power state changes

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://lore.kernel.org/r/20201217085651.24580-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/codecs/rt711.c b/sound/soc/codecs/rt711.c
index 65b59dbfb43c8..a9b1b4180c471 100644
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -462,6 +462,8 @@ static int rt711_set_amp_gain_put(struct snd_kcontrol *kcontrol,
 	unsigned int read_ll, read_rl;
 	int i;
 
+	mutex_lock(&rt711->calibrate_mutex);
+
 	/* Can't use update bit function, so read the original value first */
 	addr_h = mc->reg;
 	addr_l = mc->rreg;
@@ -547,6 +549,8 @@ static int rt711_set_amp_gain_put(struct snd_kcontrol *kcontrol,
 	if (dapm->bias_level <= SND_SOC_BIAS_STANDBY)
 		regmap_write(rt711->regmap,
 				RT711_SET_AUDIO_POWER_STATE, AC_PWRST_D3);
+
+	mutex_unlock(&rt711->calibrate_mutex);
 	return 0;
 }
 
@@ -859,9 +863,11 @@ static int rt711_set_bias_level(struct snd_soc_component *component,
 		break;
 
 	case SND_SOC_BIAS_STANDBY:
+		mutex_lock(&rt711->calibrate_mutex);
 		regmap_write(rt711->regmap,
 			RT711_SET_AUDIO_POWER_STATE,
 			AC_PWRST_D3);
+		mutex_unlock(&rt711->calibrate_mutex);
 		break;
 
 	default:
-- 
2.27.0

