Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7935B61E469
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiKFRLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiKFRKm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:10:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52215FD00;
        Sun,  6 Nov 2022 09:07:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9DEDB80C69;
        Sun,  6 Nov 2022 17:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A28FC433D7;
        Sun,  6 Nov 2022 17:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754428;
        bh=NHKdBSp6RRhLLzcR4NyitTnOaDg7TBxCveMh4CfU8ZA=;
        h=From:To:Cc:Subject:Date:From;
        b=aroZzXFZX+lHo5WMSgYNxfcaJoz4Xkh/xRp6YB7X+mITtFtoZiO5gTtUVdBppyfQK
         4BQJHyDffdSHUsnI6NUVqAZksZvUSU1ZbOuXD+VXsNfhUDASqcyGpeI7KlGXkq59lg
         Nc9uTXAJtzECgXDVby3Zt6HiHiEGgYSzz42P0kCS/H87859ASuIjjQlZY4k9i0R7Su
         rfb/b1NmwM5pqtr9RPQcv/DgmQZz2FadMe3n+C/Rqcv6HSuXcrwwF+x+/WQ71KeELO
         PimoL52VpVJI0y1ACUyIu0XLGu7c5ZI6UOtH/pPIF2XtmxMp/s9JHSFM22DJNJERPM
         lsiw0dH7ndyHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 1/7] ASoC: wm5102: Revert "ASoC: wm5102: Fix PM disable depth imbalance in wm5102_probe"
Date:   Sun,  6 Nov 2022 12:06:58 -0500
Message-Id: <20221106170705.1580963-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 9b33c87c2fe4..7e817e1877c2 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -2085,6 +2085,9 @@ static int wm5102_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm5102_digital_vu[i],
 				   WM5102_DIG_VU, WM5102_DIG_VU);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	ret = arizona_request_irq(arizona, ARIZONA_IRQ_DSP_IRQ1,
 				  "ADSP2 Compressed IRQ", wm5102_adsp2_irq,
 				  wm5102);
@@ -2117,9 +2120,6 @@ static int wm5102_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	return ret;
 
 err_spk_irqs:
-- 
2.35.1

