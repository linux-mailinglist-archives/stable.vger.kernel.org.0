Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4A7956C5
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 07:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbfHTFlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 01:41:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:25521 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728878AbfHTFlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 01:41:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 22:41:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,407,1559545200"; 
   d="scan'208";a="207243533"
Received: from test-optiplex-7040.bj.intel.com ([10.238.154.166])
  by fmsmga002.fm.intel.com with ESMTP; 19 Aug 2019 22:41:19 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org
Cc:     Xiong Zhang <xiong.y.zhang@intel.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] drm/i915: Don't deballoon unused ggtt drm_mm_node in linux guest
Date:   Tue, 20 Aug 2019 13:46:17 +0800
Message-Id: <1566279978-9659-1-git-send-email-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following call trace may exist in linux guest dmesg when guest i915
driver is unloaded.
[   90.776610] [drm:vgt_deballoon_space.isra.0 [i915]] deballoon space: range [0x0 - 0x0] 0 KiB.
[   90.776621] BUG: unable to handle kernel NULL pointer dereference at 00000000000000c0
[   90.776691] IP: drm_mm_remove_node+0x4d/0x320 [drm]
[   90.776718] PGD 800000012c7d0067 P4D 800000012c7d0067 PUD 138e4c067 PMD 0
[   90.777091] task: ffff9adab60f2f00 task.stack: ffffaf39c0fe0000
[   90.777142] RIP: 0010:drm_mm_remove_node+0x4d/0x320 [drm]
[   90.777573] Call Trace:
[   90.777653]  intel_vgt_deballoon+0x4c/0x60 [i915]
[   90.777729]  i915_ggtt_cleanup_hw+0x121/0x190 [i915]
[   90.777792]  i915_driver_unload+0x145/0x180 [i915]
[   90.777856]  i915_pci_remove+0x15/0x20 [i915]
[   90.777890]  pci_device_remove+0x3b/0xc0
[   90.777916]  device_release_driver_internal+0x157/0x220
[   90.777945]  driver_detach+0x39/0x70
[   90.777967]  bus_remove_driver+0x51/0xd0
[   90.777990]  pci_unregister_driver+0x23/0x90
[   90.778019]  SyS_delete_module+0x1da/0x240
[   90.778045]  entry_SYSCALL_64_fastpath+0x24/0x87
[   90.778072] RIP: 0033:0x7f34312af067
[   90.778092] RSP: 002b:00007ffdea3da0d8 EFLAGS: 00000206
[   90.778297] RIP: drm_mm_remove_node+0x4d/0x320 [drm] RSP: ffffaf39c0fe3dc0
[   90.778344] ---[ end trace f4b1bc8305fc59dd ]---

Four drm_mm_node are used to reserve guest ggtt space, but some of them
may be skipped and not initialised due to space constraints in
intel_vgt_balloon(). If drm_mm_remove_node() is called with
uninitialized drm_mm_node, the above call trace occurs.

This patch check drm_mm_node's validity before calling
drm_mm_remove_node().

Fixes: ff8f797557c7("drm/i915: return the correct usable aperture size under gvt environment")
Cc: stable@vger.kernel.org
Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 drivers/gpu/drm/i915/i915_vgpu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_vgpu.c b/drivers/gpu/drm/i915/i915_vgpu.c
index bf2b837..d2fd66f 100644
--- a/drivers/gpu/drm/i915/i915_vgpu.c
+++ b/drivers/gpu/drm/i915/i915_vgpu.c
@@ -119,6 +119,9 @@ static struct _balloon_info_ bl_info;
 static void vgt_deballoon_space(struct i915_ggtt *ggtt,
 				struct drm_mm_node *node)
 {
+	if (!node->allocated)
+		return;
+
 	DRM_DEBUG_DRIVER("deballoon space: range [0x%llx - 0x%llx] %llu KiB.\n",
 			 node->start,
 			 node->start + node->size,
-- 
2.7.4

