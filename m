Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B304C5743BF
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237696AbiGNEi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237697AbiGNEiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:38:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BBC3ED4A;
        Wed, 13 Jul 2022 21:27:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EEFDB82371;
        Thu, 14 Jul 2022 04:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8211AC34115;
        Thu, 14 Jul 2022 04:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772833;
        bh=FGbsfRAkzXDG408skh5FLJgLjQK83LBjEkUjRQg2WZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKNXrctVBg3SxO1QTghsSbWKLKRND+yiZ5Aq1zLcvQg/EgschLCcIz5oKxwE3BLXR
         hNdX50sHZNTh4X3kFxtRvq7RMAUy7pKgkEM9xfmlSeb6Kvn6V9OjzXMkTRt/5NAgm2
         RXpUGVr/UAAzrTm3fcuhd+eBj5vFO9eyIWp4xT/cRRJ2dgQgicvWZKe4qP5vb0RDPE
         mmPTEjpn6ZU1VvtFQWkMNSAZKv9RSFnAJB2VgtMF9GjMZlX2WxC6VfKjkHhdSCgMR9
         zduvW0vSQ9QO223/tBkRg9fmQdVVFGtn/J09vsXsI8UpFIwBTmb3bvtoVRmgnEeTEC
         tOd1E0lY6DWUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, simont@opensource.cirrus.com,
        patches@opensource.cirrus.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 2/4] ASoC: wm5110: Fix DRE control
Date:   Thu, 14 Jul 2022 00:27:05 -0400
Message-Id: <20220714042707.282675-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042707.282675-1-sashal@kernel.org>
References: <20220714042707.282675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 0bc0ae9a5938d512fd5d44f11c9c04892dcf4961 ]

The DRE controls on wm5110 should return a value of 1 if the DRE state
is actually changed, update to fix this.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220621102041.1713504-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm5110.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 06bae3b23fce..2b0342bcede4 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -404,6 +404,7 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 	unsigned int rnew = (!!ucontrol->value.integer.value[1]) << mc->rshift;
 	unsigned int lold, rold;
 	unsigned int lena, rena;
+	bool change = false;
 	int ret;
 
 	snd_soc_dapm_mutex_lock(dapm);
@@ -431,8 +432,8 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 		goto err;
 	}
 
-	ret = regmap_update_bits(arizona->regmap, ARIZONA_DRE_ENABLE,
-				 mask, lnew | rnew);
+	ret = regmap_update_bits_check(arizona->regmap, ARIZONA_DRE_ENABLE,
+				       mask, lnew | rnew, &change);
 	if (ret) {
 		dev_err(arizona->dev, "Failed to set DRE: %d\n", ret);
 		goto err;
@@ -445,6 +446,9 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 	if (!rnew && rold)
 		wm5110_clear_pga_volume(arizona, mc->rshift);
 
+	if (change)
+		ret = 1;
+
 err:
 	snd_soc_dapm_mutex_unlock(dapm);
 
-- 
2.35.1

