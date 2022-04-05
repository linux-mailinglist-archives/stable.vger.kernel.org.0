Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157CF4F2E6C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237799AbiDEJEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242936AbiDEItm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:49:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B238BE34;
        Tue,  5 Apr 2022 01:37:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EF18B81C69;
        Tue,  5 Apr 2022 08:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0509C385A0;
        Tue,  5 Apr 2022 08:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147861;
        bh=1SEV+0+k6YRHwzV5O41lcxbDLNWYL1ygIQhLSS3pFZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=09wyhEl0iSf0FCU/javc3ZryaEjQPcALPoHbo6ewIj6Us78RcfrO1ksoIZVFfXpt1
         5iRSr2xtk9xdd1IZz92dbe3yGfOd3/zzEUb9v9FGZy5ktIWA1FD1qrOpkAJXUkZBs+
         89P2NslL+E8saS+rfDC0Ioklp9KE1lqSpkX9OoJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 0147/1017] block: limit request dispatch loop duration
Date:   Tue,  5 Apr 2022 09:17:40 +0200
Message-Id: <20220405070358.569266137@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit 572299f03afd676dd4e20669cdaf5ed0fe1379d4 upstream.

When IO requests are made continuously and the target block device
handles requests faster than request arrival, the request dispatch loop
keeps on repeating to dispatch the arriving requests very long time,
more than a minute. Since the loop runs as a workqueue worker task, the
very long loop duration triggers workqueue watchdog timeout and BUG [1].

To avoid the very long loop duration, break the loop periodically. When
opportunity to dispatch requests still exists, check need_resched(). If
need_resched() returns true, the dispatch loop already consumed its time
slice, then reschedule the dispatch work and break the loop. With heavy
IO load, need_resched() does not return true for 20~30 seconds. To cover
such case, check time spent in the dispatch loop with jiffies. If more
than 1 second is spent, reschedule the dispatch work and break the loop.

[1]

[  609.691437] BUG: workqueue lockup - pool cpus=10 node=1 flags=0x0 nice=-20 stuck for 35s!
[  609.701820] Showing busy workqueues and worker pools:
[  609.707915] workqueue events: flags=0x0
[  609.712615]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
[  609.712626]     pending: drm_fb_helper_damage_work [drm_kms_helper]
[  609.712687] workqueue events_freezable: flags=0x4
[  609.732943]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
[  609.732952]     pending: pci_pme_list_scan
[  609.732968] workqueue events_power_efficient: flags=0x80
[  609.751947]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
[  609.751955]     pending: neigh_managed_work
[  609.752018] workqueue kblockd: flags=0x18
[  609.769480]   pwq 21: cpus=10 node=1 flags=0x0 nice=-20 active=3/256 refcnt=4
[  609.769488]     in-flight: 1020:blk_mq_run_work_fn
[  609.769498]     pending: blk_mq_timeout_work, blk_mq_run_work_fn
[  609.769744] pool 21: cpus=10 node=1 flags=0x0 nice=-20 hung=35s workers=2 idle: 67
[  639.899730] BUG: workqueue lockup - pool cpus=10 node=1 flags=0x0 nice=-20 stuck for 66s!
[  639.909513] Showing busy workqueues and worker pools:
[  639.915404] workqueue events: flags=0x0
[  639.920197]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
[  639.920215]     pending: drm_fb_helper_damage_work [drm_kms_helper]
[  639.920365] workqueue kblockd: flags=0x18
[  639.939932]   pwq 21: cpus=10 node=1 flags=0x0 nice=-20 active=3/256 refcnt=4
[  639.939942]     in-flight: 1020:blk_mq_run_work_fn
[  639.939955]     pending: blk_mq_timeout_work, blk_mq_run_work_fn
[  639.940212] pool 21: cpus=10 node=1 flags=0x0 nice=-20 hung=66s workers=2 idle: 67

Fixes: 6e6fcbc27e778 ("blk-mq: support batching dispatch in case of io")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: stable@vger.kernel.org # v5.10+
Link: https://lore.kernel.org/linux-block/20220310091649.zypaem5lkyfadymg@shindev/
Link: https://lore.kernel.org/r/20220318022641.133484-1-shinichiro.kawasaki@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq-sched.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -206,11 +206,18 @@ static int __blk_mq_do_dispatch_sched(st
 
 static int blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
 {
+	unsigned long end = jiffies + HZ;
 	int ret;
 
 	do {
 		ret = __blk_mq_do_dispatch_sched(hctx);
-	} while (ret == 1);
+		if (ret != 1)
+			break;
+		if (need_resched() || time_is_before_jiffies(end)) {
+			blk_mq_delay_run_hw_queue(hctx, 0);
+			break;
+		}
+	} while (1);
 
 	return ret;
 }


