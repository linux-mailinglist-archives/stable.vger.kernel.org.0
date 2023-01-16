Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5C366C6F9
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbjAPQ1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbjAPQ0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:26:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC9A2BF01
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:14:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A05860FDF
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72988C433EF;
        Mon, 16 Jan 2023 16:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885690;
        bh=CPBgmLJheB9lgsGN9WZoGcCsZDHYEFxl19kyQEFvh2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNK2NmJluw+gZnHcjZ00LFiuOm7TnPYRbCkPgFsYuQ5TXTL0WbigHRj1EdyUkr0Yk
         1/UeVQq3dmApWWUJuS1WQ+02t8ojYA3IpzJ5DuZi42eLhlNDlOxAaWTId+lCJdqJlG
         x5vttG7yUIykMvxGdtkPWesFLEXCZ6KXEX0T8p2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maor Gottlieb <maorg@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/658] bonding: Rename slave_arr to usable_slaves
Date:   Mon, 16 Jan 2023 16:43:55 +0100
Message-Id: <20230116154916.180353019@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

[ Upstream commit ed7d4f023b1a9b0578f20d66557c66452ab845ec ]

Rename slave_arr to usable_slaves, since we will have two arrays,
one for the usable slaves and the other to all slaves.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Stable-dep-of: f8a65ab2f3ff ("bonding: fix link recovery in mode 2 when updelay is nonzero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_alb.c  |  4 ++--
 drivers/net/bonding/bond_main.c | 40 ++++++++++++++++-----------------
 include/net/bonding.h           |  2 +-
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 8bee935c8f90..20114e1dde77 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1360,7 +1360,7 @@ netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 				struct bond_up_slave *slaves;
 				unsigned int count;
 
-				slaves = rcu_dereference(bond->slave_arr);
+				slaves = rcu_dereference(bond->usable_slaves);
 				count = slaves ? READ_ONCE(slaves->count) : 0;
 				if (likely(count))
 					tx_slave = slaves->arr[hash_index %
@@ -1494,7 +1494,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 			struct bond_up_slave *slaves;
 			unsigned int count;
 
-			slaves = rcu_dereference(bond->slave_arr);
+			slaves = rcu_dereference(bond->usable_slaves);
 			count = slaves ? READ_ONCE(slaves->count) : 0;
 			if (likely(count))
 				tx_slave = slaves->arr[bond_xmit_hash(bond, skb) %
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0e797730bab3..dc351832b108 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4073,9 +4073,9 @@ static void bond_skip_slave(struct bond_up_slave *slaves,
  */
 int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 {
+	struct bond_up_slave *usable_slaves, *old_usable_slaves;
 	struct slave *slave;
 	struct list_head *iter;
-	struct bond_up_slave *new_arr, *old_arr;
 	int agg_id = 0;
 	int ret = 0;
 
@@ -4083,11 +4083,10 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 	WARN_ON(lockdep_is_held(&bond->mode_lock));
 #endif
 
-	new_arr = kzalloc(offsetof(struct bond_up_slave, arr[bond->slave_cnt]),
-			  GFP_KERNEL);
-	if (!new_arr) {
+	usable_slaves = kzalloc(struct_size(usable_slaves, arr,
+					    bond->slave_cnt), GFP_KERNEL);
+	if (!usable_slaves) {
 		ret = -ENOMEM;
-		pr_err("Failed to build slave-array.\n");
 		goto out;
 	}
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
@@ -4095,14 +4094,14 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 
 		if (bond_3ad_get_active_agg_info(bond, &ad_info)) {
 			pr_debug("bond_3ad_get_active_agg_info failed\n");
-			kfree_rcu(new_arr, rcu);
+			kfree_rcu(usable_slaves, rcu);
 			/* No active aggragator means it's not safe to use
 			 * the previous array.
 			 */
-			old_arr = rtnl_dereference(bond->slave_arr);
-			if (old_arr) {
-				RCU_INIT_POINTER(bond->slave_arr, NULL);
-				kfree_rcu(old_arr, rcu);
+			old_usable_slaves = rtnl_dereference(bond->usable_slaves);
+			if (old_usable_slaves) {
+				RCU_INIT_POINTER(bond->usable_slaves, NULL);
+				kfree_rcu(old_usable_slaves, rcu);
 			}
 			goto out;
 		}
@@ -4122,18 +4121,19 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 			continue;
 
 		slave_dbg(bond->dev, slave->dev, "Adding slave to tx hash array[%d]\n",
-			  new_arr->count);
+			  usable_slaves->count);
 
-		new_arr->arr[new_arr->count++] = slave;
+		usable_slaves->arr[usable_slaves->count++] = slave;
 	}
 
-	old_arr = rtnl_dereference(bond->slave_arr);
-	rcu_assign_pointer(bond->slave_arr, new_arr);
-	if (old_arr)
-		kfree_rcu(old_arr, rcu);
+	old_usable_slaves = rtnl_dereference(bond->usable_slaves);
+	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
+	if (old_usable_slaves)
+		kfree_rcu(old_usable_slaves, rcu);
 out:
 	if (ret != 0 && skipslave)
-		bond_skip_slave(rtnl_dereference(bond->slave_arr), skipslave);
+		bond_skip_slave(rtnl_dereference(bond->usable_slaves),
+				skipslave);
 
 	return ret;
 }
@@ -4150,7 +4150,7 @@ static netdev_tx_t bond_3ad_xor_xmit(struct sk_buff *skb,
 	struct bond_up_slave *slaves;
 	unsigned int count;
 
-	slaves = rcu_dereference(bond->slave_arr);
+	slaves = rcu_dereference(bond->usable_slaves);
 	count = slaves ? READ_ONCE(slaves->count) : 0;
 	if (likely(count)) {
 		slave = slaves->arr[bond_xmit_hash(bond, skb) % count];
@@ -4457,9 +4457,9 @@ static void bond_uninit(struct net_device *bond_dev)
 		__bond_release_one(bond_dev, slave->dev, true, true);
 	netdev_info(bond_dev, "Released all slaves\n");
 
-	arr = rtnl_dereference(bond->slave_arr);
+	arr = rtnl_dereference(bond->usable_slaves);
 	if (arr) {
-		RCU_INIT_POINTER(bond->slave_arr, NULL);
+		RCU_INIT_POINTER(bond->usable_slaves, NULL);
 		kfree_rcu(arr, rcu);
 	}
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 1bee8fdff7db..69ceb5b4a8d6 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -205,7 +205,7 @@ struct bonding {
 	struct   slave __rcu *curr_active_slave;
 	struct   slave __rcu *current_arp_slave;
 	struct   slave __rcu *primary_slave;
-	struct   bond_up_slave __rcu *slave_arr; /* Array of usable slaves */
+	struct   bond_up_slave __rcu *usable_slaves; /* Array of usable slaves */
 	bool     force_primary;
 	s32      slave_cnt; /* never change this value outside the attach/detach wrappers */
 	int     (*recv_probe)(const struct sk_buff *, struct bonding *,
-- 
2.35.1



