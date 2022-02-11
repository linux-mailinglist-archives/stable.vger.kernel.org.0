Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5AC4B2147
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 10:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348345AbiBKJPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 04:15:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbiBKJPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 04:15:12 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84858102D
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 01:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644570912; x=1676106912;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=16PzWI/Zh3nEwNsaZ5vSi/iBYvqMb+/qnl7qLjco514=;
  b=glGHbcwc7HUnKtOLJWT/gHdhJx9hqPKVpu/aoYXUDoPBkZ4nq69BH+qZ
   sYEi5oPUtZSXPQW8xyEB5GAEw45+tsu1YzaJ8fXi5DjK4PL6HsI1/nI2u
   6txYXIMM3ur1AyBDlewRTsXz/TcTNX59yV0B/PLQYnzMIBrwyqvxLLmwy
   mf1O1CrQI5HsN4rq4lHRLoLc3Jc+0+CqRppHiOUiCH3O05Bib1dbEhhCr
   VsQhaaKH/GQKAdQ5QhSxJIZBaKTHNva6QUwHHWNU4RHZwrUUdXVj6bXd3
   OamhjIILI6WFHIJu9hitSoyXrBrNGJi5quqAY7xS0bH5YJpyCGS8F7P71
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="310432791"
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="310432791"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 01:15:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="702037660"
Received: from srpawnik-desktop.iind.intel.com ([10.223.141.132])
  by orsmga005.jf.intel.com with ESMTP; 11 Feb 2022 01:15:10 -0800
From:   Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, srinivas.pandruvada@linux.intel.com
Cc:     sumeet.r.pawnikar@intel.com, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH  3/4] thermal: int340x: Limit Kconfig to 64-bit
Date:   Fri, 11 Feb 2022 15:04:36 +0530
Message-Id: <20220211093437.8713-4-sumeet.r.pawnikar@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220211093437.8713-1-sumeet.r.pawnikar@intel.com>
References: <20220211093437.8713-1-sumeet.r.pawnikar@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

32-bit processors cannot generally access 64-bit MMIO registers
atomically, and it is unknown in which order the two halves of
this registers would need to be read:

drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c: In function 'send_mbox_cmd':
drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c:79:37: error: implicit declaration of function 'readq'; did you mean 'readl'? [-Werror=implicit-function-declaration]
   79 |                         *cmd_resp = readq((void __iomem *) (proc_priv->mmio_base + MBOX_OFFSET_DATA));
      |                                     ^~~~~
      |                                     readl

The driver already does not build for anything other than x86,
so limit it further to x86-64.

Fixes: aeb58c860dc5 ("thermal/drivers/int340x: processor_thermal: Suppot 64 bit RFIM responses")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
---
 drivers/thermal/intel/int340x_thermal/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/Kconfig b/drivers/thermal/intel/int340x_thermal/Kconfig
index 45c31f3d6054..5d046de96a5d 100644
--- a/drivers/thermal/intel/int340x_thermal/Kconfig
+++ b/drivers/thermal/intel/int340x_thermal/Kconfig
@@ -5,12 +5,12 @@
 
 config INT340X_THERMAL
 	tristate "ACPI INT340X thermal drivers"
-	depends on X86 && ACPI && PCI
+	depends on X86_64 && ACPI && PCI
 	select THERMAL_GOV_USER_SPACE
 	select ACPI_THERMAL_REL
 	select ACPI_FAN
 	select INTEL_SOC_DTS_IOSF_CORE
-	select PROC_THERMAL_MMIO_RAPL if X86_64 && POWERCAP
+	select PROC_THERMAL_MMIO_RAPL if POWERCAP
 	help
 	  Newer laptops and tablets that use ACPI may have thermal sensors and
 	  other devices with thermal control capabilities outside the core
-- 
2.17.1

