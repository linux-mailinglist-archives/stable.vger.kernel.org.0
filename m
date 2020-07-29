Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D1523207F
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 16:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgG2Ody (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 10:33:54 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43178 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbgG2Odx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jul 2020 10:33:53 -0400
Date:   Wed, 29 Jul 2020 14:33:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596033231;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=COUuUxl24BIY1YJMew8yKejsblD7TbzIN2or9F3NwOY=;
        b=AsfZqcFNo6rXWFWzMj0FfaEXpYa41v0kTZ0PpF24kFn7TVNrB+1gjx2qljV6lAGZGRhGsq
        MWlPQqLZBaoihjYLL5THCHa8wquImt0UfP/BAFlh+I80iGVEyONiySjI6fRTnVd0DtJrQ6
        YmqJtMyR/+nWoSqXuv/Uw2OJ6GiUe3IgDmGxq5Mzm1dZlR9k5Lgj8i3sji41cNqzHn8LWU
        d3V8wnziO8U1y2K1IYH6NH7/oonWH9kiw02Ve6czizaxyCe0+tRBhOiuJW8xtHZhodFgpu
        hPqlC7yM1nstIs3ztUBZQFy5MSXy98DTRWXtrxuH1i/CR9wKvXf4xIXZKeE+BA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596033231;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=COUuUxl24BIY1YJMew8yKejsblD7TbzIN2or9F3NwOY=;
        b=yGSpx2EIWqf29hFflRP/KXdHapWsMb+ynugCh9oyGCVibxKUvKNt33pkMgPKZIN7b8EijI
        31wJhzdIab62BABQ==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/i8259: Use printk_deferred() to prevent deadlock
Cc:     kernel test robot <lkp@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87365abt2v.fsf@nanos.tec.linutronix.de>
References: <87365abt2v.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <159603323059.4006.16549997854103286756.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     bdd65589593edd79b6a12ce86b3b7a7c6dae5208
Gitweb:        https://git.kernel.org/tip/bdd65589593edd79b6a12ce86b3b7a7c6dae5208
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Wed, 29 Jul 2020 10:53:28 +02:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Wed, 29 Jul 2020 16:27:16 +02:00

x86/i8259: Use printk_deferred() to prevent deadlock

0day reported a possible circular locking dependency:

Chain exists of:
  &irq_desc_lock_class --> console_owner --> &port_lock_key

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&port_lock_key);
                               lock(console_owner);
                               lock(&port_lock_key);
  lock(&irq_desc_lock_class);

The reason for this is a printk() in the i8259 interrupt chip driver
which is invoked with the irq descriptor lock held, which reverses the
lock operations vs. printk() from arbitrary contexts.

Switch the printk() to printk_deferred() to avoid that.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87365abt2v.fsf@nanos.tec.linutronix.de
---
 arch/x86/kernel/i8259.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index f3c7625..282b4ee 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -207,7 +207,7 @@ spurious_8259A_irq:
 		 * lets ACK and report it. [once per IRQ]
 		 */
 		if (!(spurious_irq_mask & irqmask)) {
-			printk(KERN_DEBUG
+			printk_deferred(KERN_DEBUG
 			       "spurious 8259A interrupt: IRQ%d.\n", irq);
 			spurious_irq_mask |= irqmask;
 		}
