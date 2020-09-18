Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B368726EBFA
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgIRCIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728163AbgIRCIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFCC8238E3;
        Fri, 18 Sep 2020 02:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394928;
        bh=nnaW84s0ksnm0uWprDCOIlfvStGE40uUbmvnVaQENs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5NJOQfO4iFu00NIfaUzf2O558oPvIFRTadbaI5jIKkZyxB2ZhDkXGjgcPbuzC7R6
         aJ4ylS1T5CEJridXlbiFyZz5bKNnit2GWJlrVWA9OC2kxps4hNZpGcZIA7dpadltD5
         oHR66uLbnY1V15G8PaMJ+TrcSc1BgYLYPqaKWO+o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tzung-Bi Shih <tzungbi@google.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 039/206] ASoC: max98090: remove msleep in PLL unlocked workaround
Date:   Thu, 17 Sep 2020 22:05:15 -0400
Message-Id: <20200918020802.2065198-39-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit acb874a7c049ec49d8fc66c893170fb42c01bdf7 ]

It was observed Baytrail-based chromebooks could cause continuous PLL
unlocked when using playback stream and capture stream simultaneously.
Specifically, starting a capture stream after started a playback stream.
As a result, the audio data could corrupt or turn completely silent.

As the datasheet suggested, the maximum PLL lock time should be 7 msec.
The workaround resets the codec softly by toggling SHDN off and on if
PLL failed to lock for 10 msec.  Notably, there is no suggested hold
time for SHDN off.

On Baytrail-based chromebooks, it would easily happen continuous PLL
unlocked if there is a 10 msec delay between SHDN off and on.  Removes
the msleep().

Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20191122073114.219945-2-tzungbi@google.com
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98090.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 89b6e187ac235..a5b0c40ee545f 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -2130,10 +2130,16 @@ static void max98090_pll_work(struct max98090_priv *max98090)
 
 	dev_info_ratelimited(component->dev, "PLL unlocked\n");
 
+	/*
+	 * As the datasheet suggested, the maximum PLL lock time should be
+	 * 7 msec.  The workaround resets the codec softly by toggling SHDN
+	 * off and on if PLL failed to lock for 10 msec.  Notably, there is
+	 * no suggested hold time for SHDN off.
+	 */
+
 	/* Toggle shutdown OFF then ON */
 	snd_soc_component_update_bits(component, M98090_REG_DEVICE_SHUTDOWN,
 			    M98090_SHDNN_MASK, 0);
-	msleep(10);
 	snd_soc_component_update_bits(component, M98090_REG_DEVICE_SHUTDOWN,
 			    M98090_SHDNN_MASK, M98090_SHDNN_MASK);
 
-- 
2.25.1

