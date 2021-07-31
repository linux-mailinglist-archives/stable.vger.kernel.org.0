Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1458E3DC418
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 08:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhGaGl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 02:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232079AbhGaGl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Jul 2021 02:41:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1041660EC0;
        Sat, 31 Jul 2021 06:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627713711;
        bh=f+qF1vZ81QmIVQ3D09nIQOud6p/OwzuvZDkc7M8JS3s=;
        h=Subject:To:Cc:From:Date:From;
        b=jWf1sTqPOMtuaqNGi09GDpiNrvq275qpGdolOZl5bbUCnpvQ/6pNzdFrEIJxDn4aS
         j+lJDFJxtFXyMyWAUc+UlrUbaBFcsbGYWgmeBpj6ThFuDuv7ejX9Ex/Yk1Nku+XhwG
         HtA4b/E3blgd/3XYHgbMESZQ0QcppNkXITokOQVg=
Subject: FAILED: patch "[PATCH] blk-iocost: fix operation ordering in iocg_wake_fn()" failed to apply to 5.4-stable tree
To:     tj@kernel.org, axboe@kernel.dk, riel@surriel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 31 Jul 2021 08:41:49 +0200
Message-ID: <162771370957@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5ab189cf3abbc9994bae3be524c5b88589ed56e2 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 27 Jul 2021 14:38:09 -1000
Subject: [PATCH] blk-iocost: fix operation ordering in iocg_wake_fn()

iocg_wake_fn() open-codes wait_queue_entry removal and wakeup because it
wants the wq_entry to be always removed whether it ended up waking the
task or not. finish_wait() tests whether wq_entry needs removal without
grabbing the wait_queue lock and expects the waker to use
list_del_init_careful() after all waking operations are complete, which
iocg_wake_fn() didn't do. The operation order was wrong and the regular
list_del_init() was used.

The result is that if a waiter wakes up racing the waker, it can free pop
the wq_entry off stack before the waker is still looking at it, which can
lead to a backtrace like the following.

  [7312084.588951] general protection fault, probably for non-canonical address 0x586bf4005b2b88: 0000 [#1] SMP
  ...
  [7312084.647079] RIP: 0010:queued_spin_lock_slowpath+0x171/0x1b0
  ...
  [7312084.858314] Call Trace:
  [7312084.863548]  _raw_spin_lock_irqsave+0x22/0x30
  [7312084.872605]  try_to_wake_up+0x4c/0x4f0
  [7312084.880444]  iocg_wake_fn+0x71/0x80
  [7312084.887763]  __wake_up_common+0x71/0x140
  [7312084.895951]  iocg_kick_waitq+0xe8/0x2b0
  [7312084.903964]  ioc_rqos_throttle+0x275/0x650
  [7312084.922423]  __rq_qos_throttle+0x20/0x30
  [7312084.930608]  blk_mq_make_request+0x120/0x650
  [7312084.939490]  generic_make_request+0xca/0x310
  [7312084.957600]  submit_bio+0x173/0x200
  [7312084.981806]  swap_readpage+0x15c/0x240
  [7312084.989646]  read_swap_cache_async+0x58/0x60
  [7312084.998527]  swap_cluster_readahead+0x201/0x320
  [7312085.023432]  swapin_readahead+0x2df/0x450
  [7312085.040672]  do_swap_page+0x52f/0x820
  [7312085.058259]  handle_mm_fault+0xa16/0x1420
  [7312085.066620]  do_page_fault+0x2c6/0x5c0
  [7312085.074459]  page_fault+0x2f/0x40

Fix it by switching to list_del_init_careful() and putting it at the end.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Rik van Riel <riel@surriel.com>
Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index c2d6bc88d3f1..5fac3757e6e0 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1440,16 +1440,17 @@ static int iocg_wake_fn(struct wait_queue_entry *wq_entry, unsigned mode,
 		return -1;
 
 	iocg_commit_bio(ctx->iocg, wait->bio, wait->abs_cost, cost);
+	wait->committed = true;
 
 	/*
 	 * autoremove_wake_function() removes the wait entry only when it
-	 * actually changed the task state.  We want the wait always
-	 * removed.  Remove explicitly and use default_wake_function().
+	 * actually changed the task state. We want the wait always removed.
+	 * Remove explicitly and use default_wake_function(). Note that the
+	 * order of operations is important as finish_wait() tests whether
+	 * @wq_entry is removed without grabbing the lock.
 	 */
-	list_del_init(&wq_entry->entry);
-	wait->committed = true;
-
 	default_wake_function(wq_entry, mode, flags, key);
+	list_del_init_careful(&wq_entry->entry);
 	return 0;
 }
 

