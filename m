Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C5F582DA6
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbiG0RBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241476AbiG0Q7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:59:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96B869F2C;
        Wed, 27 Jul 2022 09:37:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46681B8200C;
        Wed, 27 Jul 2022 16:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A223BC433C1;
        Wed, 27 Jul 2022 16:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939828;
        bh=o5MEAFf0pMJkybVP0AJTLDjQ/Vb5msp0ru0Amwqev1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=soqLluZkIm+MXF/uaDs1t061nCaGom6tjFwiuqL4o1nSFbMR9KfalrwOwQiD5I+nP
         8oIE8eTUbbtPhDmKsBiXfEpgvtVpV5A3sVtsc4QKE1CmijwGqkg2jMZ49mAkURN8Ht
         d5K3HVEvfII7D22kZOWl4Drp4OW5oiHzpv/tOoPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Carl Vanderlip <quic_carlv@quicinc.com>
Subject: [PATCH 5.15 013/201] PCI: hv: Fix interrupt mapping for multi-MSI
Date:   Wed, 27 Jul 2022 18:08:37 +0200
Message-Id: <20220727161027.482458055@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

5.15 backport - add hv_msi_get_int_vector helper function. Fixed merge
conflict due to delivery_mode name change (APIC_DELIVERY_MODE_FIXED
is the value given to DELIVERY_MODE on x86). Removed unused variable
in hv_compose_msi_msg. Fixed reference to msi_desc->pci to point to
the same is_msix variable.

Suggested-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Tested-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1652282599-21643-1-git-send-email-quic_jhugo@quicinc.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Carl Vanderlip <quic_carlv@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-hyperv.c |   68 ++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 11 deletions(-)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1142,6 +1142,10 @@ static void hv_int_desc_free(struct hv_p
 		u8 buffer[sizeof(struct pci_delete_interrupt)];
 	} ctxt;
 
+	if (!int_desc->vector_count) {
+		kfree(int_desc);
+		return;
+	}
 	memset(&ctxt, 0, sizeof(ctxt));
 	int_pkt = (struct pci_delete_interrupt *)&ctxt.pkt.message;
 	int_pkt->message_type.type =
@@ -1204,6 +1208,13 @@ static void hv_irq_mask(struct irq_data
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
@@ -1359,12 +1370,12 @@ static void hv_pci_compose_compl(void *c
 
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
 	int_pkt->int_desc.delivery_mode = APIC_DELIVERY_MODE_FIXED;
 
 	/*
@@ -1387,14 +1398,14 @@ static int hv_compose_msi_req_get_cpu(st
 
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
 	int_pkt->int_desc.delivery_mode = APIC_DELIVERY_MODE_FIXED;
 	cpu = hv_compose_msi_req_get_cpu(affinity);
 	int_pkt->int_desc.processor_array[0] =
@@ -1406,7 +1417,7 @@ static u32 hv_compose_msi_req_v2(
 
 static u32 hv_compose_msi_req_v3(
 	struct pci_create_interrupt3 *int_pkt, struct cpumask *affinity,
-	u32 slot, u32 vector)
+	u32 slot, u32 vector, u8 vector_count)
 {
 	int cpu;
 
@@ -1414,7 +1425,7 @@ static u32 hv_compose_msi_req_v3(
 	int_pkt->wslot.slot = slot;
 	int_pkt->int_desc.vector = vector;
 	int_pkt->int_desc.reserved = 0;
-	int_pkt->int_desc.vector_count = 1;
+	int_pkt->int_desc.vector_count = vector_count;
 	int_pkt->int_desc.delivery_mode = APIC_DELIVERY_MODE_FIXED;
 	cpu = hv_compose_msi_req_get_cpu(affinity);
 	int_pkt->int_desc.processor_array[0] =
@@ -1437,7 +1448,6 @@ static u32 hv_compose_msi_req_v3(
  */
 static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 {
-	struct irq_cfg *cfg = irqd_cfg(data);
 	struct hv_pcibus_device *hbus;
 	struct vmbus_channel *channel;
 	struct hv_pci_dev *hpdev;
@@ -1446,6 +1456,8 @@ static void hv_compose_msi_msg(struct ir
 	struct cpumask *dest;
 	struct compose_comp_ctxt comp;
 	struct tran_int_desc *int_desc;
+	struct msi_desc *msi_desc;
+	u8 vector, vector_count;
 	struct {
 		struct pci_packet pci_pkt;
 		union {
@@ -1467,7 +1479,8 @@ static void hv_compose_msi_msg(struct ir
 		return;
 	}
 
-	pdev = msi_desc_to_pci_dev(irq_data_get_msi_desc(data));
+	msi_desc  = irq_data_get_msi_desc(data);
+	pdev = msi_desc_to_pci_dev(msi_desc);
 	dest = irq_data_get_effective_affinity_mask(data);
 	pbus = pdev->bus;
 	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
@@ -1480,6 +1493,36 @@ static void hv_compose_msi_msg(struct ir
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
@@ -1490,7 +1533,8 @@ static void hv_compose_msi_msg(struct ir
 		size = hv_compose_msi_req_v1(&ctxt.int_pkts.v1,
 					dest,
 					hpdev->desc.win_slot.slot,
-					cfg->vector);
+					vector,
+					vector_count);
 		break;
 
 	case PCI_PROTOCOL_VERSION_1_2:
@@ -1498,14 +1542,16 @@ static void hv_compose_msi_msg(struct ir
 		size = hv_compose_msi_req_v2(&ctxt.int_pkts.v2,
 					dest,
 					hpdev->desc.win_slot.slot,
-					cfg->vector);
+					vector,
+					vector_count);
 		break;
 
 	case PCI_PROTOCOL_VERSION_1_4:
 		size = hv_compose_msi_req_v3(&ctxt.int_pkts.v3,
 					dest,
 					hpdev->desc.win_slot.slot,
-					cfg->vector);
+					vector,
+					vector_count);
 		break;
 
 	default:


