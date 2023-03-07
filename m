Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751706AF49D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbjCGTRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233912AbjCGTRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:17:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B00C48A4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:01:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76106B8199A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB5AC433D2;
        Tue,  7 Mar 2023 19:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215683;
        bh=zbMHqvl/9n4WQZLnBxjYh1NN6YJ8/uNsgcogAJc2izw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ix2EUzRMZz92UQN45Md/3Eg1uSUpdk+dipcr6MjsSvwjuHrnUknPuvwp5ODUh8oGg
         yT+AKFdl4ZHdgrP8upephoOx9KOnkPpMAPmldoA0nBbK7zG5Qk6Q1QBX5pGghOc7lA
         +8D18il1hP7pub1689LoUQnKJZJGx0OwFkdfNsPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Tina Zhang <tina.zhang@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 341/567] iommu/vt-d: Allow to use flush-queue when first level is default
Date:   Tue,  7 Mar 2023 18:01:17 +0100
Message-Id: <20230307165920.651303473@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tina Zhang <tina.zhang@intel.com>

[ Upstream commit 257ec290741924f8df678927d0dfecb1deebb9c5 ]

Commit 29b32839725f ("iommu/vt-d: Do not use flush-queue when caching-mode
is on") forced default domains to be strict mode as long as IOMMU
caching-mode is flagged. The reason for doing this is that when vIOMMU
uses VT-d caching mode to synchronize shadowing page tables, the strict
mode shows better performance.

However, this optimization is orthogonal to the first-level page table
because the Intel VT-d architecture does not define the caching mode of
the first-level page table. Refer to VT-d spec, section 6.1, "When the
CM field is reported as Set, any software updates to remapping
structures other than first-stage mapping (including updates to not-
present entries or present entries whose programming resulted in
translation faults) requires explicit invalidation of the caches."
Exclude the first-level page table from this optimization.

Generally using first-stage translation in vIOMMU implies nested
translation enabled in the physical IOMMU. In this case the first-stage
page table is wholly captured by the guest. The vIOMMU only needs to
transfer the cache invalidations on vIOMMU to the physical IOMMU.
Forcing the default domain to strict mode will cause more frequent
cache invalidations, resulting in performance degradation. In a real
performance benchmark test measured by iperf receive, the performance
result on Sapphire Rapids 100Gb NIC shows:
w/ this fix ~51 Gbits/s, w/o this fix ~39.3 Gbits/s.

Theoretically a first-stage IOMMU page table can still be shadowed
in absence of the caching mode, e.g. with host write-protecting guest
IOMMU page table to synchronize changed PTEs with the physical
IOMMU page table. In this case the shadowing overhead is decoupled
from emulating IOTLB invalidation then the overhead of the latter part
is solely decided by the frequency of IOTLB invalidations. Hence
allowing guest default dma domain to be lazy can also benefit the
overall performance by reducing the total VM-exit numbers.

Fixes: 29b32839725f ("iommu/vt-d: Do not use flush-queue when caching-mode is on")
Reported-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Suggested-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Tina Zhang <tina.zhang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20230214025618.2292889-1-tina.zhang@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 850b0590c24a5..9666391240928 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4423,7 +4423,8 @@ int __init intel_iommu_init(void)
 		 * is likely to be much lower than the overhead of synchronizing
 		 * the virtual and physical IOMMU page-tables.
 		 */
-		if (cap_caching_mode(iommu->cap)) {
+		if (cap_caching_mode(iommu->cap) &&
+		    !first_level_by_default(IOMMU_DOMAIN_DMA)) {
 			pr_info_once("IOMMU batching disallowed due to virtualization\n");
 			iommu_set_dma_strict();
 		}
-- 
2.39.2



