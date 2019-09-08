Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDCF2ACE36
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732631AbfIHMzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732586AbfIHMvZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:51:25 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09F13218AC;
        Sun,  8 Sep 2019 12:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947084;
        bh=Rgs42PFfzdIpzs4KOGf8Sr8EMe4g8KFqWNrmHyaoglA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RlzC1DEnz7t7SMQDKhUWMFORKckzju0GPjuIJF269hXPW+y/7QeUq3cmz8SsGQN8I
         85s0fLSJhViOwZCx9H/wmNrHmWR1hFBVnmcotRfxrH1EriTFjz0ETePd93kpk4P4Qa
         4uJ/RE+ptxWHlQCis+pk/L1dBkH2wAom1tENjqUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Leandro Dorileo <leandro.maciel.dorileo@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 13/94] taprio: Set default link speed to 10 Mbps in taprio_set_picos_per_byte
Date:   Sun,  8 Sep 2019 13:41:09 +0100
Message-Id: <20190908121150.812652806@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

The taprio budget needs to be adapted at runtime according to interface
link speed. But that handling is problematic.

For one thing, installing a qdisc on an interface that doesn't have
carrier is not illegal. But taprio prints the following stack trace:

[   31.851373] ------------[ cut here ]------------
[   31.856024] WARNING: CPU: 1 PID: 207 at net/sched/sch_taprio.c:481 taprio_dequeue+0x1a8/0x2d4
[   31.864566] taprio: dequeue() called with unknown picos per byte.
[   31.864570] Modules linked in:
[   31.873701] CPU: 1 PID: 207 Comm: tc Not tainted 5.3.0-rc5-01199-g8838fe023cd6 #1689
[   31.881398] Hardware name: Freescale LS1021A
[   31.885661] [<c03133a4>] (unwind_backtrace) from [<c030d8cc>] (show_stack+0x10/0x14)
[   31.893368] [<c030d8cc>] (show_stack) from [<c10ac958>] (dump_stack+0xb4/0xc8)
[   31.900555] [<c10ac958>] (dump_stack) from [<c0349d04>] (__warn+0xe0/0xf8)
[   31.907395] [<c0349d04>] (__warn) from [<c0349d64>] (warn_slowpath_fmt+0x48/0x6c)
[   31.914841] [<c0349d64>] (warn_slowpath_fmt) from [<c0f38db4>] (taprio_dequeue+0x1a8/0x2d4)
[   31.923150] [<c0f38db4>] (taprio_dequeue) from [<c0f227b0>] (__qdisc_run+0x90/0x61c)
[   31.930856] [<c0f227b0>] (__qdisc_run) from [<c0ec82ac>] (net_tx_action+0x12c/0x2bc)
[   31.938560] [<c0ec82ac>] (net_tx_action) from [<c0302298>] (__do_softirq+0x130/0x3c8)
[   31.946350] [<c0302298>] (__do_softirq) from [<c03502a0>] (irq_exit+0xbc/0xd8)
[   31.953536] [<c03502a0>] (irq_exit) from [<c03a4808>] (__handle_domain_irq+0x60/0xb4)
[   31.961328] [<c03a4808>] (__handle_domain_irq) from [<c0754478>] (gic_handle_irq+0x58/0x9c)
[   31.969638] [<c0754478>] (gic_handle_irq) from [<c0301a8c>] (__irq_svc+0x6c/0x90)
[   31.977076] Exception stack(0xe8167b20 to 0xe8167b68)
[   31.982100] 7b20: e9d4bd80 00000cc0 000000cf 00000000 e9d4bd80 c1f38958 00000cc0 c1f38960
[   31.990234] 7b40: 00000001 000000cf 00000004 e9dc0800 00000000 e8167b70 c0f478ec c0f46d94
[   31.998363] 7b60: 60070013 ffffffff
[   32.001833] [<c0301a8c>] (__irq_svc) from [<c0f46d94>] (netlink_trim+0x18/0xd8)
[   32.009104] [<c0f46d94>] (netlink_trim) from [<c0f478ec>] (netlink_broadcast_filtered+0x34/0x414)
[   32.017930] [<c0f478ec>] (netlink_broadcast_filtered) from [<c0f47cec>] (netlink_broadcast+0x20/0x28)
[   32.027102] [<c0f47cec>] (netlink_broadcast) from [<c0eea378>] (rtnetlink_send+0x34/0x88)
[   32.035238] [<c0eea378>] (rtnetlink_send) from [<c0f25890>] (notify_and_destroy+0x2c/0x44)
[   32.043461] [<c0f25890>] (notify_and_destroy) from [<c0f25e08>] (qdisc_graft+0x398/0x470)
[   32.051595] [<c0f25e08>] (qdisc_graft) from [<c0f27a00>] (tc_modify_qdisc+0x3a4/0x724)
[   32.059470] [<c0f27a00>] (tc_modify_qdisc) from [<c0ee4c84>] (rtnetlink_rcv_msg+0x260/0x2ec)
[   32.067864] [<c0ee4c84>] (rtnetlink_rcv_msg) from [<c0f4a988>] (netlink_rcv_skb+0xb8/0x110)
[   32.076172] [<c0f4a988>] (netlink_rcv_skb) from [<c0f4a170>] (netlink_unicast+0x1b4/0x22c)
[   32.084392] [<c0f4a170>] (netlink_unicast) from [<c0f4a5e4>] (netlink_sendmsg+0x33c/0x380)
[   32.092614] [<c0f4a5e4>] (netlink_sendmsg) from [<c0ea9f40>] (sock_sendmsg+0x14/0x24)
[   32.100403] [<c0ea9f40>] (sock_sendmsg) from [<c0eaa780>] (___sys_sendmsg+0x214/0x228)
[   32.108279] [<c0eaa780>] (___sys_sendmsg) from [<c0eabad0>] (__sys_sendmsg+0x50/0x8c)
[   32.116068] [<c0eabad0>] (__sys_sendmsg) from [<c0301000>] (ret_fast_syscall+0x0/0x54)
[   32.123938] Exception stack(0xe8167fa8 to 0xe8167ff0)
[   32.128960] 7fa0:                   b6fa68c8 000000f8 00000003 bea142d0 00000000 00000000
[   32.137093] 7fc0: b6fa68c8 000000f8 0052154c 00000128 5d6468a2 00000000 00000028 00558c9c
[   32.145224] 7fe0: 00000070 bea14278 00530d64 b6e17e64
[   32.150659] ---[ end trace 2139c9827c3e5177 ]---

