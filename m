Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2069D1488C3
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390812AbgAXOaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:30:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404977AbgAXOUm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F7EF2077C;
        Fri, 24 Jan 2020 14:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875642;
        bh=ZARtiV7XNSFsBAvby64jmeb3X142S4XmBBemf1Q0XTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TtObCB/w+uyE6zwnusZOe758bCHPM+zfCT06A9td8qcKdGhjIHGUUru9WkdqF11G6
         ga8vhY0h096sVPuQ0bjyShwFjHdl4kyaC+SS3+yFv2/9oXd8EpNKp8b4DnDQZhm0HX
         2s7KebjnoReSW9F3+5D6EC6OsUU3Ag5OUAN9VnX8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephan Gerhold <stephan@gerhold.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 25/56] ASoC: msm8916-wcd-analog: Fix selected events for MIC BIAS External1
Date:   Fri, 24 Jan 2020 09:19:41 -0500
Message-Id: <20200124142012.29752-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit e0beec88397b163c7c4ea6fcfb67e8e07a2671dc ]

MIC BIAS External1 sets pm8916_wcd_analog_enable_micbias_ext1()
as event handler, which ends up in pm8916_wcd_analog_enable_micbias_ext().

But pm8916_wcd_analog_enable_micbias_ext() only handles the POST_PMU
event, which is not specified in the event flags for MIC BIAS External1.
This means that the code in the event handler is never actually run.

Set SND_SOC_DAPM_POST_PMU as the only event for the handler to fix this.

Fixes: 585e881e5b9e ("ASoC: codecs: Add msm8916-wcd analog codec")
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20200111164006.43074-2-stephan@gerhold.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/msm8916-wcd-analog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/msm8916-wcd-analog.c b/sound/soc/codecs/msm8916-wcd-analog.c
index 4f0497ab1aa80..6083b44ce1c6c 100644
--- a/sound/soc/codecs/msm8916-wcd-analog.c
+++ b/sound/soc/codecs/msm8916-wcd-analog.c
@@ -885,10 +885,10 @@ static const struct snd_soc_dapm_widget pm8916_wcd_analog_dapm_widgets[] = {
 
 	SND_SOC_DAPM_SUPPLY("MIC BIAS External1", CDC_A_MICB_1_EN, 7, 0,
 			    pm8916_wcd_analog_enable_micbias_ext1,
-			    SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMD),
+			    SND_SOC_DAPM_POST_PMU),
 	SND_SOC_DAPM_SUPPLY("MIC BIAS External2", CDC_A_MICB_2_EN, 7, 0,
 			    pm8916_wcd_analog_enable_micbias_ext2,
-			    SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
+			    SND_SOC_DAPM_POST_PMU),
 
 	SND_SOC_DAPM_ADC_E("ADC1", NULL, CDC_A_TX_1_EN, 7, 0,
 			   pm8916_wcd_analog_enable_adc,
-- 
2.20.1

