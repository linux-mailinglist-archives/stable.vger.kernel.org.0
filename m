Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04C44C3DD8
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 06:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbiBYF11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 00:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiBYF10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 00:27:26 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09194756D
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 21:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645766812; x=1677302812;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=emEj9f2p+/wpD1xkSTpzgY4vdBL3m1sDZweir9nvenM=;
  b=hu8S8ZX2XEJkI+dN/yIlixp25XmoikSVoBBHbCVbS8uZOZuSU3M2u8ho
   2r5Cc+0ySHAIJQo7CT0ptasmz+fto2IiAxgnZVRvhAissEWVcoO/4RyJ/
   RUq5NhQg13jSekaOBH+RpB8wa1feRjlKr1iX+XxOiekq4ftFQfsrN+UWs
   ngCmcBPIAz10ZyKujLTgsAJFIyNwuz3t83z38IxPNgIcxkVMxJEduv17Y
   Xdlzfw8A7HR/AiA1M3pPU2rHC8FzWIHMEOBAu+bCCxp7vOxZb8RkaM7nc
   pYmXhq+m5J7l/PhvP4dx9pJRXlh6Xv+sqnuN1HQBvLLRLOXK5d8qNXZjN
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="252155342"
X-IronPort-AV: E=Sophos;i="5.90,135,1643702400"; 
   d="scan'208";a="252155342"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 21:26:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,135,1643702400"; 
   d="scan'208";a="491869943"
Received: from tejas-system-product-name.iind.intel.com ([10.145.162.130])
  by orsmga003.jf.intel.com with ESMTP; 24 Feb 2022 21:26:48 -0800
From:   Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>
To:     iommu@lists.linux-foundation.org
Cc:     Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>,
        Raviteja Goud Talla <ravitejax.goud.talla@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org
Subject: [PATCH V2] iommu/vt-d: Add RPLS to quirk list to skip TE disabling
Date:   Fri, 25 Feb 2022 10:43:17 +0530
Message-Id: <20220225051317.152960-1-tejaskumarx.surendrakumar.upadhyay@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The VT-d spec requires (10.4.4 Global Command Register, TE
field) that:

Hardware implementations supporting DMA draining must drain
any in-flight DMA read/write requests queued within the
Root-Complex before completing the translation enable
command and reflecting the status of the command through
the TES field in the Global Status register.

Unfortunately, some integrated graphic devices fail to do
so after some kind of power state transition. As the
result, the system might stuck in iommu_disable_translati
on(), waiting for the completion of TE transition.

This adds RPLS to a quirk list for those devices and skips
TE disabling if the qurik hits.

Fixes: b1012ca8dc4f9 "iommu/vt-d: Skip TE disabling on quirky gfx dedicated iommu"
Tested-by: Raviteja Goud Talla <ravitejax.goud.talla@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>
---
 drivers/iommu/intel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 92fea3fbbb11..be9487516617 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5743,7 +5743,7 @@ static void quirk_igfx_skip_te_disable(struct pci_dev *dev)
 	ver = (dev->device >> 8) & 0xff;
 	if (ver != 0x45 && ver != 0x46 && ver != 0x4c &&
 	    ver != 0x4e && ver != 0x8a && ver != 0x98 &&
-	    ver != 0x9a)
+	    ver != 0x9a && ver != 0xa7)
 		return;
 
 	if (risky_device(dev))
-- 
2.34.1

