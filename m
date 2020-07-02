Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDF02117F9
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgGBBX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728536AbgGBBX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BBF12145D;
        Thu,  2 Jul 2020 01:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653036;
        bh=FeJYSWpPkEj16ll5EuwSvsmJPTgeQNhCZZ/l+eCp2w8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEpsozyf6RMXApLZrXyeYiLc92fWqrtut31jAJvEuJWAkkmqigAyOkVoLeeC3tlyZ
         dbsKuOiparlf1nZNc5FGSCY0M0nfXijdvlJf7HpZRUbm/5GLkMcq6+d/Ko1ZHSPMid
         8XvdYLkzpXXGEMWTTLVpE71faGWImnyXBx5jgZ1A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 49/53] io_uring: fix current->mm NULL dereference on exit
Date:   Wed,  1 Jul 2020 21:21:58 -0400
Message-Id: <20200702012202.2700645-49-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit d60b5fbc1ce8210759b568da49d149b868e7c6d3 ]

Don't reissue requests from io_iopoll_reap_events(), the task may not
have mm, which ends up with NULL. It's better to kill everything off on
exit anyway.

[  677.734670] RIP: 0010:io_iopoll_complete+0x27e/0x630
...
[  677.734679] Call Trace:
[  677.734695]  ? __send_signal+0x1f2/0x420
[  677.734698]  ? _raw_spin_unlock_irqrestore+0x24/0x40
[  677.734699]  ? send_signal+0xf5/0x140
[  677.734700]  io_iopoll_getevents+0x12f/0x1a0
[  677.734702]  io_iopoll_reap_events.part.0+0x5e/0xa0
[  677.734703]  io_ring_ctx_wait_and_kill+0x132/0x1c0
[  677.734704]  io_uring_release+0x20/0x30
[  677.734706]  __fput+0xcd/0x230
[  677.734707]  ____fput+0xe/0x10
[  677.734709]  task_work_run+0x67/0xa0
[  677.734710]  do_exit+0x35d/0xb70
[  677.734712]  do_group_exit+0x43/0xa0
[  677.734713]  get_signal+0x140/0x900
[  677.734715]  do_signal+0x37/0x780
[  677.734717]  ? enqueue_hrtimer+0x41/0xb0
[  677.734718]  ? recalibrate_cpu_khz+0x10/0x10
[  677.734720]  ? ktime_get+0x3e/0xa0
[  677.734721]  ? lapic_next_deadline+0x26/0x30
[  677.734723]  ? tick_program_event+0x4d/0x90
[  677.734724]  ? __hrtimer_get_next_event+0x4d/0x80
[  677.734726]  __prepare_exit_to_usermode+0x126/0x1c0
[  677.734741]  prepare_exit_to_usermode+0x9/0x40
[  677.734742]  idtentry_exit_cond_rcu+0x4c/0x60
[  677.734743]  sysvec_reschedule_ipi+0x92/0x160
[  677.734744]  ? asm_sysvec_reschedule_ipi+0xa/0x20
[  677.734745]  asm_sysvec_reschedule_ipi+0x12/0x20

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6cf9d509371e2..43dc745727408 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -858,6 +858,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_files_update *ip,
 				 unsigned nr_args);
 static int io_grab_files(struct io_kiocb *req);
+static void io_complete_rw_common(struct kiocb *kiocb, long res);
 static void io_cleanup_req(struct io_kiocb *req);
 static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 		       int fd, struct file **out_file, bool fixed);
@@ -1697,6 +1698,14 @@ static void io_iopoll_queue(struct list_head *again)
 	do {
 		req = list_first_entry(again, struct io_kiocb, list);
 		list_del(&req->list);
+
+		/* shouldn't happen unless io_uring is dying, cancel reqs */
+		if (unlikely(!current->mm)) {
+			io_complete_rw_common(&req->rw.kiocb, -EAGAIN);
+			io_put_req(req);
+			continue;
+		}
+
 		refcount_inc(&req->refs);
 		io_queue_async_work(req);
 	} while (!list_empty(again));
-- 
2.25.1

