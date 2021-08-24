Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C813F6537
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239171AbhHXRKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239384AbhHXRJF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:09:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3643761A51;
        Tue, 24 Aug 2021 17:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824421;
        bh=3ptPghadu1Imn4MYEIpGfTLp9PMoiyFdNQn2geEu2Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0cy/gxBEyJXrcK7GhdeEe446X027uMkD8YI6bSuCHjvcyEbG9f4W9dviNTWewLGI
         N29zb+1Vp0TiYSKl92XLpJ4rHZU919/7Vvzbqc1Ucuy/+DbBs45qdHgXyrX2qu2oWo
         Qtzg0i1syXmxgIFgGTE8sEYveuUt3TETKaeI/eRr7Hl16pmSSsUeWh8Bk1hO699J6L
         c2e4on2n0uQ2tkPfFG09zLXow3bOF8LawL0YFCC1Aw+/S6y/xTDpXE04Fak6nqo1YH
         pM5lR3EkOPKNbk4wjFFAN/Dwz67rymfsPLWFrn8mZYBaAIqR9F/4e+tJqmSVhvsi4e
         pc2cJ65Vatpqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Gurucharan G <Gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 71/98] iavf: Fix ping is lost after untrusted VF had tried to change MAC
Date:   Tue, 24 Aug 2021 12:58:41 -0400
Message-Id: <20210824165908.709932-72-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

[ Upstream commit 8da80c9d50220a8e4190a4eaa0dd6aeefcbbb5bf ]

Make changes to MAC address dependent on the response of PF.
Disallow changes to HW MAC address and MAC filter from untrusted
VF, thanks to that ping is not lost if VF tries to change MAC.
Add a new field in iavf_mac_filter, to indicate whether there
was response from PF for given filter. Based on this field pass
or discard the filter.
If untrusted VF tried to change it's address, it's not changed.
Still filter was changed, because of that ping couldn't go through.

Fixes: c5c922b3e09b ("iavf: fix MAC address setting for VFs when filter is rejected")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Gurucharan G <Gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |  1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  1 +
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 47 ++++++++++++++++++-
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 8a65525a7c0d..6766446a33f4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -134,6 +134,7 @@ struct iavf_q_vector {
 struct iavf_mac_filter {
 	struct list_head list;
 	u8 macaddr[ETH_ALEN];
+	bool is_new_mac;	/* filter is new, wait for PF decision */
 	bool remove;		/* filter needs to be removed */
 	bool add;		/* filter needs to be added */
 };
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index c4ec9a91c7c5..7023aa147043 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -751,6 +751,7 @@ struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
 
 		list_add_tail(&f->list, &adapter->mac_filter_list);
 		f->add = true;
+		f->is_new_mac = true;
 		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
 	} else {
 		f->remove = false;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index ed08ace4f05a..8be3151f2c62 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -537,6 +537,47 @@ void iavf_del_ether_addrs(struct iavf_adapter *adapter)
 	kfree(veal);
 }
 
+/**
+ * iavf_mac_add_ok
+ * @adapter: adapter structure
+ *
+ * Submit list of filters based on PF response.
+ **/
+static void iavf_mac_add_ok(struct iavf_adapter *adapter)
+{
+	struct iavf_mac_filter *f, *ftmp;
+
+	spin_lock_bh(&adapter->mac_vlan_list_lock);
+	list_for_each_entry_safe(f, ftmp, &adapter->mac_filter_list, list) {
+		f->is_new_mac = false;
+	}
+	spin_unlock_bh(&adapter->mac_vlan_list_lock);
+}
+
+/**
+ * iavf_mac_add_reject
+ * @adapter: adapter structure
+ *
+ * Remove filters from list based on PF response.
+ **/
+static void iavf_mac_add_reject(struct iavf_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct iavf_mac_filter *f, *ftmp;
+
+	spin_lock_bh(&adapter->mac_vlan_list_lock);
+	list_for_each_entry_safe(f, ftmp, &adapter->mac_filter_list, list) {
+		if (f->remove && ether_addr_equal(f->macaddr, netdev->dev_addr))
+			f->remove = false;
+
+		if (f->is_new_mac) {
+			list_del(&f->list);
+			kfree(f);
+		}
+	}
+	spin_unlock_bh(&adapter->mac_vlan_list_lock);
+}
+
 /**
  * iavf_add_vlans
  * @adapter: adapter structure
@@ -1295,6 +1336,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		case VIRTCHNL_OP_ADD_ETH_ADDR:
 			dev_err(&adapter->pdev->dev, "Failed to add MAC filter, error %s\n",
 				iavf_stat_str(&adapter->hw, v_retval));
+			iavf_mac_add_reject(adapter);
 			/* restore administratively set MAC address */
 			ether_addr_copy(adapter->hw.mac.addr, netdev->dev_addr);
 			break;
@@ -1364,10 +1406,11 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		}
 	}
 	switch (v_opcode) {
-	case VIRTCHNL_OP_ADD_ETH_ADDR: {
+	case VIRTCHNL_OP_ADD_ETH_ADDR:
+		if (!v_retval)
+			iavf_mac_add_ok(adapter);
 		if (!ether_addr_equal(netdev->dev_addr, adapter->hw.mac.addr))
 			ether_addr_copy(netdev->dev_addr, adapter->hw.mac.addr);
-		}
 		break;
 	case VIRTCHNL_OP_GET_STATS: {
 		struct iavf_eth_stats *stats =
-- 
2.30.2

