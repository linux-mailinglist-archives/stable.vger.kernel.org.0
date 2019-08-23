Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 449359B7E9
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 22:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388903AbfHWUxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 16:53:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732398AbfHWUxE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Aug 2019 16:53:04 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1F18010F23E0;
        Fri, 23 Aug 2019 20:53:04 +0000 (UTC)
Received: from malachite.bss.redhat.com (dhcp-10-20-1-11.bss.redhat.com [10.20.1.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA1704A9;
        Fri, 23 Aug 2019 20:52:58 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4] drm/i915: Call dma_set_max_seg_size() in i915_driver_hw_probe()
Date:   Fri, 23 Aug 2019 16:52:51 -0400
Message-Id: <20190823205251.14298-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Fri, 23 Aug 2019 20:53:04 +0000 (UTC)
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

Changes since v3:
* Drop patch for enabling CONFIG_DMA_API_DEBUG_SG in CI. It looks like
  just turning it on causes the kernel to spit out bogus WARN_ONs()
  during some igt tests which would otherwise require teaching igt to
  disable the various DMA-API debugging options causing this. This is
  too much work to be worth it, since DMA-API debugging is useless for
  us. So, we'll just settle with this single patch to squelch WARN_ONs()
  during driver load for users that have CONFIG_DMA_API_DEBUG_SG turned
  on for some reason.
* Move dma_set_max_seg_size() call into i915_driver_hw_probe() - Chris
  Wilson

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v4.18+
---
 drivers/gpu/drm/i915/i915_drv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index b5b2a64753e6..020696726f9e 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -1279,6 +1279,12 @@ static int i915_driver_hw_probe(struct drm_i915_private *dev_priv)
 
 	pci_set_master(pdev);
 
+	/*
+	 * We don't have a max segment size, so set it to the max so sg's
+	 * debugging layer doesn't complain
+	 */
+	dma_set_max_seg_size(&pdev->dev, UINT_MAX);
+
 	/* overlay on gen2 is broken and can't address above 1G */
 	if (IS_GEN(dev_priv, 2)) {
 		ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(30));
-- 
2.21.0

