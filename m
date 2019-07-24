Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8934173ABD
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387731AbfGXTxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:53:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387684AbfGXTxR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:53:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 105C8205C9;
        Wed, 24 Jul 2019 19:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997995;
        bh=7i6gXfHaWngv5VUAQp+KtEuQQhJAmsAjrVtGpib9K3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUldHbPVFbWFQkSnsvnTa8q3DWs706mCe1lMXpHMcQU/4VonRASJwQF28Z5bt/5K3
         ESQdDVwet+5HlnjRwlMtG0yJ/PPM7hk1Bh0F6tNLVZDSeOrj3fJKqxXQ0FXf+SHim+
         AvCTD7jhPIpF0yK0SAMyd9KnPikyfGJ4M9HnsI3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 170/371] bcache: acquire bch_register_lock later in cached_dev_free()
Date:   Wed, 24 Jul 2019 21:18:42 +0200
Message-Id: <20190724191738.063244313@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 80265d8dfd77792e133793cef44a21323aac2908 ]

When enable lockdep engine, a lockdep warning can be observed when
reboot or shutdown system,

[ 3142.764557][    T1] bcache: bcache_reboot() Stopping all devices:
[ 3142.776265][ T2649]
[ 3142.777159][ T2649] ======================================================
[ 3142.780039][ T2649] WARNING: possible circular locking dependency detected
[ 3142.782869][ T2649] 5.2.0-rc4-lp151.20-default+ #1 Tainted: G        W
[ 3142.785684][ T2649] ------------------------------------------------------
[ 3142.788479][ T2649] kworker/3:67/2649 is trying to acquire lock:
[ 3142.790738][ T2649] 00000000aaf02291 ((wq_completion)bcache_writeback_wq){+.+.}, at: flush_workqueue+0x87/0x4c0
[ 3142.794678][ T2649]
[ 3142.794678][ T2649] but task is already holding lock:
[ 3142.797402][ T2649] 000000004fcf89c5 (&bch_register_lock){+.+.}, at: cached_dev_free+0x17/0x120 [bcache]
[ 3142.801462][ T2649]
[ 3142.801462][ T2649] which lock already depends on the new lock.
[ 3142.801462][ T2649]
[ 3142.805277][ T2649]
[ 3142.805277][ T2649] the existing dependency chain (in reverse order) is:
[ 3142.808902][ T2649]
[ 3142.808902][ T2649] -> #2 (&bch_register_lock){+.+.}:
[ 3142.812396][ T2649]        __mutex_lock+0x7a/0x9d0
[ 3142.814184][ T2649]        cached_dev_free+0x17/0x120 [bcache]
[ 3142.816415][ T2649]        process_one_work+0x2a4/0x640
[ 3142.818413][ T2649]        worker_thread+0x39/0x3f0
[ 3142.820276][ T2649]        kthread+0x125/0x140
[ 3142.822061][ T2649]        ret_from_fork+0x3a/0x50
[ 3142.823965][ T2649]
[ 3142.823965][ T2649] -> #1 ((work_completion)(&cl->work)#2){+.+.}:
[ 3142.827244][ T2649]        process_one_work+0x277/0x640
[ 3142.829160][ T2649]        worker_thread+0x39/0x3f0
[ 3142.830958][ T2649]        kthread+0x125/0x140
[ 3142.832674][ T2649]        ret_from_fork+0x3a/0x50
[ 3142.834915][ T2649]
[ 3142.834915][ T2649] -> #0 ((wq_completion)bcache_writeback_wq){+.+.}:
[ 3142.838121][ T2649]        lock_acquire+0xb4/0x1c0
[ 3142.840025][ T2649]        flush_workqueue+0xae/0x4c0
[ 3142.842035][ T2649]        drain_workqueue+0xa9/0x180
[ 3142.844042][ T2649]        destroy_workqueue+0x17/0x250
[ 3142.846142][ T2649]        cached_dev_free+0x52/0x120 [bcache]
[ 3142.848530][ T2649]        process_one_work+0x2a4/0x640
[ 3142.850663][ T2649]        worker_thread+0x39/0x3f0
[ 3142.852464][ T2649]        kthread+0x125/0x140
[ 3142.854106][ T2649]        ret_from_fork+0x3a/0x50
[ 3142.855880][ T2649]
[ 3142.855880][ T2649] other info that might help us debug this:
[ 3142.855880][ T2649]
[ 3142.859663][ T2649] Chain exists of:
[ 3142.859663][ T2649]   (wq_completion)bcache_writeback_wq --> (work_completion)(&cl->work)#2 --> &bch_register_lock
[ 3142.859663][ T2649]
[ 3142.865424][ T2649]  Possible unsafe locking scenario:
[ 3142.865424][ T2649]
[ 3142.868022][ T2649]        CPU0                    CPU1
[ 3142.869885][ T2649]        ----                    ----
[ 3142.871751][ T2649]   lock(&bch_register_lock);
[ 3142.873379][ T2649]                                lock((work_completion)(&cl->work)#2);
[ 3142.876399][ T2649]                                lock(&bch_register_lock);
[ 3142.879727][ T2649]   lock((wq_completion)bcache_writeback_wq);
[ 3142.882064][ T2649]
[ 3142.882064][ T2649]  *** DEADLOCK ***
[ 3142.882064][ T2649]
[ 3142.885060][ T2649] 3 locks held by kworker/3:67/2649:
[ 3142.887245][ T2649]  #0: 00000000e774cdd0 ((wq_completion)events){+.+.}, at: process_one_work+0x21e/0x640
[ 3142.890815][ T2649]  #1: 00000000f7df89da ((work_completion)(&cl->work)#2){+.+.}, at: process_one_work+0x21e/0x640
[ 3142.894884][ T2649]  #2: 000000004fcf89c5 (&bch_register_lock){+.+.}, at: cached_dev_free+0x17/0x120 [bcache]
[ 3142.898797][ T2649]
[ 3142.898797][ T2649] stack backtrace:
[ 3142.900961][ T2649] CPU: 3 PID: 2649 Comm: kworker/3:67 Tainted: G        W         5.2.0-rc4-lp151.20-default+ #1
[ 3142.904789][ T2649] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
[ 3142.909168][ T2649] Workqueue: events cached_dev_free [bcache]
[ 3142.911422][ T2649] Call Trace:
[ 3142.912656][ T2649]  dump_stack+0x85/0xcb
[ 3142.914181][ T2649]  print_circular_bug+0x19a/0x1f0
[ 3142.916193][ T2649]  __lock_acquire+0x16cd/0x1850
[ 3142.917936][ T2649]  ? __lock_acquire+0x6a8/0x1850
[ 3142.919704][ T2649]  ? lock_acquire+0xb4/0x1c0
[ 3142.921335][ T2649]  ? find_held_lock+0x34/0xa0
[ 3142.923052][ T2649]  lock_acquire+0xb4/0x1c0
[ 3142.924635][ T2649]  ? flush_workqueue+0x87/0x4c0
[ 3142.926375][ T2649]  flush_workqueue+0xae/0x4c0
[ 3142.928047][ T2649]  ? flush_workqueue+0x87/0x4c0
[ 3142.929824][ T2649]  ? drain_workqueue+0xa9/0x180
[ 3142.931686][ T2649]  drain_workqueue+0xa9/0x180
[ 3142.933534][ T2649]  destroy_workqueue+0x17/0x250
[ 3142.935787][ T2649]  cached_dev_free+0x52/0x120 [bcache]
[ 3142.937795][ T2649]  process_one_work+0x2a4/0x640
[ 3142.939803][ T2649]  worker_thread+0x39/0x3f0
[ 3142.941487][ T2649]  ? process_one_work+0x640/0x640
[ 3142.943389][ T2649]  kthread+0x125/0x140
[ 3142.944894][ T2649]  ? kthread_create_worker_on_cpu+0x70/0x70
[ 3142.947744][ T2649]  ret_from_fork+0x3a/0x50
[ 3142.970358][ T2649] bcache: bcache_device_free() bcache0 stopped

Here is how the deadlock happens.
1) bcache_reboot() calls bcache_device_stop(), then inside
   bcache_device_stop() BCACHE_DEV_CLOSING bit is set on d->flags.
   Then closure_queue(&d->cl) is called to invoke cached_dev_flush().
