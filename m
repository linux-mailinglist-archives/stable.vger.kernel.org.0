Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2C25802BC
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 18:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbiGYQdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 12:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236171AbiGYQdI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 12:33:08 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7991CFE4
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 09:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1658766787; x=1690302787;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f82scd+9VcrFoFDVPd2q7O+tMZkXWLKleSTjPnhsULg=;
  b=mQ3aEaxPnzAbZfXcJPaDDWQHjg3PbUSxIEmySANHEDoYEfAvaFxsmNG9
   KjxDBpD5d0KuRP8K4tuTqgbUKwGPayV1bYAZpERfw3Jw3P455vI7fqDPg
   HR1skUo1zsBmkGt4RTH1lmywscaQ4LJmiW4lfTsZ8TRz0G0/CeK/GMT79
   E=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 25 Jul 2022 09:33:07 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 09:33:06 -0700
Received: from nalasex01b.na.qualcomm.com (10.47.209.197) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 25 Jul 2022 09:33:06 -0700
Received: from bldr-qrn-hyperv-vm1.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 25 Jul 2022 09:33:05 -0700
From:   Carl Vanderlip <quic_carlv@quicinc.com>
To:     <stable@vger.kernel.org>
CC:     Jeffrey Hugo <quic_jhugo@quicinc.com>, <kys@microsoft.com>,
        <haiyangz@microsoft.com>, <sthemmin@microsoft.com>,
        <wei.liu@microsoft.com>, <decui@microsoft.com>,
        <lorenzo.pieralisi@arm.com>, <robh@kernel.org>, <kw@linux.com>,
        <bhelgaas@google.com>, Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Carl Vanderlip <quic_carlv@quicinc.com>
Subject: [PATCH 4.19 4/4] PCI: hv: Fix interrupt mapping for multi-MSI
Date:   Mon, 25 Jul 2022 16:32:40 +0000
Message-ID: <20220725163240.13001-5-quic_carlv@quicinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220725163240.13001-1-quic_carlv@quicinc.com>
References: <20220725163240.13001-1-quic_carlv@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <quic_jhugo@quicinc.com>

commit a2bad844a67b1c7740bda63e87453baf63c3a7f7 upstream.

According to Dexuan, the hypervisor folks beleive that multi-msi
allocations are not correct.  compose_msi_msg() will allocate multi-msi
one by one.  However, multi-msi is a block of related MSIs, with alignment
requirements.  In order for the hypervisor to allocate properly aligned
and consecutive entries in the IOMMU Interrupt Remapping Table, there
should be a single mapping request that requests all of the multi-msi
vectors in one shot.

Dexuan suggests detecting the multi-msi case and composing a single
request related to the first MSI.  Then for the other MSIs in the same
block, use the cached information.  This appears to be viable, so do it.

4.19 backport - add hv_msi_get_int_vector helper function. Fixed merge
conflict due to delivery_mode name change (APIC_DELIVERY_MODE_FIXED
is the value given to dest_Fixed). Removed unused variable in
hv_compose_msi_msg. Fixed reference to msi_desc->pci to point to
the same is_msix variable. Removed changes to compose_msi_req_v3 since
it doesn't exist yet.

Suggested-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Tested-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1652282599-21643-1-git-send-email-quic_jhugo@quicinc.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Carl Vanderlip <quic_carlv@quicinc.com>
---
 drivers/pci/controller/pci-hyperv.c | 61 +++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 4707ac7c770e..63c79e140f1a 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -831,6 +831,10 @@ static void hv_int_desc_free(struct hv_pci_dev *hpdev,
 		u8 buffer[sizeof(struct pci_delete_interrupt)];
 	} ctxt;
 
+	if (!int_desc->vector_count) {
+		kfree(int_desc);
+		return;
+	}
 	memset(&ctxt, 0, sizeof(ctxt));
 	int_pkt = (struct pci_delete_interrupt *)&ctxt.pkt.message;
 	int_pkt->message_type.type =
@@ -893,6 +897,13 @@ static void hv_irq_mask(struct irq_data *data)
 	pci_msi_mask_irq(data);
 }
 
