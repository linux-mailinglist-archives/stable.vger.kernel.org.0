Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E865EA1E4
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbiIZK7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237046AbiIZK6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:58:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8305AA15;
        Mon, 26 Sep 2022 03:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D07060AD6;
        Mon, 26 Sep 2022 10:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3451AC433C1;
        Mon, 26 Sep 2022 10:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188220;
        bh=235GOpZGxgAhpEMwtzpi5kLwPIn1XiFPHgpH1pS891s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXxvHSriGZ/Qadef7gAseValOOj6HZlb/2kpVQ8lVQN1JOIDykXyhdwZAA34ff1CF
         poQ2Mc6FiRls86NUrbeSafeuIOOFU/N6Jm/goniC8CIeVw0ZKP7cMOJU2h/54jnzU5
         SKGin+mZoAxjNjdxrKEG0nGlnGm8HMkrHswYwnaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Poirier <bpoirier@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/141] net: bonding: Unsync device addresses on ndo_stop
Date:   Mon, 26 Sep 2022 12:11:45 +0200
Message-Id: <20220926100757.317636840@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Poirier <bpoirier@nvidia.com>

[ Upstream commit 86247aba599e5b07d7e828e6edaaebb0ef2b1158 ]

Netdev drivers are expected to call dev_{uc,mc}_sync() in their
ndo_set_rx_mode method and dev_{uc,mc}_unsync() in their ndo_stop method.
This is mentioned in the kerneldoc for those dev_* functions.

The bonding driver calls dev_{uc,mc}_unsync() during ndo_uninit instead of
ndo_stop. This is ineffective because address lists (dev->{uc,mc}) have
already been emptied in unregister_netdevice_many() before ndo_uninit is
called. This mistake can result in addresses being leftover on former bond
slaves after a bond has been deleted; see test_LAG_cleanup() in the last
patch in this series.

Add unsync calls, via bond_hw_addr_flush(), at their expected location,
bond_close().
Add dev_mc_add() call to bond_open() to match the above change.

v3:
* When adding or deleting a slave, only sync/unsync, add/del addresses if
  the bond is up. In other cases, it is taken care of at the right time by
  ndo_open/ndo_set_rx_mode/ndo_stop.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 47 ++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index be1fd4ef4531..f38a6ce5749b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -848,7 +848,8 @@ static void bond_hw_addr_swap(struct bonding *bond, struct slave *new_active,
 		if (bond->dev->flags & IFF_ALLMULTI)
 			dev_set_allmulti(old_active->dev, -1);
 
-		bond_hw_addr_flush(bond->dev, old_active->dev);
+		if (bond->dev->flags & IFF_UP)
+			bond_hw_addr_flush(bond->dev, old_active->dev);
 	}
 
 	if (new_active) {
@@ -859,10 +860,12 @@ static void bond_hw_addr_swap(struct bonding *bond, struct slave *new_active,
 		if (bond->dev->flags & IFF_ALLMULTI)
 			dev_set_allmulti(new_active->dev, 1);
 
-		netif_addr_lock_bh(bond->dev);
-		dev_uc_sync(new_active->dev, bond->dev);
-		dev_mc_sync(new_active->dev, bond->dev);
-		netif_addr_unlock_bh(bond->dev);
+		if (bond->dev->flags & IFF_UP) {
+			netif_addr_lock_bh(bond->dev);
+			dev_uc_sync(new_active->dev, bond->dev);
+			dev_mc_sync(new_active->dev, bond->dev);
+			netif_addr_unlock_bh(bond->dev);
+		}
 	}
 }
 
@@ -2069,13 +2072,15 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			}
 		}
 
-		netif_addr_lock_bh(bond_dev);
-		dev_mc_sync_multiple(slave_dev, bond_dev);
-		dev_uc_sync_multiple(slave_dev, bond_dev);
-		netif_addr_unlock_bh(bond_dev);
+		if (bond_dev->flags & IFF_UP) {
+			netif_addr_lock_bh(bond_dev);
+			dev_mc_sync_multiple(slave_dev, bond_dev);
+			dev_uc_sync_multiple(slave_dev, bond_dev);
+			netif_addr_unlock_bh(bond_dev);
 
-		if (BOND_MODE(bond) == BOND_MODE_8023AD)
-			dev_mc_add(slave_dev, lacpdu_mcast_addr);
+			if (BOND_MODE(bond) == BOND_MODE_8023AD)
+				dev_mc_add(slave_dev, lacpdu_mcast_addr);
+		}
 	}
 
 	bond->slave_cnt++;
@@ -2302,7 +2307,8 @@ static int __bond_release_one(struct net_device *bond_dev,
 		if (old_flags & IFF_ALLMULTI)
 			dev_set_allmulti(slave_dev, -1);
 
-		bond_hw_addr_flush(bond_dev, slave_dev);
+		if (old_flags & IFF_UP)
+			bond_hw_addr_flush(bond_dev, slave_dev);
 	}
 
 	slave_disable_netpoll(slave);
@@ -3764,6 +3770,9 @@ static int bond_open(struct net_device *bond_dev)
 		/* register to receive LACPDUs */
 		bond->recv_probe = bond_3ad_lacpdu_recv;
 		bond_3ad_initiate_agg_selection(bond, 1);
+
+		bond_for_each_slave(bond, slave, iter)
+			dev_mc_add(slave->dev, lacpdu_mcast_addr);
 	}
 
 	if (bond_mode_can_use_xmit_hash(bond))
@@ -3775,6 +3784,7 @@ static int bond_open(struct net_device *bond_dev)
 static int bond_close(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
+	struct slave *slave;
 
 	bond_work_cancel_all(bond);
 	bond->send_peer_notif = 0;
@@ -3782,6 +3792,19 @@ static int bond_close(struct net_device *bond_dev)
 		bond_alb_deinitialize(bond);
 	bond->recv_probe = NULL;
 
+	if (bond_uses_primary(bond)) {
+		rcu_read_lock();
+		slave = rcu_dereference(bond->curr_active_slave);
+		if (slave)
+			bond_hw_addr_flush(bond_dev, slave->dev);
+		rcu_read_unlock();
+	} else {
+		struct list_head *iter;
+
+		bond_for_each_slave(bond, slave, iter)
+			bond_hw_addr_flush(bond_dev, slave->dev);
+	}
+
 	return 0;
 }
 
-- 
2.35.1



