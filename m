Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0102D669C
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 20:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390140AbgLJO3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:29:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390171AbgLJO2s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:28:48 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jamie Iles <jamie@nuviainc.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 04/39] bonding: wait for sysfs kobject destruction before freeing struct slave
Date:   Thu, 10 Dec 2020 15:26:15 +0100
Message-Id: <20201210142601.114138099@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142600.887734129@linuxfoundation.org>
References: <20201210142600.887734129@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jamie Iles <jamie@nuviainc.com>

[ Upstream commit b9ad3e9f5a7a760ab068e33e1f18d240ba32ce92 ]

syzkaller found that with CONFIG_DEBUG_KOBJECT_RELEASE=y, releasing a
struct slave device could result in the following splat:

  kobject: 'bonding_slave' (00000000cecdd4fe): kobject_release, parent 0000000074ceb2b2 (delayed 1000)
  bond0 (unregistering): (slave bond_slave_1): Releasing backup interface
  ------------[ cut here ]------------
  ODEBUG: free active (active state 0) object type: timer_list hint: workqueue_select_cpu_near kernel/workqueue.c:1549 [inline]
  ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x98 kernel/workqueue.c:1600
  WARNING: CPU: 1 PID: 842 at lib/debugobjects.c:485 debug_print_object+0x180/0x240 lib/debugobjects.c:485
  Kernel panic - not syncing: panic_on_warn set ...
  CPU: 1 PID: 842 Comm: kworker/u4:4 Tainted: G S                5.9.0-rc8+ #96
  Hardware name: linux,dummy-virt (DT)
  Workqueue: netns cleanup_net
  Call trace:
   dump_backtrace+0x0/0x4d8 include/linux/bitmap.h:239
   show_stack+0x34/0x48 arch/arm64/kernel/traps.c:142
   __dump_stack lib/dump_stack.c:77 [inline]
   dump_stack+0x174/0x1f8 lib/dump_stack.c:118
   panic+0x360/0x7a0 kernel/panic.c:231
   __warn+0x244/0x2ec kernel/panic.c:600
   report_bug+0x240/0x398 lib/bug.c:198
   bug_handler+0x50/0xc0 arch/arm64/kernel/traps.c:974
   call_break_hook+0x160/0x1d8 arch/arm64/kernel/debug-monitors.c:322
   brk_handler+0x30/0xc0 arch/arm64/kernel/debug-monitors.c:329
   do_debug_exception+0x184/0x340 arch/arm64/mm/fault.c:864
   el1_dbg+0x48/0xb0 arch/arm64/kernel/entry-common.c:65
   el1_sync_handler+0x170/0x1c8 arch/arm64/kernel/entry-common.c:93
   el1_sync+0x80/0x100 arch/arm64/kernel/entry.S:594
   debug_print_object+0x180/0x240 lib/debugobjects.c:485
   __debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
   debug_check_no_obj_freed+0x200/0x430 lib/debugobjects.c:998
   slab_free_hook mm/slub.c:1536 [inline]
   slab_free_freelist_hook+0x190/0x210 mm/slub.c:1577
   slab_free mm/slub.c:3138 [inline]
   kfree+0x13c/0x460 mm/slub.c:4119
   bond_free_slave+0x8c/0xf8 drivers/net/bonding/bond_main.c:1492
   __bond_release_one+0xe0c/0xec8 drivers/net/bonding/bond_main.c:2190
   bond_slave_netdev_event drivers/net/bonding/bond_main.c:3309 [inline]
   bond_netdev_event+0x8f0/0xa70 drivers/net/bonding/bond_main.c:3420
   notifier_call_chain+0xf0/0x200 kernel/notifier.c:83
   __raw_notifier_call_chain kernel/notifier.c:361 [inline]
   raw_notifier_call_chain+0x44/0x58 kernel/notifier.c:368
   call_netdevice_notifiers_info+0xbc/0x150 net/core/dev.c:2033
   call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
   call_netdevice_notifiers net/core/dev.c:2059 [inline]
   rollback_registered_many+0x6a4/0xec0 net/core/dev.c:9347
   unregister_netdevice_many.part.0+0x2c/0x1c0 net/core/dev.c:10509
   unregister_netdevice_many net/core/dev.c:10508 [inline]
   default_device_exit_batch+0x294/0x338 net/core/dev.c:10992
   ops_exit_list.isra.0+0xec/0x150 net/core/net_namespace.c:189
   cleanup_net+0x44c/0x888 net/core/net_namespace.c:603
   process_one_work+0x96c/0x18c0 kernel/workqueue.c:2269
   worker_thread+0x3f0/0xc30 kernel/workqueue.c:2415
   kthread+0x390/0x498 kernel/kthread.c:292
   ret_from_fork+0x10/0x18 arch/arm64/kernel/entry.S:925

