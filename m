Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD42F591A93
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 15:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239463AbiHMNZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 09:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbiHMNZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 09:25:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B483AE48
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 06:25:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95EC760DD8
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 13:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D38CC433D6;
        Sat, 13 Aug 2022 13:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660397133;
        bh=J/UjfqUBMWeSlPYnUMdo9WpgFmAyFz1FfJQjDswaAxI=;
        h=Subject:To:Cc:From:Date:From;
        b=fe6rcIbJIofSbhtnYtRBJzX7NsRp38HROyKsmeJuF1ILgCL6EeEyt1eNvVVAiHTcX
         CWDt5HDm59xuI3HVVEhR3/kDngJLiIza6z91635I/PFNgtGX/3rb2/MRslekKTMD8o
         IQi83Whe+AAGSsd9RvXQBGZTB9jvOf3zfpZwv+fU=
Subject: FAILED: patch "[PATCH] io_uring: optimize io_uring_task layout" failed to apply to 5.15-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 15:25:20 +0200
Message-ID: <1660397120105208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4a0fef62788b69df09267c8e3f3f11d4bb9d50e7 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 20 Jun 2022 15:27:35 +0100
Subject: [PATCH] io_uring: optimize io_uring_task layout

task_work bits of io_uring_task are split into two cache lines causing
extra cache bouncing, place them into a separate cache line. Also move
the most used submission path fields closer together, so there are hot.

Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/tctx.h b/io_uring/tctx.h
index dde82ce4d8e2..dead0ed00429 100644
--- a/io_uring/tctx.h
+++ b/io_uring/tctx.h
@@ -7,22 +7,24 @@
 
 struct io_uring_task {
 	/* submission side */
-	int			cached_refs;
-	struct xarray		xa;
-	struct wait_queue_head	wait;
-	const struct io_ring_ctx *last;
-	struct io_wq		*io_wq;
-	struct percpu_counter	inflight;
-	atomic_t		inflight_tracked;
-	atomic_t		in_idle;
-
-	spinlock_t		task_lock;
-	struct io_wq_work_list	task_list;
-	struct io_wq_work_list	prio_task_list;
-	struct callback_head	task_work;
-	bool			task_running;
-
-	struct file		*registered_rings[IO_RINGFD_REG_MAX];
+	int				cached_refs;
+	const struct io_ring_ctx 	*last;
+	struct io_wq			*io_wq;
+	struct file			*registered_rings[IO_RINGFD_REG_MAX];
+
+	struct xarray			xa;
+	struct wait_queue_head		wait;
+	atomic_t			in_idle;
+	atomic_t			inflight_tracked;
+	struct percpu_counter		inflight;
+
+	struct { /* task_work */
+		spinlock_t		task_lock;
+		bool			task_running;
+		struct io_wq_work_list	task_list;
+		struct io_wq_work_list	prio_task_list;
+		struct callback_head	task_work;
+	} ____cacheline_aligned_in_smp;
 };
 
 struct io_tctx_node {

