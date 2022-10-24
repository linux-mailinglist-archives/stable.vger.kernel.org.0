Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABDB60B4ED
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbiJXSIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiJXSH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:07:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED90202727;
        Mon, 24 Oct 2022 09:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34C6CB811D3;
        Mon, 24 Oct 2022 11:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7C4C433C1;
        Mon, 24 Oct 2022 11:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612753;
        bh=tstd9ZdpUq6Dk1Sy6I/iF27IlR0OnBZfBh7L2kweZLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVmKLZ4UJqLhOu5WQfeMWED1jtf3IX8xuvflJfy/GV3ERsy3VdyqK2kffUN2wuSuD
         XH4CWlNOLzBUGvQM9VGNsoC19iNaBjDRXozBOfMu5sXZdnulszwxJWNVFf+MwBT472
         PHyxYX4YipJ6i2r/AwhHF/i/z4upvz5ecep0ENEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/229] ASoC: wm5110: Fix PM disable depth imbalance in wm5110_probe
Date:   Mon, 24 Oct 2022 13:30:25 +0200
Message-Id: <20221024113002.445463248@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
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
index e510aca55163..43a47312d71b 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -2453,9 +2453,6 @@ static int wm5110_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm5110_digital_vu[i],
 				   WM5110_DIG_VU, WM5110_DIG_VU);
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	ret = arizona_request_irq(arizona, ARIZONA_IRQ_DSP_IRQ1,
 				  "ADSP2 Compressed IRQ", wm5110_adsp2_irq,
 				  wm5110);
@@ -2488,6 +2485,9 @@ static int wm5110_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	return ret;
 
 err_spk_irqs:
-- 
2.35.1



