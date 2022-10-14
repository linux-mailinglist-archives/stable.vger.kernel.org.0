Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2169C5FF65D
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 00:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiJNWZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 18:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiJNWZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 18:25:33 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DF166846;
        Fri, 14 Oct 2022 15:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665786332; x=1697322332;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=crbgjyT8O52ZWI32HYW5IlNr+CfyhK7rYCZVgst+Q/E=;
  b=D3feSMbEqHs5de/PT/qGV2u4n7iYtYJ/nn1dp+EAZdW0E+ycLiuP42gf
   ZrqKFtpK82IuiykgX2rNUufok12LZyIGIoQ5mX+9l6oBoKFQkGZ9PP9p2
   R7EMgfQYf6tkZs4dV7SUA4UOuD5n7H5ECrWlSM1w9RM/BrsQSoxGhtO4t
   ozHuDzXfAmtH+o+Y1HEmSAgGZuOIB1VsffiGWYaZmGXbOOW1uCqkZKXnS
   gRmDnkRYZSGFG9J5ImPL7uFq+9IPre8/0OvwHM2f65TmLkOv+E+doJPUj
   c3kOt4/PJnktJHZdV/uuR5N0lHZg7ZYbPWlpOgA3gG25Yus1f4XrZN4Zn
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="305472374"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="305472374"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 15:25:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="578779966"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="578779966"
Received: from fyu1.sc.intel.com ([172.25.103.126])
  by orsmga003.jf.intel.com with ESMTP; 14 Oct 2022 15:25:31 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Vinod Koul" <vkoul@kernel.org>,
        "Arjan Van De Ven" <arjan.van.de.ven@intel.com>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Dave Jiang" <dave.jiang@intel.com>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        "Jacob Pan" <jacob.jun.pan@linux.intel.com>
Cc:     dmaengine@vger.kernel.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>, stable@vger.kernel.org
Subject: [PATCH v2] dmaengine: idxd: Do not enable user type Work Queue without Shared Virtual Addressing
Date:   Fri, 14 Oct 2022 15:25:41 -0700
Message-Id: <20221014222541.3912195-1-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the idxd_user_drv driver is bound to a Work Queue (WQ) device
without IOMMU or with IOMMU Passthrough without Shared Virtual
Addressing (SVA), the application gains direct access to physical
memory via the device by programming physical address to a submitted
descriptor. This allows direct userspace read and write access to
arbitrary physical memory. This is inconsistent with the security
goals of a good kernel API.

Unlike vfio_pci driver, the IDXD char device driver does not provide any
ways to pin user pages and translate the address from user VA to IOVA or
PA without IOMMU SVA. Therefore the application has no way to instruct the
device to perform DMA function. This makes the char device not usable for
normal application usage.

Since user type WQ without SVA cannot be used for normal application usage
and presents the security issue, bind idxd_user_drv driver and enable user
type WQ only when SVA is enabled (i.e. user PASID is enabled).

Fixes: 448c3de8ac83 ("dmaengine: idxd: create user driver for wq 'device'")
Cc: stable@vger.kernel.org
Suggested-by: Arjan Van De Ven <arjan.van.de.ven@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
v2:
- Update changlog per Dave Hansen's comments

 drivers/dma/idxd/cdev.c   | 18 ++++++++++++++++++
 include/uapi/linux/idxd.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index c2808fd081d6..a9b96b18772f 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -312,6 +312,24 @@ static int idxd_user_drv_probe(struct idxd_dev *idxd_dev)
 	if (idxd->state != IDXD_DEV_ENABLED)
 		return -ENXIO;
 
+	/*
+	 * User type WQ is enabled only when SVA is enabled for two reasons:
+	 *   - If no IOMMU or IOMMU Passthrough without SVA, userspace
+	 *     can directly access physical address through the WQ.
+	 *   - The IDXD cdev driver does not provide any ways to pin
+	 *     user pages and translate the address from user VA to IOVA or
+	 *     PA without IOMMU SVA. Therefore the application has no way
+	 *     to instruct the device to perform DMA function. This makes
+	 *     the cdev not usable for normal application usage.
+	 */
+	if (!device_user_pasid_enabled(idxd)) {
+		idxd->cmd_status = IDXD_SCMD_WQ_USER_NO_IOMMU;
+		dev_dbg(&idxd->pdev->dev,
+			"User type WQ cannot be enabled without SVA.\n");
+
+		return -EOPNOTSUPP;
+	}
+
 	mutex_lock(&wq->wq_lock);
 	wq->type = IDXD_WQT_USER;
 	rc = drv_enable_wq(wq);
diff --git a/include/uapi/linux/idxd.h b/include/uapi/linux/idxd.h
index 095299c75828..2b9e7feba3f3 100644
--- a/include/uapi/linux/idxd.h
+++ b/include/uapi/linux/idxd.h
@@ -29,6 +29,7 @@ enum idxd_scmd_stat {
 	IDXD_SCMD_WQ_NO_SIZE = 0x800e0000,
 	IDXD_SCMD_WQ_NO_PRIV = 0x800f0000,
 	IDXD_SCMD_WQ_IRQ_ERR = 0x80100000,
+	IDXD_SCMD_WQ_USER_NO_IOMMU = 0x80110000,
 };
 
 #define IDXD_SCMD_SOFTERR_MASK	0x80000000
-- 
2.32.0

