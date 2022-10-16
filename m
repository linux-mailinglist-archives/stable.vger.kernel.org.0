Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCE75FFDB5
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 09:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiJPHGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 03:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJPHGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 03:06:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAB338A08
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 00:06:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF7B66098A
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 07:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F41C433C1;
        Sun, 16 Oct 2022 07:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665903962;
        bh=URdSmURfcWrkb9U9kePi0Ssh3ySkhwNeihhnb/QDw4o=;
        h=Subject:To:Cc:From:Date:From;
        b=hDxjUOkyKDHUNO1H0zIWyWFsy0mO3S9qmrnv4Nl371nGwRYlaA94Mey/QO3ZAp2zG
         jECt5TrJN7Eu/nBxgS3pvfoB104hFbADMaixcNZCEVyX58PmxsGgVda5TjjfdQJdjj
         RRpjSk2Sw5pTg5DvHpDopapzxThXHB1ZC+H1ta6s=
Subject: FAILED: patch "[PATCH] io_uring: don't gate task_work run on TIF_NOTIFY_SIGNAL" failed to apply to 5.19-stable tree
To:     axboe@kernel.dk, haesbaert@haesbaert.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 09:06:41 +0200
Message-ID: <1665904001170181@kroah.com>
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


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

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
e6f89be61410 ("io_uring: introduce a struct for hash table")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 46a525e199e4037516f7e498c18f065b09df32ac Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 29 Sep 2022 15:29:13 -0600
Subject: [PATCH] io_uring: don't gate task_work run on TIF_NOTIFY_SIGNAL

This isn't a reliable mechanism to tell if we have task_work pending, we
really should be looking at whether we have any items queued. This is
problematic if forward progress is gated on running said task_work. One
such example is reading from a pipe, where the write side has been closed
right before the read is started. The fput() of the file queues TWA_RESUME
task_work, and we need that task_work to be run before ->release() is
called for the pipe. If ->release() isn't called, then the read will sit
forever waiting on data that will never arise.

Fix this by io_run_task_work() so it checks if we have task_work pending
rather than rely on TIF_NOTIFY_SIGNAL for that. The latter obviously
doesn't work for task_work that is queued without TWA_SIGNAL.

Reported-by: Christiano Haesbaert <haesbaert@haesbaert.org>
Cc: stable@vger.kernel.org
Link: https://github.com/axboe/liburing/issues/665
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 177bd55357d7..48ce2348c8c1 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -231,11 +231,11 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 
 static inline int io_run_task_work(void)
 {
-	if (test_thread_flag(TIF_NOTIFY_SIGNAL)) {
+	if (task_work_pending(current)) {
+		if (test_thread_flag(TIF_NOTIFY_SIGNAL))
+			clear_notify_signal();
 		__set_current_state(TASK_RUNNING);
-		clear_notify_signal();
-		if (task_work_pending(current))
-			task_work_run();
+		task_work_run();
 		return 1;
 	}
 

