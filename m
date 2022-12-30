Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7DB658445
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbiL1Q4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbiL1Qzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:55:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565C11F61D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:50:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6C77B8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4156BC433D2;
        Wed, 28 Dec 2022 16:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246233;
        bh=2Ma9DeWXorTs0Fu3zGWxyzW4seq6PpT29z+fB/y/lxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3xgsehmA4E5D/nuNL3lpICllH8B1qL0VEGtPMySG9ec0c6lao0hRVBw18+LrVTG1
         DU2KvnXwzLxoGSijLerkFZWC9eKxiJ5hR02OU8aLA0sGaCrv6CeCh5cVx+0kYBckRS
         h4geaZO3rqa0BPkq9Lsn7baucuAdgQXO409XI9tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiao Ni <xni@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>, Ming Lei <ming.lei@redhat.com>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1007/1146] md/raid0, raid10: Dont set discard sectors for request queue
Date:   Wed, 28 Dec 2022 15:42:26 +0100
Message-Id: <20221228144357.722757349@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Ni <xni@redhat.com>

[ Upstream commit 8e1a2279ca2b0485cc379a153d02a9793f74a48f ]

It should use disk_stack_limits to get a proper max_discard_sectors
rather than setting a value by stack drivers.

And there is a bug. If all member disks are rotational devices,
raid0/raid10 set max_discard_sectors. So the member devices are
not ssd/nvme, but raid0/raid10 export the wrong value. It reports
warning messages in function __blkdev_issue_discard when mkfs.xfs
like this:

[ 4616.022599] ------------[ cut here ]------------
[ 4616.027779] WARNING: CPU: 4 PID: 99634 at block/blk-lib.c:50 __blkdev_issue_discard+0x16a/0x1a0
[ 4616.140663] RIP: 0010:__blkdev_issue_discard+0x16a/0x1a0
[ 4616.146601] Code: 24 4c 89 20 31 c0 e9 fe fe ff ff c1 e8 09 8d 48 ff 4c 89 f0 4c 09 e8 48 85 c1 0f 84 55 ff ff ff b8 ea ff ff ff e9 df fe ff ff <0f> 0b 48 8d 74 24 08 e8 ea d6 00 00 48 c7 c6 20 1e 89 ab 48 c7 c7
[ 4616.167567] RSP: 0018:ffffaab88cbffca8 EFLAGS: 00010246
[ 4616.173406] RAX: ffff9ba1f9e44678 RBX: 0000000000000000 RCX: ffff9ba1c9792080
[ 4616.181376] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9ba1c9792080
[ 4616.189345] RBP: 0000000000000cc0 R08: ffffaab88cbffd10 R09: 0000000000000000
[ 4616.197317] R10: 0000000000000012 R11: 0000000000000000 R12: 0000000000000000
[ 4616.205288] R13: 0000000000400000 R14: 0000000000000cc0 R15: ffff9ba1c9792080
[ 4616.213259] FS:  00007f9a5534e980(0000) GS:ffff9ba1b7c80000(0000) knlGS:0000000000000000
[ 4616.222298] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4616.228719] CR2: 000055a390a4c518 CR3: 0000000123e40006 CR4: 00000000001706e0
[ 4616.236689] Call Trace:
[ 4616.239428]  blkdev_issue_discard+0x52/0xb0
[ 4616.244108]  blkdev_common_ioctl+0x43c/0xa00
[ 4616.248883]  blkdev_ioctl+0x116/0x280
[ 4616.252977]  __x64_sys_ioctl+0x8a/0xc0
[ 4616.257163]  do_syscall_64+0x5c/0x90
[ 4616.261164]  ? handle_mm_fault+0xc5/0x2a0
[ 4616.265652]  ? do_user_addr_fault+0x1d8/0x690
[ 4616.270527]  ? do_syscall_64+0x69/0x90
[ 4616.274717]  ? exc_page_fault+0x62/0x150
[ 4616.279097]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[ 4616.284748] RIP: 0033:0x7f9a55398c6b

Signed-off-by: Xiao Ni <xni@redhat.com>
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid0.c  | 1 -
 drivers/md/raid10.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 857c49399c28..b536befd8898 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -398,7 +398,6 @@ static int raid0_run(struct mddev *mddev)
 
 		blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, mddev->chunk_sectors);
-		blk_queue_max_discard_sectors(mddev->queue, UINT_MAX);
 
 		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
 		blk_queue_io_opt(mddev->queue,
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3aa8b6e11d58..9a6503f5cb98 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4145,8 +4145,6 @@ static int raid10_run(struct mddev *mddev)
 	conf->thread = NULL;
 
 	if (mddev->queue) {
-		blk_queue_max_discard_sectors(mddev->queue,
-					      UINT_MAX);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
 		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
 		raid10_set_io_opt(conf);
-- 
2.35.1



