Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6024E667516
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235449AbjALORx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235547AbjALORP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:17:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4466574F4
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:09:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FA26B81E67
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8326C433EF;
        Thu, 12 Jan 2023 14:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532543;
        bh=bUIXpk+iwWzn7A0kNSCxfeMdUsOxKceqmd0lR2S7cU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GjP7ETMkDY8JEEP7f9iJRd1uox6Z391AurzhJFzSQfGRJVnf/aOtx8fMLk6pnjs4U
         VcTLPevcBpoEEBCiX/hBrce41UGwxMP5V0qbv5SD1KaFJON65e8wwfIqHolWRhdIwT
         9JlaUcZ/+quyM49KDl7vkeJZ1yoDAqubyRNN4P28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/783] ASoC: pcm512x: Fix PM disable depth imbalance in pcm512x_probe
Date:   Thu, 12 Jan 2023 14:48:32 +0100
Message-Id: <20230112135533.402492730@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 8153d3d01654..3677e9029f91 100644
--- a/sound/soc/codecs/pcm512x.c
+++ b/sound/soc/codecs/pcm512x.c
@@ -1599,7 +1599,7 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
 			if (val > 6) {
 				dev_err(dev, "Invalid pll-in\n");
 				ret = -EINVAL;
-				goto err_clk;
+				goto err_pm;
 			}
 			pcm512x->pll_in = val;
 		}
@@ -1608,7 +1608,7 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
 			if (val > 6) {
 				dev_err(dev, "Invalid pll-out\n");
 				ret = -EINVAL;
-				goto err_clk;
+				goto err_pm;
 			}
 			pcm512x->pll_out = val;
 		}
@@ -1617,12 +1617,12 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
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



