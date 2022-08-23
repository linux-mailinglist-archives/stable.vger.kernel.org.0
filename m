Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C9359DDDD
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353048AbiHWKKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351870AbiHWKIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:08:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032A27D7B0;
        Tue, 23 Aug 2022 01:54:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF088B81C39;
        Tue, 23 Aug 2022 08:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDC1C433C1;
        Tue, 23 Aug 2022 08:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244890;
        bh=XoeuMJNEjEkczly+dAJKTnNDDgHKZv6zGPaKXsLWA14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmI+xTAk0Yc6IhJXUVKu7dmFNZZ9fN+Gmhq7ZcAkjBAlEWj7RAnkDKoAgPlJrxfUK
         NjJBp40F0P4Wzh8DFceEMYxfmTFQ85clJ4zOq+8kYmPA54vdcwVFcTHrbd4KQoIsxC
         8nrPvbgRDSd0UBLBD5DHwis4RA8rnS6NBaYsm4TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 150/244] igb: Add lock to avoid data race
Date:   Tue, 23 Aug 2022 10:25:09 +0200
Message-Id: <20220823080104.179879082@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit 6faee3d4ee8be0f0367d0c3d826afb3571b7a5e0 upstream.

The commit c23d92b80e0b ("igb: Teardown SR-IOV before
unregister_netdev()") places the unregister_netdev() call after the
igb_disable_sriov() call to avoid functionality issue.

However, it introduces several race conditions when detaching a device.
For example, when .remove() is called, the below interleaving leads to
use-after-free.

 (FREE from device detaching)      |   (USE from netdev core)
igb_remove                         |  igb_ndo_get_vf_config
 igb_disable_sriov                 |  vf >= adapter->vfs_allocated_count?
  kfree(adapter->vf_data)          |
  adapter->vfs_allocated_count = 0 |
                                   |    memcpy(... adapter->vf_data[vf]

Moreover, the igb_disable_sriov() also suffers from data race with the
requests from VF driver.

 (FREE from device detaching)      |   (USE from requests)
igb_remove                         |  igb_msix_other
 igb_disable_sriov                 |   igb_msg_task
  kfree(adapter->vf_data)          |    vf < adapter->vfs_allocated_count
  adapter->vfs_allocated_count = 0 |

To this end, this commit first eliminates the data races from netdev
core by using rtnl_lock (similar to commit 719479230893 ("dpaa2-eth: add
MAC/PHY support through phylink")). And then adds a spinlock to
eliminate races from driver requests. (similar to commit 1e53834ce541
("ixgbe: Add locking to prevent panic when setting sriov_numvfs to zero")

Fixes: c23d92b80e0b ("igb: Teardown SR-IOV before unregister_netdev()")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20220817184921.735244-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igb/igb.h      |    2 ++
 drivers/net/ethernet/intel/igb/igb_main.c |   12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -664,6 +664,8 @@ struct igb_adapter {
 	struct igb_mac_addr *mac_table;
 	struct vf_mac_filter vf_macs;
 	struct vf_mac_filter *vf_mac_list;
+	/* lock for VF resources */
+	spinlock_t vfs_lock;
 };
 
 /* flags controlling PTP/1588 function */
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3637,6 +3637,7 @@ static int igb_disable_sriov(struct pci_
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct igb_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
+	unsigned long flags;
 
 	/* reclaim resources allocated to VFs */
 	if (adapter->vf_data) {
@@ -3649,12 +3650,13 @@ static int igb_disable_sriov(struct pci_
 			pci_disable_sriov(pdev);
 			msleep(500);
 		}
-
+		spin_lock_irqsave(&adapter->vfs_lock, flags);
 		kfree(adapter->vf_mac_list);
 		adapter->vf_mac_list = NULL;
 		kfree(adapter->vf_data);
 		adapter->vf_data = NULL;
 		adapter->vfs_allocated_count = 0;
+		spin_unlock_irqrestore(&adapter->vfs_lock, flags);
 		wr32(E1000_IOVCTL, E1000_IOVCTL_REUSE_VFQ);
 		wrfl();
 		msleep(100);
@@ -3814,7 +3816,9 @@ static void igb_remove(struct pci_dev *p
 	igb_release_hw_control(adapter);
 
 #ifdef CONFIG_PCI_IOV
+	rtnl_lock();
 	igb_disable_sriov(pdev);
+	rtnl_unlock();
 #endif
 
 	unregister_netdev(netdev);
@@ -3974,6 +3978,9 @@ static int igb_sw_init(struct igb_adapte
 
 	spin_lock_init(&adapter->nfc_lock);
 	spin_lock_init(&adapter->stats64_lock);
+
+	/* init spinlock to avoid concurrency of VF resources */
+	spin_lock_init(&adapter->vfs_lock);
 #ifdef CONFIG_PCI_IOV
 	switch (hw->mac.type) {
 	case e1000_82576:
@@ -7846,8 +7853,10 @@ unlock:
 static void igb_msg_task(struct igb_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
+	unsigned long flags;
 	u32 vf;
 
+	spin_lock_irqsave(&adapter->vfs_lock, flags);
 	for (vf = 0; vf < adapter->vfs_allocated_count; vf++) {
 		/* process any reset requests */
 		if (!igb_check_for_rst(hw, vf))
@@ -7861,6 +7870,7 @@ static void igb_msg_task(struct igb_adap
 		if (!igb_check_for_ack(hw, vf))
 			igb_rcv_ack_from_vf(adapter, vf);
 	}
+	spin_unlock_irqrestore(&adapter->vfs_lock, flags);
 }
 
 /**


