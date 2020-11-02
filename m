Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323A12A22AC
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 02:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbgKBBHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 20:07:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 20:07:54 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 185C622268;
        Mon,  2 Nov 2020 01:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604279274;
        bh=Niqq3HHDaK9hED/6KWIFNkPVh25jJQDmz3J5SXB7FEo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kEPjnqHb6CSGc4mnOA92vk95X5/ZHb/ViGi8ZoU8ae+EmxI0kuEkNMo9efUJlsiTO
         yEPeJXbJl9BAAuseR05wqkEjdGQgdyY9ShwdyDucNj11jaVGLkF5oJtQvSL4NuUyVd
         dc/3GLITTstvmJkXNnyGyTcVxjoBYrFym/yFTfUk=
Date:   Sun, 01 Nov 2020 17:07:53 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pmladek@suse.com,
        qiang.zhang@windriver.com, stable@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 10/15] kthread_worker: prevent queuing delayed
 work from timer_fn when it is being canceled
Message-ID: <20201102010753.nF453nOWt%akpm@linux-foundation.org>
In-Reply-To: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
