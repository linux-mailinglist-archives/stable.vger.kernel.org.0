Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFBA40DAA9
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 15:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239770AbhIPNHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 09:07:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239495AbhIPNHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 09:07:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FCF460F48;
        Thu, 16 Sep 2021 13:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631797580;
        bh=Bz4ftTzAOiZzNBnhKawQylPLLT7A6C5JcxbTdEQb8AI=;
        h=Subject:To:Cc:From:Date:From;
        b=Tapijix35qEISpUBgiLvKo6bM9NxKCQcr+NTrfsB6e1caalzPq51DpmcnR+16Cyu3
         WaqNoMvPWr8o83s5g29pDBEwVdqxX93EtqtxS6cjrf2uHX3XbmnnTUqdEDocCleIUK
         9vIyaqEjKAYvYWPi2S/fuJHEBPI9JizlbLLb2dMA=
Subject: FAILED: patch "[PATCH] drm/amdgpu: use the preferred pin domain after the check" failed to apply to 5.14-stable tree
To:     christian.koenig@amd.com, Shashank.sharma@amd.com,
        alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Sep 2021 15:06:17 +0200
Message-ID: <16317975776511@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9deb0b3dcf13e573d54bec8498f044da9780f4e2 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Date: Wed, 18 Aug 2021 14:05:28 +0200
Subject: [PATCH] drm/amdgpu: use the preferred pin domain after the check
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

For some reason we run into an use case where a BO is already pinned
into GTT, but should be pinned into VRAM|GTT again.

Handle that case gracefully as well.

Reviewed-by: Shashank Sharma <Shashank.sharma@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index d15eee98204d..7734c10ae74e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -920,11 +920,6 @@ int amdgpu_bo_pin_restricted(struct amdgpu_bo *bo, u32 domain,
 			return -EINVAL;
 	}
 
-	/* This assumes only APU display buffers are pinned with (VRAM|GTT).
-	 * See function amdgpu_display_supported_domains()
-	 */
-	domain = amdgpu_bo_get_preferred_pin_domain(adev, domain);
-
 	if (bo->tbo.pin_count) {
 		uint32_t mem_type = bo->tbo.resource->mem_type;
 		uint32_t mem_flags = bo->tbo.resource->placement;
@@ -949,6 +944,11 @@ int amdgpu_bo_pin_restricted(struct amdgpu_bo *bo, u32 domain,
 		return 0;
 	}
 
+	/* This assumes only APU display buffers are pinned with (VRAM|GTT).
+	 * See function amdgpu_display_supported_domains()
+	 */
+	domain = amdgpu_bo_get_preferred_pin_domain(adev, domain);
+
 	if (bo->tbo.base.import_attach)
 		dma_buf_pin(bo->tbo.base.import_attach);
 

