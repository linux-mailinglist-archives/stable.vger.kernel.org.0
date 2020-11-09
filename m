Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39F42ABC66
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730736AbgKINhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:37:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730387AbgKINEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:04:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEFFD208FE;
        Mon,  9 Nov 2020 13:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927064;
        bh=VeFSavHOK3iOl+ZEisP6nperyWfflKGerL0fPfr9nqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+uuHC5LbJMP1fwWaMsSzRq4SmzP7MO+nLgiJbVblsgktO96IlBjm24J1uls6WPNn
         n8BR8uOFCJpGURkfX9srI3S9tTkEnJso6esb30Vh9A7GQySFNcd1qIrZJBRfccuUh+
         yKfJyOjVzlvHGaNeYcMU3tgmmKmYZ5l6IWFd6VPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zqiang <qiang.zhang@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 098/117] kthread_worker: prevent queuing delayed work from timer_fn when it is being canceled
Date:   Mon,  9 Nov 2020 13:55:24 +0100
Message-Id: <20201109125030.351958579@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang.zhang@windriver.com>

commit 6993d0fdbee0eb38bfac350aa016f65ad11ed3b1 upstream.

There is a small race window when a delayed work is being canceled and
the work still might be queued from the timer_fn:

	CPU0						CPU1
kthread_cancel_delayed_work_sync()
   __kthread_cancel_work_sync()
     __kthread_cancel_work()
        work->canceling++;
					      kthread_delayed_work_timer_fn()
						   kthread_insert_work();

BUG: kthread_insert_work() should not get called when work->canceling is
set.

Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201014083030.16895-1-qiang.zhang@windriver.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kthread.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -828,7 +828,8 @@ void kthread_delayed_work_timer_fn(unsig
 	/* Move the work from worker->delayed_work_list. */
 	WARN_ON_ONCE(list_empty(&work->node));
 	list_del_init(&work->node);
-	kthread_insert_work(worker, work, &worker->work_list);
+	if (!work->canceling)
+		kthread_insert_work(worker, work, &worker->work_list);
 
 	spin_unlock(&worker->lock);
 }


