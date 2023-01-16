Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14AC366CB17
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbjAPRKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjAPRKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:10:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C405143455
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6400EB80DC7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE67BC43392;
        Mon, 16 Jan 2023 16:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887813;
        bh=G7o+z5biCjiN7A64QghO4NLA4xg3/x5XsZ9Yj/CCg30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V03RfiDBsBC862IIHenLFV3pq1Q36NKtCzG2tW6ZoKYpvhPAvoVXF29U9Ec7UEhUg
         UpJ4TN5d3AgJm1ur30zLtAdqHJNyeMd/Oge8gfsGpIhB6y1kokpVA1EPqnUFMmv3UQ
         favdmwsqrqROwXK2OYDKakza9Ry2KXwzHfLuUIRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sam Bobroff <sbobroff@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 290/521] powerpc/eeh: EEH for pSeries hot plug
Date:   Mon, 16 Jan 2023 16:49:12 +0100
Message-Id: <20230116154900.100777030@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Bobroff <sbobroff@linux.ibm.com>

[ Upstream commit b905f8cdca7725e750a84f7188ea6821750124c3 ]

On PowerNV and pSeries, devices currently acquire EEH support from
several different places: Boot-time devices from eeh_probe_devices()
and eeh_addr_cache_build(), Virtual Function devices from the pcibios
bus add device hooks and hot plugged devices from pci_hp_add_devices()
(with other platforms using other methods as well).  Unfortunately,
pSeries machines currently discover hot plugged devices using
pci_rescan_bus(), not pci_hp_add_devices(), and so those devices do
not receive EEH support.

Rather than adding another case for pci_rescan_bus(), this change
widens the scope of the pcibios bus add device hooks so that they can
handle all devices. As a side effect this also supports devices
discovered after manually rescanning via /sys/bus/pci/rescan.

Note that on PowerNV, this change allows the EEH subsystem to become
enabled after boot as long as it has not been forced off, which was
not previously possible (it was already possible on pSeries).

