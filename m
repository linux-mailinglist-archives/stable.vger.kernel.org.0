Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4EA412593
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353997AbhITSq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382849AbhITSmb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:42:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3828163349;
        Mon, 20 Sep 2021 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159124;
        bh=JSlWRf+J8cegpqnrLWzv525DtN5CL4GM48c1AwWkFVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRV6Q7q0Kb64TVogi19cmYmZh2OanXEVq7PTf50tr0uGjoCVKFkPKr8kV2SS6DXCy
         ZffMMwbrT+wQJ7lL4wTXD47we2aTBnIXCAdUb4ST0JzV1zCgCdf5PNJwmwgz4LxrkQ
         K6DSVLUQa6HhOrJ1FKavSaVPRc2jsz12gfviGoxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+01321b15cc98e6bf96d6@syzkaller.appspotmail.com,
        Yanfei Xu <yanfei.xu@windriver.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 087/168] blkcg: fix memory leak in blk_iolatency_init
Date:   Mon, 20 Sep 2021 18:43:45 +0200
Message-Id: <20210920163924.494984171@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yanfei Xu <yanfei.xu@windriver.com>

[ Upstream commit 6f5ddde41069fcd1f0993ec76c9dbbf9d021fd4d ]

BUG: memory leak
unreferenced object 0xffff888129acdb80 (size 96):
  comm "syz-executor.1", pid 12661, jiffies 4294962682 (age 15.220s)
  hex dump (first 32 bytes):
    20 47 c9 85 ff ff ff ff 20 d4 8e 29 81 88 ff ff   G...... ..)....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff82264ec8>] kmalloc include/linux/slab.h:591 [inline]
    [<ffffffff82264ec8>] kzalloc include/linux/slab.h:721 [inline]
    [<ffffffff82264ec8>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:724
    [<ffffffff8225b8c4>] blkcg_init_queue+0xb4/0x1c0 block/blk-cgroup.c:1185
    [<ffffffff822253da>] blk_alloc_queue+0x22a/0x2e0 block/blk-core.c:566
    [<ffffffff8223b175>] blk_mq_init_queue_data block/blk-mq.c:3100 [inline]
    [<ffffffff8223b175>] __blk_mq_alloc_disk+0x25/0xd0 block/blk-mq.c:3124
    [<ffffffff826a9303>] loop_add+0x1c3/0x360 drivers/block/loop.c:2344
    [<ffffffff826a966e>] loop_control_get_free drivers/block/loop.c:2501 [inline]
    [<ffffffff826a966e>] loop_control_ioctl+0x17e/0x2e0 drivers/block/loop.c:2516
    [<ffffffff81597eec>] vfs_ioctl fs/ioctl.c:51 [inline]
    [<ffffffff81597eec>] __do_sys_ioctl fs/ioctl.c:874 [inline]
    [<ffffffff81597eec>] __se_sys_ioctl fs/ioctl.c:860 [inline]
    [<ffffffff81597eec>] __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:860
    [<ffffffff843fa745>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff843fa745>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Once blk_throtl_init() queue init failed, blkcg_iolatency_exit() will
not be invoked for cleanup. That leads a memory leak. Swap the
blk_throtl_init() and blk_iolatency_init() calls can solve this.

Reported-by: syzbot+01321b15cc98e6bf96d6@syzkaller.appspotmail.com
Fixes: 19688d7f9592 (block/blk-cgroup: Swap the blk_throtl_init() and blk_iolatency_init() calls)
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20210915072426.4022924-1-yanfei.xu@windriver.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 31fe9be179d9..26446f97deee 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1201,10 +1201,6 @@ int blkcg_init_queue(struct request_queue *q)
 	if (preloaded)
 		radix_tree_preload_end();
 
-	ret = blk_iolatency_init(q);
-	if (ret)
-		goto err_destroy_all;
-
 	ret = blk_ioprio_init(q);
 	if (ret)
 		goto err_destroy_all;
@@ -1213,6 +1209,12 @@ int blkcg_init_queue(struct request_queue *q)
 	if (ret)
 		goto err_destroy_all;
 
+	ret = blk_iolatency_init(q);
+	if (ret) {
+		blk_throtl_exit(q);
+		goto err_destroy_all;
+	}
+
 	return 0;
 
 err_destroy_all:
-- 
2.30.2



