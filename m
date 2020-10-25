Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7522984C7
	for <lists+stable@lfdr.de>; Sun, 25 Oct 2020 23:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1419233AbgJYW5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 18:57:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391384AbgJYW5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Oct 2020 18:57:20 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD4D1222EC;
        Sun, 25 Oct 2020 22:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603666639;
        bh=sM+uM5VS2B1Fqls2hg33cvDLXN2vaD1TmjVh59xrVx8=;
        h=Date:From:To:Subject:From;
        b=1LbTDP1qKv9vnFFUab8bKJCaRhrhsoDLkkotq1L/rb042pHXkFlGWBMvL8JIQHp7G
         4y3mh3clRIhbycuE6o5KSbtmCgIFr9VXWD6fmlK/2IsaH10J+SBlbStXP0HXh06973
         HSJyre8Mc38M08hLpIPAzEth9WODUIVCRRTqbnvU=
Date:   Sun, 25 Oct 2020 15:57:19 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org,
        pmladek@suse.com, qiang.zhang@windriver.com
Subject:  +
 =?us-ascii?Q?kthread=5Fworker-prevent-queuing-delayed-work-from-time?=
 =?us-ascii?Q?r=5Ffn-when-it-is-being-canceled.patch?= added to -mm tree
Message-ID: <20201025225719.4xfmn%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kthread_worker: prevent queuing delayed work from timer_fn when it is being canceled
has been added to the -mm tree.  Its filename is
     kthread_worker-prevent-queuing-delayed-work-from-timer_fn-when-it-is-being-canceled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kthread_worker-prevent-queuing-delayed-work-from-timer_fn-when-it-is-being-canceled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kthread_worker-prevent-queuing-delayed-work-from-timer_fn-when-it-is-being-canceled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kthread_worker-prevent-queuing-delayed-work-from-timer_fn-when-it-is-being-canceled.patch

