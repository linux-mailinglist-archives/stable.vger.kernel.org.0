Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E041322C750
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 16:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgGXOHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 10:07:45 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38424 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgGXOHp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jul 2020 10:07:45 -0400
Date:   Fri, 24 Jul 2020 14:07:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595599662;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=opVcxPUv963ARJfix0eZv2oOhV48P3svftrMOGDWqj8=;
        b=Kxppuj5TTDpiFKF4ZHBMFJpK6Pht52wYRbKRufDNKLNiwZ7r9X09Hy2Nms2jmnG4UilrIw
        MJq8Vwyv7Ojf06h0fhaySfRJYKs7SPe5ahjvaqKIZ4VpBYPKoPBtv7Gek09iWraa81TX5E
        AEBpJnOfGjJ6tqBf+p4jPQLKdhgOJSeJ3kk4BUOIMF6rGX94Z3R3RN0xvzBUDh+IKnBoBh
        bFsE7zr8Zq7cxfCDJK3TT2lIqlVlk+XhiMvJREADmkoAMgMGTRwMx0gMpHXSUdVWwIhnqe
        997+gLSNXBuHS6CW5clMJg+Czq7SoXhvBwAV8jVovMxnNI3PTEiP0hkeQ0mThQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595599662;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=opVcxPUv963ARJfix0eZv2oOhV48P3svftrMOGDWqj8=;
        b=CiLn/DBxHVCGgEFJq5bIqH0ItFramz0pFzYOWslczfSpDaiSliGK2AXrZkvbex8SFDUs22
        7urxxbNSkRLvSwDw==
From:   "tip-bot2 for Oleg Nesterov" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] uprobes: Change handle_swbp() to send SIGTRAP with
 si_code=SI_KERNEL, to fix GDB regression
Cc:     Aaron Merey <amerey@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200723154420.GA32043@redhat.com>
References: <20200723154420.GA32043@redhat.com>
MIME-Version: 1.0
Message-ID: <159559966135.4006.10705285395851102706.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     fe5ed7ab99c656bd2f5b79b49df0e9ebf2cead8a
Gitweb:        https://git.kernel.org/tip/fe5ed7ab99c656bd2f5b79b49df0e9ebf2cead8a
Author:        Oleg Nesterov <oleg@redhat.com>
AuthorDate:    Thu, 23 Jul 2020 17:44:20 +02:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Fri, 24 Jul 2020 15:38:37 +02:00

uprobes: Change handle_swbp() to send SIGTRAP with si_code=SI_KERNEL, to fix GDB regression

If a tracee is uprobed and it hits int3 inserted by debugger, handle_swbp()
does send_sig(SIGTRAP, current, 0) which means si_code == SI_USER. This used
to work when this code was written, but then GDB started to validate si_code
and now it simply can't use breakpoints if the tracee has an active uprobe:

	# cat test.c
	void unused_func(void)
	{
	}
	int main(void)
	{
		return 0;
	}

	# gcc -g test.c -o test
	# perf probe -x ./test -a unused_func
	# perf record -e probe_test:unused_func gdb ./test -ex run
	GNU gdb (GDB) 10.0.50.20200714-git
	...
	Program received signal SIGTRAP, Trace/breakpoint trap.
	0x00007ffff7ddf909 in dl_main () from /lib64/ld-linux-x86-64.so.2
	(gdb)

The tracee hits the internal breakpoint inserted by GDB to monitor shared
library events but GDB misinterprets this SIGTRAP and reports a signal.

Change handle_swbp() to use force_sig(SIGTRAP), this matches do_int3_user()
and fixes the problem.

This is the minimal fix for -stable, arch/x86/kernel/uprobes.c is equally
wrong; it should use send_sigtrap(TRAP_TRACE) instead of send_sig(SIGTRAP),
but this doesn't confuse GDB and needs another x86-specific patch.

Reported-by: Aaron Merey <amerey@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200723154420.GA32043@redhat.com
---
 kernel/events/uprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index bb08628..5f8b0c5 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -2199,7 +2199,7 @@ static void handle_swbp(struct pt_regs *regs)
 	if (!uprobe) {
 		if (is_swbp > 0) {
 			/* No matching uprobe; signal SIGTRAP. */
-			send_sig(SIGTRAP, current, 0);
+			force_sig(SIGTRAP);
 		} else {
 			/*
 			 * Either we raced with uprobe_unregister() or we can't
