Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8457428B7D0
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731436AbgJLNq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:46:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389000AbgJLNqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:46:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7731C206D9;
        Mon, 12 Oct 2020 13:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510376;
        bh=rKo7mEJ8EVpEzT+k9oUSiVJ2jzU/ZwKC589M80RbYKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lbfkxAwDhssFQ8uqMQ2WRQKwJnuBD4vsKhlpfwIc7B+r8JQr/cRmYo9rLmws+6vh+
         PjOky+n3zRyfovBMt+7VFCOSuRozTk5L60mwpW0l5Tj0VRMx7G0anBiI4tPt+PQoJr
         9lSGSFacI8gCTlodCfOw723k+9Dtj5mgIw2vWhjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 072/124] bonding: set dev->needed_headroom in bond_setup_by_slave()
Date:   Mon, 12 Oct 2020 15:31:16 +0200
Message-Id: <20201012133150.339246213@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f32f19339596b214c208c0dba716f4b6cc4f6958 ]

syzbot managed to crash a host by creating a bond
with a GRE device.

For non Ethernet device, bonding calls bond_setup_by_slave()
instead of ether_setup(), and unfortunately dev->needed_headroom
was not copied from the new added member.

[  171.243095] skbuff: skb_under_panic: text:ffffffffa184b9ea len:116 put:20 head:ffff883f84012dc0 data:ffff883f84012dbc tail:0x70 end:0xd00 dev:bond0
[  171.243111] ------------[ cut here ]------------
[  171.243112] kernel BUG at net/core/skbuff.c:112!
[  171.243117] invalid opcode: 0000 [#1] SMP KASAN PTI
[  171.243469] gsmi: Log Shutdown Reason 0x03
[  171.243505] Call Trace:
[  171.243506]  <IRQ>
[  171.243512]  [<ffffffffa171be59>] skb_push+0x49/0x50
[  171.243516]  [<ffffffffa184b9ea>] ipgre_header+0x2a/0xf0
[  171.243520]  [<ffffffffa17452d7>] neigh_connected_output+0xb7/0x100
[  171.243524]  [<ffffffffa186f1d3>] ip6_finish_output2+0x383/0x490
[  171.243528]  [<ffffffffa186ede2>] __ip6_finish_output+0xa2/0x110
[  171.243531]  [<ffffffffa186acbc>] ip6_finish_output+0x2c/0xa0
[  171.243534]  [<ffffffffa186abe9>] ip6_output+0x69/0x110
[  171.243537]  [<ffffffffa186ac90>] ? ip6_output+0x110/0x110
[  171.243541]  [<ffffffffa189d952>] mld_sendpack+0x1b2/0x2d0
[  171.243544]  [<ffffffffa189d290>] ? mld_send_report+0xf0/0xf0
[  171.243548]  [<ffffffffa189c797>] mld_ifc_timer_expire+0x2d7/0x3b0
[  171.243551]  [<ffffffffa189c4c0>] ? mld_gq_timer_expire+0x50/0x50
[  171.243556]  [<ffffffffa0fea270>] call_timer_fn+0x30/0x130
[  171.243559]  [<ffffffffa0fea17c>] expire_timers+0x4c/0x110
[  171.243563]  [<ffffffffa0fea0e3>] __run_timers+0x213/0x260
[  171.243566]  [<ffffffffa0fecb7d>] ? ktime_get+0x3d/0xa0
[  171.243570]  [<ffffffffa0ff9c4e>] ? clockevents_program_event+0x7e/0xe0
[  171.243574]  [<ffffffffa0f7e5d5>] ? sched_clock_cpu+0x15/0x190
[  171.243577]  [<ffffffffa0fe973d>] run_timer_softirq+0x1d/0x40
[  171.243581]  [<ffffffffa1c00152>] __do_softirq+0x152/0x2f0
[  171.243585]  [<ffffffffa0f44e1f>] irq_exit+0x9f/0xb0
[  171.243588]  [<ffffffffa1a02e1d>] smp_apic_timer_interrupt+0xfd/0x1a0
[  171.243591]  [<ffffffffa1a01ea6>] apic_timer_interrupt+0x86/0x90

Fixes: f5184d267c1a ("net: Allow netdevices to specify needed head/tailroom")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 500aa3e19a4c7..fddf7c502355b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1195,6 +1195,7 @@ static void bond_setup_by_slave(struct net_device *bond_dev,
 
 	bond_dev->type		    = slave_dev->type;
 	bond_dev->hard_header_len   = slave_dev->hard_header_len;
+	bond_dev->needed_headroom   = slave_dev->needed_headroom;
 	bond_dev->addr_len	    = slave_dev->addr_len;
 
 	memcpy(bond_dev->broadcast, slave_dev->broadcast,
-- 
2.25.1



