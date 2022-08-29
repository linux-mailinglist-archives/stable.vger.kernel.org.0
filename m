Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE755A4884
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiH2LLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiH2LLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:11:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C4A6C12C;
        Mon, 29 Aug 2022 04:07:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EDC46119A;
        Mon, 29 Aug 2022 11:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C775C433C1;
        Mon, 29 Aug 2022 11:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771130;
        bh=exU63527SJlzAvFxYDON0sl8dvxxp6GbnX8JmR9FOaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pdg/QOFRCXnSeeaS3qjnIwS/IAHHXw4W7nXMW1vIinGZ4lddFCpAaDlrXp1u1+MAi
         0zfVEloLJPubUhHO9EU1b7TFQq+Embx52kGXFTm6wovWixxtSmw6JAuQcEIY5EmWJo
         gRu37smjA3ZqRSTF5sCFIMzmXwjnayetmAEsnGYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/136] net: use eth_hw_addr_set() instead of ether_addr_copy()
Date:   Mon, 29 Aug 2022 12:58:18 +0200
Message-Id: <20220829105805.850366015@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e35b8d7dbb094c79daf920797c372911edc2d525 ]

Convert from ether_addr_copy() to eth_hw_addr_set():

  @@
  expression dev, np;
  @@
  - ether_addr_copy(dev->dev_addr, np)
  + eth_hw_addr_set(dev, np)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_main.c | 2 +-
 drivers/net/macsec.c             | 2 +-
 drivers/net/macvlan.c            | 2 +-
 net/8021q/vlan_dev.c             | 6 +++---
 net/dsa/slave.c                  | 4 ++--
 net/hsr/hsr_device.c             | 2 +-
 net/hsr/hsr_main.c               | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index c0b21a5580d52..3f43c253adaca 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -787,7 +787,7 @@ static int ipvlan_device_event(struct notifier_block *unused,
 
 	case NETDEV_CHANGEADDR:
 		list_for_each_entry(ipvlan, &port->ipvlans, pnode) {
-			ether_addr_copy(ipvlan->dev->dev_addr, dev->dev_addr);
+			eth_hw_addr_set(ipvlan->dev, dev->dev_addr);
 			call_netdevice_notifiers(NETDEV_CHANGEADDR, ipvlan->dev);
 		}
 		break;
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 354890948f8a1..0a860cbe03e76 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3616,7 +3616,7 @@ static int macsec_set_mac_address(struct net_device *dev, void *p)
 	dev_uc_del(real_dev, dev->dev_addr);
 
 out:
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(dev, addr->sa_data);
 	macsec->secy.sci = dev_to_sci(dev, MACSEC_PORT_ES);
 
 	/* If h/w offloading is available, propagate to the device */
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index a9a515cf5a460..6363459ba1d05 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -711,7 +711,7 @@ static int macvlan_sync_address(struct net_device *dev, unsigned char *addr)
 
 	if (!(dev->flags & IFF_UP)) {
 		/* Just copy in the new address */
-		ether_addr_copy(dev->dev_addr, addr);
+		eth_hw_addr_set(dev, addr);
 	} else {
 		/* Rehash and update the device filters */
 		if (macvlan_addr_busy(vlan->port, addr))
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 8602885c8a8e0..a54535cbcf4cf 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -250,7 +250,7 @@ bool vlan_dev_inherit_address(struct net_device *dev,
 	if (dev->addr_assign_type != NET_ADDR_STOLEN)
 		return false;
 
-	ether_addr_copy(dev->dev_addr, real_dev->dev_addr);
+	eth_hw_addr_set(dev, real_dev->dev_addr);
 	call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
 	return true;
 }
@@ -349,7 +349,7 @@ static int vlan_dev_set_mac_address(struct net_device *dev, void *p)
 		dev_uc_del(real_dev, dev->dev_addr);
 
 out:
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(dev, addr->sa_data);
 	return 0;
 }
 
@@ -586,7 +586,7 @@ static int vlan_dev_init(struct net_device *dev)
 	dev->dev_id = real_dev->dev_id;
 
 	if (is_zero_ether_addr(dev->dev_addr)) {
-		ether_addr_copy(dev->dev_addr, real_dev->dev_addr);
+		eth_hw_addr_set(dev, real_dev->dev_addr);
 		dev->addr_assign_type = NET_ADDR_STOLEN;
 	}
 	if (is_zero_ether_addr(dev->broadcast))
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a2bf2d8ac65b7..11ec9e689589b 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -174,7 +174,7 @@ static int dsa_slave_set_mac_address(struct net_device *dev, void *a)
 		dev_uc_del(master, dev->dev_addr);
 
 out:
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	return 0;
 }
@@ -1954,7 +1954,7 @@ int dsa_slave_create(struct dsa_port *port)
 
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
 	if (!is_zero_ether_addr(port->mac))
-		ether_addr_copy(slave_dev->dev_addr, port->mac);
+		eth_hw_addr_set(slave_dev, port->mac);
 	else
 		eth_hw_addr_inherit(slave_dev, master);
 	slave_dev->priv_flags |= IFF_NO_QUEUE;
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index ea7b96e296ef0..a1045c3d71b4f 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -493,7 +493,7 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	INIT_LIST_HEAD(&hsr->self_node_db);
 	spin_lock_init(&hsr->list_lock);
 
-	ether_addr_copy(hsr_dev->dev_addr, slave[0]->dev_addr);
+	eth_hw_addr_set(hsr_dev, slave[0]->dev_addr);
 
 	/* initialize protocol specific functions */
 	if (protocol_version == PRP_V1) {
diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index f7e284f23b1f3..b099c31501509 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -75,7 +75,7 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 		master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 
 		if (port->type == HSR_PT_SLAVE_A) {
-			ether_addr_copy(master->dev->dev_addr, dev->dev_addr);
+			eth_hw_addr_set(master->dev, dev->dev_addr);
 			call_netdevice_notifiers(NETDEV_CHANGEADDR,
 						 master->dev);
 		}
-- 
2.35.1



