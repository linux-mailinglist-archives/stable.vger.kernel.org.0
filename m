Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B811DB687
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgETOZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:25:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33120 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727047AbgETOW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPby-00036s-Ji; Wed, 20 May 2020 15:22:22 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbx-007DWM-Kh; Wed, 20 May 2020 15:22:21 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "syzbot" <syzkaller@googlegroups.com>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Eric Dumazet" <edumazet@google.com>
Date:   Wed, 20 May 2020 15:15:00 +0100
Message-ID: <lsq.1589984009.117776856@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 92/99] cls_rsvp: fix rsvp_policy
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit cb3c0e6bdf64d0d124e94ce43cbe4ccbb9b37f51 upstream.

NLA_BINARY can be confusing, since .len value represents
the max size of the blob.

cls_rsvp really wants user space to provide long enough data
for TCA_RSVP_DST and TCA_RSVP_SRC attributes.

BUG: KMSAN: uninit-value in rsvp_get net/sched/cls_rsvp.h:258 [inline]
BUG: KMSAN: uninit-value in gen_handle net/sched/cls_rsvp.h:402 [inline]
BUG: KMSAN: uninit-value in rsvp_change+0x1ae9/0x4220 net/sched/cls_rsvp.h:572
CPU: 1 PID: 13228 Comm: syz-executor.1 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 rsvp_get net/sched/cls_rsvp.h:258 [inline]
 gen_handle net/sched/cls_rsvp.h:402 [inline]
 rsvp_change+0x1ae9/0x4220 net/sched/cls_rsvp.h:572
 tc_new_tfilter+0x31fe/0x5010 net/sched/cls_api.c:2104
 rtnetlink_rcv_msg+0xcb7/0x1570 net/core/rtnetlink.c:5415
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5442
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x1248/0x14d0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45b349
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f269d43dc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f269d43e6d4 RCX: 000000000045b349
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009c2 R14: 00000000004cb338 R15: 000000000075bfd4

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:82
 slab_alloc_node mm/slub.c:2774 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4382
 __kmalloc_reserve net/core/skbuff.c:141 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:209
 alloc_skb include/linux/skbuff.h:1049 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1174 [inline]
 netlink_sendmsg+0x7d3/0x14d0 net/netlink/af_netlink.c:1892
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 6fa8c0144b77 ("[NET_SCHED]: Use nla_policy for attribute validation in classifiers")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/cls_rsvp.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -404,10 +404,8 @@ static u32 gen_tunnel(struct rsvp_head *
 
 static const struct nla_policy rsvp_policy[TCA_RSVP_MAX + 1] = {
 	[TCA_RSVP_CLASSID]	= { .type = NLA_U32 },
-	[TCA_RSVP_DST]		= { .type = NLA_BINARY,
-				    .len = RSVP_DST_LEN * sizeof(u32) },
-	[TCA_RSVP_SRC]		= { .type = NLA_BINARY,
-				    .len = RSVP_DST_LEN * sizeof(u32) },
+	[TCA_RSVP_DST]		= { .len = RSVP_DST_LEN * sizeof(u32) },
+	[TCA_RSVP_SRC]		= { .len = RSVP_DST_LEN * sizeof(u32) },
 	[TCA_RSVP_PINFO]	= { .len = sizeof(struct tc_rsvp_pinfo) },
 };
 

