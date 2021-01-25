Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB97302AAF
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbhAYStd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:49:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730725AbhAYSsZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:48:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84F8620665;
        Mon, 25 Jan 2021 18:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600490;
        bh=Zgo+Eu0ONQsyiqmfFfZYOd5kp7Y4SaoXFo9SIbMhikc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1AtN6nIuvXT4TbnBcH10D35QweeKOCehBF4HKm4ab4j3ZnK9Skv7T8PKGoN28UdAd
         B2SFHjaG28GVP19SWAaV/DYa/zo4Y3WDBnisuaVJf1IVEte/LMUVpmZNfZqW39nS/0
         i+Os1M1YuknIMWFBjjA1a3EKLoiytZAvjXVLz5sQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuming Fan <shumingf@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/199] ASoC: rt711: mutex between calibration and power state changes
Date:   Mon, 25 Jan 2021 19:37:37 +0100
Message-Id: <20210125183217.725193823@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



