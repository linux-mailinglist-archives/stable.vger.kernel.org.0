Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1B49C12B
	for <lists+stable@lfdr.de>; Sun, 25 Aug 2019 02:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbfHYAyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 20:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbfHYAyz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Aug 2019 20:54:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7F3A2190F;
        Sun, 25 Aug 2019 00:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566694494;
        bh=YpmFU5fs/NJMrrrVE0ZhpttDS0wDvYzWyG+8KwPKHfM=;
        h=Date:From:To:Subject:From;
        b=VrpFC1Saajfsx9VLQwtvXAPYy7hXdVbLfCrBXyb4Wm4IwKNAet80OW8STG8HkbGcU
         Ys2WyzPJg/SLAeXcwZdtRgjbuCxmRaNTHYhqmelHe33dSrdlxW8tF31mhLBWssL+Iz
         UHP4cbGrg4r+RMlWxnvY3HN+CbP6lCvnjv0HQg8I=
Date:   Sat, 24 Aug 2019 17:54:53 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, caspar@linux.alibaba.com,
        hannes@cmpxchg.org, joseph.qi@linux.alibaba.com,
        kerneljasonxing@linux.alibaba.com, linux-mm@kvack.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org,
        stable@vger.kernel.org, surenb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 06/11] psi: get poll_work to run when calling poll
 syscall next time
Message-ID: <20190825005453.mWr0lsMZh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
