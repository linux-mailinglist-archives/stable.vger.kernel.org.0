Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90A74F30C5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347416AbiDEJ0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245057AbiDEIxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:53:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F74F76;
        Tue,  5 Apr 2022 01:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A006B81BBF;
        Tue,  5 Apr 2022 08:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE210C385A0;
        Tue,  5 Apr 2022 08:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148651;
        bh=RuudkV80NbnUWQJ3ZBBUJ5p0VXcyoR2tIBAnss2jxn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+5HSTldipMgndUHybpyArCf1H8eEkbTfjbGyxf/ZS+3W/xAxQRqmNoH3hYgCzgJw
         sO6f6aJLraM82JIcwzOTGlqSlOoXumgjK5AWOjcufdPTXwec0r35TgSTkwJ/poMXCV
         gytzNH+UcPDsvI5C28jIX+RnSmmuWHDMJT2BWKHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0393/1017] ASoC: msm8916-wcd-analog: Fix error handling in pm8916_wcd_analog_spmi_probe
Date:   Tue,  5 Apr 2022 09:21:46 +0200
Message-Id: <20220405070405.951366644@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

[ Upstream commit 9ebd62d60edcd4d9c75485e5ccd0b79581ad3c49 ]

In the error handling path, the clk_prepare_enable() function
call should be balanced by a corresponding 'clk_disable_unprepare()'
call , as already done in the remove function.

Fixes: de66b3455023 ("ASoC: codecs: msm8916-wcd-analog: add MBHC support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220316041924.17560-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/msm8916-wcd-analog.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/msm8916-wcd-analog.c b/sound/soc/codecs/msm8916-wcd-analog.c
index 3ddd822240e3..971b8360b5b1 100644
--- a/sound/soc/codecs/msm8916-wcd-analog.c
+++ b/sound/soc/codecs/msm8916-wcd-analog.c
@@ -1221,8 +1221,10 @@ static int pm8916_wcd_analog_spmi_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq_byname(pdev, "mbhc_switch_int");
-	if (irq < 0)
-		return irq;
+	if (irq < 0) {
+		ret = irq;
+		goto err_disable_clk;
+	}
 
 	ret = devm_request_threaded_irq(dev, irq, NULL,
 			       pm8916_mbhc_switch_irq_handler,
@@ -1234,8 +1236,10 @@ static int pm8916_wcd_analog_spmi_probe(struct platform_device *pdev)
 
 	if (priv->mbhc_btn_enabled) {
 		irq = platform_get_irq_byname(pdev, "mbhc_but_press_det");
-		if (irq < 0)
-			return irq;
+		if (irq < 0) {
+			ret = irq;
+			goto err_disable_clk;
+		}
 
 		ret = devm_request_threaded_irq(dev, irq, NULL,
 				       mbhc_btn_press_irq_handler,
@@ -1246,8 +1250,10 @@ static int pm8916_wcd_analog_spmi_probe(struct platform_device *pdev)
 			dev_err(dev, "cannot request mbhc button press irq\n");
 
 		irq = platform_get_irq_byname(pdev, "mbhc_but_rel_det");
-		if (irq < 0)
-			return irq;
+		if (irq < 0) {
+			ret = irq;
+			goto err_disable_clk;
+		}
 
 		ret = devm_request_threaded_irq(dev, irq, NULL,
 				       mbhc_btn_release_irq_handler,
@@ -1264,6 +1270,10 @@ static int pm8916_wcd_analog_spmi_probe(struct platform_device *pdev)
 	return devm_snd_soc_register_component(dev, &pm8916_wcd_analog,
 				      pm8916_wcd_analog_dai,
 				      ARRAY_SIZE(pm8916_wcd_analog_dai));
+
+err_disable_clk:
+	clk_disable_unprepare(priv->mclk);
+	return ret;
 }
 
 static int pm8916_wcd_analog_spmi_remove(struct platform_device *pdev)
-- 
2.34.1



