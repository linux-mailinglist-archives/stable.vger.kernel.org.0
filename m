Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A535FFDB3
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 09:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJPHF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 03:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJPHFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 03:05:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1C7386BA
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 00:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B1E560AB3
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 07:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803A8C433D6;
        Sun, 16 Oct 2022 07:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665903953;
        bh=1jMWhiMpwHcbzbHWLDWk/f89TDBu1e7/F8CQEefh/LE=;
        h=Subject:To:Cc:From:Date:From;
        b=OTXz2Gtc61RcgLEHnn81KajZe0fdbhvmqEfVTY0CG3YT65U6vSID0nToEmsUaF8mC
         tdLbjLa9q6ziXWwast/BRmFvzSt+wd1KOACb4uReWHUu/E56lMzg5vmmgtewGPkn/y
         zS1TsjNGBiSj9jnYxiqn/D55IaaLk0F1lyk+IVrg=
Subject: FAILED: patch "[PATCH] io_uring: don't gate task_work run on TIF_NOTIFY_SIGNAL" failed to apply to 6.0-stable tree
To:     axboe@kernel.dk, haesbaert@haesbaert.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 09:06:40 +0200
Message-ID: <16659040007770@kroah.com>
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


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

46a525e199e4 ("io_uring: don't gate task_work run on TIF_NOTIFY_SIGNAL")
c0e0d6ba25f1 ("io_uring: add IORING_SETUP_DEFER_TASKRUN")
b4c98d59a787 ("io_uring: introduce io_has_work")

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
 

