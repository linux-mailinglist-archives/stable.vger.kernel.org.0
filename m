Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB3D4F34B1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349400AbiDEKur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345372AbiDEJnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:43:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8933CC12D9;
        Tue,  5 Apr 2022 02:28:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75AB46165C;
        Tue,  5 Apr 2022 09:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BCEC385A0;
        Tue,  5 Apr 2022 09:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150924;
        bh=VAF5i6aKP1e/tf2Wm8Jq42UU+785ciOTpaHVQGl6Dug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgxkg8i1e4zmytmPpN71HXLsNRZ6OG56/yU4FCW1je5cByuyqdRtA3loDuGxczylW
         lNBVcXPj20ltFAIqfByHDLki7hgbJvGdL4D6YAE+KiKSq5xtBhZU0U6TGAK46818Yl
         30hFhGRjA83a1DPbY+YZL6GFJtS9XILSsszvcLTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 230/913] clocksource/drivers/exynos_mct: Handle DTS with higher number of interrupts
Date:   Tue,  5 Apr 2022 09:21:32 +0200
Message-Id: <20220405070346.750586466@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit ab8da93dc06d82f464c47ab30e6c75190702f369 ]

The driver statically defines maximum number of interrupts it can
handle, however it does not respect that limit when configuring them.
When provided with a DTS with more interrupts than assumed, the driver
will overwrite static array mct_irqs leading to silent memory
corruption.

Validate the interrupts coming from DTS to avoid this.  This does not
change the fact that such DTS might not boot at all, because it is
simply incompatible, however at least some warning will be printed.

Fixes: 36ba5d527e95 ("ARM: EXYNOS: add device tree support for MCT controller driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Link: https://lore.kernel.org/r/20220220103815.135380-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/exynos_mct.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 857cf12ebe57..cc2a961ddd3b 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -541,6 +541,11 @@ static int __init exynos4_timer_interrupts(struct device_node *np,
 	 * irqs are specified.
 	 */
 	nr_irqs = of_irq_count(np);
+	if (nr_irqs > ARRAY_SIZE(mct_irqs)) {
+		pr_err("exynos-mct: too many (%d) interrupts configured in DT\n",
+			nr_irqs);
+		nr_irqs = ARRAY_SIZE(mct_irqs);
+	}
 	for (i = MCT_L0_IRQ; i < nr_irqs; i++)
 		mct_irqs[i] = irq_of_parse_and_map(np, i);
 
@@ -553,11 +558,14 @@ static int __init exynos4_timer_interrupts(struct device_node *np,
 		     mct_irqs[MCT_L0_IRQ], err);
 	} else {
 		for_each_possible_cpu(cpu) {
-			int mct_irq = mct_irqs[MCT_L0_IRQ + cpu];
+			int mct_irq;
 			struct mct_clock_event_device *pcpu_mevt =
 				per_cpu_ptr(&percpu_mct_tick, cpu);
 
 			pcpu_mevt->evt.irq = -1;
+			if (MCT_L0_IRQ + cpu >= ARRAY_SIZE(mct_irqs))
+				break;
+			mct_irq = mct_irqs[MCT_L0_IRQ + cpu];
 
 			irq_set_status_flags(mct_irq, IRQ_NOAUTOEN);
 			if (request_irq(mct_irq,
-- 
2.34.1



