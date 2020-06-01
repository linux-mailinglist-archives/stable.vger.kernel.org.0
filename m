Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B751EAF35
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 21:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgFAS74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbgFAR4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:56:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 102342076B;
        Mon,  1 Jun 2020 17:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034209;
        bh=UZ0b/1dhfSmKu3YbKGmGF2l4TWOhPsCnIdcMrqj1pyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvcClYmUy/FuE067n+bVLmh1TzAqK6mf0HTDCam6kUcOi1nHVTL0HRgxz8rNRqacZ
         hph5Tje4hZibEYU2k0ZB2OshG+FfdQkrCNT4Z2qhQGcOBqQRy/dTh0cL8aRxlEadE9
         Af5nlKj2bi6CTG561BQsEkBjfcfoeTCgVq98s9VU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Song Liu <songliubraving@fb.com>,
        Joerg Roedel <jroedel@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <liu.song.a23@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Mike Travis <mike.travis@hpe.com>,
        Borislav Petkov <bp@alien8.de>,
        Tariq Toukan <tariqt@mellanox.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 41/48] genirq/generic_pending: Do not lose pending affinity update
Date:   Mon,  1 Jun 2020 19:53:51 +0200
Message-Id: <20200601174003.729212520@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit a33a5d2d16cb84bea8d5f5510f3a41aa48b5c467 upstream.

The generic pending interrupt mechanism moves interrupts from the interrupt
handler on the original target CPU to the new destination CPU. This is
required for x86 and ia64 due to the way the interrupt delivery and
acknowledge works if the interrupts are not remapped.

However that update can fail for various reasons. Some of them are valid
reasons to discard the pending update, but the case, when the previous move
has not been fully cleaned up is not a legit reason to fail.

Check the return value of irq_do_set_affinity() for -EBUSY, which indicates
a pending cleanup, and rearm the pending move in the irq dexcriptor so it's
tried again when the next interrupt arrives.

Fixes: 996c591227d9 ("x86/irq: Plug vector cleanup race")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Song Liu <songliubraving@fb.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <liu.song.a23@gmail.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: stable@vger.kernel.org
Cc: Mike Travis <mike.travis@hpe.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tariq Toukan <tariqt@mellanox.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Link: https://lkml.kernel.org/r/20180604162224.386544292@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/migration.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -7,17 +7,18 @@
 void irq_move_masked_irq(struct irq_data *idata)
 {
 	struct irq_desc *desc = irq_data_to_desc(idata);
-	struct irq_chip *chip = desc->irq_data.chip;
+	struct irq_data *data = &desc->irq_data;
+	struct irq_chip *chip = data->chip;
 
-	if (likely(!irqd_is_setaffinity_pending(&desc->irq_data)))
+	if (likely(!irqd_is_setaffinity_pending(data)))
 		return;
 
-	irqd_clr_move_pending(&desc->irq_data);
+	irqd_clr_move_pending(data);
 
 	/*
 	 * Paranoia: cpu-local interrupts shouldn't be calling in here anyway.
 	 */
-	if (irqd_is_per_cpu(&desc->irq_data)) {
+	if (irqd_is_per_cpu(data)) {
 		WARN_ON(1);
 		return;
 	}
@@ -42,9 +43,20 @@ void irq_move_masked_irq(struct irq_data
 	 * For correct operation this depends on the caller
 	 * masking the irqs.
 	 */
-	if (cpumask_any_and(desc->pending_mask, cpu_online_mask) < nr_cpu_ids)
-		irq_do_set_affinity(&desc->irq_data, desc->pending_mask, false);
+	if (cpumask_any_and(desc->pending_mask, cpu_online_mask) < nr_cpu_ids) {
+		int ret;
 
+		ret = irq_do_set_affinity(data, desc->pending_mask, false);
+		/*
+		 * If the there is a cleanup pending in the underlying
+		 * vector management, reschedule the move for the next
+		 * interrupt. Leave desc->pending_mask intact.
+		 */
+		if (ret == -EBUSY) {
+			irqd_set_move_pending(data);
+			return;
+		}
+	}
 	cpumask_clear(desc->pending_mask);
 }
 


