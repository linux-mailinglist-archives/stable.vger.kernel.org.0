Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4891B5218F6
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243509AbiEJNkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245195AbiEJNii (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47A25FCA;
        Tue, 10 May 2022 06:28:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 55A86CE1EED;
        Tue, 10 May 2022 13:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24595C385C2;
        Tue, 10 May 2022 13:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189316;
        bh=tDDRTR4hAcafWMH1wych2cfeBCdy8kCp9bNyavD8AN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJOBfdt70myElGS/zWWRj9yeY0W4geUGGMmh4GdGkP+DHUkjlpPDgt9fP8IHd+j9q
         BjnvxIKMBKsFIhXm1zRP73eFtZkhQapDIhpOSt0nk2xRTXEaJCxuuktfy+sjaPDHf5
         9EW1SZljY99l9BriomaIMK+wIk0JUFbWvmou9ass=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolin Chen <nicolinc@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 012/135] iommu/arm-smmu-v3: Fix size calculation in arm_smmu_mm_invalidate_range()
Date:   Tue, 10 May 2022 15:06:34 +0200
Message-Id: <20220510130740.748771520@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolin Chen <nicolinc@nvidia.com>

commit 95d4782c34a60800ccf91d9f0703137d4367a2fc upstream.

The arm_smmu_mm_invalidate_range function is designed to be called
by mm core for Shared Virtual Addressing purpose between IOMMU and
CPU MMU. However, the ways of two subsystems defining their "end"
addresses are slightly different. IOMMU defines its "end" address
using the last address of an address range, while mm core defines
that using the following address of an address range:

	include/linux/mm_types.h:
		unsigned long vm_end;
		/* The first byte after our end address ...

This mismatch resulted in an incorrect calculation for size so it
failed to be page-size aligned. Further, it caused a dead loop at
"while (iova < end)" check in __arm_smmu_tlb_inv_range function.

This patch fixes the issue by doing the calculation correctly.

Fixes: 2f7e8c553e98 ("iommu/arm-smmu-v3: Hook up ATC invalidation to mm ops")
Cc: stable@vger.kernel.org
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Link: https://lore.kernel.org/r/20220419210158.21320-1-nicolinc@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -183,7 +183,14 @@ static void arm_smmu_mm_invalidate_range
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
-	size_t size = end - start + 1;
+	size_t size;
+
+	/*
+	 * The mm_types defines vm_end as the first byte after the end address,
+	 * different from IOMMU subsystem using the last address of an address
+	 * range. So do a simple translation here by calculating size correctly.
+	 */
+	size = end - start;
 
 	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_BTM))
 		arm_smmu_tlb_inv_range_asid(start, size, smmu_mn->cd->asid,


