Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489BD333D98
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhCJNYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231907AbhCJNYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7719964FDA;
        Wed, 10 Mar 2021 13:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382642;
        bh=8PnZjmJnJ8XwYFe3tQsXEMTsIshZbzpo2C7X8CHBVBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDo+bjXG+AXnBr496lCCyKhQyU4Ug3dgzev9LIiAOJL/nkSd+VO8JkSzQn38nHW8E
         IyRE0DU8JU9I2IqwqvEeGyw2GWUmLv4A4nnMvI5PQBKFZ57bQqfSbDDlPZvMuV+gzK
         ASgdQ68WmrQFi120HfJPiwM+BrNmJG5PDct17494=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+695b03d82fa8e4901b06@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.11 04/36] io_uring: unpark SQPOLL thread for cancelation
Date:   Wed, 10 Mar 2021 14:23:17 +0100
Message-Id: <20210310132320.660441161@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Pavel Begunkov <asml.silence@gmail.com>

commit 34343786ecc5ff493ca4d1f873b4386759ba52ee upstream

We park SQPOLL task before going into io_uring_cancel_files(), so the
task won't run task_works including those that might be important for
the cancellation passes. In this case it's io_poll_remove_one(), which
frees requests via io_put_req_deferred().

Unpark it for while waiting, it's ok as we disable submissions
beforehand, so no new requests will be generated.

INFO: task syz-executor893:8493 blocked for more than 143 seconds.
Call Trace:
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
 schedule+0xcf/0x270 kernel/sched/core.c:5157
 io_uring_cancel_files fs/io_uring.c:8912 [inline]
 io_uring_cancel_task_requests+0xe70/0x11a0 fs/io_uring.c:8979
 __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9067
 io_uring_files_cancel include/linux/io_uring.h:51 [inline]
 do_exit+0x2fe/0x2ae0 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Cc: stable@vger.kernel.org # 5.5+
Reported-by: syzbot+695b03d82fa8e4901b06@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8955,11 +8955,16 @@ static void io_uring_cancel_files(struct
 			break;
 
 		io_uring_try_cancel_requests(ctx, task, files);
+
+		if (ctx->sq_data)
+			io_sq_thread_unpark(ctx->sq_data);
 		prepare_to_wait(&task->io_uring->wait, &wait,
 				TASK_UNINTERRUPTIBLE);
 		if (inflight == io_uring_count_inflight(ctx, task, files))
 			schedule();
 		finish_wait(&task->io_uring->wait, &wait);
+		if (ctx->sq_data)
+			io_sq_thread_park(ctx->sq_data);
 	}
 }
 


