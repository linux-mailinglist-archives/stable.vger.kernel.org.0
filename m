Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADED3DC41D
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 08:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhGaGna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 02:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232079AbhGaGn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Jul 2021 02:43:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5521760EC0;
        Sat, 31 Jul 2021 06:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627713802;
        bh=EUnM7mfbwkIRfOUJeYNXPGyVl1HRD3Ien0fi6vUrJvA=;
        h=Subject:To:Cc:From:Date:From;
        b=rJcbH127OMyV6nhFHiasS9QhlKforygr/Qm0emhHK8h/K5KhvKYo8+8holOTYhmEK
         dSEhBwdgdNsh184susMGAKl8yT/5pLviAhPdVUEVgdkZE+E1eHF49hgvF2K6NQxwXj
         hvSyHdY/LPGJHqAY0occYOdyy9D1dZ8B98oBKrIU=
Subject: FAILED: patch "[PATCH] io_uring: fix race in unified task_work running" failed to apply to 5.13-stable tree
To:     axboe@kernel.dk, forza@tnonline.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 31 Jul 2021 08:43:20 +0200
Message-ID: <162771380065153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 110aa25c3ce417a44e35990cf8ed22383277933a Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 26 Jul 2021 10:42:56 -0600
Subject: [PATCH] io_uring: fix race in unified task_work running

We use a bit to manage if we need to add the shared task_work, but
a list + lock for the pending work. Before aborting a current run
of the task_work we check if the list is empty, but we do so without
grabbing the lock that protects it. This can lead to races where
we think we have nothing left to run, where in practice we could be
racing with a task adding new work to the list. If we do hit that
race condition, we could be left with work items that need processing,
but the shared task_work is not active.

Ensure that we grab the lock before checking if the list is empty,
so we know if it's safe to exit the run or not.

Link: https://lore.kernel.org/io-uring/c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net/
Cc: stable@vger.kernel.org # 5.11+
Reported-by: Forza <forza@tnonline.net>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c4d2b320cdd4..a4331deb0427 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1959,9 +1959,13 @@ static void tctx_task_work(struct callback_head *cb)
 			node = next;
 		}
 		if (wq_list_empty(&tctx->task_list)) {
+			spin_lock_irq(&tctx->task_lock);
 			clear_bit(0, &tctx->task_state);
-			if (wq_list_empty(&tctx->task_list))
+			if (wq_list_empty(&tctx->task_list)) {
+				spin_unlock_irq(&tctx->task_lock);
 				break;
+			}
+			spin_unlock_irq(&tctx->task_lock);
 			/* another tctx_task_work() is enqueued, yield */
 			if (test_and_set_bit(0, &tctx->task_state))
 				break;

