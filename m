Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B0C5EA2F9
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbiIZLRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237622AbiIZLQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:16:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E2865579;
        Mon, 26 Sep 2022 03:37:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3533D60A37;
        Mon, 26 Sep 2022 10:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6B2C433D6;
        Mon, 26 Sep 2022 10:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188648;
        bh=e0I7OQIVqGQ6TSsjZvTXgRKRPKRk9al7618vUPaC2rI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEHsv+CzZ6o2SnBjarBy0KPmBtq+NgKVJVDjAaAne715EvhVvUQgh94olBIwVxSdH
         kaog+dEvnzxpXkZB+IUTezsxpdOtVRki/D8bfJEFMkZUueESRww/I0os3uR84nuczS
         Kbk136d20K0YhwN/ngi5e6kQ1eVlpR89zhOMeB7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Poirier <bpoirier@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/148] net: bonding: Share lacpdu_mcast_addr definition
Date:   Mon, 26 Sep 2022 12:11:50 +0200
Message-Id: <20220926100758.892184405@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
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

[ Upstream commit 1d9a143ee3408349700f44a9197b7ae0e4faae5d ]

There are already a few definitions of arrays containing
MULTICAST_LACPDU_ADDR and the next patch will add one more use. These all
contain the same constant data so define one common instance for all
bonding code.

Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 86247aba599e ("net: bonding: Unsync device addresses on ndo_stop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_3ad.c  |  5 +++--
 drivers/net/bonding/bond_main.c | 16 ++++------------
 include/net/bond_3ad.h          |  2 --
 include/net/bonding.h           |  3 +++
 4 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 1f0120cbe9e8..8ad095c19f27 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -87,8 +87,9 @@ static const u8 null_mac_addr[ETH_ALEN + 2] __long_aligned = {
 static u16 ad_ticks_per_sec;
 static const int ad_delta_in_ticks = (AD_TIMER_INTERVAL * HZ) / 1000;
 
-static const u8 lacpdu_mcast_addr[ETH_ALEN + 2] __long_aligned =
-	MULTICAST_LACPDU_ADDR;
+const u8 lacpdu_mcast_addr[ETH_ALEN + 2] __long_aligned = {
+	0x01, 0x80, 0xC2, 0x00, 0x00, 0x02
+};
 
 /* ================= main 802.3ad protocol functions ================== */
 static int ad_lacpdu_send(struct port *port);
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index cd0d7b24f014..afeb213d02fc 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -862,12 +862,8 @@ static void bond_hw_addr_flush(struct net_device *bond_dev,
 	dev_uc_unsync(slave_dev, bond_dev);
 	dev_mc_unsync(slave_dev, bond_dev);
 
-	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
-		/* del lacpdu mc addr from mc list */
-		u8 lacpdu_multicast[ETH_ALEN] = MULTICAST_LACPDU_ADDR;
-
-		dev_mc_del(slave_dev, lacpdu_multicast);
-	}
+	if (BOND_MODE(bond) == BOND_MODE_8023AD)
+		dev_mc_del(slave_dev, lacpdu_mcast_addr);
 }
 
 /*--------------------------- Active slave change ---------------------------*/
@@ -2139,12 +2135,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		dev_uc_sync_multiple(slave_dev, bond_dev);
 		netif_addr_unlock_bh(bond_dev);
 
-		if (BOND_MODE(bond) == BOND_MODE_8023AD) {
-			/* add lacpdu mc addr to mc list */
-			u8 lacpdu_multicast[ETH_ALEN] = MULTICAST_LACPDU_ADDR;
-
-			dev_mc_add(slave_dev, lacpdu_multicast);
-		}
+		if (BOND_MODE(bond) == BOND_MODE_8023AD)
+			dev_mc_add(slave_dev, lacpdu_mcast_addr);
 	}
 
 	bond->slave_cnt++;
diff --git a/include/net/bond_3ad.h b/include/net/bond_3ad.h
index 184105d68294..f2273bd5a4c5 100644
--- a/include/net/bond_3ad.h
+++ b/include/net/bond_3ad.h
@@ -15,8 +15,6 @@
 #define PKT_TYPE_LACPDU         cpu_to_be16(ETH_P_SLOW)
 #define AD_TIMER_INTERVAL       100 /*msec*/
 
-#define MULTICAST_LACPDU_ADDR    {0x01, 0x80, 0xC2, 0x00, 0x00, 0x02}
-
 #define AD_LACP_SLOW 0
 #define AD_LACP_FAST 1
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 15e083e18f75..8c18c6b01634 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -757,6 +757,9 @@ extern struct rtnl_link_ops bond_link_ops;
 /* exported from bond_sysfs_slave.c */
 extern const struct sysfs_ops slave_sysfs_ops;
 
+/* exported from bond_3ad.c */
+extern const u8 lacpdu_mcast_addr[];
+
 static inline netdev_tx_t bond_tx_drop(struct net_device *dev, struct sk_buff *skb)
 {
 	atomic_long_inc(&dev->tx_dropped);
-- 
2.35.1



