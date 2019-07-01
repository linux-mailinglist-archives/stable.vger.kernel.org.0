Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2895C596
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 00:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfGAWWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 18:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfGAWWq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 18:22:46 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D97A2183F;
        Mon,  1 Jul 2019 22:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562019765;
        bh=O4jxR60nqkk1kIaWeJlGk0ex6fD5pVss+d5o1sJvsGM=;
        h=Date:From:To:Subject:From;
        b=NuTHPFl9OCMCn3/3yA8CFsLVOs6jP11lukTfo7Rnq8DpVFNq1+5qIF8rmFOIqbAxQ
         YwrJ4bpnO6rYKttczSUXc74kjkIDeAsp/U2llwrYEEyEbXug6oI2bZpyfFfixi98K4
         F7JhZIkKcNOKjONfZI7KF8c1WKsAvlvzfcWUHk2s=
Date:   Mon, 01 Jul 2019 15:22:45 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, jlu@pengutronix.de, john.ogness@linutronix.de,
        luto@kernel.org, mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 fs-proc-allow-reporting-eip-esp-for-all-coredumping-threads.patch removed
 from -mm tree
Message-ID: <20190701222245.erojJQ8TM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs/proc/array.c: allow reporting eip/esp for all coredumping threads
has been removed from the -mm tree.  Its filename was
     fs-proc-allow-reporting-eip-esp-for-all-coredumping-threads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
tasks to become inactive before proceeding to invoke a core dumper.

Link: http://lkml.kernel.org/r/87y32p7i7a.fsf@linutronix.de
Link: http://lkml.kernel.org/r/20190522161614.628-1-jlu@pengutronix.de
Fixes: fd7d56270b526ca3 ("fs/proc: Report eip/esp in /prod/PID/stat for coredumping")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reported-by: Jan Luebbe <jlu@pengutronix.de>
Tested-by: Jan Luebbe <jlu@pengutronix.de>
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


