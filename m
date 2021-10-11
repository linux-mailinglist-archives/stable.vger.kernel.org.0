Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAF642907F
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238742AbhJKOJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:09:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240936AbhJKOHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:07:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F40DE611AD;
        Mon, 11 Oct 2021 14:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960836;
        bh=3NesVe6MIMIg1JcO6e+qoeeCfWDDmmgJD90a/Lv8f1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rv/Ha/amC29WY/Y1dwyIwyXO0sPhuS3cViJgJdxQc7n27zbg/FdZzzVFVKpOBY8At
         Py+RBieS/BXoDaCgGBFnFfSIj/F4muQ91z8qKkXr+suflxXAxBO2S6mu3FdDJHnHVa
         DxUiN5+AV3wE3MQ4/fvXMLvqKqsJAFxJ+O4C/mfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Davide Caratti <dcaratti@redhat.com>,
        syzbot <syzkaller@googlegroups.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 090/151] net/sched: sch_taprio: properly cancel timer from taprio_destroy()
Date:   Mon, 11 Oct 2021 15:46:02 +0200
Message-Id: <20211011134520.744055424@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a56d447f196fa9973c568f54c0d76d5391c3b0c0 ]

There is a comment in qdisc_create() about us not calling ops->reset()
in some cases.

err_out4:
	/*
	 * Any broken qdiscs that would require a ops->reset() here?
	 * The qdisc was never in action so it shouldn't be necessary.
	 */

As taprio sets a timer before actually receiving a packet, we need
to cancel it from ops->destroy, just in case ops->reset has not
been called.

syzbot reported:

ODEBUG: free active (active state 0) object type: hrtimer hint: advance_sched+0x0/0x9a0 arch/x86/include/asm/atomic64_64.h:22
WARNING: CPU: 0 PID: 8441 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 0 PID: 8441 Comm: syz-executor813 Not tainted 5.14.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd e0 d3 e3 89 4c 89 ee 48 c7 c7 e0 c7 e3 89 e8 5b 86 11 05 <0f> 0b 83 05 85 03 92 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc9000130f330 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff88802baeb880 RSI: ffffffff815d87b5 RDI: fffff52000261e58
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815d25ee R11: 0000000000000000 R12: ffffffff898dd020
R13: ffffffff89e3ce20 R14: ffffffff81653630 R15: dffffc0000000000
FS:  0000000000f0d300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffb64b3e000 CR3: 0000000036557000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __debug_check_no_obj_freed lib/debugobjects.c:987 [inline]
 debug_check_no_obj_freed+0x301/0x420 lib/debugobjects.c:1018
 slab_free_hook mm/slub.c:1603 [inline]
 slab_free_freelist_hook+0x171/0x240 mm/slub.c:1653
 slab_free mm/slub.c:3213 [inline]
 kfree+0xe4/0x540 mm/slub.c:4267
 qdisc_create+0xbcf/0x1320 net/sched/sch_api.c:1299
 tc_modify_qdisc+0x4c8/0x1a60 net/sched/sch_api.c:1663
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5571
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2403
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2457
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2486
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80

Fixes: 44d4775ca518 ("net/sched: sch_taprio: reset child qdiscs before freeing them")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Davide Caratti <dcaratti@redhat.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Acked-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 1ab2fc933a21..b9fd18d98646 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1641,6 +1641,10 @@ static void taprio_destroy(struct Qdisc *sch)
 	list_del(&q->taprio_list);
 	spin_unlock(&taprio_list_lock);
 
+	/* Note that taprio_reset() might not be called if an error
+	 * happens in qdisc_create(), after taprio_init() has been called.
+	 */
+	hrtimer_cancel(&q->advance_timer);
 
 	taprio_disable_offload(dev, q, NULL);
 
-- 
2.33.0



