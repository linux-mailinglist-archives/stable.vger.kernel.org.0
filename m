Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9585050DA
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238765AbiDRM3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239522AbiDRM2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:28:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456331FCD9;
        Mon, 18 Apr 2022 05:22:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B964B80EDC;
        Mon, 18 Apr 2022 12:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE0AC385A1;
        Mon, 18 Apr 2022 12:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284518;
        bh=SuuDmPTb5VGvYkiKexzHbRRnRZQ/cYrWEhuSXbDByN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWydHuVeuUqUQEwOcb+/1OiIjLI3vM6GZtSVwCVTRCabXwHR3Fufcn6toEFXS49tk
         izuYD6Urxewaxj1xR+UqOMb36kgeNcKWcO8tReFTEKGcrKzix6yn1yX9Y4Gc3apwJz
         3EKZuIUNhASB0Ka2KdhIFWnUxDpa6ZiRLAvKj/9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 142/219] Drivers: hv: vmbus: Propagate VMbus coherence to each VMbus device
Date:   Mon, 18 Apr 2022 14:11:51 +0200
Message-Id: <20220418121210.865930956@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit 37200078ed6aa2ac3c88a01a64996133dccfdd34 ]

VMbus synthetic devices are not represented in the ACPI DSDT -- only
the top level VMbus device is represented. As a result, on ARM64
coherence information in the _CCA method is not specified for
synthetic devices, so they default to not hardware coherent.
Drivers for some of these synthetic devices have been recently
updated to use the standard DMA APIs, and they are incurring extra
overhead of unneeded software coherence management.

Fix this by propagating coherence information from the VMbus node
in ACPI to the individual synthetic devices. There's no effect on
x86/x64 where devices are always hardware coherent.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/1648138492-2191-2-git-send-email-mikelley@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/hv_common.c         | 11 +++++++++++
 drivers/hv/vmbus_drv.c         | 31 +++++++++++++++++++++++++++++++
 include/asm-generic/mshyperv.h |  1 +
 3 files changed, 43 insertions(+)

diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
index 181d16bbf49d..820e81406251 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -20,6 +20,7 @@
 #include <linux/panic_notifier.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
+#include <linux/dma-map-ops.h>
 #include <asm/hyperv-tlfs.h>
 #include <asm/mshyperv.h>
 
@@ -216,6 +217,16 @@ bool hv_query_ext_cap(u64 cap_query)
 }
 EXPORT_SYMBOL_GPL(hv_query_ext_cap);
 
+void hv_setup_dma_ops(struct device *dev, bool coherent)
+{
+	/*
+	 * Hyper-V does not offer a vIOMMU in the guest
+	 * VM, so pass 0/NULL for the IOMMU settings
+	 */
+	arch_setup_dma_ops(dev, 0, 0, NULL, coherent);
+}
+EXPORT_SYMBOL_GPL(hv_setup_dma_ops);
+
 bool hv_is_hibernation_supported(void)
 {
 	return !hv_root_partition && acpi_sleep_state_supported(ACPI_STATE_S4);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 6c057c76c2ca..3cd0d3a44fa2 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -920,6 +920,21 @@ static int vmbus_probe(struct device *child_device)
 	return ret;
 }
 
+/*
+ * vmbus_dma_configure -- Configure DMA coherence for VMbus device
+ */
+static int vmbus_dma_configure(struct device *child_device)
+{
+	/*
+	 * On ARM64, propagate the DMA coherence setting from the top level
+	 * VMbus ACPI device to the child VMbus device being added here.
+	 * On x86/x64 coherence is assumed and these calls have no effect.
+	 */
+	hv_setup_dma_ops(child_device,
+		device_get_dma_attr(&hv_acpi_dev->dev) == DEV_DMA_COHERENT);
+	return 0;
+}
+
 /*
  * vmbus_remove - Remove a vmbus device
  */
@@ -1040,6 +1055,7 @@ static struct bus_type  hv_bus = {
 	.remove =		vmbus_remove,
 	.probe =		vmbus_probe,
 	.uevent =		vmbus_uevent,
+	.dma_configure =	vmbus_dma_configure,
 	.dev_groups =		vmbus_dev_groups,
 	.drv_groups =		vmbus_drv_groups,
 	.bus_groups =		vmbus_bus_groups,
@@ -2435,6 +2451,21 @@ static int vmbus_acpi_add(struct acpi_device *device)
 
 	hv_acpi_dev = device;
 
+	/*
+	 * Older versions of Hyper-V for ARM64 fail to include the _CCA
+	 * method on the top level VMbus device in the DSDT. But devices
+	 * are hardware coherent in all current Hyper-V use cases, so fix
+	 * up the ACPI device to behave as if _CCA is present and indicates
+	 * hardware coherence.
+	 */
+	ACPI_COMPANION_SET(&device->dev, device);
+	if (IS_ENABLED(CONFIG_ACPI_CCA_REQUIRED) &&
+	    device_get_dma_attr(&device->dev) == DEV_DMA_NOT_SUPPORTED) {
+		pr_info("No ACPI _CCA found; assuming coherent device I/O\n");
+		device->flags.cca_seen = true;
+		device->flags.coherent_dma = true;
+	}
+
 	result = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
 					vmbus_walk_resources, NULL);
 
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index c08758b6b364..c05d2ce9b6cd 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -269,6 +269,7 @@ bool hv_isolation_type_snp(void);
 u64 hv_ghcb_hypercall(u64 control, void *input, void *output, u32 input_size);
 void hyperv_cleanup(void);
 bool hv_query_ext_cap(u64 cap_query);
+void hv_setup_dma_ops(struct device *dev, bool coherent);
 void *hv_map_memory(void *addr, unsigned long size);
 void hv_unmap_memory(void *addr);
 #else /* CONFIG_HYPERV */
-- 
2.35.1



