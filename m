Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A312ABAF6
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732431AbgKINQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:16:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387444AbgKINQP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:16:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B72020789;
        Mon,  9 Nov 2020 13:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927773;
        bh=L5sgyIIzup66rGfaRgla51c2az4K+STAoHhzrxK/Vqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZ3RvUln/jvnL9GV6za78uY9D4b99RZGSRnXtizQAHyKEbYcxUR/3aCr2Me82XPGh
         eY9PloC4Pqkbm7h1VEfADgcuZkAMNOzxkl906KeLOAkmIKkm2NVmBvI0eyy1W5yV8c
         qXuiZ3Ltb5WQdrkOXyvVjbaaEa5y/tJLGKxyA7N8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 017/133] drm/i915: Use the active reference on the vma while capturing
Date:   Mon,  9 Nov 2020 13:54:39 +0100
Message-Id: <20201109125031.542668212@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit db9bc2d35f49fed248296d3216597b078c0bab37 upstream.

During error capture, we need to take a reference to the vma from before
the reset in order to catpure the contents of the vma later. Currently
we are using both an active reference and a kref, but due to nature of
the i915_vma reference handling, that kref is on the vma->obj and not
the vma itself. This means the vma may be destroyed as soon as it is
idle, that is in between the i915_active_release(&vma->active) and the
i915_vma_put(vma):

