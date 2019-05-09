Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 181D419260
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfEISqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:46:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727572AbfEISqW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:46:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40B0921848;
        Thu,  9 May 2019 18:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427581;
        bh=b5xDG6mZ/aI0h7Sx6grFfqOyC+SdTpnFXfOMx54HGqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02Eo+mQwWibtTnPp1H2tlr87czblMx64Xk0Gob/rS0BIKDeupKviFacCjEyLO6akE
         rYXNbq1csRGUCn5j67DWeU9UfmACwVKmmAUsoad49f6XPOrMEHNsRJgviA2NEV/JUO
         0/tZYhrKT6Hs+fnY/LHI3BnowHA3+TO4hdSn8mVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, JaeChul Lee <jcsing.lee@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/42] ASoC: samsung: odroid: Fix clock configuration for 44100 sample rate
Date:   Thu,  9 May 2019 20:41:58 +0200
Message-Id: <20190509181254.491618500@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181252.616018683@linuxfoundation.org>
References: <20190509181252.616018683@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2b13bee3884926cba22061efa75bd315e871de24 ]

After commit fbeec965b8d1c ("ASoC: samsung: odroid: Fix 32000 sample rate
handling") the audio root clock frequency is configured improperly for
44100 sample rate. Due to clock rate rounding it's 20070401 Hz instead
of 22579000 Hz. This results in a too low value of the PSR clock divider
in the CPU DAI driver and too fast actual sample rate for fs=44100. E.g.
1 kHz tone has actual 1780 Hz frequency (1 kHz * 20070401/22579000 * 2).

Fix this by increasing the correction passed to clk_set_rate() to take
into account inaccuracy of the EPLL frequency properly.

Fixes: fbeec965b8d1c ("ASoC: samsung: odroid: Fix 32000 sample rate handling")
Reported-by: JaeChul Lee <jcsing.lee@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/odroid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/samsung/odroid.c b/sound/soc/samsung/odroid.c
index 06a31a9585a05..32c9e197ca957 100644
--- a/sound/soc/samsung/odroid.c
+++ b/sound/soc/samsung/odroid.c
@@ -66,11 +66,11 @@ static int odroid_card_hw_params(struct snd_pcm_substream *substream,
 		return ret;
 
 	/*
-	 *  We add 1 to the rclk_freq value in order to avoid too low clock
+	 *  We add 2 to the rclk_freq value in order to avoid too low clock
 	 *  frequency values due to the EPLL output frequency not being exact
 	 *  multiple of the audio sampling rate.
 	 */
-	rclk_freq = params_rate(params) * rfs + 1;
+	rclk_freq = params_rate(params) * rfs + 2;
 
 	ret = clk_set_rate(priv->sclk_i2s, rclk_freq);
 	if (ret < 0)
-- 
2.20.1



