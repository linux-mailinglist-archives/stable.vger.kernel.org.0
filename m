Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD885764C0
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 17:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiGOPwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 11:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGOPwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 11:52:15 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1018626541
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 08:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1657900334; x=1689436334;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=umrgkJpFtPxppRWLqj07jSc+N5r9Tzevrlp5SNqi8cc=;
  b=if1yUQ8WMMlFtbRAXnEREtawbUxOsYfZ58mGKMDaqZ6Yrpy8iTXyBQlS
   1ESZKLlYcpDjIvd6vNBnpfMvS/1rdmU0ZWiWIa6e7w5kLh4WPKBWXAv4b
   pmqkyLUaRvPWdYTE7GW25OlPuy14gyfQKU40nFekFbw/bfttnDbLSx9W8
   8=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 15 Jul 2022 08:52:13 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 08:52:13 -0700
Received: from nalasex01b.na.qualcomm.com (10.47.209.197) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 15 Jul 2022 08:52:12 -0700
Received: from ubuntuvm.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 15 Jul 2022 08:52:11 -0700
From:   Carl Vanderlip <quic_carlv@quicinc.com>
To:     <stable@vger.kernel.org>
CC:     Jeffrey Hugo <quic_jhugo@quicinc.com>, <kys@microsoft.com>,
        <haiyangz@microsoft.com>, <sthemmin@microsoft.com>,
        <wei.liu@microsoft.com>, <decui@microsoft.com>,
        <lorenzo.pieralisi@arm.com>, <robh@kernel.org>, <kw@linux.com>,
        <bhelgaas@google.com>, Wei Liu <wei.liu@kernel.org>,
        "Carl Vanderlip" <quic_carlv@quicinc.com>
Subject: [PATCH 5.18 v2 1/4] PCI: hv: Fix multi-MSI to allow more than one MSI vector
Date:   Fri, 15 Jul 2022 15:51:23 +0000
Message-ID: <20220715155126.13445-2-quic_carlv@quicinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220715155126.13445-1-quic_carlv@quicinc.com>
References: <20220713181254.5831-1-quic_carlv@quicinc.com>
 <20220715155126.13445-1-quic_carlv@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
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

[ upstream change 08e61e861a0e47e5e1a3fb78406afd6b0cea6b6d ]

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

Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/r/1649856981-14649-1-git-send-email-quic_jhugo@quicinc.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Carl Vanderlip <quic_carlv@quicinc.com>
---
 drivers/pci/controller/pci-hyperv.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index d270a204324e..1cbe24b92a38 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -614,7 +614,16 @@ static void hv_set_msi_entry_from_desc(union hv_msi_entry *msi_entry,
 static int hv_msi_prepare(struct irq_domain *domain, struct device *dev,
 			  int nvec, msi_alloc_info_t *info)
 {
-	return pci_msi_prepare(domain, dev, nvec, info);
+	int ret = pci_msi_prepare(domain, dev, nvec, info);
+
+	/*
+	 * By using the interrupt remapper in the hypervisor IOMMU, contiguous
+	 * CPU vectors is not needed for multi-MSI
+	 */
+	if (info->type == X86_IRQ_ALLOC_TYPE_PCI_MSI)
+		info->flags &= ~X86_IRQ_ALLOC_CONTIGUOUS_VECTORS;
+
+	return ret;
 }
 
 /**
-- 
2.25.1

