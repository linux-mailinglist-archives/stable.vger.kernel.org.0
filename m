Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4FB3F3612
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 23:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240950AbhHTVc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 17:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240955AbhHTVcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 17:32:25 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417ECC061757;
        Fri, 20 Aug 2021 14:31:47 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPv6:2600:8800:8c06:1000::c8f3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: alyssa)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 65D5D1F44A90;
        Fri, 20 Aug 2021 22:31:43 +0100 (BST)
From:   Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
To:     dri-devel@lists.freedesktop.org
Cc:     Rob Herring <robh@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        Chris Morgan <macromorgan@hotmail.com>, stable@vger.kernel.org
Subject: [PATCH 3/3] drm/panfrost: Clamp lock region to Bifrost minimum
Date:   Fri, 20 Aug 2021 17:31:17 -0400
Message-Id: <20210820213117.13050-4-alyssa.rosenzweig@collabora.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210820213117.13050-1-alyssa.rosenzweig@collabora.com>
References: <20210820213117.13050-1-alyssa.rosenzweig@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When locking a region, we currently clamp to a PAGE_SIZE as the minimum
lock region. While this is valid for Midgard, it is invalid for Bifrost,
where the minimum locking size is 8x larger than the 4k page size. Add a
hardware definition for the minimum lock region size (corresponding to
KBASE_LOCK_REGION_MIN_SIZE_LOG2 in kbase) and respect it.

Signed-off-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Tested-by: Chris Morgan <macromorgan@hotmail.com>
Cc: <stable@vger.kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c  | 2 +-
 drivers/gpu/drm/panfrost/panfrost_regs.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index 3a795273e505..dfe5f1d29763 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -66,7 +66,7 @@ static void lock_region(struct panfrost_device *pfdev, u32 as_nr,
 	/* The size is encoded as ceil(log2) minus(1), which may be calculated
 	 * with fls. The size must be clamped to hardware bounds.
 	 */
-	size = max_t(u64, size, PAGE_SIZE);
+	size = max_t(u64, size, AS_LOCK_REGION_MIN_SIZE);
 	region_width = fls64(size - 1) - 1;
 	region |= region_width;
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_regs.h b/drivers/gpu/drm/panfrost/panfrost_regs.h
index 1940ff86e49a..6c5a11ef1ee8 100644
--- a/drivers/gpu/drm/panfrost/panfrost_regs.h
+++ b/drivers/gpu/drm/panfrost/panfrost_regs.h
@@ -316,6 +316,8 @@
 #define AS_FAULTSTATUS_ACCESS_TYPE_READ		(0x2 << 8)
 #define AS_FAULTSTATUS_ACCESS_TYPE_WRITE	(0x3 << 8)
 
+#define AS_LOCK_REGION_MIN_SIZE                 (1ULL << 15)
+
 #define gpu_write(dev, reg, data) writel(data, dev->iomem + reg)
 #define gpu_read(dev, reg) readl(dev->iomem + reg)
 
-- 
2.30.2

