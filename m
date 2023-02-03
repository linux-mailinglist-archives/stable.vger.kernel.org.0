Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10896896CE
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbjBCKdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbjBCKc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:32:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F2987D29
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:30:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8A6261EC7
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE760C433D2;
        Fri,  3 Feb 2023 10:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420231;
        bh=aOR7yfgqGr7mCMb0WWcBi6CbdGZox3hQXdT4xKs6VnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4kWKLb599Z17UhcL03/RyTdOr/3TLWO/JdDJ/CpvCs2LlEQiA/G+mwTWdwVWp709
         34tHx318fJGgs1VXXo9r7S44GvXzxYmGNtpy+YrU1qNxilA52K5msXrHny68j5AtO6
         XGy8StoGeTrmqcEiFnN+oA4VlFO7gLoxwdNmSndQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/134] net/sched: sch_taprio: do not schedule in taprio_reset()
Date:   Fri,  3 Feb 2023 11:13:19 +0100
Message-Id: <20230203101028.091340710@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ea4fdbaa2f7798cb25adbe4fd52ffc6356f097bb ]

As reported by syzbot and hinted by Vinicius, I should not have added
a qdisc_synchronize() call in taprio_reset()

taprio_reset() can be called with qdisc spinlock held (and BH disabled)
as shown in included syzbot report [1].

Only taprio_destroy() needed this synchronization, as explained
in the blamed commit changelog.

[1]

BUG: scheduling while atomic: syz-executor150/5091/0x00000202
2 locks held by syz-executor150/5091:
Modules linked in:
Preemption disabled at:
[<0000000000000000>] 0x0
Kernel panic - not syncing: scheduling while atomic: panic_on_warn set ...
CPU: 1 PID: 5091 Comm: syz-executor150 Not tainted 6.2.0-rc3-syzkaller-00219-g010a74f52203 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
panic+0x2cc/0x626 kernel/panic.c:318
check_panic_on_warn.cold+0x19/0x35 kernel/panic.c:238
__schedule_bug.cold+0xd5/0xfe kernel/sched/core.c:5836
schedule_debug kernel/sched/core.c:5865 [inline]
__schedule+0x34e4/0x5450 kernel/sched/core.c:6500
schedule+0xde/0x1b0 kernel/sched/core.c:6682
schedule_timeout+0x14e/0x2a0 kernel/time/timer.c:2167
schedule_timeout_uninterruptible kernel/time/timer.c:2201 [inline]
msleep+0xb6/0x100 kernel/time/timer.c:2322
qdisc_synchronize include/net/sch_generic.h:1295 [inline]
taprio_reset+0x93/0x270 net/sched/sch_taprio.c:1703
qdisc_reset+0x10c/0x770 net/sched/sch_generic.c:1022
dev_reset_queue+0x92/0x130 net/sched/sch_generic.c:1285
netdev_for_each_tx_queue include/linux/netdevice.h:2464 [inline]
dev_deactivate_many+0x36d/0x9f0 net/sched/sch_generic.c:1351
dev_deactivate+0xed/0x1b0 net/sched/sch_generic.c:1374
qdisc_graft+0xe4a/0x1380 net/sched/sch_api.c:1080
tc_modify_qdisc+0xb6b/0x19a0 net/sched/sch_api.c:1689
rtnetlink_rcv_msg+0x43e/0xca0 net/core/rtnetlink.c:6141
netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg+0xd3/0x120 net/socket.c:734
____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
__sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
do_syscall_x64 arch/x86/entry/common.c:50 [inline]

Fixes: 3a415d59c1db ("net/sched: sch_taprio: fix possible use-after-free")
Link: https://lore.kernel.org/netdev/167387581653.2747.13878941339893288655.git-patchwork-notify@kernel.org/T/
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://lore.kernel.org/r/20230123084552.574396-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 4278a466cb50..b7bd8c3e3158 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1622,7 +1622,6 @@ static void taprio_reset(struct Qdisc *sch)
 	int i;
 
 	hrtimer_cancel(&q->advance_timer);
-	qdisc_synchronize(sch);
 
 	if (q->qdiscs) {
 		for (i = 0; i < dev->num_tx_queues && q->qdiscs[i]; i++)
-- 
2.39.0



