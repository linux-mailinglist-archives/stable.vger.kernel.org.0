Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2952D07A5
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 23:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgLFW0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 17:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbgLFW0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 17:26:55 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90484C0613D2;
        Sun,  6 Dec 2020 14:26:14 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id v14so9958579wml.1;
        Sun, 06 Dec 2020 14:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7HHLLOjkccgnUtL12PevMC3GpBirCPeoDGjbB/DnT+Y=;
        b=NeM8aHM9j9LZGo3lw/4Bpv+VLP4pTNkPEW+zFH27MizLN2o/U0trzEWclyyMxCNnp+
         Ta1AMl0GMlUCiD+Z6VKCKeYi6vQ+2fHgCGTWMzb7TaCiV7FB6cI7wpGMf/gtD6FUdWN4
         GXt3xTxyZTPOtXa9/pyfHzIo9pgVk5RfY4Mqc8h7mTZMhg/jymJbGojSChm86EzZae5g
         lv4Scj4AW9SJmApzDsHcVi7yqPJajWxCoh8oLHuyqe2dIFREjHr0jT148s8/7+bYmUm6
         75IRcVhR2qXhnqe5KfU3i7ibwG/c/NYMfDMxdV1CuJZQXxqEEz00WtAL1vAIPEe6tDP7
         QATQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7HHLLOjkccgnUtL12PevMC3GpBirCPeoDGjbB/DnT+Y=;
        b=Jqo2VX0vyfilYmL9qUNWtWVEflAB1dqGv5P8aT2QmKAwid3bUOGyWlgsrB5EpTa545
         bLRXNLa1h4VQRn99PAicaI2St1V0/HP5S7pQZn/unHQVVL8zlbGWuoWRbyV7+zYCJdpn
         +v74E278P8iD/Ct/6FtAvCQcRFJoR9vJDf2QiWK1ICgL8qMncAcUZThWC8vwcCLj8HnG
         Dmnt9cnVS0F/ZR2Rr2V5I0z0o+dgraOkFzRadnpdEiqILfDfgfy0AtZq5lthg8nlvoBZ
         +JjSJvjCW3u7kCCv+hUztCIS20SByTeCsBNt8O+6QaF6tihzmcfVbeGMZQbr7otJJdaD
         6I4Q==
X-Gm-Message-State: AOAM533BISZtO890c5KhczoLd9Mj07+tOkwbIa7GqRyCnW/3biZG2P8S
        yYIZQ3l+/HOCryKe7aQa/w3VZMAT06J/UQ==
X-Google-Smtp-Source: ABdhPJxvblVV9KczXNy1bATM6LPc7rsC/mmb+Ug8kijIWdP8JbO4P87zMQb+edotAN1X/FUPnP4/xw==
X-Received: by 2002:a1c:25c3:: with SMTP id l186mr14993663wml.113.1607293573246;
        Sun, 06 Dec 2020 14:26:13 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.92])
        by smtp.gmail.com with ESMTPSA id h20sm11284917wmb.29.2020.12.06.14.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 14:26:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        stable@vger.kernel.org, Abaci Fuzz <abaci@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 5.10 1/5] io_uring: always let io_iopoll_complete() complete polled io.
Date:   Sun,  6 Dec 2020 22:22:42 +0000
Message-Id: <cf556b9b870c640690a1705c073fe955c01dab47.1607293068.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1607293068.git.asml.silence@gmail.com>
References: <cover.1607293068.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

