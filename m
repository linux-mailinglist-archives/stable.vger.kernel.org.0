Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA9D12B631
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfL0Rk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:40:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbfL0Rk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:40:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC30120740;
        Fri, 27 Dec 2019 17:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468458;
        bh=iWH0MFW5TIsBkDItbrtJZGgrfm8ntD5+Gb/OZCOoeX8=;
        h=From:To:Cc:Subject:Date:From;
        b=bGYbuKlc1zLBFKdxCDkoz1fwXmc2MrTmVmuJC4XsccDqSvz3L+ZvXibzDC0C+THHS
         HQTJTzGKmBpv/NepUQtpqUPWm2O8NtDy9PpvE59x27lpis0X4V2bmdhTOOhZmkXhFM
         idnfzI7QiaF5vPsYsl+TZD21vtf01F0eS0uN8hfs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuming Fan <shumingf@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 001/187] ASoC: rt5682: fix i2c arbitration lost issue
Date:   Fri, 27 Dec 2019 12:37:49 -0500
Message-Id: <20191227174055.4923-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit bc094709de0192a756c6946a7c89c543243ae609 ]

This patch modified the HW initial setting to fix i2c arbitration lost issue.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://lore.kernel.org/r/20191125091940.11953-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index c50b75ce82e0..05e883a65d7a 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -72,6 +72,7 @@ struct rt5682_priv {
 static const struct reg_sequence patch_list[] = {
 	{RT5682_HP_IMP_SENS_CTRL_19, 0x1000},
 	{RT5682_DAC_ADC_DIG_VOL1, 0xa020},
+	{RT5682_I2C_CTRL, 0x000f},
 };
 
 static const struct reg_default rt5682_reg[] = {
@@ -2481,6 +2482,7 @@ static void rt5682_calibrate(struct rt5682_priv *rt5682)
 	mutex_lock(&rt5682->calibrate_mutex);
 
 	rt5682_reset(rt5682->regmap);
+	regmap_write(rt5682->regmap, RT5682_I2C_CTRL, 0x000f);
 	regmap_write(rt5682->regmap, RT5682_PWR_ANLG_1, 0xa2af);
 	usleep_range(15000, 20000);
 	regmap_write(rt5682->regmap, RT5682_PWR_ANLG_1, 0xf2af);
-- 
2.20.1

