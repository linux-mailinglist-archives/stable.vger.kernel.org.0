Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA5A26AFBE
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 23:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbgIOVla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 17:41:30 -0400
Received: from mail-bn8nam12on2133.outbound.protection.outlook.com ([40.107.237.133]:5473
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728136AbgIOVdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 17:33:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHO5ndZrSwi9dM5iY9F6vSV3dXFW2aT9Iuir5kEoWJe7V1kHvBoe3vuPWQAimlbDlsR1c5+2ia9zK5lBoYxa6akSMMclkPsDdInmcjUL3AbPyX2hFNsS9A6b2HwKkXmIuD1RdVF9OHVKMZYFWocKgrK2ta5Tw2aETdukHeGrgDKBVS2w0qJafYcuQhk2BX8AkdkOIuRlaNsZl+F8OhHXrUo1OoWyPmbXhs2FnZSwzPmhxugdWwq+fygyVFHMGZuV6+Pk3YaxaISmdE/+4Aa8YjGQgqc+/k5svJJYqUavz5/S1mbK+GDAL7mV/bm8HID1HS5hW3/0lzqpwcO5KpscVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qNedkKmMvY4eHHTkTlFBXTYwRp31+WjUa+1WCw4ML88=;
 b=I69NVUTbTOrX6SkXiHYfEkkRoRMAztbIBI9rVIugUnDlNtkKWtMLvO/bsPSlZAjJ4o/bPVm1jC263WN+c/Gd5QNct2/S58VNCkahqavbq2lLMbqRICruFvTCMllD1qS0aamRseZmq1G6jgA/CTDco0QZCvXcjdHbQrwqQ5gy0q0BDUFPJIOvyAvTXHSRfeWi6HjmGvVqWkGzrMAcXMUFSNUFxDKkUMGeUzVuycsuh1nEZOcrRf2qxLJcv9/W03DSxEy1gsxVlNxyNoCz4z0rCOVufVaDm8CIO0qUnoIwVxHVx4lu8XWdByY/gTr4vj2AuIhYe6Lv4ZDNFJDXvq2Juw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qNedkKmMvY4eHHTkTlFBXTYwRp31+WjUa+1WCw4ML88=;
 b=IZ07XNm48tmflovamDuYP1HVPVC4GBVQDhwnSOpnwSw8+WhZfJQb0FtmybxVeSshsp8MoUOVvj8L8p6muPk5zTzHJDf7jbqE0fk16C2+s7wEWb4Xv2r9Fc6i80zDq+wLgtTRqLyh0hSag3SVMkRwC8PHuI8yIA2OoGgTnqDHx/Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=os.amperecomputing.com;
Received: from DM6PR01MB5802.prod.exchangelabs.com (2603:10b6:5:203::17) by
 DM6PR01MB5516.prod.exchangelabs.com (2603:10b6:5:153::22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.17; Tue, 15 Sep 2020 21:31:17 +0000
Received: from DM6PR01MB5802.prod.exchangelabs.com
 ([fe80::ed9e:20e7:332a:704b]) by DM6PR01MB5802.prod.exchangelabs.com
 ([fe80::ed9e:20e7:332a:704b%7]) with mapi id 15.20.3391.011; Tue, 15 Sep 2020
 21:31:17 +0000
From:   "John L. Villalovos" <jlvillal@os.amperecomputing.com>
To:     stable@vger.kernel.org
Cc:     "John L. Villalovos" <jlvillal@os.amperecomputing.com>,
        Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 5/5] usb: add a hcd_uses_dma helper
Date:   Tue, 15 Sep 2020 14:30:39 -0700
Message-Id: <20200915213039.862123-6-jlvillal@os.amperecomputing.com>
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
Received: from localhost.localdomain (4.28.12.214) by CY4PR14CA0040.namprd14.prod.outlook.com (2603:10b6:903:101::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 21:31:16 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [4.28.12.214]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b49a4c38-23f6-4468-e695-08d859beadce
X-MS-TrafficTypeDiagnostic: DM6PR01MB5516:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR01MB5516577BCC067A13B23020DFED200@DM6PR01MB5516.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:459;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sCr5JLw+T7yu1fNsXAOZjlPnayRYRIbg6ECzhqDs+GNsncvtOT+uj2jfLu0bw0AwkWmEyupbR+X1o654zupx7tXQXrpARdy6/KrfXebBlXUvYsjFQ17CNdUt5Q7conPyKk/PmOCkNNtOz1ljNFM1ZCbOqPlYk2mDmL3JIjFn28TP7+rhThtl/ZY1SWjBVgkFvFuEKYboBofUR/ht1lPGdJmkjWh2LsNLEE1c+wnBr0z50A9849QadjtUgUPE6mH8+etvn69yH+wC8N2knHlknMe8pIZUz3Vs5xisy8m2zd6jvILjXrIlpFadD7LKjx/PzaNXsqFrx7fZpPf2kUAIkm0Iwg0eQdFjB+3BjS12q92uqRaV+2FHWTs0Fc74Ei1Yz/TZbmjwCReTAPmBNlz43tOQGfCiXUObsTEFoWepQ9bD3V+VIMykYzBhL5qPmolA0pGis4FzBGhNKrAmxnoNp8sGSpSbs2xFbEDFRJrZt6Ies4rnqDvod/2lgwMhFsZR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR01MB5802.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(366004)(376002)(39850400004)(83380400001)(6512007)(8936002)(316002)(66946007)(16526019)(8676002)(4326008)(2616005)(6486002)(956004)(26005)(186003)(1076003)(54906003)(6666004)(6506007)(966005)(478600001)(5660300002)(86362001)(2906002)(66476007)(69590400008)(66556008)(52116002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 7asIl+zlE2SC+wYZGgDSeW+nQK1Lv6XKrVw1xKyvMhdFCdH8Sw0AvOWptxizmH/3Nv7CzAJEHbOVHNCEcgslpMk1x4WbepnCOQRdGY0d7CTiRB3HoiFP5E26b+3M5M96u3mzXW8SkLnwID0rCQMdoOhAyJ4OHtVCXZ9FbIA3TTFJK4/e21KHOfDHxFAGqOm5j/LzooM/pqhp/qYJen6121bcKkvo9JEQgwaLDufOVbEcwrYuGOrnxa/4K80fp3PQt5rAJpuwUot77bF9BECkmiekqmDB/7GcN8oTcC2BbMcT1YeYduvdDnqHCU17Vgwox8v168J/CG6X8jK9WE6v8iwgtHrfI56vOHhBlHxskaWaogINF2TyJRvL1V/3mzeIdfKFieiQ/1nmoTEoIKSm4t+hYZxchoJxHjetwsQ5Cc2ExDL8uvtVtE9ezFqOFwsFc4alKU0yq3RLZOmk4vRZEn9ADNvv0fyxA30fvKLQcJ838jrWuJkfk7eJzdW5vTxryv0lq7U+OBgWhLK3xDFa1aYxBI2c/BOUF9UgrbpxHclv9TI6aZRugmxb2weWg12QJcSvymSFO7IfCe5LSYWDWC7eRnQ+0fe6AXI5n2oxjyqxXzxWw7flc9Nf5QNXd4ddxsWZ3W8shleZpe7yhP5s/w==
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b49a4c38-23f6-4468-e695-08d859beadce
X-MS-Exchange-CrossTenant-AuthSource: DM6PR01MB5802.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 21:31:16.9060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8djaI5LOyD4p3Tj6JmZjjdRLR+ALbbOglpMivDeVE/9Wbi7YAKmgl6iaKk2xz9qeZQgeMIQptRJocw65ECRvvESh2gV2c5pqWxFlJ22Bc41nBiD+YqO51Ee8Y+qeoEwt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5516
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit edfbcb321faf07ca970e4191abe061deeb7d3788 upstream.

The USB buffer allocation code is the only place in the usb core (and in
fact the whole kernel) that uses is_device_dma_capable, while the URB
mapping code uses the uses_dma flag in struct usb_bus.  Switch the buffer
allocation to use the uses_dma flag used by the rest of the USB code,
and create a helper in hcd.h that checks this flag as well as the
CONFIG_HAS_DMA to simplify the caller a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20190811080520.21712-3-hch@lst.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: John L. Villalovos <jlvillal@os.amperecomputing.com>
---
 drivers/usb/core/buffer.c | 10 +++-------
 drivers/usb/core/hcd.c    |  4 ++--
 drivers/usb/dwc2/hcd.c    |  2 +-
 include/linux/usb.h       |  2 +-
 include/linux/usb/hcd.h   |  3 +++
 5 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/core/buffer.c b/drivers/usb/core/buffer.c
index 8f1697bcc170..84055ed842ff 100644
--- a/drivers/usb/core/buffer.c
+++ b/drivers/usb/core/buffer.c
@@ -66,9 +66,7 @@ int hcd_buffer_create(struct usb_hcd *hcd)
 	char		name[16];
 	int		i, size;
 
-	if (hcd->localmem_pool ||
-	    !IS_ENABLED(CONFIG_HAS_DMA) ||
-	    !is_device_dma_capable(hcd->self.sysdev))
+	if (hcd->localmem_pool || !hcd_uses_dma(hcd))
 		return 0;
 
 	for (i = 0; i < HCD_BUFFER_POOLS; i++) {
@@ -133,8 +131,7 @@ void *hcd_buffer_alloc(
 		return gen_pool_dma_alloc(hcd->localmem_pool, size, dma);
 
 	/* some USB hosts just use PIO */
-	if (!IS_ENABLED(CONFIG_HAS_DMA) ||
-	    !is_device_dma_capable(bus->sysdev)) {
+	if (!hcd_uses_dma(hcd)) {
 		*dma = ~(dma_addr_t) 0;
 		return kmalloc(size, mem_flags);
 	}
@@ -164,8 +161,7 @@ void hcd_buffer_free(
 		return;
 	}
 
-	if (!IS_ENABLED(CONFIG_HAS_DMA) ||
-	    !is_device_dma_capable(bus->sysdev)) {
+	if (!hcd_uses_dma(hcd)) {
 		kfree(addr);
 		return;
 	}
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index c991e7ff1875..8b8ec0c7325d 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1511,7 +1511,7 @@ int usb_hcd_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 	if (usb_endpoint_xfer_control(&urb->ep->desc)) {
 		if (hcd->self.uses_pio_for_control)
 			return ret;
-		if (IS_ENABLED(CONFIG_HAS_DMA) && hcd->self.uses_dma) {
+		if (hcd_uses_dma(hcd)) {
 			if (is_vmalloc_addr(urb->setup_packet)) {
 				WARN_ONCE(1, "setup packet is not dma capable\n");
 				return -EAGAIN;
@@ -1545,7 +1545,7 @@ int usb_hcd_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 	dir = usb_urb_dir_in(urb) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 	if (urb->transfer_buffer_length != 0
 	    && !(urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP)) {
-		if (IS_ENABLED(CONFIG_HAS_DMA) && hcd->self.uses_dma) {
+		if (hcd_uses_dma(hcd)) {
 			if (urb->num_sgs) {
 				int n;
 
diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index a5c8329fd462..797bb4f2a52c 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -4770,7 +4770,7 @@ static int _dwc2_hcd_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 
 	buf = urb->transfer_buffer;
 
-	if (hcd->self.uses_dma) {
+	if (hcd_uses_dma(hcd)) {
 		if (!buf && (urb->transfer_dma & 3)) {
 			dev_err(hsotg->dev,
 				"%s: unaligned transfer with no transfer_buffer",
diff --git a/include/linux/usb.h b/include/linux/usb.h
index ff010d1fd1c7..667712d416c1 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1455,7 +1455,7 @@ typedef void (*usb_complete_t)(struct urb *);
  * field rather than determining a dma address themselves.
  *
  * Note that transfer_buffer must still be set if the controller
- * does not support DMA (as indicated by bus.uses_dma) and when talking
+ * does not support DMA (as indicated by hcd_uses_dma()) and when talking
  * to root hub. If you have to trasfer between highmem zone and the device
  * on such controller, create a bounce buffer or bail out with an error.
  * If transfer_buffer cannot be set (is in highmem) and the controller is DMA
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index e24dade77132..aa69d7d5762a 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -422,6 +422,9 @@ static inline bool hcd_periodic_completion_in_progress(struct usb_hcd *hcd,
 	return hcd->high_prio_bh.completing_ep == ep;
 }
 
+#define hcd_uses_dma(hcd) \
+	(IS_ENABLED(CONFIG_HAS_DMA) && (hcd)->self.uses_dma)
+
 extern int usb_hcd_link_urb_to_ep(struct usb_hcd *hcd, struct urb *urb);
 extern int usb_hcd_check_unlink_urb(struct usb_hcd *hcd, struct urb *urb,
 		int status);
-- 
2.26.2

