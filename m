Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F0C42DC4D
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhJNO6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232006AbhJNO5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:57:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C56EC60F36;
        Thu, 14 Oct 2021 14:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223340;
        bh=9n0KO/SVOXfcWhAq4JTMCmYNMpFBJrl7+pSIco1JJas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wm8Z9LWlRPm9kxwvgw6DExMAkClMLi18wEc+HNMcZHDBbC8MgBPNuY4193OOz1OYw
         mfTbKxu6mHD8cvjzfxss8ySArBcaQs8xX3KrLavpki0BNJpBOX+/DJODw1kf3yVRxE
         qsuaWdx3Ls5D/ZCYdJ+XAjYpJftp70oWf/T/tjTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 10/25] net_sched: fix NULL deref in fifo_set_limit()
Date:   Thu, 14 Oct 2021 16:53:41 +0200
Message-Id: <20211014145207.901653380@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.575041491@linuxfoundation.org>
References: <20211014145207.575041491@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 560ee196fe9e5037e5015e2cdb14b3aecb1cd7dc ]

syzbot reported another NULL deref in fifo_set_limit() [1]

I could repro the issue with :

unshare -n
tc qd add dev lo root handle 1:0 tbf limit 200000 burst 70000 rate 100Mbit
tc qd replace dev lo parent 1:0 pfifo_fast
tc qd change dev lo root handle 1:0 tbf limit 300000 burst 70000 rate 100Mbit

pfifo_fast does not have a change() operation.
Make fifo_set_limit() more robust about this.

[1]
BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 1cf99067 P4D 1cf99067 PUD 7ca49067 PMD 0
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 14443 Comm: syz-executor959 Not tainted 5.15.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffffc9000e2f7310 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffffff8d6ecc00 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff888024c27910 RDI: ffff888071e34000
RBP: ffff888071e34000 R08: 0000000000000001 R09: ffffffff8fcfb947
R10: 0000000000000001 R11: 0000000000000000 R12: ffff888024c27910
R13: ffff888071e34018 R14: 0000000000000000 R15: ffff88801ef74800
FS:  00007f321d897700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000722c3000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 fifo_set_limit net/sched/sch_fifo.c:242 [inline]
 fifo_set_limit+0x198/0x210 net/sched/sch_fifo.c:227
 tbf_change+0x6ec/0x16d0 net/sched/sch_tbf.c:418
 qdisc_change net/sched/sch_api.c:1332 [inline]
 tc_modify_qdisc+0xd9a/0x1a60 net/sched/sch_api.c:1634
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: fb0305ce1b03 ("net-sched: consolidate default fifo qdisc setup")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20210930212239.3430364-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fifo.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_fifo.c b/net/sched/sch_fifo.c
index 1e37247656f8..8b7110cbcce4 100644
--- a/net/sched/sch_fifo.c
+++ b/net/sched/sch_fifo.c
@@ -151,6 +151,9 @@ int fifo_set_limit(struct Qdisc *q, unsigned int limit)
 	if (strncmp(q->ops->id + 1, "fifo", 4) != 0)
 		return 0;
 
+	if (!q->ops->change)
+		return 0;
+
 	nla = kmalloc(nla_attr_size(sizeof(struct tc_fifo_qopt)), GFP_KERNEL);
 	if (nla) {
 		nla->nla_type = RTM_NEWQDISC;
-- 
2.33.0



