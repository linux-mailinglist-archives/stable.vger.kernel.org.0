Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BA5579E09
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242369AbiGSM5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242150AbiGSM4k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:56:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913399A6AA;
        Tue, 19 Jul 2022 05:22:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CB79B81A7F;
        Tue, 19 Jul 2022 12:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A6BC341C6;
        Tue, 19 Jul 2022 12:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233362;
        bh=RNgEKpLAZW9CrGtWagK/54Wuvr9HSc17s7AkNEZdXzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSTpyEyczu5MF7JRYia4F08qu3JpjcQlGdDt25BfjTt5ypmNyITT06/NOb6q5gKa9
         M0nfCLvUt4FArbju4IxRLL+nXG7DOOSyKXNTaTIpEtnXO0sO8od+6MmSW9Em9OAUs0
         TzSV/uBKA6nafeyrvBKfmWHbfbj/bFu1rdjUgKLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.18 097/231] ice: handle E822 generic device ID in PLDM header
Date:   Tue, 19 Jul 2022 13:53:02 +0200
Message-Id: <20220719114722.891365903@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

[ Upstream commit f52d166819a4d8e0d5cca07d8a8dd6397c96dcf1 ]

The driver currently presumes that the record data in the PLDM header
of the firmware image will match the device ID of the running device.
This is true for E810 devices. It appears that for E822 devices that
this is not guaranteed to be true.

Fix this by adding a check for the generic E822 device.

Fixes: d69ea414c9b4 ("ice: implement device flash update via devlink")
Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_devids.h   |  1 +
 .../net/ethernet/intel/ice/ice_fw_update.c    | 96 ++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_main.c     |  1 +
 3 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devids.h b/drivers/net/ethernet/intel/ice/ice_devids.h
index 61dd2f18dee8..b41bc3dc1745 100644
--- a/drivers/net/ethernet/intel/ice/ice_devids.h
+++ b/drivers/net/ethernet/intel/ice/ice_devids.h
@@ -5,6 +5,7 @@
 #define _ICE_DEVIDS_H_
 
 /* Device IDs */
+#define ICE_DEV_ID_E822_SI_DFLT         0x1888
 /* Intel(R) Ethernet Connection E823-L for backplane */
 #define ICE_DEV_ID_E823L_BACKPLANE	0x124C
 /* Intel(R) Ethernet Connection E823-L for SFP */
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index 665a344fb9c0..3dc5662d62a6 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -736,7 +736,87 @@ static int ice_finalize_update(struct pldmfw *context)
 	return 0;
 }
 
-static const struct pldmfw_ops ice_fwu_ops = {
+struct ice_pldm_pci_record_id {
+	u32 vendor;
+	u32 device;
+	u32 subsystem_vendor;
+	u32 subsystem_device;
+};
+
+/**
+ * ice_op_pci_match_record - Check if a PCI device matches the record
+ * @context: PLDM fw update structure
+ * @record: list of records extracted from the PLDM image
+ *
+ * Determine if the PCI device associated with this device matches the record
+ * data provided.
+ *
+ * Searches the descriptor TLVs and extracts the relevant descriptor data into
+ * a pldm_pci_record_id. This is then compared against the PCI device ID
+ * information.
+ *
+ * Returns: true if the device matches the record, false otherwise.
+ */
+static bool
+ice_op_pci_match_record(struct pldmfw *context, struct pldmfw_record *record)
+{
+	struct pci_dev *pdev = to_pci_dev(context->dev);
+	struct ice_pldm_pci_record_id id = {
+		.vendor = PCI_ANY_ID,
+		.device = PCI_ANY_ID,
+		.subsystem_vendor = PCI_ANY_ID,
+		.subsystem_device = PCI_ANY_ID,
+	};
+	struct pldmfw_desc_tlv *desc;
+
+	list_for_each_entry(desc, &record->descs, entry) {
+		u16 value;
+		int *ptr;
+
+		switch (desc->type) {
+		case PLDM_DESC_ID_PCI_VENDOR_ID:
+			ptr = &id.vendor;
+			break;
+		case PLDM_DESC_ID_PCI_DEVICE_ID:
+			ptr = &id.device;
+			break;
+		case PLDM_DESC_ID_PCI_SUBVENDOR_ID:
+			ptr = &id.subsystem_vendor;
+			break;
+		case PLDM_DESC_ID_PCI_SUBDEV_ID:
+			ptr = &id.subsystem_device;
+			break;
+		default:
+			/* Skip unrelated TLVs */
+			continue;
+		}
+
+		value = get_unaligned_le16(desc->data);
+		/* A value of zero for one of the descriptors is sometimes
+		 * used when the record should ignore this field when matching
+		 * device. For example if the record applies to any subsystem
+		 * device or vendor.
+		 */
+		if (value)
+			*ptr = value;
+		else
+			*ptr = PCI_ANY_ID;
+	}
+
+	/* the E822 device can have a generic device ID so check for that */
+	if ((id.vendor == PCI_ANY_ID || id.vendor == pdev->vendor) &&
+	    (id.device == PCI_ANY_ID || id.device == pdev->device ||
+	    id.device == ICE_DEV_ID_E822_SI_DFLT) &&
+	    (id.subsystem_vendor == PCI_ANY_ID ||
+	    id.subsystem_vendor == pdev->subsystem_vendor) &&
+	    (id.subsystem_device == PCI_ANY_ID ||
+	    id.subsystem_device == pdev->subsystem_device))
+		return true;
+
+	return false;
+}
+
+static const struct pldmfw_ops ice_fwu_ops_e810 = {
 	.match_record = &pldmfw_op_pci_match_record,
 	.send_package_data = &ice_send_package_data,
 	.send_component_table = &ice_send_component_table,
@@ -744,6 +824,14 @@ static const struct pldmfw_ops ice_fwu_ops = {
 	.finalize_update = &ice_finalize_update,
 };
 
+static const struct pldmfw_ops ice_fwu_ops_e822 = {
+	.match_record = &ice_op_pci_match_record,
+	.send_package_data = &ice_send_package_data,
+	.send_component_table = &ice_send_component_table,
+	.flash_component = &ice_flash_component,
+	.finalize_update = &ice_finalize_update,
+};
+
 /**
  * ice_get_pending_updates - Check if the component has a pending update
  * @pf: the PF driver structure
@@ -921,7 +1009,11 @@ int ice_devlink_flash_update(struct devlink *devlink,
 
 	memset(&priv, 0, sizeof(priv));
 
-	priv.context.ops = &ice_fwu_ops;
+	/* the E822 device needs a slightly different ops */
+	if (hw->mac_type == ICE_MAC_GENERIC)
+		priv.context.ops = &ice_fwu_ops_e822;
+	else
+		priv.context.ops = &ice_fwu_ops_e810;
 	priv.context.dev = dev;
 	priv.extack = extack;
 	priv.pf = pf;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d069b19f9bf7..efb076f71e38 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5397,6 +5397,7 @@ static const struct pci_device_id ice_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823L_10G_BASE_T), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823L_1GBE), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823L_QSFP), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822_SI_DFLT), 0 },
 	/* required last entry */
 	{ 0, }
 };
-- 
2.35.1



