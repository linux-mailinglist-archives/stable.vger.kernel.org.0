Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D576ADAC6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjCGJpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjCGJpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:45:53 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1603B5BC85
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678182351; x=1709718351;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SJ/2AwXzarDVShG6oGH338mQVh6Nfv4yMwFXH/EgR/U=;
  b=Zk0whIY3K85dbvTDxxPEY882hC/hFPf53kkWTr5rOi+Jygi8WfjbuF37
   63Qn14h0TmtN8CTz0815oyhq2dRLJLVQMxmBeanVkWEznJPdyBbCaGSGQ
   YR6AKgRuRMTGhO+kjSNeucavTGZqkjBWFEKjMK8RowxGbdTX+gJN5oUXY
   zeUeuc0EcWvnI3r8Gejg5BNw1ib/svBZxl249ETTaoaLqflL8MrPcfXuh
   qzyu8ua+/LUoYsV+iTudTddrrfiGKcDY+xuSf/hvHt1qGZctCQI7KkTb8
   QJhhTRKPdZG9xtlAiGg3uoECv52imZv6bhDrZFYaWqxWK2+1DnUdUuc7X
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="334525635"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="334525635"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 01:45:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="819697635"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="819697635"
Received: from gaertgee-mobl.ger.corp.intel.com (HELO intel.com) ([10.249.43.130])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 01:45:28 -0800
Date:   Tue, 7 Mar 2023 10:45:26 +0100
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Cc:     Andi Shyti <andi.shyti@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>
Subject: Re: [Intel-gfx] [PATCH v3 0/2] Fix error propagation amongst request
Message-ID: <ZAcHtsmKkwlPwCz7@ashyti-mobl2.lan>
References: <20230228021142.1905349-1-andi.shyti@linux.intel.com>
 <24b04551-8f13-3669-e3b7-d567ca8b35f6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24b04551-8f13-3669-e3b7-d567ca8b35f6@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi GG,

On Tue, Mar 07, 2023 at 09:33:12AM +0200, Gwan-gyeong Mun wrote:
> Hi Andi,
> 
> After applying these two patches, deadlock is being detected in the call
> stack below. Please review whether the patch to update the
> intel_context_migrate_copy() part affected the deadlock.
> 
> https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_114451v1/bat-dg2-8/igt@i915_module_load@load.html#dmesg-warnings1037

Thanks for looking into this. Yes, there is a basic locking issue
here coming from migrate. migrate() takes the timeline lock and
then calls the request_create() which tries to lock again. We
inevitably fall into deadlock.

The locking of the timeline is quite exotic, it's started in
request_create() and released in request_add().

It's still in trybot, but this is supposed to be the next
version:

https://patchwork.freedesktop.org/series/114645/

This creates new version of request_create_locked() and
request_add_locked() where there the timeline is not locked in
the process.

There are still some selftests that need to be fixed, though.

Andi

