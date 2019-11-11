Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 798B3F7D3E
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbfKKSyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:54:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730587AbfKKSys (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:54:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A638C204EC;
        Mon, 11 Nov 2019 18:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498487;
        bh=jSKxf7RCpTSWkKvjcXzpxBPA8OR53DXQcNcN28NHpSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3VR0mTDwUwT/zxiYqR8U9Ss0UEO3HRKcJa44TtyjnU0fLnCxher6Sez8bH2ydYs7
         Lu+W6gaImAy5YgQwV+nG1aJhds6p0KV8MChiKMnFYPm1CrCOadgwMdJk66NXXm6GYY
         F2J8yvsKu9rmRW+7LxP0cwDMXfcBy85x/F8uFx9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 133/193] bonding: use dynamic lockdep key instead of subclass
Date:   Mon, 11 Nov 2019 19:28:35 +0100
Message-Id: <20191111181510.984303579@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 089bca2caed0d0dea7da235ce1fe245808f5ec02 ]

All bonding device has same lockdep key and subclass is initialized with
nest_level.
But actual nest_level value can be changed when a lower device is attached.
And at this moment, the subclass should be updated but it seems to be
unsafe.
So this patch makes bonding use dynamic lockdep key instead of the
subclass.

Test commands:
    ip link add bond0 type bond

    for i in {1..5}
    do
	    let A=$i-1
	    ip link add bond$i type bond
	    ip link set bond$i master bond$A
    done
    ip link set bond5 master bond0

Splat looks like:
[  307.992912] WARNING: possible recursive locking detected
[  307.993656] 5.4.0-rc3+ #96 Tainted: G        W
[  307.994367] --------------------------------------------
[  307.995092] ip/761 is trying to acquire lock:
[  307.995710] ffff8880513aac60 (&(&bond->stats_lock)->rlock#2/2){+.+.}, at: bond_get_stats+0xb8/0x500 [bonding]
[  307.997045]
	       but task is already holding lock:
[  307.997923] ffff88805fcbac60 (&(&bond->stats_lock)->rlock#2/2){+.+.}, at: bond_get_stats+0xb8/0x500 [bonding]
[  307.999215]
	       other info that might help us debug this:
[  308.000251]  Possible unsafe locking scenario:

[  308.001137]        CPU0
[  308.001533]        ----
[  308.001915]   lock(&(&bond->stats_lock)->rlock#2/2);
[  308.002609]   lock(&(&bond->stats_lock)->rlock#2/2);
[  308.003302]
		*** DEADLOCK ***

[  308.004310]  May be due to missing lock nesting notation

[  308.005319] 3 locks held by ip/761:
[  308.005830]  #0: ffffffff9fcc42b0 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[  308.006894]  #1: ffff88805fcbac60 (&(&bond->stats_lock)->rlock#2/2){+.+.}, at: bond_get_stats+0xb8/0x500 [bonding]
[  308.008243]  #2: ffffffff9f9219c0 (rcu_read_lock){....}, at: bond_get_stats+0x9f/0x500 [bonding]
[  308.009422]
	       stack backtrace:
[  308.010124] CPU: 0 PID: 761 Comm: ip Tainted: G        W         5.4.0-rc3+ #96
[  308.011097] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  308.012179] Call Trace:
[  308.012601]  dump_stack+0x7c/0xbb
[  308.013089]  __lock_acquire+0x269d/0x3de0
[  308.013669]  ? register_lock_class+0x14d0/0x14d0
[  308.014318]  lock_acquire+0x164/0x3b0
[  308.014858]  ? bond_get_stats+0xb8/0x500 [bonding]
[  308.015520]  _raw_spin_lock_nested+0x2e/0x60
[  308.016129]  ? bond_get_stats+0xb8/0x500 [bonding]
[  308.017215]  bond_get_stats+0xb8/0x500 [bonding]
[  308.018454]  ? bond_arp_rcv+0xf10/0xf10 [bonding]
[  308.019710]  ? rcu_read_lock_held+0x90/0xa0
[  308.020605]  ? rcu_read_lock_sched_held+0xc0/0xc0
[  308.021286]  ? bond_get_stats+0x9f/0x500 [bonding]
[  308.021953]  dev_get_stats+0x1ec/0x270
[  308.022508]  bond_get_stats+0x1d1/0x500 [bonding]

Fixes: d3fff6c443fe ("net: add netdev_lockdep_set_classes() helper")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 10 +++++++---
 include/net/bonding.h           |  1 +
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 142c5126da759..c3df99f8c3835 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3459,7 +3459,7 @@ static void bond_get_stats(struct net_device *bond_dev,
 	struct list_head *iter;
 	struct slave *slave;
 
-	spin_lock_nested(&bond->stats_lock, bond_get_nest_level(bond_dev));
+	spin_lock(&bond->stats_lock);
 	memcpy(stats, &bond->bond_stats, sizeof(*stats));
 
 	rcu_read_lock();
@@ -4297,8 +4297,6 @@ void bond_setup(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 
-	spin_lock_init(&bond->mode_lock);
-	spin_lock_init(&bond->stats_lock);
 	bond->params = bonding_defaults;
 
 	/* Initialize pointers */
@@ -4367,6 +4365,7 @@ static void bond_uninit(struct net_device *bond_dev)
 
 	list_del(&bond->bond_list);
 
+	lockdep_unregister_key(&bond->stats_lock_key);
 	bond_debug_unregister(bond);
 }
 
@@ -4773,6 +4772,11 @@ static int bond_init(struct net_device *bond_dev)
 	bond->nest_level = SINGLE_DEPTH_NESTING;
 	netdev_lockdep_set_classes(bond_dev);
 
+	spin_lock_init(&bond->mode_lock);
+	spin_lock_init(&bond->stats_lock);
+	lockdep_register_key(&bond->stats_lock_key);
+	lockdep_set_class(&bond->stats_lock, &bond->stats_lock_key);
+
 	list_add_tail(&bond->bond_list, &bn->dev_list);
 
 	bond_prepare_sysfs_group(bond);
diff --git a/include/net/bonding.h b/include/net/bonding.h
index d416af72404b5..be404b272d6b1 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -238,6 +238,7 @@ struct bonding {
 	struct	 dentry *debug_dir;
 #endif /* CONFIG_DEBUG_FS */
 	struct rtnl_link_stats64 bond_stats;
+	struct lock_class_key stats_lock_key;
 };
 
 #define bond_slave_get_rcu(dev) \
-- 
2.20.1



