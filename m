Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA08B6C1781
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbjCTPOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbjCTPOI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:14:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2DC24BD0
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:09:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 238E56154D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3958EC433D2;
        Mon, 20 Mar 2023 15:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324947;
        bh=S2b6AX0vXQ4ZAW1SspSCFbw7GcHIXNPPW6vsXxINsLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBVBZDte0OTQeEOXga37fxUIZi9E9D3zZ3DPgCuFb7a0uQnkgEowx22rvWF79qZEs
         UxyzR3lpVw6VGcrB7GNfIjb/GPJHRiU8XjIqhROsJ57BracobKNwQHaor+5iSS5UK/
         wtWJbbhQ9Cgqh4G9hqGiXNJFSpcHq5HScrGOJBXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/115] bonding: restore IFF_MASTER/SLAVE flags on bond enslave ether type change
Date:   Mon, 20 Mar 2023 15:54:23 +0100
Message-Id: <20230320145451.552929366@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 9ec7eb60dcbcb6c41076defbc5df7bbd95ceaba5 ]

Add bond_ether_setup helper which is used to fix ether_setup() calls in the
bonding driver. It takes care of both IFF_MASTER and IFF_SLAVE flags, the
former is always restored and the latter only if it was set.
If the bond enslaves non-ARPHRD_ETHER device (changes its type), then
releases it and enslaves ARPHRD_ETHER device (changes back) then we
use ether_setup() to restore the bond device type but it also resets its
flags and removes IFF_MASTER and IFF_SLAVE[1]. Use the bond_ether_setup
helper to restore both after such transition.

[1] reproduce (nlmon is non-ARPHRD_ETHER):
 $ ip l add nlmon0 type nlmon
 $ ip l add bond2 type bond mode active-backup
 $ ip l set nlmon0 master bond2
 $ ip l set nlmon0 nomaster
 $ ip l add bond1 type bond
 (we use bond1 as ARPHRD_ETHER device to restore bond2's mode)
 $ ip l set bond1 master bond2
 $ ip l sh dev bond2
 37: bond2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether be:d7:c5:40:5b:cc brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 1500
 (notice bond2's IFF_MASTER is missing)

Fixes: e36b9d16c6a6 ("bonding: clean muticast addresses when device changes type")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 456298919d541..b2db30d5f1f45 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1744,6 +1744,19 @@ void bond_lower_state_changed(struct slave *slave)
 		slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
 } while (0)
 
+/* The bonding driver uses ether_setup() to convert a master bond device
+ * to ARPHRD_ETHER, that resets the target netdevice's flags so we always
+ * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE if it was set
+ */
+static void bond_ether_setup(struct net_device *bond_dev)
+{
+	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
+
+	ether_setup(bond_dev);
+	bond_dev->flags |= IFF_MASTER | slave_flag;
+	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+}
+
 /* enslave device <slave> to bond device <master> */
 int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		 struct netlink_ext_ack *extack)
@@ -1835,10 +1848,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 			if (slave_dev->type != ARPHRD_ETHER)
 				bond_setup_by_slave(bond_dev, slave_dev);
-			else {
-				ether_setup(bond_dev);
-				bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-			}
+			else
+				bond_ether_setup(bond_dev);
 
 			call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE,
 						 bond_dev);
-- 
2.39.2



