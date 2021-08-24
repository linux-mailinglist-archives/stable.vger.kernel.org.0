Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3308D3F640C
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbhHXRAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238859AbhHXQ7H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:59:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4FEF61507;
        Tue, 24 Aug 2021 16:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824249;
        bh=AjN8WuHeOJrEIHg9pF2uFBcczx+GuJ/SS/Dr/Eglj3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2WfO2tzI07+HDMspcKlihe/dErZjILCU0Z+8alpP0I2mO8+Wiv4mmt0Tr3sbaI7K
         GHwo6LmA2Rr4v2x2a7HEuO1evdVNbTL2OvvTaYs+z9LOznty1NooFpOu29Dx2MfSmn
         4NgeoODL2KmvqPxuuX1Bo9ez1an1uRVzv27yJKVrEgwW4RjZneBCo2tXtZKPoIyU0h
         j1fIPA99hm0jgER/XJbgXhbVgGn94S6BI0rKvkUGa4fAM6JOU3U7P4CBVRoId5sBWD
         xtQlK/6FC1muf2iy52cfWlqpXhprHFsPQeGlGadJFReVpMB8JDGHa0L5JYth7+yFtA
         wsHhJUmQor98g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Gurucharan G <Gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 082/127] iavf: Fix ping is lost after untrusted VF had tried to change MAC
Date:   Tue, 24 Aug 2021 12:55:22 -0400
Message-Id: <20210824165607.709387-83-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
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
index e8bd04100ecd..90793b36126e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -136,6 +136,7 @@ struct iavf_q_vector {
 struct iavf_mac_filter {
 	struct list_head list;
 	u8 macaddr[ETH_ALEN];
+	bool is_new_mac;	/* filter is new, wait for PF decision */
 	bool remove;		/* filter needs to be removed */
 	bool add;		/* filter needs to be added */
 };
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 244ec74ceca7..606a01ce4073 100644
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
index 0eab3c43bdc5..3c735968e1b8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -540,6 +540,47 @@ void iavf_del_ether_addrs(struct iavf_adapter *adapter)
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
@@ -1492,6 +1533,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		case VIRTCHNL_OP_ADD_ETH_ADDR:
 			dev_err(&adapter->pdev->dev, "Failed to add MAC filter, error %s\n",
 				iavf_stat_str(&adapter->hw, v_retval));
+			iavf_mac_add_reject(adapter);
 			/* restore administratively set MAC address */
 			ether_addr_copy(adapter->hw.mac.addr, netdev->dev_addr);
 			break;
@@ -1639,10 +1681,11 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
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

