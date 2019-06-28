Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 721EF5A4C3
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 21:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfF1TGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 15:06:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbfF1TGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 15:06:41 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73DC220828;
        Fri, 28 Jun 2019 19:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561748800;
        bh=OJBbFXxsapHmqXnNPYWLphBT6YHjmM6QXxeqdERoVjg=;
        h=Date:From:To:Subject:From;
        b=ihY1uffN2B3Z3Japf1SQ8ErA0cGJS8iqZb4m3oJ+0ox2+AZ72gPQ27Jyp1XVpGN30
         NnxJ3Bffo7TjhfH2AUV8fVnK6m1qkNScDh2N5oPqRbY67WvT+PQ8xhuzlZ66giYGoo
         xStmkczojYUJDrAxj8Kk6e1Ftsiu8UbaXdr0kiI0=
Date:   Fri, 28 Jun 2019 12:06:40 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, akpm@linux-foundation.org, jlu@pengutronix.de,
        john.ogness@linutronix.de, luto@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 02/15] fs/proc/array.c: allow reporting eip/esp
 for all coredumping threads
Message-ID: <20190628190640.PuAK-SGHn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
