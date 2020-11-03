Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9692A4E2F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 19:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgKCSRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 13:17:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:39556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgKCSRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 13:17:13 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 826A22080D;
        Tue,  3 Nov 2020 18:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604427432;
        bh=n5wNWjXf1491Qk/AIDVyyhHom6cYu3MkQPqbgLrwhwA=;
        h=Date:From:To:Subject:From;
        b=ChdmoIFWZGTcsGaBA/SWvHBA/HQZd4a5Y+0+78ZPI++ODKfRBIGIO3ZdzCxYIi24J
         DtkDJM67+YwO4M9Hb5h83C4fcMwztNaxHsRDo0dE1UClAh6fjjVNccMovBMGT3DKhS
         sfX3G7cAnOnijSMP+S/LtaIOTSS5Zm/SGpwXNbYw=
Date:   Tue, 03 Nov 2020 10:17:12 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, pmladek@suse.com,
        qiang.zhang@windriver.com, stable@vger.kernel.org, tj@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?kthread=5Fworker-prevent-queuing-delayed-work-from-time?=
 =?US-ASCII?Q?r=5Ffn-when-it-is-being-canceled.patch?= removed from -mm
 tree
Message-ID: <20201103181712.QU928QUTg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kthread_worker: prevent queuing delayed work from timer_fn when it is being canceled
has been removed from the -mm tree.  Its filename was
     kthread_worker-prevent-queuing-delayed-work-from-timer_fn-when-it-is-being-canceled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zqiang <qiang.zhang@windriver.com>
Subject: kthread_worker: prevent queuing delayed work from timer_fn when it is being canceled

There is a small race window when a delayed work is being canceled and the
work still might be queued from the timer_fn:

	CPU0						CPU1
kthread_cancel_delayed_work_sync()
   __kthread_cancel_work_sync()
     __kthread_cancel_work()
        work->canceling++;
					      kthread_delayed_work_timer_fn()
						   kthread_insert_work();

BUG: kthread_insert_work() should not get called when work->canceling is
set.

Link: https://lkml.kernel.org/r/20201014083030.16895-1-qiang.zhang@windriver.com
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/kthread.c~kthread_worker-prevent-queuing-delayed-work-from-timer_fn-when-it-is-being-canceled
+++ a/kernel/kthread.c
@@ -897,7 +897,8 @@ void kthread_delayed_work_timer_fn(struc
 	/* Move the work from worker->delayed_work_list. */
 	WARN_ON_ONCE(list_empty(&work->node));
 	list_del_init(&work->node);
-	kthread_insert_work(worker, work, &worker->work_list);
+	if (!work->canceling)
+		kthread_insert_work(worker, work, &worker->work_list);
 
 	raw_spin_unlock_irqrestore(&worker->lock, flags);
 }
_

Patches currently in -mm which might be from qiang.zhang@windriver.com are


