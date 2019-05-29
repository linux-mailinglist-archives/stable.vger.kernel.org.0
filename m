Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F12FC2E7A9
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 23:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfE2Vwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 17:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbfE2Vwp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 17:52:45 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D2702423A;
        Wed, 29 May 2019 21:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559166763;
        bh=WSBRk8GSHPX6RtEC4hXv5PLnhgIBE4wPSX0Up59JeHg=;
        h=Date:From:To:Subject:From;
        b=m6b6YU3OjiZQfs9q7vReq71eMgKj5d3RN876EfU1kd61P8K6UI+QC4gKww3YabXRn
         odbdbeTxi2TlSHW0UCWfZSosGbDT1KQdy9SVSa8RFbh/t6PADzb++OJSCbLuXoL8bm
         9wPXYkj9qAdN5e7XtaVxEVE1tVt5Wk5wAh5nZgd4=
Date:   Wed, 29 May 2019 14:52:43 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        luto@kernel.org, john.ogness@linutronix.de, adobriyan@gmail.com,
        jlu@pengutronix.de
Subject:  [to-be-updated]
 proc-report-eip-and-esp-for-all-threads-when-coredumping.patch removed from
 -mm tree
Message-ID: <20190529215243.MDRh5%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: proc: report eip and esp for all threads when coredumping
has been removed from the -mm tree.  Its filename was
     proc-report-eip-and-esp-for-all-threads-when-coredumping.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jan Luebbe <jlu@pengutronix.de>
Subject: proc: report eip and esp for all threads when coredumping

0a1eb2d474ed ("fs/proc: Stop reporting eip and esp in /proc/PID/stat")
stopped reporting eip/esp and fd7d56270b52 ("fs/proc: Report eip/esp in
/prod/PID/stat for coredumping") reintroduced the feature to fix a
regression with userspace core dump handlers (such as minicoredumper).

Because PF_DUMPCORE is only set for the primary thread, this didn't fix
the original problem for secondary threads.  This commit checks
mm->core_state instead, as already done for /proc/<pid>/status in
task_core_dumping().  As we have a mm_struct available here anyway, this
seems to be a clean solution.

In current mainline, all threads except the main have the
/proc/[pid]/stat fields 'kstkesp' (29, current stack pointer) and
'kstkeip' (30, current instruction pointer) show as 0 even during
coredumping when read by the core dump handler.

minicoredumper for example tries to use this value to find each
thread's stack and tries to dump it, which fails as there is nothing
mapped at 0.  The result is that the thread's stack data is missing
from the generated core dump.

With this patch, kstkesp and kstkeip are visible again to the core dump
handler, so the minified core dump contains all stacks again.  For a
process running normally, the values are still reported as 0 (as
intended).

[akpm@linux-foundation.org: cleanup, per Alexey]
[john.ogness@linutronix.de: close race window]
  Link: http://lkml.kernel.org/r/875zpzif8v.fsf@linutronix.de
Link: http://lkml.kernel.org/r/20190522161614.628-1-jlu@pengutronix.de
Fixes: fd7d56270b526ca3 ("fs/proc: Report eip/esp in /prod/PID/stat for coredumping")
Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c   |    2 +-
 fs/proc/array.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/array.c~proc-report-eip-and-esp-for-all-threads-when-coredumping
+++ a/fs/proc/array.c
@@ -462,7 +462,7 @@ static int do_task_stat(struct seq_file
 		 * a program is not able to use ptrace(2) in that case. It is
 		 * safe because the task has stopped executing permanently.
 		 */
-		if (permitted && (task->flags & PF_DUMPCORE)) {
+		if (permitted && mm->core_state) {
 			if (try_get_task_stack(task)) {
 				eip = KSTK_EIP(task);
 				esp = KSTK_ESP(task);
--- a/fs/coredump.c~proc-report-eip-and-esp-for-all-threads-when-coredumping
+++ a/fs/coredump.c
@@ -340,10 +340,10 @@ static int zap_threads(struct task_struc
 
 	spin_lock_irq(&tsk->sighand->siglock);
 	if (!signal_group_exit(tsk->signal)) {
-		mm->core_state = core_state;
 		tsk->signal->group_exit_task = tsk;
 		nr = zap_process(tsk, exit_code, 0);
 		clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
+		mm->core_state = core_state;
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
 	if (unlikely(nr < 0))
_

Patches currently in -mm which might be from jlu@pengutronix.de are


