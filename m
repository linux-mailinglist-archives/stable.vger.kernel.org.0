Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224DB12213F
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 02:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfLQBBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 20:01:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34464 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726181AbfLQAva (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:30 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15E-0003IT-5M; Tue, 17 Dec 2019 00:51:28 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15D-0005Rd-9p; Tue, 17 Dec 2019 00:51:27 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "syzbot" <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Tue, 17 Dec 2019 00:45:39 +0000
Message-ID: <lsq.1576543535.656545696@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 005/136] sch_cbq: validate TCA_CBQ_WRROPT to avoid crash
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit e9789c7cc182484fc031fd88097eb14cb26c4596 upstream.

syzbot reported a crash in cbq_normalize_quanta() caused
by an out of range cl->priority.

iproute2 enforces this check, but malicious users do not.

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] SMP KASAN PTI
Modules linked in:
CPU: 1 PID: 26447 Comm: syz-executor.1 Not tainted 5.3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:cbq_normalize_quanta.part.0+0x1fd/0x430 net/sched/sch_cbq.c:902
RSP: 0018:ffff8801a5c333b0 EFLAGS: 00010206
RAX: 0000000020000003 RBX: 00000000fffffff8 RCX: ffffc9000712f000
RDX: 00000000000043bf RSI: ffffffff83be8962 RDI: 0000000100000018
RBP: ffff8801a5c33420 R08: 000000000000003a R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000002ef
R13: ffff88018da95188 R14: dffffc0000000000 R15: 0000000000000015
FS:  00007f37d26b1700(0000) GS:ffff8801dad00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004c7cec CR3: 00000001bcd0a006 CR4: 00000000001626f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 [<ffffffff83be9d57>] cbq_normalize_quanta include/net/pkt_sched.h:27 [inline]
 [<ffffffff83be9d57>] cbq_addprio net/sched/sch_cbq.c:1097 [inline]
 [<ffffffff83be9d57>] cbq_set_wrr+0x2d7/0x450 net/sched/sch_cbq.c:1115
 [<ffffffff83bee8a7>] cbq_change_class+0x987/0x225b net/sched/sch_cbq.c:1537
 [<ffffffff83b96985>] tc_ctl_tclass+0x555/0xcd0 net/sched/sch_api.c:2329
 [<ffffffff83a84655>] rtnetlink_rcv_msg+0x485/0xc10 net/core/rtnetlink.c:5248
 [<ffffffff83cadf0a>] netlink_rcv_skb+0x17a/0x460 net/netlink/af_netlink.c:2510
 [<ffffffff83a7db6d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5266
 [<ffffffff83cac2c6>] netlink_unicast_kernel net/netlink/af_netlink.c:1324 [inline]
 [<ffffffff83cac2c6>] netlink_unicast+0x536/0x720 net/netlink/af_netlink.c:1350
 [<ffffffff83cacd4a>] netlink_sendmsg+0x89a/0xd50 net/netlink/af_netlink.c:1939
 [<ffffffff8399d46e>] sock_sendmsg_nosec net/socket.c:673 [inline]
 [<ffffffff8399d46e>] sock_sendmsg+0x12e/0x170 net/socket.c:684
 [<ffffffff8399f1fd>] ___sys_sendmsg+0x81d/0x960 net/socket.c:2359
 [<ffffffff839a2d05>] __sys_sendmsg+0x105/0x1d0 net/socket.c:2397
 [<ffffffff839a2df9>] SYSC_sendmsg net/socket.c:2406 [inline]
 [<ffffffff839a2df9>] SyS_sendmsg+0x29/0x30 net/socket.c:2404
 [<ffffffff8101ccc8>] do_syscall_64+0x528/0x770 arch/x86/entry/common.c:305
 [<ffffffff84400091>] entry_SYSCALL_64_after_hwframe+0x42/0xb7

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16:
 - netlink doesn't support error messages
 - Keep calling nla_parse_nested()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/sch_cbq.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1357,6 +1357,27 @@ static const struct nla_policy cbq_polic
 	[TCA_CBQ_POLICE]	= { .len = sizeof(struct tc_cbq_police) },
 };
 
+static int cbq_opt_parse(struct nlattr *tb[TCA_CBQ_MAX + 1],
+			 struct nlattr *opt)
+{
+	int err;
+
+	if (!opt)
+		return -EINVAL;
+
+	err = nla_parse_nested(tb, TCA_CBQ_MAX, opt, cbq_policy);
+	if (err < 0)
+		return err;
+
+	if (tb[TCA_CBQ_WRROPT]) {
+		const struct tc_cbq_wrropt *wrr = nla_data(tb[TCA_CBQ_WRROPT]);
+
+		if (wrr->priority > TC_CBQ_MAXPRIO)
+			err = -EINVAL;
+	}
+	return err;
+}
+
 static int cbq_init(struct Qdisc *sch, struct nlattr *opt)
 {
 	struct cbq_sched_data *q = qdisc_priv(sch);
@@ -1368,10 +1389,7 @@ static int cbq_init(struct Qdisc *sch, s
 	hrtimer_init(&q->delay_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
 	q->delay_timer.function = cbq_undelay;
 
-	if (!opt)
-		return -EINVAL;
-
-	err = nla_parse_nested(tb, TCA_CBQ_MAX, opt, cbq_policy);
+	err = cbq_opt_parse(tb, opt);
 	if (err < 0)
 		return err;
 
@@ -1751,10 +1769,7 @@ cbq_change_class(struct Qdisc *sch, u32
 	struct cbq_class *parent;
 	struct qdisc_rate_table *rtab = NULL;
 
-	if (opt == NULL)
-		return -EINVAL;
-
-	err = nla_parse_nested(tb, TCA_CBQ_MAX, opt, cbq_policy);
+	err = cbq_opt_parse(tb, opt);
 	if (err < 0)
 		return err;
 