This happens because the qdisc ->dequeue callback gets called. Which
again is not illegal, the qdisc will dequeue even when the interface is
up but doesn't have carrier (and hence SPEED_UNKNOWN), and the frames
will be dropped further down the stack in dev_direct_xmit().

And, at the end of the day, for what? For calculating the initial budget
of an interface which is non-operational at the moment and where frames
will get dropped anyway.

So if we can't figure out the link speed, default to SPEED_10 and move
along. We can also remove the runtime check now.

Cc: Leandro Dorileo <leandro.maciel.dorileo@intel.com>
Fixes: 7b9eba7ba0c1 ("net/sched: taprio: fix picos_per_byte miscalculation")
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -205,11 +205,6 @@ static struct sk_buff *taprio_dequeue(st
 	u32 gate_mask;
 	int i;
 
-	if (atomic64_read(&q->picos_per_byte) == -1) {
-		WARN_ONCE(1, "taprio: dequeue() called with unknown picos per byte.");
-		return NULL;
-	}
-
 	rcu_read_lock();
 	entry = rcu_dereference(q->current_entry);
 	/* if there's no entry, it means that the schedule didn't
@@ -665,12 +660,20 @@ static void taprio_set_picos_per_byte(st
 				      struct taprio_sched *q)
 {
 	struct ethtool_link_ksettings ecmd;
-	int picos_per_byte = -1;
+	int speed = SPEED_10;
+	int picos_per_byte;
+	int err;
+
+	err = __ethtool_get_link_ksettings(dev, &ecmd);
+	if (err < 0)
+		goto skip;
+
+	if (ecmd.base.speed != SPEED_UNKNOWN)
+		speed = ecmd.base.speed;
 
-	if (!__ethtool_get_link_ksettings(dev, &ecmd) &&
-	    ecmd.base.speed != SPEED_UNKNOWN)
-		picos_per_byte = div64_s64(NSEC_PER_SEC * 1000LL * 8,
-					   ecmd.base.speed * 1000 * 1000);
+skip:
+	picos_per_byte = div64_s64(NSEC_PER_SEC * 1000LL * 8,
+				   speed * 1000 * 1000);
 
 	atomic64_set(&q->picos_per_byte, picos_per_byte);
 	netdev_dbg(dev, "taprio: set %s's picos_per_byte to: %lld, linkspeed: %d\n",


