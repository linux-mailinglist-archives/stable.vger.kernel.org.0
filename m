Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912C8145037
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388100AbgAVJor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:44:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:38250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387925AbgAVJor (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:44:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B21312468D;
        Wed, 22 Jan 2020 09:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686286;
        bh=WX4sVxHyxlfhYXQVhTKofynFZ8SPwIrhm6Yg1RftmQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9+RONwvZxPanjMsrbzKzg7+PQQzSQrAaeY/NVsvZn/Ys1uWY9KVSGEOwN/BmQ16d
         je5QCJC9KXWaGu38yPV49OCQxPRyDB+uTyPQXi8fVuztAiBiCRD9zif4K3dfsao4GS
         p1VfyOUy6FaHmwbCDrLCfAT1jWl5w8wGZ80uvj7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 016/222] ASoC: msm8916-wcd-analog: Fix selected events for MIC BIAS External1
Date:   Wed, 22 Jan 2020 10:26:42 +0100
Message-Id: <20200122092834.550163981@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

commit e0beec88397b163c7c4ea6fcfb67e8e07a2671dc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/msm8916-wcd-analog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/msm8916-wcd-analog.c
+++ b/sound/soc/codecs/msm8916-wcd-analog.c
@@ -888,10 +888,10 @@ static const struct snd_soc_dapm_widget
 
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


