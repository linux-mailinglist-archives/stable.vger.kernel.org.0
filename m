Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5DD657EC0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbiL1P5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbiL1P5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:57:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5833917E06
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:57:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 097A2B8172B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B08C433EF;
        Wed, 28 Dec 2022 15:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243022;
        bh=/+UuJAjFEjapQYnf+bpUs6VXLAIZiYcE0CkzyaZZO3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j0EwG60ktHL3u/E1fsYMbMyAsJMsCsDahPXbV5/9oFmOKSVnFr2ZheuwVA8tLv2uC
         fRwQynQI29My5UV5Qt73zsKhnU4UNArlJyvJCyzIHp7Wy49cTGhzAZ+PwV1HUG6DDa
         3jkDpOOsu8PfLBMSUbPfS0eP+wUwTnIJocMEWbZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0441/1146] ASoC: pcm512x: Fix PM disable depth imbalance in pcm512x_probe
Date:   Wed, 28 Dec 2022 15:33:00 +0100
Message-Id: <20221228144342.159003136@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 97b801be6f8e53676b9f2b105f54e35c745c1b22 ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context. We fix it by going to
err_pm instead of err_clk.

Fixes:f086ba9d5389c ("ASoC: pcm512x: Support mastering BCLK/LRCLK using the PLL")

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20220928160402.126140-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/pcm512x.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/pcm512x.c b/sound/soc/codecs/pcm512x.c
index 767463e82665..89059a673cf0 100644
--- a/sound/soc/codecs/pcm512x.c
+++ b/sound/soc/codecs/pcm512x.c
@@ -1634,7 +1634,7 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
 			if (val > 6) {
 				dev_err(dev, "Invalid pll-in\n");
 				ret = -EINVAL;
-				goto err_clk;
+				goto err_pm;
 			}
 			pcm512x->pll_in = val;
 		}
@@ -1643,7 +1643,7 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
 			if (val > 6) {
 				dev_err(dev, "Invalid pll-out\n");
 				ret = -EINVAL;
-				goto err_clk;
+				goto err_pm;
 			}
 			pcm512x->pll_out = val;
 		}
@@ -1652,12 +1652,12 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
 			dev_err(dev,
 				"Error: both pll-in and pll-out, or none\n");
 			ret = -EINVAL;
-			goto err_clk;
+			goto err_pm;
 		}
 		if (pcm512x->pll_in && pcm512x->pll_in == pcm512x->pll_out) {
 			dev_err(dev, "Error: pll-in == pll-out\n");
 			ret = -EINVAL;
-			goto err_clk;
+			goto err_pm;
 		}
 	}
 #endif
-- 
2.35.1



