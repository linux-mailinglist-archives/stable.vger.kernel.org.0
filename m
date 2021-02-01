Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116F130A33B
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 09:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhBAIWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 03:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbhBAIWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 03:22:03 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660E5C06174A
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 00:21:23 -0800 (PST)
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 659601F44855;
        Mon,  1 Feb 2021 08:21:20 +0000 (GMT)
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     dri-devel@lists.freedesktop.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] drm/panfrost: Don't try to map pages that are already mapped
Date:   Mon,  1 Feb 2021 09:21:15 +0100
Message-Id: <20210201082116.267208-3-boris.brezillon@collabora.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210201082116.267208-1-boris.brezillon@collabora.com>
References: <20210201082116.267208-1-boris.brezillon@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We allocate 2MB chunks at a time, so it might appear that a page fault
has already been handled by a previous page fault when we reach
panfrost_mmu_map_fault_addr(). Bail out in that case to avoid mapping the
same area twice.

Cc: <stable@vger.kernel.org>
Fixes: 187d2929206e ("drm/panfrost: Add support for GPU heap allocations")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index 904d63450862..21e552d1ac71 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -488,8 +488,14 @@ static int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as,
 		}
 		bo->base.pages = pages;
 		bo->base.pages_use_count = 1;
-	} else
+	} else {
 		pages = bo->base.pages;
+		if (pages[page_offset]) {
+			/* Pages are already mapped, bail out. */
+			mutex_unlock(&bo->base.pages_lock);
+			goto out;
+		}
+	}
 
 	mapping = bo->base.base.filp->f_mapping;
 	mapping_set_unevictable(mapping);
@@ -522,6 +528,7 @@ static int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as,
 
 	dev_dbg(pfdev->dev, "mapped page fault @ AS%d %llx", as, addr);
 
+out:
 	panfrost_gem_mapping_put(bomapping);
 
 	return 0;
-- 
2.26.2

