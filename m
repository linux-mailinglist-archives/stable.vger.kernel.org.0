Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FA2643366
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbiLETgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbiLETfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:35:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE2626AE3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:32:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 771E961307
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85741C433D6;
        Mon,  5 Dec 2022 19:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268737;
        bh=B/cXDLNvVGFqJM1R9PCzif5c4F4+K6FKcibWDhnFfmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzQowmBpbWvTxdN4vVH4oGUs/qSIiz3WiTINpIneWKiF5fXp0rAQ2sJRrB9QeenX+
         HUornyMOJeAOniVSnvm5QxzNwNMcz6/rClm8G2jSUvWhuZfYT+iI2O+d3ViF0LZuGC
         K1oLHvSsMajyGyaWzBnS8z6vu3BLCfJ9Sk+nB7VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Abaci <abaci@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH 5.10 69/92] io_uring: dont hold uring_lock when calling io_run_task_work*
Date:   Mon,  5 Dec 2022 20:10:22 +0100
Message-Id: <20221205190805.785745100@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Xu <haoxu@linux.alibaba.com>

commit 8bad28d8a305b0e5ae444c8c3051e8744f5a4296 upstream.

Abaci reported the below issue:
[  141.400455] hrtimer: interrupt took 205853 ns
[  189.869316] process 'usr/local/ilogtail/ilogtail_0.16.26' started with executable stack
[  250.188042]
[  250.188327] ============================================
[  250.189015] WARNING: possible recursive locking detected
[  250.189732] 5.11.0-rc4 #1 Not tainted
[  250.190267] --------------------------------------------
[  250.190917] a.out/7363 is trying to acquire lock:
[  250.191506] ffff888114dbcbe8 (&ctx->uring_lock){+.+.}-{3:3}, at: __io_req_task_submit+0x29/0xa0
[  250.192599]
[  250.192599] but task is already holding lock:
[  250.193309] ffff888114dbfbe8 (&ctx->uring_lock){+.+.}-{3:3}, at: __x64_sys_io_uring_register+0xad/0x210
[  250.194426]
[  250.194426] other info that might help us debug this:
[  250.195238]  Possible unsafe locking scenario:
[  250.195238]
[  250.196019]        CPU0
[  250.196411]        ----
[  250.196803]   lock(&ctx->uring_lock);
[  250.197420]   lock(&ctx->uring_lock);
[  250.197966]
[  250.197966]  *** DEADLOCK ***
[  250.197966]
[  250.198837]  May be due to missing lock nesting notation
[  250.198837]
[  250.199780] 1 lock held by a.out/7363:
[  250.200373]  #0: ffff888114dbfbe8 (&ctx->uring_lock){+.+.}-{3:3}, at: __x64_sys_io_uring_register+0xad/0x210
[  250.201645]
[  250.201645] stack backtrace:
[  250.202298] CPU: 0 PID: 7363 Comm: a.out Not tainted 5.11.0-rc4 #1
[  250.203144] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  250.203887] Call Trace:
[  250.204302]  dump_stack+0xac/0xe3
[  250.204804]  __lock_acquire+0xab6/0x13a0
[  250.205392]  lock_acquire+0x2c3/0x390
[  250.205928]  ? __io_req_task_submit+0x29/0xa0
[  250.206541]  __mutex_lock+0xae/0x9f0
[  250.207071]  ? __io_req_task_submit+0x29/0xa0
[  250.207745]  ? 0xffffffffa0006083
[  250.208248]  ? __io_req_task_submit+0x29/0xa0
[  250.208845]  ? __io_req_task_submit+0x29/0xa0
[  250.209452]  ? __io_req_task_submit+0x5/0xa0
[  250.210083]  __io_req_task_submit+0x29/0xa0
[  250.210687]  io_async_task_func+0x23d/0x4c0
[  250.211278]  task_work_run+0x89/0xd0
[  250.211884]  io_run_task_work_sig+0x50/0xc0
[  250.212464]  io_sqe_files_unregister+0xb2/0x1f0
[  250.213109]  __io_uring_register+0x115a/0x1750
[  250.213718]  ? __x64_sys_io_uring_register+0xad/0x210
[  250.214395]  ? __fget_files+0x15a/0x260
[  250.214956]  __x64_sys_io_uring_register+0xbe/0x210
[  250.215620]  ? trace_hardirqs_on+0x46/0x110
[  250.216205]  do_syscall_64+0x2d/0x40
[  250.216731]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  250.217455] RIP: 0033:0x7f0fa17e5239
[  250.218034] Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05  3d 01 f0 ff ff 73 01 c3 48 8b 0d 27 ec 2c 00 f7 d8 64 89 01 48
[  250.220343] RSP: 002b:00007f0fa1eeac48 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
[  250.221360] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0fa17e5239
[  250.222272] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000008
[  250.223185] RBP: 00007f0fa1eeae20 R08: 0000000000000000 R09: 0000000000000000
[  250.224091] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  250.224999] R13: 0000000000021000 R14: 0000000000000000 R15: 00007f0fa1eeb700

