Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9C82906C3
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 16:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408489AbgJPOCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 10:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408488AbgJPOCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 10:02:51 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307F6C061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 07:02:51 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id s15so1498574vsm.0
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 07:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rJm08I4a1ngfuMhp2ha+JxReuT8zRWoprhLvCpyFUTI=;
        b=IxFPcfbYwez8j0+lX3hb3IfBNpo4VOObbbvHQ27yX4sgbdTH3O5jWmrXmLY5foyFxo
         mE06e1z2vVHgBn58MdN8BOJ5F15uVCMm1Qzz346OKhKsgPIuEB6+ZeY9TxUy2n8MOOBn
         PA1EO08D5xp/B5nzlCCABPEx5kbCdYgWcK83chtRxBRjoR6Oj0z2NBGAOZQ7TAE3OB5z
         P98ijeN+Xm4opEFpTTGL0FD27IpxQ05Gj2qUM+rWJstJ30+Iohji1EsNqXzInraXfjsm
         XhIJ27U5GlDeUU0CmudKifU2+VAkcxf2f2zS+SsOf4V3P/vfZSIznpDB4CaO0tR0wY64
         o6Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rJm08I4a1ngfuMhp2ha+JxReuT8zRWoprhLvCpyFUTI=;
        b=lJDmRAjxtPo5uXuuw8fA2C9oRUJJO95dgtw+3nTKL0ZhmxTXXdd8rgQ48BnWKh3r1h
         3e74hPNm0D8LOVhqmFIoiwU20T0+cGq2T8prw54kClX1BYD5OeScBQiQjoCAXOcb5SWc
         93nkHnD/7p7AdCfAVYGFuXRmGmWSugay+onP1URALbT5Gtm9RrFHlRvUdzRX/Mp48H30
         1wqzFduJwZHlwr4buFKiCKy1qHrOBKL5a5zvtLLddlLVsWhGgswvVY51QlEjy7YQjUH2
         wStWcM2kVGE7Nw1wqF/hOjiWzckEM/dAwYqnq+cTd/ksbbXTcj1HEdw2s3EJlvvyhbTh
         ObcQ==
X-Gm-Message-State: AOAM533hIfK4A9lekXWLOI9xKNh/e5UsGRBNcqDmtqtCjqiat1GpT4iI
        cBkFVum80itVVQQbGdlT0UD1VCIQEjRaMDpbO44=
X-Google-Smtp-Source: ABdhPJxv5hZ2Ao62z1Vs848BRfLNWM35LbY2sB0tX+PolqmWE2UzKxXmt2yjWbZ9j/Ky7hziPEDW2uFZWUNaeVowFoI=
X-Received: by 2002:a05:6102:1d8:: with SMTP id s24mr1837997vsq.8.1602856970238;
 Fri, 16 Oct 2020 07:02:50 -0700 (PDT)
