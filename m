Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA60A5107F7
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353626AbiDZTFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353569AbiDZTFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BD7199168;
        Tue, 26 Apr 2022 12:02:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8B36DCE20EE;
        Tue, 26 Apr 2022 19:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1E0C385AF;
        Tue, 26 Apr 2022 19:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999724;
        bh=lZSgcARiKu563cMVPF9TLhAYaBQcnyIOkxgPX0ZQyPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJ+h3nGs0WIRmXyRDFcnxccbAvEBreyfrwWZJ4KS+oEj3XsVqDQV9+7aEhsKpBVva
         je6xFRnVpZpuC30gdMdSUab09P7sWVOlvG/hoHzKnsau2LCnHJXURVT0ASTGuLQ0Mo
         CEOlwdDrqgpoab5NUO9ZEPSHkyLj5XSgitV+kGWLzGQ7LxplmWwAUGBw5XjtBZTVO9
         9OcFcKTsmf2qK0/Tg08POWlnqR5gypmuJnvDsClzTseu/1Tjttrw88skoYZzCfs1yX
         zVlN6RWv2/a5BKXmtSTRVWoZdSSX+Dsmsu1EeZw/ZY6GpMJAOtkSSWXMQWjDNCEbmt
         eTl7yJoN9S9vw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hongyu Jin <hongyu.jin@unisoc.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Chao Yu <chao@kernel.org>, Sasha Levin <sashal@kernel.org>,
        xiang@kernel.org, linux-erofs@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.17 13/22] erofs: fix use-after-free of on-stack io[]
Date:   Tue, 26 Apr 2022 15:01:36 -0400
Message-Id: <20220426190145.2351135-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190145.2351135-1-sashal@kernel.org>
References: <20220426190145.2351135-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hongyu Jin <hongyu.jin@unisoc.com>

[ Upstream commit 60b30050116c0351b90154044345c1b53ae1f323 ]

The root cause is the race as follows:
Thread #1                              Thread #2(irq ctx)

z_erofs_runqueue()
  struct z_erofs_decompressqueue io_A[];
  submit bio A
  z_erofs_decompress_kickoff(,,1)
                                       z_erofs_decompressqueue_endio(bio A)
                                       z_erofs_decompress_kickoff(,,-1)
                                       spin_lock_irqsave()
                                       atomic_add_return()
  io_wait_event()	-> pending_bios is already 0
  [end of function]
                                       wake_up_locked(io_A[]) // crash

Referenced backtrace in kernel 5.4:

[   10.129422] Unable to handle kernel paging request at virtual address eb0454a4
[   10.364157] CPU: 0 PID: 709 Comm: getprop Tainted: G        WC O      5.4.147-ab09225 #1
[   11.556325] [<c01b33b8>] (__wake_up_common) from [<c01b3300>] (__wake_up_locked+0x40/0x48)
[   11.565487] [<c01b3300>] (__wake_up_locked) from [<c044c8d0>] (z_erofs_vle_unzip_kickoff+0x6c/0xc0)
[   11.575438] [<c044c8d0>] (z_erofs_vle_unzip_kickoff) from [<c044c854>] (z_erofs_vle_read_endio+0x16c/0x17c)
[   11.586082] [<c044c854>] (z_erofs_vle_read_endio) from [<c06a80e8>] (clone_endio+0xb4/0x1d0)
[   11.595428] [<c06a80e8>] (clone_endio) from [<c04a1280>] (blk_update_request+0x150/0x4dc)
[   11.604516] [<c04a1280>] (blk_update_request) from [<c06dea28>] (mmc_blk_cqe_complete_rq+0x144/0x15c)
[   11.614640] [<c06dea28>] (mmc_blk_cqe_complete_rq) from [<c04a5d90>] (blk_done_softirq+0xb0/0xcc)
[   11.624419] [<c04a5d90>] (blk_done_softirq) from [<c010242c>] (__do_softirq+0x184/0x56c)
[   11.633419] [<c010242c>] (__do_softirq) from [<c01051e8>] (irq_exit+0xd4/0x138)
[   11.641640] [<c01051e8>] (irq_exit) from [<c010c314>] (__handle_domain_irq+0x94/0xd0)
[   11.650381] [<c010c314>] (__handle_domain_irq) from [<c04fde70>] (gic_handle_irq+0x50/0xd4)
[   11.659641] [<c04fde70>] (gic_handle_irq) from [<c0101b70>] (__irq_svc+0x70/0xb0)

Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20220401115527.4935-1-hongyu.jin.cn@gmail.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 12 ++++--------
 fs/erofs/zdata.h |  2 +-
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 423bc1a61da5..a1b48bcafe63 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1073,12 +1073,9 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 
 	/* wake up the caller thread for sync decompression */
 	if (sync) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&io->u.wait.lock, flags);
 		if (!atomic_add_return(bios, &io->pending_bios))
-			wake_up_locked(&io->u.wait);
-		spin_unlock_irqrestore(&io->u.wait.lock, flags);
+			complete(&io->u.done);
+
 		return;
 	}
 
@@ -1224,7 +1221,7 @@ jobqueue_init(struct super_block *sb,
 	} else {
 fg_out:
 		q = fgq;
-		init_waitqueue_head(&fgq->u.wait);
+		init_completion(&fgq->u.done);
 		atomic_set(&fgq->pending_bios, 0);
 	}
 	q->sb = sb;
@@ -1428,8 +1425,7 @@ static void z_erofs_runqueue(struct super_block *sb,
 		return;
 
 	/* wait until all bios are completed */
-	io_wait_event(io[JQ_SUBMIT].u.wait,
-		      !atomic_read(&io[JQ_SUBMIT].pending_bios));
+	wait_for_completion_io(&io[JQ_SUBMIT].u.done);
 
 	/* handle synchronous decompress queue in the caller context */
 	z_erofs_decompress_queue(&io[JQ_SUBMIT], pagepool);
diff --git a/fs/erofs/zdata.h b/fs/erofs/zdata.h
index e043216b545f..800b11c53f57 100644
--- a/fs/erofs/zdata.h
+++ b/fs/erofs/zdata.h
@@ -97,7 +97,7 @@ struct z_erofs_decompressqueue {
 	z_erofs_next_pcluster_t head;
 
 	union {
-		wait_queue_head_t wait;
+		struct completion done;
 		struct work_struct work;
 	} u;
 };
-- 
2.35.1

