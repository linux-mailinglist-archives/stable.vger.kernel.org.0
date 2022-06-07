Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26463541572
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239125AbiFGUgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377770AbiFGUeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:34:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A26F1E73D5;
        Tue,  7 Jun 2022 11:35:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70A78612F2;
        Tue,  7 Jun 2022 18:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFFAC385A2;
        Tue,  7 Jun 2022 18:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626958;
        bh=+K1lCRNxqNUDo7RhKYAXGxU/yjFx0irCjRgVthz9R/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCLK0uZWMYpUpg5H1uQUKsKu072676cw3Vd7WdkubzyP7uDpZt/NU46qLVYkr2pHU
         ++RMdd8SCQjpFW0VFTICRp25FY5TR6Vv3YFUSqd6m6VLARFZ0dxzGyZ0+nHcAPvirP
         k5IJ68wBMQMTH7dNA6akH5q5THUprGQF+qx8fB5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 567/772] iommu/amd: Enable swiotlb in all cases
Date:   Tue,  7 Jun 2022 19:02:39 +0200
Message-Id: <20220607165005.662800332@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 121660bba631104154b7c15e88f208c48c8c3297 ]

Previously the AMD IOMMU would only enable SWIOTLB in certain
circumstances:
 * IOMMU in passthrough mode
 * SME enabled

This logic however doesn't work when an untrusted device is plugged in
that doesn't do page aligned DMA transactions.  The expectation is
that a bounce buffer is used for those transactions.

This fails like this:

swiotlb buffer is full (sz: 4096 bytes), total 0 (slots), used 0 (slots)

That happens because the bounce buffers have been allocated, followed by
freed during startup but the bounce buffering code expects that all IOMMUs
have left it enabled.

Remove the criteria to set up bounce buffers on AMD systems to ensure
they're always available for supporting untrusted devices.

Fixes: 82612d66d51d ("iommu: Allow the dma-iommu api to use bounce buffers")
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220404204723.9767-2-mario.limonciello@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a18b549951bb..74c4ae85e41e 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1838,17 +1838,10 @@ void amd_iommu_domain_update(struct protection_domain *domain)
 	amd_iommu_domain_flush_complete(domain);
 }
 
-static void __init amd_iommu_init_dma_ops(void)
-{
-	swiotlb = (iommu_default_passthrough() || sme_me_mask) ? 1 : 0;
-}
-
 int __init amd_iommu_init_api(void)
 {
 	int err;
 
-	amd_iommu_init_dma_ops();
-
 	err = bus_set_iommu(&pci_bus_type, &amd_iommu_ops);
 	if (err)
 		return err;
-- 
2.35.1



