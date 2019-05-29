Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5A02E7B6
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 23:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfE2Vz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 17:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbfE2Vz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 17:55:28 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0FA42424E;
        Wed, 29 May 2019 21:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559166927;
        bh=fdneiKOZnULccpcFdKgeHbXdd4KEOHpKScKB5sS8mgo=;
        h=Date:From:To:Subject:From;
        b=IdHv0T95vLCmkmzuQv/9Kc4Zlps/ztVE4gi1BW+OwPvgtA7RTeZSYuvi8mgYBzYnO
         hooMi/S0Jkx3hTTD+aUgng0VHXDUYeu82e4x31VF3WWSaHR3p3sS4UQIiQCXYqfCRg
         LC5wAPZ8EFzEsoDedkyMjlix1MLlmsrodfKyiLU0=
Date:   Wed, 29 May 2019 14:55:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        luto@kernel.org, jlu@pengutronix.de, adobriyan@gmail.com,
        john.ogness@linutronix.de
Subject:  +
 fs-proc-allow-reporting-eip-esp-for-all-coredumping-threads.patch added to
 -mm tree
Message-ID: <20190529215527.9PxGs%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs/proc/array.c: allow reporting eip/esp for all coredumping threads
has been added to the -mm tree.  Its filename is
     fs-proc-allow-reporting-eip-esp-for-all-coredumping-threads.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-allow-reporting-eip-esp-for-all-coredumping-threads.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-allow-reporting-eip-esp-for-all-coredumping-threads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Ogness <john.ogness@linutronix.de>
Subject: fs/proc/array.c: allow reporting eip/esp for all coredumping threads

0a1eb2d474ed ("fs/proc: Stop reporting eip and esp in /proc/PID/stat")
stopped reporting eip/esp and fd7d56270b52 ("fs/proc: Report eip/esp in
/prod/PID/stat for coredumping") reintroduced the feature to fix a
regression with userspace core dump handlers (such as minicoredumper).

Because PF_DUMPCORE is only set for the primary thread, this didn't fix
the original problem for secondary threads.  Allow reporting the eip/esp
for all threads by checking for PF_EXITING as well.  This is set for all
the other threads when they are killed.  coredump_wait() waits for all the
tasks to become inactive before proceeding to invoke the core the core
dumper.

Link: http://lkml.kernel.org/r/87y32p7i7a.fsf@linutronix.de
Link: http://lkml.kernel.org/r/20190522161614.628-1-jlu@pengutronix.de
Fixes: fd7d56270b526ca3 ("fs/proc: Report eip/esp in /prod/PID/stat for coredumping")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reported-by: Jan Luebbe <jlu@pengutronix.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/array.c~fs-proc-allow-reporting-eip-esp-for-all-coredumping-threads
+++ a/fs/proc/array.c
@@ -462,7 +462,7 @@ static int do_task_stat(struct seq_file
 		 * a program is not able to use ptrace(2) in that case. It is
 		 * safe because the task has stopped executing permanently.
 		 */
-		if (permitted && (task->flags & PF_DUMPCORE)) {
+		if (permitted && (task->flags & (PF_EXITING|PF_DUMPCORE))) {
 			if (try_get_task_stack(task)) {
 				eip = KSTK_EIP(task);
 				esp = KSTK_ESP(task);
_

Patches currently in -mm which might be from john.ogness@linutronix.de are

fs-proc-allow-reporting-eip-esp-for-all-coredumping-threads.patch

