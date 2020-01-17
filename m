Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC01913FEDD
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390365AbgAPX14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:27:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390363AbgAPX1z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:27:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 147EC20684;
        Thu, 16 Jan 2020 23:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217274;
        bh=BthoY7cBT+8JYlgXSawoQEjQkU4RYH/k7PQnhlSHTLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rw40zoDW3TumsWjPPZlFu5zWhW4ni6tb/gV/4fekUxHA2dzmKqW+7X/vYU4IwCZBZ
         80k/tA2hxze4P8r++g7WYHrf7LavwhEEiLuiGLzb37Sr467H4eZ2KHmQ/z+miQ0RdN
         XCVhu300kQd/zkCQ2lQPyH+pyKgtXTJk++h1afvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?=E7=BD=97=E6=9D=83?= <luoquan@qianxin.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH 4.19 16/84] drm/i915: Fix use-after-free when destroying GEM context
Date:   Fri, 17 Jan 2020 00:17:50 +0100
Message-Id: <20200116231715.550710759@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@canonical.com>

This patch is a simplified fix to address a use-after-free in 4.14.x and
4.19.x stable kernels. The flaw is already fixed upstream, starting in
5.2, by commit 7dc40713618c ("drm/i915: Introduce a mutex for
file_priv->context_idr") as part of a more complex patch series that
isn't appropriate for backporting to stable kernels.

Expand mutex coverage, while destroying the GEM context, to include the
GEM context lookup step. This fixes a use-after-free detected by KASAN:

 ==================================================================
 BUG: KASAN: use-after-free in i915_ppgtt_close+0x2ca/0x2f0
 Write of size 1 at addr ffff8881368a8368 by task i915-poc/3124

 CPU: 0 PID: 3124 Comm: i915-poc Not tainted 4.14.164 #1
 Hardware name: HP HP Elite x2 1012 G1 /80FC, BIOS N85 Ver. 01.20 04/05/2017
 Call Trace:
  dump_stack+0xcd/0x12e
  ? _atomic_dec_and_lock+0x1b2/0x1b2
  ? i915_ppgtt_close+0x2ca/0x2f0
  ? printk+0x8f/0xab
  ? show_regs_print_info+0x53/0x53
  ? i915_ppgtt_close+0x2ca/0x2f0
  print_address_description+0x65/0x270
  ? i915_ppgtt_close+0x2ca/0x2f0
  kasan_report+0x251/0x340
  i915_ppgtt_close+0x2ca/0x2f0
  ? __radix_tree_insert+0x3f0/0x3f0
  ? i915_ppgtt_init_hw+0x7c0/0x7c0
  context_close+0x42e/0x680
  ? i915_gem_context_release+0x230/0x230
  ? kasan_kmalloc+0xa0/0xd0
  ? radix_tree_delete_item+0x1d4/0x250
  ? radix_tree_lookup+0x10/0x10
  ? inet_recvmsg+0x4b0/0x4b0
  ? kasan_slab_free+0x88/0xc0
  i915_gem_context_destroy_ioctl+0x236/0x300
  ? i915_gem_context_create_ioctl+0x360/0x360
  ? drm_dev_printk+0x1d0/0x1d0
  ? memcpy+0x34/0x50
  ? i915_gem_context_create_ioctl+0x360/0x360
  drm_ioctl_kernel+0x1b0/0x2b0
  ? drm_ioctl_permit+0x2a0/0x2a0
  ? avc_ss_reset+0xd0/0xd0
  drm_ioctl+0x6fe/0xa20
  ? i915_gem_context_create_ioctl+0x360/0x360
  ? drm_getstats+0x20/0x20
  ? put_unused_fd+0x260/0x260
  do_vfs_ioctl+0x189/0x12d0
  ? ioctl_preallocate+0x280/0x280
  ? selinux_file_ioctl+0x3a7/0x680
  ? selinux_bprm_set_creds+0xe30/0xe30
  ? security_file_ioctl+0x69/0xa0
  ? selinux_bprm_set_creds+0xe30/0xe30
  SyS_ioctl+0x6f/0x80
  ? __sys_sendmmsg+0x4a0/0x4a0
  ? do_vfs_ioctl+0x12d0/0x12d0
  do_syscall_64+0x214/0x5f0
  ? __switch_to_asm+0x31/0x60
  ? __switch_to_asm+0x25/0x60
  ? __switch_to_asm+0x31/0x60
  ? syscall_return_slowpath+0x2c0/0x2c0
  ? copy_overflow+0x20/0x20
  ? __switch_to_asm+0x25/0x60
  ? syscall_return_via_sysret+0x2a/0x7a
  ? prepare_exit_to_usermode+0x200/0x200
  ? __switch_to_asm+0x31/0x60
  ? __switch_to_asm+0x31/0x60
  ? __switch_to_asm+0x25/0x60
  ? __switch_to_asm+0x25/0x60
  ? __switch_to_asm+0x31/0x60
  ? __switch_to_asm+0x25/0x60
  ? __switch_to_asm+0x31/0x60
  ? __switch_to_asm+0x31/0x60
  ? __switch_to_asm+0x25/0x60
  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
 RIP: 0033:0x7f7fda5115d7
 RSP: 002b:00007f7eec317ec8 EFLAGS: 00000286 ORIG_RAX: 0000000000000010
 RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7fda5115d7
 RDX: 000055b306db9188 RSI: 000000004008646e RDI: 0000000000000003
 RBP: 00007f7eec317ef0 R08: 00007f7eec318700 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000286 R12: 00007f7eec317fc0
 R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffd8007ade0

 Allocated by task 2898:
  save_stack+0x32/0xb0
  kasan_kmalloc+0xa0/0xd0
  kmem_cache_alloc_trace+0x5e/0x180
  i915_ppgtt_create+0xab/0x2510
  i915_gem_create_context+0x981/0xf90
  i915_gem_context_create_ioctl+0x1d7/0x360
  drm_ioctl_kernel+0x1b0/0x2b0
  drm_ioctl+0x6fe/0xa20
  do_vfs_ioctl+0x189/0x12d0
  SyS_ioctl+0x6f/0x80
  do_syscall_64+0x214/0x5f0
  entry_SYSCALL_64_after_hwframe+0x3d/0xa2

 Freed by task 104:
  save_stack+0x32/0xb0
  kasan_slab_free+0x72/0xc0
  kfree+0x88/0x190
  i915_ppgtt_release+0x24e/0x460
  i915_gem_context_free+0x90/0x480
  contexts_free_worker+0x54/0x80
  process_one_work+0x876/0x14e0
  worker_thread+0x1b8/0xfd0
  kthread+0x2f8/0x3c0
  ret_from_fork+0x35/0x40

 The buggy address belongs to the object at ffff8881368a8000
  which belongs to the cache kmalloc-8192 of size 8192
 The buggy address is located 872 bytes inside of
  8192-byte region [ffff8881368a8000, ffff8881368aa000)
 The buggy address belongs to the page:
 page:ffffea0004da2a00 count:1 mapcount:0 mapping:          (null) index:0x0 compound_mapcount: 0
 flags: 0x200000000008100(slab|head)
 raw: 0200000000008100 0000000000000000 0000000000000000 0000000100030003
 raw: dead000000000100 dead000000000200 ffff88822a002280 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff8881368a8200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8881368a8280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 >ffff8881368a8300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                           ^
  ffff8881368a8380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8881368a8400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ==================================================================

Fixes: 1acfc104cdf8 ("drm/i915: Enable rcu-only context lookups")
Reported-by: 罗权 <luoquan@qianxin.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Cc: stable@vger.kernel.org # 4.14.x
Cc: stable@vger.kernel.org # 4.19.x
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_context.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/i915_gem_context.c
@@ -770,18 +770,19 @@ int i915_gem_context_destroy_ioctl(struc
 	if (args->ctx_id == DEFAULT_CONTEXT_HANDLE)
 		return -ENOENT;
 
+	ret = i915_mutex_lock_interruptible(dev);
+	if (ret)
+		return ret;
+
 	ctx = i915_gem_context_lookup(file_priv, args->ctx_id);
-	if (!ctx)
+	if (!ctx) {
+		mutex_unlock(&dev->struct_mutex);
 		return -ENOENT;
-
-	ret = mutex_lock_interruptible(&dev->struct_mutex);
-	if (ret)
-		goto out;
+	}
 
 	__destroy_hw_context(ctx, file_priv);
 	mutex_unlock(&dev->struct_mutex);
 
-out:
 	i915_gem_context_put(ctx);
 	return 0;
 }


