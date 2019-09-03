Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE45A6FC5
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbfICQe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730975AbfICQ1y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA5812343A;
        Tue,  3 Sep 2019 16:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528073;
        bh=zhVFKvgOVO0h6u6YsHm1erT5jr7By0XHYjeYvoOXFSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNHSb3NzwJeamYcfHj4IP9o14jvGmweINJmk5Nh4Uv13qCZox1BVC005DO9Q84Ehp
         qumff+XuQL2ytG1bn60/x7rmHCVVHeAnk69DH5WH2S6toVqEacwE7i4lckMyeD9nvk
         EOSBoGsSkDjnWaiTNCZJ62jF3Hn4PBxyqjNF9jfg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Adam Zabrocki <adamza@microsoft.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 087/167] drm/i915: Handle vm_mmap error during I915_GEM_MMAP ioctl with WC set
Date:   Tue,  3 Sep 2019 12:23:59 -0400
Message-Id: <20190903162519.7136-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

[ Upstream commit ebfb6977801da521d8d5d752d373a187e2a2b9b3 ]

Add err goto label and use it when VMA can't be established or changes
underneath.

v2:
- Dropping Fixes: as it's indeed impossible to race an object to the
  error address. (Chris)
v3:
- Use IS_ERR_VALUE (Chris)

Reported-by: Adam Zabrocki <adamza@microsoft.com>
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Adam Zabrocki <adamza@microsoft.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com> #v2
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20190207085454.10598-2-joonas.lahtinen@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_gem.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index e81abd468a15d..9634d3adb8d01 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1881,6 +1881,9 @@ i915_gem_mmap_ioctl(struct drm_device *dev, void *data,
 	addr = vm_mmap(obj->base.filp, 0, args->size,
 		       PROT_READ | PROT_WRITE, MAP_SHARED,
 		       args->offset);
+	if (IS_ERR_VALUE(addr))
+		goto err;
+
 	if (args->flags & I915_MMAP_WC) {
 		struct mm_struct *mm = current->mm;
 		struct vm_area_struct *vma;
@@ -1896,17 +1899,22 @@ i915_gem_mmap_ioctl(struct drm_device *dev, void *data,
 		else
 			addr = -ENOMEM;
 		up_write(&mm->mmap_sem);
+		if (IS_ERR_VALUE(addr))
+			goto err;
 
 		/* This may race, but that's ok, it only gets set */
 		WRITE_ONCE(obj->frontbuffer_ggtt_origin, ORIGIN_CPU);
 	}
 	i915_gem_object_put(obj);
-	if (IS_ERR((void *)addr))
-		return addr;
 
 	args->addr_ptr = (uint64_t) addr;
 
 	return 0;
+
+err:
+	i915_gem_object_put(obj);
+
+	return addr;
 }
 
 static unsigned int tile_row_pages(struct drm_i915_gem_object *obj)
-- 
2.20.1

