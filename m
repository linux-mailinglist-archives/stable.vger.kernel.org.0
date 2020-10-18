Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A235291F03
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgJRTTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:19:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728290AbgJRTTd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:19:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAD7B2236F;
        Sun, 18 Oct 2020 19:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048772;
        bh=rvqf+6pKT2gzTdaBVe5RNP0ouNMiELv4AHgvr8iGzPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfY7JwAOwpgIeLuH9zqFQ+j8Yd1fjoyBWr5ixZXpc4lQmZ0H/ZVRfiefxbfLY2mHS
         guirsm2ORT8gnF0CCkKPZsHAxhFZAdW9X2y5dsatSfSSsEWN/RJSE0EpjLBd7ZLMcS
         ONwH/sRKEduO1eo0GkXFKu2mNmnZZoNbHIddngig=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia Yang <jiayang5@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.9 071/111] drm: fix double free for gbo in drm_gem_vram_init and drm_gem_vram_create
Date:   Sun, 18 Oct 2020 15:17:27 -0400
Message-Id: <20201018191807.4052726-71-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia Yang <jiayang5@huawei.com>

[ Upstream commit da62cb7230f0871c30dc9789071f63229158d261 ]

I got a use-after-free report when doing some fuzz test:

If ttm_bo_init() fails, the "gbo" and "gbo->bo.base" will be
freed by ttm_buffer_object_destroy() in ttm_bo_init(). But
then drm_gem_vram_create() and drm_gem_vram_init() will free
"gbo" and "gbo->bo.base" again.

BUG: KMSAN: use-after-free in drm_vma_offset_remove+0xb3/0x150
CPU: 0 PID: 24282 Comm: syz-executor.1 Tainted: G    B   W         5.7.0-rc4-msan #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
Call Trace:
 __dump_stack
 dump_stack+0x1c9/0x220
 kmsan_report+0xf7/0x1e0
 __msan_warning+0x58/0xa0
 drm_vma_offset_remove+0xb3/0x150
 drm_gem_free_mmap_offset
 drm_gem_object_release+0x159/0x180
 drm_gem_vram_init
 drm_gem_vram_create+0x7c5/0x990
 drm_gem_vram_fill_create_dumb
 drm_gem_vram_driver_dumb_create+0x238/0x590
 drm_mode_create_dumb
 drm_mode_create_dumb_ioctl+0x41d/0x450
 drm_ioctl_kernel+0x5a4/0x710
 drm_ioctl+0xc6f/0x1240
 vfs_ioctl
 ksys_ioctl
 __do_sys_ioctl
 __se_sys_ioctl+0x2e9/0x410
 __x64_sys_ioctl+0x4a/0x70
 do_syscall_64+0xb8/0x160
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4689b9
Code: fd e0 fa ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 cb e0 fa ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f368fa4dc98 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000076bf00 RCX: 00000000004689b9
RDX: 0000000020000240 RSI: 00000000c02064b2 RDI: 0000000000000003
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00000000004d17e0 R14: 00007f368fa4e6d4 R15: 000000000076bf0c

Uninit was created at:
 kmsan_save_stack_with_flags
 kmsan_internal_poison_shadow+0x66/0xd0
 kmsan_slab_free+0x6e/0xb0
 slab_free_freelist_hook
 slab_free
 kfree+0x571/0x30a0
 drm_gem_vram_destroy
 ttm_buffer_object_destroy+0xc8/0x130
 ttm_bo_release
 kref_put
 ttm_bo_put+0x117d/0x23e0
 ttm_bo_init_reserved+0x11c0/0x11d0
 ttm_bo_init+0x289/0x3f0
 drm_gem_vram_init
 drm_gem_vram_create+0x775/0x990
 drm_gem_vram_fill_create_dumb
 drm_gem_vram_driver_dumb_create+0x238/0x590
 drm_mode_create_dumb
 drm_mode_create_dumb_ioctl+0x41d/0x450
 drm_ioctl_kernel+0x5a4/0x710
 drm_ioctl+0xc6f/0x1240
 vfs_ioctl
 ksys_ioctl
 __do_sys_ioctl
 __se_sys_ioctl+0x2e9/0x410
 __x64_sys_ioctl+0x4a/0x70
 do_syscall_64+0xb8/0x160
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

If ttm_bo_init() fails, the "gbo" will be freed by
ttm_buffer_object_destroy() in ttm_bo_init(). But then
drm_gem_vram_create() and drm_gem_vram_init() will free
"gbo" again.

Reported-by: Hulk Robot <hulkci@huawei.com>
Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Signed-off-by: Jia Yang <jiayang5@huawei.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20200714083238.28479-2-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gem_vram_helper.c | 28 +++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_vram_helper.c b/drivers/gpu/drm/drm_gem_vram_helper.c
index 3296ed3df3580..8b65ca164bf4b 100644
--- a/drivers/gpu/drm/drm_gem_vram_helper.c
+++ b/drivers/gpu/drm/drm_gem_vram_helper.c
@@ -167,6 +167,10 @@ static void drm_gem_vram_placement(struct drm_gem_vram_object *gbo,
 	}
 }
 
+/*
+ * Note that on error, drm_gem_vram_init will free the buffer object.
+ */
+
 static int drm_gem_vram_init(struct drm_device *dev,
 			     struct drm_gem_vram_object *gbo,
 			     size_t size, unsigned long pg_align)
@@ -176,15 +180,19 @@ static int drm_gem_vram_init(struct drm_device *dev,
 	int ret;
 	size_t acc_size;
 
-	if (WARN_ONCE(!vmm, "VRAM MM not initialized"))
+	if (WARN_ONCE(!vmm, "VRAM MM not initialized")) {
+		kfree(gbo);
 		return -EINVAL;
+	}
 	bdev = &vmm->bdev;
 
 	gbo->bo.base.funcs = &drm_gem_vram_object_funcs;
 
 	ret = drm_gem_object_init(dev, &gbo->bo.base, size);
-	if (ret)
+	if (ret) {
+		kfree(gbo);
 		return ret;
+	}
 
 	acc_size = ttm_bo_dma_acc_size(bdev, size, sizeof(*gbo));
 
@@ -195,13 +203,13 @@ static int drm_gem_vram_init(struct drm_device *dev,
 			  &gbo->placement, pg_align, false, acc_size,
 			  NULL, NULL, ttm_buffer_object_destroy);
 	if (ret)
-		goto err_drm_gem_object_release;
+		/*
+		 * A failing ttm_bo_init will call ttm_buffer_object_destroy
+		 * to release gbo->bo.base and kfree gbo.
+		 */
+		return ret;
 
 	return 0;
-
-err_drm_gem_object_release:
-	drm_gem_object_release(&gbo->bo.base);
-	return ret;
 }
 
 /**
@@ -235,13 +243,9 @@ struct drm_gem_vram_object *drm_gem_vram_create(struct drm_device *dev,
 
 	ret = drm_gem_vram_init(dev, gbo, size, pg_align);
 	if (ret < 0)
-		goto err_kfree;
+		return ERR_PTR(ret);
 
 	return gbo;
-
-err_kfree:
-	kfree(gbo);
-	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(drm_gem_vram_create);
 
-- 
2.25.1

