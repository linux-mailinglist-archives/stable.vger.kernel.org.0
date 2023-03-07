Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4631B6AEB2C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjCGRk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbjCGRki (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:40:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACF294A77
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:36:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7707F6150D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE18C433EF;
        Tue,  7 Mar 2023 17:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210606;
        bh=xLaW9MhnaabbtCXhChoRpKpVK5Vxj2sMJJtHHD3Bago=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJGfl9Iv8gtJ0ps+1LBSdp/EIMMZ65kx5ZfIiFLWhkmjrNODlZapk2qmT4Q2EmuMa
         uzMIMuWYt8xancbXG9wXjRD53cLjASbkJQuArOwkeHeA0EYo5FuzD/QuVcBaTOYLJZ
         tlvBxpZosakCSTOeMlHDgON9RHS56oZJaVFzqocY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0564/1001] iommu/amd: Do not identity map v2 capable device when snp is enabled
Date:   Tue,  7 Mar 2023 17:55:36 +0100
Message-Id: <20230307170045.948964158@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 18792e99ea2fea27c72eb1ecca1879e5e6be304d ]

Flow:
  - Booted system with SNP enabled, memory encryption off and
    IOMMU DMA translation mode
  - AMD driver detects v2 capable device and amd_iommu_def_domain_type()
    returns identity mode
  - amd_iommu_domain_alloc() returns NULL an SNP is enabled
  - System will fail to register device

On SNP enabled system, passthrough mode is not supported. IOMMU default
domain is set to translation mode. We need to return zero from
amd_iommu_def_domain_type() so that it allocates translation domain.

Fixes: fb2accadaa94 ("iommu/amd: Introduce function to check and enable SNP")
CC: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/20230207091752.7656-1-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 9dc41c48c29d6..ff4f3d4da3402 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2405,12 +2405,17 @@ static int amd_iommu_def_domain_type(struct device *dev)
 		return 0;
 
 	/*
-	 * Do not identity map IOMMUv2 capable devices when memory encryption is
-	 * active, because some of those devices (AMD GPUs) don't have the
-	 * encryption bit in their DMA-mask and require remapping.
+	 * Do not identity map IOMMUv2 capable devices when:
+	 *  - memory encryption is active, because some of those devices
+	 *    (AMD GPUs) don't have the encryption bit in their DMA-mask
+	 *    and require remapping.
+	 *  - SNP is enabled, because it prohibits DTE[Mode]=0.
 	 */
-	if (!cc_platform_has(CC_ATTR_MEM_ENCRYPT) && dev_data->iommu_v2)
+	if (dev_data->iommu_v2 &&
+	    !cc_platform_has(CC_ATTR_MEM_ENCRYPT) &&
+	    !amd_iommu_snp_en) {
 		return IOMMU_DOMAIN_IDENTITY;
+	}
 
 	return 0;
 }
-- 
2.39.2



