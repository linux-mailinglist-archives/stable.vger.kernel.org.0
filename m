Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C04355137
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 12:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhDFKve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 06:51:34 -0400
Received: from foss.arm.com ([217.140.110.172]:40688 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231156AbhDFKvd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 06:51:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4F9531B;
        Tue,  6 Apr 2021 03:51:25 -0700 (PDT)
Received: from e125770.cambridge.arm.com (e125770.cambridge.arm.com [10.1.197.16])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D44A3F73D;
        Tue,  6 Apr 2021 03:51:24 -0700 (PDT)
From:   Luca Fancellu <luca.fancellu@arm.com>
To:     sstabellini@kernel.org, jgross@suse.com, jgrall@amazon.com
Cc:     boris.ostrovsky@oracle.com, tglx@linutronix.de, wei.liu@kernel.org,
        jbeulich@suse.com, yyankovskyi@gmail.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, bertrand.marquis@arm.com
Subject: [PATCH] xen/evtchn: Change irq_info lock to raw_spinlock_t
Date:   Tue,  6 Apr 2021 11:51:04 +0100
Message-Id: <20210406105105.10141-1-luca.fancellu@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Unmask operation must be called with interrupt disabled,
on preempt_rt spin_lock_irqsave/spin_unlock_irqrestore
don't disable/enable interrupts, so use raw_* implementation
and change lock variable in struct irq_info from spinlock_t
to raw_spinlock_t

Cc: stable@vger.kernel.org
Fixes: 25da4618af24 ("xen/events: don't unmask an event channel
when an eoi is pending")

Signed-off-by: Luca Fancellu <luca.fancellu@arm.com>
---
 drivers/xen/events/events_base.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 8236e2364eeb..7bbfd58958bc 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -110,7 +110,7 @@ struct irq_info {
 	unsigned short eoi_cpu; /* EOI must happen on this cpu-1 */
 	unsigned int irq_epoch; /* If eoi_cpu valid: irq_epoch of event */
 	u64 eoi_time;           /* Time in jiffies when to EOI. */
-	spinlock_t lock;
+	raw_spinlock_t lock;
 
 	union {
 		unsigned short virq;
@@ -312,7 +312,7 @@ static int xen_irq_info_common_setup(struct irq_info *info,
 	info->evtchn = evtchn;
 	info->cpu = cpu;
 	info->mask_reason = EVT_MASK_REASON_EXPLICIT;
-	spin_lock_init(&info->lock);
+	raw_spin_lock_init(&info->lock);
 
 	ret = set_evtchn_to_irq(evtchn, irq);
 	if (ret < 0)
@@ -472,28 +472,28 @@ static void do_mask(struct irq_info *info, u8 reason)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&info->lock, flags);
+	raw_spin_lock_irqsave(&info->lock, flags);
 
 	if (!info->mask_reason)
 		mask_evtchn(info->evtchn);
 
 	info->mask_reason |= reason;
 
-	spin_unlock_irqrestore(&info->lock, flags);
+	raw_spin_unlock_irqrestore(&info->lock, flags);
 }
 
 static void do_unmask(struct irq_info *info, u8 reason)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&info->lock, flags);
+	raw_spin_lock_irqsave(&info->lock, flags);
 
 	info->mask_reason &= ~reason;
 
 	if (!info->mask_reason)
 		unmask_evtchn(info->evtchn);
 
-	spin_unlock_irqrestore(&info->lock, flags);
+	raw_spin_unlock_irqrestore(&info->lock, flags);
 }
 
 #ifdef CONFIG_X86
-- 
2.17.1

