Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB8741565E2
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgBHS3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34556 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727937AbgBHS3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:48 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrN-0003hn-Tc; Sat, 08 Feb 2020 18:29:42 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrN-000CXr-GC; Sat, 08 Feb 2020 18:29:41 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Christian Borntraeger" <borntraeger@de.ibm.com>,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>
Date:   Sat, 08 Feb 2020 18:21:27 +0000
Message-ID: <lsq.1581185941.629568389@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 148/148] s390: Fix unmatched preempt_disable() on exit
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

exit_thread_runtime_instr() may return with preemption disabled,
leading to the following lockdep splat:

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:586
in_atomic(): 1, irqs_disabled(): 0, pid: 565, name: kworker/u2:0
no locks held by kworker/u2:0/565.
CPU: 0 PID: 565 Comm: kworker/u2:0 Not tainted 3.16.81-00145-gafe1c874fa44 #1
       00000000025dbbd8 00000000025dbbe8 0000000000000002 0000000000000000 
       00000000025dbc78 00000000025dbbf0 00000000025dbbf0 000000000098c55c 
       0000000000000000 00000000025d05b8 00000000025d1590 0000000000000000 
       0000000000000000 000000000000000c 00000000025dbbd8 0000000000000070 
       00000000009b7220 000000000098c55c 00000000025dbbd8 00000000025dbc20 
Call Trace:
([<000000000098c4ce>] show_trace+0xb6/0xd8)
 [<000000000098c592>] show_stack+0xa2/0xd8
 [<0000000000992c04>] dump_stack+0xc4/0x118
 [<0000000000191e20>] __might_sleep+0x230/0x238
 [<000000000099fbb0>] mutex_lock_nested+0x48/0x3d8
 [<000000000025e33e>] perf_event_exit_task+0x36/0x398
 [<0000000000158536>] do_exit+0x3ae/0xca0
 [<0000000000175826>] ____call_usermodehelper+0x136/0x148
 [<00000000009a550a>] kernel_thread_starter+0x6/0xc
 [<00000000009a5504>] kernel_thread_starter+0x0/0xc

This was fixed by commit 8d9047f8b967 "s390/runtime instrumentation:
simplify task exit handling" upstream, but that won't apply here.

Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/s390/kernel/runtime_instr.c
+++ b/arch/s390/kernel/runtime_instr.c
@@ -53,9 +53,9 @@ void exit_thread_runtime_instr(void)
 {
 	struct task_struct *task = current;
 
-	preempt_disable();
 	if (!task->thread.ri_cb)
 		return;
+	preempt_disable();
 	disable_runtime_instr();
 	kfree(task->thread.ri_cb);
 	task->thread.ri_signum = 0;

