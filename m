Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0161B63098E
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbiKSCOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234266AbiKSCNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:13:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939F5776FA;
        Fri, 18 Nov 2022 18:12:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F6F862831;
        Sat, 19 Nov 2022 02:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74869C433D7;
        Sat, 19 Nov 2022 02:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823939;
        bh=FYr04vfyjSoFDAZ0lW1wqrJZDHN6z/tNqY0IwKMY5nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJz/FbTQZjHIeaIZjDQf8l8NRWpNyQl1hDmFL/NFdZg606eyIRvCTsUT3IB68tXoU
         pa0LEM/0duFeZd7aF1gTeypMD+lFDcD2SagfppwPP/LEcz0EDuyUf+ic5WdoAuuVai
         AnF+zRx+CNsoulOhfrd9/Yn/ya3Udu5VxlvLA0oiBSY8toLVr4URd/ePke0Yjv1NSs
         cd9CDDbipY3qvMiPd5hCDVRYTgsNSxAqOK/j5cOur+YkCb27P3O/4TSpNQESa4z1JZ
         0FEtORlqQcGzTJnVvuByg5ba8wM99cY/Vd+CBByw/+CNuKvDHNEsAn9PMXBxRQs36+
         YzYfzXb6T5tTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        tj@kernel.org, josef@toxicpanda.com, paolo.valente@linaro.org,
        cgroups@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 28/44] block, bfq: fix null pointer dereference in bfq_bio_bfqg()
Date:   Fri, 18 Nov 2022 21:11:08 -0500
Message-Id: <20221119021124.1773699-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit f02be9002c480cd3ec0fcf184ad27cf531bd6ece ]

Out test found a following problem in kernel 5.10, and the same problem
should exist in mainline:

BUG: kernel NULL pointer dereference, address: 0000000000000094
PGD 0 P4D 0
Oops: 0000 [#1] SMP
CPU: 7 PID: 155 Comm: kworker/7:1 Not tainted 5.10.0-01932-g19e0ace2ca1d-dirty 4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-b4
Workqueue: kthrotld blk_throtl_dispatch_work_fn
RIP: 0010:bfq_bio_bfqg+0x52/0xc0
Code: 94 00 00 00 00 75 2e 48 8b 40 30 48 83 05 35 06 c8 0b 01 48 85 c0 74 3d 4b
RSP: 0018:ffffc90001a1fba0 EFLAGS: 00010002
RAX: ffff888100d60400 RBX: ffff8881132e7000 RCX: 0000000000000000
RDX: 0000000000000017 RSI: ffff888103580a18 RDI: ffff888103580a18
RBP: ffff8881132e7000 R08: 0000000000000000 R09: ffffc90001a1fe10
R10: 0000000000000a20 R11: 0000000000034320 R12: 0000000000000000
R13: ffff888103580a18 R14: ffff888114447000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88881fdc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000094 CR3: 0000000100cdb000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 bfq_bic_update_cgroup+0x3c/0x350
 ? ioc_create_icq+0x42/0x270
 bfq_init_rq+0xfd/0x1060
 bfq_insert_requests+0x20f/0x1cc0
 ? ioc_create_icq+0x122/0x270
 blk_mq_sched_insert_requests+0x86/0x1d0
 blk_mq_flush_plug_list+0x193/0x2a0
 blk_flush_plug_list+0x127/0x170
 blk_finish_plug+0x31/0x50
 blk_throtl_dispatch_work_fn+0x151/0x190
 process_one_work+0x27c/0x5f0
 worker_thread+0x28b/0x6b0
 ? rescuer_thread+0x590/0x590
 kthread+0x153/0x1b0
 ? kthread_flush_work+0x170/0x170
 ret_from_fork+0x1f/0x30
Modules linked in:
CR2: 0000000000000094
---[ end trace e2e59ac014314547 ]---
RIP: 0010:bfq_bio_bfqg+0x52/0xc0
Code: 94 00 00 00 00 75 2e 48 8b 40 30 48 83 05 35 06 c8 0b 01 48 85 c0 74 3d 4b
RSP: 0018:ffffc90001a1fba0 EFLAGS: 00010002
RAX: ffff888100d60400 RBX: ffff8881132e7000 RCX: 0000000000000000
RDX: 0000000000000017 RSI: ffff888103580a18 RDI: ffff888103580a18
RBP: ffff8881132e7000 R08: 0000000000000000 R09: ffffc90001a1fe10
R10: 0000000000000a20 R11: 0000000000034320 R12: 0000000000000000
R13: ffff888103580a18 R14: ffff888114447000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88881fdc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000094 CR3: 0000000100cdb000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Root cause is quite complex:

1) use bfq elevator for the test device.
2) create a cgroup CG
3) config blk throtl in CG

   blkg_conf_prep
    blkg_create

4) create a thread T1 and issue async io in CG:

   bio_init
    bio_associate_blkg
   ...
   submit_bio
    submit_bio_noacct
     blk_throtl_bio -> io is throttled
     // io submit is done

5) switch elevator:

   bfq_exit_queue
    blkcg_deactivate_policy
     list_for_each_entry(blkg, &q->blkg_list, q_node)
      blkg->pd[] = NULL
      // bfq policy is removed

5) thread t1 exist, then remove the cgroup CG:

   blkcg_unpin_online
    blkcg_destroy_blkgs
     blkg_destroy
      list_del_init(&blkg->q_node)
      // blkg is removed from queue list

6) switch elevator back to bfq

 bfq_init_queue
  bfq_create_group_hierarchy
   blkcg_activate_policy
    list_for_each_entry_reverse(blkg, &q->blkg_list)
     // blkg is removed from list, hence bfq policy is still NULL

7) throttled io is dispatched to bfq:

 bfq_insert_requests
  bfq_init_rq
   bfq_bic_update_cgroup
    bfq_bio_bfqg
     bfqg = blkg_to_bfqg(blkg)
     // bfqg is NULL because bfq policy is NULL

The problem is only possible in bfq because only bfq can be deactivated and
activated while queue is online, while others can only be deactivated while
the device is removed.

Fix the problem in bfq by checking if blkg is online before calling
blkg_to_bfqg().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221108103434.2853269-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-cgroup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 30b15a9a47c4..249f489d115f 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -615,6 +615,10 @@ struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
 	struct bfq_group *bfqg;
 
 	while (blkg) {
+		if (!blkg->online) {
+			blkg = blkg->parent;
+			continue;
+		}
 		bfqg = blkg_to_bfqg(blkg);
 		if (bfqg->online) {
 			bio_associate_blkg_from_css(bio, &blkg->blkcg->css);
-- 
2.35.1

