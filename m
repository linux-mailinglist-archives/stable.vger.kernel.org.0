Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72633ED58A
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239449AbhHPNMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237599AbhHPNI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:08:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 142D863292;
        Mon, 16 Aug 2021 13:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119232;
        bh=9+9XOk85IsP739cIze54vro3URXnfgTsykq4TG5YyJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nqmwCRthBbNS4xLqUv3++YieXGxejxjwvsYVoTFocRiY9RLsrZaoD+TFmIu68+/l
         ftQmU/g4uM9WuW19xkoGSIzOhVaX92VL0hU8PVoZN8KiuiN2itF/QxTF4mpEXWYIGw
         oSzpkTyRr6qHHYqLFr85ZdbxPamJ9hUpETMgnBnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Liang Li <liali@redhat.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 44/96] ice: dont remove netdev->dev_addr from uc sync list
Date:   Mon, 16 Aug 2021 15:01:54 +0200
Message-Id: <20210816125436.430407177@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit 3ba7f53f8bf1fb862e36c7f74434ac3aceb60158 ]

In some circumstances, such as with bridging, it's possible that the
stack will add the device's own MAC address to its unicast address list.

If, later, the stack deletes this address, the driver will receive a
request to remove this address.

The driver stores its current MAC address as part of the VSI MAC filter
list instead of separately. So, this causes a problem when the device's
MAC address is deleted unexpectedly, which results in traffic failure in
some cases.

The following configuration steps will reproduce the previously
mentioned problem:

> ip link set eth0 up
> ip link add dev br0 type bridge
> ip link set br0 up
> ip addr flush dev eth0
> ip link set eth0 master br0
> echo 1 > /sys/class/net/br0/bridge/vlan_filtering
> modprobe -r veth
> modprobe -r bridge
> ip addr add 192.168.1.100/24 dev eth0

The following ping command fails due to the netdev->dev_addr being
deleted when removing the bridge module.
> ping <link partner>

Fix this by making sure to not delete the netdev->dev_addr during MAC
address sync. After fixing this issue it was noticed that the
netdev_warn() in .set_mac was overly verbose, so make it at
netdev_dbg().

Also, there is a possibility of a race condition between .set_mac and
.set_rx_mode. Fix this by calling netif_addr_lock_bh() and
netif_addr_unlock_bh() on the device's netdev when the netdev->dev_addr
is going to be updated in .set_mac.

Fixes: e94d44786693 ("ice: Implement filter sync, NDO operations and bump version")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Liang Li <liali@redhat.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6421e9fd69a2..a46780570cd9 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -189,6 +189,14 @@ static int ice_add_mac_to_unsync_list(struct net_device *netdev, const u8 *addr)
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 
+	/* Under some circumstances, we might receive a request to delete our
+	 * own device address from our uc list. Because we store the device
+	 * address in the VSI's MAC filter list, we need to ignore such
+	 * requests and not delete our device address from this list.
+	 */
+	if (ether_addr_equal(addr, netdev->dev_addr))
+		return 0;
+
 	if (ice_fltr_add_mac_to_list(vsi, &vsi->tmp_unsync_list, addr,
 				     ICE_FWD_TO_VSI))
 		return -EINVAL;
@@ -4881,7 +4889,7 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 		return -EADDRNOTAVAIL;
 
 	if (ether_addr_equal(netdev->dev_addr, mac)) {
-		netdev_warn(netdev, "already using mac %pM\n", mac);
+		netdev_dbg(netdev, "already using mac %pM\n", mac);
 		return 0;
 	}
 
@@ -4892,6 +4900,7 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 		return -EBUSY;
 	}
 
+	netif_addr_lock_bh(netdev);
 	/* Clean up old MAC filter. Not an error if old filter doesn't exist */
 	status = ice_fltr_remove_mac(vsi, netdev->dev_addr, ICE_FWD_TO_VSI);
 	if (status && status != ICE_ERR_DOES_NOT_EXIST) {
@@ -4901,30 +4910,28 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 
 	/* Add filter for new MAC. If filter exists, return success */
 	status = ice_fltr_add_mac(vsi, mac, ICE_FWD_TO_VSI);
-	if (status == ICE_ERR_ALREADY_EXISTS) {
+	if (status == ICE_ERR_ALREADY_EXISTS)
 		/* Although this MAC filter is already present in hardware it's
 		 * possible in some cases (e.g. bonding) that dev_addr was
 		 * modified outside of the driver and needs to be restored back
 		 * to this value.
 		 */
-		memcpy(netdev->dev_addr, mac, netdev->addr_len);
 		netdev_dbg(netdev, "filter for MAC %pM already exists\n", mac);
-		return 0;
-	}
-
-	/* error if the new filter addition failed */
-	if (status)
+	else if (status)
+		/* error if the new filter addition failed */
 		err = -EADDRNOTAVAIL;
 
 err_update_filters:
 	if (err) {
 		netdev_err(netdev, "can't set MAC %pM. filter update failed\n",
 			   mac);
+		netif_addr_unlock_bh(netdev);
 		return err;
 	}
 
 	/* change the netdev's MAC address */
 	memcpy(netdev->dev_addr, mac, netdev->addr_len);
+	netif_addr_unlock_bh(netdev);
 	netdev_dbg(vsi->netdev, "updated MAC address to %pM\n",
 		   netdev->dev_addr);
 
-- 
2.30.2



