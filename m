Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9F46358EE
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235433AbiKWKFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236131AbiKWKEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:04:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB9311449C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:55:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5C5F4CE20F1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8DAC433D6;
        Wed, 23 Nov 2022 09:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197345;
        bh=tyAEXhWApP7/Lzvpy3qUsl/3ZRXi/aXzjW7On/nmbVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwiANz+UwGOmxXvG/p6x0EqUTI0nuh07GxR9lZodPPUegdXvBfMJu4NpKDT+Xd97K
         6N4UpJAXh+vM1XWGsEaE3VyKe4YD30neljmoGRFBO4a1O/q7Y4lBwd7frqcUHQOqmz
         TXPnojL8jlY1NLY1+7Ndk+vyhIMYudMUDXM/xWdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.0 266/314] iommu/vt-d: Preset Access bit for IOVA in FL non-leaf paging entries
Date:   Wed, 23 Nov 2022 09:51:51 +0100
Message-Id: <20221123084637.582663833@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tina Zhang <tina.zhang@intel.com>

commit 242b0aaeabbe2efbef1b9d42a8e56627e800964c upstream.

The A/D bits are preseted for IOVA over first level(FL) usage for both
kernel DMA (i.e, domain typs is IOMMU_DOMAIN_DMA) and user space DMA
usage (i.e., domain type is IOMMU_DOMAIN_UNMANAGED).

Presetting A bit in FL requires to preset the bit in every related paging
entries, including the non-leaf ones. Otherwise, hardware may treat this
as an error. For example, in a case of ECAP_REG.SMPWC==0, DMA faults might
occur with below DMAR fault messages (wrapped for line length) dumped.

 DMAR: DRHD: handling fault status reg 2
 DMAR: [DMA Read NO_PASID] Request device [aa:00.0] fault addr 0x10c3a6000
    [fault reason 0x90]
    SM: A/D bit update needed in first-level entry when set up in no snoop

Fixes: 289b3b005cb9 ("iommu/vt-d: Preset A/D bits for user space DMA usage")
Cc: stable@vger.kernel.org
Signed-off-by: Tina Zhang <tina.zhang@intel.com>
Link: https://lore.kernel.org/r/20221113010324.1094483-1-tina.zhang@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20221116051544.26540-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -954,11 +954,9 @@ static struct dma_pte *pfn_to_dma_pte(st
 
 			domain_flush_cache(domain, tmp_page, VTD_PAGE_SIZE);
 			pteval = ((uint64_t)virt_to_dma_pfn(tmp_page) << VTD_PAGE_SHIFT) | DMA_PTE_READ | DMA_PTE_WRITE;
-			if (domain_use_first_level(domain)) {
-				pteval |= DMA_FL_PTE_XD | DMA_FL_PTE_US;
-				if (iommu_is_dma_domain(&domain->domain))
-					pteval |= DMA_FL_PTE_ACCESS;
-			}
+			if (domain_use_first_level(domain))
+				pteval |= DMA_FL_PTE_XD | DMA_FL_PTE_US | DMA_FL_PTE_ACCESS;
+
 			if (cmpxchg64(&pte->val, 0ULL, pteval))
 				/* Someone else set it while we were thinking; use theirs. */
 				free_pgtable_page(tmp_page);


