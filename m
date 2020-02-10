Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB501157AE4
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbgBJN0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:26:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727939AbgBJMgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:48 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41C842051A;
        Mon, 10 Feb 2020 12:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338208;
        bh=xyi1BokZh6flgpInBanUV5C40kryavWStzwihmuMg/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3scSmk+NNykExBGUtekSxtxDE03B/tznfOAC3dvb2tqU20u6r8S3uyvfHKLSNgs5
         jWz3Hpd2mDGWaj5aZujbwuzIfAkQa3HZ9apZCQ9olS2oQUud4NJ0COTYqVsLm8oD87
         ZbyIMEr/iNFYA6oGRl8CvB3oAP33HuGGmxA3ys04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 003/309] cls_rsvp: fix rsvp_policy
Date:   Mon, 10 Feb 2020 04:29:19 -0800
Message-Id: <20200210122406.411919249@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cb3c0e6bdf64d0d124e94ce43cbe4ccbb9b37f51 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_rsvp.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -463,10 +463,8 @@ static u32 gen_tunnel(struct rsvp_head *
 
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
 