Abaci Fuzz reported a double-free or invalid-free BUG in io_commit_cqring():
[   95.504842] BUG: KASAN: double-free or invalid-free in io_commit_cqring+0x3ec/0x8e0
[   95.505921]
[   95.506225] CPU: 0 PID: 4037 Comm: io_wqe_worker-0 Tainted: G    B
W         5.10.0-rc5+ #1
[   95.507434] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[   95.508248] Call Trace:
[   95.508683]  dump_stack+0x107/0x163
[   95.509323]  ? io_commit_cqring+0x3ec/0x8e0
[   95.509982]  print_address_description.constprop.0+0x3e/0x60
[   95.510814]  ? vprintk_func+0x98/0x140
[   95.511399]  ? io_commit_cqring+0x3ec/0x8e0
[   95.512036]  ? io_commit_cqring+0x3ec/0x8e0
[   95.512733]  kasan_report_invalid_free+0x51/0x80
[   95.513431]  ? io_commit_cqring+0x3ec/0x8e0
[   95.514047]  __kasan_slab_free+0x141/0x160
[   95.514699]  kfree+0xd1/0x390
[   95.515182]  io_commit_cqring+0x3ec/0x8e0
[   95.515799]  __io_req_complete.part.0+0x64/0x90
[   95.516483]  io_wq_submit_work+0x1fa/0x260
[   95.517117]  io_worker_handle_work+0xeac/0x1c00
[   95.517828]  io_wqe_worker+0xc94/0x11a0
[   95.518438]  ? io_worker_handle_work+0x1c00/0x1c00
[   95.519151]  ? __kthread_parkme+0x11d/0x1d0
[   95.519806]  ? io_worker_handle_work+0x1c00/0x1c00
[   95.520512]  ? io_worker_handle_work+0x1c00/0x1c00
[   95.521211]  kthread+0x396/0x470
[   95.521727]  ? _raw_spin_unlock_irq+0x24/0x30
[   95.522380]  ? kthread_mod_delayed_work+0x180/0x180
[   95.523108]  ret_from_fork+0x22/0x30
[   95.523684]
[   95.523985] Allocated by task 4035:
[   95.524543]  kasan_save_stack+0x1b/0x40
[   95.525136]  __kasan_kmalloc.constprop.0+0xc2/0xd0
[   95.525882]  kmem_cache_alloc_trace+0x17b/0x310
[   95.533930]  io_queue_sqe+0x225/0xcb0
[   95.534505]  io_submit_sqes+0x1768/0x25f0
[   95.535164]  __x64_sys_io_uring_enter+0x89e/0xd10
[   95.535900]  do_syscall_64+0x33/0x40
[   95.536465]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   95.537199]
[   95.537505] Freed by task 4035:
[   95.538003]  kasan_save_stack+0x1b/0x40
[   95.538599]  kasan_set_track+0x1c/0x30
[   95.539177]  kasan_set_free_info+0x1b/0x30
[   95.539798]  __kasan_slab_free+0x112/0x160
[   95.540427]  kfree+0xd1/0x390
[   95.540910]  io_commit_cqring+0x3ec/0x8e0
[   95.541516]  io_iopoll_complete+0x914/0x1390
[   95.542150]  io_do_iopoll+0x580/0x700
[   95.542724]  io_iopoll_try_reap_events.part.0+0x108/0x200
[   95.543512]  io_ring_ctx_wait_and_kill+0x118/0x340
[   95.544206]  io_uring_release+0x43/0x50
[   95.544791]  __fput+0x28d/0x940
[   95.545291]  task_work_run+0xea/0x1b0
[   95.545873]  do_exit+0xb6a/0x2c60
[   95.546400]  do_group_exit+0x12a/0x320
[   95.546967]  __x64_sys_exit_group+0x3f/0x50
[   95.547605]  do_syscall_64+0x33/0x40
[   95.548155]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

The reason is that once we got a non EAGAIN error in io_wq_submit_work(),
we'll complete req by calling io_req_complete(), which will hold completion_lock
to call io_commit_cqring(), but for polled io, io_iopoll_complete() won't
hold completion_lock to call io_commit_cqring(), then there maybe concurrent
access to ctx->defer_list, double free may happen.

To fix this bug, we always let io_iopoll_complete() complete polled io.

Cc: <stable@vger.kernel.org> # 5.5+
Reported-by: Abaci Fuzz <abaci@linux.alibaba.com>
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a2a7c65a77aa..c895a306f919 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6074,8 +6074,19 @@ static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
 	}
 
 	if (ret) {
-		req_set_fail_links(req);
-		io_req_complete(req, ret);
+		/*
+		 * io_iopoll_complete() does not hold completion_lock to complete
+		 * polled io, so here for polled io, just mark it done and still let
+		 * io_iopoll_complete() complete it.
+		 */
+		if (req->ctx->flags & IORING_SETUP_IOPOLL) {
+			struct kiocb *kiocb = &req->rw.kiocb;
+
+			kiocb_done(kiocb, ret, NULL);
+		} else {
+			req_set_fail_links(req);
+			io_req_complete(req, ret);
+		}
 	}
 
 	return io_steal_work(req);
-- 
2.24.0

