Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD7688D78
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfHJUqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:46:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55362 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726911AbfHJUoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:07 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDd-00053m-42; Sat, 10 Aug 2019 21:44:05 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-0003cb-PJ; Sat, 10 Aug 2019 21:43:46 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Valentin Schneider" <valentin.schneider@arm.com>,
        "Mike Galbraith" <efault@gmx.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Mel Gorman" <mgorman@techsingularity.net>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.727370332@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 064/157] sched/fair: Do not re-read ->h_load_next
 during hierarchical load calculation
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@techsingularity.net>

commit 0e9f02450da07fc7b1346c8c32c771555173e397 upstream.

A NULL pointer dereference bug was reported on a distribution kernel but
the same issue should be present on mainline kernel. It occured on s390
but should not be arch-specific.  A partial oops looks like:

  Unable to handle kernel pointer dereference in virtual kernel address space
  ...
  Call Trace:
    ...
    try_to_wake_up+0xfc/0x450
    vhost_poll_wakeup+0x3a/0x50 [vhost]
    __wake_up_common+0xbc/0x178
    __wake_up_common_lock+0x9e/0x160
    __wake_up_sync_key+0x4e/0x60
    sock_def_readable+0x5e/0x98

The bug hits any time between 1 hour to 3 days. The dereference occurs
in update_cfs_rq_h_load when accumulating h_load. The problem is that
cfq_rq->h_load_next is not protected by any locking and can be updated
by parallel calls to task_h_load. Depending on the compiler, code may be
generated that re-reads cfq_rq->h_load_next after the check for NULL and
then oops when reading se->avg.load_avg. The dissassembly showed that it
was possible to reread h_load_next after the check for NULL.

While this does not appear to be an issue for later compilers, it's still
an accident if the correct code is generated. Full locking in this path
would have high overhead so this patch uses READ_ONCE to read h_load_next
only once and check for NULL before dereferencing. It was confirmed that
there were no further oops after 10 days of testing.

As Peter pointed out, it is also necessary to use WRITE_ONCE() to avoid any
potential problems with store tearing.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 685207963be9 ("sched: Move h_load calculation to task_h_load()")
Link: https://lkml.kernel.org/r/20190319123610.nsivgf3mjbjjesxb@techsingularity.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16: use ACCESS_ONCE()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sched/fair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5487,10 +5487,10 @@ static void update_cfs_rq_h_load(struct
 	if (cfs_rq->last_h_load_update == now)
 		return;
 
-	cfs_rq->h_load_next = NULL;
+	ACCESS_ONCE(cfs_rq->h_load_next) = NULL;
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
-		cfs_rq->h_load_next = se;
+		ACCESS_ONCE(cfs_rq->h_load_next) = se;
 		if (cfs_rq->last_h_load_update == now)
 			break;
 	}
@@ -5500,7 +5500,7 @@ static void update_cfs_rq_h_load(struct
 		cfs_rq->last_h_load_update = now;
 	}
 
-	while ((se = cfs_rq->h_load_next) != NULL) {
+	while ((se = ACCESS_ONCE(cfs_rq->h_load_next)) != NULL) {
 		load = cfs_rq->h_load;
 		load = div64_ul(load * se->avg.load_avg_contrib,
 				cfs_rq->runnable_load_avg + 1);

