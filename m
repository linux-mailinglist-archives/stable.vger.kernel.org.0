Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57BD58C092
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242922AbiHHBwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243433AbiHHBu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:50:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF69DFE5;
        Sun,  7 Aug 2022 18:37:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C398160DF8;
        Mon,  8 Aug 2022 01:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416E4C43150;
        Mon,  8 Aug 2022 01:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922677;
        bh=ZhQdQ25lhwjVuqIW3YiIiWB8Dz9feH/CLcYEmXCV7wM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xbl+/tu4xchq6CYNztAm89nLBA2jmWrh1ibZkL5hQNyIsumQ8J2aOmCYUQcKdSThi
         d+PIDmRHETvc0KyCS+MCQ4AlBnJLm4dnEGzbaaw6cE1hfCUetWq16xJdTQnOdOmpVP
         qrh0HkSd6TRBIgxIaabV36U+y3mGWqmsRoOtmT+Bqb7LFvubbvhYhtz5A6OeziP0MJ
         uiPLDZgQCUyB46BpNPGvIX/rVyTo6m3/LXWqlsL2qNRHDg9gpr0/J4UuBLLOtQ09rA
         BobWaDeQ/+8oTSYFhz36NkpfOJOwEPMYqgZ8+QyhDykzPjbizmFiYYwcUmG8fcQdJv
         lkVDJLBM49v9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     William Dean <williamsukatube@163.com>,
        Hacash Robot <hacashRobot@santino.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tsbogend@alpha.franken.de, fancer.lancer@gmail.com,
        tglx@linutronix.de, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/29] irqchip/mips-gic: Check the return value of ioremap() in gic_of_init()
Date:   Sun,  7 Aug 2022 21:37:18 -0400
Message-Id: <20220808013741.316026-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013741.316026-1-sashal@kernel.org>
References: <20220808013741.316026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Dean <williamsukatube@163.com>

[ Upstream commit 71349cc85e5930dce78ed87084dee098eba24b59 ]

The function ioremap() in gic_of_init() can fail, so
its return value should be checked.

Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: William Dean <williamsukatube@163.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220723100128.2964304-1-williamsukatube@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mips-gic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 8b08b31ea2ba..8ada91bdbe4d 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -766,6 +766,10 @@ static int __init gic_of_init(struct device_node *node,
 	}
 
 	mips_gic_base = ioremap(gic_base, gic_len);
+	if (!mips_gic_base) {
+		pr_err("Failed to ioremap gic_base\n");
+		return -ENOMEM;
+	}
 
 	gicconfig = read_gic_config();
 	gic_shared_intrs = gicconfig & GIC_CONFIG_NUMINTERRUPTS;
-- 
2.35.1

