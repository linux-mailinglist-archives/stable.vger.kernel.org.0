Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6F35BA744
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 09:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiIPHMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 03:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiIPHMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 03:12:18 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F7D4B4AD
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 00:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663312336; x=1694848336;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0jETsX3p5DQRkBm8H/U1fajbR6ezzfZd+nH9Cn3T5GA=;
  b=DFLMHUKMUPKXInnrpwOzwSRBM/qkkd5O4L5H0CO+uyp6J2lNqvQbhqlI
   /ykkSxUatZJtMcJ+If7W2kYf62treuUznaM5wl0FqGwDo/QW0dqCXdkbB
   UNQfFQhKJ4HfRFXV1iKyId3aYCM6wvw91DN+ClGOTkkQf7Mdu2GRjEyca
   B4O4DAlmYz2M1NPtBIp9v4Z+rUqZzhZnbwbQrga19HXfrmApze665oqJR
   CsYd1iOacs0Gm1cddtFq0tZgIUegVP1MldwG6NvzLagcumIqthQjc9aRo
   5HgOe3gH1iAVeuLRJwav9wR/X0NKCUcfgefL2ufGKmKWysf+WJAeqeaTk
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="296519963"
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="296519963"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2022 00:12:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="650780432"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga001.jf.intel.com with ESMTP; 16 Sep 2022 00:12:15 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     baolu.lu@linux.intel.com
Cc:     kevin.tian@intel.com, baolu.lu@intel.com, yi.l.liu@intel.com,
        raghunathan.srinivasan@intel.com, iommu@lists.linux.dev,
        joro@8bytes.org, will@kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/2] iommu/vt-d: Check correct capability for sagaw determination
Date:   Fri, 16 Sep 2022 00:12:11 -0700
Message-Id: <20220916071212.2223869-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220916071212.2223869-1-yi.l.liu@intel.com>
References: <20220916071212.2223869-1-yi.l.liu@intel.com>
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

Check 5-level paging capability for 57 bits address width instead of
checking 1GB large page capability.

Fixes: 53fc7ad6edf2 ("iommu/vt-d: Correctly calculate sagaw value of IOMMU")
Cc: stable@vger.kernel.org
Reported-by: Raghunathan Srinivasan <raghunathan.srinivasan@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 1f2cd43cf9bc..664499dddf0c 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -399,7 +399,7 @@ static unsigned long __iommu_calculate_sagaw(struct intel_iommu *iommu)
 {
 	unsigned long fl_sagaw, sl_sagaw;
 
-	fl_sagaw = BIT(2) | (cap_fl1gp_support(iommu->cap) ? BIT(3) : 0);
+	fl_sagaw = BIT(2) | (cap_5lp_support(iommu->cap) ? BIT(3) : 0);
 	sl_sagaw = cap_sagaw(iommu->cap);
 
 	/* Second level only. */
-- 
2.34.1

