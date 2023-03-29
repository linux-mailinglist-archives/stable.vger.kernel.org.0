Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC296CECBE
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 17:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjC2PXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 11:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbjC2PXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 11:23:09 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41F7191;
        Wed, 29 Mar 2023 08:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680103386; x=1711639386;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nL0f7A5x5LQ1jCJa81s31afmroXO2D9CQeufu39LtvI=;
  b=kkoSHF4+VlcTZrpfySX8inScEUQZzeQMJBRZfJGE8811hPBYakhejs0c
   3dajD8Jbp0lQ9vuOJSTTeLJ1SXU7y4EEXHjsTcCotnjrlMohafQVPVJJt
   0GIVIxrHdoxma5vgojrIiLrLBwhxzWn5S9lteFTsmvMdBz5Eqo/QFWan/
   RkPuV9jdGlrQlziV4h39J3GNCjZXPCelK2pRcf2O1OAEQMqPBjJ/OFJFG
   KY7RwJv0B/bkb+rDfxFejc26sKxY8nnkAIItZXPmtxp/0DXccm8XcD7FB
   EZxaN8usJdbZyrBeQ2o9ztWv3lzH2vDSF+6+rv2GedLZRjrW8sVXHCIU+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="368679580"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="368679580"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 08:22:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="808270496"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="808270496"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by orsmga004.jf.intel.com with ESMTP; 29 Mar 2023 08:22:13 -0700
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     rafael@kernel.org, rui.zhang@intel.com, daniel.lezcano@linaro.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] thermal: intel: int340x: processor_thermal: Fix additional deadlock
Date:   Wed, 29 Mar 2023 08:22:07 -0700
Message-Id: <20230329152207.991768-1-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 52f04f10b900 ("thermal: intel: int340x: processor_thermal: Fix
deadlock") addressed deadlock issue during user space trip update. But it
missed a case when thermal zone device is disabled when user writes 0.

Call to thermal_zone_device_disable() also causes deadlock as it also
tries to lock tz->lock, which is already claimed by trip_point_temp_store()
in the thermal core code.

Remove call to thermal_zone_device_disable() in the function
sys_set_trip_temp(), which is called from trip_point_temp_store().

Fixes: 52f04f10b900 ("thermal: intel: int340x: processor_thermal: Fix deadlock")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org # 6.2+
---
 .../thermal/intel/int340x_thermal/processor_thermal_device_pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
index 90526f46c9b1..d71ee50e7878 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
@@ -153,7 +153,6 @@ static int sys_set_trip_temp(struct thermal_zone_device *tzd, int trip, int temp
 		cancel_delayed_work_sync(&pci_info->work);
 		proc_thermal_mmio_write(pci_info, PROC_THERMAL_MMIO_INT_ENABLE_0, 0);
 		proc_thermal_mmio_write(pci_info, PROC_THERMAL_MMIO_THRES_0, 0);
-		thermal_zone_device_disable(tzd);
 		pci_info->stored_thres = 0;
 		return 0;
 	}
-- 
2.39.1

