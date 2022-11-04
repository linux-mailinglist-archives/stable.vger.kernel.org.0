Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3614619F52
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 18:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiKDRz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 13:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiKDRz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 13:55:26 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3CF303C3
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 10:55:25 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id k9-20020a170902c40900b0018734e872a9so4075954plk.21
        for <stable@vger.kernel.org>; Fri, 04 Nov 2022 10:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ByKqJidfNb3mojJPAq8ZsGvjppf1O9EkDzOQxFpRQe8=;
        b=e9kM7oGtvlmUl02QSt+b5ByDYOyWRrDYmh0YchXF+ZihKPF6CNQ1IyOiRWRGPbmar9
         stiVUgjM7Vaxhgf//4aYPxGBtZlovL18YJoRDsTy1p8qE/01CeuGyrr/kA5VnMz+lA2n
         1ZiW8ldbyjsDqd25WWL5uHwUYBfx4u32/SvP0dmh4QjS/l3exRarhJXoACIv/8c59VcM
         W4oj6pp5yukfEPXBuFRfBgCZZIcADEg7DwG5aSLk7mBQd69lWBS8a8Niego2T5UJJAKY
         601e07/H+ShvnMVFY5dFHck9c6F7odRF20HKmfsuKVIbPm6kLzWQjTILdlYl8+ZNESD7
         g7ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ByKqJidfNb3mojJPAq8ZsGvjppf1O9EkDzOQxFpRQe8=;
        b=LAUJHvWVGAFFhqibpxkIeIw9Y9Js63PCZAnjnbpk2ka3IxVWOFFQ4CJhmo79ukDpxM
         EEfnzzn0OzrDrIeyrMWD/yQQIQpNZ3OH2cBCcWk/fToWLVm1SOvbXJwI4kfm7JvVD2BO
         d7FclVk/u5nfU7PX5DCXHjzIemKl7u5xkCO1fFL0spVyw5fjNUHNx6e776KteuZcuThp
         WqfO9pNE+LTyR1mvVhd3t5b3MvheiRlpuEK28IJwMc8AxFE1wocvslIvjzkbb4BrZ1mk
         L7merDPj3iwOzFiZxxnuBVgcM34X86YtcvPSp0qp0ySTy4rSpDKBoL+gZP1IlSZxsvem
         luPQ==
X-Gm-Message-State: ACrzQf0QONn7XL0ax9lRugfAF10JsvpEGjkump+ICYh2jDSMKyM6Xfx5
        cSaJ2LgRCUfH/diDZJNXNlWp0ez5Lqqftw==
X-Google-Smtp-Source: AMsMyM7PthA71t0he2kma2h0sC9u6asPoijITy9fa2CUsCyRYYo7+YlB1A+awT+6CelbSJ15Ti/8qRT9AwqP1Q==
X-Received: from xllamas.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5070])
 (user=cmllamas job=sendgmr) by 2002:a17:90a:8a16:b0:212:f516:edfb with SMTP
 id w22-20020a17090a8a1600b00212f516edfbmr359722pjn.156.1667584524402; Fri, 04
 Nov 2022 10:55:24 -0700 (PDT)
Date:   Fri,  4 Nov 2022 17:54:49 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104175450.306810-1-cmllamas@google.com>
Subject: [PATCH 5.10] binder: fix UAF of alloc->vma in race with munmap()
From:   Carlos Llamas <cmllamas@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?=" <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Carlos Llamas <cmllamas@google.com>,
        Suren Baghdasaryan <surenb@google.com>
