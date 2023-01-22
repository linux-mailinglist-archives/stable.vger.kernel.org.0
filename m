Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB08676E99
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbjAVPMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjAVPMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:12:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA04621A09
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:12:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4974B60C63
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF24C433EF;
        Sun, 22 Jan 2023 15:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400332;
        bh=xD3AYwBmm7PKmBNsYHmtr8QyoJvhojUloP4cPovuszo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTeE5+8qEnKqytNgc5zh6tflQE9smuEJ8iKZnHvsMYxtT5vqS1sA/gB/AiGloxsR1
         hzhMX/qWQsqtjZ6tjkajcacSGRQzSEMqP9BxBEnRlW/R5GnTm83MdfXKiOjY2AK6Iz
         RS6NpvYv/vCIp2Do9yfGaL9CXrF8zJkmRTbFaSec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+dfcc5f4da15868df7d4d@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 34/98] io_uring/rw: defer fsnotify calls to task context
Date:   Sun, 22 Jan 2023 16:03:50 +0100
Message-Id: <20230122150230.933049060@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit b000145e9907809406d8164c3b2b8861d95aecd1 upstream.

We can't call these off the kiocb completion as that might be off
soft/hard irq context. Defer the calls to when we process the
task_work for this request. That avoids valid complaints like:

stack backtrace:
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.0.0-rc6-syzkaller-00321-g105a36f3694e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_usage_bug kernel/locking/lockdep.c:3961 [inline]
 valid_state kernel/locking/lockdep.c:3973 [inline]
 mark_lock_irq kernel/locking/lockdep.c:4176 [inline]
 mark_lock.part.0.cold+0x18/0xd8 kernel/locking/lockdep.c:4632
 mark_lock kernel/locking/lockdep.c:4596 [inline]
 mark_usage kernel/locking/lockdep.c:4527 [inline]
 __lock_acquire+0x11d9/0x56d0 kernel/locking/lockdep.c:5007
 lock_acquire kernel/locking/lockdep.c:5666 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
 __fs_reclaim_acquire mm/page_alloc.c:4674 [inline]
 fs_reclaim_acquire+0x115/0x160 mm/page_alloc.c:4688
 might_alloc include/linux/sched/mm.h:271 [inline]
 slab_pre_alloc_hook mm/slab.h:700 [inline]
 slab_alloc mm/slab.c:3278 [inline]
 __kmem_cache_alloc_lru mm/slab.c:3471 [inline]
 kmem_cache_alloc+0x39/0x520 mm/slab.c:3491
 fanotify_alloc_fid_event fs/notify/fanotify/fanotify.c:580 [inline]
 fanotify_alloc_event fs/notify/fanotify/fanotify.c:813 [inline]
 fanotify_handle_event+0x1130/0x3f40 fs/notify/fanotify/fanotify.c:948
 send_to_group fs/notify/fsnotify.c:360 [inline]
 fsnotify+0xafb/0x1680 fs/notify/fsnotify.c:570
 __fsnotify_parent+0x62f/0xa60 fs/notify/fsnotify.c:230
 fsnotify_parent include/linux/fsnotify.h:77 [inline]
 fsnotify_file include/linux/fsnotify.h:99 [inline]
 fsnotify_access include/linux/fsnotify.h:309 [inline]
 __io_complete_rw_common+0x485/0x720 io_uring/rw.c:195
 io_complete_rw+0x1a/0x1f0 io_uring/rw.c:228
 iomap_dio_complete_work fs/iomap/direct-io.c:144 [inline]
 iomap_dio_bio_end_io+0x438/0x5e0 fs/iomap/direct-io.c:178
 bio_endio+0x5f9/0x780 block/bio.c:1564
 req_bio_endio block/blk-mq.c:695 [inline]
 blk_update_request+0x3fc/0x1300 block/blk-mq.c:825
 scsi_end_request+0x7a/0x9a0 drivers/scsi/scsi_lib.c:541
 scsi_io_completion+0x173/0x1f70 drivers/scsi/scsi_lib.c:971
 scsi_complete+0x122/0x3b0 drivers/scsi/scsi_lib.c:1438
 blk_complete_reqs+0xad/0xe0 block/blk-mq.c:1022
 __do_softirq+0x1d3/0x9c6 kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
 common_interrupt+0xa9/0xc0 arch/x86/kernel/irq.c:240

Fixes: f63cf5192fe3 ("io_uring: ensure that fsnotify is always called")
Link: https://lore.kernel.org/all/20220929135627.ykivmdks2w5vzrwg@quack3/
Reported-by: syzbot+dfcc5f4da15868df7d4d@syzkaller.appspotmail.com
Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d4e017b07371..33e6e1011105 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2702,12 +2702,6 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 
 static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
-	if (req->rw.kiocb.ki_flags & IOCB_WRITE) {
-		kiocb_end_write(req);
-		fsnotify_modify(req->file);
-	} else {
-		fsnotify_access(req->file);
-	}
 	if (res != req->result) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
@@ -2760,6 +2754,20 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 	__io_req_complete(req, issue_flags, io_fixup_rw_res(req, res), io_put_rw_kbuf(req));
 }
 
+static void io_req_rw_complete(struct io_kiocb *req, bool *locked)
+{
+	struct io_rw *rw = &req->rw;
+
+	if (rw->kiocb.ki_flags & IOCB_WRITE) {
+		kiocb_end_write(req);
+		fsnotify_modify(req->file);
+	} else {
+		fsnotify_access(req->file);
+	}
+
+	io_req_task_complete(req, locked);
+}
+
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
@@ -2767,7 +2775,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 	if (__io_complete_rw_common(req, res))
 		return;
 	req->result = io_fixup_rw_res(req, res);
-	req->io_task_work.func = io_req_task_complete;
+	req->io_task_work.func = io_req_rw_complete;
 	io_req_task_work_add(req);
 }
 
-- 
2.39.0



