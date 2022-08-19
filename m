Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CEC59A4E1
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353659AbiHSQmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354113AbiHSQlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:41:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBEE1296C3;
        Fri, 19 Aug 2022 09:10:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9B4161811;
        Fri, 19 Aug 2022 16:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05A6C433C1;
        Fri, 19 Aug 2022 16:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925434;
        bh=OuBP3EZABoATWLplK79AVl6BvvWf0TZZLXbKO6eBR7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWKdCw/I6f8ggFnefNCfXIuLR1MUSgf082/Fnw9CSEmq9Ks2K60e8VSnfoyP87JK6
         DnHrHEaBexNI8P0F/sTQY2X1I5zg0EoWdHT3oySiq0ctFnFafYJV7ewcYyprboT3Rm
         z6sRyp3rqnadf2/HkN9VgZ6v8/Rzu7LGFuvrHVOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yury Norov <yury.norov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 472/545] iommu/vt-d: avoid invalid memory access via node_online(NUMA_NO_NODE)
Date:   Fri, 19 Aug 2022 17:44:02 +0200
Message-Id: <20220819153850.522230547@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

[ Upstream commit b0b0b77ea611e3088e9523e60860f4f41b62b235 ]

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

[0] https://github.com/norov/linux/commit/0e862838f290147ea9c16db852d8d494b552d38d

Fixes: ee34b32d8c29 ("dmar: support for parsing Remapping Hardware Static Affinity structure")
Cc: stable@vger.kernel.org # 2.6.33+
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/dmar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 70d569b80ecf..0bc497f4cb9f 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -497,7 +497,7 @@ static int dmar_parse_one_rhsa(struct acpi_dmar_header *header, void *arg)
 		if (drhd->reg_base_addr == rhsa->base_address) {
 			int node = pxm_to_node(rhsa->proximity_domain);
 
-			if (!node_online(node))
+			if (node != NUMA_NO_NODE && !node_online(node))
 				node = NUMA_NO_NODE;
 			drhd->iommu->node = node;
 			return 0;
-- 
2.35.1



