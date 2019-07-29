Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDA5796D3
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404252AbfG2Tzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404209AbfG2Tzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:55:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8DB121655;
        Mon, 29 Jul 2019 19:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430146;
        bh=roI165Huh2YZwrrESWI0FM6qfxa7DS7JW2FonjcqrGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrZ/tdQkMif5oBfxu18Q+8U0Dzqp5Z8JNB2T2XFgLJY3HIN+MK/fYyAyM/imjQl2+
         aHS4mRxxQMsyesbOxch6Y/nf/MSizcs19hrQvdolke/cbOW6PqCAS+31MI5VVL/9Y7
         s13ov+6FYN+AVNsGOPaqd+244jlKeniHlyvIsmLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.2 212/215] io_uring: add a memory barrier before atomic_read
Date:   Mon, 29 Jul 2019 21:23:28 +0200
Message-Id: <20190729190816.660689010@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>

commit c0e48f9dea9129aa11bec3ed13803bcc26e96e49 upstream.

There is a hang issue while using fio to do some basic test. The issue
can be easily reproduced using the below script:

        while true
        do
                fio  --ioengine=io_uring  -rw=write -bs=4k -numjobs=1 \
                     -size=1G -iodepth=64 -name=uring   --filename=/dev/zero
        done

After several minutes (or more), fio would block at
io_uring_enter->io_cqring_wait in order to waiting for previously
committed sqes to be completed and can't return to user anymore until
we send a SIGTERM to fio. After receiving SIGTERM, fio hangs at
io_ring_ctx_wait_and_kill with a backtrace like this:

        [54133.243816] Call Trace:
        [54133.243842]  __schedule+0x3a0/0x790
        [54133.243868]  schedule+0x38/0xa0
        [54133.243880]  schedule_timeout+0x218/0x3b0
        [54133.243891]  ? sched_clock+0x9/0x10
        [54133.243903]  ? wait_for_completion+0xa3/0x130
        [54133.243916]  ? _raw_spin_unlock_irq+0x2c/0x40
        [54133.243930]  ? trace_hardirqs_on+0x3f/0xe0
        [54133.243951]  wait_for_completion+0xab/0x130
        [54133.243962]  ? wake_up_q+0x70/0x70
        [54133.243984]  io_ring_ctx_wait_and_kill+0xa0/0x1d0
        [54133.243998]  io_uring_release+0x20/0x30
        [54133.244008]  __fput+0xcf/0x270
        [54133.244029]  ____fput+0xe/0x10
        [54133.244040]  task_work_run+0x7f/0xa0
        [54133.244056]  do_exit+0x305/0xc40
        [54133.244067]  ? get_signal+0x13b/0xbd0
        [54133.244088]  do_group_exit+0x50/0xd0
        [54133.244103]  get_signal+0x18d/0xbd0
        [54133.244112]  ? _raw_spin_unlock_irqrestore+0x36/0x60
        [54133.244142]  do_signal+0x34/0x720
        [54133.244171]  ? exit_to_usermode_loop+0x7e/0x130
        [54133.244190]  exit_to_usermode_loop+0xc0/0x130
        [54133.244209]  do_syscall_64+0x16b/0x1d0
        [54133.244221]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The reason is that we had added a req to ctx->pending_async at the very
end, but it didn't get a chance to be processed. How could this happen?

        fio#cpu0                                        wq#cpu1

        io_add_to_prev_work                    io_sq_wq_submit_work

          atomic_read() <<< 1

                                                  atomic_dec_return() << 1->0
                                                  list_empty();    <<< true;

          list_add_tail()
          atomic_read() << 0 or 1?

As atomic_ops.rst states, atomic_read does not guarantee that the
runtime modification by any other thread is visible yet, so we must take
care of that with a proper implicit or explicit memory barrier.

This issue was detected with the help of Jackie's <liuyun01@kylinos.cn>

Fixes: 31b515106428 ("io_uring: allow workqueue item to handle multiple buffered requests")
Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1769,6 +1769,10 @@ static bool io_add_to_prev_work(struct a
 	ret = true;
 	spin_lock(&list->lock);
 	list_add_tail(&req->list, &list->list);
+	/*
+	 * Ensure we see a simultaneous modification from io_sq_wq_submit_work()
+	 */
+	smp_mb();
 	if (!atomic_read(&list->cnt)) {
 		list_del_init(&req->list);
 		ret = false;


