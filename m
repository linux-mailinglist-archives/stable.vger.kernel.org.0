Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D5460E054
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 14:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbiJZMJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 08:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbiJZMIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 08:08:43 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633A1C1D90
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 05:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666786065; x=1698322065;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Lml/L4nm+aruhykmoM/m4x5FA5fE6H2WDPtTS6RnmAM=;
  b=EYAyITo/f78XniHTXTZT9i2W3rbkWu48C93RIufcuseGRm2xa2ROhjGK
   cAUwEAwY1WoWNZVuuJcat3uUX5wkZSDDUBoVeNdfVJsOzjjXo4PPeTFOo
   tubu28KQLoBbJdp6FvSCoFbqNrYTEsKbUk55zNG+gb7jX2E8vcB3gmxSI
   cC7wfO//oNo/Fx7ruxFZ6VSPobup8rfgvhZUAnt5MThdl6pYqv35Ru3mF
   TaHWVijt3sCSaDnogoP+vw+5f9ljnWQdfI61dtUrBoEgXzBUNzA2ymWfX
   uOswLev1tB3qzJRd/LFvsYYE2l/+fdKajK9vpQtJfyhDmRDrOJpuM5QgX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="291232962"
X-IronPort-AV: E=Sophos;i="5.95,214,1661842800"; 
   d="scan'208";a="291232962"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 05:07:22 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="877164492"
X-IronPort-AV: E=Sophos;i="5.95,214,1661842800"; 
   d="scan'208";a="877164492"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.53.127])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 05:07:20 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5.15] perf/x86/intel/pt: Relax address filter validation
Date:   Wed, 26 Oct 2022 15:07:09 +0300
Message-Id: <20221026120709.3866-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c243cecb58e3905baeace8827201c14df8481e2a upstream

The requirement for 64-bit address filters is that they are canonical
addresses. In other respects any address range is allowed which would
include user space addresses.

That can be useful for tracing virtual machine guests because address
filtering can be used to advantage in place of current privilege level
(CPL) filtering.

Now for stable because a side effect is that this also fixes
address filter validation for addresses in kernel modules.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220131072453.2839535-2-adrian.hunter@intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/events/intel/pt.c | 63 ++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 13 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 215aed65e978..9ac205487804 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -13,6 +13,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/types.h>
+#include <linux/bits.h>
+#include <linux/limits.h>
 #include <linux/slab.h>
 #include <linux/device.h>
 
@@ -1348,11 +1350,37 @@ static void pt_addr_filters_fini(struct perf_event *event)
 	event->hw.addr_filters = NULL;
 }
 
-static inline bool valid_kernel_ip(unsigned long ip)
+#ifdef CONFIG_X86_64
+static u64 canonical_address(u64 vaddr, u8 vaddr_bits)
 {
-	return virt_addr_valid(ip) && kernel_ip(ip);
+	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
 }
 
+static u64 is_canonical_address(u64 vaddr, u8 vaddr_bits)
+{
+	return canonical_address(vaddr, vaddr_bits) == vaddr;
+}
+
+/* Clamp to a canonical address greater-than-or-equal-to the address given */
+static u64 clamp_to_ge_canonical_addr(u64 vaddr, u8 vaddr_bits)
+{
+	return is_canonical_address(vaddr, vaddr_bits) ?
+	       vaddr :
+	       -BIT_ULL(vaddr_bits - 1);
+}
+
+/* Clamp to a canonical address less-than-or-equal-to the address given */
+static u64 clamp_to_le_canonical_addr(u64 vaddr, u8 vaddr_bits)
+{
+	return is_canonical_address(vaddr, vaddr_bits) ?
+	       vaddr :
+	       BIT_ULL(vaddr_bits - 1) - 1;
+}
+#else
+#define clamp_to_ge_canonical_addr(x, y) (x)
+#define clamp_to_le_canonical_addr(x, y) (x)
+#endif
+
 static int pt_event_addr_filters_validate(struct list_head *filters)
 {
 	struct perf_addr_filter *filter;
@@ -1367,14 +1395,6 @@ static int pt_event_addr_filters_validate(struct list_head *filters)
 		    filter->action == PERF_ADDR_FILTER_ACTION_START)
 			return -EOPNOTSUPP;
 
-		if (!filter->path.dentry) {
-			if (!valid_kernel_ip(filter->offset))
-				return -EINVAL;
-
-			if (!valid_kernel_ip(filter->offset + filter->size))
-				return -EINVAL;
-		}
-
 		if (++range > intel_pt_validate_hw_cap(PT_CAP_num_address_ranges))
 			return -EOPNOTSUPP;
 	}
@@ -1398,9 +1418,26 @@ static void pt_event_addr_filters_sync(struct perf_event *event)
 		if (filter->path.dentry && !fr[range].start) {
 			msr_a = msr_b = 0;
 		} else {
-			/* apply the offset */
-			msr_a = fr[range].start;
-			msr_b = msr_a + fr[range].size - 1;
+			unsigned long n = fr[range].size - 1;
+			unsigned long a = fr[range].start;
+			unsigned long b;
+
+			if (a > ULONG_MAX - n)
+				b = ULONG_MAX;
+			else
+				b = a + n;
+			/*
+			 * Apply the offset. 64-bit addresses written to the
+			 * MSRs must be canonical, but the range can encompass
+			 * non-canonical addresses. Since software cannot
+			 * execute at non-canonical addresses, adjusting to
+			 * canonical addresses does not affect the result of the
+			 * address filter.
+			 */
+			msr_a = clamp_to_ge_canonical_addr(a, boot_cpu_data.x86_virt_bits);
+			msr_b = clamp_to_le_canonical_addr(b, boot_cpu_data.x86_virt_bits);
+			if (msr_b < msr_a)
+				msr_a = msr_b = 0;
 		}
 
 		filters->filter[range].msr_a  = msr_a;
-- 
2.34.1

