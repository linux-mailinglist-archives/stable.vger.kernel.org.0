Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B029B1D0E68
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388301AbgEMJ7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:59:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387827AbgEMJwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:52:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B08C2312A;
        Wed, 13 May 2020 09:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363562;
        bh=4LdK0UMZKV88NR0FednH6zsZI4bJjPkcrrE6fGKiOuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzRT6a1PeTNpV9QNnWZz3n/iPReGlppxXQy5kYnwRfp9bV6yDBOO4tTGORxlHAPnl
         BrlvLK+t0bCWSf1dTwj+7tqiLoNZc6ozvfOjlSy1ArwQXs8xhNalq0zTDZgmC30q5B
         bURnr6+UntY/I+7v5cYcdk1ojoZLri5ko6YlGm48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 035/118] sch_choke: avoid potential panic in choke_reset()
Date:   Wed, 13 May 2020 11:44:14 +0200
Message-Id: <20200513094420.534388849@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8738c85c72b3108c9b9a369a39868ba5f8e10ae0 ]

If choke_init() could not allocate q->tab, we would crash later
in choke_reset().

BUG: KASAN: null-ptr-deref in memset include/linux/string.h:366 [inline]
BUG: KASAN: null-ptr-deref in choke_reset+0x208/0x340 net/sched/sch_choke.c:326
Write of size 8 at addr 0000000000000000 by task syz-executor822/7022

CPU: 1 PID: 7022 Comm: syz-executor822 Not tainted 5.7.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 __kasan_report.cold+0x5/0x4d mm/kasan/report.c:515
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 check_memory_region_inline mm/kasan/generic.c:187 [inline]
 check_memory_region+0x141/0x190 mm/kasan/generic.c:193
 memset+0x20/0x40 mm/kasan/common.c:85
 memset include/linux/string.h:366 [inline]
 choke_reset+0x208/0x340 net/sched/sch_choke.c:326
 qdisc_reset+0x6b/0x520 net/sched/sch_generic.c:910
 dev_deactivate_queue.constprop.0+0x13c/0x240 net/sched/sch_generic.c:1138
 netdev_for_each_tx_queue include/linux/netdevice.h:2197 [inline]
 dev_deactivate_many+0xe2/0xba0 net/sched/sch_generic.c:1195
 dev_deactivate+0xf8/0x1c0 net/sched/sch_generic.c:1233
 qdisc_graft+0xd25/0x1120 net/sched/sch_api.c:1051
 tc_modify_qdisc+0xbab/0x1a00 net/sched/sch_api.c:1670
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5454
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295

Fixes: 77e62da6e60c ("sch_choke: drop all packets in queue during reset")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_choke.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -323,7 +323,8 @@ static void choke_reset(struct Qdisc *sc
 
 	sch->q.qlen = 0;
 	sch->qstats.backlog = 0;
-	memset(q->tab, 0, (q->tab_mask + 1) * sizeof(struct sk_buff *));
+	if (q->tab)
+		memset(q->tab, 0, (q->tab_mask + 1) * sizeof(struct sk_buff *));
 	q->head = q->tail = 0;
 	red_restart(&q->vars);
 }


