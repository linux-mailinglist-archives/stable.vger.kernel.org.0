Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA08F657DA2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbiL1PpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbiL1PpO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:45:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBD1175B3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:45:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AF856155C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8C6C433EF;
        Wed, 28 Dec 2022 15:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242312;
        bh=XezicBxC7vh4bZiwu9P39wBjQZUNgrg3LNoA3ip5Vd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4QcPrYZp4GgnFJE5xpnJCliBPY9AvNmlxnP1ReVJP04INDhO/Ea5v52ZX7C5mOPE
         E+Cs8mslRlZ0EGn7rxNLDbXkpEZi+Dydbauath9REKkCTaWGPnyQyrwaYDkXWbR6FH
         M4kP7Kmei+4ibqpGN21Mwn3HzZDBBLyk3ZUdmm/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Yu Kuai <yukuai3@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 587/731] block, bfq: fix possible uaf for bfqq->bic
Date:   Wed, 28 Dec 2022 15:41:34 +0100
Message-Id: <20221228144313.561564440@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 64dc8c732f5c2b406cc752e6aaa1bd5471159cab ]

Our test report a uaf for 'bfqq->bic' in 5.10:

==================================================================
BUG: KASAN: use-after-free in bfq_select_queue+0x378/0xa30

CPU: 6 PID: 2318352 Comm: fsstress Kdump: loaded Not tainted 5.10.0-60.18.0.50.h602.kasan.eulerosv2r11.x86_64 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58-20220320_160524-szxrtosci10000 04/01/2014
Call Trace:
 bfq_select_queue+0x378/0xa30
 bfq_dispatch_request+0xe8/0x130
 blk_mq_do_dispatch_sched+0x62/0xb0
 __blk_mq_sched_dispatch_requests+0x215/0x2a0
 blk_mq_sched_dispatch_requests+0x8f/0xd0
 __blk_mq_run_hw_queue+0x98/0x180
 __blk_mq_delay_run_hw_queue+0x22b/0x240
 blk_mq_run_hw_queue+0xe3/0x190
 blk_mq_sched_insert_requests+0x107/0x200
 blk_mq_flush_plug_list+0x26e/0x3c0
 blk_finish_plug+0x63/0x90
 __iomap_dio_rw+0x7b5/0x910
 iomap_dio_rw+0x36/0x80
 ext4_dio_read_iter+0x146/0x190 [ext4]
 ext4_file_read_iter+0x1e2/0x230 [ext4]
 new_sync_read+0x29f/0x400
 vfs_read+0x24e/0x2d0
 ksys_read+0xd5/0x1b0
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x61/0xc6

Commit 3bc5e683c67d ("bfq: Split shared queues on move between cgroups")
changes that move process to a new cgroup will allocate a new bfqq to
use, however, the old bfqq and new bfqq can point to the same bic:

1) Initial state, two process with io in the same cgroup.

Process 1       Process 2
 (BIC1)          (BIC2)
  |  Λ            |  Λ
  |  |            |  |
  V  |            V  |
  bfqq1           bfqq2

2) bfqq1 is merged to bfqq2.

Process 1       Process 2
 (BIC1)          (BIC2)
  |               |
   \-------------\|
                  V
  bfqq1           bfqq2(coop)

3) Process 1 exit, then issue new io(denoce IOA) from Process 2.

 (BIC2)
  |  Λ
  |  |
  V  |
  bfqq2(coop)

4) Before IOA is completed, move Process 2 to another cgroup and issue io.

Process 2
 (BIC2)
   Λ
   |\--------------\
   |                V
  bfqq2           bfqq3

Now that BIC2 points to bfqq3, while bfqq2 and bfqq3 both point to BIC2.
If all the requests are completed, and Process 2 exit, BIC2 will be
freed while there is no guarantee that bfqq2 will be freed before BIC2.

Fix the problem by clearing bfqq->bic while bfqq is detached from bic.

Fixes: 3bc5e683c67d ("bfq: Split shared queues on move between cgroups")
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221214030430.3304151-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index f21b861a0d66..b8b6e9eae94b 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -386,6 +386,12 @@ static void bfq_put_stable_ref(struct bfq_queue *bfqq);
 
 void bic_set_bfqq(struct bfq_io_cq *bic, struct bfq_queue *bfqq, bool is_sync)
 {
+	struct bfq_queue *old_bfqq = bic->bfqq[is_sync];
+
+	/* Clear bic pointer if bfqq is detached from this bic */
+	if (old_bfqq && old_bfqq->bic == bic)
+		old_bfqq->bic = NULL;
+
 	/*
 	 * If bfqq != NULL, then a non-stable queue merge between
 	 * bic->bfqq and bfqq is happening here. This causes troubles
@@ -5245,7 +5251,6 @@ static void bfq_exit_icq_bfqq(struct bfq_io_cq *bic, bool is_sync)
 		unsigned long flags;
 
 		spin_lock_irqsave(&bfqd->lock, flags);
-		bfqq->bic = NULL;
 		bfq_exit_bfqq(bfqd, bfqq);
 		bic_set_bfqq(bic, NULL, is_sync);
 		spin_unlock_irqrestore(&bfqd->lock, flags);
-- 
2.35.1



