Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381225EA4E9
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238635AbiIZL4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239038AbiIZLyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:54:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867B157E2E;
        Mon, 26 Sep 2022 03:50:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FE0C60AF3;
        Mon, 26 Sep 2022 10:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2835C433D6;
        Mon, 26 Sep 2022 10:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189289;
        bh=VyzeQ3A73WzZWuQ1QIIIEVGaB9CNiZoFtGOsM/3vM0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COipS0xnPhmXjucJSSVpRXpMMUyoSCH+OmoCKBFmdAR3BuZgq6nvpSgyxLMhakrBu
         wSSLlFev6SY5GKAuxLLDro2A+cEkOl9K5YEEqSsr95Iw4NuGmfSKCy5R6NELQofrRI
         Arkx3T3jiIn/6cQ6ufKxTGv0CJtVJQ2eZK/o37fE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Poirier <bpoirier@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 105/207] net: bonding: Share lacpdu_mcast_addr definition
Date:   Mon, 26 Sep 2022 12:11:34 +0200
Message-Id: <20220926100811.294285540@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
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
index bff0bfd10e23..b159b73f2969 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -865,12 +865,8 @@ static void bond_hw_addr_flush(struct net_device *bond_dev,
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
@@ -2144,12 +2140,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
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
index 3b816ae8b1f3..7ac1773b9922 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -785,6 +785,9 @@ extern struct rtnl_link_ops bond_link_ops;
 /* exported from bond_sysfs_slave.c */
 extern const struct sysfs_ops slave_sysfs_ops;
 
+/* exported from bond_3ad.c */
+extern const u8 lacpdu_mcast_addr[];
+
 static inline netdev_tx_t bond_tx_drop(struct net_device *dev, struct sk_buff *skb)
 {
 	dev_core_stats_tx_dropped_inc(dev);
-- 
2.35.1



