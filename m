Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA1A3D7612
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbhG0NXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:23:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236874AbhG0NUR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 664BB61ACF;
        Tue, 27 Jul 2021 13:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391989;
        bh=B9xYAL/8m8xchTS/11Noy/LV1czP1hU/TtmNdYqMCos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHgXEZHnUf6zsxk6YafnlO8N1n4Z9JN2PewHMnDkr9ByTNnnSXxrowRMeHNM/YIkc
         9rYa7nQ+ygd5DEVl1KXiCm7/KUtdaXhkSelbgnJRAezKVky9Xj+HaS8EPry+5YGADC
         Oena2ZWQpwYsjg96dd3lBu6wKAx5lz7m4hmi5BqO8GxCW1c1nt3MhpK8CABQQ1wCYG
         RrdvmShvLKlrEsNEOipg2zi8Ep2Sm6HgsEka+I1y/Y502ev7/oJn39L1aXTps1DcFQ
         l7aCBclxQRJZjrReuFPpTk0/nWP1GkX/QDt3UJO9UA8vCW/WA3rvHDu3i4ErCFL5mZ
         6q4xCxZvkpZtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oder Chiou <oder_chiou@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 08/17] ASoC: rt5682: Fix the issue of garbled recording after powerd_dbus_suspend
Date:   Tue, 27 Jul 2021 09:19:29 -0400
Message-Id: <20210727131938.834920-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131938.834920-1-sashal@kernel.org>
References: <20210727131938.834920-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oder Chiou <oder_chiou@realtek.com>

[ Upstream commit 6a503e1c455316fd0bfd8188c0a62cce7c5525ca ]

While using the DMIC recording, the garbled data will be captured by the
DMIC. It is caused by the critical power of PLL closed in the jack detect
function.

Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Link: https://lore.kernel.org/r/20210716085853.20170-1-oder_chiou@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index d9878173ff89..2e41b8c169e5 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -971,10 +971,14 @@ int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
 		rt5682_enable_push_button_irq(component, false);
 		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
 			RT5682_TRIG_JD_MASK, RT5682_TRIG_JD_LOW);
-		if (!snd_soc_dapm_get_pin_status(dapm, "MICBIAS"))
+		if (!snd_soc_dapm_get_pin_status(dapm, "MICBIAS") &&
+			!snd_soc_dapm_get_pin_status(dapm, "PLL1") &&
+			!snd_soc_dapm_get_pin_status(dapm, "PLL2B"))
 			snd_soc_component_update_bits(component,
 				RT5682_PWR_ANLG_1, RT5682_PWR_MB, 0);
-		if (!snd_soc_dapm_get_pin_status(dapm, "Vref2"))
+		if (!snd_soc_dapm_get_pin_status(dapm, "Vref2") &&
+			!snd_soc_dapm_get_pin_status(dapm, "PLL1") &&
+			!snd_soc_dapm_get_pin_status(dapm, "PLL2B"))
 			snd_soc_component_update_bits(component,
 				RT5682_PWR_ANLG_1, RT5682_PWR_VREF2, 0);
 		snd_soc_component_update_bits(component, RT5682_PWR_ANLG_3,
-- 
2.30.2

