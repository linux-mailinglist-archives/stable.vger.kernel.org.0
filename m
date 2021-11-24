Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BBC45C512
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347602AbhKXNyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:54:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354675AbhKXNwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:52:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D304363217;
        Wed, 24 Nov 2021 13:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759097;
        bh=2tKJaBA5c8WEaBp1u+IDUjcTiU1IhKkbgOVhBFGmA+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LkICFexG7b/Q6S6Lo/m1Wx1m9x1jTYkuTz9t3UAmdVjRpRaWFtCE7+q8E/dMElqJ6
         vx3Gh7xP+AsXuQvNTHVx5g4E6AK75U1vxM5pYk5SpsPzReRL7q75ou69dlZTzcbvrG
         OPQNiUhu4SLO0pSvJhkexQHc86W5xeoYrE+TzhiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/279] iavf: Restore VLAN filters after link down
Date:   Wed, 24 Nov 2021 12:56:59 +0100
Message-Id: <20211124115723.358367615@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

[ Upstream commit 4293014230b887d94b68aa460ff00153454a3709 ]

Restore VLAN filters after the link is brought down, and up - since all
filters are deleted from HW during the netdev link down routine.

Fixes: ed1f5b58ea01 ("i40evf: remove VLAN filters on close")
Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h      |  1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c | 35 ++++++++++++++++++---
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 68c80f04113c8..46312a4415baf 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -39,6 +39,7 @@
 #include "iavf_txrx.h"
 #include "iavf_fdir.h"
 #include "iavf_adv_rss.h"
+#include <linux/bitmap.h>
 
 #define DEFAULT_DEBUG_LEVEL_SHIFT 3
 #define PFX "iavf: "
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index d537d50525e3f..aaf8a2f396e46 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -687,6 +687,23 @@ static void iavf_del_vlan(struct iavf_adapter *adapter, u16 vlan)
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
 }
 
+/**
+ * iavf_restore_filters
+ * @adapter: board private structure
+ *
+ * Restore existing non MAC filters when VF netdev comes back up
+ **/
+static void iavf_restore_filters(struct iavf_adapter *adapter)
+{
+	/* re-add all VLAN filters */
+	if (VLAN_ALLOWED(adapter)) {
+		u16 vid;
+
+		for_each_set_bit(vid, adapter->vsi.active_vlans, VLAN_N_VID)
+			iavf_add_vlan(adapter, vid);
+	}
+}
+
 /**
  * iavf_vlan_rx_add_vid - Add a VLAN filter to a device
  * @netdev: network device struct
@@ -700,8 +717,11 @@ static int iavf_vlan_rx_add_vid(struct net_device *netdev,
 
 	if (!VLAN_ALLOWED(adapter))
 		return -EIO;
+
 	if (iavf_add_vlan(adapter, vid) == NULL)
 		return -ENOMEM;
+
+	set_bit(vid, adapter->vsi.active_vlans);
 	return 0;
 }
 
@@ -716,11 +736,13 @@ static int iavf_vlan_rx_kill_vid(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
-	if (VLAN_ALLOWED(adapter)) {
-		iavf_del_vlan(adapter, vid);
-		return 0;
-	}
-	return -EIO;
+	if (!VLAN_ALLOWED(adapter))
+		return -EIO;
+
+	iavf_del_vlan(adapter, vid);
+	clear_bit(vid, adapter->vsi.active_vlans);
+
+	return 0;
 }
 
 /**
@@ -3248,6 +3270,9 @@ static int iavf_open(struct net_device *netdev)
 
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
 
+	/* Restore VLAN filters that were removed with IFF_DOWN */
+	iavf_restore_filters(adapter);
+
 	iavf_configure(adapter);
 
 	iavf_up_complete(adapter);
-- 
2.33.0



