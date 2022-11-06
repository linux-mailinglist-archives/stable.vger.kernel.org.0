Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7883E61E43A
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiKFRJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbiKFRIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:08:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4341183B;
        Sun,  6 Nov 2022 09:06:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BFE18CE0DA3;
        Sun,  6 Nov 2022 17:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F42C433C1;
        Sun,  6 Nov 2022 17:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754358;
        bh=6KG5m9XApVpdHLC3NcSvYAiVS7AmZYt5nk9nikO4EuM=;
        h=From:To:Cc:Subject:Date:From;
        b=hSiIf2raEPbtw07+OzUccOmdpmlOyImKRk5mPAca8lfI0L4CKQd6n7JDxfADOJKBQ
         8JMG9Ew/Ycgzc+OpLpPj3PLr+Bi9nknBMnyJGI6zjy+ZBpyVnPHasQw5xB4/5J6jK7
         H9zCt9vEFenPChP9ltkxktVTegjuNyisO9hgKyDUrp74aWTnAVbiz2H9H0VJ/U9Ow8
         xQL6p3pX+KDA8iv47/ZHewsKPmm9hXJ5Ia7Ebzuf25n3sS4fqTA/z+sTuDpRbiS2wP
         2HRKtUS2HZSMLalIVtbwEh0LI6D5CRGS2ar0JgjyyzNDUWUxJk6T8z1KGv9tcVauxJ
         3LI3lhB09UMtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 01/16] ASoC: wm5102: Revert "ASoC: wm5102: Fix PM disable depth imbalance in wm5102_probe"
Date:   Sun,  6 Nov 2022 12:05:38 -0500
Message-Id: <20221106170555.1580584-1-sashal@kernel.org>
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
index b7f5e5391fdb..2ed3fa67027d 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -2083,6 +2083,9 @@ static int wm5102_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm5102_digital_vu[i],
 				   WM5102_DIG_VU, WM5102_DIG_VU);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	ret = arizona_request_irq(arizona, ARIZONA_IRQ_DSP_IRQ1,
 				  "ADSP2 Compressed IRQ", wm5102_adsp2_irq,
 				  wm5102);
@@ -2115,9 +2118,6 @@ static int wm5102_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	return ret;
 
 err_spk_irqs:
-- 
2.35.1