<3> [197.866181] BUG: KASAN: use-after-free in intel_engine_coredump_add_vma+0x36c/0x4a0 [i915]
<3> [197.866339] Read of size 8 at addr ffff8881258cb800 by task gem_exec_captur/1041
<3> [197.866467]
<4> [197.866512] CPU: 2 PID: 1041 Comm: gem_exec_captur Not tainted 5.9.0-g5e4234f97efba-kasan_200+ #1
<4> [197.866521] Hardware name: Intel Corp. Broxton P/Apollolake RVP1A, BIOS APLKRVPA.X64.0150.B11.1608081044 08/08/2016
<4> [197.866530] Call Trace:
<4> [197.866549]  dump_stack+0x99/0xd0
<4> [197.866760]  ? intel_engine_coredump_add_vma+0x36c/0x4a0 [i915]
<4> [197.866783]  print_address_description.constprop.8+0x3e/0x60
<4> [197.866797]  ? kmsg_dump_rewind_nolock+0xd4/0xd4
<4> [197.866819]  ? lockdep_hardirqs_off+0xd4/0x120
<4> [197.867037]  ? intel_engine_coredump_add_vma+0x36c/0x4a0 [i915]
<4> [197.867249]  ? intel_engine_coredump_add_vma+0x36c/0x4a0 [i915]
<4> [197.867270]  kasan_report.cold.10+0x1f/0x37
<4> [197.867492]  ? intel_engine_coredump_add_vma+0x36c/0x4a0 [i915]
<4> [197.867710]  intel_engine_coredump_add_vma+0x36c/0x4a0 [i915]
<4> [197.867949]  i915_gpu_coredump.part.29+0x150/0x7b0 [i915]
<4> [197.868186]  i915_capture_error_state+0x5e/0xc0 [i915]
<4> [197.868396]  intel_gt_handle_error+0x6eb/0xa20 [i915]
<4> [197.868624]  ? intel_gt_reset_global+0x370/0x370 [i915]
<4> [197.868644]  ? check_flags+0x50/0x50
<4> [197.868662]  ? __lock_acquire+0xd59/0x6b00
<4> [197.868678]  ? register_lock_class+0x1ad0/0x1ad0
<4> [197.868944]  i915_wedged_set+0xcf/0x1b0 [i915]
<4> [197.869147]  ? i915_wedged_get+0x90/0x90 [i915]
<4> [197.869371]  ? i915_wedged_get+0x90/0x90 [i915]
<4> [197.869398]  simple_attr_write+0x153/0x1c0
<4> [197.869428]  full_proxy_write+0xee/0x180
<4> [197.869442]  ? __sb_start_write+0x1f3/0x310
<4> [197.869465]  vfs_write+0x1a3/0x640
<4> [197.869492]  ksys_write+0xec/0x1c0
<4> [197.869507]  ? __ia32_sys_read+0xa0/0xa0
<4> [197.869525]  ? lockdep_hardirqs_on_prepare+0x32b/0x4e0
<4> [197.869541]  ? syscall_enter_from_user_mode+0x1c/0x50
<4> [197.869566]  do_syscall_64+0x33/0x80
<4> [197.869579]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4> [197.869590] RIP: 0033:0x7fd8b7aee281
<4> [197.869604] Code: c3 0f 1f 84 00 00 00 00 00 48 8b 05 59 8d 20 00 c3 0f 1f 84 00 00 00 00 00 8b 05 8a d1 20 00 85 c0 75 16 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 57 f3 c3 0f 1f 44 00 00 41 54 55 49 89 d4 53
<4> [197.869613] RSP: 002b:00007ffea3b72008 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
<4> [197.869625] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd8b7aee281
<4> [197.869633] RDX: 0000000000000002 RSI: 00007fd8b81a82e7 RDI: 000000000000000d
<4> [197.869641] RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000034
<4> [197.869650] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fd8b81a82e7
<4> [197.869658] R13: 000000000000000d R14: 0000000000000000 R15: 0000000000000000
<3> [197.869707]
<3> [197.869757] Allocated by task 1041:
<4> [197.869833]  kasan_save_stack+0x19/0x40
<4> [197.869843]  __kasan_kmalloc.constprop.5+0xc1/0xd0
<4> [197.869853]  kmem_cache_alloc+0x106/0x8e0
<4> [197.870059]  i915_vma_instance+0x212/0x1930 [i915]
<4> [197.870270]  eb_lookup_vmas+0xe06/0x1d10 [i915]
<4> [197.870475]  i915_gem_do_execbuffer+0x131d/0x4080 [i915]
<4> [197.870682]  i915_gem_execbuffer2_ioctl+0x103/0x5d0 [i915]
<4> [197.870701]  drm_ioctl_kernel+0x1d2/0x270
<4> [197.870710]  drm_ioctl+0x40d/0x85c
<4> [197.870721]  __x64_sys_ioctl+0x10d/0x170
<4> [197.870731]  do_syscall_64+0x33/0x80
<4> [197.870740]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
<3> [197.870748]
<3> [197.870798] Freed by task 22:
<4> [197.870865]  kasan_save_stack+0x19/0x40
<4> [197.870875]  kasan_set_track+0x1c/0x30
<4> [197.870884]  kasan_set_free_info+0x1b/0x30
<4> [197.870894]  __kasan_slab_free+0x111/0x160
<4> [197.870903]  kmem_cache_free+0xcd/0x710
<4> [197.871109]  i915_vma_parked+0x618/0x800 [i915]
<4> [197.871307]  __gt_park+0xdb/0x1e0 [i915]
<4> [197.871501]  ____intel_wakeref_put_last+0xb1/0x190 [i915]
<4> [197.871516]  process_one_work+0x8dc/0x15d0
<4> [197.871525]  worker_thread+0x82/0xb30
<4> [197.871535]  kthread+0x36d/0x440
<4> [197.871545]  ret_from_fork+0x22/0x30
<3> [197.871553]
<3> [197.871602] The buggy address belongs to the object at ffff8881258cb740
 which belongs to the cache i915_vma of size 968

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2553
Fixes: 2850748ef876 ("drm/i915: Pull i915_vma_pin under the vm->mutex")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201016092527.29039-1-chris@chris-wilson.co.uk
(cherry picked from commit 178536b8292ecd118f59d2fac4509c7e70b99854)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gpu_error.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gpu_error.c
+++ b/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -1312,7 +1312,7 @@ capture_vma(struct intel_engine_capture_
 	}
 
 	strcpy(c->name, name);
-	c->vma = i915_vma_get(vma);
+	c->vma = vma; /* reference held while active */
 
 	c->next = next;
 	return c;
@@ -1402,7 +1402,6 @@ intel_engine_coredump_add_vma(struct int
 						 compress));
 
 		i915_active_release(&vma->active);
-		i915_vma_put(vma);
 
 		capture = this->next;
 		kfree(this);


