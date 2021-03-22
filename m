Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7703443B0
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhCVMxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231797AbhCVMvD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:51:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C799A6191C;
        Mon, 22 Mar 2021 12:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417144;
        bh=euZCduEQCwhBFTcqkM5DEM5BTfllHg05eeO5hxEoQgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BlrE3nAR52YSsSyZuHk+CI1lWtRU6eDIaIDNEGU5pBxzgCwW/ynF1tCfr5w5TZsg4
         PHu2SytZDrB/S1RXBmtiQHD17J8v6tEW7cXJKpNpzEbyVg//NpVjdE7TDpn5RYFZ69
         iF6kra9WJT203BzpTf24G7AKOd7u711XXFoeiwWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4.19 42/43] genirq: Disable interrupts for force threaded handlers
Date:   Mon, 22 Mar 2021 13:28:56 +0100
Message-Id: <20210322121921.286954168@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121919.936671417@linuxfoundation.org>
References: <20210322121919.936671417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 81e2073c175b887398e5bca6c004efa89983f58d upstream.

With interrupt force threading all device interrupt handlers are invoked
from kernel threads. Contrary to hard interrupt context the invocation only
disables bottom halfs, but not interrupts. This was an oversight back then
because any code like this will have an issue:

thread(irq_A)
  irq_handler(A)
    spin_lock(&foo->lock);

interrupt(irq_B)
  irq_handler(B)
    spin_lock(&foo->lock);

This has been triggered with networking (NAPI vs. hrtimers) and console
drivers where printk() happens from an interrupt which interrupted the
force threaded handler.

Now people noticed and started to change the spin_lock() in the handler to
spin_lock_irqsave() which affects performance or add IRQF_NOTHREAD to the
interrupt request which in turn breaks RT.

Fix the root cause and not the symptom and disable interrupts before
invoking the force threaded handler which preserves the regular semantics
and the usefulness of the interrupt force threading as a general debugging
tool.

For not RT this is not changing much, except that during the execution of
the threaded handler interrupts are delayed until the handler
returns. Vs. scheduling and softirq processing there is no difference.

For RT kernels there is no issue.

Fixes: 8d32a307e4fa ("genirq: Provide forced interrupt threading")
Reported-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Johan Hovold <johan@kernel.org>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/20210317143859.513307808@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/manage.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -987,11 +987,15 @@ irq_forced_thread_fn(struct irq_desc *de
 	irqreturn_t ret;
 
 	local_bh_disable();
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT_BASE))
+		local_irq_disable();
 	ret = action->thread_fn(action->irq, action->dev_id);
 	if (ret == IRQ_HANDLED)
 		atomic_inc(&desc->threads_handled);
 
 	irq_finalize_oneshot(desc, action);
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT_BASE))
+		local_irq_enable();
 	local_bh_enable();
 	return ret;
 }


