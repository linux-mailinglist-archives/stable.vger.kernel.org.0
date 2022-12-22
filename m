Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB92C653EAC
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 12:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbiLVLGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 06:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiLVLGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 06:06:34 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E733897
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 03:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671707193; x=1703243193;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bE1MGAtv+t+qlq4DBkVb5lQW5j5dayUpgaorPm5GaV8=;
  b=WTYVSTVLnKfcgl7jAUNQ0eCVVv791KkiIwSu5CwOvWWs7vrZkkzU1F5M
   SKQ58bOITCblzUcxOGhtmfOGhcOT3wCZj508gdNJqwdqCXInHojIymQiT
   ZsXHlpyrqTemD2QIH9rH1UjaMqZxjpYp7AR+xohHNod8jFAaXtXZDLx8A
   tJ7PVNBg+07Zyeb93AXBEnN34qviNi0+GNFxifan8BzOwMfGellNU9Kml
   OwO2jUn6FXXqY/msUXJxEMgvltiS3B21yj08w4zEObUc3twDC/GwzmUOY
   GjSqXhxb5jM0omE6zvdjb98H5GApGdHHDhLqbaIQRmGhMmg21XJ/x2txG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="303534796"
X-IronPort-AV: E=Sophos;i="5.96,265,1665471600"; 
   d="scan'208";a="303534796"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 03:06:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="825937606"
X-IronPort-AV: E=Sophos;i="5.96,265,1665471600"; 
   d="scan'208";a="825937606"
Received: from cprice2-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.213.220.27])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 03:06:30 -0800
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
To:     Intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Matthew Auld <matthew.auld@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: Fix same object multiple mmap memory leak
Date:   Thu, 22 Dec 2022 11:06:20 +0000
Message-Id: <20221222110620.276311-1-tvrtko.ursulin@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HEXHASH_WORD,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

This is the fix proposed by Chuansheng Liu <chuansheng.liu@intel.com> to
close a memory leak caused by refactoring done in 786555987207
("drm/i915/gem: Store mmap_offsets in an rbtree rather than a plain list").

Original commit text from Liu was this:

>
> The below memory leak information is caught:
>
> unreferenced object 0xffff997dd4e3b240 (size 64):
>   comm "gem_tiled_fence", pid 10332, jiffies 4294959326 (age 220778.420s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 be f2 d4 7d 99 ff ff  ............}...
>   backtrace:
>     [<ffffffffa0f04365>] kmem_cache_alloc_trace+0x2e5/0x450
>     [<ffffffffc062f3ac>] drm_vma_node_allow+0x2c/0xe0 [drm]
>     [<ffffffffc13149ea>] __assign_mmap_offset_handle+0x1da/0x4a0 [i915]
>     [<ffffffffc1315235>] i915_gem_mmap_offset_ioctl+0x55/0xb0 [i915]
>     [<ffffffffc06207e4>] drm_ioctl_kernel+0xb4/0x140 [drm]
>     [<ffffffffc0620ac7>] drm_ioctl+0x257/0x410 [drm]
>     [<ffffffffa0f553ae>] __x64_sys_ioctl+0x8e/0xc0
>     [<ffffffffa1821128>] do_syscall_64+0x38/0xc0
>     [<ffffffffa1a0007c>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> The issue is always reproduced with the test:
> gem_tiled_fence_blits --run-subtest basic
>
> It tries to mmap_gtt the same object several times, it is like:
> create BO
> mmap_gtt BO
> unmap BO
> mmap_gtt BO <== second time mmap_gtt
> unmap
> close BO
>
> The leak happens at the second time mmap_gtt in function
> mmap_offset_attach(),it will simply increase the reference
> count to 2 by calling drm_vma_node_allow() directly since
> the mmo has been created at the first time.
>
> However the driver just revokes the vma_node only one time
> when closing the object, it leads to memory leak easily.
>
> This patch is to fix the memory leak by calling drm_vma_node_allow() one
> time also.

Issue was later also reported by Mirsad:

>
> The problem is a kernel memory leak that is repeatedly occurring
> triggered during the execution of Chrome browser under the latest
> 6.1.0+  kernel of this morning and Almalinux 8.6 on a Lenovo
> desktop box with Intel(R) Core(TM) i5-8400 CPU @ 2.80GHz CPU.
>
> The build is with KMEMLEAK, KASAN and MGLRU turned on during the
> build,  on a vanilla mainline kernel from Mr. Torvalds' tree.
>
> The leaks look like this one:
>
> unreferenced object 0xffff888131754880 (size 64):
>    comm "chrome", pid 13058, jiffies 4298568878 (age 3708.084s)
>    hex dump (first 32 bytes):
>      01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
>      00 00 00 00 00 00 00 00 00 80 1e 3e 83 88 ff ff ...........>....
>    backtrace:
>      [<ffffffff9e9b5542>] slab_post_alloc_hook+0xb2/0x340
>      [<ffffffff9e9bbf5f>] __kmem_cache_alloc_node+0x1bf/0x2c0
>      [<ffffffff9e8f767a>] kmalloc_trace+0x2a/0xb0
>      [<ffffffffc08dfde5>] drm_vma_node_allow+0x45/0x150 [drm]
>      [<ffffffffc0b33315>] __assign_mmap_offset_handle+0x615/0x820 [i915]
>      [<ffffffffc0b34057>] i915_gem_mmap_offset_ioctl+0x77/0x110 [i915]
>      [<ffffffffc08bc5e1>] drm_ioctl_kernel+0x181/0x280 [drm]
>      [<ffffffffc08bc9cd>] drm_ioctl+0x2dd/0x6a0 [drm]
>      [<ffffffff9ea54744>] __x64_sys_ioctl+0xc4/0x100
>      [<ffffffff9fbc0178>] do_syscall_64+0x58/0x80
>      [<ffffffff9fc000aa>] entry_SYSCALL_64_after_hwframe+0x72/0xdc
>

Root cause is that 786555987207 started caching (and sharing) the
i915_mmap_offset objects per object and same mmap type. This means that
reference count incremented by drm_vma_node_allow could grow beyond one,
while the object closure path calls drm_vma_node_revoke only once and
so the structure leaks.

Secondary effect from this, which is also different than what we had
before 786555987207 is that it is now possible to mmap an offset belonging
to a closed object.

Fix here is to partially revert to behaviour before 786555987207 - that is
to disallow mmap of closed objects and to only increment the mmap offset
ref count once per object-type.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Co-developed-by: Chuansheng Liu <chuansheng.liu@intel.com>
Fixes: 786555987207 ("drm/i915/gem: Store mmap_offsets in an rbtree rather than a plain list")
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Tested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Testcase: igt@gem_mmap_gtt@mmap-closed-bo
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: "Thomas Hellström" <thomas.hellstrom@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.7+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
---
Test-with: 20221222100403.256775-1-tvrtko.ursulin@linux.intel.com
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
index d73ba0f5c4c5..1ceff19a0ac0 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -695,9 +695,10 @@ mmap_offset_attach(struct drm_i915_gem_object *obj,
 insert:
 	mmo = insert_mmo(obj, mmo);
 	GEM_BUG_ON(lookup_mmo(obj, mmap_type) != mmo);
-out:
+
 	if (file)
 		drm_vma_node_allow(&mmo->vma_node, file);
+out:
 	return mmo;
 
 err:
-- 
2.34.1

