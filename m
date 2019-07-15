Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A30B6910A
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388679AbfGOO0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391013AbfGOO0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:26:14 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E5E6206B8;
        Mon, 15 Jul 2019 14:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200773;
        bh=N1X1Rp0aGXOTiEvnWSmIUyE1epMSQjdYFSMEopPZ6qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ga9PA6uu7bNOIXHaoa2tgZzvHd7Ab6xQCdiXCeuKLzwQ3F+nnHIDzxna9mpVakbxq
         SDz9mhkt8KcZpiVfNPh2clSKjVIkokoCXO+1nFyBuAk18YZK7sR86Gd0T9bYWkeCfF
         GzffbpIqh0HmFQP7DLgtfpGJz/3O2q+XHhc9ax9Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 128/158] bcache: fix potential deadlock in cached_def_free()
Date:   Mon, 15 Jul 2019 10:17:39 -0400
Message-Id: <20190715141809.8445-128-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 7e865eba00a3df2dc8c4746173a8ca1c1c7f042e ]

When enable lockdep and reboot system with a writeback mode bcache
device, the following potential deadlock warning is reported by lockdep
engine.

[  101.536569][  T401] kworker/2:2/401 is trying to acquire lock:
[  101.538575][  T401] 00000000bbf6e6c7 ((wq_completion)bcache_writeback_wq){+.+.}, at: flush_workqueue+0x87/0x4c0
[  101.542054][  T401]
[  101.542054][  T401] but task is already holding lock:
[  101.544587][  T401] 00000000f5f305b3 ((work_completion)(&cl->work)#2){+.+.}, at: process_one_work+0x21e/0x640
[  101.548386][  T401]
[  101.548386][  T401] which lock already depends on the new lock.
[  101.548386][  T401]
[  101.551874][  T401]
[  101.551874][  T401] the existing dependency chain (in reverse order) is:
[  101.555000][  T401]
[  101.555000][  T401] -> #1 ((work_completion)(&cl->work)#2){+.+.}:
[  101.557860][  T401]        process_one_work+0x277/0x640
[  101.559661][  T401]        worker_thread+0x39/0x3f0
[  101.561340][  T401]        kthread+0x125/0x140
[  101.562963][  T401]        ret_from_fork+0x3a/0x50
[  101.564718][  T401]
[  101.564718][  T401] -> #0 ((wq_completion)bcache_writeback_wq){+.+.}:
[  101.567701][  T401]        lock_acquire+0xb4/0x1c0
[  101.569651][  T401]        flush_workqueue+0xae/0x4c0
[  101.571494][  T401]        drain_workqueue+0xa9/0x180
[  101.573234][  T401]        destroy_workqueue+0x17/0x250
[  101.575109][  T401]        cached_dev_free+0x44/0x120 [bcache]
[  101.577304][  T401]        process_one_work+0x2a4/0x640
[  101.579357][  T401]        worker_thread+0x39/0x3f0
[  101.581055][  T401]        kthread+0x125/0x140
[  101.582709][  T401]        ret_from_fork+0x3a/0x50
[  101.584592][  T401]
[  101.584592][  T401] other info that might help us debug this:
[  101.584592][  T401]
[  101.588355][  T401]  Possible unsafe locking scenario:
[  101.588355][  T401]
[  101.590974][  T401]        CPU0                    CPU1
[  101.592889][  T401]        ----                    ----
[  101.594743][  T401]   lock((work_completion)(&cl->work)#2);
[  101.596785][  T401]                                lock((wq_completion)bcache_writeback_wq);
[  101.600072][  T401]                                lock((work_completion)(&cl->work)#2);
[  101.602971][  T401]   lock((wq_completion)bcache_writeback_wq);
[  101.605255][  T401]
[  101.605255][  T401]  *** DEADLOCK ***
[  101.605255][  T401]
[  101.608310][  T401] 2 locks held by kworker/2:2/401:
[  101.610208][  T401]  #0: 00000000cf2c7d17 ((wq_completion)events){+.+.}, at: process_one_work+0x21e/0x640
[  101.613709][  T401]  #1: 00000000f5f305b3 ((work_completion)(&cl->work)#2){+.+.}, at: process_one_work+0x21e/0x640
[  101.617480][  T401]
[  101.617480][  T401] stack backtrace:
[  101.619539][  T401] CPU: 2 PID: 401 Comm: kworker/2:2 Tainted: G        W         5.2.0-rc4-lp151.20-default+ #1
[  101.623225][  T401] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
[  101.627210][  T401] Workqueue: events cached_dev_free [bcache]
[  101.629239][  T401] Call Trace:
[  101.630360][  T401]  dump_stack+0x85/0xcb
[  101.631777][  T401]  print_circular_bug+0x19a/0x1f0
[  101.633485][  T401]  __lock_acquire+0x16cd/0x1850
[  101.635184][  T401]  ? __lock_acquire+0x6a8/0x1850
[  101.636863][  T401]  ? lock_acquire+0xb4/0x1c0
[  101.638421][  T401]  ? find_held_lock+0x34/0xa0
[  101.640015][  T401]  lock_acquire+0xb4/0x1c0
[  101.641513][  T401]  ? flush_workqueue+0x87/0x4c0
[  101.643248][  T401]  flush_workqueue+0xae/0x4c0
[  101.644832][  T401]  ? flush_workqueue+0x87/0x4c0
[  101.646476][  T401]  ? drain_workqueue+0xa9/0x180
[  101.648303][  T401]  drain_workqueue+0xa9/0x180
[  101.649867][  T401]  destroy_workqueue+0x17/0x250
[  101.651503][  T401]  cached_dev_free+0x44/0x120 [bcache]
[  101.653328][  T401]  process_one_work+0x2a4/0x640
[  101.655029][  T401]  worker_thread+0x39/0x3f0
[  101.656693][  T401]  ? process_one_work+0x640/0x640
[  101.658501][  T401]  kthread+0x125/0x140
[  101.660012][  T401]  ? kthread_create_worker_on_cpu+0x70/0x70
[  101.661985][  T401]  ret_from_fork+0x3a/0x50
[  101.691318][  T401] bcache: bcache_device_free() bcache0 stopped

Here is how the above potential deadlock may happen in reboot/shutdown
code path,
1) bcache_reboot() is called firstly in the reboot/shutdown code path,
   then in bcache_reboot(), bcache_device_stop() is called.
2) bcache_device_stop() sets BCACHE_DEV_CLOSING on d->falgs, then call
   closure_queue(&d->cl) to invoke cached_dev_flush(). And in turn
   cached_dev_flush() calls cached_dev_free() via closure_at()
3) In cached_dev_free(), after stopped writebach kthread
   dc->writeback_thread, the kwork dc->writeback_write_wq is stopping by
   destroy_workqueue().
