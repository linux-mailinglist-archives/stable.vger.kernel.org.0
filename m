Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A904734CA54
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbhC2Igy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:36:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231797AbhC2Iff (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:35:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8139619BB;
        Mon, 29 Mar 2021 08:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006910;
        bh=Jc0biOn8ajKpHNR/Ryer9lQoSywdZkn5qgvaPyliJbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6fhOwDuS1Ho1AWP/4GnrYRBM7JouyU4t9tMVQeMrwccI54+TV/viXENkjYemgobk
         HSXTjnCUMbEI5tPVbSnn7nqdl6pF2ESdy/Qq41uUhPVYAbRHWVLWFiMmjIwvgd0oc3
         Z/aNWsI3GlU2R1DfGf2QSeYjvUDAnkH4bMiT3KN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+779559d6503f3a56213d@syzkaller.appspotmail.com,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 121/254] drop_monitor: Perform cleanup upon probe registration failure
Date:   Mon, 29 Mar 2021 09:57:17 +0200
Message-Id: <20210329075637.195829511@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 9398e9c0b1d44eeb700e9e766c02bcc765c82570 ]

In the rare case that drop_monitor fails to register its probe on the
'napi_poll' tracepoint, it will not deactivate its hysteresis timer as
part of the error path. If the hysteresis timer was armed by the shortly
lived 'kfree_skb' probe and user space retries to initiate tracing, a
warning will be emitted for trying to initialize an active object [1].

Fix this by properly undoing all the operations that were done prior to
probe registration, in both software and hardware code paths.

Note that syzkaller managed to fail probe registration by injecting a
slab allocation failure [2].

[1]
ODEBUG: init active (active state 0) object type: timer_list hint: sched_send_work+0x0/0x60 include/linux/list.h:135
WARNING: CPU: 1 PID: 8649 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 1 PID: 8649 Comm: syz-executor.0 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
[...]
Call Trace:
 __debug_object_init+0x524/0xd10 lib/debugobjects.c:588
 debug_timer_init kernel/time/timer.c:722 [inline]
 debug_init kernel/time/timer.c:770 [inline]
 init_timer_key+0x2d/0x340 kernel/time/timer.c:814
 net_dm_trace_on_set net/core/drop_monitor.c:1111 [inline]
 set_all_monitor_traces net/core/drop_monitor.c:1188 [inline]
 net_dm_monitor_start net/core/drop_monitor.c:1295 [inline]
 net_dm_cmd_trace+0x720/0x1220 net/core/drop_monitor.c:1339
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2348
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2402
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2435
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

[2]
 FAULT_INJECTION: forcing a failure.
 name failslab, interval 1, probability 0, space 0, times 1
 CPU: 1 PID: 8645 Comm: syz-executor.0 Not tainted 5.11.0-syzkaller #0
 Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
 Call Trace:
  dump_stack+0xfa/0x151
  should_fail.cold+0x5/0xa
  should_failslab+0x5/0x10
  __kmalloc+0x72/0x3f0
  tracepoint_add_func+0x378/0x990
  tracepoint_probe_register+0x9c/0xe0
  net_dm_cmd_trace+0x7fc/0x1220
  genl_family_rcv_msg_doit+0x228/0x320
  genl_rcv_msg+0x328/0x580
  netlink_rcv_skb+0x153/0x420
  genl_rcv+0x24/0x40
  netlink_unicast+0x533/0x7d0
  netlink_sendmsg+0x856/0xd90
  sock_sendmsg+0xcf/0x120
  ____sys_sendmsg+0x6e8/0x810
  ___sys_sendmsg+0xf3/0x170
  __sys_sendmsg+0xe5/0x1b0
  do_syscall_64+0x2d/0x70
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 70c69274f354 ("drop_monitor: Initialize timer and work item upon tracing enable")
Fixes: 8ee2267ad33e ("drop_monitor: Convert to using devlink tracepoint")
Reported-by: syzbot+779559d6503f3a56213d@syzkaller.appspotmail.com
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/drop_monitor.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 571f191c06d9..db65ce62b625 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1053,6 +1053,20 @@ static int net_dm_hw_monitor_start(struct netlink_ext_ack *extack)
 	return 0;
 
 err_module_put:
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_dm_data *hw_data = &per_cpu(dm_hw_cpu_data, cpu);
+		struct sk_buff *skb;
+
+		del_timer_sync(&hw_data->send_timer);
+		cancel_work_sync(&hw_data->dm_alert_work);
+		while ((skb = __skb_dequeue(&hw_data->drop_queue))) {
+			struct devlink_trap_metadata *hw_metadata;
+
+			hw_metadata = NET_DM_SKB_CB(skb)->hw_metadata;
+			net_dm_hw_metadata_free(hw_metadata);
+			consume_skb(skb);
+		}
+	}
 	module_put(THIS_MODULE);
 	return rc;
 }
@@ -1134,6 +1148,15 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 err_unregister_trace:
 	unregister_trace_kfree_skb(ops->kfree_skb_probe, NULL);
 err_module_put:
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
+		struct sk_buff *skb;
+
+		del_timer_sync(&data->send_timer);
+		cancel_work_sync(&data->dm_alert_work);
+		while ((skb = __skb_dequeue(&data->drop_queue)))
+			consume_skb(skb);
+	}
 	module_put(THIS_MODULE);
 	return rc;
 }
-- 
2.30.1



