Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7652A6B6C
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 18:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgKDRKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 12:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727363AbgKDRKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 12:10:15 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBD3C0613D3;
        Wed,  4 Nov 2020 09:10:15 -0800 (PST)
Date:   Wed, 04 Nov 2020 17:10:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604509813;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C4AvBpvQsHocr6abfyMEyOETK85Sp502ytUC6eeH14Q=;
        b=OFlZdAGYdQu0eyALzhnv1Cf3lntyGdmyMq9RjHuZOzjmCXocYdYgjlHzwW4SD/Ixkd2pBu
        X1dh2BKApPiOKIITRRDltkvQQiSANj4G0tIQHhuw5/MukdlJ2uoCwACGQgZY61feNWLRJD
        qD8FzYIrXmou1VT3Tf6X8aTnYXFzeK/mQgCv+WhIhGlD6C1l3tdGFYZbWhpj9r6Ql68DMf
        umZbFBnA3jhs5B1TJdoAuCtYadorwaR3Dt2iFnuwhFBbNOAYMdQWj5lobQOrvXb1/obnJ8
        K2pXVA3oPLoUKt+GXJMpPUTFLf6/dDEihvnHIwJMbtJeY+WlGfZg0tqks6anfQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604509813;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C4AvBpvQsHocr6abfyMEyOETK85Sp502ytUC6eeH14Q=;
        b=QOklWbvP2iWBzh9K83QnFoKVTc2oNZd6NNggTLFR7Lx4Fh6UUZIoLTyiF3YjYeZG/7b5z9
        vurcHEYXB3ZmZxAA==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: core/urgent] entry: Fix the incorrect ordering of lockdep and RCU check
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87y2jhl19s.fsf@nanos.tec.linutronix.de>
References: <87y2jhl19s.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <160450981252.397.3004160214016071021.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the core/urgent branch of tip:

Commit-ID:     9d820f68b2bdba5b2e7bf135123c3f57c5051d05
Gitweb:        https://git.kernel.org/tip/9d820f68b2bdba5b2e7bf135123c3f57c5051d05
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Wed, 04 Nov 2020 14:06:23 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 04 Nov 2020 18:06:14 +01:00

entry: Fix the incorrect ordering of lockdep and RCU check

When an exception/interrupt hits kernel space and the kernel is not
currently in the idle task then RCU must be watching.

irqentry_enter() validates this via rcu_irq_enter_check_tick(), which in
turn invokes lockdep when taking a lock. But at that point lockdep does not
yet know about the fact that interrupts have been disabled by the CPU,
which triggers a lockdep splat complaining about inconsistent state.

Invoking trace_hardirqs_off() before rcu_irq_enter_check_tick() defeats the
point of rcu_irq_enter_check_tick() because trace_hardirqs_off() uses RCU.

So use the same sequence as for the idle case and tell lockdep about the
irq state change first, invoke the RCU check and then do the lockdep and
tracer update.

Fixes: a5497bab5f72 ("entry: Provide generic interrupt entry/exit code")
Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87y2jhl19s.fsf@nanos.tec.linutronix.de

---
 kernel/entry/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index 2b83666..e9e2df3 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -337,10 +337,10 @@ noinstr irqentry_state_t irqentry_enter(struct pt_regs *regs)
 	 * already contains a warning when RCU is not watching, so no point
 	 * in having another one here.
 	 */
+	lockdep_hardirqs_off(CALLER_ADDR0);
 	instrumentation_begin();
 	rcu_irq_enter_check_tick();
-	/* Use the combo lockdep/tracing function */
-	trace_hardirqs_off();
+	trace_hardirqs_off_finish();
 	instrumentation_end();
 
 	return ret;