4) Inside destroy_workqueue(), drain_workqueue() is called. Inside
   drain_workqueue(), flush_workqueue() is called. Then wq->lockdep_map
   is acquired by lock_map_acquire() in flush_workqueue(). After the
   lock acquired the rest part of flush_workqueue() just wait for the
   workqueue to complete.
5) Now we look back at writeback thread routine bch_writeback_thread(),
   in the main while-loop, write_dirty() is called via continue_at() in
   read_dirty_submit(), which is called via continue_at() in while-loop
   level called function read_dirty(). Inside write_dirty() it may be
   re-called on workqueeu dc->writeback_write_wq via continue_at().
   It means when the writeback kthread is stopped in cached_dev_free()
   there might be still one kworker queued on dc->writeback_write_wq
   to execute write_dirty() again.
6) Now this kworker is scheduled on dc->writeback_write_wq to run by
   process_one_work() (which is called by worker_thread()). Before
   calling the kwork routine, wq->lockdep_map is acquired.
7) But wq->lockdep_map is acquired already in step 4), so a A-A lock
   (lockdep terminology) scenario happens.

Indeed on multiple cores syatem, the above deadlock is very rare to
happen, just as the code comments in process_one_work() says,
2263     * AFAICT there is no possible deadlock scenario between the
2264     * flush_work() and complete() primitives (except for
	   single-threaded
2265     * workqueues), so hiding them isn't a problem.

But it is still good to fix such lockdep warning, even no one running
bcache on single core system.

The fix is simple. This patch solves the above potential deadlock by,
- Do not destroy workqueue dc->writeback_write_wq in cached_dev_free().
- Flush and destroy dc->writeback_write_wq in writebach kthread routine
  bch_writeback_thread(), where after quit the thread main while-loop
  and before cached_dev_put() is called.

By this fix, dc->writeback_write_wq will be stopped and destroy before
the writeback kthread stopped, so the chance for a A-A locking on
wq->lockdep_map is disappeared, such A-A deadlock won't happen
any more.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c     | 2 --
 drivers/md/bcache/writeback.c | 4 ++++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index be8054c04eb7..173a2be72eeb 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1185,8 +1185,6 @@ static void cached_dev_free(struct closure *cl)
 
 	if (!IS_ERR_OR_NULL(dc->writeback_thread))
 		kthread_stop(dc->writeback_thread);
-	if (dc->writeback_write_wq)
-		destroy_workqueue(dc->writeback_write_wq);
 	if (!IS_ERR_OR_NULL(dc->status_update_thread))
 		kthread_stop(dc->status_update_thread);
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 08c3a9f9676c..6e72bb6c00f2 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -708,6 +708,10 @@ static int bch_writeback_thread(void *arg)
 		}
 	}
 
+	if (dc->writeback_write_wq) {
+		flush_workqueue(dc->writeback_write_wq);
+		destroy_workqueue(dc->writeback_write_wq);
+	}
 	cached_dev_put(dc);
 	wait_for_kthread_stop();
 
-- 
2.20.1

