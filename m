Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287155FD29C
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 03:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiJMBc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 21:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJMBcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 21:32:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F38961D4A;
        Wed, 12 Oct 2022 18:32:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1118C616C0;
        Thu, 13 Oct 2022 00:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6A0C4347C;
        Thu, 13 Oct 2022 00:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620804;
        bh=pDfWdgrmGL3v4gY+NvOwF/FcqsCCUIwrxA9uS0UWmtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=etsSi+J1zes3vHxAasqhzOjLN1iAZih0wJ1hzPTljjG/fEFzQzKT1blUZwm50RSqp
         x37bUYlG1h0UaKgf2SjLtu7qdCgBGvEq2iOxwcZDNkJQkwPO1EZFx09RoNjkiLO8bc
         EyCmpP2hxY8CDeXhLzDzqJ67e45y4L5+OlsupW1CoV6ivQ3j8VV3lPNXsgnEkg4Ow3
         1PDU/DZuPHFNpsdrAuxIToisbvgIfcqgVNOdb76KN/Qj5Unc/3bJJfv/z11Lp11Z/S
         hNfV0Q+JfY0pV3hZ1ULKwW880lVflN205t8h3MInSfNPsQfiAv58tgLWv95dzQ/LA8
         nj9B0VL47lJ1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Logan Gunthorpe <logang@deltatee.com>, Song Liu <song@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/19] md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d
Date:   Wed, 12 Oct 2022 20:26:09 -0400
Message-Id: <20221013002623.1895576-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002623.1895576-1-sashal@kernel.org>
References: <20221013002623.1895576-1-sashal@kernel.org>
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

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 5e2cf333b7bd5d3e62595a44d598a254c697cd74 ]

A complicated deadlock exists when using the journal and an elevated
group_thrtead_cnt. It was found with loop devices, but its not clear
whether it can be seen with real disks. The deadlock can occur simply
by writing data with an fio script.

When the deadlock occurs, multiple threads will hang in different ways:

 1) The group threads will hang in the blk-wbt code with bios waiting to
    be submitted to the block layer:

        io_schedule+0x70/0xb0
        rq_qos_wait+0x153/0x210
        wbt_wait+0x115/0x1b0
        io_schedule+0x70/0xb0
        rq_qos_wait+0x153/0x210
        wbt_wait+0x115/0x1b0
        __rq_qos_throttle+0x38/0x60
        blk_mq_submit_bio+0x589/0xcd0
        wbt_wait+0x115/0x1b0
        __rq_qos_throttle+0x38/0x60
        blk_mq_submit_bio+0x589/0xcd0
        __submit_bio+0xe6/0x100
        submit_bio_noacct_nocheck+0x42e/0x470
        submit_bio_noacct+0x4c2/0xbb0
        ops_run_io+0x46b/0x1a30
        handle_stripe+0xcd3/0x36b0
        handle_active_stripes.constprop.0+0x6f6/0xa60
        raid5_do_work+0x177/0x330

    Or:
        io_schedule+0x70/0xb0
        rq_qos_wait+0x153/0x210
        wbt_wait+0x115/0x1b0
        __rq_qos_throttle+0x38/0x60
        blk_mq_submit_bio+0x589/0xcd0
        __submit_bio+0xe6/0x100
        submit_bio_noacct_nocheck+0x42e/0x470
        submit_bio_noacct+0x4c2/0xbb0
        flush_deferred_bios+0x136/0x170
        raid5_do_work+0x262/0x330

 2) The r5l_reclaim thread will hang in the same way, submitting a
    bio to the block layer:

        io_schedule+0x70/0xb0
        rq_qos_wait+0x153/0x210
        wbt_wait+0x115/0x1b0
        __rq_qos_throttle+0x38/0x60
        blk_mq_submit_bio+0x589/0xcd0
        __submit_bio+0xe6/0x100
        submit_bio_noacct_nocheck+0x42e/0x470
        submit_bio_noacct+0x4c2/0xbb0
        submit_bio+0x3f/0xf0
        md_super_write+0x12f/0x1b0
        md_update_sb.part.0+0x7c6/0xff0
        md_update_sb+0x30/0x60
        r5l_do_reclaim+0x4f9/0x5e0
        r5l_reclaim_thread+0x69/0x30b

    However, before hanging, the MD_SB_CHANGE_PENDING flag will be
    set for sb_flags in r5l_write_super_and_discard_space(). This
    flag will never be cleared because the submit_bio() call never
    returns.

 3) Due to the MD_SB_CHANGE_PENDING flag being set, handle_stripe()
    will do no processing on any pending stripes and re-set
    STRIPE_HANDLE. This will cause the raid5d thread to enter an
    infinite loop, constantly trying to handle the same stripes
    stuck in the queue.

    The raid5d thread has a blk_plug that holds a number of bios
    that are also stuck waiting seeing the thread is in a loop
    that never schedules. These bios have been accounted for by
    blk-wbt thus preventing the other threads above from
    continuing when they try to submit bios. --Deadlock.

To fix this, add the same wait_event() that is used in raid5_do_work()
to raid5d() such that if MD_SB_CHANGE_PENDING is set, the thread will
schedule and wait until the flag is cleared. The schedule action will
flush the plug which will allow the r5l_reclaim thread to continue,
thus preventing the deadlock.

However, md_check_recovery() calls can also clear MD_SB_CHANGE_PENDING
from the same thread and can thus deadlock if the thread is put to
sleep. So avoid waiting if md_check_recovery() is being called in the
loop.

It's not clear when the deadlock was introduced, but the similar
wait_event() call in raid5_do_work() was added in 2017 by this
commit:

    16d997b78b15 ("md/raid5: simplfy delaying of writes while metadata
                   is updated.")

Link: https://lore.kernel.org/r/7f3b87b6-b52a-f737-51d7-a4eec5c44112@deltatee.com
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6f04473f0838..cf021a7801d6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -44,6 +44,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
@@ -6329,7 +6330,18 @@ static void raid5d(struct md_thread *thread)
 			spin_unlock_irq(&conf->device_lock);
 			md_check_recovery(mddev);
 			spin_lock_irq(&conf->device_lock);
+
+			/*
+			 * Waiting on MD_SB_CHANGE_PENDING below may deadlock
+			 * seeing md_check_recovery() is needed to clear
+			 * the flag when using mdmon.
+			 */
+			continue;
 		}
+
+		wait_event_lock_irq(mddev->sb_wait,
+			!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
+			conf->device_lock);
 	}
 	pr_debug("%d stripes handled\n", handled);
 
-- 
2.35.1

