Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C461582D87
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbiG0Q75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241206AbiG0Q65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:58:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E318F675BD;
        Wed, 27 Jul 2022 09:37:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF9C061AA9;
        Wed, 27 Jul 2022 16:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAEEC433D7;
        Wed, 27 Jul 2022 16:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939822;
        bh=5nBEjBIzLOia/efdCOlZmxwgl2SbuzyDpTTIsEyjpK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3jC98VpC6flz+VJUkUp4lOghgH5ndOq2iI25/TQF6BV+PWdYkQRwEipJHKl+M3UE
         3ZvMm4CkjnUBD8quZBY7qAq6wL+ttIM37DfHNTs7eCidw59iuRWIDtLp8BfgdsJxTP
         yIaSirws7Vx6UOSNIqN40ZF6AOMbfPTkVH2jtHu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Carl Vanderlip <quic_carlv@quicinc.com>
Subject: [PATCH 5.15 011/201] PCI: hv: Fix hv_arch_irq_unmask() for multi-MSI
Date:   Wed, 27 Jul 2022 18:08:35 +0200
Message-Id: <20220727161027.412476761@linuxfoundation.org>
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

5.15 backport - no changes to code, but merge conflict due to refactor.

Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1651068453-29588-1-git-send-email-quic_jhugo@quicinc.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Carl Vanderlip <quic_carlv@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/mshyperv.h     |    7 -------
 drivers/pci/controller/pci-hyperv.c |    5 ++++-
 2 files changed, 4 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -176,13 +176,6 @@ bool hv_vcpu_is_preempted(int vcpu);
 static inline void hv_apic_init(void) {}
 #endif
 
-static inline void hv_set_msi_entry_from_desc(union hv_msi_entry *msi_entry,
-					      struct msi_desc *msi_desc)
-{
-	msi_entry->address.as_uint32 = msi_desc->msg.address_lo;
-	msi_entry->data.as_uint32 = msi_desc->msg.data;
-}
-
 struct irq_domain *hv_create_pci_msi_domain(void);
 
 int hv_map_ioapic_interrupt(int ioapic_id, bool level, int vcpu, int vector,
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1234,6 +1234,7 @@ static void hv_irq_unmask(struct irq_dat
 	struct msi_desc *msi_desc = irq_data_get_msi_desc(data);
 	struct irq_cfg *cfg = irqd_cfg(data);
 	struct hv_retarget_device_interrupt *params;
+	struct tran_int_desc *int_desc;
 	struct hv_pcibus_device *hbus;
 	struct cpumask *dest;
 	cpumask_var_t tmp;
@@ -1248,6 +1249,7 @@ static void hv_irq_unmask(struct irq_dat
 	pdev = msi_desc_to_pci_dev(msi_desc);
 	pbus = pdev->bus;
 	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
+	int_desc = data->chip_data;
 
 	spin_lock_irqsave(&hbus->retarget_msi_interrupt_lock, flags);
 
@@ -1255,7 +1257,8 @@ static void hv_irq_unmask(struct irq_dat
 	memset(params, 0, sizeof(*params));
 	params->partition_id = HV_PARTITION_ID_SELF;
 	params->int_entry.source = HV_INTERRUPT_SOURCE_MSI;
-	hv_set_msi_entry_from_desc(&params->int_entry.msi_entry, msi_desc);
+	params->int_entry.msi_entry.address.as_uint32 = int_desc->address & 0xffffffff;
+	params->int_entry.msi_entry.data.as_uint32 = int_desc->data;
 	params->device_id = (hbus->hdev->dev_instance.b[5] << 24) |
 			   (hbus->hdev->dev_instance.b[4] << 16) |
 			   (hbus->hdev->dev_instance.b[7] << 8) |


