Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A50601E30
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiJRAIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiJRAH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:07:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CC0870A5;
        Mon, 17 Oct 2022 17:07:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEF70612B4;
        Tue, 18 Oct 2022 00:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DB4C43150;
        Tue, 18 Oct 2022 00:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051666;
        bh=Wz6/W8ffwyEXEVYVufTDi1EST1b5dNnFzBabgt1Ya6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLOcfX3i4etGzwairs9wxsmA9p0A2AlVTJd+gt4RXlZfZEMrfE1FxY2QGyOFgffCG
         xkHBPLlMA8pD7NBNF9d148mmbspF0xcEOPlVHxUhIw53b5hTKcZFaiIQrOK7AWBjvA
         TAf2/sUl+yQqBbF8z+DSyE2pQsjkmf6VHMAJRBiqQr8xsu0gGuZaJvELpF/oc9f4Ly
         4xJXXRrwNtelVluBfZz8CeInqmiBzuQlXhWDh5omdfWQRTqmzK/YMNsnMQx2hCwR/H
         uog8cF+Jaa5UXsxpkdFFx9Dil4YDUoSYfm7nDhjP4cye0ffuq6lZmVbn/3WkMvhBlW
         eFtV5p48BYJHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>, dwmw2@infradead.org,
        baolu.lu@linux.intel.com, joro@8bytes.org, will@kernel.org,
        iommu@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 07/32] iommu/vt-d: Handle race between registration and device probe
Date:   Mon, 17 Oct 2022 20:07:04 -0400
Message-Id: <20221018000729.2730519-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000729.2730519-1-sashal@kernel.org>
References: <20221018000729.2730519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit c919739ce4721ecf7b96b99253b032df30fcf19b ]

Currently we rely on registering all our instances before initially
allowing any .probe_device calls via bus_set_iommu(). In preparation for
phasing out the latter, make sure we won't inadvertently return success
for a device associated with a known but not yet registered instance,
otherwise we'll run straight into iommu_group_get_for_dev() trying to
use NULL ops.

That also highlights an issue with intel_iommu_get_resv_regions() taking
dmar_global_lock from within a section where intel_iommu_init() already
holds it, which already exists via probe_acpi_namespace_devices() when
an ANDD device is probed, but gets more obvious with the upcoming change
to iommu_device_register(). Since they are both read locks it manages
not to deadlock in practice, and a more in-depth rework of this locking
is underway, so no attempt is made to address it here.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/579f2692291bcbfc3ac64f7456fcff0d629af131.1660572783.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 31bc50e538a3..ed63386b9b60 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4457,7 +4457,7 @@ static struct iommu_device *intel_iommu_probe_device(struct device *dev)
 	u8 bus, devfn;
 
 	iommu = device_to_iommu(dev, &bus, &devfn);
-	if (!iommu)
+	if (!iommu || !iommu->iommu.ops)
 		return ERR_PTR(-ENODEV);
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
-- 
2.35.1

