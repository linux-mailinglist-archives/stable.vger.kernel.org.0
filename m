Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8764726AFC4
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 23:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgIOVmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 17:42:18 -0400
Received: from mail-bn8nam12on2106.outbound.protection.outlook.com ([40.107.237.106]:50336
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728127AbgIOVbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 17:31:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aynFijQg75efb21yr4T4utZJb13Y7876m1wStkCIIKQ/MTpi60DmCQ466GUmiT9nZ5cGxxdNslxLdhfqpdR6gvuaYjBLaKOMXxoUIKcF1zpn2x1ssTNQkEZImNaEdXxlWLdjlJX/xxNMUmK19OXlgARRMY3nZmAkAYcdfERJ31lvgF8VTw14IQe65u+/DxzyunP91fy3pdqm1y8SpwL8zyKQTAHVh70GUTusFf44LDt5oSvLSpYY7O2xw6hV98giF0R/UBKm+PZZi+Ir/PQ72bIKSdVX5iUYg67WTPfnkxgHtFv/th6S68vRXoNMGqif1kToVChUwoOFI+p6N4z3nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcC5atYKHIVWPnCHh1OvvK5gzJs8/PHMoavVka86r2U=;
 b=RH8HMvZgVSyA/87i6WB0bVpGqpNgUkw3Pf9vopwdMbipBQHK/aAERYLUGYWKsyCLcRbnGIUumrDphu9P9PZvn1BlJ8nw9Od9BT0fYS0VwqXeTJaD3vb6pJiPV2gpexACFKzKPjqeQ8vzNVF7yNL3W0PP3R6Sq4Yg7FyCymq17TowDJOazhs4zP3sKgE6DI7PlSsGAALmWurdVSojY8Jqi4HQxQCliyMf5ei/bJcoJMHL0z93q2Y5JZ0ZkPge0Cjd8L9S2fPn/fN20O0PLLN8vsOhk88cklQCVFpytTkcRIlLNzZ/bM3W2Vnf89Nds3yRbCHXWekot5LEbl7v6xBaZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcC5atYKHIVWPnCHh1OvvK5gzJs8/PHMoavVka86r2U=;
 b=g+BPBy1lHcyUUUzaceIh3MllfGiQxkLFM6b+WykVRK+Lc3V18vOLJTVX/44KQQDGa2XpfjTqRYGeyTrBbZmTDzcLb/By6EZ0FYoQuwosVzMXGRsfBD6XKfSC94ZiSjssoYc9DdrfVnLCF5MXWlvd62V26BdgQ2r4e/CyUrCsZ6w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=os.amperecomputing.com;
Received: from DM6PR01MB5802.prod.exchangelabs.com (2603:10b6:5:203::17) by
 DM6PR01MB5516.prod.exchangelabs.com (2603:10b6:5:153::22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.17; Tue, 15 Sep 2020 21:31:11 +0000
Received: from DM6PR01MB5802.prod.exchangelabs.com
 ([fe80::ed9e:20e7:332a:704b]) by DM6PR01MB5802.prod.exchangelabs.com
 ([fe80::ed9e:20e7:332a:704b%7]) with mapi id 15.20.3391.011; Tue, 15 Sep 2020
 21:31:11 +0000
From:   "John L. Villalovos" <jlvillal@os.amperecomputing.com>
To:     stable@vger.kernel.org
Cc:     "John L. Villalovos" <jlvillal@os.amperecomputing.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Fredrik Noring <noring@nocrew.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.19 2/5] USB: use genalloc for USB HCs with local memory
Date:   Tue, 15 Sep 2020 14:30:36 -0700
Message-Id: <20200915213039.862123-3-jlvillal@os.amperecomputing.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915213039.862123-1-jlvillal@os.amperecomputing.com>
References: <20200915213039.862123-1-jlvillal@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY4PR14CA0040.namprd14.prod.outlook.com
 (2603:10b6:903:101::26) To DM6PR01MB5802.prod.exchangelabs.com
 (2603:10b6:5:203::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (4.28.12.214) by CY4PR14CA0040.namprd14.prod.outlook.com (2603:10b6:903:101::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 21:31:10 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [4.28.12.214]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c166616-ad93-4e14-d728-08d859beaa80
X-MS-TrafficTypeDiagnostic: DM6PR01MB5516:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR01MB55167C48D81355BC15F7B528ED200@DM6PR01MB5516.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6X76WEG/LuMKvBGF0Tl8Tmp8ghUFlnyASKHbjdx5sSvi4NHIrej4mCSNeiPJUTQFQMmXXi6w1DmTEXHqO3C7GKZPxpD5TJW9Gb5lc1HwDrPiK+7EcymKR8u6+NjGnBlxqYmSE18UWFaiTP6X9aKxWg3bmtIIs/IHexJrOQ29JNYpPt3GpJujV5UiEjJTr5vgvIqJDX4ltGWaHxQj9WlO9ziciynlfboLHPrTuQX/bT76ejWy6ad31Ky36eU0yeCrN/lkd+KvLkhr+qkNNSwZIqacC1kzI2KUwAV0BsX81DPOGNfTtDEiWJMKGPo7F093EfqjW9m1JRPcp3akAue1sJmjqvuvlU1IHq4HyRQSSjY0GAe9TpmyhXSHHA5xIQZuHyBhX6WruYASolSvU/MgAO+Y8olvXm7XMKPdIK3mTAocJG+jcf5y4azIg8XEgzej
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR01MB5802.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(366004)(376002)(39850400004)(83380400001)(6512007)(8936002)(316002)(66946007)(16526019)(8676002)(4326008)(2616005)(6486002)(956004)(26005)(186003)(1076003)(54906003)(6666004)(6506007)(478600001)(5660300002)(86362001)(2906002)(66476007)(69590400008)(66556008)(52116002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: KbKRFgpCdk6afG6VqxMAaSE74cLSSw4pqsBEj4fTiNWHZlNMkkqZIGOiMiaGZMhZixEKeG31M9ThXMOTk3hZjVUVugVeC42qe0+hX8r4R+jiIkMh670GI4K2HVvAlAAd7merPAdq7qCEpSgTuUg+bBa2O95zZHkQd+5Ml1V1nCD5R1ELT7Qd2n8fc126irCtVY7wfZvMfJZJjqfJGPX/4maUbK1Eh4jKAlNOz7PRjUlNe4P+xfXwUP8+BQNrw5h+m3k6lfh3DU3OuSLHRugQPWxcQOBpSawM4UflHCgW1hrhO/pBGhSVGEi/44PeoKx4svL//xwwsFNgGWaqLuLWNHNiSWuxJJ7tYJXscbIB+z2ShqtZpBuCLXzJoPeXwMNOUjx13GMQeBD8Xu6aQHn+x07YGzfvLqR4et/EiNDVARymrGgMVwN/hSUGldUsCOop0X7gvITVaraBr7xjsmNWf3v6Bbu+ZbNo/z9txZlLZZywGQt045MaBoO/K2lneHiFxT1LpHjU0U+KPOJcBkmpebysX9T3HbjxNDRaO5vNxiS9WJR2fM9XuE5drY8EawF5tRSWBbHqjQlZ+xPGdmLg6nYI3K/nC+zvLGAo5Oi4rrs4BfGXY6cyxRKfaJP6DSzXu12VZubn1TeisxNgebBplw==
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c166616-ad93-4e14-d728-08d859beaa80
X-MS-Exchange-CrossTenant-AuthSource: DM6PR01MB5802.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 21:31:11.3922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2CvLWkdv2Xx+d98mYU2EjJFCm881vpCzGw/YYwRw9gQitrCNUUsJAX+67CW3SQnYn71BGUXfLywKo53pzz1A1tx1x8CRFwB63ZIe6lIxrqGq6vOMJSaPKrJPDnVWn+8N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5516
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b0310c2f09bbe8aebefb97ed67949a3a7092aca6 upstream.

For HCs that have local memory, replace the current DMA API usage with
a genalloc generic allocator to manage the mappings for these devices.
To help users, introduce a new HCD API, usb_hcd_setup_local_mem() that
will setup up the genalloc backing up the device local memory. It will
be used in subsequent patches.  This is in preparation for dropping
the existing "coherent" dma mem declaration APIs.  The current
implementation was relying on a short circuit in the DMA API that in
the end, was acting as an allocator for these type of devices.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Tested-by: Fredrik Noring <noring@nocrew.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John L. Villalovos <jlvillal@os.amperecomputing.com>
---
 drivers/usb/Kconfig         |  1 +
 drivers/usb/core/buffer.c   |  9 +++++++++
 drivers/usb/core/hcd.c      | 36 ++++++++++++++++++++++++++++++++++++
 drivers/usb/host/ohci-hcd.c | 23 ++++++++++++++++++-----
 drivers/usb/host/ohci-mem.c | 35 +++++++++++++++++++++++++++++++----
 drivers/usb/host/ohci.h     |  2 ++
 include/linux/usb/hcd.h     |  5 +++++
 7 files changed, 102 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 70e6c956c23c..2b3a76eaa653 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -44,6 +44,7 @@ config USB_ARCH_HAS_HCD
 config USB
 	tristate "Support for Host-side USB"
 	depends on USB_ARCH_HAS_HCD
+	select GENERIC_ALLOCATOR
 	select USB_COMMON
 	select NLS  # for UTF-8 strings
 	---help---
diff --git a/drivers/usb/core/buffer.c b/drivers/usb/core/buffer.c
index 77eef8acff94..a9392b63c175 100644
--- a/drivers/usb/core/buffer.c
+++ b/drivers/usb/core/buffer.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
+#include <linux/genalloc.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
 
@@ -128,6 +129,9 @@ void *hcd_buffer_alloc(
 	if (size == 0)
 		return NULL;
 
+	if (hcd->localmem_pool)
+		return gen_pool_dma_alloc(hcd->localmem_pool, size, dma);
+
 	/* some USB hosts just use PIO */
 	if (!IS_ENABLED(CONFIG_HAS_DMA) ||
 	    (!is_device_dma_capable(bus->sysdev) &&
@@ -156,6 +160,11 @@ void hcd_buffer_free(
 	if (!addr)
 		return;
 
+	if (hcd->localmem_pool) {
+		gen_pool_free(hcd->localmem_pool, (unsigned long)addr, size);
+		return;
+	}
+
 	if (!IS_ENABLED(CONFIG_HAS_DMA) ||
 	    (!is_device_dma_capable(bus->sysdev) &&
 	     !(hcd->driver->flags & HCD_LOCAL_MEM))) {
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index b82a7d787add..c1daf3f646d6 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -29,6 +29,8 @@
 #include <linux/workqueue.h>
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
+#include <linux/genalloc.h>
+#include <linux/io.h>
 
 #include <linux/phy/phy.h>
 #include <linux/usb.h>
@@ -3025,6 +3027,40 @@ usb_hcd_platform_shutdown(struct platform_device *dev)
 }
 EXPORT_SYMBOL_GPL(usb_hcd_platform_shutdown);
 
+int usb_hcd_setup_local_mem(struct usb_hcd *hcd, phys_addr_t phys_addr,
+			    dma_addr_t dma, size_t size)
+{
+	int err;
+	void *local_mem;
+
+	hcd->localmem_pool = devm_gen_pool_create(hcd->self.sysdev, PAGE_SHIFT,
+						  dev_to_node(hcd->self.sysdev),
+						  dev_name(hcd->self.sysdev));
+	if (IS_ERR(hcd->localmem_pool))
+		return PTR_ERR(hcd->localmem_pool);
+
+	local_mem = devm_memremap(hcd->self.sysdev, phys_addr,
+				  size, MEMREMAP_WC);
+	if (!local_mem)
+		return -ENOMEM;
+
+	/*
+	 * Here we pass a dma_addr_t but the arg type is a phys_addr_t.
+	 * It's not backed by system memory and thus there's no kernel mapping
+	 * for it.
+	 */
+	err = gen_pool_add_virt(hcd->localmem_pool, (unsigned long)local_mem,
+				dma, size, dev_to_node(hcd->self.sysdev));
+	if (err < 0) {
+		dev_err(hcd->self.sysdev, "gen_pool_add_virt failed with %d\n",
+			err);
+		return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(usb_hcd_setup_local_mem);
+
 /*-------------------------------------------------------------------------*/
 
 #if IS_ENABLED(CONFIG_USB_MON)
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index af11887f5f9e..9b2d8b84ae26 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -40,6 +40,7 @@
 #include <linux/dmapool.h>
 #include <linux/workqueue.h>
 #include <linux/debugfs.h>
+#include <linux/genalloc.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -514,8 +515,15 @@ static int ohci_init (struct ohci_hcd *ohci)
 	timer_setup(&ohci->io_watchdog, io_watchdog_func, 0);
 	ohci->prev_frame_no = IO_WATCHDOG_OFF;
 
-	ohci->hcca = dma_alloc_coherent (hcd->self.controller,
-			sizeof(*ohci->hcca), &ohci->hcca_dma, GFP_KERNEL);
+	if (hcd->localmem_pool)
+		ohci->hcca = gen_pool_dma_alloc(hcd->localmem_pool,
+						sizeof(*ohci->hcca),
+						&ohci->hcca_dma);
+	else
+		ohci->hcca = dma_alloc_coherent(hcd->self.controller,
+						sizeof(*ohci->hcca),
+						&ohci->hcca_dma,
+						GFP_KERNEL);
 	if (!ohci->hcca)
 		return -ENOMEM;
 
@@ -999,9 +1007,14 @@ static void ohci_stop (struct usb_hcd *hcd)
 	remove_debug_files (ohci);
 	ohci_mem_cleanup (ohci);
 	if (ohci->hcca) {
-		dma_free_coherent (hcd->self.controller,
-				sizeof *ohci->hcca,
-				ohci->hcca, ohci->hcca_dma);
+		if (hcd->localmem_pool)
+			gen_pool_free(hcd->localmem_pool,
+				      (unsigned long)ohci->hcca,
+				      sizeof(*ohci->hcca));
+		else
+			dma_free_coherent(hcd->self.controller,
+					  sizeof(*ohci->hcca),
+					  ohci->hcca, ohci->hcca_dma);
 		ohci->hcca = NULL;
 		ohci->hcca_dma = 0;
 	}
diff --git a/drivers/usb/host/ohci-mem.c b/drivers/usb/host/ohci-mem.c
index b3da3f12e5b1..8e15044be14c 100644
--- a/drivers/usb/host/ohci-mem.c
+++ b/drivers/usb/host/ohci-mem.c
@@ -36,6 +36,13 @@ static void ohci_hcd_init (struct ohci_hcd *ohci)
 
 static int ohci_mem_init (struct ohci_hcd *ohci)
 {
+	/*
+	 * HCs with local memory allocate from localmem_pool so there's
+	 * no need to create the below dma pools.
+	 */
+	if (ohci_to_hcd(ohci)->localmem_pool)
+		return 0;
+
 	ohci->td_cache = dma_pool_create ("ohci_td",
 		ohci_to_hcd(ohci)->self.controller,
 		sizeof (struct td),
@@ -88,8 +95,12 @@ td_alloc (struct ohci_hcd *hc, gfp_t mem_flags)
 {
 	dma_addr_t	dma;
 	struct td	*td;
+	struct usb_hcd	*hcd = ohci_to_hcd(hc);
 
-	td = dma_pool_zalloc (hc->td_cache, mem_flags, &dma);
+	if (hcd->localmem_pool)
+		td = gen_pool_dma_zalloc(hcd->localmem_pool, sizeof(*td), &dma);
+	else
+		td = dma_pool_zalloc(hc->td_cache, mem_flags, &dma);
 	if (td) {
 		/* in case hc fetches it, make it look dead */
 		td->hwNextTD = cpu_to_hc32 (hc, dma);
@@ -103,6 +114,7 @@ static void
 td_free (struct ohci_hcd *hc, struct td *td)
 {
 	struct td	**prev = &hc->td_hash [TD_HASH_FUNC (td->td_dma)];
+	struct usb_hcd	*hcd = ohci_to_hcd(hc);
 
 	while (*prev && *prev != td)
 		prev = &(*prev)->td_hash;
@@ -110,7 +122,12 @@ td_free (struct ohci_hcd *hc, struct td *td)
 		*prev = td->td_hash;
 	else if ((td->hwINFO & cpu_to_hc32(hc, TD_DONE)) != 0)
 		ohci_dbg (hc, "no hash for td %p\n", td);
-	dma_pool_free (hc->td_cache, td, td->td_dma);
+
+	if (hcd->localmem_pool)
+		gen_pool_free(hcd->localmem_pool, (unsigned long)td,
+			      sizeof(*td));
+	else
+		dma_pool_free(hc->td_cache, td, td->td_dma);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -121,8 +138,12 @@ ed_alloc (struct ohci_hcd *hc, gfp_t mem_flags)
 {
 	dma_addr_t	dma;
 	struct ed	*ed;
+	struct usb_hcd	*hcd = ohci_to_hcd(hc);
 
-	ed = dma_pool_zalloc (hc->ed_cache, mem_flags, &dma);
+	if (hcd->localmem_pool)
+		ed = gen_pool_dma_zalloc(hcd->localmem_pool, sizeof(*ed), &dma);
+	else
+		ed = dma_pool_zalloc(hc->ed_cache, mem_flags, &dma);
 	if (ed) {
 		INIT_LIST_HEAD (&ed->td_list);
 		ed->dma = dma;
@@ -133,6 +154,12 @@ ed_alloc (struct ohci_hcd *hc, gfp_t mem_flags)
 static void
 ed_free (struct ohci_hcd *hc, struct ed *ed)
 {
-	dma_pool_free (hc->ed_cache, ed, ed->dma);
+	struct usb_hcd	*hcd = ohci_to_hcd(hc);
+
+	if (hcd->localmem_pool)
+		gen_pool_free(hcd->localmem_pool, (unsigned long)ed,
+			      sizeof(*ed));
+	else
+		dma_pool_free(hc->ed_cache, ed, ed->dma);
 }
 
diff --git a/drivers/usb/host/ohci.h b/drivers/usb/host/ohci.h
index ef4813bfc5bf..b015b00774b2 100644
--- a/drivers/usb/host/ohci.h
+++ b/drivers/usb/host/ohci.h
@@ -385,6 +385,8 @@ struct ohci_hcd {
 
 	/*
 	 * memory management for queue data structures
+	 *
+	 * @td_cache and @ed_cache are %NULL if &usb_hcd.localmem_pool is used.
 	 */
 	struct dma_pool		*td_cache;
 	struct dma_pool		*ed_cache;
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 97e2ddec18b1..5f1d57064cc0 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -211,6 +211,9 @@ struct usb_hcd {
 #define	HC_IS_RUNNING(state) ((state) & __ACTIVE)
 #define	HC_IS_SUSPENDED(state) ((state) & __SUSPEND)
 
+	/* memory pool for HCs having local memory, or %NULL */
+	struct gen_pool         *localmem_pool;
+
 	/* more shared queuing code would be good; it should support
 	 * smarter scheduling, handle transaction translators, etc;
 	 * input size of periodic table to an interrupt scheduler.
@@ -461,6 +464,8 @@ extern int usb_add_hcd(struct usb_hcd *hcd,
 		unsigned int irqnum, unsigned long irqflags);
 extern void usb_remove_hcd(struct usb_hcd *hcd);
 extern int usb_hcd_find_raw_port_number(struct usb_hcd *hcd, int port1);
+int usb_hcd_setup_local_mem(struct usb_hcd *hcd, phys_addr_t phys_addr,
+			    dma_addr_t dma, size_t size);
 
 struct platform_device;
 extern void usb_hcd_platform_shutdown(struct platform_device *dev);
-- 
2.26.2

