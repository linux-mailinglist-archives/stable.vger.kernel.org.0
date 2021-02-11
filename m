Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF696318E70
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhBKP0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:26:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhBKPWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:22:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19F8664EA1;
        Thu, 11 Feb 2021 15:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055804;
        bh=XaHfzuhK9rtzcF4bpwXufiz2ZcYvGVQCb2OqVZiDTDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPeq4pTFKtmKPkUvsXwQeTnyuBPQnaBRAThlGVtvmZflAcdBhINNX1SnvINXvvIAn
         6HIUehM9eS7Z7GUjutfi3l4VPXO9q9i4f5EYW9HHa5UD6EETjDddsGA86r6gm4pm+V
         nkdMxvSTjiFrRetUJoYGsAV0vtO4jCQyg+apgvYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+3e3d9bd0c6ce9efbc3ef@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 14/54] io_uring: fix sqo ownership false positive warning
Date:   Thu, 11 Feb 2021 16:01:58 +0100
Message-Id: <20210211150153.500605711@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 70b2c60d3797bffe182dddb9bb55975b9be5889a ]

WARNING: CPU: 0 PID: 21359 at fs/io_uring.c:9042
    io_uring_cancel_task_requests+0xe55/0x10c0 fs/io_uring.c:9042
Call Trace:
 io_uring_flush+0x47b/0x6e0 fs/io_uring.c:9227
 filp_close+0xb4/0x170 fs/open.c:1295
 close_files fs/file.c:403 [inline]
 put_files_struct fs/file.c:418 [inline]
 put_files_struct+0x1cc/0x350 fs/file.c:415
 exit_files+0x7e/0xa0 fs/file.c:435
 do_exit+0xc22/0x2ae0 kernel/exit.c:820
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x427/0x20f0 kernel/signal.c:2773
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Now io_uring_cancel_task_requests() can be called not through file
notes but directly, remove a WARN_ONCE() there that give us false
positives. That check is not very important and we catch it in other
places.

Fixes: 84965ff8a84f0 ("io_uring: if we see flush on exit, cancel related tasks")
Cc: stable@vger.kernel.org # 5.9+
Reported-by: syzbot+3e3d9bd0c6ce9efbc3ef@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8683,8 +8683,6 @@ static void io_uring_cancel_task_request
 	struct task_struct *task = current;
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
-		/* for SQPOLL only sqo_task has task notes */
-		WARN_ON_ONCE(ctx->sqo_task != current);
 		io_disable_sqo_submit(ctx);
 		task = ctx->sq_data->thread;
 		atomic_inc(&task->io_uring->in_idle);


