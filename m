Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 715C227019
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 22:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbfEVTW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730460AbfEVTWZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:22:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 267E420644;
        Wed, 22 May 2019 19:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552944;
        bh=t5xengB7nNuo2KSH7Jj1ZxDwNMwXO7ggXnUm8qMUaWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P86AuJrAyjGNPkCOo5wvqwhZCddKJtLeF3xXWVWnTsWZlQGkuIJM2xcZVJUsdiiGL
         /N2gIyqbGJuLCMxAs1JvixgpszUZIPMNWXPUFPofQbtQ45s3779XRFrxFWoR1tZ7H/
         5KdmBoKt3JXwoygfa0Fqxo+ZFFv8FqV6tJnWnY7A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Derrick <jonathan.derrick@intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 043/375] drm/nouveau/bar/nv50: ensure BAR is mapped
Date:   Wed, 22 May 2019 15:15:43 -0400
Message-Id: <20190522192115.22666-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

[ Upstream commit f10b83de1fd49216a4c657816f48001437e4bdd5 ]

If the BAR is zero size, it indicates it was never successfully mapped.
Ensure that the BAR is valid during initialization before attempting to
use it.

Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c b/drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c
index 157b076a12723..38c9c086754b6 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c
@@ -109,7 +109,7 @@ nv50_bar_oneinit(struct nvkm_bar *base)
 	struct nvkm_device *device = bar->base.subdev.device;
 	static struct lock_class_key bar1_lock;
 	static struct lock_class_key bar2_lock;
-	u64 start, limit;
+	u64 start, limit, size;
 	int ret;
 
 	ret = nvkm_gpuobj_new(device, 0x20000, 0, false, NULL, &bar->mem);
@@ -127,7 +127,10 @@ nv50_bar_oneinit(struct nvkm_bar *base)
 
 	/* BAR2 */
 	start = 0x0100000000ULL;
-	limit = start + device->func->resource_size(device, 3);
+	size = device->func->resource_size(device, 3);
+	if (!size)
+		return -ENOMEM;
+	limit = start + size;
 
 	ret = nvkm_vmm_new(device, start, limit-- - start, NULL, 0,
 			   &bar2_lock, "bar2", &bar->bar2_vmm);
@@ -164,7 +167,10 @@ nv50_bar_oneinit(struct nvkm_bar *base)
 
 	/* BAR1 */
 	start = 0x0000000000ULL;
-	limit = start + device->func->resource_size(device, 1);
+	size = device->func->resource_size(device, 1);
+	if (!size)
+		return -ENOMEM;
+	limit = start + size;
 
 	ret = nvkm_vmm_new(device, start, limit-- - start, NULL, 0,
 			   &bar1_lock, "bar1", &bar->bar1_vmm);
-- 
2.20.1

