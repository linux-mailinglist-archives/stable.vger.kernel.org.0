Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4572ABAE0
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387955AbgKINUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387976AbgKINUq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:20:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC5B2206D8;
        Mon,  9 Nov 2020 13:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928045;
        bh=BwQ6VG+gjhfz0EqD6NV1hgsz137g69CXNnH/vrOTCFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/tIGRzaKjsubk45Vl3at9pWXn7x1aSMNx7xN78sAwGjwExFK8R9sGMtIxOYD0MFx
         0B/A24L0/yg/wZOFbmygPGhIFmD3TZng47qU8LglsBOGfJEzT/vjfVkL6S+Qa1iIaQ
         fXjdGXf+zSuUUUMS8bhEc0EHbNXGu7mIVLvAWVOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.9 109/133] entry: Fix the incorrect ordering of lockdep and RCU check
Date:   Mon,  9 Nov 2020 13:56:11 +0100
Message-Id: <20201109125035.932625125@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 9d820f68b2bdba5b2e7bf135123c3f57c5051d05 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/entry/common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -338,10 +338,10 @@ noinstr irqentry_state_t irqentry_enter(
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


