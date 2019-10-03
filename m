Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E879FCAB56
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388783AbfJCQPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388770AbfJCQPC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:15:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5856420700;
        Thu,  3 Oct 2019 16:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119300;
        bh=WqMEXr3WLrWyWaK6Cq1JyEiT1hv2oun49bhJwGXYrdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUTkG/5aQb0XyGdpgeW/1ftqmvAVKAvBMiYNECubSyOQHEgJFpj7wbxKBbSbvakK/
         OHRBSzsEBGPhLXrxhYq3uj1Z4hkgIk4m4HEP66nurCNDccHhMJPCnCxtp9TRyOo5Pf
         p316BraOEAQJN1N9+LQNi4Em/bZcLYXZNEHzDBu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 015/211] net: sched: fix possible crash in tcf_action_destroy()
Date:   Thu,  3 Oct 2019 17:51:21 +0200
Message-Id: <20191003154450.323116782@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3d66b89c30f9220a72e92847768fc8ba4d027d88 ]

If the allocation done in tcf_exts_init() failed,
we end up with a NULL pointer in exts->actions.

kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8198 Comm: syz-executor.3 Not tainted 5.3.0-rc8+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:tcf_action_destroy+0x71/0x160 net/sched/act_api.c:705
Code: c3 08 44 89 ee e8 4f cb bb fb 41 83 fd 20 0f 84 c9 00 00 00 e8 c0 c9 bb fb 48 89 d8 48 b9 00 00 00 00 00 fc ff df 48 c1 e8 03 <80> 3c 08 00 0f 85 c0 00 00 00 4c 8b 33 4d 85 f6 0f 84 9d 00 00 00
RSP: 0018:ffff888096e16ff0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: dffffc0000000000
RDX: 0000000000040000 RSI: ffffffff85b6ab30 RDI: 0000000000000000
RBP: ffff888096e17020 R08: ffff8880993f6140 R09: fffffbfff11cae67
R10: fffffbfff11cae66 R11: ffffffff88e57333 R12: 0000000000000000
R13: 0000000000000000 R14: ffff888096e177a0 R15: 0000000000000001
FS:  00007f62bc84a700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000758040 CR3: 0000000088b64000 CR4: 00000000001426e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tcf_exts_destroy+0x38/0xb0 net/sched/cls_api.c:3030
 tcindex_set_parms+0xf7f/0x1e50 net/sched/cls_tcindex.c:488
 tcindex_change+0x230/0x318 net/sched/cls_tcindex.c:519
 tc_new_tfilter+0xa4b/0x1c70 net/sched/cls_api.c:2152
 rtnetlink_rcv_msg+0x838/0xb00 net/core/rtnetlink.c:5214
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5241
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:657
 ___sys_sendmsg+0x3e2/0x920 net/socket.c:2311
 __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]

Fixes: 90b73b77d08e ("net: sched: change action API to use array of pointers to actions")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Vlad Buslov <vladbu@mellanox.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_api.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2038,8 +2038,10 @@ out:
 void tcf_exts_destroy(struct tcf_exts *exts)
 {
 #ifdef CONFIG_NET_CLS_ACT
-	tcf_action_destroy(exts->actions, TCA_ACT_UNBIND);
-	kfree(exts->actions);
+	if (exts->actions) {
+		tcf_action_destroy(exts->actions, TCA_ACT_UNBIND);
+		kfree(exts->actions);
+	}
 	exts->nr_actions = 0;
 #endif
 }


