Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0289DBAB27
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439141AbfIVTfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:35:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390332AbfIVSqx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:46:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C73E2186A;
        Sun, 22 Sep 2019 18:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178012;
        bh=aCeOu7Setfrgi0G235/LuiodlneTa/ZnHrrPVIws2c0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3aRIGiWyBH8KwdloXWFBbYKISF4GHzvp33/Gg9rWdelc1PAJSnFMCb2TXUi3sjK5
         Lbjmh83xiKMFtyXAeCdi8/FalOt0THT6Gcjh6E37WCkzWAUk4tkOllh3QdwCLVIA5H
         J8ooWrVgMMUabdLqLVzdOzN5uUiQlIq+rkVYMe3k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 099/203] ASoC: sun4i-i2s: Don't use the oversample to calculate BCLK
Date:   Sun, 22 Sep 2019 14:42:05 -0400
Message-Id: <20190922184350.30563-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime.ripard@bootlin.com>

[ Upstream commit 7df8f9a20196072162d9dc8fe99943f2d35f23d5 ]

The BCLK divider should be calculated using the parameters that actually
make the BCLK rate: the number of channels, the sampling rate and the
sample width.

We've been using the oversample_rate previously because in the former SoCs,
the BCLK's parent is MCLK, which in turn is being used to generate the
oversample rate, so we end up with something like this:

oversample = mclk_rate / sampling_rate
bclk_div = oversample / word_size / channels

So, bclk_div = mclk_rate / sampling_rate / word_size / channels.

And this is actually better, since the oversampling ratio only plays a role
because the MCLK is its parent, not because of what BCLK is supposed to be.

Furthermore, that assumption of MCLK being the parent has been broken on
newer SoCs, so let's use the proper formula, and have the parent rate as an
argument.

Fixes: 7d2993811a1e ("ASoC: sun4i-i2s: Add support for H3")
Fixes: 21faaea1343f ("ASoC: sun4i-i2s: Add support for A83T")
Fixes: 66ecce332538 ("ASoC: sun4i-i2s: Add compatibility with A64 codec I2S")
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Link: https://lore.kernel.org/r/c3595e3a9788c2ef2dcc30aa3c8c4953bb5cc249.1566242458.git-series.maxime.ripard@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sunxi/sun4i-i2s.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sunxi/sun4i-i2s.c b/sound/soc/sunxi/sun4i-i2s.c
index 7fa5c61169db0..ab8cb83c8b1a8 100644
--- a/sound/soc/sunxi/sun4i-i2s.c
+++ b/sound/soc/sunxi/sun4i-i2s.c
@@ -222,10 +222,11 @@ static const struct sun4i_i2s_clk_div sun4i_i2s_mclk_div[] = {
 };
 
 static int sun4i_i2s_get_bclk_div(struct sun4i_i2s *i2s,
-				  unsigned int oversample_rate,
+				  unsigned long parent_rate,
+				  unsigned int sampling_rate,
 				  unsigned int word_size)
 {
-	int div = oversample_rate / word_size / 2;
+	int div = parent_rate / sampling_rate / word_size / 2;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(sun4i_i2s_bclk_div); i++) {
@@ -315,8 +316,8 @@ static int sun4i_i2s_set_clk_rate(struct snd_soc_dai *dai,
 		return -EINVAL;
 	}
 
-	bclk_div = sun4i_i2s_get_bclk_div(i2s, oversample_rate,
-					  word_size);
+	bclk_div = sun4i_i2s_get_bclk_div(i2s, i2s->mclk_freq,
+					  rate, word_size);
 	if (bclk_div < 0) {
 		dev_err(dai->dev, "Unsupported BCLK divider: %d\n", bclk_div);
 		return -EINVAL;
-- 
2.20.1

