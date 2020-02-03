Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00D65150C57
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730641AbgBCQfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:35:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730998AbgBCQfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:35:23 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D73272051A;
        Mon,  3 Feb 2020 16:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747722;
        bh=BJeyOg53CE8yFXKYW1iXox6u9fUIOkVtA3skUwSg2L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEs6PRVUpiwh33ZLx7/+5UsJbr2O7InXFxv5vnsWi1mMM6ATskQ0zuTXxEi8/ordX
         uotpRCMQwMBPW7kPBEiYFtEKWI0Ej3MJpsT3r7/zufVtLJrr0yKGklA28k9VfhKMDf
         EKa0becC0KWgrBZvAAGFy4P75ufglN2lT5eP+hqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Assmann <sassmann@kpanic.de>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/90] iavf: remove current MAC address filter on VF reset
Date:   Mon,  3 Feb 2020 16:19:45 +0000
Message-Id: <20200203161923.209520709@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

[ Upstream commit 9e05229190380f6b8f702da39aaeb97a0fc80dc3 ]

Currently MAC filters are not altered during a VF reset event. This may
lead to a stale filter when an administratively set MAC is forced by the
PF.

For an administratively set MAC the PF driver deletes the VFs filters,
overwrites the VFs MAC address and triggers a VF reset. However
the VF driver itself is not aware of the filter removal, which is what
the VF reset is for.
The VF reset queues all filters present in the VF driver to be re-added
to the PF filter list (including the filter for the now stale VF MAC
address) and triggers a VIRTCHNL_OP_GET_VF_RESOURCES event, which
provides the new MAC address to the VF.

When this happens i40e will complain and reject the stale MAC filter,
at least in the untrusted VF case.
i40e 0000:08:00.0: Setting MAC 3c:fa:fa:fa:fa:01 on VF 0
iavf 0000:08:02.0: Reset warning received from the PF
iavf 0000:08:02.0: Scheduling reset task
i40e 0000:08:00.0: Bring down and up the VF interface to make this change effective.
i40e 0000:08:00.0: VF attempting to override administratively set MAC address, bring down and up the VF interface to resume normal operation
i40e 0000:08:00.0: VF 0 failed opcode 10, retval: -1
iavf 0000:08:02.0: Failed to add MAC filter, error IAVF_ERR_NVM

To avoid re-adding the stale MAC filter it needs to be removed from the
VF driver's filter list before queuing the existing filters. Then during
the VIRTCHNL_OP_GET_VF_RESOURCES event the correct filter needs to be
added again, at which point the MAC address has been updated.

As a bonus this change makes bringing the VF down and up again
superfluous for the administratively set MAC case.

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h          |  2 ++
 drivers/net/ethernet/intel/iavf/iavf_main.c     | 17 +++++++++++++----
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c |  3 +++
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 29de3ae96ef22..bd1b1ed323f4f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -415,4 +415,6 @@ void iavf_enable_channels(struct iavf_adapter *adapter);
 void iavf_disable_channels(struct iavf_adapter *adapter);
 void iavf_add_cloud_filter(struct iavf_adapter *adapter);
 void iavf_del_cloud_filter(struct iavf_adapter *adapter);
+struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
+					const u8 *macaddr);
 #endif /* _IAVF_H_ */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 821987da5698a..8e16be960e96b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -743,9 +743,8 @@ iavf_mac_filter *iavf_find_filter(struct iavf_adapter *adapter,
  *
  * Returns ptr to the filter object or NULL when no memory available.
  **/
-static struct
-iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
-				 const u8 *macaddr)
+struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
+					const u8 *macaddr)
 {
 	struct iavf_mac_filter *f;
 
@@ -2065,9 +2064,9 @@ static void iavf_reset_task(struct work_struct *work)
 	struct virtchnl_vf_resource *vfres = adapter->vf_res;
 	struct net_device *netdev = adapter->netdev;
 	struct iavf_hw *hw = &adapter->hw;
+	struct iavf_mac_filter *f, *ftmp;
 	struct iavf_vlan_filter *vlf;
 	struct iavf_cloud_filter *cf;
-	struct iavf_mac_filter *f;
 	u32 reg_val;
 	int i = 0, err;
 	bool running;
@@ -2181,6 +2180,16 @@ static void iavf_reset_task(struct work_struct *work)
 
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
 
+	/* Delete filter for the current MAC address, it could have
+	 * been changed by the PF via administratively set MAC.
+	 * Will be re-added via VIRTCHNL_OP_GET_VF_RESOURCES.
+	 */
+	list_for_each_entry_safe(f, ftmp, &adapter->mac_filter_list, list) {
+		if (ether_addr_equal(f->macaddr, adapter->hw.mac.addr)) {
+			list_del(&f->list);
+			kfree(f);
+		}
+	}
 	/* re-add all MAC filters */
 	list_for_each_entry(f, &adapter->mac_filter_list, list) {
 		f->add = true;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index c46770eba320e..1ab9cb339acb4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1359,6 +1359,9 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 			ether_addr_copy(netdev->perm_addr,
 					adapter->hw.mac.addr);
 		}
+		spin_lock_bh(&adapter->mac_vlan_list_lock);
+		iavf_add_filter(adapter, adapter->hw.mac.addr);
+		spin_unlock_bh(&adapter->mac_vlan_list_lock);
 		iavf_process_config(adapter);
 		}
 		break;
-- 
2.20.1



