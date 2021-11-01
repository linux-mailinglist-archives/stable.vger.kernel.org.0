Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F9144188E
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbhKAJtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:49:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234134AbhKAJrW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:47:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CC1A61409;
        Mon,  1 Nov 2021 09:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759059;
        bh=mUMnDLT1havrmlYLy9rDK1MLXhWgSSzQ35hNqEv4XxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kayOL2Db/RJ9tD/9E4CWhbLmpa/DrYA2qAeIxCfHPgaT/ZaxioS55snG20Z9QtEWb
         /Y3im6b2NKE/BCkh+lMr2M31QXQEjRtMSjV1Gajd0/Tqieq//UYUSGUjeQ8mq82JcS
         +DIpFg5Ee+s4zrnH2MTZwrzLPKABXk5PFdHLAAG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Ertman <david.m.ertman@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.14 070/125] ice: Respond to a NETDEV_UNREGISTER event for LAG
Date:   Mon,  1 Nov 2021 10:17:23 +0100
Message-Id: <20211101082546.454283355@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

commit 6a8b357278f5f8b9817147277ab8f12879dce8a8 upstream.

When the PF is a member of a link aggregate, and the driver
is removed, the process will hang unless we respond to the
NETDEV_UNREGISTER event that is sent to the event_handler
for LAG.

Add a case statement for the ice_lag_event_handler to unlink
the PF from the link aggregate.

Also remove code that was incorrectly applying a dev_hold to
peer_netdevs that were associated with the ice driver.

Fixes: df006dd4b1dc ("ice: Add initial support framework for LAG")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_lag.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -100,9 +100,9 @@ static void ice_display_lag_info(struct
  */
 static void ice_lag_info_event(struct ice_lag *lag, void *ptr)
 {
-	struct net_device *event_netdev, *netdev_tmp;
 	struct netdev_notifier_bonding_info *info;
 	struct netdev_bonding_info *bonding_info;
+	struct net_device *event_netdev;
 	const char *lag_netdev_name;
 
 	event_netdev = netdev_notifier_info_to_dev(ptr);
@@ -123,19 +123,6 @@ static void ice_lag_info_event(struct ic
 		goto lag_out;
 	}
 
-	rcu_read_lock();
-	for_each_netdev_in_bond_rcu(lag->upper_netdev, netdev_tmp) {
-		if (!netif_is_ice(netdev_tmp))
-			continue;
-
-		if (netdev_tmp && netdev_tmp != lag->netdev &&
-		    lag->peer_netdev != netdev_tmp) {
-			dev_hold(netdev_tmp);
-			lag->peer_netdev = netdev_tmp;
-		}
-	}
-	rcu_read_unlock();
-
 	if (bonding_info->slave.state)
 		ice_lag_set_backup(lag);
 	else
@@ -319,6 +306,9 @@ ice_lag_event_handler(struct notifier_bl
 	case NETDEV_BONDING_INFO:
 		ice_lag_info_event(lag, ptr);
 		break;
+	case NETDEV_UNREGISTER:
+		ice_lag_unlink(lag, ptr);
+		break;
 	default:
 		break;
 	}


