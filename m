Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6EAE53DBDA
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 15:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344497AbiFENym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 09:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344419AbiFENyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 09:54:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2699B1E1;
        Sun,  5 Jun 2022 06:54:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75F7D60FA6;
        Sun,  5 Jun 2022 13:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D199C385A5;
        Sun,  5 Jun 2022 13:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654437245;
        bh=h4il9NEwlDhRClIoY7hNjlMkV92f7fL2oN4YkoUeJsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/mpuCW2Lr0kaFLAhpKw/OnbjBxq62LgIub3j3bXFFWVw2JHEB8lEzCGH1Je63umN
         g7kGKx6oUa/BCBJJ0arwnn0x/6da9t0t1K9xa9G+q69GBnGycf8cveXlPZZyRx65vz
         ySy7a5zMsCGrUreGzkRfzj/AX0QAAUaJC91p8TUqH8NZhR1+At95yFI8Hx2F9Lq+3/
         1pbmVOUpreK/3R1+p6ZeCKD6uqARNq3HDgyFcpVgZ5IVk4pNkttf1MtGzpxRFoLOx9
         G9cW4jFWKL+vSqHfu6i4AE7prfn7BfNqCj65Uhg6aaLW+B3hXfOi2SUV85Sf1LuIG/
         JkT1h7a0fRFHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH MANUALSEL 5.17 4/6] lib/irq_poll: Prevent softirq pending leak in irq_poll_cpu_dead()
Date:   Sun,  5 Jun 2022 09:53:35 -0400
Message-Id: <20220605135341.61427-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220605135341.61427-1-sashal@kernel.org>
References: <20220605135341.61427-1-sashal@kernel.org>
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

[ Upstream commit 75d8cce128c516fe6cf4b8683e8fe1a59e919902 ]

irq_poll_cpu_dead() pulls the blk_cpu_iopoll backlog from the dead CPU and
raises the POLL softirq with __raise_softirq_irqoff() on the CPU it is
running on. That just sets the bit in the pending softirq mask.

This means the handling of the softirq is delayed until the next interrupt
or a local_bh_disable/enable() pair. As a consequence the CPU on which this
code runs can reach idle with the POLL softirq pending, which triggers a
warning in the NOHZ idle code.

Add a local_bh_disable/enable() pair around the interrupts disabled section
in irq_poll_cpu_dead(). local_bh_enable will handle the pending softirq.

[tglx: Massaged changelog and comment]

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/87k0bxgl27.ffs@tglx
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/irq_poll.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/irq_poll.c b/lib/irq_poll.c
index 2f17b488d58e..2d5329a42105 100644
--- a/lib/irq_poll.c
+++ b/lib/irq_poll.c
@@ -188,14 +188,18 @@ EXPORT_SYMBOL(irq_poll_init);
 static int irq_poll_cpu_dead(unsigned int cpu)
 {
 	/*
-	 * If a CPU goes away, splice its entries to the current CPU
-	 * and trigger a run of the softirq
+	 * If a CPU goes away, splice its entries to the current CPU and
+	 * set the POLL softirq bit. The local_bh_disable()/enable() pair
+	 * ensures that it is handled. Otherwise the current CPU could
+	 * reach idle with the POLL softirq pending.
 	 */
+	local_bh_disable();
 	local_irq_disable();
 	list_splice_init(&per_cpu(blk_cpu_iopoll, cpu),
 			 this_cpu_ptr(&blk_cpu_iopoll));
 	__raise_softirq_irqoff(IRQ_POLL_SOFTIRQ);
 	local_irq_enable();
+	local_bh_enable();
 
 	return 0;
 }
-- 
2.35.1

