Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E192E441719
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhKAJc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:32:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232955AbhKAJa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:30:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 823A8611C3;
        Mon,  1 Nov 2021 09:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758642;
        bh=whK8dXXSHGtjp7fUO0uGdvOWOGmrtBzFwivuSbaxon4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QtEG9yOzYZE1hmymClXtW5IFv2oqX5n9NlBTlpG6X/YJzl9hgkcPXcz99LrJ4VkQb
         m+97NuGExGY4YeFpElNEWkQGF6JTbZsyBbqkBLnnn9b9IKNA7cFEaX7xoekWHZetpe
         jKhkL9S4KSRDHfc3TcJlqv8wJW03Pjasp4ULJ/pk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 47/51] net: use netif_is_bridge_port() to check for IFF_BRIDGE_PORT
Date:   Mon,  1 Nov 2021 10:17:51 +0100
Message-Id: <20211101082511.530757274@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 2e92a2d0e450740ebe7e7a816162327ad1fde94b ]

Trivial cleanup, so that all bridge port-specific code can be found in
one go.

CC: Johannes Berg <johannes@sipsolutions.net>
CC: Roopa Prabhu <roopa@cumulusnetworks.com>
CC: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c       |  2 +-
 drivers/net/ethernet/micrel/ksz884x.c |  2 +-
 net/core/rtnetlink.c                  | 12 ++++++------
 net/wireless/nl80211.c                |  2 +-
 net/wireless/util.c                   |  2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 1949f631e1bc..a7eaf80f500c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1219,7 +1219,7 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
 	skb->dev = bond->dev;
 
 	if (BOND_MODE(bond) == BOND_MODE_ALB &&
-	    bond->dev->priv_flags & IFF_BRIDGE_PORT &&
+	    netif_is_bridge_port(bond->dev) &&
 	    skb->pkt_type == PACKET_HOST) {
 
 		if (unlikely(skb_cow_head(skb,
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 7dc451fdaf35..2431723bc2fb 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -5693,7 +5693,7 @@ static void dev_set_promiscuous(struct net_device *dev, struct dev_priv *priv,
 		 * from the bridge.
 		 */
 		if ((hw->features & STP_SUPPORT) && !promiscuous &&
-		    (dev->priv_flags & IFF_BRIDGE_PORT)) {
+		    netif_is_bridge_port(dev)) {
 			struct ksz_switch *sw = hw->ksz_switch;
 			int port = priv->port.first_port;
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index a53b101ce41a..55c0f32b9375 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3729,7 +3729,7 @@ static int rtnl_fdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	/* Support fdb on master device the net/bridge default case */
 	if ((!ndm->ndm_flags || ndm->ndm_flags & NTF_MASTER) &&
-	    (dev->priv_flags & IFF_BRIDGE_PORT)) {
+	    netif_is_bridge_port(dev)) {
 		struct net_device *br_dev = netdev_master_upper_dev_get(dev);
 		const struct net_device_ops *ops = br_dev->netdev_ops;
 
@@ -3840,7 +3840,7 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	/* Support fdb on master device the net/bridge default case */
 	if ((!ndm->ndm_flags || ndm->ndm_flags & NTF_MASTER) &&
-	    (dev->priv_flags & IFF_BRIDGE_PORT)) {
+	    netif_is_bridge_port(dev)) {
 		struct net_device *br_dev = netdev_master_upper_dev_get(dev);
 		const struct net_device_ops *ops = br_dev->netdev_ops;
 
@@ -4066,13 +4066,13 @@ static int rtnl_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
 				continue;
 
 			if (!br_idx) { /* user did not specify a specific bridge */
-				if (dev->priv_flags & IFF_BRIDGE_PORT) {
+				if (netif_is_bridge_port(dev)) {
 					br_dev = netdev_master_upper_dev_get(dev);
 					cops = br_dev->netdev_ops;
 				}
 			} else {
 				if (dev != br_dev &&
-				    !(dev->priv_flags & IFF_BRIDGE_PORT))
+				    !netif_is_bridge_port(dev))
 					continue;
 
 				if (br_dev != netdev_master_upper_dev_get(dev) &&
@@ -4084,7 +4084,7 @@ static int rtnl_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
 			if (idx < s_idx)
 				goto cont;
 
-			if (dev->priv_flags & IFF_BRIDGE_PORT) {
+			if (netif_is_bridge_port(dev)) {
 				if (cops && cops->ndo_fdb_dump) {
 					err = cops->ndo_fdb_dump(skb, cb,
 								br_dev, dev,
@@ -4234,7 +4234,7 @@ static int rtnl_fdb_get(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 
 	if (dev) {
 		if (!ndm_flags || (ndm_flags & NTF_MASTER)) {
-			if (!(dev->priv_flags & IFF_BRIDGE_PORT)) {
+			if (!netif_is_bridge_port(dev)) {
 				NL_SET_ERR_MSG(extack, "Device is not a bridge port");
 				return -EINVAL;
 			}
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7b170ed6923e..7633d6a74bc2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3480,7 +3480,7 @@ static int nl80211_valid_4addr(struct cfg80211_registered_device *rdev,
 			       enum nl80211_iftype iftype)
 {
 	if (!use_4addr) {
-		if (netdev && (netdev->priv_flags & IFF_BRIDGE_PORT))
+		if (netdev && netif_is_bridge_port(netdev))
 			return -EBUSY;
 		return 0;
 	}
diff --git a/net/wireless/util.c b/net/wireless/util.c
index f0247eab5bc9..82b3baed2c7d 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -976,7 +976,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		return -EOPNOTSUPP;
 
 	/* if it's part of a bridge, reject changing type to station/ibss */
-	if ((dev->priv_flags & IFF_BRIDGE_PORT) &&
+	if (netif_is_bridge_port(dev) &&
 	    (ntype == NL80211_IFTYPE_ADHOC ||
 	     ntype == NL80211_IFTYPE_STATION ||
 	     ntype == NL80211_IFTYPE_P2P_CLIENT))
-- 
2.33.0



