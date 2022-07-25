Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41AB95802BB
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 18:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbiGYQdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 12:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbiGYQdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 12:33:06 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD0C1A80F
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 09:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1658766785; x=1690302785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WASvGCGmxB0QsS7S2AbJ6DLIoe1mhILanNEERZtjkm4=;
  b=sLtqdIQ14oIcBzh0i+rP1jPseHPvoPYef5apJRAhKzCNZEgHjv75Y/IH
   bnPRMD8HgQqHQcknvL2fHAtg1FcP0wMXGBc+tq1hD1F7vH+ftDGwCu7Le
   /0FDSgLJ+wXoQCpWMANwIrGSWCEYB86jfcwMbLa6Qrf6rr3A8mJjt5oXU
   w=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 25 Jul 2022 09:33:05 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 09:33:03 -0700
Received: from nalasex01b.na.qualcomm.com (10.47.209.197) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 25 Jul 2022 09:33:03 -0700
Received: from bldr-qrn-hyperv-vm1.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 25 Jul 2022 09:33:02 -0700
From:   Carl Vanderlip <quic_carlv@quicinc.com>
To:     <stable@vger.kernel.org>
CC:     Jeffrey Hugo <quic_jhugo@quicinc.com>, <kys@microsoft.com>,
        <haiyangz@microsoft.com>, <sthemmin@microsoft.com>,
        <wei.liu@microsoft.com>, <decui@microsoft.com>,
        <lorenzo.pieralisi@arm.com>, <robh@kernel.org>, <kw@linux.com>,
        <bhelgaas@google.com>, Wei Liu <wei.liu@kernel.org>,
        "Carl Vanderlip" <quic_carlv@quicinc.com>
Subject: [PATCH 4.19 1/4] PCI: hv: Fix multi-MSI to allow more than one MSI vector
Date:   Mon, 25 Jul 2022 16:32:37 +0000
Message-ID: <20220725163240.13001-2-quic_carlv@quicinc.com>
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

commit 08e61e861a0e47e5e1a3fb78406afd6b0cea6b6d upstream.

If the allocation of multiple MSI vectors for multi-MSI fails in the core
PCI framework, the framework will retry the allocation as a single MSI
vector, assuming that meets the min_vecs specified by the requesting
driver.

Hyper-V advertises that multi-MSI is supported, but reuses the VECTOR
domain to implement that for x86.  The VECTOR domain does not support
multi-MSI, so the alloc will always fail and fallback to a single MSI
allocation.

In short, Hyper-V advertises a capability it does not implement.

Hyper-V can support multi-MSI because it coordinates with the hypervisor
to map the MSIs in the IOMMU's interrupt remapper, which is something the
VECTOR domain does not have.  Therefore the fix is simple - copy what the
x86 IOMMU drivers (AMD/Intel-IR) do by removing
X86_IRQ_ALLOC_CONTIGUOUS_VECTORS after calling the VECTOR domain's
pci_msi_prepare().

4.19 backport - adds the hv_msi_prepare wrapper function.
X86_IRQ_ALLOC_TYPE_PCI_MSI changed to X86_IRQ_ALLOC_TYPE_MSI
(same value).

Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/r/1649856981-14649-1-git-send-email-quic_jhugo@quicinc.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Carl Vanderlip <quic_carlv@quicinc.com>
---
 drivers/pci/controller/pci-hyperv.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 5c2849846641..863e012efa9d 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -893,6 +893,21 @@ static void hv_irq_mask(struct irq_data *data)
 	pci_msi_mask_irq(data);
 }
 
+static int hv_msi_prepare(struct irq_domain *domain, struct device *dev,
+			  int nvec, msi_alloc_info_t *info)
+{
+	int ret = pci_msi_prepare(domain, dev, nvec, info);
+
+	/*
+	 * By using the interrupt remapper in the hypervisor IOMMU, contiguous
+	 * CPU vectors is not needed for multi-MSI
+	 */
+	if (info->type == X86_IRQ_ALLOC_TYPE_MSI)
+		info->flags &= ~X86_IRQ_ALLOC_CONTIGUOUS_VECTORS;
+
+	return ret;
+}
+
 /**
  * hv_irq_unmask() - "Unmask" the IRQ by setting its current
  * affinity.
@@ -1240,7 +1255,7 @@ static irq_hw_number_t hv_msi_domain_ops_get_hwirq(struct msi_domain_info *info,
 
 static struct msi_domain_ops hv_msi_ops = {
 	.get_hwirq	= hv_msi_domain_ops_get_hwirq,
-	.msi_prepare	= pci_msi_prepare,
+	.msi_prepare	= hv_msi_prepare,
 	.set_desc	= pci_msi_set_desc,
 	.msi_free	= hv_msi_free,
 };
-- 
2.25.1

