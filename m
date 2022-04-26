Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFD950F548
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345835AbiDZIr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346917AbiDZIpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A70933E14;
        Tue, 26 Apr 2022 01:36:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FA66B81CED;
        Tue, 26 Apr 2022 08:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF8EC385AC;
        Tue, 26 Apr 2022 08:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962205;
        bh=bcOTZJMicACjWXiZfXi+DQEm7lArO/AWDfEHBhtc7QE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJF6SgeW06cXl1GPFvaAWvJh69p8E4qDTTK9WOJZGKdhP8NH+p/JCaPcx+gDOViYx
         8aAHGwpAiwWFuUwOdgsDxj0cGoduwFWMKkc3RMf2MTqhb0cSFtZGK9UGDbcG2RTyqv
         1/DhZoTPNTEf7692o82sIqhEDOfo+Lp3ikb7u6NI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/124] ASoC: msm8916-wcd-digital: Check failure for devm_snd_soc_register_component
Date:   Tue, 26 Apr 2022 10:20:21 +0200
Message-Id: <20220426081747.879941932@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit e927b05f3cc20de87f6b7d912a5bbe556931caca ]

devm_snd_soc_register_component() may fails, we should check the error
and do the corresponding error handling.

Fixes: 150db8c5afa1 ("ASoC: codecs: Add msm8916-wcd digital codec")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220403115239.30140-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/msm8916-wcd-digital.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/msm8916-wcd-digital.c b/sound/soc/codecs/msm8916-wcd-digital.c
index 9ad7fc0baf07..20a07c92b2fc 100644
--- a/sound/soc/codecs/msm8916-wcd-digital.c
+++ b/sound/soc/codecs/msm8916-wcd-digital.c
@@ -1206,9 +1206,16 @@ static int msm8916_wcd_digital_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, priv);
 
-	return devm_snd_soc_register_component(dev, &msm8916_wcd_digital,
+	ret = devm_snd_soc_register_component(dev, &msm8916_wcd_digital,
 				      msm8916_wcd_digital_dai,
 				      ARRAY_SIZE(msm8916_wcd_digital_dai));
+	if (ret)
+		goto err_mclk;
+
+	return 0;
+
+err_mclk:
+	clk_disable_unprepare(priv->mclk);
 err_clk:
 	clk_disable_unprepare(priv->ahbclk);
 	return ret;
-- 
2.35.1



