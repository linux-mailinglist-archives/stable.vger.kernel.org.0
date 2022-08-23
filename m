Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F5059D584
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346860AbiHWImn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347128AbiHWIko (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:40:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFCC4DF04;
        Tue, 23 Aug 2022 01:19:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 567076137C;
        Tue, 23 Aug 2022 08:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B399C433C1;
        Tue, 23 Aug 2022 08:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242682;
        bh=4w3lDk5hzKUuT+9+ilwQbT7hBop2B7aR7/BqfQaQuMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrdHCQaGAB4NPAECdyMJcpdnZO9/gXFLz9Qa4a031J4onVGwYy4GU/7SnV+BQlalS
         BNzBHOKNnzh4O3z6EsF4xyAn8xgkGDdz1VThpeJZcmTOUeiXW2ltptsyfWkfhDQl+O
         9U0OXfo6tSVPwCDgPcvUpt0AqUfNTODe1iImwPi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Sai Prakash Ranjan <quic_saipraka@quicinc.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 087/101] irqchip/tegra: Fix overflow implicit truncation warnings
Date:   Tue, 23 Aug 2022 10:04:00 +0200
Message-Id: <20220823080037.865505015@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sai Prakash Ranjan <quic_saipraka@quicinc.com>

[ Upstream commit 443685992bda9bb4f8b17fc02c9f6c60e62b1461 ]

Fix -Woverflow warnings for tegra irqchip driver which is a result
of moving arm64 custom MMIO accessor macros to asm-generic function
implementations giving a bonus type-checking now and uncovering these
overflow warnings.

drivers/irqchip/irq-tegra.c: In function ‘tegra_ictlr_suspend’:
drivers/irqchip/irq-tegra.c:151:18: warning: large integer implicitly truncated to unsigned type [-Woverflow]
   writel_relaxed(~0ul, ictlr + ICTLR_COP_IER_CLR);
                  ^

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sai Prakash Ranjan <quic_saipraka@quicinc.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-tegra.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-tegra.c b/drivers/irqchip/irq-tegra.c
index 3973a14bb15b..02ffefd5011a 100644
--- a/drivers/irqchip/irq-tegra.c
+++ b/drivers/irqchip/irq-tegra.c
@@ -157,10 +157,10 @@ static int tegra_ictlr_suspend(void)
 		lic->cop_iep[i] = readl_relaxed(ictlr + ICTLR_COP_IEP_CLASS);
 
 		/* Disable COP interrupts */
-		writel_relaxed(~0ul, ictlr + ICTLR_COP_IER_CLR);
+		writel_relaxed(GENMASK(31, 0), ictlr + ICTLR_COP_IER_CLR);
 
 		/* Disable CPU interrupts */
-		writel_relaxed(~0ul, ictlr + ICTLR_CPU_IER_CLR);
+		writel_relaxed(GENMASK(31, 0), ictlr + ICTLR_CPU_IER_CLR);
 
 		/* Enable the wakeup sources of ictlr */
 		writel_relaxed(lic->ictlr_wake_mask[i], ictlr + ICTLR_CPU_IER_SET);
@@ -181,12 +181,12 @@ static void tegra_ictlr_resume(void)
 
 		writel_relaxed(lic->cpu_iep[i],
 			       ictlr + ICTLR_CPU_IEP_CLASS);
-		writel_relaxed(~0ul, ictlr + ICTLR_CPU_IER_CLR);
+		writel_relaxed(GENMASK(31, 0), ictlr + ICTLR_CPU_IER_CLR);
 		writel_relaxed(lic->cpu_ier[i],
 			       ictlr + ICTLR_CPU_IER_SET);
 		writel_relaxed(lic->cop_iep[i],
 			       ictlr + ICTLR_COP_IEP_CLASS);
-		writel_relaxed(~0ul, ictlr + ICTLR_COP_IER_CLR);
+		writel_relaxed(GENMASK(31, 0), ictlr + ICTLR_COP_IER_CLR);
 		writel_relaxed(lic->cop_ier[i],
 			       ictlr + ICTLR_COP_IER_SET);
 	}
@@ -321,7 +321,7 @@ static int __init tegra_ictlr_init(struct device_node *node,
 		lic->base[i] = base;
 
 		/* Disable all interrupts */
-		writel_relaxed(~0UL, base + ICTLR_CPU_IER_CLR);
+		writel_relaxed(GENMASK(31, 0), base + ICTLR_CPU_IER_CLR);
 		/* All interrupts target IRQ */
 		writel_relaxed(0, base + ICTLR_CPU_IEP_CLASS);
 
-- 
2.35.1



