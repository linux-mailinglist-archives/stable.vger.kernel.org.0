Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2537A1AED0A
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 15:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgDRNtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 09:49:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgDRNtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 09:49:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 165A92224E;
        Sat, 18 Apr 2020 13:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587217757;
        bh=VyeAYrSuj5Nu9IZdaUdo5Y5eQ7ucFMmf8JRnu3917n8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LhmnsGoViz2uWAloF47qt3HIV1Tuzk1GvxwY6Gio9bGHQ67KIRgTcabVLUPW4QgLM
         zcbSSlaZr3GBTelbwbnlpb5mSIL2wrAyWkdwt3O8DODymsDo30ctqZ9pgdecrrwgB4
         Id74zt0qkzqYzOwQSo6XY2nub8USDC6IMgHCECKw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.6 48/73] iommu/virtio: Fix freeing of incomplete domains
Date:   Sat, 18 Apr 2020 09:47:50 -0400
Message-Id: <20200418134815.6519-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418134815.6519-1-sashal@kernel.org>
References: <20200418134815.6519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

[ Upstream commit 7062af3ed2ba451029e3733d9f677c68f5ea9e77 ]

Calling viommu_domain_free() on a domain that hasn't been finalised (not
attached to any device, for example) can currently cause an Oops,
because we attempt to call ida_free() on ID 0, which may either be
unallocated or used by another domain.

Only initialise the vdomain->viommu pointer, which denotes a finalised
domain, at the end of a successful viommu_domain_finalise().

Fixes: edcd69ab9a32 ("iommu: Add virtio-iommu driver")
Reported-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20200326093558.2641019-3-jean-philippe@linaro.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/virtio-iommu.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index cce329d71fbad..5eed75cd121f1 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -613,18 +613,20 @@ static int viommu_domain_finalise(struct viommu_dev *viommu,
 	int ret;
 	struct viommu_domain *vdomain = to_viommu_domain(domain);
 
-	vdomain->viommu		= viommu;
-	vdomain->map_flags	= viommu->map_flags;
+	ret = ida_alloc_range(&viommu->domain_ids, viommu->first_domain,
+			      viommu->last_domain, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+
+	vdomain->id		= (unsigned int)ret;
 
 	domain->pgsize_bitmap	= viommu->pgsize_bitmap;
 	domain->geometry	= viommu->geometry;
 
-	ret = ida_alloc_range(&viommu->domain_ids, viommu->first_domain,
-			      viommu->last_domain, GFP_KERNEL);
-	if (ret >= 0)
-		vdomain->id = (unsigned int)ret;
+	vdomain->map_flags	= viommu->map_flags;
+	vdomain->viommu		= viommu;
 
-	return ret > 0 ? 0 : ret;
+	return 0;
 }
 
 static void viommu_domain_free(struct iommu_domain *domain)
-- 
2.20.1

