Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B056A9B85
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 17:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCCQTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 11:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjCCQTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 11:19:30 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84F323679;
        Fri,  3 Mar 2023 08:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677860355; x=1709396355;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ek6XqKRjAwHSqFxYlwA0ot0sijMnK5XWyd+WPWb4jEI=;
  b=a9qjSxGbbAcYO710Lon2yPUdH9349k+XLd5B9E+VTThmfPWktSN39wUn
   67dWczqj7r8DDveqYxC7JXwodf7V/hH+Il1QJfcuErKz/IOAFNMGQelXV
   Gy5JVXav2O/s8PDzR7JJVutj93LqCBKefIYBmTZipu5S/cSOKf3iKBlJa
   906bcQiZEpNzTkr6c2V1D+O5zkPzs+Rx5b/xF9gJjPfe0yPvEZus+veR+
   TfhQF4gEJC+Tb24fLQqaKIx3CbbbhGwy9pkGGwWR/mK0lV9l1Jshu43dc
   GT3ujsrHsbXb/jTSoGX4YwguPw3kgRUFfMbyZxDzumbCCB7i/+JPUri7E
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="397667308"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="397667308"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 08:19:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="675425096"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="675425096"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by orsmga002.jf.intel.com with ESMTP; 03 Mar 2023 08:19:14 -0800
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     rafael@kernel.org, rui.zhang@intel.com, daniel.lezcano@linaro.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] thermal: int340x: processor_thermal: Fix deadlock
Date:   Fri,  3 Mar 2023 08:19:09 -0800
Message-Id: <20230303161910.3195805-1-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@intel.com>

When user space updates the trip point there is a deadlock, which results
in caller gets blocked forever.

Commit 05eeee2b51b4 ("thermal/core: Protect sysfs accesses to thermal
operations with thermal zone mutex"), added a mutex for tz->lock in the
function trip_point_temp_store(). Hence, trip set callback() can't
call any thermal zone API as they are protected with the same mutex lock.

The callback here calling thermal_zone_device_enable(), which will result
in deadlock.

Move the thermal_zone_device_enable() to proc_thermal_pci_probe() to
avoid this deadlock.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Cc: stable@vger.kernel.org
---
The commit which caused this issue was added during v6.2 cycle.

 .../intel/int340x_thermal/processor_thermal_device_pci.c     | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
index bf1b1cdfade4..acc11ad56975 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
@@ -194,7 +194,6 @@ static int sys_set_trip_temp(struct thermal_zone_device *tzd, int trip, int temp
 	proc_thermal_mmio_write(pci_info, PROC_THERMAL_MMIO_THRES_0, _temp);
 	proc_thermal_mmio_write(pci_info, PROC_THERMAL_MMIO_INT_ENABLE_0, 1);
 
-	thermal_zone_device_enable(tzd);
 	pci_info->stored_thres = temp;
 
 	return 0;
@@ -277,6 +276,10 @@ static int proc_thermal_pci_probe(struct pci_dev *pdev, const struct pci_device_
 		goto err_free_vectors;
 	}
 
+	ret = thermal_zone_device_enable(pci_info->tzone);
+	if (ret)
+		goto err_free_vectors;
+
 	return 0;
 
 err_free_vectors:
-- 
2.34.1

