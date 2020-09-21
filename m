Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3352727F7
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgIUOkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727431AbgIUOkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:40:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4CD52076E;
        Mon, 21 Sep 2020 14:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699231;
        bh=aqhq97v0vMI/8zhDlmjgrthGC99DKHlygRR/9St7wN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKDSYKgQGPBqzYW0QpHNBphUNcWJRoHl9qvNBnC0PQPx+Gr/4050U24V3nXDxaB21
         VEonN7/8MFh1FSpU0iN692+k4KzehNBfmVbUqZJ4rM77aHhVos46C8mi31bsQ0LHZj
         R/oWC3viMev9XJEKxnHoBHkeAuGtAcIsIvLcYMYY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.8 03/20] ASoC: wm8994: Skip setting of the WM8994_MICBIAS register for WM1811
Date:   Mon, 21 Sep 2020 10:40:10 -0400
Message-Id: <20200921144027.2135390-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144027.2135390-1-sashal@kernel.org>
References: <20200921144027.2135390-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

[ Upstream commit 811c5494436789e7149487c06e0602b507ce274b ]

The WM8994_MICBIAS register is not available in the WM1811 CODEC so skip
initialization of that register for that device.
This suppresses an error during boot:
"wm8994-codec: ASoC: error at snd_soc_component_update_bits on wm8994-codec"

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20200827173357.31891-1-s.nawrocki@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c  | 2 ++
 sound/soc/codecs/wm_hubs.c | 3 +++
 sound/soc/codecs/wm_hubs.h | 1 +
 3 files changed, 6 insertions(+)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 55d0b9be6ff00..c2116836a7203 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -4166,11 +4166,13 @@ static int wm8994_component_probe(struct snd_soc_component *component)
 			wm8994->hubs.dcs_readback_mode = 2;
 			break;
 		}
+		wm8994->hubs.micd_scthr = true;
 		break;
 
 	case WM8958:
 		wm8994->hubs.dcs_readback_mode = 1;
 		wm8994->hubs.hp_startup_mode = 1;
+		wm8994->hubs.micd_scthr = true;
 
 		switch (control->revision) {
 		case 0:
diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index e93af7edd8f75..dd421e2fe7b21 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -1223,6 +1223,9 @@ int wm_hubs_handle_analogue_pdata(struct snd_soc_component *component,
 		snd_soc_component_update_bits(component, WM8993_ADDITIONAL_CONTROL,
 				    WM8993_LINEOUT2_FB, WM8993_LINEOUT2_FB);
 
+	if (!hubs->micd_scthr)
+		return 0;
+
 	snd_soc_component_update_bits(component, WM8993_MICBIAS,
 			    WM8993_JD_SCTHR_MASK | WM8993_JD_THR_MASK |
 			    WM8993_MICB1_LVL | WM8993_MICB2_LVL,
diff --git a/sound/soc/codecs/wm_hubs.h b/sound/soc/codecs/wm_hubs.h
index 4b8e5f0d6e32d..988b29e630607 100644
--- a/sound/soc/codecs/wm_hubs.h
+++ b/sound/soc/codecs/wm_hubs.h
@@ -27,6 +27,7 @@ struct wm_hubs_data {
 	int hp_startup_mode;
 	int series_startup;
 	int no_series_update;
+	bool micd_scthr;
 
 	bool no_cache_dac_hp_direct;
 	struct list_head dcs_cache;
-- 
2.25.1

