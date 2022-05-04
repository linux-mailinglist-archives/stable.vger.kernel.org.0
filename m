Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE3C51A995
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355933AbiEDRSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356745AbiEDROF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852B453B75;
        Wed,  4 May 2022 09:58:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23F01618E8;
        Wed,  4 May 2022 16:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1E4C385AF;
        Wed,  4 May 2022 16:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683493;
        bh=lZSgcARiKu563cMVPF9TLhAYaBQcnyIOkxgPX0ZQyPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UIAonYcqcjz9dO3vVTkQOVVA4faMdQfVuDuG1nqYcH0dG+lB37NyNl1Q/XgEjR4/X
         tB62SyHqG5wF4TxV9Fd6QEOPCYyBefN2hJLweP8AW45nSsuTDvA3G5F2OCUN1ALcLY
         x0ql/x85ET8IDWE29dvZ99mEYG3J4INAnnLjff34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongyu Jin <hongyu.jin@unisoc.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Chao Yu <chao@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 168/225] erofs: fix use-after-free of on-stack io[]
Date:   Wed,  4 May 2022 18:46:46 +0200
Message-Id: <20220504153125.086107183@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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



