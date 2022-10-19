Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB8D603E97
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbiJSJQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbiJSJOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:14:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3F8222BB;
        Wed, 19 Oct 2022 02:04:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A3C06183D;
        Wed, 19 Oct 2022 09:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E30C433D6;
        Wed, 19 Oct 2022 09:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170256;
        bh=SqKkbboLaCEUZHGHFvJKgJF9FO7wa7t4MA8G7KqeKkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvuxuwYlIseDXieRyCVh1FMSABj03s3OD+b345PqWA02a48oo1fs/G9eW1iZxnfsl
         0C36ioShqrLA5kILg0/Ia3Am2ovKkMV8kQlf5g9zo/SAflmdSCjh3WB1UCrhYcssS2
         pG/3M4N1JRmFc/d+6Pqqi//dklZOXZdxgOuv5eXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+dfcc5f4da15868df7d4d@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 586/862] io_uring/rw: defer fsnotify calls to task context
Date:   Wed, 19 Oct 2022 10:31:13 +0200
Message-Id: <20221019083315.856733085@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit b000145e9907809406d8164c3b2b8861d95aecd1 ]

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
 io_uring/rw.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 295e3456d68e..eda14e8ec009 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -186,14 +186,6 @@ static void kiocb_end_write(struct io_kiocb *req)
 
 static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-
-	if (rw->kiocb.ki_flags & IOCB_WRITE) {
-		kiocb_end_write(req);
-		fsnotify_modify(req->file);
-	} else {
-		fsnotify_access(req->file);
-	}
 	if (unlikely(res != req->cqe.res)) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
@@ -220,6 +212,20 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 	return res;
 }
 
+static void io_req_rw_complete(struct io_kiocb *req, bool *locked)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
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
 static void io_complete_rw(struct kiocb *kiocb, long res)
 {
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
@@ -228,7 +234,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 	if (__io_complete_rw_common(req, res))
 		return;
 	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
-	req->io_task_work.func = io_req_task_complete;
+	req->io_task_work.func = io_req_rw_complete;
 	io_req_task_work_add(req);
 }
 
-- 
2.35.1