> <4> [33.070967] ============================================
> <4> [33.070968] WARNING: possible recursive locking detected
> <4> [33.070969] 6.2.0-Patchwork_114451v1-g8589fd9227ca+ #1 Not tainted
> <4> [33.070970] --------------------------------------------
> <4> [33.070971] i915_module_loa/948 is trying to acquire lock:
> <4> [33.070972] ffff8881127f0478 (migrate){+.+.}-{3:3}, at:
> i915_request_create+0x1c6/0x230 [i915]
> <4> [33.071215]
> but task is already holding lock:
> <4> [33.071235] ffff8881127f0478 (migrate){+.+.}-{3:3}, at:
> intel_context_migrate_copy+0x1b3/0xa80 [i915]
> <4> [33.071484]
> other info that might help us debug this:
> <4> [33.071504]  Possible unsafe locking scenario:
> <4> [33.071522]        CPU0
> <4> [33.071532]        ----
> <4> [33.071541]   lock(migrate);
> <4> [33.071554]   lock(migrate);
> <4> [33.071567]
>  *** DEADLOCK ***
> <4> [33.071585]  May be due to missing lock nesting notation
> <4> [33.071606] 3 locks held by i915_module_loa/948:
> <4> [33.071622]  #0: ffffc90001eb7b70
> (reservation_ww_class_acquire){+.+.}-{0:0}, at:
> i915_gem_do_execbuffer+0xae2/0x21c0 [i915]
> <4> [33.071893]  #1: ffff8881127b9c28
> (reservation_ww_class_mutex){+.+.}-{3:3}, at:
> __intel_context_do_pin_ww+0x7a/0xa30 [i915]
> <4> [33.072133]  #2: ffff8881127f0478 (migrate){+.+.}-{3:3}, at:
> intel_context_migrate_copy+0x1b3/0xa80 [i915]
> <4> [33.072384]
> stack backtrace:
> <4> [33.072399] CPU: 7 PID: 948 Comm: i915_module_loa Not tainted
> 6.2.0-Patchwork_114451v1-g8589fd9227ca+ #1
> <4> [33.072428] Hardware name: Intel Corporation CoffeeLake Client
> Platform/CoffeeLake S UDIMM RVP, BIOS CNLSFWR1.R00.X220.B00.2103302221
> 03/30/2021
> <4> [33.072465] Call Trace:
> <4> [33.072475]  <TASK>
> <4> [33.072486]  dump_stack_lvl+0x5b/0x85
> <4> [33.072503]  __lock_acquire.cold+0x158/0x33b
> <4> [33.072524]  lock_acquire+0xd6/0x310
> <4> [33.072541]  ? i915_request_create+0x1c6/0x230 [i915]
> <4> [33.072812]  __mutex_lock+0x95/0xf40
> <4> [33.072829]  ? i915_request_create+0x1c6/0x230 [i915]
> <4> [33.073093]  ? rcu_read_lock_sched_held+0x55/0x80
> <4> [33.073112]  ? __mutex_lock+0x133/0xf40
> <4> [33.073128]  ? i915_request_create+0x1c6/0x230 [i915]
> <4> [33.073388]  ? intel_context_migrate_copy+0x1b3/0xa80 [i915]
> <4> [33.073619]  ? i915_request_create+0x1c6/0x230 [i915]
> <4> [33.073876]  i915_request_create+0x1c6/0x230 [i915]
> <4> [33.074135]  intel_context_migrate_copy+0x1d0/0xa80 [i915]
> <4> [33.074360]  __i915_ttm_move+0x7a8/0x940 [i915]
> <4> [33.074538]  ? _raw_spin_unlock_irqrestore+0x41/0x70
> <4> [33.074552]  ? dma_resv_iter_next+0x91/0xb0
> <4> [33.074564]  ? dma_resv_iter_first+0x42/0xb0
> <4> [33.074576]  ? i915_deps_add_resv+0x4c/0xc0 [i915]
> <4> [33.074744]  i915_ttm_move+0x2ac/0x430 [i915]
> <4> [33.074910]  ttm_bo_handle_move_mem+0xb5/0x140 [ttm]
> <4> [33.074930]  ttm_bo_validate+0xe9/0x1a0 [ttm]
> <4> [33.074947]  __i915_ttm_get_pages+0x4e/0x190 [i915]
> <4> [33.075112]  i915_ttm_get_pages+0xf3/0x160 [i915]
> <4> [33.075280]  ____i915_gem_object_get_pages+0x36/0xb0 [i915]
> <4> [33.075446]  __i915_gem_object_get_pages+0x95/0xa0 [i915]
> <4> [33.075608]  i915_vma_get_pages+0xfa/0x160 [i915]
> <4> [33.075779]  i915_vma_pin_ww+0xdc/0xb50 [i915]
> <4> [33.075953]  eb_validate_vmas+0x1c6/0xac0 [i915]
> <4> [33.076114]  i915_gem_do_execbuffer+0xb2a/0x21c0 [i915]
> <4> [33.076276]  ? __stack_depot_save+0x3f/0x4e0
> <4> [33.076292]  ? 0xffffffff81000000
> <4> [33.076301]  ? _raw_spin_unlock_irq+0x41/0x50
> <4> [33.076312]  ? lockdep_hardirqs_on+0xc3/0x140
> <4> [33.076325]  ? set_track_update+0x25/0x50
> <4> [33.076338]  ? __lock_acquire+0x5f2/0x2130
> <4> [33.076356]  i915_gem_execbuffer2_ioctl+0x123/0x2e0 [i915]
> <4> [33.076519]  ? __pfx_i915_gem_execbuffer2_ioctl+0x10/0x10 [i915]
> <4> [33.076679]  drm_ioctl_kernel+0xb4/0x150
> <4> [33.076692]  drm_ioctl+0x21d/0x420
> <4> [33.076703]  ? __pfx_i915_gem_execbuffer2_ioctl+0x10/0x10 [i915]
> <4> [33.076864]  ? __vm_munmap+0xd3/0x170
> <4> [33.076877]  __x64_sys_ioctl+0x76/0xb0
> <4> [33.076889]  do_syscall_64+0x3c/0x90
> <4> [33.076900]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> <4> [33.076913] RIP: 0033:0x7f304aa903ab
> <4> [33.076923] Code: 0f 1e fa 48 8b 05 e5 7a 0d 00 64 c7 00 26 00 00 00 48
> c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48>
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b5 7a 0d 00 f7 d8 64 89 01 48
> <4> [33.076957] RSP: 002b:00007fffb1424cf8 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> <4> [33.076975] RAX: ffffffffffffffda RBX: 00007fffb1424da0 RCX:
> 00007f304aa903ab
> <4> [33.076990] RDX: 00007fffb1424da0 RSI: 0000000040406469 RDI:
> 0000000000000005
> <4> [33.077004] RBP: 0000000040406469 R08: 0000000000000005 R09:
> 0000000100003000
> <4> [33.077019] R10: 0000000000000001 R11: 0000000000000246 R12:
> 0000000000010000
> <4> [33.077034] R13: 0000000000000005 R14: 00000000ffffffff R15:
> 00000000000056a0
> <4> [33.077052]  </TASK>
> 
> Br,
> 
> G.G.
> 
> On 2/28/23 4:11 AM, Andi Shyti wrote:
> > Hi,
> > 
> > This series of two patches fixes the issue introduced in
> > cf586021642d80 ("drm/i915/gt: Pipelined page migration") where,
> > as reported by Matt, in a chain of requests an error is reported
> > only if happens in the last request.
> > 
> > However Chris noticed that without ensuring exclusivity in the
> > locking we might end up in some deadlock. That's why patch 1
> > throttles for the ringspace in order to make sure that no one is
> > holding it.
> > 
> > Version 1 of this patch has been reviewed by matt and this
> > version is adding Chris exclusive locking.
> > 
> > Thanks Chris for this work.
> > 
> > Andi
> > 
> > Changelog
> > =========
> > v1 -> v2
> >   - Add patch 1 for ensuring exclusive locking of the timeline
> >   - Reword git commit of patch 2.
> > 
> > Andi Shyti (1):
> >    drm/i915/gt: Make sure that errors are propagated through request
> >      chains
> > 
> > Chris Wilson (1):
> >    drm/i915: Throttle for ringspace prior to taking the timeline mutex
> > 
> >   drivers/gpu/drm/i915/gt/intel_context.c | 41 +++++++++++++++++++++++++
> >   drivers/gpu/drm/i915/gt/intel_context.h |  2 ++
> >   drivers/gpu/drm/i915/gt/intel_migrate.c | 39 +++++++++++++++++------
> >   drivers/gpu/drm/i915/i915_request.c     |  3 ++
> >   4 files changed, 75 insertions(+), 10 deletions(-)
> > 
