Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F325FCBDC
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 22:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiJLUOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 16:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiJLUO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 16:14:28 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EC7B2D9F;
        Wed, 12 Oct 2022 13:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665605666; x=1697141666;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=huo+KtRk2qsQtwkewNosEHJSjhPQ+l135DctbnNxUwc=;
  b=l3+PuHku82CeAoCL0QaygLslfhVJCY+NZ76j3/yv1jUrTDvIgd1zF6pD
   Iaks/tNRkl4xtOqlpodPSL/nMe1INmpHhnSS1QnkEXdTDN55QkuVYsMU4
   MPuM+sHaEykYANzIo6tgJbTaD/Y6UZKXJ5oNcCztdlPFlAzTY5ROJETE/
   bhHkV3sYXiXg83acjVspWUF3nfrOoYTBqmehuDh5t3UIb7Sllou1JxFY+
   bBZcfgA2hkeoACSrgO+cHEC4Y32u4jLTta5VPaHsJ3kgs5xi6jbTE/eVU
   U/k9VqJMrXpDg0FbplE9B1dZIwJNxuDP6Zg+JX0mJCSPmXfo1dRrL08Vz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10498"; a="331395163"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="331395163"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2022 13:14:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10498"; a="621904664"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="621904664"
Received: from fyu1.sc.intel.com ([172.25.103.126])
  by orsmga007.jf.intel.com with ESMTP; 12 Oct 2022 13:14:08 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Vinod Koul" <vkoul@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Sasha Levin" <sashal@kernel.org>,
        "Arjan Van De Ven" <arjan.van.de.ven@intel.com>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Dave Jiang" <dave.jiang@intel.com>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        "Jacob Pan" <jacob.jun.pan@linux.intel.com>
Cc:     dmaengine@vger.kernel.org, stable@vger.kernel.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH] dmaengine: idxd: Do not enable user type Work Queue without Shared Virtual Addressing
Date:   Wed, 12 Oct 2022 13:14:18 -0700
Message-Id: <20221012201418.3883096-1-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Userspace can directly access physical address through user type
Work Queue (WQ) in two scenarios: no IOMMU or IOMMU Passthrough
without Shared Virtual Addressing (SVA). In these two cases, user type WQ
allows userspace to issue DMA physical address access without virtual
to physical translation.

This is inconsistent with the security goals of a good kernel API.

Plus there is no usage for user type WQ without SVA.

So enable user type WQ only when SVA is enabled (i.e. user PASID is
enabled).

Fixes: 42d279f9137a ("dmaengine: idxd: add char driver to expose submission portal to userland")

Suggested-by: Arjan Van De Ven <arjan.van.de.ven@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/cdev.c   | 14 ++++++++++++++
 include/uapi/linux/idxd.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index c2808fd081d6..4cd3400c5a48 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -312,6 +312,20 @@ static int idxd_user_drv_probe(struct idxd_dev *idxd_dev)
 	if (idxd->state != IDXD_DEV_ENABLED)
 		return -ENXIO;
 
+	/*
+	 * User type WQ is enabled only when SVA is enabled for two reasons:
+	 *   - If no IOMMU or IOMMU Passthrough without SVA, userspace
+	 *     can directly access physical address through the WQ.
+	 *   - There is no usage case for the WQ without SVA.
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

