Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39BA43C490
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 10:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239170AbhJ0IFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 04:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240708AbhJ0IEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 04:04:22 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D55CC061745
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 01:01:50 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id o14so2518350wra.12
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 01:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=koEXHSUcy6ltk8p7Tlj/Y8IX/ZrF3FoSYssdwagAkQA=;
        b=bhK4E3M+j/B8YILGhEFzHYTEZ4pm9h81c8MmxFm6CGqGh1kjbccUdUlFFuKFWuNq5X
         8qWtRkOSzsbiSRfv+wB/Z/Jo3Qc1LQY5Jky05TTO/iAcNzMgLbUByXFB1XyLeF8f3n67
         tTzma9Q6aoF4x/lGuJkjll6umr4+6Z8hdUng6mP7I2nBiOfU7qN7HMcHWZyTe7Ei+8yw
         UHTAfKMYuS9ZO65LfZ39f4yp0lC0HK3lpddD6CrH1E368RA6Cjld5FgZv3rF9KbyyrLa
         YSSq4Qnt2LikwI+s+4AmXU/TxB72C/R210mXrPXsizneQk3b/2mqcCwu9Ik5Zkh/SIKn
         Gl0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=koEXHSUcy6ltk8p7Tlj/Y8IX/ZrF3FoSYssdwagAkQA=;
        b=csye1iU/FBIn/Uo8ofgiKyaEIcVpo9RZ4Jl62YhxO/bHRm3hmeCRRs8BilfeWwKxun
         9KYhq4ypFT9cYHy+49h36Cs+Tznibq+vCaK6wqhVcBCpao1XxY2jAl3Emp5VsxbEVNkq
         /7Wg2z8VVnkBptjDBZG/kIl0F198K+CZzjDcTp2y03lejxhcUtuFHdy47BT1m8yob2cg
         0+sSi28ZrUlQ8+sy0pJQUmCuQn1+jH5QhjooK2dGCCchMxJ/X0IwfWn6GB9g0msuNJVs
         zQ4ZhbHNN2Kj80bH+ndeBN5ogncYVCdVZMP3JLy+LuUr5iA5Sfjbf++5JY/0o4cBkmQP
         yyjg==
X-Gm-Message-State: AOAM53175Og3JGavzIStZIIMqO6a9epDsoJPL/lI1ybyr+d6ozZfzzKw
        YSHUlnf+J+eh9nls6OVtj05rdQKCXKUh5A==
X-Google-Smtp-Source: ABdhPJzWzrFXSRLD/rZ9qd3uCa30n6A8M9D4EDQOTi9Gx2N0h7p83v0eK9kllzBaMXwVT/e+X3s74w==
X-Received: by 2002:adf:82b0:: with SMTP id 45mr9765542wrc.120.1635321708600;
        Wed, 27 Oct 2021 01:01:48 -0700 (PDT)
Received: from localhost.localdomain ([95.148.6.207])
        by smtp.gmail.com with ESMTPSA id e18sm12231847wrv.44.2021.10.27.01.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 01:01:48 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        syzbot+59d8a1f4e60c20c066cf@syzkaller.appspotmail.com
Subject: [PATCH 5.10 1/1] io_uring: fix double free in the deferred/cancelled path
Date:   Wed, 27 Oct 2021 09:01:28 +0100
Message-Id: <20211027080128.1836624-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

792bb6eb86233 ("io_uring: don't take uring_lock during iowq cancel")
inadvertently fixed this issue in v5.12.  This patch cherry-picks the
hunk of commit which does so.

Syzbot vomit (snipped):

  ==================================================================
  BUG: KASAN: double-free or invalid-free in slab_free mm/slub.c:3195 [inline]
  BUG: KASAN: double-free or invalid-free in kfree+0xca/0x310 mm/slub.c:4183

  CPU: 1 PID: 431 Comm: syz-executor823 Not tainted 5.10.75-syzkaller-01082-g234d53d2bb60 #0
  Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  Call Trace:
   __dump_stack lib/dump_stack.c:77 [inline]
   dump_stack_lvl+0x1e2/0x24b lib/dump_stack.c:118
   print_address_description+0x8d/0x3d0 mm/kasan/report.c:233
   kasan_report_invalid_free+0x58/0x130 mm/kasan/report.c:358
   ____kasan_slab_free+0x14b/0x170 mm/kasan/common.c:362
   __kasan_slab_free+0x11/0x20 mm/kasan/common.c:368
   kasan_slab_free include/linux/kasan.h:235 [inline]
   slab_free_hook mm/slub.c:1596 [inline]
   slab_free_freelist_hook+0xb2/0x180 mm/slub.c:1621
   slab_free mm/slub.c:3195 [inline]
   kfree+0xca/0x310 mm/slub.c:4183
   __io_queue_deferred fs/io_uring.c:1541 [inline]
   io_commit_cqring+0x76a/0xa00 fs/io_uring.c:1587
   io_iopoll_complete fs/io_uring.c:2378 [inline]
   io_do_iopoll+0x1e18/0x23f0 fs/io_uring.c:2431
   io_iopoll_try_reap_events+0x116/0x290 fs/io_uring.c:2470
   io_ring_ctx_wait_and_kill+0x295/0x670 fs/io_uring.c:8575
   io_uring_release+0x5b/0x70 fs/io_uring.c:8602
   __fput+0x348/0x7d0 fs/file_table.c:281
   ____fput+0x15/0x20 fs/file_table.c:314
   task_work_run+0x147/0x1b0 kernel/task_work.c:154
   exit_task_work include/linux/task_work.h:30 [inline]
   do_exit+0x70e/0x23a0 kernel/exit.c:813
   do_group_exit+0x16a/0x2d0 kernel/exit.c:910
   __do_sys_exit_group+0x17/0x20 kernel/exit.c:921
   __se_sys_exit_group+0x14/0x20 kernel/exit.c:919
   __x64_sys_exit_group+0x3b/0x40 kernel/exit.c:919
   do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

Cc: stable <stable@vger.kernel.org> # 5.10.x
Reported-by: syzbot+59d8a1f4e60c20c066cf@syzkaller.appspotmail.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 26753d0cb4312..361f8ae96c36f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2075,7 +2075,9 @@ static void io_req_task_cancel(struct callback_head *cb)
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct io_ring_ctx *ctx = req->ctx;
 
+	mutex_lock(&ctx->uring_lock);
 	__io_req_task_cancel(req, -ECANCELED);
+	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
 }
 
-- 
2.33.0.1079.g6e70778dc9-goog

