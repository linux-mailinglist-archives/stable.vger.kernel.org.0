Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B22B6047C4
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiJSNpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiJSNoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:44:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0659AD8B;
        Wed, 19 Oct 2022 06:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 843E3B8241C;
        Wed, 19 Oct 2022 08:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD26FC433D6;
        Wed, 19 Oct 2022 08:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169787;
        bh=mHHiX2Vds7w034Q/10+IvKu6BhX3WEG6qDXMWNVsef8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eIcNm3x04mz+6L+fwf3zcZEzC5J37pUA4zgEcxrJX7ujP6wKuQ/WgYF4iwa55PHCc
         +2O7EBJ2o2A7kAXQTfT9u3ce52QS8hm225guwQbRWKhFj2u2lZPmfykjn/FVR+2Eub
         LiBgzOO63/j11GQypFc1vjowgNpUg5RQZD4n/YBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 407/862] ASoC: stm: Fix PM disable depth imbalance in stm32_i2s_probe
Date:   Wed, 19 Oct 2022 10:28:14 +0200
Message-Id: <20221019083307.934299755@linuxfoundation.org>
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

[ Upstream commit 93618e5e05a3ce4aa6750268c5025bdb4cb7dc6e ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context. We fix it by moving
pm_runtime_enable to the endding of stm32_i2s_probe.

Fixes:32a956a1fadf ("ASoC: stm32: i2s: add pm_runtime support")

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://lore.kernel.org/r/20220927142640.64647-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_i2s.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/stm/stm32_i2s.c b/sound/soc/stm/stm32_i2s.c
index 6aafe793eec4..ce7f6942308f 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -1136,8 +1136,6 @@ static int stm32_i2s_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(i2s->regmap),
 				     "Regmap init error\n");
 
-	pm_runtime_enable(&pdev->dev);
-
 	ret = snd_dmaengine_pcm_register(&pdev->dev, &stm32_i2s_pcm_config, 0);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret, "PCM DMA register error\n");
@@ -1180,6 +1178,8 @@ static int stm32_i2s_probe(struct platform_device *pdev)
 			FIELD_GET(I2S_VERR_MIN_MASK, val));
 	}
 
+	pm_runtime_enable(&pdev->dev);
+
 	return ret;
 
 error:
-- 
2.35.1



