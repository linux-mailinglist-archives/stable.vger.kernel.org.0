Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9F7582CE2
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240725AbiG0Qve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240644AbiG0QvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:51:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81B461D9E;
        Wed, 27 Jul 2022 09:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D709261A74;
        Wed, 27 Jul 2022 16:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD879C433C1;
        Wed, 27 Jul 2022 16:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939598;
        bh=CTdHHqXgnYxT68ljy/SEmGkgeqO487aQEcM+i7haNSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4sWkbjrws54tL1PiAFM+b0l5zVQM6i3p8R8ikaT8T3mxMkNWInqlsBYtYoRAn21t
         CtCm949d1Os8kphkYpT1ypMpqZse82vBFwjCBXJ7BN3ZGcLpcH0oz3bt+LPkUX0T2a
         zUTPMclbSlL0wAym69q4FoEExCYHOzJzWXsP0ZLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Carl Vanderlip <quic_carlv@quicinc.com>
Subject: [PATCH 5.10 020/105] PCI: hv: Fix interrupt mapping for multi-MSI
Date:   Wed, 27 Jul 2022 18:10:06 +0200
Message-Id: <20220727161012.907747745@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
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

5.10 backport - add hv_msi_get_int_vector helper function. Fixed merge
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-hyperv.c |   61 +++++++++++++++++++++++++++++++-----
 1 file changed, 53 insertions(+), 8 deletions(-)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1118,6 +1118,10 @@ static void hv_int_desc_free(struct hv_p
 		u8 buffer[sizeof(struct pci_delete_interrupt)];
 	} ctxt;
 
+	if (!int_desc->vector_count) {
+		kfree(int_desc);
+		return;
+	}
 	memset(&ctxt, 0, sizeof(ctxt));
 	int_pkt = (struct pci_delete_interrupt *)&ctxt.pkt.message;
 	int_pkt->message_type.type =
@@ -1180,6 +1184,13 @@ static void hv_irq_mask(struct irq_data
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
@@ -1335,12 +1346,12 @@ static void hv_pci_compose_compl(void *c
 
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
@@ -1354,14 +1365,14 @@ static u32 hv_compose_msi_req_v1(
 
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
@@ -1389,7 +1400,6 @@ static u32 hv_compose_msi_req_v2(
  */
 static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 {
-	struct irq_cfg *cfg = irqd_cfg(data);
 	struct hv_pcibus_device *hbus;
 	struct vmbus_channel *channel;
 	struct hv_pci_dev *hpdev;
@@ -1398,6 +1408,8 @@ static void hv_compose_msi_msg(struct ir
 	struct cpumask *dest;
 	struct compose_comp_ctxt comp;
 	struct tran_int_desc *int_desc;
+	struct msi_desc *msi_desc;
+	u8 vector, vector_count;
 	struct {
 		struct pci_packet pci_pkt;
 		union {
@@ -1418,7 +1430,8 @@ static void hv_compose_msi_msg(struct ir
 		return;
 	}
 
-	pdev = msi_desc_to_pci_dev(irq_data_get_msi_desc(data));
+	msi_desc  = irq_data_get_msi_desc(data);
+	pdev = msi_desc_to_pci_dev(msi_desc);
 	dest = irq_data_get_effective_affinity_mask(data);
 	pbus = pdev->bus;
 	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
@@ -1431,6 +1444,36 @@ static void hv_compose_msi_msg(struct ir
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
@@ -1441,7 +1484,8 @@ static void hv_compose_msi_msg(struct ir
 		size = hv_compose_msi_req_v1(&ctxt.int_pkts.v1,
 					dest,
 					hpdev->desc.win_slot.slot,
-					cfg->vector);
+					vector,
+					vector_count);
 		break;
 
 	case PCI_PROTOCOL_VERSION_1_2:
@@ -1449,7 +1493,8 @@ static void hv_compose_msi_msg(struct ir
 		size = hv_compose_msi_req_v2(&ctxt.int_pkts.v2,
 					dest,
 					hpdev->desc.win_slot.slot,
-					cfg->vector);
+					vector,
+					vector_count);
 		break;
 
 	default:


