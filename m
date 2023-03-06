Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B3D6ABD3A
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 11:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjCFKtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 05:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjCFKtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 05:49:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47C82330F
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 02:49:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35C7160DD3
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 10:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2A6C433EF;
        Mon,  6 Mar 2023 10:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678099739;
        bh=o0gvoHAKKEiEgsHKQjyKj/VyljZYi67dOHE/bjFkdJU=;
        h=Subject:To:Cc:From:Date:From;
        b=zccw0TccNKl1Lr09JZ06uDpDjVriB6b72VDF881UIWzDpHUVmMyRl1wd7xIOy6qgZ
         vCQXwUTVhfNCY4WKldn8+HnEjwUrLhAT6hQW/7Ry0kk248N0oDevV+zMez16F0chBn
         ZC6JP+o/K5MPlT7GjuIXP1LQCmqkMVdw8l6l66g0=
Subject: FAILED: patch "[PATCH] io_uring: add reschedule point to handle_tw_list()" failed to apply to 5.10-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 11:48:57 +0100
Message-ID: <16780997371220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x f58680085478dd292435727210122960d38e8014
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16780997371220@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

f58680085478 ("io_uring: add reschedule point to handle_tw_list()")
c6dd763c2460 ("io_uring: trace task_work_run")
3a0c037b0e16 ("io_uring: batch task_work")
f88262e60bb9 ("io_uring: lockless task list")
ed5ccb3beeba ("io_uring: remove priority tw list optimisation")
4a0fef62788b ("io_uring: optimize io_uring_task layout")
253993210bd8 ("io_uring: introduce locking helpers for CQE posting")
305bef988708 ("io_uring: hide eventfd assumptions in eventfd paths")
d9dee4302a7c ("io_uring: remove ->flush_cqes optimisation")
a830ffd28780 ("io_uring: move io_eventfd_signal()")
9046c6415be6 ("io_uring: reshuffle io_uring/io_uring.h")
d142c3ec8d16 ("io_uring: remove extra io_commit_cqring()")
68494a65d0e2 ("io_uring: introduce io_req_cqe_overflow()")
faf88dde060f ("io_uring: don't inline __io_get_cqe()")
d245bca6375b ("io_uring: don't expose io_fill_cqe_aux()")
6a02e4be8187 ("io_uring: inline ->registered_rings")
aa1e90f64ee5 ("io_uring: move small helpers to headers")
aa1e90f64ee5 ("io_uring: move small helpers to headers")
aa1e90f64ee5 ("io_uring: move small helpers to headers")
aa1e90f64ee5 ("io_uring: move small helpers to headers")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f58680085478dd292435727210122960d38e8014 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 27 Jan 2023 09:50:31 -0700
Subject: [PATCH] io_uring: add reschedule point to handle_tw_list()

If CONFIG_PREEMPT_NONE is set and the task_work chains are long, we
could be running into issues blocking others for too long. Add a
reschedule check in handle_tw_list(), and flush the ctx if we need to
reschedule.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fab581a31dc1..acf6d9680d76 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1179,10 +1179,16 @@ static unsigned int handle_tw_list(struct llist_node *node,
 			/* if not contended, grab and improve batching */
 			*locked = mutex_trylock(&(*ctx)->uring_lock);
 			percpu_ref_get(&(*ctx)->refs);
-		}
+		} else if (!*locked)
+			*locked = mutex_trylock(&(*ctx)->uring_lock);
 		req->io_task_work.func(req, locked);
 		node = next;
 		count++;
+		if (unlikely(need_resched())) {
+			ctx_flush_and_put(*ctx, locked);
+			*ctx = NULL;
+			cond_resched();
+		}
 	}
 
 	return count;

