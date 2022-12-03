Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F326411EF
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 01:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiLCAXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 19:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234634AbiLCAXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 19:23:23 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC05C9075D
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 16:23:22 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id i19-20020a63e913000000b004705d1506a6so5805668pgh.13
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 16:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ckYytnVepoWbimE5xbgdrdPOmCNvH6nlU8CJOTSK59I=;
        b=AP2QhyJjEnq1NfXdCq5GJzqo/eyTwtvHuv53zolMCj3Hhx0DpJARPIek3x1v2zrpl+
         tKrE/iQh0D51pFvtUw3y9iiZqqzOH9eECRf0tljCZHxmvY3oOi97LxNgc6fmW/ly7i7z
         NEOlL1JPir1fl9Pr9TVSl8pbIcJrfrE8Z3SpuL9SUBC6u83i2dvinSMQTndUCOq60ZoD
         HCBDIeYKFMzCs5nT8xGMbHiSgm0j+f70d+tQdelf8btJqPXOMnnNOP/szMI5DrMuZqTq
         BfPZhT+xMLYjuhTMfAiijZ+vooyKLFXtPlmAZapo2GcOZUYgFhdQQDcCYazRLwgZcD4A
         DvYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ckYytnVepoWbimE5xbgdrdPOmCNvH6nlU8CJOTSK59I=;
        b=p249O/FIvU1rywsM6wJT7faF+ArTjivkK/lRSNeV/PHHgJetTBxuFvIqbsUNp9uxf0
         wPvskINKadUUsjt3Kf+nqPyzKt1r6x8yhpDIisXYxx4H83suHS1SMox9+JBSJauGdDPB
         fOZFig4x8I6rF1yZ7Ynd6+lao4qNL4ntJ/JlVEFLGbdzkD8LgsOjdDrSwfAqTAhgQIsz
         KZIQuJ/rEJeRL5aHb2F1A439pHinRDrv7TZG88azXI5IHEalvHFsoHSIpDG8cOkdnwqm
         0d2vhYAs4vrTGxQLlaqb9s5p46dd3+mSCc2Np++s+M0IN/3m8raX5AHB+vMfYN+ywGCe
         gVCA==
X-Gm-Message-State: ANoB5pl6uO1wUOjpOdOj5vLahV7gP4764XQQUeAsmob1wkjw9brI7zk8
        xLpF95SgnLWtIPFKS9fhX2LllA4UXmx/8g==
X-Google-Smtp-Source: AA0mqf5FLpxaeAUlECyuixx/9UtFbHUy3NZB8q/YFzDXHiW9Q/SRa3bZUzJNss5DBiNM89zzDNtRsKiqTDumYQ==
X-Received: from skhawaja-linux-us.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:3f34])
 (user=skhawaja job=sendgmr) by 2002:a17:902:e849:b0:186:dd96:ce45 with SMTP
 id t9-20020a170902e84900b00186dd96ce45mr54603645plg.73.1670027002387; Fri, 02
 Dec 2022 16:23:22 -0800 (PST)
Date:   Sat,  3 Dec 2022 00:23:05 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221203002305.1203792-1-skhawaja@google.com>
Subject: [PATCH] io_uring: don't hold uring_lock when calling io_run_task_work*
From:   Samiullah Khawaja <skhawaja@google.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>,
        Abaci <abaci@linux.alibaba.com>,
        Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Xu <haoxu@linux.alibaba.com>

commit 8bad28d8a305b0e5ae444c8c3051e8744f5a4296 upstream.

[Backported on top of stable 5.10 since the issue was introduced into it
with commit referred in Fixes tag below. The backport is done without
`file` to `rsrc` refactoring since it is not in 5.10].

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
Fixes: ce00a7d0d9523 ("io_uring: fix io_sqe_files_unregister() hangs")
Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
[axboe: fixes from Pavel folded in]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 fs/io_uring.c | 82 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 61 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d1cb1addea96..c5c22b067cd8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -217,6 +217,7 @@ struct fixed_file_data {
 	struct completion		done;
 	struct list_head		ref_list;
 	spinlock_t			lock;
+	bool				quiesce;
 };
 
 struct io_buffer {
@@ -7105,41 +7106,79 @@ static void io_sqe_files_set_node(struct fixed_file_data *file_data,
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
@@ -7150,7 +7189,6 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	kfree(data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
-	destroy_fixed_file_ref_node(backup_node);
 	return 0;
 }
 
@@ -8444,7 +8482,9 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		css_put(ctx->sqo_blkcg_css);
 #endif
 
+	mutex_lock(&ctx->uring_lock);
 	io_sqe_files_unregister(ctx);
+	mutex_unlock(&ctx->uring_lock);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
 
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