This is a potential use-after-free if the sysfs nodes are being accessed
whilst removing the struct slave, so wait for the object destruction to
complete before freeing the struct slave itself.

Fixes: 07699f9a7c8d ("bonding: add sysfs /slave dir for bond slave devices.")
Fixes: a068aab42258 ("bonding: Fix reference count leak in bond_sysfs_slave_add.")
Cc: Qiushi Wu <wu000273@umn.edu>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Jamie Iles <jamie@nuviainc.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20201120142827.879226-1-jamie@nuviainc.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c        |   61 +++++++++++++++++++++++----------
 drivers/net/bonding/bond_sysfs_slave.c |   18 ---------
 include/net/bonding.h                  |    8 ++++
 3 files changed, 52 insertions(+), 35 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1225,7 +1225,39 @@ static void bond_upper_dev_unlink(struct
 	rtmsg_ifinfo(RTM_NEWLINK, slave_dev, IFF_SLAVE, GFP_KERNEL);
 }
 
-static struct slave *bond_alloc_slave(struct bonding *bond)
+static void slave_kobj_release(struct kobject *kobj)
+{
+	struct slave *slave = to_slave(kobj);
+	struct bonding *bond = bond_get_bond_by_slave(slave);
+
+	cancel_delayed_work_sync(&slave->notify_work);
+	if (BOND_MODE(bond) == BOND_MODE_8023AD)
+		kfree(SLAVE_AD_INFO(slave));
+
+	kfree(slave);
+}
+
+static struct kobj_type slave_ktype = {
+	.release = slave_kobj_release,
+#ifdef CONFIG_SYSFS
+	.sysfs_ops = &slave_sysfs_ops,
+#endif
+};
+
+static int bond_kobj_init(struct slave *slave)
+{
+	int err;
+
+	err = kobject_init_and_add(&slave->kobj, &slave_ktype,
+				   &(slave->dev->dev.kobj), "bonding_slave");
+	if (err)
+		kobject_put(&slave->kobj);
+
+	return err;
+}
+
+static struct slave *bond_alloc_slave(struct bonding *bond,
+				      struct net_device *slave_dev)
 {
 	struct slave *slave = NULL;
 
@@ -1233,11 +1265,17 @@ static struct slave *bond_alloc_slave(st
 	if (!slave)
 		return NULL;
 
+	slave->bond = bond;
+	slave->dev = slave_dev;
+
+	if (bond_kobj_init(slave))
+		return NULL;
+
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 		SLAVE_AD_INFO(slave) = kzalloc(sizeof(struct ad_slave_info),
 					       GFP_KERNEL);
 		if (!SLAVE_AD_INFO(slave)) {
-			kfree(slave);
+			kobject_put(&slave->kobj);
 			return NULL;
 		}
 	}
@@ -1246,17 +1284,6 @@ static struct slave *bond_alloc_slave(st
 	return slave;
 }
 
-static void bond_free_slave(struct slave *slave)
-{
-	struct bonding *bond = bond_get_bond_by_slave(slave);
-
-	cancel_delayed_work_sync(&slave->notify_work);
-	if (BOND_MODE(bond) == BOND_MODE_8023AD)
-		kfree(SLAVE_AD_INFO(slave));
-
-	kfree(slave);
-}
-
 static void bond_fill_ifbond(struct bonding *bond, struct ifbond *info)
 {
 	info->bond_mode = BOND_MODE(bond);
@@ -1420,14 +1447,12 @@ int bond_enslave(struct net_device *bond
 	    bond->dev->addr_assign_type == NET_ADDR_RANDOM)
 		bond_set_dev_addr(bond->dev, slave_dev);
 
-	new_slave = bond_alloc_slave(bond);
+	new_slave = bond_alloc_slave(bond, slave_dev);
 	if (!new_slave) {
 		res = -ENOMEM;
 		goto err_undo_flags;
 	}
 
-	new_slave->bond = bond;
-	new_slave->dev = slave_dev;
 	/* Set the new_slave's queue_id to be zero.  Queue ID mapping
 	 * is set via sysfs or module option if desired.
 	 */
@@ -1741,7 +1766,7 @@ err_restore_mtu:
 	dev_set_mtu(slave_dev, new_slave->original_mtu);
 
 err_free:
-	bond_free_slave(new_slave);
+	kobject_put(&new_slave->kobj);
 
 err_undo_flags:
 	/* Enslave of first slave has failed and we need to fix master's mac */
@@ -1920,7 +1945,7 @@ static int __bond_release_one(struct net
 	if (!netif_is_bond_master(slave_dev))
 		slave_dev->priv_flags &= ~IFF_BONDING;
 
-	bond_free_slave(slave);
+	kobject_put(&slave->kobj);
 
 	return 0;
 }
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -125,7 +125,6 @@ static const struct slave_attribute *sla
 };
 
 #define to_slave_attr(_at) container_of(_at, struct slave_attribute, attr)
-#define to_slave(obj)	container_of(obj, struct slave, kobj)
 
 static ssize_t slave_show(struct kobject *kobj,
 			  struct attribute *attr, char *buf)
@@ -136,28 +135,15 @@ static ssize_t slave_show(struct kobject
 	return slave_attr->show(slave, buf);
 }
 
-static const struct sysfs_ops slave_sysfs_ops = {
+const struct sysfs_ops slave_sysfs_ops = {
 	.show = slave_show,
 };
 
-static struct kobj_type slave_ktype = {
-#ifdef CONFIG_SYSFS
-	.sysfs_ops = &slave_sysfs_ops,
-#endif
-};
-
 int bond_sysfs_slave_add(struct slave *slave)
 {
 	const struct slave_attribute **a;
 	int err;
 
-	err = kobject_init_and_add(&slave->kobj, &slave_ktype,
-				   &(slave->dev->dev.kobj), "bonding_slave");
-	if (err) {
-		kobject_put(&slave->kobj);
-		return err;
-	}
-
 	for (a = slave_attrs; *a; ++a) {
 		err = sysfs_create_file(&slave->kobj, &((*a)->attr));
 		if (err) {
@@ -175,6 +161,4 @@ void bond_sysfs_slave_del(struct slave *
 
 	for (a = slave_attrs; *a; ++a)
 		sysfs_remove_file(&slave->kobj, &((*a)->attr));
-
-	kobject_put(&slave->kobj);
 }
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -181,6 +181,11 @@ struct slave {
 	struct rtnl_link_stats64 slave_stats;
 };
 
+static inline struct slave *to_slave(struct kobject *kobj)
+{
+	return container_of(kobj, struct slave, kobj);
+}
+
 struct bond_up_slave {
 	unsigned int	count;
 	struct rcu_head rcu;
@@ -667,6 +672,9 @@ extern struct bond_parm_tbl ad_select_tb
 /* exported from bond_netlink.c */
 extern struct rtnl_link_ops bond_link_ops;
 
+/* exported from bond_sysfs_slave.c */
+extern const struct sysfs_ops slave_sysfs_ops;
+
 static inline void bond_tx_drop(struct net_device *dev, struct sk_buff *skb)
 {
 	atomic_long_inc(&dev->tx_dropped);


