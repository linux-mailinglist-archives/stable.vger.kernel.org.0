Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E764CF951
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239990AbiCGKE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239914AbiCGKA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:00:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516A37D01A;
        Mon,  7 Mar 2022 01:46:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AFF3B810AA;
        Mon,  7 Mar 2022 09:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8561AC340E9;
        Mon,  7 Mar 2022 09:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646391;
        bh=fNbghsphnqjd+aQ1YEnnQU2LeC4m4Eg5nLJWZLd4RgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nb5G82RHt/LiQyNfC+didCelyD/om50w2rogYEc469ZfX1uvO2oNj4FX59dNDAT+s
         hHz0mz0DKDYL1x+jlXEBEE1cMnTYMTpshs+k1nz9oX3hWilg+e94OPEIzrAjyCl8cB
         WpfAwKrWRlUn4MJYp3EfjyhXbtD0WxW5zJwUyhFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 229/262] iavf: Fix kernel BUG in free_msi_irqs
Date:   Mon,  7 Mar 2022 10:19:33 +0100
Message-Id: <20220307091709.659839241@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

[ Upstream commit 605ca7c5c670762e36ccb475cfa089d7ad0698e0 ]

Fix driver not freeing VF's traffic irqs, prior to calling
pci_disable_msix in iavf_remove.
There were possible 2 erroneous states in which, iavf_close would
not be called.
One erroneous state is fixed by allowing netdev to register, when state
is already running. It was possible for VF adapter to enter state loop
from running to resetting, where iavf_open would subsequently fail.
If user would then unload driver/remove VF pci, iavf_close would not be
called, as the netdev was not registered, leaving traffic pcis still
allocated.
Fixed this by breaking loop, allowing netdev to open device when adapter
state is __IAVF_RUNNING and it is not explicitily downed.
Other possiblity is entering to iavf_remove from __IAVF_RESETTING state,
where iavf_close would not free irqs, but just return 0.
Fixed this by checking for last adapter state and then removing irqs.

Kernel panic:
[ 2773.628585] kernel BUG at drivers/pci/msi.c:375!
...
[ 2773.631567] RIP: 0010:free_msi_irqs+0x180/0x1b0
...
[ 2773.640939] Call Trace:
[ 2773.641572]  pci_disable_msix+0xf7/0x120
[ 2773.642224]  iavf_reset_interrupt_capability.part.41+0x15/0x30 [iavf]
[ 2773.642897]  iavf_remove+0x12e/0x500 [iavf]
[ 2773.643578]  pci_device_remove+0x3b/0xc0
[ 2773.644266]  device_release_driver_internal+0x103/0x1f0
[ 2773.644948]  pci_stop_bus_device+0x69/0x90
[ 2773.645576]  pci_stop_and_remove_bus_device+0xe/0x20
[ 2773.646215]  pci_iov_remove_virtfn+0xba/0x120
[ 2773.646862]  sriov_disable+0x2f/0xe0
[ 2773.647531]  ice_free_vfs+0x2f8/0x350 [ice]
[ 2773.648207]  ice_sriov_configure+0x94/0x960 [ice]
[ 2773.648883]  ? _kstrtoull+0x3b/0x90
[ 2773.649560]  sriov_numvfs_store+0x10a/0x190
[ 2773.650249]  kernfs_fop_write+0x116/0x190
[ 2773.650948]  vfs_write+0xa5/0x1a0
[ 2773.651651]  ksys_write+0x4f/0xb0
[ 2773.652358]  do_syscall_64+0x5b/0x1a0
[ 2773.653075]  entry_SYSCALL_64_after_hwframe+0x65/0xca

