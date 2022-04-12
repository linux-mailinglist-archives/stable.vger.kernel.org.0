Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAAC4FD7A5
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377328AbiDLHtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358703AbiDLHmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5F353B62;
        Tue, 12 Apr 2022 00:18:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF24A6171C;
        Tue, 12 Apr 2022 07:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E078CC385A1;
        Tue, 12 Apr 2022 07:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747932;
        bh=OlZDwkLIrhSfs14hQ3b6bvoPaxN1iOD12TvNEMCVr08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MiDp91WUTsXho3Y0Am6kBht2GngfCEsGpGAvgD8WEnkY+BnXMvGDXxopr3s55ZkMP
         Gxu1sdbuXKdXtIDPu+FMiDkLxV1rctfBsTb/1LgXaFFHEyKr7UPwTq51ZbLokEzq0P
         QDEEUJ2my9/A/pogA46yQsSedldwt3X2Y9Gc/7mE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Drew Fustini <dfustini@baylibre.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Suman Anna <s-anna@ti.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Tony Lindgren <tony@atomide.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 258/343] iommu/omap: Fix regression in probe for NULL pointer dereference
Date:   Tue, 12 Apr 2022 08:31:16 +0200
Message-Id: <20220412062958.773402653@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
index 980e4af3f06b..d2e82a1b56d8 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1661,7 +1661,7 @@ static struct iommu_device *omap_iommu_probe_device(struct device *dev)
 	num_iommus = of_property_count_elems_of_size(dev->of_node, "iommus",
 						     sizeof(phandle));
 	if (num_iommus < 0)
-		return 0;
+		return ERR_PTR(-ENODEV);
 
 	arch_data = kcalloc(num_iommus + 1, sizeof(*arch_data), GFP_KERNEL);
 	if (!arch_data)
-- 
2.35.1



