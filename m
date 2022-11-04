Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DB2619F53
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 18:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiKDRzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 13:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiKDRzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 13:55:41 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95789303C3
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 10:55:39 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id v10-20020a17090a7c0a00b00215deac75b4so2713986pjf.3
        for <stable@vger.kernel.org>; Fri, 04 Nov 2022 10:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/X2Hm1gIXw/9Z8rvwApLMhnT3Rh/DkkCP/PD4pSdarQ=;
        b=ltdOmDrH0s0e5PAFtmKQIxn2sNp/mLjaG7D7tWApB9kwiLiFCuqwulpMI7KQ5xw+7z
         YaabZBg/sCKFhS5kS4XyOv0Q3UxonF5QBgOzkAPqPja1mNGBWeVdhCDwErNwetLZbnif
         5hNZXVA86+tBUx2f+W55lFqJRPWmZRuVViTVSpoDakHAToJrW+U9yKvFx/LdNc5ezhVo
         PIE7dufsgeACkhdeo9x/h09KlOcSLNC+LIdFbcGKdsGS26i6+RunW2qEyJL65CM/TNKu
         rZaIjGDRC5EeZwoEy1dQktXWu7NdNZ3LUpVe83ZOeYprRTzmJ4ijEsuszMpTpuB7pOXk
         usBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/X2Hm1gIXw/9Z8rvwApLMhnT3Rh/DkkCP/PD4pSdarQ=;
        b=gm3sE3sMnWmIbUCEHmxh/g89tQBOIj1On7FUtIBk+imTzQxFMQ9dN0AoVx2y1pLIlh
         zQwOT1K5XJL/2rHp0QZ3Z4dJCpX4TSFy1/nZXjeIUXR7zEkgz5Ott4JB/pg8Hjnl1WJY
         Xk7uz4YHNaHmNErv5pBToc+s+beGpejw8Kz4pwlNk+ico5dytZNB4nRpQ1RhKAUPuDh5
         eI7PEV5k9erqGvbrlQOCJY/TFLBuuvcYe8ejawxAPASvnOECYUOGkR9aiat8hCZzmoV5
         1EiJbomIke3QbFskG2Wqe46YmdfBFsjwrLWc1rsC+jI8PfloePsOwVfqXNY5MfGx3dKj
         NROQ==
X-Gm-Message-State: ACrzQf0+HMZGYYS7B3ggMx/Dv3ox215n0yAwCL4bjePQzbu6fjYxNO11
        hqJk8km9ydHde3evdW45paPg8x5X8tYkjA==
X-Google-Smtp-Source: AMsMyM6aoq+wEQyCl0d5HHt377RTRbSlt7JSeMgjYDeHp8juYcoABBwqoMwB1IL6jH2fpfv2SK77DpFb5JvLRg==
X-Received: from xllamas.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5070])
 (user=cmllamas job=sendgmr) by 2002:a17:902:f78a:b0:184:f2e2:a5fa with SMTP
 id q10-20020a170902f78a00b00184f2e2a5famr36539848pln.161.1667584539105; Fri,
 04 Nov 2022 10:55:39 -0700 (PDT)
Date:   Fri,  4 Nov 2022 17:55:33 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104175534.307317-1-cmllamas@google.com>
Subject: [PATCH 5.4] binder: fix UAF of alloc->vma in race with munmap()
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
Cc: <stable@vger.kernel.org> # 5.4.x
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
---
 drivers/android/binder_alloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index b5022a7f6bae..7e48ed7c9c8e 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -212,7 +212,7 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
 		mm = alloc->vma_vm_mm;
 
 	if (mm) {
-		down_read(&mm->mmap_sem);
+		down_write(&mm->mmap_sem);
 		vma = alloc->vma;
 	}
 
@@ -271,7 +271,7 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
 		/* vm_insert_page does not seem to increment the refcount */
 	}
 	if (mm) {
-		up_read(&mm->mmap_sem);
+		up_write(&mm->mmap_sem);
 		mmput(mm);
 	}
 	return 0;
@@ -304,7 +304,7 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
 	}
 err_no_vma:
 	if (mm) {
-		up_read(&mm->mmap_sem);
+		up_write(&mm->mmap_sem);
 		mmput(mm);
 	}
 	return vma ? -ENOMEM : -ESRCH;
-- 
2.38.1.431.g37b22c650d-goog

