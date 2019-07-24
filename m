Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36D4973EF8
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388401AbfGXTd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388382AbfGXTdw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:33:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F761229F4;
        Wed, 24 Jul 2019 19:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996832;
        bh=cOw+J+1RVaTrWSrl4Y1WW/S9Q5B6zKEYVYIdDeOurZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMey0TyIMZYBNhqpQpg3QJzkUl8rxVsREiObr1yh5bo9Tz8k/JQW9uwmMVZbozr7T
         7xh/gMsATkDxgcAjeyV9cTUUzcUjiCDwKJ7SRHTlYilnpSu7UKsfsaR7DusCQIzwog
         scNDQ9VQBBWCCzefm5XwGn9BpaHoePq/GI0lwiQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shijith Thotton <sthotton@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 232/413] genirq: Update irq stats from NMI handlers
Date:   Wed, 24 Jul 2019 21:18:43 +0200
Message-Id: <20190724191751.697842633@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 3ff4a1260885..b76703b2c0af 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -754,6 +754,8 @@ void handle_fasteoi_nmi(struct irq_desc *desc)
 	unsigned int irq = irq_desc_get_irq(desc);
 	irqreturn_t res;
 
+	__kstat_incr_irqs_this_cpu(desc);
+
 	trace_irq_handler_entry(irq, action);
 	/*
 	 * NMIs cannot be shared, there is only one action.
@@ -968,6 +970,8 @@ void handle_percpu_devid_fasteoi_nmi(struct irq_desc *desc)
 	unsigned int irq = irq_desc_get_irq(desc);
 	irqreturn_t res;
 
+	__kstat_incr_irqs_this_cpu(desc);
+
 	trace_irq_handler_entry(irq, action);
 	res = action->handler(irq, raw_cpu_ptr(action->percpu_dev_id));
 	trace_irq_handler_exit(irq, action, res);
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index c52b737ab8e3..9149dde5a7b0 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -946,6 +946,11 @@ unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
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
@@ -963,7 +968,8 @@ unsigned int kstat_irqs(unsigned int irq)
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



