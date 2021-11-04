Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42720444CF7
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 02:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhKDBYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 21:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbhKDBYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 21:24:47 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BADAC061203
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 18:22:10 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id k4so4538228plx.8
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 18:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eHqAIzV719j9lAkpwSrBfwZkYLTO2TUYbW63qRGOcw8=;
        b=JcDp7is6r26TrSdZ0q88ZPFszRzkzCKWQuNv8lvraPDM50WH6GhwKYgOTd+Poe0Ofp
         QiM3HSyb4VpWvdmvy9DS4EXMAwF1O98JlIHepU7K6N1uvq7ZKDEVSF6UMUH7qK0weYfj
         Zdf9LX/SDC7/oaD+O2O6l8WzEQ8kRkgvi1+ZaxeOIO9pEyhFQizHWDo2TN7bvLisVjw/
         8zfaxAEbz8xiKC/8jf6PcRpABdpSNl1gUW3XVc1Sw/0YercramVOWNYxhSqZPBrnMzXI
         oA+tcKwZ3CT+uz6qG4g9D8WmSpaGxCwLLwmqfcm192cSLTDtmHCI5rhoByBpWMdoFfmJ
         +Xkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eHqAIzV719j9lAkpwSrBfwZkYLTO2TUYbW63qRGOcw8=;
        b=idTQzcm5YI/tECdvk/f5aXyvlPYF6cKWVYd6+Nhj62hUtnkj5XQBwOs04JneTNySGR
         lVPo9qGpuB23QLs2xAB6sPJZOgHdDOQ5fU9qEJvOaLQH4Q977xWNOPRDR2U0evtrHyf6
         dm/Fiw5wLC953J1552MRM+kxskIj+Yp+lCy605NOSaXvKwKNW/z5Leg0rvbXqG6OWoif
         jZvUd92eD6nD+3mFjcmv7EY//cYrA2E6drJ6S2XD1+zGm31yEggwTUP9d3V5qD7BNhlH
         EHUgA9uTzGUrYU5kHnngaY/3y2Fo5Vn4r2Ti4XrFZ9x8KJBpMtsVQxfQ62Fd+Wdhe6xm
         hMAQ==
X-Gm-Message-State: AOAM5331nSr/7BaJFG0aypV/Nr5E5hm1hMYABTHYa/MX1XSIupWfrQxi
        YKH0R8r/Ki2NeznTRrRtbG8Lyg==
X-Google-Smtp-Source: ABdhPJx6xhIDWyRA1hCuL+WEEewz3TJLvBAIAp/NDnCi6Iky/USsaRIUt3iyHq1gKN1wqrr1GE5tgw==
X-Received: by 2002:a17:90a:9501:: with SMTP id t1mr18921689pjo.134.1635988929371;
        Wed, 03 Nov 2021 18:22:09 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id jz24sm2663464pjb.19.2021.11.03.18.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 18:22:08 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+6055980d041c8ac23307@syzkaller.appspotmail.com
Subject: [PATCH] io_uring: prevent io_put_identity() from freeing a static identity
Date:   Wed,  3 Nov 2021 18:21:20 -0700
Message-Id: <20211104012120.729261-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Note: this applies to 5.10 stable only. It doesn't trigger on anything
above 5.10 as the code there has been substantially reworked. This also
doesn't apply to any stable kernel below 5.10 afaict.

Syzbot found a bug: KASAN: invalid-free in io_dismantle_req
https://syzkaller.appspot.com/bug?id=123d9a852fc88ba573ffcb2dbcf4f9576c3b0559

