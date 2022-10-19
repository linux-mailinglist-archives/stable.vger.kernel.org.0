Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534F9603D9F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbiJSJF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbiJSJEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:04:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF78AE87D;
        Wed, 19 Oct 2022 01:57:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A394161876;
        Wed, 19 Oct 2022 08:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F21C43142;
        Wed, 19 Oct 2022 08:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169782;
        bh=sByEGu5DwWG/ZQcSeCd52zZmd43PIsJ/HeVT8zR41nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aX3Cx31B2PUM5CUtZriCaIYs94GevP2Vz0PcHj8DOWRNhCcGrWRPiaDziUc730q7X
         z5rqfpQ8LjNJSSX8nyvLViDbGe47MnNn+h1FaOw83GtptMhkA1PrQUJyi6ywzmRuGK
         KTTUG4+eHr10lgJESizbcJ0z4rGSMqIRHrOYL2wM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 405/862] ASoC: stm32: dfsdm: Fix PM disable depth imbalance in stm32_adfsdm_probe
Date:   Wed, 19 Oct 2022 10:28:12 +0200
Message-Id: <20221019083307.843102826@linuxfoundation.org>
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

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit b9a0da5b2edcae2a901b85c8cc42efc5bec4bd7b ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context. We fix it by moving
pm_runtime_enable to the endding of stm32_adfsdm_probe.

Fixes:98e500a12f934 ("ASoC: stm32: dfsdm: add pm_runtime support for audio")

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://lore.kernel.org/r/20220927142601.64266-2-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_adfsdm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/stm/stm32_adfsdm.c b/sound/soc/stm/stm32_adfsdm.c
index 04f2912e1418..643fc8a17018 100644
--- a/sound/soc/stm/stm32_adfsdm.c
+++ b/sound/soc/stm/stm32_adfsdm.c
@@ -335,8 +335,6 @@ static int stm32_adfsdm_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(&pdev->dev, priv);
 
-	pm_runtime_enable(&pdev->dev);
-
 	ret = devm_snd_soc_register_component(&pdev->dev,
 					      &stm32_adfsdm_dai_component,
 					      &priv->dai_drv, 1);
@@ -366,9 +364,13 @@ static int stm32_adfsdm_probe(struct platform_device *pdev)
 #endif
 
 	ret = snd_soc_add_component(component, NULL, 0);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&pdev->dev, "%s: Failed to register PCM platform\n",
 			__func__);
+		return ret;
+	}
+
+	pm_runtime_enable(&pdev->dev);
 
 	return ret;
 }
-- 
2.35.1



