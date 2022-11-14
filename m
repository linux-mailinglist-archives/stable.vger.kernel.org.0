Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB16D628022
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237732AbiKNND3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237664AbiKNND2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:03:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C8E764E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:03:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC562B80EA6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F99C433D7;
        Mon, 14 Nov 2022 13:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431003;
        bh=xXF3tu2Ms1oJ3mM4BG18dObHaLUBErIRtfPqmtVMaJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9NZuC/fl3kqxf5xqtkywWOpXjYv4wSAWCR2iIs5/5hinJnf4bsWUUP6xmXN9rHaR
         DtxrRuo2wiVK3nuBjTPMVKQ+G+jz6olc11J4iKerAoBXt8cTjeQCfVF0QTEhuv2DRv
         7UYyPZPZt4shGPNw54saJWbKJ1B+1Dm36G1xzEu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dave Jiang <dave.jiang@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 064/190] dmanegine: idxd: reformat opcap output to match bitmap_parse() input
Date:   Mon, 14 Nov 2022 13:44:48 +0100
Message-Id: <20221114124501.519227212@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit a8563a33a5e26064061f2fb34215c97f0e2995f4 ]

To make input and output consistent and prepping for the per WQ operation
configuration support, change the output of opcap display to match the
input that is expected by bitmap_parse() helper function. The output will
be a bitmap with field width as the number of bits using the %*pb format
specifier for printk() family.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Co-developed-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: https://lore.kernel.org/r/20220917161222.2835172-3-fenghua.yu@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: e8dbd6445dd6 ("dmaengine: idxd: Fix max batch size for Intel IAA")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/idxd.h      |  2 ++
 drivers/dma/idxd/init.c      | 20 ++++++++++++++++++++
 drivers/dma/idxd/registers.h |  2 ++
 drivers/dma/idxd/sysfs.c     |  9 ++-------
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index fed0dfc1eaa8..33640a41e172 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -308,6 +308,8 @@ struct idxd_device {
 	struct work_struct work;
 
 	struct idxd_pmu *idxd_pmu;
+
+	unsigned long *opcap_bmap;
 };
 
 /* IDXD software descriptor */
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index aa3478257ddb..913a55ccb864 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -369,6 +369,19 @@ static void idxd_read_table_offsets(struct idxd_device *idxd)
 	dev_dbg(dev, "IDXD Perfmon Offset: %#x\n", idxd->perfmon_offset);
 }
 
+static void multi_u64_to_bmap(unsigned long *bmap, u64 *val, int count)
+{
+	int i, j, nr;
+
+	for (i = 0, nr = 0; i < count; i++) {
+		for (j = 0; j < BITS_PER_LONG_LONG; j++) {
+			if (val[i] & BIT(j))
+				set_bit(nr, bmap);
+			nr++;
+		}
+	}
+}
+
 static void idxd_read_caps(struct idxd_device *idxd)
 {
 	struct device *dev = &idxd->pdev->dev;
@@ -427,6 +440,7 @@ static void idxd_read_caps(struct idxd_device *idxd)
 				IDXD_OPCAP_OFFSET + i * sizeof(u64));
 		dev_dbg(dev, "opcap[%d]: %#llx\n", i, idxd->hw.opcap.bits[i]);
 	}
+	multi_u64_to_bmap(idxd->opcap_bmap, &idxd->hw.opcap.bits[0], 4);
 }
 
 static struct idxd_device *idxd_alloc(struct pci_dev *pdev, struct idxd_driver_data *data)
@@ -448,6 +462,12 @@ static struct idxd_device *idxd_alloc(struct pci_dev *pdev, struct idxd_driver_d
 	if (idxd->id < 0)
 		return NULL;
 
+	idxd->opcap_bmap = bitmap_zalloc_node(IDXD_MAX_OPCAP_BITS, GFP_KERNEL, dev_to_node(dev));
+	if (!idxd->opcap_bmap) {
+		ida_free(&idxd_ida, idxd->id);
+		return NULL;
+	}
+
 	device_initialize(conf_dev);
 	conf_dev->parent = dev;
 	conf_dev->bus = &dsa_bus_type;
diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index 02449aa9c454..4c96ea85f843 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -90,6 +90,8 @@ struct opcap {
 	u64 bits[4];
 };
 
+#define IDXD_MAX_OPCAP_BITS		256U
+
 #define IDXD_OPCAP_OFFSET		0x40
 
 #define IDXD_TABLE_OFFSET		0x60
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 3f262a57441b..b6760b28a963 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1177,14 +1177,8 @@ static ssize_t op_cap_show(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
 	struct idxd_device *idxd = confdev_to_idxd(dev);
-	int i, rc = 0;
-
-	for (i = 0; i < 4; i++)
-		rc += sysfs_emit_at(buf, rc, "%#llx ", idxd->hw.opcap.bits[i]);
 
-	rc--;
-	rc += sysfs_emit_at(buf, rc, "\n");
-	return rc;
+	return sysfs_emit(buf, "%*pb\n", IDXD_MAX_OPCAP_BITS, idxd->opcap_bmap);
 }
 static DEVICE_ATTR_RO(op_cap);
 
@@ -1408,6 +1402,7 @@ static void idxd_conf_device_release(struct device *dev)
 	kfree(idxd->wqs);
 	kfree(idxd->engines);
 	ida_free(&idxd_ida, idxd->id);
+	bitmap_free(idxd->opcap_bmap);
 	kfree(idxd);
 }
 
-- 
2.35.1



