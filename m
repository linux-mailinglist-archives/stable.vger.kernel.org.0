Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDDA571F97
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 17:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiGLPj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 11:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGLPj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 11:39:56 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EAAB6DAF;
        Tue, 12 Jul 2022 08:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657640395; x=1689176395;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=F7VV3q2hjlQTSC7T2+EILAlpcUTmpM8ilmUao/NlR40=;
  b=FuSoZKcZY4oV69pQYz7LLCjknAiMPTgzpE0F4GVudmRne4aOCQI6VNfs
   c0mEN3JpVF+NSZtnatr3XSArHUjR+hnhACxi0KMcxgYcvbYtIdFITGeCp
   l9q+YA29LjwGiPCNi2SyQtIXceFDjgxe0r973CiMZwewXQ02xVO8xvi0z
   qF3v9V1bVXp9itww20gsBZN3WZenwI7cDor6dPTPfKV1y3myH2o3DwdRr
   Ve7lcZcn9qUpY09cG3OAruhNsJNYBCB4DGE4TEueJzucyEP6LE1pLblLR
   +IOOFUADBRhTAwzoCWiIbWZs41LiCC8jqLSRTiFCy4zrNVZq7BV+/pAAC
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="371279836"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="371279836"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 08:39:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="545473915"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 12 Jul 2022 08:39:52 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26CFdod0023823;
        Tue, 12 Jul 2022 16:39:51 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Yury Norov <yury.norov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        kernel test robot <oliver.sang@intel.com>,
        iommu@lists.linux.dev, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iommu/vt-d: avoid invalid memory access via node_online(NUMA_NO_NODE)
Date:   Tue, 12 Jul 2022 17:38:36 +0200
Message-Id: <20220712153836.41599-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

KASAN reports:

[ 4.668325][ T0] BUG: KASAN: wild-memory-access in dmar_parse_one_rhsa (arch/x86/include/asm/bitops.h:214 arch/x86/include/asm/bitops.h:226 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/nodemask.h:415 drivers/iommu/intel/dmar.c:497)
[    4.676149][    T0] Read of size 8 at addr 1fffffff85115558 by task swapper/0/0
[    4.683454][    T0]
[    4.685638][    T0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.19.0-rc3-00004-g0e862838f290 #1
[    4.694331][    T0] Hardware name: Supermicro SYS-5018D-FN4T/X10SDV-8C-TLN4F, BIOS 1.1 03/02/2016
[    4.703196][    T0] Call Trace:
[    4.706334][    T0]  <TASK>
[ 4.709133][ T0] ? dmar_parse_one_rhsa (arch/x86/include/asm/bitops.h:214 arch/x86/include/asm/bitops.h:226 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/nodemask.h:415 drivers/iommu/intel/dmar.c:497)

after converting the type of the first argument (@nr, bit number)
of arch_test_bit() from `long` to `unsigned long`[0].

Under certain conditions (for example, when ACPI NUMA is disabled
via command line), pxm_to_node() can return %NUMA_NO_NODE (-1).
It is valid 'magic' number of NUMA node, but not valid bit number
to use in bitops.
node_online() eventually descends to test_bit() without checking
for the input, assuming it's on caller side (which might be good
for perf-critical tasks). There, -1 becomes %ULONG_MAX which leads
to an insane array index when calculating bit position in memory.

For now, add an explicit check for @node being not %NUMA_NO_NODE
before calling test_bit(). The actual logics didn't change here
at all.

Fixes: ee34b32d8c29 ("dmar: support for parsing Remapping Hardware Static Affinity structure")
Cc: stable@vger.kernel.org # 2.6.33+
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/iommu/intel/dmar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 9699ca101c62..64b14ac4c7b0 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -494,7 +494,7 @@ static int dmar_parse_one_rhsa(struct acpi_dmar_header *header, void *arg)
 		if (drhd->reg_base_addr == rhsa->base_address) {
 			int node = pxm_to_node(rhsa->proximity_domain);
 
-			if (!node_online(node))
+			if (node != NUMA_NO_NODE && !node_online(node))
 				node = NUMA_NO_NODE;
 			drhd->iommu->node = node;
 			return 0;
-- 
2.36.1

