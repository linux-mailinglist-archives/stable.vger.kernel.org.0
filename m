Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CCE35BDA3
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238607AbhDLIwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238794AbhDLIut (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:50:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48DD061019;
        Mon, 12 Apr 2021 08:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217431;
        bh=bs6zqPTMkrvoNg910H6N+vc6hFdTmrBJ1bBAqvZ+AeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1B7axGtf2AEE98m9Lf1t1XrPT3JSOKfwrvNCqyK/J/Bx9COnlcemFUqs1MR5iUCk
         fJiGBmcQ+rF4BZ8+W5rpcamDckc0S6qHxNW1UQsuupDu2ue+zvkJ7MHeg276Sa3sPj
         fuse0guIEMwD5cgx4F/bjMHKoziqiULY1HM6HOfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Fancellu <luca.fancellu@arm.com>,
        Julien Grall <jgrall@amazon.com>, Wei Liu <wei.liu@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 5.10 013/188] xen/evtchn: Change irq_info lock to raw_spinlock_t
Date:   Mon, 12 Apr 2021 10:38:47 +0200
Message-Id: <20210412084014.100323512@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
@@ -108,7 +108,7 @@ struct irq_info {
 	unsigned short eoi_cpu; /* EOI must happen on this cpu-1 */
 	unsigned int irq_epoch; /* If eoi_cpu valid: irq_epoch of event */
 	u64 eoi_time;           /* Time in jiffies when to EOI. */
-	spinlock_t lock;
+	raw_spinlock_t lock;
 
 	union {
 		unsigned short virq;
@@ -280,7 +280,7 @@ static int xen_irq_info_common_setup(str
 	info->evtchn = evtchn;
 	info->cpu = cpu;
 	info->mask_reason = EVT_MASK_REASON_EXPLICIT;
-	spin_lock_init(&info->lock);
+	raw_spin_lock_init(&info->lock);
 
 	ret = set_evtchn_to_irq(evtchn, irq);
 	if (ret < 0)
@@ -432,28 +432,28 @@ static void do_mask(struct irq_info *inf
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


