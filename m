Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9400B30A33A
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 09:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbhBAIWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 03:22:05 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58832 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbhBAIWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 03:22:02 -0500
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 19AD61F44850;
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
Subject: [PATCH 1/3] drm/panfrost: Clear MMU irqs before handling the fault
Date:   Mon,  1 Feb 2021 09:21:14 +0100
Message-Id: <20210201082116.267208-2-boris.brezillon@collabora.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210201082116.267208-1-boris.brezillon@collabora.com>
References: <20210201082116.267208-1-boris.brezillon@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When a fault is handled it will unblock the GPU which will continue
executing its shader and might fault almost immediately on a different
page. If we clear interrupts after handling the fault we might miss new
faults, so clear them before.

Cc: <stable@vger.kernel.org>
Fixes: 187d2929206e ("drm/panfrost: Add support for GPU heap allocations")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index 7c1b3481b785..904d63450862 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -593,6 +593,8 @@ static irqreturn_t panfrost_mmu_irq_handler_thread(int irq, void *data)
 		access_type = (fault_status >> 8) & 0x3;
 		source_id = (fault_status >> 16);
 
+		mmu_write(pfdev, MMU_INT_CLEAR, mask);
+
 		/* Page fault only */
 		ret = -1;
 		if ((status & mask) == BIT(i) && (exception_type & 0xF8) == 0xC0)
@@ -616,8 +618,6 @@ static irqreturn_t panfrost_mmu_irq_handler_thread(int irq, void *data)
 				access_type, access_type_name(pfdev, fault_status),
 				source_id);
 
-		mmu_write(pfdev, MMU_INT_CLEAR, mask);
-
 		status &= ~mask;
 	}
 
-- 
2.26.2

