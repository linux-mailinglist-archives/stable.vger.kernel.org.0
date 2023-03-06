Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E626ABD34
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 11:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjCFKse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 05:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjCFKsd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 05:48:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128E6BBB1
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 02:48:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CE8E60DDC
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 10:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7DEC433D2;
        Mon,  6 Mar 2023 10:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678099710;
        bh=uJb5cGletVUk/YqDfSMzEdxbpaaicZ2z3PhIj8m9WDQ=;
        h=Subject:To:Cc:From:Date:From;
        b=JWxj6ZJEMsyvdWNd+LPhMx6zy4VxStJEnC7aEAUPdDtlSdWzf1lxnBkYis3Rjc1uH
         It4Tysm+PgsLHVYRiWCMzGVHqh2fe0qKploYkXx5pY5t4Au7ATYFMEea8BJWUepg2U
         O/Gw5vcQaTtmhaboOKU8W/OsKA2VrrmEMRnF6IuU=
Subject: FAILED: patch "[PATCH] io_uring: handle TIF_NOTIFY_RESUME when checking for" failed to apply to 5.10-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 11:48:19 +0100
Message-ID: <1678099699105122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
git cherry-pick -x b5d3ae202fbfe055aa2a8ae8524531ee1dcab717
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678099699105122@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

b5d3ae202fbf ("io_uring: handle TIF_NOTIFY_RESUME when checking for task_work")
7cfe7a09489c ("io_uring: clear TIF_NOTIFY_SIGNAL if set and task_work not available")
46a525e199e4 ("io_uring: don't gate task_work run on TIF_NOTIFY_SIGNAL")
c0e0d6ba25f1 ("io_uring: add IORING_SETUP_DEFER_TASKRUN")
b4c98d59a787 ("io_uring: introduce io_has_work")
78a861b94959 ("io_uring: add sync cancelation API through io_uring_register()")
c34398a8c018 ("io_uring: remove __io_req_task_work_add")
ed5ccb3beeba ("io_uring: remove priority tw list optimisation")
625d38b3fd34 ("io_uring: improve io_run_task_work()")
4a0fef62788b ("io_uring: optimize io_uring_task layout")
253993210bd8 ("io_uring: introduce locking helpers for CQE posting")
305bef988708 ("io_uring: hide eventfd assumptions in eventfd paths")
affa87db9010 ("io_uring: fix multi ctx cancellation")
d9dee4302a7c ("io_uring: remove ->flush_cqes optimisation")
a830ffd28780 ("io_uring: move io_eventfd_signal()")
9046c6415be6 ("io_uring: reshuffle io_uring/io_uring.h")
d142c3ec8d16 ("io_uring: remove extra io_commit_cqring()")
ab1c84d855cf ("io_uring: make io_uring_types.h public")
68494a65d0e2 ("io_uring: introduce io_req_cqe_overflow()")
faf88dde060f ("io_uring: don't inline __io_get_cqe()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b5d3ae202fbfe055aa2a8ae8524531ee1dcab717 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 24 Jan 2023 08:24:25 -0700
Subject: [PATCH] io_uring: handle TIF_NOTIFY_RESUME when checking for
 task_work

If TIF_NOTIFY_RESUME is set, then we need to call resume_user_mode_work()
for PF_IO_WORKER threads. They never return to usermode, hence never get
a chance to process any items that are marked by this flag. Most notably
this includes the final put of files, but also any throttling markers set
by block cgroups.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index c68edf9872a5..d58cfe062da9 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -3,6 +3,7 @@
 
 #include <linux/errno.h>
 #include <linux/lockdep.h>
+#include <linux/resume_user_mode.h>
 #include <linux/io_uring_types.h>
 #include <uapi/linux/eventpoll.h>
 #include "io-wq.h"
@@ -274,6 +275,13 @@ static inline int io_run_task_work(void)
 	 */
 	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
 		clear_notify_signal();
+	/*
+	 * PF_IO_WORKER never returns to userspace, so check here if we have
+	 * notify work that needs processing.
+	 */
+	if (current->flags & PF_IO_WORKER &&
+	    test_thread_flag(TIF_NOTIFY_RESUME))
+		resume_user_mode_work(NULL);
 	if (task_work_pending(current)) {
 		__set_current_state(TASK_RUNNING);
 		task_work_run();

