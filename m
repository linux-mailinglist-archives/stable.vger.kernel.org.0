Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C05627FD2
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237746AbiKNNCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237788AbiKNNBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:01:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACE729371
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:01:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F210B80EC2
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD01C433D6;
        Mon, 14 Nov 2022 13:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430909;
        bh=naNsn2C35KOhHn0cP2eAY12Bi6K46uaf4D1UewyAg/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hV/RQw8Vx6qnmLnGY17NaOJlCJsv7O6Ow/+aiDOjKRCwKnGR02/g8BMz3jrJ6Z+T2
         Ce5HYvTPjKfq09ILyWmLR3ltAjCZGQQRICDGmY/BZdSGLxK+ns6iHA6a5orUY/Gmgk
         /jAY2grHHwez/DHOJUuXQS8btDRNs8S8nwpDcgiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dexuan Cui <decui@microsoft.com>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Carl Vanderlip <quic_carlv@quicinc.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 031/190] PCI: hv: Fix the definition of vector in hv_compose_msi_msg()
Date:   Mon, 14 Nov 2022 13:44:15 +0100
Message-Id: <20221114124500.113941537@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit e70af8d040d2b7904dca93d942ba23fb722e21b1 ]

The local variable 'vector' must be u32 rather than u8: see the
struct hv_msi_desc3.

'vector_count' should be u16 rather than u8: see struct hv_msi_desc,
hv_msi_desc2 and hv_msi_desc3.

Fixes: a2bad844a67b ("PCI: hv: Fix interrupt mapping for multi-MSI")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Cc: Jeffrey Hugo <quic_jhugo@quicinc.com>
Cc: Carl Vanderlip <quic_carlv@quicinc.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://lore.kernel.org/r/20221027205256.17678-1-decui@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-hyperv.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index e7c6f6629e7c..ba64284eaf9f 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1614,7 +1614,7 @@ static void hv_pci_compose_compl(void *context, struct pci_response *resp,
 
 static u32 hv_compose_msi_req_v1(
 	struct pci_create_interrupt *int_pkt, const struct cpumask *affinity,
-	u32 slot, u8 vector, u8 vector_count)
+	u32 slot, u8 vector, u16 vector_count)
 {
 	int_pkt->message_type.type = PCI_CREATE_INTERRUPT_MESSAGE;
 	int_pkt->wslot.slot = slot;
@@ -1642,7 +1642,7 @@ static int hv_compose_msi_req_get_cpu(const struct cpumask *affinity)
 
 static u32 hv_compose_msi_req_v2(
 	struct pci_create_interrupt2 *int_pkt, const struct cpumask *affinity,
-	u32 slot, u8 vector, u8 vector_count)
+	u32 slot, u8 vector, u16 vector_count)
 {
 	int cpu;
 
@@ -1661,7 +1661,7 @@ static u32 hv_compose_msi_req_v2(
 
 static u32 hv_compose_msi_req_v3(
 	struct pci_create_interrupt3 *int_pkt, const struct cpumask *affinity,
-	u32 slot, u32 vector, u8 vector_count)
+	u32 slot, u32 vector, u16 vector_count)
 {
 	int cpu;
 
@@ -1701,7 +1701,12 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	struct compose_comp_ctxt comp;
 	struct tran_int_desc *int_desc;
 	struct msi_desc *msi_desc;
-	u8 vector, vector_count;
+	/*
+	 * vector_count should be u16: see hv_msi_desc, hv_msi_desc2
+	 * and hv_msi_desc3. vector must be u32: see hv_msi_desc3.
+	 */
+	u16 vector_count;
+	u32 vector;
 	struct {
 		struct pci_packet pci_pkt;
 		union {
@@ -1767,6 +1772,11 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 		vector_count = 1;
 	}
 
+	/*
+	 * hv_compose_msi_req_v1 and v2 are for x86 only, meaning 'vector'
+	 * can't exceed u8. Cast 'vector' down to u8 for v1/v2 explicitly
+	 * for better readability.
+	 */
 	memset(&ctxt, 0, sizeof(ctxt));
 	init_completion(&comp.comp_pkt.host_event);
 	ctxt.pci_pkt.completion_func = hv_pci_compose_compl;
@@ -1777,7 +1787,7 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 		size = hv_compose_msi_req_v1(&ctxt.int_pkts.v1,
 					dest,
 					hpdev->desc.win_slot.slot,
-					vector,
+					(u8)vector,
 					vector_count);
 		break;
 
@@ -1786,7 +1796,7 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 		size = hv_compose_msi_req_v2(&ctxt.int_pkts.v2,
 					dest,
 					hpdev->desc.win_slot.slot,
-					vector,
+					(u8)vector,
 					vector_count);
 		break;
 
-- 
2.35.1



