Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C764FD073
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbiDLGrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351640AbiDLGp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:45:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0567C3B3DB;
        Mon, 11 Apr 2022 23:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 953ED61890;
        Tue, 12 Apr 2022 06:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86E9C385A8;
        Tue, 12 Apr 2022 06:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745536;
        bh=/yuEIPbt33KJon35HqzIrY/FhQnhpTOQIOvcSepHF9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03mM0dPqf78K7JQH3GqUlphvLGqh7Mee1CRJ7wc81ktkSmTIeVjg7VS+pNG/FQdsc
         39a1OfAtIgoklcKejYl20LnoguwhuS/EKuIdJ7Ym6e0JfRU2Aap7B+BLmmN4nPgzJ7
         NOh9QS83Sym2D0Ba2SOWdFNMv2eqiwQaGZpYKGXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Drew Fustini <dfustini@baylibre.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Suman Anna <s-anna@ti.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Tony Lindgren <tony@atomide.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/171] iommu/omap: Fix regression in probe for NULL pointer dereference
Date:   Tue, 12 Apr 2022 08:30:21 +0200
Message-Id: <20220412062931.646939080@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 71ff461c3f41f6465434b9e980c01782763e7ad8 ]

Commit 3f6634d997db ("iommu: Use right way to retrieve iommu_ops") started
triggering a NULL pointer dereference for some omap variants:

__iommu_probe_device from probe_iommu_group+0x2c/0x38
probe_iommu_group from bus_for_each_dev+0x74/0xbc
bus_for_each_dev from bus_iommu_probe+0x34/0x2e8
bus_iommu_probe from bus_set_iommu+0x80/0xc8
bus_set_iommu from omap_iommu_init+0x88/0xcc
omap_iommu_init from do_one_initcall+0x44/0x24

This is caused by omap iommu probe returning 0 instead of ERR_PTR(-ENODEV)
as noted by Jason Gunthorpe <jgg@ziepe.ca>.

Looks like the regression already happened with an earlier commit
6785eb9105e3 ("iommu/omap: Convert to probe/release_device() call-backs")
that changed the function return type and missed converting one place.

Cc: Drew Fustini <dfustini@baylibre.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Suman Anna <s-anna@ti.com>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Fixes: 6785eb9105e3 ("iommu/omap: Convert to probe/release_device() call-backs")
Fixes: 3f6634d997db ("iommu: Use right way to retrieve iommu_ops")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Tested-by: Drew Fustini <dfustini@baylibre.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20220331062301.24269-1-tony@atomide.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/omap-iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 71f29c0927fc..ff2c692c0db4 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1665,7 +1665,7 @@ static struct iommu_device *omap_iommu_probe_device(struct device *dev)
 	num_iommus = of_property_count_elems_of_size(dev->of_node, "iommus",
 						     sizeof(phandle));
 	if (num_iommus < 0)
-		return 0;
+		return ERR_PTR(-ENODEV);
 
 	arch_data = kcalloc(num_iommus + 1, sizeof(*arch_data), GFP_KERNEL);
 	if (!arch_data)
-- 
2.35.1



