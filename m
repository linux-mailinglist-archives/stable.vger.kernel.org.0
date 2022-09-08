Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F7D5B22E7
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 17:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiIHP62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 11:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiIHP61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 11:58:27 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14F8F9108
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 08:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662652706; x=1694188706;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+6OUiz4rKrFjHm4ULr72B6eVMKgiKfq0/CDe9DNVRjg=;
  b=gfPzwkNGc8CnoKC1J+N4Vj0rUkab0th+qspV+NzZw2TrmL3yXigiFJS5
   QD/eaNIsC9YbPpbRfWUr34vCnka356lRtUS2VDRGmHDyEOHLLYri7G4Y3
   V+uA1n+ofcbgssqZtMDhRCU7Zfj37jEynQPbdtrfTEQPRmqrB30xoEUp/
   jvy+6Ew9i79ZVjU5j1EdB4jaqC4IPiH03RpVEl/Ufgws9Dy3+1YfmyQWy
   ItTUuIWLe895w2O3JOG0bYJ2pPXiS10xXoL/Kv31EtTHdoRkQtAH1ayv/
   dJVGmNamawjyq/MiLGZ8bHZXtMjS3/OPxCPEkcqTu4Ot/KmHbz4bWOY/y
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="294812475"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="294812475"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 08:58:26 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="592231383"
Received: from orsosgc001.jf.intel.com (HELO unerlige-ril.jf.intel.com) ([10.165.21.138])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 08:58:26 -0700
From:   Ashutosh Dixit <ashutosh.dixit@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Fix perf limit reasons bit positions
Date:   Thu,  8 Sep 2022 08:58:21 -0700
Message-Id: <20220908155821.1662110-1-ashutosh.dixit@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Perf limit reasons bit positions were off by one.

Fixes: fa68bff7cf27 ("drm/i915/gt: Add sysfs throttle frequency interfaces")
Cc: stable@vger.kernel.org # v5.18+
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Acked-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Sujaritha Sundaresan <sujaritha.sundaresan@intel.com>
---
 drivers/gpu/drm/i915/i915_reg.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index c413eec3373f..24009786f88b 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1794,14 +1794,14 @@
 
 #define GT0_PERF_LIMIT_REASONS		_MMIO(0x1381a8)
 #define   GT0_PERF_LIMIT_REASONS_MASK	0xde3
-#define   PROCHOT_MASK			REG_BIT(1)
-#define   THERMAL_LIMIT_MASK		REG_BIT(2)
-#define   RATL_MASK			REG_BIT(6)
-#define   VR_THERMALERT_MASK		REG_BIT(7)
-#define   VR_TDC_MASK			REG_BIT(8)
-#define   POWER_LIMIT_4_MASK		REG_BIT(9)
-#define   POWER_LIMIT_1_MASK		REG_BIT(11)
-#define   POWER_LIMIT_2_MASK		REG_BIT(12)
+#define   PROCHOT_MASK			REG_BIT(0)
+#define   THERMAL_LIMIT_MASK		REG_BIT(1)
+#define   RATL_MASK			REG_BIT(5)
+#define   VR_THERMALERT_MASK		REG_BIT(6)
+#define   VR_TDC_MASK			REG_BIT(7)
+#define   POWER_LIMIT_4_MASK		REG_BIT(8)
+#define   POWER_LIMIT_1_MASK		REG_BIT(10)
+#define   POWER_LIMIT_2_MASK		REG_BIT(11)
 
 #define CHV_CLK_CTL1			_MMIO(0x101100)
 #define VLV_CLK_CTL2			_MMIO(0x101104)
-- 
2.34.1