Fixes: 22ead37f8af8 ("i40evf: Add longer wait after remove module")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h      | 36 +++++++++++++++++++++
 drivers/net/ethernet/intel/iavf/iavf_main.c | 20 ++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 997c45f2c542..21e0f3361560 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -395,6 +395,38 @@ struct iavf_device {
 extern char iavf_driver_name[];
 extern struct workqueue_struct *iavf_wq;
 
+static inline const char *iavf_state_str(enum iavf_state_t state)
+{
+	switch (state) {
+	case __IAVF_STARTUP:
+		return "__IAVF_STARTUP";
+	case __IAVF_REMOVE:
+		return "__IAVF_REMOVE";
+	case __IAVF_INIT_VERSION_CHECK:
+		return "__IAVF_INIT_VERSION_CHECK";
+	case __IAVF_INIT_GET_RESOURCES:
+		return "__IAVF_INIT_GET_RESOURCES";
+	case __IAVF_INIT_SW:
+		return "__IAVF_INIT_SW";
+	case __IAVF_INIT_FAILED:
+		return "__IAVF_INIT_FAILED";
+	case __IAVF_RESETTING:
+		return "__IAVF_RESETTING";
+	case __IAVF_COMM_FAILED:
+		return "__IAVF_COMM_FAILED";
+	case __IAVF_DOWN:
+		return "__IAVF_DOWN";
+	case __IAVF_DOWN_PENDING:
+		return "__IAVF_DOWN_PENDING";
+	case __IAVF_TESTING:
+		return "__IAVF_TESTING";
+	case __IAVF_RUNNING:
+		return "__IAVF_RUNNING";
+	default:
+		return "__IAVF_UNKNOWN_STATE";
+	}
+}
+
 static inline void iavf_change_state(struct iavf_adapter *adapter,
 				     enum iavf_state_t state)
 {
@@ -402,6 +434,10 @@ static inline void iavf_change_state(struct iavf_adapter *adapter,
 		adapter->last_state = adapter->state;
 		adapter->state = state;
 	}
+	dev_dbg(&adapter->pdev->dev,
+		"state transition from:%s to:%s\n",
+		iavf_state_str(adapter->last_state),
+		iavf_state_str(adapter->state));
 }
 
 int iavf_up(struct iavf_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 33a3dbcf8f2d..e97a8dbbbc89 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3325,6 +3325,13 @@ static int iavf_open(struct net_device *netdev)
 		goto err_unlock;
 	}
 
+	if (adapter->state == __IAVF_RUNNING &&
+	    !test_bit(__IAVF_VSI_DOWN, adapter->vsi.state)) {
+		dev_dbg(&adapter->pdev->dev, "VF is already open.\n");
+		err = 0;
+		goto err_unlock;
+	}
+
 	/* allocate transmit descriptors */
 	err = iavf_setup_all_tx_resources(adapter);
 	if (err)
@@ -3972,6 +3979,7 @@ static int __maybe_unused iavf_resume(struct device *dev_d)
 static void iavf_remove(struct pci_dev *pdev)
 {
 	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
+	enum iavf_state_t prev_state = adapter->last_state;
 	struct net_device *netdev = adapter->netdev;
 	struct iavf_fdir_fltr *fdir, *fdirtmp;
 	struct iavf_vlan_filter *vlf, *vlftmp;
@@ -4013,9 +4021,21 @@ static void iavf_remove(struct pci_dev *pdev)
 
 	adapter->aq_required = 0;
 	adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
+
 	iavf_free_all_tx_resources(adapter);
 	iavf_free_all_rx_resources(adapter);
 	iavf_free_misc_irq(adapter);
+
+	/* In case we enter iavf_remove from erroneous state, free traffic irqs
+	 * here, so as to not cause a kernel crash, when calling
+	 * iavf_reset_interrupt_capability.
+	 */
+	if ((adapter->last_state == __IAVF_RESETTING &&
+	     prev_state != __IAVF_DOWN) ||
+	    (adapter->last_state == __IAVF_RUNNING &&
+	     !(netdev->flags & IFF_UP)))
+		iavf_free_traffic_irqs(adapter);
+
 	iavf_reset_interrupt_capability(adapter);
 	iavf_free_q_vectors(adapter);
 
-- 
2.34.1



