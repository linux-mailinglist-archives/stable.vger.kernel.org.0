Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86DAF9D859
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 23:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbfHZVbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 17:31:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728595AbfHZVbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 17:31:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A90D822CBB;
        Mon, 26 Aug 2019 21:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566855103;
        bh=NhKsK5SsbS3K8but2gipb7XQMydNj5o7FqhuC/5+lPk=;
        h=Date:From:To:Subject:From;
        b=jrV5IrfFhh34eI4mrOQnuwyFWlIJpk5jBkNHO2s36m1AfaNE+zAatb1G+o81D/SGH
         lwQVrZt5EavT0PVFVlsMHiuDmTMMSochoPSdNZ4gZs9Uzo5I4QaO70xGZ3tCoWAM7F
         yMhJzYBCmHLr8Kn3vm2ofizXHpzfttLQKRzYq6ow=
Date:   Mon, 26 Aug 2019 14:31:42 -0700
From:   akpm@linux-foundation.org
To:     caspar@linux.alibaba.com, hannes@cmpxchg.org,
        joseph.qi@linux.alibaba.com, kerneljasonxing@linux.alibaba.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org,
        stable@vger.kernel.org, surenb@google.com
Subject:  [merged]
 psi-get-poll_work-to-run-when-calling-poll-syscall-next-time.patch removed
 from -mm tree
Message-ID: <20190826213142.KLvu6I_uT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: psi: get poll_work to run when calling poll syscall next time
has been removed from the -mm tree.  Its filename was
     psi-get-poll_work-to-run-when-calling-poll-syscall-next-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Xing <kerneljasonxing@linux.alibaba.com>
Subject: psi: get poll_work to run when calling poll syscall next time

Only when calling the poll syscall the first time can user receive POLLPRI
correctly.  After that, user always fails to acquire the event signal.

Reproduce case:
1. Get the monitor code in Documentation/accounting/psi.txt
2. Run it, and wait for the event triggered.
3. Kill and restart the process.

The question is why we can end up with poll_scheduled = 1 but the work not
running (which would reset it to 0).  And the answer is because the
scheduling side sees group->poll_kworker under RCU protection and then
schedules it, but here we cancel the work and destroy the worker.  The
cancel needs to pair with resetting the poll_scheduled flag.

Link: http://lkml.kernel.org/r/1566357985-97781-1-git-send-email-joseph.qi@linux.alibaba.com
Signed-off-by: Jason Xing <kerneljasonxing@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Caspar Zhang <caspar@linux.alibaba.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/psi.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/sched/psi.c~psi-get-poll_work-to-run-when-calling-poll-syscall-next-time
+++ a/kernel/sched/psi.c
@@ -1131,7 +1131,15 @@ static void psi_trigger_destroy(struct k
 	 * deadlock while waiting for psi_poll_work to acquire trigger_lock
 	 */
 	if (kworker_to_destroy) {
+		/*
+		 * After the RCU grace period has expired, the worker
+		 * can no longer be found through group->poll_kworker.
+		 * But it might have been already scheduled before
+		 * that - deschedule it cleanly before destroying it.
+		 */
 		kthread_cancel_delayed_work_sync(&group->poll_work);
+		atomic_set(&group->poll_scheduled, 0);
+
 		kthread_destroy_worker(kworker_to_destroy);
 	}
 	kfree(t);
_

Patches currently in -mm which might be from kerneljasonxing@linux.alibaba.com are


