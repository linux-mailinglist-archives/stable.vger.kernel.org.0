Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 317059A12B
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 22:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732323AbfHVUcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 16:32:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43602 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731831AbfHVUcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 16:32:14 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F10BA30BDE39;
        Thu, 22 Aug 2019 20:32:11 +0000 (UTC)
Received: from malachite.bss.redhat.com (dhcp-10-20-1-11.bss.redhat.com [10.20.1.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22E8C2B1CC;
        Thu, 22 Aug 2019 20:31:39 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] drm/i915: Call dma_set_max_seg_size() in i915_ggtt_probe_hw()
Date:   Thu, 22 Aug 2019 16:31:26 -0400
Message-Id: <20190822203127.24648-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 22 Aug 2019 20:32:14 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, we don't call dma_set_max_seg_size() for i915 because we
intentionally do not limit the segment length that the device supports.
However, this results in a warning being emitted if we try to map
anything larger than SZ_64K on a kernel with CONFIG_DMA_API_DEBUG_SG
enabled:

[    7.751926] DMA-API: i915 0000:00:02.0: mapping sg segment longer
than device claims to support [len=98304] [max=65536]
[    7.751934] WARNING: CPU: 5 PID: 474 at kernel/dma/debug.c:1220
debug_dma_map_sg+0x20f/0x340

This was originally brought up on
https://bugs.freedesktop.org/show_bug.cgi?id=108517 , and the consensus
there was it wasn't really useful to set a limit (and that dma-debug
isn't really all that useful for i915 in the first place). Unfortunately
though, CONFIG_DMA_API_DEBUG_SG is enabled in the debug configs for
various distro kernels. Since a WARN_ON() will disable automatic problem
reporting (and cause any CI with said option enabled to start
complaining), we really should just fix the problem.

Note that as me and Chris Wilson discussed, the other solution for this
would be to make DMA-API not make such assumptions when a driver hasn't
explicitly set a maximum segment size. But, taking a look at the commit
which originally introduced this behavior, commit 78c47830a5cb
("dma-debug: check scatterlist segments"), there is an explicit mention
of this assumption and how it applies to devices with no segment size:

	Conversely, devices which are less limited than the rather
	conservative defaults, or indeed have no limitations at all
	(e.g. GPUs with their own internal MMU), should be encouraged to
	set appropriate dma_parms, as they may get more efficient DMA
	mapping performance out of it.

So unless there's any concerns (I'm open to discussion!), let's just
follow suite and call dma_set_max_seg_size() with UINT_MAX as our limit
to silence any warnings.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v4.18+
---
 drivers/gpu/drm/i915/i915_gem_gtt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
index 0b81e0b64393..a1475039d182 100644
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -3152,6 +3152,11 @@ static int ggtt_probe_hw(struct i915_ggtt *ggtt, struct intel_gt *gt)
 	if (ret)
 		return ret;
 
+	/* We don't have a max segment size, so set it to the max so sg's
+	 * debugging layer doesn't complain
+	 */
+	dma_set_max_seg_size(ggtt->vm.dma, UINT_MAX);
+
 	if ((ggtt->vm.total - 1) >> 32) {
 		DRM_ERROR("We never expected a Global GTT with more than 32bits"
 			  " of address space! Found %lldM!\n",
-- 
2.21.0