Signed-off-by: Sam Bobroff <sbobroff@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/72ae8ae9c54097158894a52de23690448de38ea9.1565930772.git.sbobroff@linux.ibm.com
Stable-dep-of: 9aafbfa5f57a ("powerpc/pseries/eeh: use correct API for error log size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh.c                    |  4 +-
 arch/powerpc/platforms/powernv/eeh-powernv.c | 39 +++++++++-----
 arch/powerpc/platforms/pseries/eeh_pseries.c | 54 ++++++++++----------
 3 files changed, 56 insertions(+), 41 deletions(-)

diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index 2b81e9a056b5..be475e946306 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -1170,7 +1170,7 @@ void eeh_add_device_late(struct pci_dev *dev)
 	struct pci_dn *pdn;
 	struct eeh_dev *edev;
 
-	if (!dev || !eeh_enabled())
+	if (!dev)
 		return;
 
 	pr_debug("EEH: Adding device %s\n", pci_name(dev));
@@ -1226,6 +1226,8 @@ void eeh_add_device_tree_late(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 
+	if (eeh_has_flag(EEH_FORCE_DISABLED))
+		return;
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		eeh_add_device_late(dev);
 		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) {
diff --git a/arch/powerpc/platforms/powernv/eeh-powernv.c b/arch/powerpc/platforms/powernv/eeh-powernv.c
index 4fa601feb860..4dab6ffa3f69 100644
--- a/arch/powerpc/platforms/powernv/eeh-powernv.c
+++ b/arch/powerpc/platforms/powernv/eeh-powernv.c
@@ -47,7 +47,7 @@ void pnv_pcibios_bus_add_device(struct pci_dev *pdev)
 {
 	struct pci_dn *pdn = pci_get_pdn(pdev);
 
-	if (!pdev->is_virtfn)
+	if (eeh_has_flag(EEH_FORCE_DISABLED))
 		return;
 
 	pr_debug("%s: EEH: Setting up device %s.\n", __func__, pci_name(pdev));
@@ -202,6 +202,25 @@ PNV_EEH_DBGFS_ENTRY(inbB, 0xE10);
 
 #endif /* CONFIG_DEBUG_FS */
 
+void pnv_eeh_enable_phbs(void)
+{
+	struct pci_controller *hose;
+	struct pnv_phb *phb;
+
+	list_for_each_entry(hose, &hose_list, list_node) {
+		phb = hose->private_data;
+		/*
+		 * If EEH is enabled, we're going to rely on that.
+		 * Otherwise, we restore to conventional mechanism
+		 * to clear frozen PE during PCI config access.
+		 */
+		if (eeh_enabled())
+			phb->flags |= PNV_PHB_FLAG_EEH;
+		else
+			phb->flags &= ~PNV_PHB_FLAG_EEH;
+	}
+}
+
 /**
  * pnv_eeh_post_init - EEH platform dependent post initialization
  *
@@ -248,19 +267,11 @@ int pnv_eeh_post_init(void)
 	if (!eeh_enabled())
 		disable_irq(eeh_event_irq);
 
+	pnv_eeh_enable_phbs();
+
 	list_for_each_entry(hose, &hose_list, list_node) {
 		phb = hose->private_data;
 
-		/*
-		 * If EEH is enabled, we're going to rely on that.
-		 * Otherwise, we restore to conventional mechanism
-		 * to clear frozen PE during PCI config access.
-		 */
-		if (eeh_enabled())
-			phb->flags |= PNV_PHB_FLAG_EEH;
-		else
-			phb->flags &= ~PNV_PHB_FLAG_EEH;
-
 		/* Create debugfs entries */
 #ifdef CONFIG_DEBUG_FS
 		if (phb->has_dbgfs || !phb->dbgfs)
@@ -474,7 +485,11 @@ static void *pnv_eeh_probe(struct pci_dn *pdn, void *data)
 	 * Enable EEH explicitly so that we will do EEH check
 	 * while accessing I/O stuff
 	 */
-	eeh_add_flag(EEH_ENABLED);
+	if (!eeh_has_flag(EEH_ENABLED)) {
+		enable_irq(eeh_event_irq);
+		pnv_eeh_enable_phbs();
+		eeh_add_flag(EEH_ENABLED);
+	}
 
 	/* Save memory bars */
 	eeh_save_bars(edev);
diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index b4f77bc5f8bf..2713d2aa963c 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -55,44 +55,44 @@ static int ibm_get_config_addr_info;
 static int ibm_get_config_addr_info2;
 static int ibm_configure_pe;
 
-#ifdef CONFIG_PCI_IOV
 void pseries_pcibios_bus_add_device(struct pci_dev *pdev)
 {
 	struct pci_dn *pdn = pci_get_pdn(pdev);
-	struct pci_dn *physfn_pdn;
-	struct eeh_dev *edev;
 
-	if (!pdev->is_virtfn)
+	if (eeh_has_flag(EEH_FORCE_DISABLED))
 		return;
 
 	pr_debug("%s: EEH: Setting up device %s.\n", __func__, pci_name(pdev));
+#ifdef CONFIG_PCI_IOV
+	if (pdev->is_virtfn) {
+		struct pci_dn *physfn_pdn;
 
-	pdn->device_id  =  pdev->device;
-	pdn->vendor_id  =  pdev->vendor;
-	pdn->class_code =  pdev->class;
-	/*
-	 * Last allow unfreeze return code used for retrieval
-	 * by user space in eeh-sysfs to show the last command
-	 * completion from platform.
-	 */
-	pdn->last_allow_rc =  0;
-	physfn_pdn      =  pci_get_pdn(pdev->physfn);
-	pdn->pe_number  =  physfn_pdn->pe_num_map[pdn->vf_index];
-	edev = pdn_to_eeh_dev(pdn);
-
-	/*
-	 * The following operations will fail if VF's sysfs files
-	 * aren't created or its resources aren't finalized.
-	 */
+		pdn->device_id  =  pdev->device;
+		pdn->vendor_id  =  pdev->vendor;
+		pdn->class_code =  pdev->class;
+		/*
+		 * Last allow unfreeze return code used for retrieval
+		 * by user space in eeh-sysfs to show the last command
+		 * completion from platform.
+		 */
+		pdn->last_allow_rc =  0;
+		physfn_pdn      =  pci_get_pdn(pdev->physfn);
+		pdn->pe_number  =  physfn_pdn->pe_num_map[pdn->vf_index];
+	}
+#endif
 	eeh_add_device_early(pdn);
 	eeh_add_device_late(pdev);
-	edev->pe_config_addr =  (pdn->busno << 16) | (pdn->devfn << 8);
-	eeh_rmv_from_parent_pe(edev); /* Remove as it is adding to bus pe */
-	eeh_add_to_parent_pe(edev);   /* Add as VF PE type */
-	eeh_sysfs_add_device(pdev);
+#ifdef CONFIG_PCI_IOV
+	if (pdev->is_virtfn) {
+		struct eeh_dev *edev = pdn_to_eeh_dev(pdn);
 
-}
+		edev->pe_config_addr =  (pdn->busno << 16) | (pdn->devfn << 8);
+		eeh_rmv_from_parent_pe(edev); /* Remove as it is adding to bus pe */
+		eeh_add_to_parent_pe(edev);   /* Add as VF PE type */
+	}
 #endif
+	eeh_sysfs_add_device(pdev);
+}
 
 /*
  * Buffer for reporting slot-error-detail rtas calls. Its here
@@ -159,10 +159,8 @@ static int pseries_eeh_init(void)
 	/* Set EEH probe mode */
 	eeh_add_flag(EEH_PROBE_MODE_DEVTREE | EEH_ENABLE_IO_FOR_LOG);
 
-#ifdef CONFIG_PCI_IOV
 	/* Set EEH machine dependent code */
 	ppc_md.pcibios_bus_add_device = pseries_pcibios_bus_add_device;
-#endif
 
 	return 0;
 }
-- 
2.35.1



