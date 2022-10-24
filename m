Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A0060ABAF
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbiJXNzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236729AbiJXNxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:53:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5F2BCBBB;
        Mon, 24 Oct 2022 05:43:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06D766130D;
        Mon, 24 Oct 2022 12:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199F2C433C1;
        Mon, 24 Oct 2022 12:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615413;
        bh=HwiXSdroz8eQ6MEaXKUECvcjmJX8KqgXnrZziaxBMv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDZVQHahFSIY6Wh3hjHpQFF/MrA5+TzCVMVWdQiFgbcp0d5hEaA+Gl2+xbvau2oaE
         grTCTpZzBNoaY07fTmIm9YuPCBfVm31a8ogQcloBv4pu+kf/EZYXGy2cVzVsKp5LLL
         U+WlpPoHJ0duzXA1JCUB82jFt3YHuCjTOEaYQzoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/530] ASoC: wm5110: Fix PM disable depth imbalance in wm5110_probe
Date:   Mon, 24 Oct 2022 13:29:46 +0200
Message-Id: <20221024113056.056635336@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 86b46bf1feb83898d89a2b4a8d08d21e9ea277a7 ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context. We fix it by moving
pm_runtime_enable to the endding of wm5110_probe.

Fixes:5c6af635fd772 ("ASoC: wm5110: Add audio CODEC driver")

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20220928160116.125020-3-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm5110.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 7c6e01720d65..66a4827c16bd 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -2458,9 +2458,6 @@ static int wm5110_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm5110_digital_vu[i],
 				   WM5110_DIG_VU, WM5110_DIG_VU);
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	ret = arizona_request_irq(arizona, ARIZONA_IRQ_DSP_IRQ1,
 				  "ADSP2 Compressed IRQ", wm5110_adsp2_irq,
 				  wm5110);
@@ -2493,6 +2490,9 @@ static int wm5110_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	return ret;
 
 err_spk_irqs:
-- 
2.35.1



