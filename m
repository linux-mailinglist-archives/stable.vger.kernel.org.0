Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B693D61B3
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbhGZPcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237400AbhGZP3P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A21961006;
        Mon, 26 Jul 2021 16:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315664;
        bh=a6h9FSpiKUXuVVrtPpJ4s7x6xJH52lcP633fa1lzLek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIzaeZ92PLasKF7EOYEgykI2kGCtrO1JFa4/0Sz5nQcYdM5YXMZBDkP2KxB/aSBCR
         pJBOhG48hVkWmJ8HusSWmwbHxAM2h7EHrIF+w3alAOd/Dv84IVQ6pY6hh8QZOpj+4n
         HnB0Dze6GCPNicQEDSGbzoISm/BFr/mNVAvqDX1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 018/223] bonding: fix suspicious RCU usage in bond_ipsec_del_sa()
Date:   Mon, 26 Jul 2021 17:36:50 +0200
Message-Id: <20210726153846.851293563@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit a22c39b831a081da9b2c488bd970a4412d926f30 ]

To dereference bond->curr_active_slave, it uses rcu_dereference().
But it and the caller doesn't acquire RCU so a warning occurs.
So add rcu_read_lock().

Test commands:
    ip netns add A
    ip netns exec A bash
    modprobe netdevsim
    echo "1 1" > /sys/bus/netdevsim/new_device
    ip link add bond0 type bond
    ip link set eth0 master bond0
    ip link set eth0 up
    ip link set bond0 up
    ip x s add proto esp dst 14.1.1.1 src 15.1.1.1 spi 0x07 mode \
transport reqid 0x07 replay-window 32 aead 'rfc4106(gcm(aes))' \
0x44434241343332312423222114131211f4f3f2f1 128 sel src 14.0.0.52/24 \
dst 14.0.0.70/24 proto tcp offload dev bond0 dir in
    ip x s f

Splat looks like:
=============================
WARNING: suspicious RCU usage
5.13.0-rc3+ #1168 Not tainted
-----------------------------
drivers/net/bonding/bond_main.c:448 suspicious rcu_dereference_check()
usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
2 locks held by ip/705:
 #0: ffff888106701780 (&net->xfrm.xfrm_cfg_mutex){+.+.}-{3:3},
at: xfrm_netlink_rcv+0x59/0x80 [xfrm_user]
 #1: ffff8880075b0098 (&x->lock){+.-.}-{2:2},
at: xfrm_state_delete+0x16/0x30

stack backtrace:
CPU: 6 PID: 705 Comm: ip Not tainted 5.13.0-rc3+ #1168
Call Trace:
 dump_stack+0xa4/0xe5
 bond_ipsec_del_sa+0x16a/0x1c0 [bonding]
 __xfrm_state_delete+0x51f/0x730
 xfrm_state_delete+0x1e/0x30
 xfrm_state_flush+0x22f/0x390
 xfrm_flush_sa+0xd8/0x260 [xfrm_user]
 ? xfrm_flush_policy+0x290/0x290 [xfrm_user]
 xfrm_user_rcv_msg+0x331/0x660 [xfrm_user]
 ? rcu_read_lock_sched_held+0x91/0xc0
 ? xfrm_user_state_lookup.constprop.39+0x320/0x320 [xfrm_user]
 ? find_held_lock+0x3a/0x1c0
 ? mutex_lock_io_nested+0x1210/0x1210
 ? sched_clock_cpu+0x18/0x170
 netlink_rcv_skb+0x121/0x350
[ ... ]

Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 24b33118105a..a7b6550063b2 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -444,21 +444,24 @@ static void bond_ipsec_del_sa(struct xfrm_state *xs)
 	if (!bond_dev)
 		return;
 
+	rcu_read_lock();
 	bond = netdev_priv(bond_dev);
 	slave = rcu_dereference(bond->curr_active_slave);
 
 	if (!slave)
-		return;
+		goto out;
 
 	xs->xso.real_dev = slave->dev;
 
 	if (!(slave->dev->xfrmdev_ops
 	      && slave->dev->xfrmdev_ops->xdo_dev_state_delete)) {
 		slave_warn(bond_dev, slave->dev, "%s: no slave xdo_dev_state_delete\n", __func__);
-		return;
+		goto out;
 	}
 
 	slave->dev->xfrmdev_ops->xdo_dev_state_delete(xs);
+out:
+	rcu_read_unlock();
 }
 
 /**
-- 
2.30.2



