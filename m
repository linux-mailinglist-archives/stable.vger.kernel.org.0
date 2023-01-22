Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238C6676DCC
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 15:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjAVOtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 09:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjAVOtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 09:49:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6ED18AB3
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 06:49:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 172AF60C41
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B47DC433EF;
        Sun, 22 Jan 2023 14:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674398946;
        bh=klWRaUInWLwFkUTfNkyN+9BcTz7yVkHg03kKafmuuEQ=;
        h=Subject:To:Cc:From:Date:From;
        b=mxfz7RQ8kg2R+PvUNHHI3fnsr6kKuTL8OEVUUeKVtyJGm00TZ8njxR/v9mmQXQaI/
         fKXIs/k6DMIAzFlfSnLHJQIsAb5XzvWcxshUmZ9U2ySFZHspBGjrBh0TM7SjXflHzO
         8ypQYTypo3DZVWPkSIpdIpvsup5SdFfK9/uzGwQA=
Subject: FAILED: patch "[PATCH] io_uring: clear TIF_NOTIFY_SIGNAL if set and task_work not" failed to apply to 5.15-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 15:48:56 +0100
Message-ID: <1674398936111119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

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
68494a65d0e2 ("io_uring: introduce io_req_cqe_overflow()")
faf88dde060f ("io_uring: don't inline __io_get_cqe()")
d245bca6375b ("io_uring: don't expose io_fill_cqe_aux()")
9ca9fb24d5fe ("io_uring: mutex locked poll hashing")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7cfe7a09489c1cefee7181e07b5f2bcbaebd9f41 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 25 Nov 2022 09:36:29 -0700
Subject: [PATCH] io_uring: clear TIF_NOTIFY_SIGNAL if set and task_work not
 available

With how task_work is added and signaled, we can have TIF_NOTIFY_SIGNAL
set and no task_work pending as it got run in a previous loop. Treat
TIF_NOTIFY_SIGNAL like get_signal(), always clear it if set regardless
of whether or not task_work is pending to run.

Cc: stable@vger.kernel.org
Fixes: 46a525e199e4 ("io_uring: don't gate task_work run on TIF_NOTIFY_SIGNAL")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index cef5ff924e63..50bc3af44953 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -238,9 +238,14 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 
 static inline int io_run_task_work(void)
 {
+	/*
+	 * Always check-and-clear the task_work notification signal. With how
+	 * signaling works for task_work, we can find it set with nothing to
+	 * run. We need to clear it for that case, like get_signal() does.
+	 */
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
+		clear_notify_signal();
 	if (task_work_pending(current)) {
-		if (test_thread_flag(TIF_NOTIFY_SIGNAL))
-			clear_notify_signal();
 		__set_current_state(TASK_RUNNING);
 		task_work_run();
 		return 1;