Cc:     kernel-team@android.com, Jann Horn <jannh@google.com>,
        stable@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Liam Howlett <liam.howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 720c24192404 ("ANDROID: binder: change down_write to
down_read") binder assumed the mmap read lock is sufficient to protect
alloc->vma inside binder_update_page_range(). This used to be accurate
until commit dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in
munmap"), which now downgrades the mmap_lock after detaching the vma
from the rbtree in munmap(). Then it proceeds to teardown and free the
vma with only the read lock held.

This means that accesses to alloc->vma in binder_update_page_range() now
will race with vm_area_free() in munmap() and can cause a UAF as shown
in the following KASAN trace:

  ==================================================================
  BUG: KASAN: use-after-free in vm_insert_page+0x7c/0x1f0
  Read of size 8 at addr ffff16204ad00600 by task server/558

  CPU: 3 PID: 558 Comm: server Not tainted 5.10.150-00001-gdc8dcf942daa #1
  Hardware name: linux,dummy-virt (DT)
  Call trace:
   dump_backtrace+0x0/0x2a0
   show_stack+0x18/0x2c
   dump_stack+0xf8/0x164
   print_address_description.constprop.0+0x9c/0x538
   kasan_report+0x120/0x200
   __asan_load8+0xa0/0xc4
   vm_insert_page+0x7c/0x1f0
   binder_update_page_range+0x278/0x50c
   binder_alloc_new_buf+0x3f0/0xba0
   binder_transaction+0x64c/0x3040
   binder_thread_write+0x924/0x2020
   binder_ioctl+0x1610/0x2e5c
   __arm64_sys_ioctl+0xd4/0x120
   el0_svc_common.constprop.0+0xac/0x270
   do_el0_svc+0x38/0xa0
   el0_svc+0x1c/0x2c
   el0_sync_handler+0xe8/0x114
   el0_sync+0x180/0x1c0

  Allocated by task 559:
   kasan_save_stack+0x38/0x6c
   __kasan_kmalloc.constprop.0+0xe4/0xf0
   kasan_slab_alloc+0x18/0x2c
   kmem_cache_alloc+0x1b0/0x2d0
   vm_area_alloc+0x28/0x94
   mmap_region+0x378/0x920
   do_mmap+0x3f0/0x600
   vm_mmap_pgoff+0x150/0x17c
   ksys_mmap_pgoff+0x284/0x2dc
   __arm64_sys_mmap+0x84/0xa4
   el0_svc_common.constprop.0+0xac/0x270
   do_el0_svc+0x38/0xa0
   el0_svc+0x1c/0x2c
   el0_sync_handler+0xe8/0x114
   el0_sync+0x180/0x1c0

  Freed by task 560:
   kasan_save_stack+0x38/0x6c
   kasan_set_track+0x28/0x40
   kasan_set_free_info+0x24/0x4c
   __kasan_slab_free+0x100/0x164
   kasan_slab_free+0x14/0x20
   kmem_cache_free+0xc4/0x34c
   vm_area_free+0x1c/0x2c
   remove_vma+0x7c/0x94
   __do_munmap+0x358/0x710
   __vm_munmap+0xbc/0x130
   __arm64_sys_munmap+0x4c/0x64
   el0_svc_common.constprop.0+0xac/0x270
   do_el0_svc+0x38/0xa0
   el0_svc+0x1c/0x2c
   el0_sync_handler+0xe8/0x114
   el0_sync+0x180/0x1c0

  [...]
  ==================================================================

To prevent the race above, revert back to taking the mmap write lock
inside binder_update_page_range(). One might expect an increase of mmap
lock contention. However, binder already serializes these calls via top
level alloc->mutex. Also, there was no performance impact shown when
running the binder benchmark tests.

Note this patch is specific to stable branches 5.4 and 5.10. Since in
newer kernel releases binder no longer caches a pointer to the vma.
Instead, it has been refactored to use vma_lookup() which avoids the
issue described here. This switch was introduced in commit a43cfc87caaf
("android: binder: stop saving a pointer to the VMA").

Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
Reported-by: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org> # 5.10.x
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
---
 drivers/android/binder_alloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 95ca4f934d28..a77ed66425f2 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -212,7 +212,7 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
 		mm = alloc->vma_vm_mm;
 
 	if (mm) {
-		mmap_read_lock(mm);
+		mmap_write_lock(mm);
 		vma = alloc->vma;
 	}
 
@@ -270,7 +270,7 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
 		trace_binder_alloc_page_end(alloc, index);
 	}
 	if (mm) {
-		mmap_read_unlock(mm);
+		mmap_write_unlock(mm);
 		mmput(mm);
 	}
 	return 0;
@@ -303,7 +303,7 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
 	}
 err_no_vma:
 	if (mm) {
-		mmap_read_unlock(mm);
+		mmap_write_unlock(mm);
 		mmput(mm);
 	}
 	return vma ? -ENOMEM : -ESRCH;
-- 
2.38.1.431.g37b22c650d-goog

