Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4B735BF3D
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbhDLJDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239889AbhDLJBa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD9DA6135F;
        Mon, 12 Apr 2021 08:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217993;
        bh=JL9fUh2zWV1/Zx8exjNFW2cp7HUKmXACOgrT/Aksdxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnIXiNHTbuVzP9dUHkUkjgQ21qegFfldekHrawhKZai+fAvXjqpR/zW9YEj0+VaDk
         iWAvvUFj01zHT0FIEzuIPeK/PutG/+1ksqrega0UJ+CzPq89oYmcBlH3j8GQ/VkzPo
         oJsPLm6XMph6JNiBc1SDXXH6ZAOekUfHZIaM+ezk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Fancellu <luca.fancellu@arm.com>,
        Julien Grall <jgrall@amazon.com>, Wei Liu <wei.liu@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 5.11 014/210] xen/evtchn: Change irq_info lock to raw_spinlock_t
Date:   Mon, 12 Apr 2021 10:38:39 +0200
Message-Id: <20210412084016.480231903@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Fancellu <luca.fancellu@arm.com>

commit d120198bd5ff1d41808b6914e1eb89aff937415c upstream.

Unmask operation must be called with interrupt disabled,
on preempt_rt spin_lock_irqsave/spin_unlock_irqrestore
don't disable/enable interrupts, so use raw_* implementation
and change lock variable in struct irq_info from spinlock_t
to raw_spinlock_t

Cc: stable@vger.kernel.org
Fixes: 25da4618af24 ("xen/events: don't unmask an event channel when an eoi is pending")
Signed-off-by: Luca Fancellu <luca.fancellu@arm.com>
Reviewed-by: Julien Grall <jgrall@amazon.com>
Reviewed-by: Wei Liu <wei.liu@kernel.org>
Link: https://lore.kernel.org/r/20210406105105.10141-1-luca.fancellu@arm.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/events/events_base.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -109,7 +109,7 @@ struct irq_info {
 	unsigned short eoi_cpu; /* EOI must happen on this cpu-1 */
 	unsigned int irq_epoch; /* If eoi_cpu valid: irq_epoch of event */
 	u64 eoi_time;           /* Time in jiffies when to EOI. */
-	spinlock_t lock;
+	raw_spinlock_t lock;
 
 	union {
 		unsigned short virq;
@@ -310,7 +310,7 @@ static int xen_irq_info_common_setup(str
 	info->evtchn = evtchn;
 	info->cpu = cpu;
 	info->mask_reason = EVT_MASK_REASON_EXPLICIT;
-	spin_lock_init(&info->lock);
+	raw_spin_lock_init(&info->lock);
 
 	ret = set_evtchn_to_irq(evtchn, irq);
 	if (ret < 0)
@@ -463,28 +463,28 @@ static void do_mask(struct irq_info *inf
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