2) In cached_dev_flush(), cached_dev_free() is called by continu_at().
3) In cached_dev_free(), when stopping the writeback kthread of the
   cached device by kthread_stop(), dc->writeback_thread will be waken
   up to quite the kthread while-loop, then cached_dev_put() is called
   in bch_writeback_thread().
4) Calling cached_dev_put() in writeback kthread may drop dc->count to
   0, then dc->detach kworker is scheduled, which is initialized as
   cached_dev_detach_finish().
5) Inside cached_dev_detach_finish(), the last line of code is to call
   closure_put(&dc->disk.cl), which drops the last reference counter of
   closrure dc->disk.cl, then the callback cached_dev_flush() gets
   called.
Now cached_dev_flush() is called for second time in the code path, the
first time is in step 2). And again bch_register_lock will be acquired
again, and a A-A lock (lockdep terminology) is happening.

The root cause of the above A-A lock is in cached_dev_free(), mutex
bch_register_lock is held before stopping writeback kthread and other
kworkers. Fortunately now we have variable 'bcache_is_reboot', which may
prevent device registration or unregistration during reboot/shutdown
time, so it is unncessary to hold bch_register_lock such early now.

This is how this patch fixes the reboot/shutdown time A-A lock issue:
After moving mutex_lock(&bch_register_lock) to a later location where
before atomic_read(&dc->running) in cached_dev_free(), such A-A lock
problem can be solved without any reboot time registration race.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e489d2459569..cbde1cc1d2bd 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1186,8 +1186,6 @@ static void cached_dev_free(struct closure *cl)
 {
 	struct cached_dev *dc = container_of(cl, struct cached_dev, disk.cl);
 
-	mutex_lock(&bch_register_lock);
-
 	if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags))
 		cancel_writeback_rate_update_dwork(dc);
 
@@ -1198,6 +1196,8 @@ static void cached_dev_free(struct closure *cl)
 	if (!IS_ERR_OR_NULL(dc->status_update_thread))
 		kthread_stop(dc->status_update_thread);
 
+	mutex_lock(&bch_register_lock);
+
 	if (atomic_read(&dc->running))
 		bd_unlink_disk_holder(dc->bdev, dc->disk.disk);
 	bcache_device_free(&dc->disk);
-- 
2.20.1



