Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5E518B5E
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 16:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfEIONt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 10:13:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46942 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726694AbfEIONL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 10:13:11 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOjnI-000129-Lt; Thu, 09 May 2019 15:13:08 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOjnI-0006MP-FI; Thu, 09 May 2019 15:13:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Tom Gundersen" <teg@jklm.no>, "Jann Horn" <jannh@google.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "David Herrmann" <dh.herrmann@gmail.com>
Date:   Thu, 09 May 2019 15:08:17 +0100
Message-ID: <lsq.1557410897.703932534@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 08/10] fork: record start_time late
In-Reply-To: <lsq.1557410896.171359878@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.67-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Herrmann <dh.herrmann@gmail.com>

commit 7b55851367136b1efd84d98fea81ba57a98304cf upstream.

This changes the fork(2) syscall to record the process start_time after
initializing the basic task structure but still before making the new
process visible to user-space.

Technically, we could record the start_time anytime during fork(2).  But
this might lead to scenarios where a start_time is recorded long before
a process becomes visible to user-space.  For instance, with
userfaultfd(2) and TLS, user-space can delay the execution of fork(2)
for an indefinite amount of time (and will, if this causes network
access, or similar).

By recording the start_time late, it much closer reflects the point in
time where the process becomes live and can be observed by other
processes.

Lastly, this makes it much harder for user-space to predict and control
the start_time they get assigned.  Previously, user-space could fork a
process and stall it in copy_thread_tls() before its pid is allocated,
but after its start_time is recorded.  This can be misused to later-on
cycle through PIDs and resume the stalled fork(2) yielding a process
that has the same pid and start_time as a process that existed before.
This can be used to circumvent security systems that identify processes
by their pid+start_time combination.

Even though user-space was always aware that start_time recording is
flaky (but several projects are known to still rely on start_time-based
identification), changing the start_time to be recorded late will help
mitigate existing attacks and make it much harder for user-space to
control the start_time a process gets assigned.

Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.16: start_time initialisation code is different]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/fork.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1265,9 +1265,6 @@ static struct task_struct *copy_process(
 
 	posix_cpu_timers_init(p);
 
-	do_posix_clock_monotonic_gettime(&p->start_time);
-	p->real_start_time = p->start_time;
-	monotonic_to_bootbased(&p->real_start_time);
 	p->io_context = NULL;
 	p->audit_context = NULL;
 	if (clone_flags & CLONE_THREAD)
@@ -1423,6 +1420,18 @@ static struct task_struct *copy_process(
 	p->task_works = NULL;
 
 	/*
+	 * From this point on we must avoid any synchronous user-space
+	 * communication until we take the tasklist-lock. In particular, we do
+	 * not want user-space to be able to predict the process start-time by
+	 * stalling fork(2) after we recorded the start_time but before it is
+	 * visible to the system.
+	 */
+
+	do_posix_clock_monotonic_gettime(&p->start_time);
+	p->real_start_time = p->start_time;
+	monotonic_to_bootbased(&p->real_start_time);
+
+	/*
 	 * Make it visible to the rest of the system, but dont wake it up yet.
 	 * Need tasklist lock for parent etc handling!
 	 */

