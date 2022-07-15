Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE2F57688A
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 22:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbiGOUwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 16:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiGOUwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 16:52:38 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86904BE28
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 13:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1657918357; x=1689454357;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CMVjCLdNdV1W4mko4+M0UJ0jrDXADcRt/x8pBHwH+KQ=;
  b=EaIsKeNfAWj6twOW3RFU6pz5BPPGPxDzlXjLp0fs6ltt4JE70/KWDaLn
   grlJK6+ocuI5B5DUBJFzDnWMDt/1WnZJfsnfCLEeLaUqEBZLZ5Xdli5cu
   4w+Pea7STNlkyhiW1o0EMjwkrsEc3lQ3ciBzGS5YXUm0IzxUiQ56/sJcf
   E=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 15 Jul 2022 13:52:37 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 13:52:37 -0700
Received: from nalasex01b.na.qualcomm.com (10.47.209.197) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 15 Jul 2022 13:52:36 -0700
Received: from ubuntuvm.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 15 Jul 2022 13:52:35 -0700
From:   Carl Vanderlip <quic_carlv@quicinc.com>
To:     <stable@vger.kernel.org>
CC:     Jeffrey Hugo <quic_jhugo@quicinc.com>, <kys@microsoft.com>,
        <haiyangz@microsoft.com>, <sthemmin@microsoft.com>,
        <wei.liu@microsoft.com>, <decui@microsoft.com>,
        <lorenzo.pieralisi@arm.com>, <robh@kernel.org>, <kw@linux.com>,
        <bhelgaas@google.com>, Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Carl Vanderlip <quic_carlv@quicinc.com>
Subject: [PATCH 5.10 2/4] PCI: hv: Fix hv_arch_irq_unmask() for multi-MSI
Date:   Fri, 15 Jul 2022 20:52:08 +0000
Message-ID: <20220715205210.18544-3-quic_carlv@quicinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220715205210.18544-1-quic_carlv@quicinc.com>
References: <20220715205210.18544-1-quic_carlv@quicinc.com>
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

commit 455880dfe292a2bdd3b4ad6a107299fce610e64b upstream.

In the multi-MSI case, hv_arch_irq_unmask() will only operate on the first
MSI of the N allocated.  This is because only the first msi_desc is cached
and it is shared by all the MSIs of the multi-MSI block.  This means that
hv_arch_irq_unmask() gets the correct address, but the wrong data (always
0).

This can break MSIs.

Lets assume MSI0 is vector 34 on CPU0, and MSI1 is vector 33 on CPU0.

hv_arch_irq_unmask() is called on MSI0.  It uses a hypercall to configure
the MSI address and data (0) to vector 34 of CPU0.  This is correct.  Then
hv_arch_irq_unmask is called on MSI1.  It uses another hypercall to
configure the MSI address and data (0) to vector 33 of CPU0.  This is
wrong, and results in both MSI0 and MSI1 being routed to vector 33.  Linux
will observe extra instances of MSI1 and no instances of MSI0 despite the
endpoint device behaving correctly.

For the multi-MSI case, we need unique address and data info for each MSI,
but the cached msi_desc does not provide that.  However, that information
can be gotten from the int_desc cached in the chip_data by
compose_msi_msg().  Fix the multi-MSI case to use that cached information
instead.  Since hv_set_msi_entry_from_desc() is no longer applicable,
remove it.

5.10 backport - removed unused hv_set_msi_entry_from_desc function from
mshyperv.h instead of pci-hyperv.c. msi_entry.address/data.as_uint32
changed to direct reference (as they are u32's, just sans union).

Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1651068453-29588-1-git-send-email-quic_jhugo@quicinc.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Carl Vanderlip <quic_carlv@quicinc.com>
---
 arch/x86/include/asm/mshyperv.h     | 7 -------
 drivers/pci/controller/pci-hyperv.c | 5 ++++-
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index 30f76b966857..871a8b06d430 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -247,13 +247,6 @@ bool hv_vcpu_is_preempted(int vcpu);
 static inline void hv_apic_init(void) {}
 #endif
 
-static inline void hv_set_msi_entry_from_desc(union hv_msi_entry *msi_entry,
-					      struct msi_desc *msi_desc)
-{
-	msi_entry->address = msi_desc->msg.address_lo;
-	msi_entry->data = msi_desc->msg.data;
-}
-
 #else /* CONFIG_HYPERV */
 static inline void hyperv_init(void) {}
 static inline void hyperv_setup_mmu_ops(void) {}
diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 292cdc3fe347..6bcef857ef51 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1210,6 +1210,7 @@ static void hv_irq_unmask(struct irq_data *data)
 	struct msi_desc *msi_desc = irq_data_get_msi_desc(data);
 	struct irq_cfg *cfg = irqd_cfg(data);
 	struct hv_retarget_device_interrupt *params;
+	struct tran_int_desc *int_desc;
 	struct hv_pcibus_device *hbus;
 	struct cpumask *dest;
 	cpumask_var_t tmp;
@@ -1224,6 +1225,7 @@ static void hv_irq_unmask(struct irq_data *data)
 	pdev = msi_desc_to_pci_dev(msi_desc);
 	pbus = pdev->bus;
 	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
+	int_desc = data->chip_data;
 
 	spin_lock_irqsave(&hbus->retarget_msi_interrupt_lock, flags);
 
@@ -1231,7 +1233,8 @@ static void hv_irq_unmask(struct irq_data *data)
 	memset(params, 0, sizeof(*params));
 	params->partition_id = HV_PARTITION_ID_SELF;
 	params->int_entry.source = 1; /* MSI(-X) */
-	hv_set_msi_entry_from_desc(&params->int_entry.msi_entry, msi_desc);
+	params->int_entry.msi_entry.address = int_desc->address & 0xffffffff;
+	params->int_entry.msi_entry.data = int_desc->data;
 	params->device_id = (hbus->hdev->dev_instance.b[5] << 24) |
 			   (hbus->hdev->dev_instance.b[4] << 16) |
 			   (hbus->hdev->dev_instance.b[7] << 8) |
-- 
2.25.1