The test submits bunch of io_uring writes and exits, which then triggers
uring_task_cancel() and io_put_identity(), which in some corner cases,
tries to free a static identity. This causes a panic as shown in the
trace below:

 BUG: KASAN: double-free or invalid-free in kfree+0xd5/0x310
 CPU: 0 PID: 4618 Comm: repro Not tainted 5.10.76-05281-g4944ec82ebb9-dirty #17
 Call Trace:
  dump_stack_lvl+0x1b2/0x21b
  print_address_description+0x8d/0x3b0
  kasan_report_invalid_free+0x58/0x130
  ____kasan_slab_free+0x14b/0x170
  __kasan_slab_free+0x11/0x20
  slab_free_freelist_hook+0xcc/0x1a0
  kfree+0xd5/0x310
  io_dismantle_req+0x9b0/0xd90
  io_do_iopoll+0x13a4/0x23e0
  io_iopoll_try_reap_events+0x116/0x290
  io_uring_cancel_task_requests+0x197d/0x1ee0
  io_uring_flush+0x170/0x6d0
  filp_close+0xb0/0x150
  put_files_struct+0x1d4/0x350
  exit_files+0x80/0xa0
  do_exit+0x6d9/0x2390
  do_group_exit+0x16a/0x2d0
  get_signal+0x133e/0x1f80
  arch_do_signal+0x7b/0x610
  exit_to_user_mode_prepare+0xaa/0xe0
  syscall_exit_to_user_mode+0x24/0x40
  do_syscall_64+0x3d/0x70
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

 Allocated by task 4611:
  ____kasan_kmalloc+0xcd/0x100
  __kasan_kmalloc+0x9/0x10
  kmem_cache_alloc_trace+0x208/0x390
  io_uring_alloc_task_context+0x57/0x550
  io_uring_add_task_file+0x1f7/0x290
  io_uring_create+0x2195/0x3490
  __x64_sys_io_uring_setup+0x1bf/0x280
  do_syscall_64+0x31/0x70
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

 The buggy address belongs to the object at ffff88810732b500
  which belongs to the cache kmalloc-192 of size 192
 The buggy address is located 88 bytes inside of
  192-byte region [ffff88810732b500, ffff88810732b5c0)
 Kernel panic - not syncing: panic_on_warn set ...

This issue bisected to this commit:
commit 186725a80c4e ("io_uring: fix skipping disabling sqo on exec")

Simple reverting the offending commit doesn't work as it hits some
other, related issues like:

/* sqo_dead check is for when this happens after cancellation */
WARN_ON_ONCE(ctx->sqo_task == current && !ctx->sqo_dead &&
	     !xa_load(&tctx->xa, (unsigned long)file));

 ------------[ cut here ]------------
 WARNING: CPU: 1 PID: 5622 at fs/io_uring.c:8960 io_uring_flush+0x5bc/0x6d0
 Modules linked in:
 CPU: 1 PID: 5622 Comm: repro Not tainted 5.10.76-05281-g4944ec82ebb9-dirty #16
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-6.fc35 04/01/2014
 RIP: 0010:io_uring_flush+0x5bc/0x6d0
 Call Trace:
 filp_close+0xb0/0x150
 put_files_struct+0x1d4/0x350
 reset_files_struct+0x88/0xa0
 bprm_execve+0x7f2/0x9f0
 do_execveat_common+0x46f/0x5d0
 __x64_sys_execve+0x92/0xb0
 do_syscall_64+0x31/0x70
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Changing __io_uring_task_cancel() to call io_disable_sqo_submit() directly,
as the comment suggests, only if __io_uring_files_cancel() is not executed
seems to fix the issue.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: <io-uring@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Reported-by: syzbot+6055980d041c8ac23307@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 fs/io_uring.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0736487165da..fcf9ffe9b209 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8882,20 +8882,18 @@ void __io_uring_task_cancel(void)
 	struct io_uring_task *tctx = current->io_uring;
 	DEFINE_WAIT(wait);
 	s64 inflight;
+	int canceled = 0;
 
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
 
-	/* trigger io_disable_sqo_submit() */
-	if (tctx->sqpoll)
-		__io_uring_files_cancel(NULL);
-
 	do {
 		/* read completions before cancelations */
 		inflight = tctx_inflight(tctx);
 		if (!inflight)
 			break;
 		__io_uring_files_cancel(NULL);
+		canceled = 1;
 
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
 
@@ -8909,6 +8907,21 @@ void __io_uring_task_cancel(void)
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
 
+	/*
+	 * trigger io_disable_sqo_submit()
+	 * if not already done by __io_uring_files_cancel()
+	 */
+	if (tctx->sqpoll && !canceled) {
+		struct file *file;
+		unsigned long index;
+
+		xa_for_each(&tctx->xa, index, file) {
+			struct io_ring_ctx *ctx = file->private_data;
+
+			io_disable_sqo_submit(ctx);
+		}
+	}
+
 	atomic_dec(&tctx->in_idle);
 
 	io_uring_remove_task_files(tctx);
-- 
2.33.1

