Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B301121934
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfLPRxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:53:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbfLPRxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:53:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 907AA2166E;
        Mon, 16 Dec 2019 17:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518792;
        bh=r2NVtKImI41IpFVzW8C0UM8Dw0QN0YHq4bm0R0hfP8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EncvrwtZBNVLDtklcet6Lr8EL9sl94Mrz9HkiVl1232xLm26Ab5/TC1teQcKxWfNl
         cF2Effnhlyz+fgNuPstDhXbGTh1VWJXclfr1gwR3pWyLnDEHDws4sZrmgNWiEf0EVR
         g4bS7uLO3FBwMlrtdT9a/R9oklWnuMhDRjK4fQnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 061/267] dmaengine: dw-dmac: implement dma protection control setting
Date:   Mon, 16 Dec 2019 18:46:27 +0100
Message-Id: <20191216174855.674306439@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

[ Upstream commit 7b0c03ecc42fb223baf015877fee9d517c2c8af1 ]

This patch adds a new device-tree property that allows to
specify the dma protection control bits for the all of the
DMA controller's channel uniformly.

Setting the "correct" bits can have a huge impact on the
PPC460EX and APM82181 that use this DMA engine in combination
with a DesignWare' SATA-II core (sata_dwc_460ex driver).

In the OpenWrt Forum, the user takimata reported that:
|It seems your patch unleashed the full power of the SATA port.
|Where I was previously hitting a really hard limit at around
|82 MB/s for reading and 27 MB/s for writing, I am now getting this:
|
|root@OpenWrt:/mnt# time dd if=/dev/zero of=tempfile bs=1M count=1024
|1024+0 records in
|1024+0 records out
|real    0m 13.65s
|user    0m 0.01s
|sys     0m 11.89s
|
|root@OpenWrt:/mnt# time dd if=tempfile of=/dev/null bs=1M count=1024
|1024+0 records in
|1024+0 records out
|real    0m 8.41s
|user    0m 0.01s
|sys     0m 4.70s
|
|This means: 121 MB/s reading and 75 MB/s writing!
|
|The drive is a WD Green WD10EARX taken from an older MBL Single.
|I repeated the test a few times with even larger files to rule out
|any caching, I'm still seeing the same great performance. OpenWrt is
|now completely on par with the original MBL firmware's performance.

Another user And.short reported:
|I can report that your fix worked! Boots up fine with two
|drives even with more partitions, and no more reboot on
|concurrent disk access!

A closer look into the sata_dwc_460ex code revealed that
the driver did initally set the correct protection control
bits. However, this feature was lost when the sata_dwc_460ex
driver was converted to the generic DMA driver framework.

BugLink: https://forum.openwrt.org/t/wd-mybook-live-duo-two-disks/16195/55
BugLink: https://forum.openwrt.org/t/wd-mybook-live-duo-two-disks/16195/50
Fixes: 8b3444852a2b ("sata_dwc_460ex: move to generic DMA driver")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw/core.c                | 2 ++
 drivers/dma/dw/platform.c            | 6 ++++++
 drivers/dma/dw/regs.h                | 4 ++++
 include/linux/platform_data/dma-dw.h | 6 ++++++
 4 files changed, 18 insertions(+)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 0f389e008ce64..055d83b6cb68a 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -160,12 +160,14 @@ static void dwc_initialize_chan_idma32(struct dw_dma_chan *dwc)
 
 static void dwc_initialize_chan_dw(struct dw_dma_chan *dwc)
 {
+	struct dw_dma *dw = to_dw_dma(dwc->chan.device);
 	u32 cfghi = DWC_CFGH_FIFO_MODE;
 	u32 cfglo = DWC_CFGL_CH_PRIOR(dwc->priority);
 	bool hs_polarity = dwc->dws.hs_polarity;
 
 	cfghi |= DWC_CFGH_DST_PER(dwc->dws.dst_id);
 	cfghi |= DWC_CFGH_SRC_PER(dwc->dws.src_id);
+	cfghi |= DWC_CFGH_PROTCTL(dw->pdata->protctl);
 
 	/* Set polarity of handshake interface */
 	cfglo |= hs_polarity ? DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL : 0;
diff --git a/drivers/dma/dw/platform.c b/drivers/dma/dw/platform.c
index bc31fe8020619..46a519e07195c 100644
--- a/drivers/dma/dw/platform.c
+++ b/drivers/dma/dw/platform.c
@@ -162,6 +162,12 @@ dw_dma_parse_dt(struct platform_device *pdev)
 			pdata->multi_block[tmp] = 1;
 	}
 
+	if (!of_property_read_u32(np, "snps,dma-protection-control", &tmp)) {
+		if (tmp > CHAN_PROTCTL_MASK)
+			return NULL;
+		pdata->protctl = tmp;
+	}
+
 	return pdata;
 }
 #else
diff --git a/drivers/dma/dw/regs.h b/drivers/dma/dw/regs.h
index 09e7dfdbb7907..646c9c960c071 100644
--- a/drivers/dma/dw/regs.h
+++ b/drivers/dma/dw/regs.h
@@ -200,6 +200,10 @@ enum dw_dma_msize {
 #define DWC_CFGH_FCMODE		(1 << 0)
 #define DWC_CFGH_FIFO_MODE	(1 << 1)
 #define DWC_CFGH_PROTCTL(x)	((x) << 2)
+#define DWC_CFGH_PROTCTL_DATA	(0 << 2)	/* data access - always set */
+#define DWC_CFGH_PROTCTL_PRIV	(1 << 2)	/* privileged -> AHB HPROT[1] */
+#define DWC_CFGH_PROTCTL_BUFFER	(2 << 2)	/* bufferable -> AHB HPROT[2] */
+#define DWC_CFGH_PROTCTL_CACHE	(4 << 2)	/* cacheable  -> AHB HPROT[3] */
 #define DWC_CFGH_DS_UPD_EN	(1 << 5)
 #define DWC_CFGH_SS_UPD_EN	(1 << 6)
 #define DWC_CFGH_SRC_PER(x)	((x) << 7)
diff --git a/include/linux/platform_data/dma-dw.h b/include/linux/platform_data/dma-dw.h
index 896cb71a382cb..1a1d58ebffbf1 100644
--- a/include/linux/platform_data/dma-dw.h
+++ b/include/linux/platform_data/dma-dw.h
@@ -49,6 +49,7 @@ struct dw_dma_slave {
  * @data_width: Maximum data width supported by hardware per AHB master
  *		(in bytes, power of 2)
  * @multi_block: Multi block transfers supported by hardware per channel.
+ * @protctl: Protection control signals setting per channel.
  */
 struct dw_dma_platform_data {
 	unsigned int	nr_channels;
@@ -65,6 +66,11 @@ struct dw_dma_platform_data {
 	unsigned char	nr_masters;
 	unsigned char	data_width[DW_DMA_MAX_NR_MASTERS];
 	unsigned char	multi_block[DW_DMA_MAX_NR_CHANNELS];
+#define CHAN_PROTCTL_PRIVILEGED		BIT(0)
+#define CHAN_PROTCTL_BUFFERABLE		BIT(1)
+#define CHAN_PROTCTL_CACHEABLE		BIT(2)
+#define CHAN_PROTCTL_MASK		GENMASK(2, 0)
+	unsigned char	protctl;
 };
 
 #endif /* _PLATFORM_DATA_DMA_DW_H */
-- 
2.20.1



