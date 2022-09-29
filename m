Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB445EFCF4
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 20:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbiI2SXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 14:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbiI2SXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 14:23:16 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8172142E25;
        Thu, 29 Sep 2022 11:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664475795; x=1696011795;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SA5Zv3CFmymWcqoF3kgJhVL3n30g1TRkOiD3YxTlFFM=;
  b=Vq4bNPnknL+/IWxZVw03yDGy2U0DJVeR8iE8J5Yjksra8jZzUqhAC8Id
   lWV4GAxOWm290WsUSUGZtZG0/CGP6kA0iaPzvxt1fgq1v6tFHPF4e1+KL
   Bz6VL9rhYZO1/a+D53MBBVwqBSp8qbnImsB5VQiOyvj/aiJZ7t3ZACw1b
   A=;
X-IronPort-AV: E=Sophos;i="5.93,356,1654560000"; 
   d="scan'208";a="1059364674"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-b27d4a00.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 18:23:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b27d4a00.us-east-1.amazon.com (Postfix) with ESMTPS id 2457281255;
        Thu, 29 Sep 2022 18:23:12 +0000 (UTC)
Received: from EX19D012UWB001.ant.amazon.com (10.13.138.50) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 29 Sep 2022 18:23:11 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX19D012UWB001.ant.amazon.com (10.13.138.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.12; Thu, 29 Sep 2022 18:23:11 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Thu, 29 Sep 2022 18:23:10
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 98CF927B3; Thu, 29 Sep 2022 18:23:09 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <linux-kernel@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <stable@vger.kernel.org>
CC:     <hch@lst.de>, <sagi@grimberg.me>, <axboe@fb.com>,
        <kbusch@kernel.org>, <mbacco@amazon.com>, <benh@amazon.com>,
        <sjpark@amazon.com>, "Rishabh Bhatnagar" <risbhat@amazon.com>
Subject: [PATCH v2] nvme-pci: Set min align mask before calculating max_hw_sectors
Date:   Thu, 29 Sep 2022 18:22:59 +0000
Message-ID: <20220929182259.22523-1-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-12.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In cases where swiotlb is enabled dma_max_mapping_size takes into
account the min align mask for the device. Right now the mask is
set after the max hw sectors are calculated which might result in
a request size that overflows the swiotlb buffer.
Set the min align mask for nvme driver before calling
dma_max_mapping_size while calculating max hw sectors.

Fixes: 7637de311bd2 ("nvme-pci: limit max_hw_sectors based on the DMA max mapping size")
Cc: stable@vger.kernel.org
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 Changes in V2:
 - Add Cc: <stable@vger.kernel.org> tag
 - Improve the commit text
 - Add patch version

 Changes in V1:
 - Add fixes tag

 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 98864b853eef..30e71e41a0a2 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2834,6 +2834,8 @@ static void nvme_reset_work(struct work_struct *work)
 		nvme_start_admin_queue(&dev->ctrl);
 	}
 
+	dma_set_min_align_mask(dev->dev, NVME_CTRL_PAGE_SIZE - 1);
+
 	/*
 	 * Limit the max command size to prevent iod->sg allocations going
 	 * over a single page.
@@ -2846,7 +2848,6 @@ static void nvme_reset_work(struct work_struct *work)
 	 * Don't limit the IOMMU merged segment size.
 	 */
 	dma_set_max_seg_size(dev->dev, 0xffffffff);
-	dma_set_min_align_mask(dev->dev, NVME_CTRL_PAGE_SIZE - 1);
 
 	mutex_unlock(&dev->shutdown_lock);
 
-- 
2.37.1

