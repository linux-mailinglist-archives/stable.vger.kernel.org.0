Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD284803E6
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhL0TGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:06:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41930 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbhL0TFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:05:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06707B81145;
        Mon, 27 Dec 2021 19:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D75C36AEB;
        Mon, 27 Dec 2021 19:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631920;
        bh=zrDXBEC0TcWKOtmboRNZ02hBjuZ67/soUOSSI1zFhrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3r/1qTrLEgJdheVWtYTeSlW822xOzVjm4nGjVm18rwJiaQChuML58M09rmr7wl4B
         N9KR9Jxo8BchtTxxDRYCbhNTQnXiYwv8N1pNhmk7Rv81z0KQzvIlb9ugERsQY2Ujsj
         lpwtqBTFBeRIlMJI7hwCyX0oBx3wnIWvEL27KfMH+yRCnGkmSPjb3nWeuihVOiITb1
         OkNrJHZudJB9OMLaeM5mDO71ExUt1jyna/egmZuILxwq3FWJggoe7RFllBo7KlFARy
         8dAjXt5v/Th0r2Szy/ujpUvqxbKWFQLvO62CLzfdsCeQ8iNa29vz5wXGP10d24K7LE
         I7YzCfg+v8moA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Derek Fang <derek.fang@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 06/14] ASoC: rt5682: fix the wrong jack type detected
Date:   Mon, 27 Dec 2021 14:04:44 -0500
Message-Id: <20211227190452.1042714-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190452.1042714-1-sashal@kernel.org>
References: <20211227190452.1042714-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Derek Fang <derek.fang@realtek.com>

[ Upstream commit 8deb34a90f06374fd26f722c2a79e15160f66be7 ]

Some powers were changed during the jack insert detection
and clk's enable/disable in CCF.
If in parallel, the influence has a chance to detect
the wrong jack type, so add a lock.

Signed-off-by: Derek Fang <derek.fang@realtek.com>
Link: https://lore.kernel.org/r/20211214105033.471-1-derek.fang@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index 41827cdf26a39..aaef76cc151fa 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -924,6 +924,8 @@ int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
 	unsigned int val, count;
 
 	if (jack_insert) {
+		snd_soc_dapm_mutex_lock(dapm);
+
 		snd_soc_component_update_bits(component, RT5682_PWR_ANLG_1,
 			RT5682_PWR_VREF2 | RT5682_PWR_MB,
 			RT5682_PWR_VREF2 | RT5682_PWR_MB);
@@ -968,6 +970,8 @@ int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
 		snd_soc_component_update_bits(component, RT5682_MICBIAS_2,
 			RT5682_PWR_CLK25M_MASK | RT5682_PWR_CLK1M_MASK,
 			RT5682_PWR_CLK25M_PU | RT5682_PWR_CLK1M_PU);
+
+		snd_soc_dapm_mutex_unlock(dapm);
 	} else {
 		rt5682_enable_push_button_irq(component, false);
 		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
-- 
2.34.1

