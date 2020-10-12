Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6179A28BA51
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbgJLOIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389225AbgJLNeV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:34:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19526215A4;
        Mon, 12 Oct 2020 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509621;
        bh=Sk17WUeJFmvZw7vGnTJ9gGzFZbhHP9bVX7SaI9iXvtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oS4qntBhQ1NtJpuCqQlNmEhjcLba1R7/n74qAffhN028DuY216nu0+osgQ6kFYLlJ
         7YtZDzX2N03Rd+l17kI+YOG8Q3ALtT4SsY/5mLwFCm2b9bymuV9Lh9SDKYRVx/Dyxi
         qwOQeqeI9QBP4PBgogdVN2jZUDFYkZTL03WG/G7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 14/54] iommu/exynos: add missing put_device() call in exynos_iommu_of_xlate()
Date:   Mon, 12 Oct 2020 15:26:36 +0200
Message-Id: <20201012132630.252717421@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
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
index beef59eb94fa7..626b434e7967a 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1265,13 +1265,17 @@ static int exynos_iommu_of_xlate(struct device *dev,
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
 		dev->archdata.iommu = owner;
-- 
2.25.1



