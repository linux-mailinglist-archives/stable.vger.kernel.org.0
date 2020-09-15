Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48E526AFC2
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 23:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgIOVln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 17:41:43 -0400
Received: from mail-bn8nam12on2118.outbound.protection.outlook.com ([40.107.237.118]:22112
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728131AbgIOVdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 17:33:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OtGoPq0leZvwRPgzdLsiGmVHl6LWRJYswCSj9eValnOTVjlOiOeVB/Lz12Z+q1coqLfORZP545e3GtiqjoHwwPSvYpLzUasXwy7vG6Sdi+Cmh9gYZP2EQfI8bzznB0qXQ//KvqPFxSyEUoT9lpJF97aehPHzOuKO1cAHJJRDFZEZ6r9LEhkf83sIhaD5MnhggdeUDcLQxnNvlDeiVSHZpItQpDClOiCL+NwPuU55Ee2OsQa3xQzdoxDDU9UBBBssXwRueE6pKVHMrjuC8kFhdHg7p/1BCma8YOYaXt6zVkAWKsVT9YSmeCGexqtJd6CW14UeB+gKw3deWESoA/6kfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6udCXZv0n6zMMzIkdXfMI8YgvTF43uNzbitjkXJVFDI=;
 b=dknhkAnUqYTfZkAofzZZNkIYM/gdrkW99hDHYAm4AhDfDWsU7Lsu/hlhbb1R5Ti9JAKUbD2g0wx19oYMboNSFNJCJ0jU1f0+E1R//4o26re9w+nyyIOxHRJ2TRFBAobqkLH+TB29UXeyBZOUed3cilftcZSOJKXogphEk/p2f/n6TCfHW8IY6RqhZBQSfQ6zriuWqgCUnHGFxbUlenFAfMXlihrce/in2mnjDCs2cp5Dta7qQhdPHPe3bYSGbQHJNSVoisEURQ/5bm72ipNtMD7pTVaDjaOfRH1lzp/GCSz9mcF8M6lXEYY4Z9QT7Tl/FySPSmQD1zfQy/G6EF0Lyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6udCXZv0n6zMMzIkdXfMI8YgvTF43uNzbitjkXJVFDI=;
 b=PPLkipyPcP3tWAGFLUr3XtXIkKc8KbawJyEtyGvm+o+Q/z1PhKAVDiKO9QcSnZFZVVijAcT8RvDnxkbTIftfnb2rasLglMNRauK/1Br7uXMM8ZubaD26gzdDKrEontPXj6Vfd6w+micSmxaGqRTNHRbt0CxOjc07cZqbeQ3OWmQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=os.amperecomputing.com;
Received: from DM6PR01MB5802.prod.exchangelabs.com (2603:10b6:5:203::17) by
 DM6PR01MB5516.prod.exchangelabs.com (2603:10b6:5:153::22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.17; Tue, 15 Sep 2020 21:31:13 +0000
Received: from DM6PR01MB5802.prod.exchangelabs.com
 ([fe80::ed9e:20e7:332a:704b]) by DM6PR01MB5802.prod.exchangelabs.com
 ([fe80::ed9e:20e7:332a:704b%7]) with mapi id 15.20.3391.011; Tue, 15 Sep 2020
 21:31:13 +0000
From:   "John L. Villalovos" <jlvillal@os.amperecomputing.com>
To:     stable@vger.kernel.org
Cc:     "John L. Villalovos" <jlvillal@os.amperecomputing.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Fredrik Noring <noring@nocrew.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.19 3/5] USB: drop HCD_LOCAL_MEM flag
Date:   Tue, 15 Sep 2020 14:30:37 -0700
Message-Id: <20200915213039.862123-4-jlvillal@os.amperecomputing.com>
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
Received: from localhost.localdomain (4.28.12.214) by CY4PR14CA0040.namprd14.prod.outlook.com (2603:10b6:903:101::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 21:31:12 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [4.28.12.214]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7824220b-0c4a-41eb-e506-08d859beab99
X-MS-TrafficTypeDiagnostic: DM6PR01MB5516:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR01MB5516DF8A1F0BF1C7151AB277ED200@DM6PR01MB5516.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:765;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: raktIQegyoSkja/q7/XZM3gzV4K1ypuJFP5UcdJuW5H8Xn6lcNkANw6itKUUABIXBVQVIyK6cR8K2K+QZhtyxPNpu2dQREYfQjABMUE8y0xKse/LsVPVrOuEpajZj2b8im6Q0LHTUFTMK7rFTNSVf+OHSy8WYnsmZcvJSkspC4uTjTMMKsdOMLpKXmO6mF3lIgWyiZfyS8hv6Go8U52MMPtT8UUoF/2aXBouiO7cVeqEV0JEcOsNq75+qAsNdavnHhz62UttH0GsrxjFhBmgUpyGKSGeNxVfrEkC27iR0c5fPIpVXQ4/K0BD8wZOVRVir3jxSaEhPXODEkkfkSh5LQcVkoEcpwe2gAjeqdPUegYZkDjguesW0klUc+FBY0GOJGE5dSm8YtH90W/qy5y/MOfNnX7QhmAxzQ/i/013YoGQxjhH3b7uGNYGBVnFphuK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR01MB5802.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(366004)(376002)(39850400004)(83380400001)(6512007)(8936002)(316002)(66946007)(16526019)(8676002)(4326008)(2616005)(6486002)(956004)(26005)(186003)(1076003)(54906003)(6666004)(6506007)(478600001)(5660300002)(86362001)(2906002)(66476007)(69590400008)(66556008)(52116002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ntGNI9maA4gluVHjhlED1yDApOmwszv+Lk6Yrkg2deb0QjniMovQPORB3n0aXgqkHkHnSdyGnmZY7s9Cmpy8Cx12xtPM8bEUIm5MgVA+ggLzdcrOaZZOJs3Tev5J7VbEadlEKAPduzuRAWhqy0pOYvs9yd7xbjpPI4eZOrviGtXwOzGW0d7ZVQt+lEa2Bt/p1jnIs43AnYV+4J0tYQFF1Ttwuwl+7uGGItwR258S0psEZh0y1LndNY7JElssHXzq+sJItOP6guFCeVAm9zsCPJCWixhwBSqPV5VlyTs9dunsD4mcg/FzcAjgA/9G8XSJOtnw8FK8PhFJRGwPFp9LZrIi8oPic8nFXOryCqAqDt3S3Wh100iaFs50xO2inpNePFHbVFe/gGC7dNEXoxNE9C0xip3WD9aUtLPpi3G76XrJBFEyVwGxvte/oW9T0SG88QxiQAgJnToOyiBPG6FN5Bs09SsibW0lKvkAL63hVOPo6/PzahNCJbph/px1Nt9e6jWMMB0LiKSTG55xYfPvHh25h1RAHX6/gzJGWdmFyIMMXK7ZpBkB9fCpkwQW6DwJ0b8PYD47VOFX4rtMVhwv3DMFYPW2PfbczdbsxruU79fwyjaBLIK0Fv8Iot0zlymEXwZvbOTu8zVPUhs0mwTpvw==
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7824220b-0c4a-41eb-e506-08d859beab99
X-MS-Exchange-CrossTenant-AuthSource: DM6PR01MB5802.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 21:31:13.2012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nlMrdmxJfRaEEoaphMzbzqkbwNtBmvCi73KGdXSV/cFcOw+JYnRCATIiIY8cnmiUVIMf6wykabvqRasMEvG9nAnrVGbs6YABYsXyNw65Iyh5Yi05PIxfp2AciiBpQJwd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5516
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2d7a3dc3e24f43504b1f25eae8195e600f4cce8b upstream.

With the addition of the local memory allocator, the HCD_LOCAL_MEM
flag can be dropped and the checks against it replaced with a check
for the localmem_pool ptr being initialized.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Tested-by: Fredrik Noring <noring@nocrew.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John L. Villalovos <jlvillal@os.amperecomputing.com>
---
 drivers/usb/core/buffer.c      |  8 +++-----
 drivers/usb/core/hcd.c         | 15 ++++++---------
 drivers/usb/host/ehci-hcd.c    |  2 +-
 drivers/usb/host/fotg210-hcd.c |  2 +-
 drivers/usb/host/ohci-hcd.c    |  2 +-
 drivers/usb/host/ohci-sm501.c  |  2 +-
 drivers/usb/host/ohci-tmio.c   |  2 +-
 drivers/usb/host/uhci-hcd.c    |  2 +-
 include/linux/usb/hcd.h        |  1 -
 9 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/core/buffer.c b/drivers/usb/core/buffer.c
index a9392b63c175..d93e25aeaf96 100644
--- a/drivers/usb/core/buffer.c
+++ b/drivers/usb/core/buffer.c
@@ -68,7 +68,7 @@ int hcd_buffer_create(struct usb_hcd *hcd)
 
 	if (!IS_ENABLED(CONFIG_HAS_DMA) ||
 	    (!is_device_dma_capable(hcd->self.sysdev) &&
-	     !(hcd->driver->flags & HCD_LOCAL_MEM)))
+	     !hcd->localmem_pool))
 		return 0;
 
 	for (i = 0; i < HCD_BUFFER_POOLS; i++) {
@@ -134,8 +134,7 @@ void *hcd_buffer_alloc(
 
 	/* some USB hosts just use PIO */
 	if (!IS_ENABLED(CONFIG_HAS_DMA) ||
-	    (!is_device_dma_capable(bus->sysdev) &&
-	     !(hcd->driver->flags & HCD_LOCAL_MEM))) {
+	    !is_device_dma_capable(bus->sysdev)) {
 		*dma = ~(dma_addr_t) 0;
 		return kmalloc(size, mem_flags);
 	}
@@ -166,8 +165,7 @@ void hcd_buffer_free(
 	}
 
 	if (!IS_ENABLED(CONFIG_HAS_DMA) ||
-	    (!is_device_dma_capable(bus->sysdev) &&
-	     !(hcd->driver->flags & HCD_LOCAL_MEM))) {
+	    !is_device_dma_capable(bus->sysdev)) {
 		kfree(addr);
 		return;
 	}
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index c1daf3f646d6..c991e7ff1875 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1346,14 +1346,14 @@ EXPORT_SYMBOL_GPL(usb_hcd_unlink_urb_from_ep);
  * using regular system memory - like pci devices doing bus mastering.
  *
  * To support host controllers with limited dma capabilities we provide dma
- * bounce buffers. This feature can be enabled using the HCD_LOCAL_MEM flag.
+ * bounce buffers. This feature can be enabled by initializing
+ * hcd->localmem_pool using usb_hcd_setup_local_mem().
  * For this to work properly the host controller code must first use the
  * function dma_declare_coherent_memory() to point out which memory area
  * that should be used for dma allocations.
  *
- * The HCD_LOCAL_MEM flag then tells the usb code to allocate all data for
- * dma using dma_alloc_coherent() which in turn allocates from the memory
- * area pointed out with dma_declare_coherent_memory().
+ * The initialized hcd->localmem_pool then tells the usb code to allocate all
+ * data for dma using the genalloc API.
  *
  * So, to summarize...
  *
@@ -1363,9 +1363,6 @@ EXPORT_SYMBOL_GPL(usb_hcd_unlink_urb_from_ep);
  *   (a) "normal" kernel memory is no good, and
  *   (b) there's not enough to share
  *
- * - The only *portable* hook for such stuff in the
- *   DMA framework is dma_declare_coherent_memory()
- *
  * - So we use that, even though the primary requirement
  *   is that the memory be "local" (hence addressable
  *   by that device), not "coherent".
@@ -1532,7 +1529,7 @@ int usb_hcd_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 						urb->setup_dma))
 				return -EAGAIN;
 			urb->transfer_flags |= URB_SETUP_MAP_SINGLE;
-		} else if (hcd->driver->flags & HCD_LOCAL_MEM) {
+		} else if (hcd->localmem_pool) {
 			ret = hcd_alloc_coherent(
 					urb->dev->bus, mem_flags,
 					&urb->setup_dma,
@@ -1602,7 +1599,7 @@ int usb_hcd_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 				else
 					urb->transfer_flags |= URB_DMA_MAP_SINGLE;
 			}
-		} else if (hcd->driver->flags & HCD_LOCAL_MEM) {
+		} else if (hcd->localmem_pool) {
 			ret = hcd_alloc_coherent(
 					urb->dev->bus, mem_flags,
 					&urb->transfer_dma,
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 8608ac513fb7..f0a0ddee52d0 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -559,7 +559,7 @@ static int ehci_init(struct usb_hcd *hcd)
 	ehci->command = temp;
 
 	/* Accept arbitrarily long scatter-gather lists */
-	if (!(hcd->driver->flags & HCD_LOCAL_MEM))
+	if (!hcd->localmem_pool)
 		hcd->self.sg_tablesize = ~0;
 
 	/* Prepare for unlinking active QHs */
diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index 2d5a72c15069..cfaf03008a13 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -4998,7 +4998,7 @@ static int hcd_fotg210_init(struct usb_hcd *hcd)
 	fotg210->command = temp;
 
 	/* Accept arbitrarily long scatter-gather lists */
-	if (!(hcd->driver->flags & HCD_LOCAL_MEM))
+	if (!hcd->localmem_pool)
 		hcd->self.sg_tablesize = ~0;
 	return 0;
 }
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 9b2d8b84ae26..81a104fafbc2 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -457,7 +457,7 @@ static int ohci_init (struct ohci_hcd *ohci)
 	struct usb_hcd *hcd = ohci_to_hcd(ohci);
 
 	/* Accept arbitrarily long scatter-gather lists */
-	if (!(hcd->driver->flags & HCD_LOCAL_MEM))
+	if (!hcd->localmem_pool)
 		hcd->self.sg_tablesize = ~0;
 
 	if (distrust_firmware)
diff --git a/drivers/usb/host/ohci-sm501.c b/drivers/usb/host/ohci-sm501.c
index 0a39dc58f376..f9b1279b68ec 100644
--- a/drivers/usb/host/ohci-sm501.c
+++ b/drivers/usb/host/ohci-sm501.c
@@ -49,7 +49,7 @@ static const struct hc_driver ohci_sm501_hc_driver = {
 	 * generic hardware linkage
 	 */
 	.irq =			ohci_irq,
-	.flags =		HCD_USB11 | HCD_MEMORY | HCD_LOCAL_MEM,
+	.flags =		HCD_USB11 | HCD_MEMORY,
 
 	/*
 	 * basic lifecycle operations
diff --git a/drivers/usb/host/ohci-tmio.c b/drivers/usb/host/ohci-tmio.c
index a631dbb369d7..98ecf3e3d74f 100644
--- a/drivers/usb/host/ohci-tmio.c
+++ b/drivers/usb/host/ohci-tmio.c
@@ -153,7 +153,7 @@ static const struct hc_driver ohci_tmio_hc_driver = {
 
 	/* generic hardware linkage */
 	.irq =			ohci_irq,
-	.flags =		HCD_USB11 | HCD_MEMORY | HCD_LOCAL_MEM,
+	.flags =		HCD_USB11 | HCD_MEMORY,
 
 	/* basic lifecycle operations */
 	.start =		ohci_tmio_start,
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 6218bfe54f52..b4f4f729e080 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -581,7 +581,7 @@ static int uhci_start(struct usb_hcd *hcd)
 
 	hcd->uses_new_polling = 1;
 	/* Accept arbitrarily long scatter-gather lists */
-	if (!(hcd->driver->flags & HCD_LOCAL_MEM))
+	if (!hcd->localmem_pool)
 		hcd->self.sg_tablesize = ~0;
 
 	spin_lock_init(&uhci->lock);
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 5f1d57064cc0..e24dade77132 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -256,7 +256,6 @@ struct hc_driver {
 
 	int	flags;
 #define	HCD_MEMORY	0x0001		/* HC regs use memory (else I/O) */
-#define	HCD_LOCAL_MEM	0x0002		/* HC needs local memory */
 #define	HCD_SHARED	0x0004		/* Two (or more) usb_hcds share HW */
 #define	HCD_USB11	0x0010		/* USB 1.1 */
 #define	HCD_USB2	0x0020		/* USB 2.0 */
-- 
2.26.2

