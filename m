Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D913CD758
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbfJFR1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:27:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbfJFR1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:27:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B7562133F;
        Sun,  6 Oct 2019 17:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382851;
        bh=dwN7DkGYj2baReDA/IN8LzWxLGWghlHv0lcA1lpB8ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmKz+eDwaVTdTIFLKzj6mUYEug3i0rkro7Iu6y7tzICFb2G+KOUONJfQmUApnGkeB
         R9d1HiWID1KcAlQSU2ye4bXRx9lQSjK7PTtfzUloARNVoKDTFbKSKdbK+zE6aByZ5G
         MvQxJzrVNS/L/w/D3S9UhvSSoyH6NfF85gte0cAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 63/68] sch_cbq: validate TCA_CBQ_WRROPT to avoid crash
Date:   Sun,  6 Oct 2019 19:21:39 +0200
Message-Id: <20191006171138.008238363@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171108.150129403@linuxfoundation.org>
References: <20191006171108.150129403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e9789c7cc182484fc031fd88097eb14cb26c4596 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_cbq.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1131,6 +1131,26 @@ static const struct nla_policy cbq_polic
 	[TCA_CBQ_POLICE]	= { .len = sizeof(struct tc_cbq_police) },
 };
 
+static int cbq_opt_parse(struct nlattr *tb[TCA_CBQ_MAX + 1], struct nlattr *opt)
+{
+	int err;
+
+	if (!opt)
+		return -EINVAL;
+
+	err = nla_parse_nested(tb, TCA_CBQ_MAX, opt, cbq_policy, NULL);
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
@@ -1142,10 +1162,7 @@ static int cbq_init(struct Qdisc *sch, s
 	hrtimer_init(&q->delay_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
 	q->delay_timer.function = cbq_undelay;
 
-	if (!opt)
-		return -EINVAL;
-
-	err = nla_parse_nested(tb, TCA_CBQ_MAX, opt, cbq_policy, NULL);
+	err = cbq_opt_parse(tb, opt);
 	if (err < 0)
 		return err;
 
@@ -1459,10 +1476,7 @@ cbq_change_class(struct Qdisc *sch, u32
 	struct cbq_class *parent;
 	struct qdisc_rate_table *rtab = NULL;
 
-	if (opt == NULL)
-		return -EINVAL;
-
-	err = nla_parse_nested(tb, TCA_CBQ_MAX, opt, cbq_policy, NULL);
+	err = cbq_opt_parse(tb, opt);
 	if (err < 0)
 		return err;
 


