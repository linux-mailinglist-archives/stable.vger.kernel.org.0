Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 968F5BA5FC
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390430AbfIVSq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:46:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390405AbfIVSq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:46:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BECA206C2;
        Sun, 22 Sep 2019 18:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178015;
        bh=gzyP2iDTSZJkcDxjXtyZpYtn6CrWpPanXtKAD1JQ+j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUCbwd4zX9Ezq+LaoQgh4gaYhTVPDeAVbHP3c/yjlbe7aZYKkkHqaEc4W7nDiWtyx
         fwi/pV54orRrS0AjptA1TCBVjom9vqoURw6UpJLpDMmNPBHWKB6c+Eh67sFKHtBu70
         oFBqBNbsg+CBkmygqBozXdENvtZ/c+7m0GqumXmA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 102/203] ASoC: mchp-i2s-mcc: Fix unprepare of GCLK
Date:   Sun, 22 Sep 2019 14:42:08 -0400
Message-Id: <20190922184350.30563-102-sashal@kernel.org>
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

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

[ Upstream commit 988b59467b2b14523a266957affbe9eca3e99fc9 ]

If hw_free() gets called after hw_params(), GCLK remains prepared,
preventing further use of it. This patch fixes this by unpreparing the
clock in hw_free() or if hw_params() gets an error.

Fixes: 7e0cdf545a55 ("ASoC: mchp-i2s-mcc: add driver for I2SC Multi-Channel Controller")
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Link: https://lore.kernel.org/r/20190820162411.24836-2-codrin.ciubotariu@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/mchp-i2s-mcc.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/atmel/mchp-i2s-mcc.c b/sound/soc/atmel/mchp-i2s-mcc.c
index 8272915fa09b9..ab7d5f98e759e 100644
--- a/sound/soc/atmel/mchp-i2s-mcc.c
+++ b/sound/soc/atmel/mchp-i2s-mcc.c
@@ -670,8 +670,13 @@ static int mchp_i2s_mcc_hw_params(struct snd_pcm_substream *substream,
 	}
 
 	ret = regmap_write(dev->regmap, MCHP_I2SMCC_MRA, mra);
-	if (ret < 0)
+	if (ret < 0) {
+		if (dev->gclk_use) {
+			clk_unprepare(dev->gclk);
+			dev->gclk_use = 0;
+		}
 		return ret;
+	}
 	return regmap_write(dev->regmap, MCHP_I2SMCC_MRB, mrb);
 }
 
@@ -710,9 +715,13 @@ static int mchp_i2s_mcc_hw_free(struct snd_pcm_substream *substream,
 		regmap_write(dev->regmap, MCHP_I2SMCC_CR, MCHP_I2SMCC_CR_CKDIS);
 
 		if (dev->gclk_running) {
-			clk_disable_unprepare(dev->gclk);
+			clk_disable(dev->gclk);
 			dev->gclk_running = 0;
 		}
+		if (dev->gclk_use) {
+			clk_unprepare(dev->gclk);
+			dev->gclk_use = 0;
+		}
 	}
 
 	return 0;
-- 
2.20.1

