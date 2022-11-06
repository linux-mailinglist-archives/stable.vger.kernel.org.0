Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C2E61E3A7
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiKFREA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiKFRD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:03:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6185E018;
        Sun,  6 Nov 2022 09:03:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67FEEB80BED;
        Sun,  6 Nov 2022 17:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40E8C433B5;
        Sun,  6 Nov 2022 17:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754236;
        bh=BlHBcJB8ZwkL6rjtBjKyyCuYCrVc9UriR2h3+tIdkQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWjjlgLQ0C40LOB3xgu6Zge8CnqpWhe8ouk+6oKi59l6btcXc0Rki/5VEf9Pk7j+w
         PYykaVaO/fv5ESUNwmovR8EO+S522zRjpWUDhly5ReJQGHRFOtO1mlg2wmUN74o+EM
         jXsr14zafVeydWy5S6UlO8Lu2ctTErDJXuQBbdqygXjejEsrc44c0xrZBk+uRS68rD
         TYHHNsn2UItntXZcq4PAVi/euolj/J9FyUvzC4ZuM7i4ai0hVIGfcaqQqnGC30gL04
         B/MDzOBrWy8zST5ReqTwXlqYExoyEN88nVuH8xvWJT11GLvFAbfShRB2/mEcKgb5OQ
         XPzEf/eGAXpPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 04/30] ASoC: wm5110: Revert "ASoC: wm5110: Fix PM disable depth imbalance in wm5110_probe"
Date:   Sun,  6 Nov 2022 12:03:16 -0500
Message-Id: <20221106170345.1579893-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170345.1579893-1-sashal@kernel.org>
References: <20221106170345.1579893-1-sashal@kernel.org>
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
index fc634c995834..f3f4a10bf0f7 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -2457,6 +2457,9 @@ static int wm5110_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm5110_digital_vu[i],
 				   WM5110_DIG_VU, WM5110_DIG_VU);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	ret = arizona_request_irq(arizona, ARIZONA_IRQ_DSP_IRQ1,
 				  "ADSP2 Compressed IRQ", wm5110_adsp2_irq,
 				  wm5110);
@@ -2489,9 +2492,6 @@ static int wm5110_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	return ret;
 
 err_spk_irqs:
-- 
2.35.1

