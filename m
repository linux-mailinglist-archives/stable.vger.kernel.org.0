Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A3D53DBC1
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 15:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244215AbiFENx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 09:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241771AbiFENx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 09:53:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF562AF5;
        Sun,  5 Jun 2022 06:53:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F28E360F9E;
        Sun,  5 Jun 2022 13:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C096EC34115;
        Sun,  5 Jun 2022 13:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654437204;
        bh=4qMC9CoFFzyDXCOkYG5Quuebl4JSXLc6N91kOk/wLXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0F5En/COjfnWWoKWWwoTZ6GU2ixzRRpucn4HiEwylYCbckSiP3fbhtK190MFIZzg
         /7G43vZYpX3VKz5qO7E1tX61OeItN1ru/sRnEBEbXZTINyA9bfa25hT7I+Zy9iP2kw
         ktWxoNOgTbIiCTlNaWiDlMRb8nJuaBORTxXuOrO3De+D92u8adFL6J3OZcvAWO1WVM
         3RQ4sz7P10GZGpIFDNw8RLvNZVxO1y3GwV6ELx1dFWxTqEvzWvsPH+3HEECzNiIsF5
         wwuDBMabsEVQ5ruDPnXpQAk1giYThD6YNHesgdlmf4nevp0V4JMck8r+rw6RGcSPT/
         2f7S2oUkyPMeg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH MANUALSEL 5.18 2/7] genirq/irq_sim: Make the irq_work always run in hard irq context
Date:   Sun,  5 Jun 2022 09:53:10 -0400
Message-Id: <20220605135320.61247-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220605135320.61247-1-sashal@kernel.org>
References: <20220605135320.61247-1-sashal@kernel.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 21673fcb2532dcd189905ff5a5389eb7dcd0e57a ]

The IRQ simulator uses irq_work to trigger an interrupt. Without the
IRQ_WORK_HARD_IRQ flag the irq_work will be performed in thread context
on PREEMPT_RT. This causes locking errors later in handle_simple_irq()
which expects to be invoked with disabled interrupts.

Triggering individual interrupts in hardirq context should not lead to
unexpected high latencies since this is also what the hardware
controller does. Also it is used as a simulator so...

Use IRQ_WORK_INIT_HARD() to carry out the irq_work in hardirq context on
PREEMPT_RT.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/YnuZBoEVMGwKkLm+@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irq_sim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/irq_sim.c b/kernel/irq/irq_sim.c
index 0cd02efa3a74..dd76323ea3fd 100644
--- a/kernel/irq/irq_sim.c
+++ b/kernel/irq/irq_sim.c
@@ -181,7 +181,7 @@ struct irq_domain *irq_domain_create_sim(struct fwnode_handle *fwnode,
 		goto err_free_bitmap;
 
 	work_ctx->irq_count = num_irqs;
-	init_irq_work(&work_ctx->work, irq_sim_handle_irq);
+	work_ctx->work = IRQ_WORK_INIT_HARD(irq_sim_handle_irq);
 
 	return work_ctx->domain;
 
-- 
2.35.1

