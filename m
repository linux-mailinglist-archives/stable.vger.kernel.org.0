Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825094E6BE6
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 02:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344473AbiCYBVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 21:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244604AbiCYBVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 21:21:17 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D9B366AE
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 18:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648171184; x=1679707184;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6Dtbe2t8Agnn46DxITZgYPQpiah6xy7Fzhkn08LE2P4=;
  b=n9a0ej9DRNY3Bc4Tx60gRWQ3W0DWWNhJPrMYPcyFvX+CwTx8MEhFk+PF
   sVKPmRoIHBYbAVlca1Z8rqsCWgfoY1/yNOu/1huYCaBtXmubbgOG9pVCs
   Wc6Y0X/WZX3iyg7SauIKAGCfvldH68jD3UE/pcyR3wpH5geYVZo8R3PEF
   1jchJDs6aDbJLaGcjBlYCmcI7bExXFsGkP/Ez02/vBuWjKDJ31OGUqMlE
   HiV7C3Rbl5boRJ+9qrAztghtw89PdaERnrZpDTcOemABDeQkBpOQz2ADp
   CUbf4QEduUWaTA4e8qvv2Zkf6OUvdmjOcFbgHwzudzWzfnKODI4x5tZMp
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10296"; a="321724820"
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="321724820"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2022 18:19:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="561626046"
Received: from cliu38-mobl3.sh.intel.com ([10.239.147.106])
  by orsmga008.jf.intel.com with ESMTP; 24 Mar 2022 18:19:42 -0700
From:   Chuansheng Liu <chuansheng.liu@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH v2] drm/i915: fix one mem leak in mmap_offset_attach()
Date:   Fri, 25 Mar 2022 09:03:28 +0800
Message-Id: <20220325010328.32963-1-chuansheng.liu@intel.com>
X-Mailer: git-send-email 2.25.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The below memory leak information is caught:

unreferenced object 0xffff997dd4e3b240 (size 64):
  comm "gem_tiled_fence", pid 10332, jiffies 4294959326 (age
220778.420s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 be f2 d4 7d 99 ff ff  ............}...
  backtrace:
    [<ffffffffa0f04365>] kmem_cache_alloc_trace+0x2e5/0x450
    [<ffffffffc062f3ac>] drm_vma_node_allow+0x2c/0xe0 [drm]
    [<ffffffffc13149ea>] __assign_mmap_offset_handle+0x1da/0x4a0 [i915]
    [<ffffffffc1315235>] i915_gem_mmap_offset_ioctl+0x55/0xb0 [i915]
    [<ffffffffc06207e4>] drm_ioctl_kernel+0xb4/0x140 [drm]
    [<ffffffffc0620ac7>] drm_ioctl+0x257/0x410 [drm]
    [<ffffffffa0f553ae>] __x64_sys_ioctl+0x8e/0xc0
    [<ffffffffa1821128>] do_syscall_64+0x38/0xc0
[<ffffffffa1a0007c>] entry_SYSCALL_64_after_hwframe+0x44/0xae

The issue is always reproduced with the test:
gem_tiled_fence_blits --run-subtest basic

It tries to mmap_gtt the same object several times, it is like:
create BO
mmap_gtt BO
unmap BO
mmap_gtt BO <== second time mmap_gtt
unmap
close BO

The leak happens at the second time mmap_gtt in function
mmap_offset_attach(),it will simply increase the reference
count to 2 by calling drm_vma_node_allow() directly since
the mmo has been created at the first time.

However the driver just revokes the vma_node only one time
when closing the object, it leads to memory leak easily.

This patch is to fix the memory leak by calling drm_vma_node_allow() one
time also.

V2: add "Fixes and Cc stable". (Tvrtko Ursulin)

Fixes: 786555987207 ("drm/i915/gem: Store mmap_offsets in an rbtree
rather than a plain list")
Cc: <stable@vger.kernel.org> # v5.7+
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
index c3ea243d414d..fda346d687fd 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -680,7 +680,7 @@ mmap_offset_attach(struct drm_i915_gem_object *obj,
 	mmo = insert_mmo(obj, mmo);
 	GEM_BUG_ON(lookup_mmo(obj, mmap_type) != mmo);
 out:
-	if (file)
+	if (file && !drm_vma_node_is_allowed(&mmo->vma_node, file))
 		drm_vma_node_allow(&mmo->vma_node, file);
 	return mmo;
 
-- 
2.25.0.rc2

