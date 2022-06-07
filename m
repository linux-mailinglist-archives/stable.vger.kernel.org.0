Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52914540C31
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349606AbiFGSeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351979AbiFGSdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:33:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDE717EC34;
        Tue,  7 Jun 2022 10:57:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6E0EB82371;
        Tue,  7 Jun 2022 17:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DF3C385A5;
        Tue,  7 Jun 2022 17:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624624;
        bh=wH7/90BcNZzwB2bJOgzMEcaResWqJwE5uqhLmPT9ENA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PpZD7TKgF9X5yRD66zqx6I3uWcQWIaAF2yym1jzJLwz3wg8RGHPfWuMzdW0pydLLp
         a8jYsAIMfVHqeRKApcOcyvMGCOLrt0ZIooME5BgB/eHLSkiOkKVJV/Q4JRdZCIX7Z6
         5TzDYey8OjizP6CT6HUL948esx/z33J6pw+gAuDuOj2gKzHOWTfvbdMgZcuKyjMgzq
         w7VSTp3m5rI7jEssQc2L1wSbI8mns1VIvgmdztYuDZJbwJx+zHB9Np5OQnHZv6/AJ1
         wegSUFTb07xsf8h8gldBG6r01aXSNtcb4VtPQKCl0IY0xkpI7Z55yby/S7gtht+tnj
         bSNfwElqy6nkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de
Subject: [PATCH AUTOSEL 5.15 23/51] clocksource/drivers/sp804: Avoid error on multiple instances
Date:   Tue,  7 Jun 2022 13:55:22 -0400
Message-Id: <20220607175552.479948-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175552.479948-1-sashal@kernel.org>
References: <20220607175552.479948-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit a98399cbc1e05f7b977419f03905501d566cf54e ]

When a machine sports more than one SP804 timer instance, we only bring
up the first one, since multiple timers of the same kind are not useful
to Linux. As this is intentional behaviour, we should not return an
error message, as we do today:
===============
[    0.000800] Failed to initialize '/bus@8000000/motherboard-bus@8000000/iofpga-bus@300000000/timer@120000': -22
===============

Replace the -EINVAL return with a debug message and return 0 instead.

Also we do not reach the init function anymore if the DT node is
disabled (as this is now handled by OF_DECLARE), so remove the explicit
check for that case.

This fixes a long standing bogus error when booting ARM's fastmodels.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20220506162522.3675399-1-andre.przywara@arm.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-sp804.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/timer-sp804.c b/drivers/clocksource/timer-sp804.c
index 401d592e85f5..e6a87f4af2b5 100644
--- a/drivers/clocksource/timer-sp804.c
+++ b/drivers/clocksource/timer-sp804.c
@@ -259,6 +259,11 @@ static int __init sp804_of_init(struct device_node *np, struct sp804_timer *time
 	struct clk *clk1, *clk2;
 	const char *name = of_get_property(np, "compatible", NULL);
 
+	if (initialized) {
+		pr_debug("%pOF: skipping further SP804 timer device\n", np);
+		return 0;
+	}
+
 	base = of_iomap(np, 0);
 	if (!base)
 		return -ENXIO;
@@ -270,11 +275,6 @@ static int __init sp804_of_init(struct device_node *np, struct sp804_timer *time
 	writel(0, timer1_base + timer->ctrl);
 	writel(0, timer2_base + timer->ctrl);
 
-	if (initialized || !of_device_is_available(np)) {
-		ret = -EINVAL;
-		goto err;
-	}
-
 	clk1 = of_clk_get(np, 0);
 	if (IS_ERR(clk1))
 		clk1 = NULL;
-- 
2.35.1