+static unsigned int hv_msi_get_int_vector(struct irq_data *data)
+{
+	struct irq_cfg *cfg = irqd_cfg(data);
+
+	return cfg->vector;
+}
+
 static int hv_msi_prepare(struct irq_domain *domain, struct device *dev,
 			  int nvec, msi_alloc_info_t *info)
 {
@@ -1035,12 +1046,12 @@ static void hv_pci_compose_compl(void *context, struct pci_response *resp,
 
 static u32 hv_compose_msi_req_v1(
 	struct pci_create_interrupt *int_pkt, struct cpumask *affinity,
-	u32 slot, u8 vector)
+	u32 slot, u8 vector, u8 vector_count)
 {
 	int_pkt->message_type.type = PCI_CREATE_INTERRUPT_MESSAGE;
 	int_pkt->wslot.slot = slot;
 	int_pkt->int_desc.vector = vector;
-	int_pkt->int_desc.vector_count = 1;
+	int_pkt->int_desc.vector_count = vector_count;
 	int_pkt->int_desc.delivery_mode = dest_Fixed;
 
 	/*
@@ -1054,14 +1065,14 @@ static u32 hv_compose_msi_req_v1(
 
 static u32 hv_compose_msi_req_v2(
 	struct pci_create_interrupt2 *int_pkt, struct cpumask *affinity,
-	u32 slot, u8 vector)
+	u32 slot, u8 vector, u8 vector_count)
 {
 	int cpu;
 
 	int_pkt->message_type.type = PCI_CREATE_INTERRUPT_MESSAGE2;
 	int_pkt->wslot.slot = slot;
 	int_pkt->int_desc.vector = vector;
-	int_pkt->int_desc.vector_count = 1;
+	int_pkt->int_desc.vector_count = vector_count;
 	int_pkt->int_desc.delivery_mode = dest_Fixed;
 
 	/*
@@ -1089,7 +1100,6 @@ static u32 hv_compose_msi_req_v2(
  */
 static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 {
-	struct irq_cfg *cfg = irqd_cfg(data);
 	struct hv_pcibus_device *hbus;
 	struct hv_pci_dev *hpdev;
 	struct pci_bus *pbus;
@@ -1098,6 +1108,8 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	unsigned long flags;
 	struct compose_comp_ctxt comp;
 	struct tran_int_desc *int_desc;
+	struct msi_desc *msi_desc;
+	u8 vector, vector_count;
 	struct {
 		struct pci_packet pci_pkt;
 		union {
@@ -1118,7 +1130,8 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 		return;
 	}
 
-	pdev = msi_desc_to_pci_dev(irq_data_get_msi_desc(data));
+	msi_desc  = irq_data_get_msi_desc(data);
+	pdev = msi_desc_to_pci_dev(msi_desc);
 	dest = irq_data_get_effective_affinity_mask(data);
 	pbus = pdev->bus;
 	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
@@ -1130,6 +1143,36 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	if (!int_desc)
 		goto drop_reference;
 
+	if (!msi_desc->msi_attrib.is_msix && msi_desc->nvec_used > 1) {
+		/*
+		 * If this is not the first MSI of Multi MSI, we already have
+		 * a mapping.  Can exit early.
+		 */
+		if (msi_desc->irq != data->irq) {
+			data->chip_data = int_desc;
+			int_desc->address = msi_desc->msg.address_lo |
+					    (u64)msi_desc->msg.address_hi << 32;
+			int_desc->data = msi_desc->msg.data +
+					 (data->irq - msi_desc->irq);
+			msg->address_hi = msi_desc->msg.address_hi;
+			msg->address_lo = msi_desc->msg.address_lo;
+			msg->data = int_desc->data;
+			put_pcichild(hpdev);
+			return;
+		}
+		/*
+		 * The vector we select here is a dummy value.  The correct
+		 * value gets sent to the hypervisor in unmask().  This needs
+		 * to be aligned with the count, and also not zero.  Multi-msi
+		 * is powers of 2 up to 32, so 32 will always work here.
+		 */
+		vector = 32;
+		vector_count = msi_desc->nvec_used;
+	} else {
+		vector = hv_msi_get_int_vector(data);
+		vector_count = 1;
+	}
+
 	memset(&ctxt, 0, sizeof(ctxt));
 	init_completion(&comp.comp_pkt.host_event);
 	ctxt.pci_pkt.completion_func = hv_pci_compose_compl;
@@ -1140,14 +1183,16 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 		size = hv_compose_msi_req_v1(&ctxt.int_pkts.v1,
 					dest,
 					hpdev->desc.win_slot.slot,
-					cfg->vector);
+					vector,
+					vector_count);
 		break;
 
 	case PCI_PROTOCOL_VERSION_1_2:
 		size = hv_compose_msi_req_v2(&ctxt.int_pkts.v2,
 					dest,
 					hpdev->desc.win_slot.slot,
-					cfg->vector);
+					vector,
+					vector_count);
 		break;
 
 	default:
-- 
2.25.1

