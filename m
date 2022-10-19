Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863F460413E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbiJSKlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiJSKkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534F810DE5C;
        Wed, 19 Oct 2022 03:19:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18F9A61876;
        Wed, 19 Oct 2022 08:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E25AC433D6;
        Wed, 19 Oct 2022 08:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169887;
        bh=S2q4dLCv0wB5dsVQ0gf1Cc97ul+nQ3BJKl3LWuEVW5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wA8m9s7bCpfD9BEafwlW+aQSR7q0VQ1g6YOmUDDw7TLmktn5PGOGPbGQ0IRnSl1Vu
         P/9GrMmvS20d0jgSkndbLfMbPfwu9Vjhra6Ds2QDt5zo9L7cfu1S5oMl9y5dp+r5Tc
         QmDCKPkRxMM66wyRho4UzDTutwNCtLfs5Ds64GFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Judy Hsiao <judyhsiao@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 413/862] ASoC: rockchip: i2s: use regmap_read_poll_timeout_atomic to poll I2S_CLR
Date:   Wed, 19 Oct 2022 10:28:20 +0200
Message-Id: <20221019083308.208444995@linuxfoundation.org>
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

[ Upstream commit f0c8d7468af0001b80b0c86802ee28063f800987 ]

1. Uses regmap_read_poll_timeout_atomic to poll I2S_CLR as it is called
   within a spin lock.

2. Fixes the typo of break condition in regmap_read_poll_timeout_atomic.

Fixes: fbb0ec656ee5 ("ASoC: rockchip: i2s: use regmap_read_poll_timeout to poll I2S_CLR")
Signed-off-by: Judy Hsiao <judyhsiao@chromium.org>
Link: https://lore.kernel.org/r/20220930151546.2017667-1-judyhsiao@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_i2s.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index 28c86f5e435e..a8758ad68442 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -162,12 +162,12 @@ static int rockchip_snd_txctrl(struct rk_i2s_dev *i2s, int on)
 						 I2S_CLR_TXC | I2S_CLR_RXC);
 			if (ret < 0)
 				goto end;
-			ret = regmap_read_poll_timeout(i2s->regmap,
-						       I2S_CLR,
-						       val,
-						       val != 0,
-						       20,
-						       200);
+			ret = regmap_read_poll_timeout_atomic(i2s->regmap,
+							      I2S_CLR,
+							      val,
+							      val == 0,
+							      20,
+							      200);
 			if (ret < 0)
 				dev_warn(i2s->dev, "fail to clear: %d\n", ret);
 		}
@@ -220,12 +220,12 @@ static int rockchip_snd_rxctrl(struct rk_i2s_dev *i2s, int on)
 						 I2S_CLR_TXC | I2S_CLR_RXC);
 			if (ret < 0)
 				goto end;
-			ret = regmap_read_poll_timeout(i2s->regmap,
-						       I2S_CLR,
-						       val,
-						       val != 0,
-						       20,
-						       200);
+			ret = regmap_read_poll_timeout_atomic(i2s->regmap,
+							      I2S_CLR,
+							      val,
+							      val == 0,
+							      20,
+							      200);
 			if (ret < 0)
 				dev_warn(i2s->dev, "fail to clear: %d\n", ret);
 		}
-- 
2.35.1



