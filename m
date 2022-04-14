Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884105014B9
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245668AbiDNNsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344066AbiDNNjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:39:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071EE18392;
        Thu, 14 Apr 2022 06:37:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9727761D67;
        Thu, 14 Apr 2022 13:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0681C385A9;
        Thu, 14 Apr 2022 13:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943429;
        bh=JMbRjxHjk7BFQMGIiIj8gstdGIzg0UFgQWTxL9OTBww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLsuV3Pd8xHQNACxRwJR5P8LqEkBt7TVAIklhWG1AArW9GrsQSjAW0sl5gOxPN4IK
         Qun/lA9y0YCBXjivnZ/WReUh+1BK8GEFDJV/IaA4sh5hOuMY+pIQ/2VNkLgIUgsgJ6
         7/WIgvs/RIeYfVOeyFeTYK1/tyGYOtCV98m78bBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 152/475] ASoC: msm8916-wcd-digital: Fix missing clk_disable_unprepare() in msm8916_wcd_digital_probe
Date:   Thu, 14 Apr 2022 15:08:57 +0200
Message-Id: <20220414110859.395758472@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 375a347da4889f64d86e1ab7f4e6702b6e9bf299 ]

Fix the missing clk_disable_unprepare() before return
from msm8916_wcd_digital_probe in the error handling case.

Fixes: 150db8c5afa1 ("ASoC: codecs: Add msm8916-wcd digital codec")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220307084523.28687-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/msm8916-wcd-digital.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/msm8916-wcd-digital.c b/sound/soc/codecs/msm8916-wcd-digital.c
index 09fccacadd6b..d5269ab5f91c 100644
--- a/sound/soc/codecs/msm8916-wcd-digital.c
+++ b/sound/soc/codecs/msm8916-wcd-digital.c
@@ -1201,7 +1201,7 @@ static int msm8916_wcd_digital_probe(struct platform_device *pdev)
 	ret = clk_prepare_enable(priv->mclk);
 	if (ret < 0) {
 		dev_err(dev, "failed to enable mclk %d\n", ret);
-		return ret;
+		goto err_clk;
 	}
 
 	dev_set_drvdata(dev, priv);
@@ -1209,6 +1209,9 @@ static int msm8916_wcd_digital_probe(struct platform_device *pdev)
 	return devm_snd_soc_register_component(dev, &msm8916_wcd_digital,
 				      msm8916_wcd_digital_dai,
 				      ARRAY_SIZE(msm8916_wcd_digital_dai));
+err_clk:
+	clk_disable_unprepare(priv->ahbclk);
+	return ret;
 }
 
 static int msm8916_wcd_digital_remove(struct platform_device *pdev)
-- 
2.34.1