MIME-Version: 1.0
References: <20201016092527.29039-1-chris@chris-wilson.co.uk>
In-Reply-To: <20201016092527.29039-1-chris@chris-wilson.co.uk>
From:   Matthew Auld <matthew.william.auld@gmail.com>
Date:   Fri, 16 Oct 2020 15:02:23 +0100
Message-ID: <CAM0jSHOrQiz0KgbyeSo=pJkqB7icXbzx2OUOcubJ=4oK_TjOEg@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Use the active reference on the vma
 while capturing
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Oct 2020 at 10:25, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> During error capture, we need to take a reference to the vma from the
> before the reset in order to catpure the contents of the vma later.
> Currently we are using both an active reference and a kref, but due to
> nature of the i915_vma reference handling, that kref is on the vma->obj
> and not the vma itself. This means the vma may be destroyed as soon as
> it is idle, that is in between the i915_active_release(&vma->active) and
> the i915_vma_put(vma);
>
> <3> [197.866181] BUG: KASAN: use-after-free in intel_engine_coredump_add_vma+0x36c/0x4a0 [i915]
> <3> [197.866339] Read of size 8 at addr ffff8881258cb800 by task gem_exec_captur/1041
> <3> [197.866467]
> <4> [197.866512] CPU: 2 PID: 1041 Comm: gem_exec_captur Not tainted 5.9.0-g5e4234f97efba-kasan_200+ #1
> <4> [197.866521] Hardware name: Intel Corp. Broxton P/Apollolake RVP1A, BIOS APLKRVPA.X64.0150.B11.1608081044 08/08/2016
> <4> [197.866530] Call Trace:
> <4> [197.866549]  dump_stack+0x99/0xd0
> <4> [197.866760]  ? intel_engine_coredump_add_vma+0x36c/0x4a0 [i915]
> <4> [197.866783]  print_address_description.constprop.8+0x3e/0x60
> <4> [197.866797]  ? kmsg_dump_rewind_nolock+0xd4/0xd4
> <4> [197.866819]  ? lockdep_hardirqs_off+0xd4/0x120
> <4> [197.867037]  ? intel_engine_coredump_add_vma+0x36c/0x4a0 [i915]
> <4> [197.867249]  ? intel_engine_coredump_add_vma+0x36c/0x4a0 [i915]
> <4> [197.867270]  kasan_report.cold.10+0x1f/0x37
> <4> [197.867492]  ? intel_engine_coredump_add_vma+0x36c/0x4a0 [i915]
> <4> [197.867710]  intel_engine_coredump_add_vma+0x36c/0x4a0 [i915]
> <4> [197.867949]  i915_gpu_coredump.part.29+0x150/0x7b0 [i915]
> <4> [197.868186]  i915_capture_error_state+0x5e/0xc0 [i915]
> <4> [197.868396]  intel_gt_handle_error+0x6eb/0xa20 [i915]
> <4> [197.868624]  ? intel_gt_reset_global+0x370/0x370 [i915]
> <4> [197.868644]  ? check_flags+0x50/0x50
> <4> [197.868662]  ? __lock_acquire+0xd59/0x6b00
> <4> [197.868678]  ? register_lock_class+0x1ad0/0x1ad0
> <4> [197.868944]  i915_wedged_set+0xcf/0x1b0 [i915]
> <4> [197.869147]  ? i915_wedged_get+0x90/0x90 [i915]
> <4> [197.869371]  ? i915_wedged_get+0x90/0x90 [i915]
> <4> [197.869398]  simple_attr_write+0x153/0x1c0
> <4> [197.869428]  full_proxy_write+0xee/0x180
> <4> [197.869442]  ? __sb_start_write+0x1f3/0x310
> <4> [197.869465]  vfs_write+0x1a3/0x640
> <4> [197.869492]  ksys_write+0xec/0x1c0
> <4> [197.869507]  ? __ia32_sys_read+0xa0/0xa0
> <4> [197.869525]  ? lockdep_hardirqs_on_prepare+0x32b/0x4e0
> <4> [197.869541]  ? syscall_enter_from_user_mode+0x1c/0x50
> <4> [197.869566]  do_syscall_64+0x33/0x80
> <4> [197.869579]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> <4> [197.869590] RIP: 0033:0x7fd8b7aee281
> <4> [197.869604] Code: c3 0f 1f 84 00 00 00 00 00 48 8b 05 59 8d 20 00 c3 0f 1f 84 00 00 00 00 00 8b 05 8a d1 20 00 85 c0 75 16 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 57 f3 c3 0f 1f 44 00 00 41 54 55 49 89 d4 53
> <4> [197.869613] RSP: 002b:00007ffea3b72008 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> <4> [197.869625] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd8b7aee281
> <4> [197.869633] RDX: 0000000000000002 RSI: 00007fd8b81a82e7 RDI: 000000000000000d
> <4> [197.869641] RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000034
> <4> [197.869650] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fd8b81a82e7
> <4> [197.869658] R13: 000000000000000d R14: 0000000000000000 R15: 0000000000000000
> <3> [197.869707]
> <3> [197.869757] Allocated by task 1041:
> <4> [197.869833]  kasan_save_stack+0x19/0x40
> <4> [197.869843]  __kasan_kmalloc.constprop.5+0xc1/0xd0
> <4> [197.869853]  kmem_cache_alloc+0x106/0x8e0
> <4> [197.870059]  i915_vma_instance+0x212/0x1930 [i915]
> <4> [197.870270]  eb_lookup_vmas+0xe06/0x1d10 [i915]
> <4> [197.870475]  i915_gem_do_execbuffer+0x131d/0x4080 [i915]
> <4> [197.870682]  i915_gem_execbuffer2_ioctl+0x103/0x5d0 [i915]
> <4> [197.870701]  drm_ioctl_kernel+0x1d2/0x270
> <4> [197.870710]  drm_ioctl+0x40d/0x85c
> <4> [197.870721]  __x64_sys_ioctl+0x10d/0x170
> <4> [197.870731]  do_syscall_64+0x33/0x80
> <4> [197.870740]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> <3> [197.870748]
> <3> [197.870798] Freed by task 22:
> <4> [197.870865]  kasan_save_stack+0x19/0x40
> <4> [197.870875]  kasan_set_track+0x1c/0x30
> <4> [197.870884]  kasan_set_free_info+0x1b/0x30
> <4> [197.870894]  __kasan_slab_free+0x111/0x160
> <4> [197.870903]  kmem_cache_free+0xcd/0x710
> <4> [197.871109]  i915_vma_parked+0x618/0x800 [i915]
> <4> [197.871307]  __gt_park+0xdb/0x1e0 [i915]
> <4> [197.871501]  ____intel_wakeref_put_last+0xb1/0x190 [i915]
> <4> [197.871516]  process_one_work+0x8dc/0x15d0
> <4> [197.871525]  worker_thread+0x82/0xb30
> <4> [197.871535]  kthread+0x36d/0x440
> <4> [197.871545]  ret_from_fork+0x22/0x30
> <3> [197.871553]
> <3> [197.871602] The buggy address belongs to the object at ffff8881258cb740
>  which belongs to the cache i915_vma of size 968
>
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2553
> Fixes: 2850748ef876 ("drm/i915: Pull i915_vma_pin under the vm->mutex")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
