Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFBD283B0A
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgJEPjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727173AbgJEP3w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43EEB207BC;
        Mon,  5 Oct 2020 15:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911791;
        bh=HAB3dK+OxcDD+n9S9n5H0BXgQQKbtd3f1J+WywRwN2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhPvqnUTuv3dOaMPIo+BJscBXvShj0HOQCY6m4cEE4Ga2nuxm/w/EIGS1kJ6SXTtf
         HyhQOokrB1Wi5qk5+dARg/RbeFt2LwSJi94996PoESzX4McWQhLBhAb7FZqRrnh1Dj
         9NpLBQCyz/2+ZbkTPM9FpWCnAJ3JJocpvDBikPyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 39/57] iommu/exynos: add missing put_device() call in exynos_iommu_of_xlate()
Date:   Mon,  5 Oct 2020 17:26:51 +0200
Message-Id: <20201005142111.688665149@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 1a26044954a6d1f4d375d5e62392446af663be7a ]

if of_find_device_by_node() succeed, exynos_iommu_of_xlate() doesn't have
a corresponding put_device(). Thus add put_device() to fix the exception
handling for this function implementation.

Fixes: aa759fd376fb ("iommu/exynos: Add callback for initializing devices from device tree")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20200918011335.909141-1-yukuai3@huawei.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/exynos-iommu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 9c94e16fb1277..55ed857f804f7 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1299,13 +1299,17 @@ static int exynos_iommu_of_xlate(struct device *dev,
 		return -ENODEV;
 
 	data = platform_get_drvdata(sysmmu);
-	if (!data)
+	if (!data) {
+		put_device(&sysmmu->dev);
 		return -ENODEV;
+	}
 
 	if (!owner) {
 		owner = kzalloc(sizeof(*owner), GFP_KERNEL);
-		if (!owner)
+		if (!owner) {
+			put_device(&sysmmu->dev);
 			return -ENOMEM;
+		}
 
 		INIT_LIST_HEAD(&owner->controllers);
 		mutex_init(&owner->rpm_lock);
-- 
2.25.1



