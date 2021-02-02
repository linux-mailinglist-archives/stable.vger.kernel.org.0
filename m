Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBB430C4BC
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 17:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235912AbhBBQAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 11:00:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:38282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235211AbhBBPMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 10:12:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9107564F82;
        Tue,  2 Feb 2021 15:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278420;
        bh=T1G47C+170L7aGR3/Jpru6PX8ZjymhBt7Devr9ptUGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JruYYX4H+4u8OKJe6K89fQB/9K25/DCiOJTAs7Q/CWMzzl3jI8vMgqIlr1gzn/1w7
         o7XhECaItVS637yNHQSDxkrwDm5BlaF3w4bjOLbET7x5NZzijfEHpTmqhfWH5iN34Y
         TSX2ZocU/brrEqbI2IFWp5+1QY1kuAAsH4poeJ36jzx4HkZTwVmzChZK9LdqB0ccet
         dtsMtZKr47e8EdantOxGAOfOnTrhdWvgSnpNHr6aAS9RRH2tt2316wOzN9Bm4kNvFp
         cEvgzdR4/xsSD7SCS61J+rujBVT1FNMsuNDLXAiPKkaB2P61vlupdqlDx25rU57raZ
         VShZlW/tXQgqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eliot Blennerhassett <eliot@blennerhassett.gen.nz>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 07/17] ASoC: ak4458: correct reset polarity
Date:   Tue,  2 Feb 2021 10:06:41 -0500
Message-Id: <20210202150651.1864426-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150651.1864426-1-sashal@kernel.org>
References: <20210202150651.1864426-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eliot Blennerhassett <eliot@blennerhassett.gen.nz>

[ Upstream commit e953daeb68b1abd8a7d44902786349fdeef5c297 ]

Reset (aka power off) happens when the reset gpio is made active.
Change function name to ak4458_reset to match devicetree property "reset-gpios"

Signed-off-by: Eliot Blennerhassett <eliot@blennerhassett.gen.nz>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/ce650f47-4ff6-e486-7846-cc3d033f3601@blennerhassett.gen.nz
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak4458.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/sound/soc/codecs/ak4458.c b/sound/soc/codecs/ak4458.c
index 71562154c0b1e..217e8ce9a4ba4 100644
--- a/sound/soc/codecs/ak4458.c
+++ b/sound/soc/codecs/ak4458.c
@@ -523,18 +523,10 @@ static struct snd_soc_dai_driver ak4497_dai = {
 	.ops = &ak4458_dai_ops,
 };
 
-static void ak4458_power_off(struct ak4458_priv *ak4458)
+static void ak4458_reset(struct ak4458_priv *ak4458, bool active)
 {
 	if (ak4458->reset_gpiod) {
-		gpiod_set_value_cansleep(ak4458->reset_gpiod, 0);
-		usleep_range(1000, 2000);
-	}
-}
-
-static void ak4458_power_on(struct ak4458_priv *ak4458)
-{
-	if (ak4458->reset_gpiod) {
-		gpiod_set_value_cansleep(ak4458->reset_gpiod, 1);
+		gpiod_set_value_cansleep(ak4458->reset_gpiod, active);
 		usleep_range(1000, 2000);
 	}
 }
@@ -548,7 +540,7 @@ static int ak4458_init(struct snd_soc_component *component)
 	if (ak4458->mute_gpiod)
 		gpiod_set_value_cansleep(ak4458->mute_gpiod, 1);
 
-	ak4458_power_on(ak4458);
+	ak4458_reset(ak4458, false);
 
 	ret = snd_soc_component_update_bits(component, AK4458_00_CONTROL1,
 			    0x80, 0x80);   /* ACKS bit = 1; 10000000 */
@@ -571,7 +563,7 @@ static void ak4458_remove(struct snd_soc_component *component)
 {
 	struct ak4458_priv *ak4458 = snd_soc_component_get_drvdata(component);
 
-	ak4458_power_off(ak4458);
+	ak4458_reset(ak4458, true);
 }
 
 #ifdef CONFIG_PM
@@ -581,7 +573,7 @@ static int __maybe_unused ak4458_runtime_suspend(struct device *dev)
 
 	regcache_cache_only(ak4458->regmap, true);
 
-	ak4458_power_off(ak4458);
+	ak4458_reset(ak4458, true);
 
 	if (ak4458->mute_gpiod)
 		gpiod_set_value_cansleep(ak4458->mute_gpiod, 0);
@@ -596,8 +588,8 @@ static int __maybe_unused ak4458_runtime_resume(struct device *dev)
 	if (ak4458->mute_gpiod)
 		gpiod_set_value_cansleep(ak4458->mute_gpiod, 1);
 
-	ak4458_power_off(ak4458);
-	ak4458_power_on(ak4458);
+	ak4458_reset(ak4458, true);
+	ak4458_reset(ak4458, false);
 
 	regcache_cache_only(ak4458->regmap, false);
 	regcache_mark_dirty(ak4458->regmap);
-- 
2.27.0

