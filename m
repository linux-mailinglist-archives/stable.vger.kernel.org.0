Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7CF9635686
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237786AbiKWJbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237785AbiKWJa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:30:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEFDE8A
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:29:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DAC7ACE20EC
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA935C433D6;
        Wed, 23 Nov 2022 09:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195773;
        bh=0962/nnKhBf2bAmZiiQyeQHRPm1jDKsRvyc8iH052qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evmwj2Myk4gABY2SqiWMZtYbYE8VyChwN1GzSg9O/dTA60QztOl188N3UPF8KjMsZ
         u8fVyHYvswjG/nwHvkvu0BQVZPi7Mbtr9zYHH6tFVyV+DHAtCkO3jlnZLJLQIz293f
         dRGiAWhKmVw4RtemDHVvRMmr6JrQSXllSYzXyGgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Qilong <zhangqilong3@huawei.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/181] ASoC: wm5102: Revert "ASoC: wm5102: Fix PM disable depth imbalance in wm5102_probe"
Date:   Wed, 23 Nov 2022 09:49:27 +0100
Message-Id: <20221123084602.848489788@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

[ Upstream commit de71d7567e358effd06dfc3e2a154b25f1331c10 ]

This reverts commit fcbb60820cd3008bb44334a0395e5e57ccb77329.

The pm_runtime_disable is redundant when error returns in
wm5102_probe, we just revert the old patch to fix it.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20221010114852.88127-2-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm5102.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm5102.c b/sound/soc/codecs/wm5102.c
index c8adce8936bc..621598608bf0 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -2087,6 +2087,9 @@ static int wm5102_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm5102_digital_vu[i],
 				   WM5102_DIG_VU, WM5102_DIG_VU);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	ret = arizona_request_irq(arizona, ARIZONA_IRQ_DSP_IRQ1,
 				  "ADSP2 Compressed IRQ", wm5102_adsp2_irq,
 				  wm5102);
@@ -2119,9 +2122,6 @@ static int wm5102_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	return ret;
 
 err_spk_irqs:
-- 
2.35.1



