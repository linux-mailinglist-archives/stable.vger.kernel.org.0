Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA636AF54A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbjCGTYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbjCGTXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:23:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E846AA403C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:09:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2875B817C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA880C433EF;
        Tue,  7 Mar 2023 19:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216153;
        bh=kSa5fo1dlKimv7z6D7HoV5rRTyqvKOTO+gFtH7ck1iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mg89bCP1gmYPATDffl/f1/78y/ouc0I1Tpn0jEqitQDJGYLVMaBs1uWfLsay/6jXC
         UB96/PH2dQpOJaIUo86C633jHlK6ee9crjfWtZoT4GG8dkYT2Rz45d22lty2T4lu06
         gj8G9WHySBnjcrVPYtgKe58Vj6nMspSa7lbTX+ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 492/567] io_uring: add a conditional reschedule to the IOPOLL cancelation loop
Date:   Tue,  7 Mar 2023 18:03:48 +0100
Message-Id: <20230307165927.269566625@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit fcc926bb857949dbfa51a7d95f3f5ebc657f198c upstream.

If the kernel is configured with CONFIG_PREEMPT_NONE, we could be
sitting in a tight loop reaping events but not giving them a chance to
finish. This results in a trace ala:

rcu: INFO: rcu_sched self-detected stall on CPU
rcu:    2-...!: (5249 ticks this GP) idle=935c/1/0x4000000000000000 softirq=4265/4274 fqs=1
        (t=5251 jiffies g=465 q=4135 ncpus=4)
rcu: rcu_sched kthread starved for 5249 jiffies! g465 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu:    Unless rcu_sched kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_sched       state:R  running task     stack:0     pid:12    ppid:2      flags:0x00000008
Call trace:
 __switch_to+0xb0/0xc8
 __schedule+0x43c/0x520
 schedule+0x4c/0x98
 schedule_timeout+0xbc/0xdc
 rcu_gp_fqs_loop+0x308/0x344
 rcu_gp_kthread+0xd8/0xf0
 kthread+0xb8/0xc8
 ret_from_fork+0x10/0x20
rcu: Stack dump where RCU GP kthread last ran:
Task dump for CPU 0:
task:kworker/u8:10   state:R  running task     stack:0     pid:89    ppid:2      flags:0x0000000a
Workqueue: events_unbound io_ring_exit_work
Call trace:
 __switch_to+0xb0/0xc8
 0xffff0000c8fefd28
CPU: 2 PID: 95 Comm: kworker/u8:13 Not tainted 6.2.0-rc5-00042-g40316e337c80-dirty #2759
Hardware name: linux,dummy-virt (DT)
Workqueue: events_unbound io_ring_exit_work
pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
pc : io_do_iopoll+0x344/0x360
lr : io_do_iopoll+0xb8/0x360
sp : ffff800009bebc60
x29: ffff800009bebc60 x28: 0000000000000000 x27: 0000000000000000
x26: ffff0000c0f67d48 x25: ffff0000c0f67840 x24: ffff800008950024
x23: 0000000000000001 x22: 0000000000000000 x21: ffff0000c27d3200
x20: ffff0000c0f67840 x19: ffff0000c0f67800 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000001 x13: 0000000000000001 x12: 0000000000000000
x11: 0000000000000179 x10: 0000000000000870 x9 : ffff800009bebd60
x8 : ffff0000c27d3ad0 x7 : fefefefefefefeff x6 : 0000646e756f626e
x5 : ffff0000c0f67840 x4 : 0000000000000000 x3 : ffff0000c2398000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_do_iopoll+0x344/0x360
 io_uring_try_cancel_requests+0x21c/0x334
 io_ring_exit_work+0x90/0x40c
 process_one_work+0x1a4/0x254
 worker_thread+0x1ec/0x258
 kthread+0xb8/0xc8
 ret_from_fork+0x10/0x20

Add a cond_resched() in the cancelation IOPOLL loop to fix this.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -9861,6 +9861,7 @@ static void io_uring_try_cancel_requests
 			while (!list_empty_careful(&ctx->iopoll_list)) {
 				io_iopoll_try_reap_events(ctx);
 				ret = true;
+				cond_resched();
 			}
 		}
 


