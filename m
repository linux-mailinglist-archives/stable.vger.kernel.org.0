Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1D965014B
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiLRQ1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbiLRQ0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:26:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8473D13F98;
        Sun, 18 Dec 2022 08:10:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4791A60DD7;
        Sun, 18 Dec 2022 16:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD94C43392;
        Sun, 18 Dec 2022 16:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379793;
        bh=XLEiZvTkEEAwuhWrHpN9qyqocU/jogGxwcB92TCq5kI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvFAtXjLFq1aRaLpZ6G0X3ZnWZXfxnUVAq7vVaahOjlgWgwsbsBgaT14AtB2O5v9T
         zlOO4MgcvVk352cqmMvVxR7soe9Z6PCIV9GYF7J6c+h2pYE3i0E045cKbe9hTLp7E0
         3qPMIAI7qIFbXQnOxsXWMp2c3Ds4sY1sz7o3KBA3pUYgs61tbZti+C36gb3Ut5iFE6
         1GFnYufH7yFNL7WQNwboHym1hCnzqKSxCSphwXvKl1pVX3VEeVSpXQjj6SyiX7/F+h
         a3LoC8dveSzSrFg1+ZszODi0KjsPIPrA3lQn5Kd41F6FZh4SXzVs+tofx2m7U/j7ME
         Qa2IP46jhcznA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiao Ni <xni@redhat.com>, Yi Zhang <yi.zhang@redhat.com>,
        Ming Lei <ming.lei@redhat.com>, Song Liu <song@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 37/73] md/raid0, raid10: Don't set discard sectors for request queue
Date:   Sun, 18 Dec 2022 11:07:05 -0500
Message-Id: <20221218160741.927862-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 64d6e4cd8a3a..b19c6ce89d5e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4104,8 +4104,6 @@ static int raid10_run(struct mddev *mddev)
 	conf->thread = NULL;
 
 	if (mddev->queue) {
-		blk_queue_max_discard_sectors(mddev->queue,
-					      UINT_MAX);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
 		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
 		raid10_set_io_opt(conf);
-- 
2.35.1