This is caused by calling io_run_task_work_sig() to do work under
uring_lock while the caller io_sqe_files_unregister() already held
uring_lock.
To fix this issue, briefly drop uring_lock when calling
io_run_task_work_sig(), and there are two things to concern:

- hold uring_lock in io_ring_ctx_free() around io_sqe_files_unregister()
    this is for consistency of lock/unlock.
- add new fixed rsrc ref node before dropping uring_lock
    it's not safe to do io_uring_enter-->percpu_ref_get() with a dying one.
- check if rsrc_data->refs is dying to avoid parallel io_sqe_files_unregister

Reported-by: Abaci <abaci@linux.alibaba.com>
Fixes: 1ffc54220c44 ("io_uring: fix io_sqe_files_unregister() hangs")
Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
[axboe: fixes from Pavel folded in]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   82 +++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 61 insertions(+), 21 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -217,6 +217,7 @@ struct fixed_file_data {
 	struct completion		done;
 	struct list_head		ref_list;
 	spinlock_t			lock;
+	bool				quiesce;
 };
 
 struct io_buffer {
@@ -7105,41 +7106,79 @@ static void io_sqe_files_set_node(struct
 	percpu_ref_get(&file_data->refs);
 }
 
-static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
-{
-	struct fixed_file_data *data = ctx->file_data;
-	struct fixed_file_ref_node *backup_node, *ref_node = NULL;
-	unsigned nr_tables, i;
-	int ret;
 
-	if (!data)
-		return -ENXIO;
-	backup_node = alloc_fixed_file_ref_node(ctx);
-	if (!backup_node)
-		return -ENOMEM;
+static void io_sqe_files_kill_node(struct fixed_file_data *data)
+{
+	struct fixed_file_ref_node *ref_node = NULL;
 
 	spin_lock_bh(&data->lock);
 	ref_node = data->node;
 	spin_unlock_bh(&data->lock);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
+}
+
+static int io_file_ref_quiesce(struct fixed_file_data *data,
+			       struct io_ring_ctx *ctx)
+{
+	int ret;
+	struct fixed_file_ref_node *backup_node;
 
-	percpu_ref_kill(&data->refs);
+	if (data->quiesce)
+		return -ENXIO;
 
-	/* wait for all refs nodes to complete */
-	flush_delayed_work(&ctx->file_put_work);
+	data->quiesce = true;
 	do {
+		backup_node = alloc_fixed_file_ref_node(ctx);
+		if (!backup_node)
+			break;
+
+		io_sqe_files_kill_node(data);
+		percpu_ref_kill(&data->refs);
+		flush_delayed_work(&ctx->file_put_work);
+
 		ret = wait_for_completion_interruptible(&data->done);
 		if (!ret)
 			break;
+
+		percpu_ref_resurrect(&data->refs);
+		io_sqe_files_set_node(data, backup_node);
+		backup_node = NULL;
+		reinit_completion(&data->done);
+		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig();
-		if (ret < 0) {
-			percpu_ref_resurrect(&data->refs);
-			reinit_completion(&data->done);
-			io_sqe_files_set_node(data, backup_node);
-			return ret;
-		}
+		mutex_lock(&ctx->uring_lock);
+
+		if (ret < 0)
+			break;
+		backup_node = alloc_fixed_file_ref_node(ctx);
+		ret = -ENOMEM;
+		if (!backup_node)
+			break;
 	} while (1);
+	data->quiesce = false;
+
+	if (backup_node)
+		destroy_fixed_file_ref_node(backup_node);
+	return ret;
+}
+
+static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
+{
+	struct fixed_file_data *data = ctx->file_data;
+	unsigned nr_tables, i;
+	int ret;
+
+	/*
+	 * percpu_ref_is_dying() is to stop parallel files unregister
+	 * Since we possibly drop uring lock later in this function to
+	 * run task work.
+	 */
+	if (!data || percpu_ref_is_dying(&data->refs))
+		return -ENXIO;
+	ret = io_file_ref_quiesce(data, ctx);
+	if (ret)
+		return ret;
 
 	__io_sqe_files_unregister(ctx);
 	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
@@ -7150,7 +7189,6 @@ static int io_sqe_files_unregister(struc
 	kfree(data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
-	destroy_fixed_file_ref_node(backup_node);
 	return 0;
 }
 
@@ -8444,7 +8482,9 @@ static void io_ring_ctx_free(struct io_r
 		css_put(ctx->sqo_blkcg_css);
 #endif
 
+	mutex_lock(&ctx->uring_lock);
 	io_sqe_files_unregister(ctx);
+	mutex_unlock(&ctx->uring_lock);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
 


