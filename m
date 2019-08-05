Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B453C81C8F
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731160AbfHENZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:25:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731150AbfHENZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:25:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 763B020880;
        Mon,  5 Aug 2019 13:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011505;
        bh=M5XLCrLXO58Fa1EK7vbtFtKGYwFSzsWIZeij3TjsELI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOzX8CT4gyxqy7taFrZrKLbfXh3pVqvDD9gf3NtVlJuCTTtKPar41n9Qz5QcAq0Fs
         eCjVhoZmq416TZmJwLgZ1XTLaelBxQLtO11Z5N43qDT0pq1Nz0HBBw2JdQW4ofimuD
         RrddcH+vFT+95AC7ynnMTqzvJtcWFckyFPOKVOP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        linux-block@vger.kernel.org, Jackie Liu <liuyun01@kylinos.cn>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.2 114/131] io_uring: fix KASAN use after free in io_sq_wq_submit_work
Date:   Mon,  5 Aug 2019 15:03:21 +0200
Message-Id: <20190805124959.595607216@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

commit d0ee879187df966ef638031b5f5183078d672141 upstream.

[root@localhost ~]# ./liburing/test/link

QEMU Standard PC report that:

[   29.379892] CPU: 0 PID: 84 Comm: kworker/u2:2 Not tainted 5.3.0-rc2-00051-g4010b622f1d2-dirty #86
[   29.379902] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
[   29.379913] Workqueue: io_ring-wq io_sq_wq_submit_work
[   29.379929] Call Trace:
[   29.379953]  dump_stack+0xa9/0x10e
[   29.379970]  ? io_sq_wq_submit_work+0xbf4/0xe90
[   29.379986]  print_address_description.cold.6+0x9/0x317
[   29.379999]  ? io_sq_wq_submit_work+0xbf4/0xe90
[   29.380010]  ? io_sq_wq_submit_work+0xbf4/0xe90
[   29.380026]  __kasan_report.cold.7+0x1a/0x34
[   29.380044]  ? io_sq_wq_submit_work+0xbf4/0xe90
[   29.380061]  kasan_report+0xe/0x12
[   29.380076]  io_sq_wq_submit_work+0xbf4/0xe90
[   29.380104]  ? io_sq_thread+0xaf0/0xaf0
[   29.380152]  process_one_work+0xb59/0x19e0
[   29.380184]  ? pwq_dec_nr_in_flight+0x2c0/0x2c0
[   29.380221]  worker_thread+0x8c/0xf40
[   29.380248]  ? __kthread_parkme+0xab/0x110
[   29.380265]  ? process_one_work+0x19e0/0x19e0
[   29.380278]  kthread+0x30b/0x3d0
[   29.380292]  ? kthread_create_on_node+0xe0/0xe0
[   29.380311]  ret_from_fork+0x3a/0x50

[   29.380635] Allocated by task 209:
[   29.381255]  save_stack+0x19/0x80
[   29.381268]  __kasan_kmalloc.constprop.6+0xc1/0xd0
[   29.381279]  kmem_cache_alloc+0xc0/0x240
[   29.381289]  io_submit_sqe+0x11bc/0x1c70
[   29.381300]  io_ring_submit+0x174/0x3c0
[   29.381311]  __x64_sys_io_uring_enter+0x601/0x780
[   29.381322]  do_syscall_64+0x9f/0x4d0
[   29.381336]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

[   29.381633] Freed by task 84:
[   29.382186]  save_stack+0x19/0x80
[   29.382198]  __kasan_slab_free+0x11d/0x160
[   29.382210]  kmem_cache_free+0x8c/0x2f0
[   29.382220]  io_put_req+0x22/0x30
[   29.382230]  io_sq_wq_submit_work+0x28b/0xe90
[   29.382241]  process_one_work+0xb59/0x19e0
[   29.382251]  worker_thread+0x8c/0xf40
[   29.382262]  kthread+0x30b/0x3d0
[   29.382272]  ret_from_fork+0x3a/0x50

[   29.382569] The buggy address belongs to the object at ffff888067172140
                which belongs to the cache io_kiocb of size 224
[   29.384692] The buggy address is located 120 bytes inside of
                224-byte region [ffff888067172140, ffff888067172220)
[   29.386723] The buggy address belongs to the page:
[   29.387575] page:ffffea00019c5c80 refcount:1 mapcount:0 mapping:ffff88806ace5180 index:0x0
[   29.387587] flags: 0x100000000000200(slab)
[   29.387603] raw: 0100000000000200 dead000000000100 dead000000000122 ffff88806ace5180
[   29.387617] raw: 0000000000000000 00000000800c000c 00000001ffffffff 0000000000000000
[   29.387624] page dumped because: kasan: bad access detected

[   29.387920] Memory state around the buggy address:
[   29.388771]  ffff888067172080: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
[   29.390062]  ffff888067172100: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
[   29.391325] >ffff888067172180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   29.392578]                                         ^
[   29.393480]  ffff888067172200: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
[   29.394744]  ffff888067172280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   29.396003] ==================================================================
[   29.397260] Disabling lock debugging due to kernel taint

io_sq_wq_submit_work free and read req again.

Cc: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Cc: linux-block@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: f7b76ac9d17e ("io_uring: fix counter inc/dec mismatch in async_list")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1692,6 +1692,7 @@ restart:
 	do {
 		struct sqe_submit *s = &req->submit;
 		const struct io_uring_sqe *sqe = s->sqe;
+		unsigned int flags = req->flags;
 
 		/* Ensure we clear previously set non-block flag */
 		req->rw.ki_flags &= ~IOCB_NOWAIT;
@@ -1737,7 +1738,7 @@ restart:
 		kfree(sqe);
 
 		/* req from defer and link list needn't decrease async cnt */
-		if (req->flags & (REQ_F_IO_DRAINED | REQ_F_LINK_DONE))
+		if (flags & (REQ_F_IO_DRAINED | REQ_F_LINK_DONE))
 			goto out;
 
 		if (!async_list)


