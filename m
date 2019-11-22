Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB5B1064D0
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfKVGTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:19:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728691AbfKVFws (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CE472071F;
        Fri, 22 Nov 2019 05:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401967;
        bh=geeeVQ63UDrNG1JfFxbc//qDRyzxsQyqhEbu7hEACLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQKXNHRMhIHkF1a9Ioi7N1d1dFy1wHjAJUCvUFKj3HYCsUJgqJWOe+jSRGPZ7X6HT
         AsLUAmRy0GRzEQokhnN9klEkxAHfedpbMV5BrEHTFjZ39BKUgQS3hMjcwYoUP1mTAA
         wL1oY8qH/p/ZcQz4gPNKhkFngZs1ZxrJYqLWWzKw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 188/219] ASoC: samsung: i2s: Fix prescaler setting for the secondary DAI
Date:   Fri, 22 Nov 2019 00:48:40 -0500
Message-Id: <20191122054911.1750-181-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

[ Upstream commit 323fb7b947b265753de34703dbbf8acc8ea3a4de ]

Make sure i2s->rclk_srcrate is properly initialized also during
playback through the secondary DAI.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/i2s.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index ce00fe2f6aae3..d4bde4834ce5f 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -604,6 +604,7 @@ static int i2s_set_fmt(struct snd_soc_dai *dai,
 	unsigned int fmt)
 {
 	struct i2s_dai *i2s = to_info(dai);
+	struct i2s_dai *other = get_other_dai(i2s);
 	int lrp_shift, sdf_shift, sdf_mask, lrp_rlow, mod_slave;
 	u32 mod, tmp = 0;
 	unsigned long flags;
@@ -661,7 +662,8 @@ static int i2s_set_fmt(struct snd_soc_dai *dai,
 		 * CLK_I2S_RCLK_SRC clock is not exposed so we ensure any
 		 * clock configuration assigned in DT is not overwritten.
 		 */
-		if (i2s->rclk_srcrate == 0 && i2s->clk_data.clks == NULL)
+		if (i2s->rclk_srcrate == 0 && i2s->clk_data.clks == NULL &&
+		    other->clk_data.clks == NULL)
 			i2s_set_sysclk(dai, SAMSUNG_I2S_RCLKSRC_0,
 							0, SND_SOC_CLOCK_IN);
 		break;
@@ -699,6 +701,7 @@ static int i2s_hw_params(struct snd_pcm_substream *substream,
 	struct snd_pcm_hw_params *params, struct snd_soc_dai *dai)
 {
 	struct i2s_dai *i2s = to_info(dai);
+	struct i2s_dai *other = get_other_dai(i2s);
 	u32 mod, mask = 0, val = 0;
 	struct clk *rclksrc;
 	unsigned long flags;
@@ -784,6 +787,9 @@ static int i2s_hw_params(struct snd_pcm_substream *substream,
 	i2s->frmclk = params_rate(params);
 
 	rclksrc = i2s->clk_table[CLK_I2S_RCLK_SRC];
+	if (!rclksrc || IS_ERR(rclksrc))
+		rclksrc = other->clk_table[CLK_I2S_RCLK_SRC];
+
 	if (rclksrc && !IS_ERR(rclksrc))
 		i2s->rclk_srcrate = clk_get_rate(rclksrc);
 
-- 
2.20.1

