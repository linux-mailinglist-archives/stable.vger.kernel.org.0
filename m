Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45035603D98
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiJSJFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbiJSJEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:04:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA15A8352;
        Wed, 19 Oct 2022 01:57:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 904FF61851;
        Wed, 19 Oct 2022 08:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13DDC433C1;
        Wed, 19 Oct 2022 08:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169735;
        bh=goNWUmtCyQy3LmAC5CpO9eeEFfx49WATQu4/du69dXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJFgXf7OQHapWD5XcM5TNpKGH4ozFCHsbkmvIgTxJEvytG+6Zkau0uF5qqLHAP53S
         /OwPER1Y+icsXwbHhB3En84b0sN8CGh0q3w0TqBoHF68CPihS1vHYqTXl9jfFRAmeB
         DaP4hwpYsosMlcYVPLnXYK9fe6y13z6LsMEFETyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Judy Hsiao <judyhsiao@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 389/862] ASoC: rockchip: i2s: use regmap_read_poll_timeout to poll I2S_CLR
Date:   Wed, 19 Oct 2022 10:27:56 +0200
Message-Id: <20221019083307.129986122@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Judy Hsiao <judyhsiao@chromium.org>

[ Upstream commit fbb0ec656ee5ee43b4b3022fd8290707265c52df ]

Use regmap_read_poll_timeout to poll I2S_CLR.
It also fixes the 'rockchip-i2s ff070000.i2s; fail to clear' when
the read of I2S_CLR exceeds the retry limit.

Fixes: 0ff9f8b9f592 ("ASoC: rockchip: i2s: Fix error code when fail to read I2S_CLR")
Signed-off-by: Judy Hsiao <judyhsiao@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Link: https://lore.kernel.org/r/20220914031234.2250298-1-judyhsiao@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_i2s.c | 41 ++++++++++++-------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index f5f3540a9e18..28c86f5e435e 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -126,7 +126,6 @@ static inline struct rk_i2s_dev *to_info(struct snd_soc_dai *dai)
 static int rockchip_snd_txctrl(struct rk_i2s_dev *i2s, int on)
 {
 	unsigned int val = 0;
-	int retry = 10;
 	int ret = 0;
 
 	spin_lock(&i2s->lock);
@@ -163,18 +162,14 @@ static int rockchip_snd_txctrl(struct rk_i2s_dev *i2s, int on)
 						 I2S_CLR_TXC | I2S_CLR_RXC);
 			if (ret < 0)
 				goto end;
-			regmap_read(i2s->regmap, I2S_CLR, &val);
-
-			/* Should wait for clear operation to finish */
-			while (val) {
-				regmap_read(i2s->regmap, I2S_CLR, &val);
-				retry--;
-				if (!retry) {
-					dev_warn(i2s->dev, "fail to clear\n");
-					ret = -EBUSY;
-					break;
-				}
-			}
+			ret = regmap_read_poll_timeout(i2s->regmap,
+						       I2S_CLR,
+						       val,
+						       val != 0,
+						       20,
+						       200);
+			if (ret < 0)
+				dev_warn(i2s->dev, "fail to clear: %d\n", ret);
 		}
 	}
 end:
@@ -188,7 +183,6 @@ static int rockchip_snd_txctrl(struct rk_i2s_dev *i2s, int on)
 static int rockchip_snd_rxctrl(struct rk_i2s_dev *i2s, int on)
 {
 	unsigned int val = 0;
-	int retry = 10;
 	int ret = 0;
 
 	spin_lock(&i2s->lock);
@@ -226,17 +220,14 @@ static int rockchip_snd_rxctrl(struct rk_i2s_dev *i2s, int on)
 						 I2S_CLR_TXC | I2S_CLR_RXC);
 			if (ret < 0)
 				goto end;
-			regmap_read(i2s->regmap, I2S_CLR, &val);
-			/* Should wait for clear operation to finish */
-			while (val) {
-				regmap_read(i2s->regmap, I2S_CLR, &val);
-				retry--;
-				if (!retry) {
-					dev_warn(i2s->dev, "fail to clear\n");
-					ret = -EBUSY;
-					break;
-				}
-			}
+			ret = regmap_read_poll_timeout(i2s->regmap,
+						       I2S_CLR,
+						       val,
+						       val != 0,
+						       20,
+						       200);
+			if (ret < 0)
+				dev_warn(i2s->dev, "fail to clear: %d\n", ret);
 		}
 	}
 end:
-- 
2.35.1



