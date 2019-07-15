Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3081368FCA
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389771AbfGOOQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389764AbfGOOQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:16:47 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4D18206B8;
        Mon, 15 Jul 2019 14:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200206;
        bh=cAUwIub1pI+rARba9PzikXlrQ0MtODg9OBKPnMzw8nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTuHHsCXU1hwIbHVKbv3TDyyeWG5gJEKUB6wWrZHbGziQfnPmzJ53HFLqFhHLCA1E
         ZDB9Hn8LzX0QqrhMCAAvXuvATEdIJehBz0wJf1czmbOB2KFfKoFFauSUtvSMKMoUP3
         WzTNAfK96FjnmbrixTDm3kKhUhORAvTzcX42Kxxw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shijith Thotton <sthotton@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 208/219] genirq: Update irq stats from NMI handlers
Date:   Mon, 15 Jul 2019 10:03:29 -0400
Message-Id: <20190715140341.6443-208-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shijith Thotton <sthotton@marvell.com>

[ Upstream commit c09cb1293523dd786ae54a12fd88001542cba2f6 ]

The NMI handlers handle_percpu_devid_fasteoi_nmi() and handle_fasteoi_nmi()
do not update the interrupt counts. Due to that the NMI interrupt count
does not show up correctly in /proc/interrupts.

Add the statistics and treat the NMI handlers in the same way as per cpu
interrupts and prevent them from updating irq_desc::tot_count as this might
be corrupted due to concurrency.

[ tglx: Massaged changelog ]

Fixes: 2dcf1fbcad35 ("genirq: Provide NMI handlers")
Signed-off-by: Shijith Thotton <sthotton@marvell.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/1562313336-11888-1-git-send-email-sthotton@marvell.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/chip.c    | 4 ++++
 kernel/irq/irqdesc.c | 8 +++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 51128bea3846..9209a60d9b85 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -748,6 +748,8 @@ void handle_fasteoi_nmi(struct irq_desc *desc)
 	unsigned int irq = irq_desc_get_irq(desc);
 	irqreturn_t res;
 
+	__kstat_incr_irqs_this_cpu(desc);
+
 	trace_irq_handler_entry(irq, action);
 	/*
 	 * NMIs cannot be shared, there is only one action.
@@ -962,6 +964,8 @@ void handle_percpu_devid_fasteoi_nmi(struct irq_desc *desc)
 	unsigned int irq = irq_desc_get_irq(desc);
 	irqreturn_t res;
 
+	__kstat_incr_irqs_this_cpu(desc);
+
 	trace_irq_handler_entry(irq, action);
 	res = action->handler(irq, raw_cpu_ptr(action->percpu_dev_id));
 	trace_irq_handler_exit(irq, action, res);
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 9f8a709337cf..8a93df71673d 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -945,6 +945,11 @@ unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 			*per_cpu_ptr(desc->kstat_irqs, cpu) : 0;
 }
 
+static bool irq_is_nmi(struct irq_desc *desc)
+{
+	return desc->istate & IRQS_NMI;
+}
+
 /**
  * kstat_irqs - Get the statistics for an interrupt
  * @irq:	The interrupt number
@@ -962,7 +967,8 @@ unsigned int kstat_irqs(unsigned int irq)
 	if (!desc || !desc->kstat_irqs)
 		return 0;
 	if (!irq_settings_is_per_cpu_devid(desc) &&
-	    !irq_settings_is_per_cpu(desc))
+	    !irq_settings_is_per_cpu(desc) &&
+	    !irq_is_nmi(desc))
 	    return desc->tot_count;
 
 	for_each_possible_cpu(cpu)
-- 
2.20.1

