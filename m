Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF2A61E40E
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiKFRHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiKFRGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:06:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA61D11A19;
        Sun,  6 Nov 2022 09:05:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D2C660CD4;
        Sun,  6 Nov 2022 17:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D12C433C1;
        Sun,  6 Nov 2022 17:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754317;
        bh=g4cq773dvlASalNtfikbmrufDOKIajeBhDLQDHGfWhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=etMYRrSt4vwZg1LDTBtqPKwyW8GQQuOFJCD0ye+Ixk2AmHvGUrsci4fetXQNqUSA6
         EuSvrLf85nwE9YpOpKw9BoHKXoZ94RB/7E2tMV/T3hT16opec3c54GbrbQqi0ZTc/q
         2H2JrD3jhgYHJ/1+wCej4vIgSQZi52emL1tb9wsQcyStvt/kOJEWLcuByK3QDdQL5p
         8gxm/l7wQagXAC3Qn3cgGAOFZrX1TfA+Ln0k3eVw9KcbyK/xMi8YnlTAIQkPTQACq2
         BBufSOhvbyZbTohc0MlMJN6bgBX2Ln0AxC4fJnqpQqbUY3kxhpprZdkK4Q0kFdbqzy
         AMM4pQYOtA6bg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 03/18] ASoC: wm8997: Revert "ASoC: wm8997: Fix PM disable depth imbalance in wm8997_probe"
Date:   Sun,  6 Nov 2022 12:04:52 -0500
Message-Id: <20221106170509.1580304-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170509.1580304-1-sashal@kernel.org>
References: <20221106170509.1580304-1-sashal@kernel.org>
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

[ Upstream commit 68ce83e3bb26feba0fcdd59667fde942b3a600a1 ]

This reverts commit 41a736ac20602f64773e80f0f5b32cde1830a44a.

The pm_runtime_disable is redundant when error returns in
wm8997_probe, we just revert the old patch to fix it.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20221010114852.88127-4-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8997.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8997.c b/sound/soc/codecs/wm8997.c
index c8c711e555c0..38ef631d1a1f 100644
--- a/sound/soc/codecs/wm8997.c
+++ b/sound/soc/codecs/wm8997.c
@@ -1162,6 +1162,9 @@ static int wm8997_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm8997_digital_vu[i],
 				   WM8997_DIG_VU, WM8997_DIG_VU);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	arizona_init_common(arizona);
 
 	ret = arizona_init_vol_limit(arizona);
@@ -1180,9 +1183,6 @@ static int wm8997_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	return ret;
 
 err_spk_irqs:
-- 
2.35.1

