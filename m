Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C68763553A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237293AbiKWJPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237263AbiKWJPR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:15:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAA7107E44
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:15:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 035F4B81EF5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13889C433C1;
        Wed, 23 Nov 2022 09:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194913;
        bh=vczTo+3PmWL+4BALxrRkYT1pHu2q6iwT5EFYiSxxAF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iU3VFC5uUQpsw38YnJqdKbmhseuqB3kUMAKgstvBKuZdqbazkFT+TguwSPJOtCWZW
         H1lwGCqBVr+cpjKUHkJNtaT8yGt56CJqRClR/3jmwFHH5n0mcgF+XQxqFtaOpb2wU4
         mQmCJ8XwNjbuC8X4WSoGG/TXYur02gYmaVkH/f1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Qilong <zhangqilong3@huawei.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/156] ASoC: wm5110: Revert "ASoC: wm5110: Fix PM disable depth imbalance in wm5110_probe"
Date:   Wed, 23 Nov 2022 09:50:22 +0100
Message-Id: <20221123084600.289537917@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

[ Upstream commit 7d4e966f4cd73ff69bf06934e8e14a33fb7ef447 ]

This reverts commit 86b46bf1feb83898d89a2b4a8d08d21e9ea277a7.

The pm_runtime_disable is redundant when error returns in
wm5110_probe, we just revert the old patch to fix it.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20221010114852.88127-3-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm5110.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index bbe9fdfb423c..06ec3f48c808 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -2452,6 +2452,9 @@ static int wm5110_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm5110_digital_vu[i],
 				   WM5110_DIG_VU, WM5110_DIG_VU);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	ret = arizona_request_irq(arizona, ARIZONA_IRQ_DSP_IRQ1,
 				  "ADSP2 Compressed IRQ", wm5110_adsp2_irq,
 				  wm5110);
@@ -2484,9 +2487,6 @@ static int wm5110_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	return ret;
 
 err_spk_irqs:
-- 
2.35.1



