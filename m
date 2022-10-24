Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CEB60AA41
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiJXNbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236208AbiJXN36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:29:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EABA39BB7;
        Mon, 24 Oct 2022 05:33:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 484F8B81334;
        Mon, 24 Oct 2022 12:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A079EC433C1;
        Mon, 24 Oct 2022 12:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613356;
        bh=ftqTTz4oueZLOW8B6OOpn9+6JAH7uQ2dzq2hyjs5PNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qP5zeIh3arv2uXg5wLR/mtoKcyyOtJwt6k6XaqexITHj4bCPy1uUxJ3oDy/7QuVea
         Fw1FPcRbrUOwHnxZFSZsIr/D2y8+m54G7ZF3pKs1TlOMKmPOi3/CTgUx0muAph82Ub
         a8qW9inXAHIRaf2hKg8iCxi/291JevSn846WBKjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 106/255] ASoC: wm5102: Fix PM disable depth imbalance in wm5102_probe
Date:   Mon, 24 Oct 2022 13:30:16 +0200
Message-Id: <20221024113005.981453324@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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

[ Upstream commit fcbb60820cd3008bb44334a0395e5e57ccb77329 ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context. We fix it by moving
pm_runtime_enable to the endding of wm5102_probe.

Fixes:93e8791dd34ca ("ASoC: wm5102: Initial driver")

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20220928160116.125020-4-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm5102.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm5102.c b/sound/soc/codecs/wm5102.c
index d6d4b4121369..c5667b149c70 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -2084,9 +2084,6 @@ static int wm5102_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm5102_digital_vu[i],
 				   WM5102_DIG_VU, WM5102_DIG_VU);
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	ret = arizona_request_irq(arizona, ARIZONA_IRQ_DSP_IRQ1,
 				  "ADSP2 Compressed IRQ", wm5102_adsp2_irq,
 				  wm5102);
@@ -2119,6 +2116,9 @@ static int wm5102_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	return ret;
 
 err_spk_irqs:
-- 
2.35.1



