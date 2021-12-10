Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330C1470318
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 15:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242362AbhLJOuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 09:50:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:29215 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235695AbhLJOuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Dec 2021 09:50:37 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10193"; a="235869016"
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="235869016"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 06:47:02 -0800
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="602164290"
Received: from jkilcoyx-mobl.ger.corp.intel.com (HELO [10.252.4.39]) ([10.252.4.39])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 06:46:58 -0800
Message-ID: <a7898ef462a49db825b3fdd4efdba1e546466473.camel@linux.intel.com>
Subject: Re: [PATCH] drm/i915: Stop doing writeback from the shrinker
From:   Thomas =?ISO-8859-1?Q?Hellstr=F6m?= 
        <thomas.hellstrom@linux.intel.com>
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Michal Hocko <mhocko@suse.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Hugh Dickins <hughd@google.com>,
        Sushma Venkatesh Reddy <sushma.venkatesh.reddy@intel.com>,
        Renato Pereyra <renatopereyra@google.com>,
        stable@vger.kernel.org
Date:   Fri, 10 Dec 2021 15:46:56 +0100
In-Reply-To: <20211210110556.883735-1-tvrtko.ursulin@linux.intel.com>
References: <20211210110556.883735-1-tvrtko.ursulin@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-12-10 at 11:05 +0000, Tvrtko Ursulin wrote:
> From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> 
> This effectively removes writeback which was added in 2d6692e642e7
> ("drm/i915: Start writeback from the shrinker").
> 
> Digging through the history it seems we went back and forth on the
> topic
> of whether it would be safe a couple of times. See for instance
> 5537252b6b6d ("drm/i915: Invalidate our pages under memory pressure")
> where Hugh Dickins has advised against it. I do not have enough
> expertise
> in the memory management area so am hoping for expert input here.
> 
> Reason for proposing removal is that there are reports from the field
> which indicate a sysetm wide deadlock (of a sort) implicating i915
> doing
> writeback at shrinking time.
> 
> Signature is a hung task notifier kicking in and task traces such as:

It would be interesting to see what exactly the find_get_entry is
blocked on. The other two tasks are blocked on the shrinker_rwsem which
is held by i915. If it's indeed a deadlock with either of those two,
then the fix Chris is working on for an unrelated issue we discovered
with shrinking would move out the writeback call from the
shrinker_rwsem and resolve this, but if i915 is in turn deadlocking
with another process and these two are just hanging waiting for the
shrinker_rwsem, we would still have other issues.

Do you by any chance have the list of the locks held by the system at
this point?

/Thomas


> 
>  [  247.030274] minijail-init   D    0  1773   1770 0x80004082
>  [  247.036419] Call Trace:
>  [  247.039167]  __schedule+0x57e/0x10d2
>  [  247.043175]  ? __schedule+0x586/0x10d2
>  [  247.047381]  ? _raw_spin_unlock+0xe/0x20
>  [  247.051779]  ? __queue_work+0x316/0x371
>  [   247.056079]  schedule+0x7c/0x9f
>  [  247.059602]  rwsem_down_write_slowpath+0x2ae/0x494
>  [  247.064971]  unregister_shrinker+0x20/0x65
>  [  247.069562]  deactivate_locked_super+0x38/0x88
>  [  247.074538]  cleanup_mnt+0xcc/0x10e
>  [  247.078447]  task_work_run+0x7d/0xa6
>  [  247.082459]  do_exit+0x23d/0x831
>  [  247.086079]  ? syscall_trace_enter+0x207/0x20e
>  [  247.091055]  do_group_exit+0x8d/0x9d
>  [  247.095062]  __x64_sys_exit_group+0x17/0x17
>  [  247.099750]  do_syscall_64+0x54/0x7e
>  [  247.103758]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
>  [  246.876816] chrome          D    0  1791   1785 0x00004080
>  [  246.882965] Call Trace:
>  [  246.885713]  __schedule+0x57e/0x10d2
>  [  246.889724]  ? pcpu_alloc_area+0x25d/0x273
>  [  246.894314]  schedule+0x7c/0x9f
>  [  246.897836]  rwsem_down_write_slowpath+0x2ae/0x494
>  [  246.903207]  register_shrinker_prepared+0x19/0x48
>  [  246.908479]  ? test_single_super+0x10/0x10
>  [  246.913071]  sget_fc+0x1fc/0x20e
>  [  246.916691]  ? kill_litter_super+0x40/0x40
>  [  246.921334]  ? proc_apply_options+0x42/0x42
>  [  246.926044]  vfs_get_super+0x3a/0xdf
>  [  246.930053]  vfs_get_tree+0x2b/0xc3
>  [  246.933965]  fc_mount+0x12/0x39
>  [  246.937492]  pid_ns_prepare_proc+0x9d/0xc5
>  [  246.942085]  alloc_pid+0x275/0x289
>  [  246.945900]  copy_process+0x5e5/0xeea
>  [  246.950006]  _do_fork+0x95/0x303
>  [  246.953628]  __se_sys_clone+0x65/0x7f
>  [  246.957735]  do_syscall_64+0x54/0x7e
>  [  246.961743]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> And finally the smoking gun in:
> 
>  [  247.383338] CPU: 3 PID: 88 Comm: kswapd0 Tainted: G    
> U            5.4.154 #36
>  [  247.383338] Hardware name: Google Delbin/Delbin, BIOS
> Google_Delbin.13672.57.0 02/09/2021
>  [  247.383339] RIP: 0010:__rcu_read_lock+0x0/0x1a
>  [  247.383339] Code: ff ff 0f 0b e9 61 fe ff ff 0f 0b e9 76 fe ff ff
> 0f 0b 49 8b 44 24 20 e9 59 ff ff ff 0f 0b e9 67 ff ff ff 0f 0b e9 1b
> ff ff ff <0f> 1f 44 00 00 55 48 89 e5 65 48 8b 04 25 80 5d 01 00 ff
> 80 f8 03
>  [  247.383340] RSP: 0018:ffffb0aa0031b978 EFLAGS: 00000286
>  [  247.383340] RAX: 0000000000000000 RBX: fffff6b944ca8040 RCX:
> fffff6b944ca8001
>  [  247.383341] RDX: 0000000000000028 RSI: 0000000000000001 RDI:
> ffff8b52bc618c18
>  [  247.383341] RBP: ffffb0aa0031b9d0 R08: 0000000000000000 R09:
> ffff8b52fb5f00d8
>  [  247.383341] R10: 0000000000000000 R11: 0000000000000000 R12:
> 0000000000000000
>  [  247.383342] R13: 61c8864680b583eb R14: 0000000000000001 R15:
> ffffb0aa0031b980
>  [  247.383342] FS:  0000000000000000(0000) GS:ffff8b52fbf80000(0000)
> knlGS:0000000000000000
>  [  247.383343] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  [  247.383343] CR2: 00007c78a400d680 CR3: 0000000120f46006 CR4:
> 0000000000762ee0
>  [  247.383344] PKRU: 55555554
>  [  247.383344] Call Trace:
>  [  247.383345]  find_get_entry+0x4c/0x116
>  [  247.383345]  find_lock_entry+0xc8/0xec
>  [  247.383346]  shmem_writeback+0x7b/0x163
>  [  247.383346]  i915_gem_shrink+0x302/0x40b
>  [  247.383347]  ? __intel_runtime_pm_get+0x22/0x82
>  [  247.383347]  i915_gem_shrinker_scan+0x86/0xa8
>  [  247.383348]  shrink_slab+0x272/0x48b
>  [  247.383348]  shrink_node+0x784/0xbea
>  [  247.383348]  ? rcu_read_unlock_special+0x66/0x15f
>  [  247.383349]  ? update_batch_size+0x78/0x78
>  [  247.383349]  kswapd+0x75c/0xa56
>  [  247.383350]  kthread+0x147/0x156
>  [  247.383350]  ? kswapd_run+0xb6/0xb6
>  [  247.383351]  ? kthread_blkcg+0x2e/0x2e
>  [  247.383351]  ret_from_fork+0x1f/0x40
> 
> You will notice the trace is from an older kernel, the problem being
> reproducing the issue on latest upstream base is proving to be tricky
> due
> other (unrelated) issues.
> 
> It is even tricky to repro on an older kernel, with it seemingly
> needing a
> very specific game, transparent huge pages enabled and a specific
> memory
> configuration.
> 
> However given the history on the topic I could find, assuming what I
> found
> is not incomplete, suspicion on writeback being not the right thing
> to do
> in general is still there. I would therefore like to have input from
> the
> experts here.
> 
> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Fixes: 2d6692e642e7 ("drm/i915: Start writeback from the shrinker")
> References: 5537252b6b6d ("drm/i915: Invalidate our pages under
> memory pressure")
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: Matthew Auld <matthew.auld@intel.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com> #v1
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Sushma Venkatesh Reddy <sushma.venkatesh.reddy@intel.com>
> Cc: Renato Pereyra <renatopereyra@google.com>
> Cc: intel-gfx@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v5.3+
> ---
>  drivers/gpu/drm/i915/gem/i915_gem_object.h    |  2 -
>  .../gpu/drm/i915/gem/i915_gem_object_types.h  |  4 +-
>  drivers/gpu/drm/i915/gem/i915_gem_pages.c     | 10 ----
>  drivers/gpu/drm/i915/gem/i915_gem_shmem.c     | 49 -----------------
> --
>  drivers/gpu/drm/i915/gem/i915_gem_shrinker.c  | 18 +++----
>  drivers/gpu/drm/i915/gem/i915_gem_shrinker.h  |  1 -
>  drivers/gpu/drm/i915/gem/i915_gem_ttm.c       |  6 +--
>  .../gpu/drm/i915/gem/selftests/huge_pages.c   |  3 +-
>  8 files changed, 11 insertions(+), 82 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.h
> b/drivers/gpu/drm/i915/gem/i915_gem_object.h
> index 66f20b803b01..352c7158a487 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_object.h
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_object.h
> @@ -455,7 +455,6 @@ i915_gem_object_unpin_pages(struct
> drm_i915_gem_object *obj)
>  
>  int __i915_gem_object_put_pages(struct drm_i915_gem_object *obj);
>  int i915_gem_object_truncate(struct drm_i915_gem_object *obj);
> -void i915_gem_object_writeback(struct drm_i915_gem_object *obj);
>  
>  /**
>   * i915_gem_object_pin_map - return a contiguous mapping of the
> entire object
> @@ -621,7 +620,6 @@ int shmem_sg_alloc_table(struct drm_i915_private
> *i915, struct sg_table *st,
>                          unsigned int max_segment);
>  void shmem_sg_free_table(struct sg_table *st, struct address_space
> *mapping,
>                          bool dirty, bool backup);
> -void __shmem_writeback(size_t size, struct address_space *mapping);
>  
>  #ifdef CONFIG_MMU_NOTIFIER
>  static inline bool
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
> b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
> index f9f7e44099fe..e188d6137cc0 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
> @@ -57,10 +57,8 @@ struct drm_i915_gem_object_ops {
>         void (*put_pages)(struct drm_i915_gem_object *obj,
>                           struct sg_table *pages);
>         int (*truncate)(struct drm_i915_gem_object *obj);
> -       void (*writeback)(struct drm_i915_gem_object *obj);
>         int (*shrinker_release_pages)(struct drm_i915_gem_object
> *obj,
> -                                     bool no_gpu_wait,
> -                                     bool should_writeback);
> +                                     bool no_gpu_wait);
>  
>         int (*pread)(struct drm_i915_gem_object *obj,
>                      const struct drm_i915_gem_pread *arg);
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
> b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
> index 49c6e55c68ce..52e975f57956 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
> @@ -168,16 +168,6 @@ int i915_gem_object_truncate(struct
> drm_i915_gem_object *obj)
>         return 0;
>  }
>  
> -/* Try to discard unwanted pages */
> -void i915_gem_object_writeback(struct drm_i915_gem_object *obj)
> -{
> -       assert_object_held_shared(obj);
> -       GEM_BUG_ON(i915_gem_object_has_pages(obj));
> -
> -       if (obj->ops->writeback)
> -               obj->ops->writeback(obj);
> -}
> -
>  static void __i915_gem_object_reset_page_iter(struct
> drm_i915_gem_object *obj)
>  {
>         struct radix_tree_iter iter;
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> index cc9fe258fba7..b4b8c921063e 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> @@ -283,54 +283,6 @@ shmem_truncate(struct drm_i915_gem_object *obj)
>         return 0;
>  }
>  
> -void __shmem_writeback(size_t size, struct address_space *mapping)
> -{
> -       struct writeback_control wbc = {
> -               .sync_mode = WB_SYNC_NONE,
> -               .nr_to_write = SWAP_CLUSTER_MAX,
> -               .range_start = 0,
> -               .range_end = LLONG_MAX,
> -               .for_reclaim = 1,
> -       };
> -       unsigned long i;
> -
> -       /*
> -        * Leave mmapings intact (GTT will have been revoked on
> unbinding,
> -        * leaving only CPU mmapings around) and add those pages to
> the LRU
> -        * instead of invoking writeback so they are aged and paged
> out
> -        * as normal.
> -        */
> -
> -       /* Begin writeback on each dirty page */
> -       for (i = 0; i < size >> PAGE_SHIFT; i++) {
> -               struct page *page;
> -
> -               page = find_lock_page(mapping, i);
> -               if (!page)
> -                       continue;
> -
> -               if (!page_mapped(page) &&
> clear_page_dirty_for_io(page)) {
> -                       int ret;
> -
> -                       SetPageReclaim(page);
> -                       ret = mapping->a_ops->writepage(page, &wbc);
> -                       if (!PageWriteback(page))
> -                               ClearPageReclaim(page);
> -                       if (!ret)
> -                               goto put;
> -               }
> -               unlock_page(page);
> -put:
> -               put_page(page);
> -       }
> -}
> -
> -static void
> -shmem_writeback(struct drm_i915_gem_object *obj)
> -{
> -       __shmem_writeback(obj->base.size, obj->base.filp->f_mapping);
> -}
> -
>  void
>  __i915_gem_object_release_shmem(struct drm_i915_gem_object *obj,
>                                 struct sg_table *pages,
> @@ -503,7 +455,6 @@ const struct drm_i915_gem_object_ops
> i915_gem_shmem_ops = {
>         .get_pages = shmem_get_pages,
>         .put_pages = shmem_put_pages,
>         .truncate = shmem_truncate,
> -       .writeback = shmem_writeback,
>  
>         .pwrite = shmem_pwrite,
>         .pread = shmem_pread,
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
> b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
> index 157a9765f483..99a38e016780 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
> @@ -55,12 +55,11 @@ static bool unsafe_drop_pages(struct
> drm_i915_gem_object *obj,
>         return false;
>  }
>  
> -static int try_to_writeback(struct drm_i915_gem_object *obj,
> unsigned int flags)
> +static int obj_invalidate(struct drm_i915_gem_object *obj, unsigned
> int flags)
>  {
>         if (obj->ops->shrinker_release_pages)
>                 return obj->ops->shrinker_release_pages(obj,
> -                                                       !(flags &
> I915_SHRINK_ACTIVE),
> -                                                       flags &
> I915_SHRINK_WRITEBACK);
> +                                                       !(flags &
> I915_SHRINK_ACTIVE));
>  
>         switch (obj->mm.madv) {
>         case I915_MADV_DONTNEED:
> @@ -70,8 +69,9 @@ static int try_to_writeback(struct
> drm_i915_gem_object *obj, unsigned int flags)
>                 return 0;
>         }
>  
> -       if (flags & I915_SHRINK_WRITEBACK)
> -               i915_gem_object_writeback(obj);
> +       if (obj->base.filp)
> +               invalidate_mapping_pages(file_inode(obj->base.filp)-
> >i_mapping,
> +                                        0, (loff_t)-1);
>  
>         return 0;
>  }
> @@ -227,7 +227,7 @@ i915_gem_shrink(struct i915_gem_ww_ctx *ww,
>                                 }
>  
>                                 if
> (!__i915_gem_object_put_pages(obj)) {
> -                                       if (!try_to_writeback(obj,
> shrink))
> +                                       if (!obj_invalidate(obj,
> shrink))
>                                                 count += obj-
> >base.size >> PAGE_SHIFT;
>                                 }
>                                 if (!ww)
> @@ -339,8 +339,7 @@ i915_gem_shrinker_scan(struct shrinker *shrinker,
> struct shrink_control *sc)
>                                                  &sc->nr_scanned,
>                                                  I915_SHRINK_ACTIVE |
>                                                  I915_SHRINK_BOUND |
> -                                                I915_SHRINK_UNBOUND
> |
> -                                               
> I915_SHRINK_WRITEBACK);
> +                                               
> I915_SHRINK_UNBOUND);
>                 }
>         }
>  
> @@ -361,8 +360,7 @@ i915_gem_shrinker_oom(struct notifier_block *nb,
> unsigned long event, void *ptr)
>         with_intel_runtime_pm(&i915->runtime_pm, wakeref)
>                 freed_pages += i915_gem_shrink(NULL, i915, -1UL,
> NULL,
>                                                I915_SHRINK_BOUND |
> -                                              I915_SHRINK_UNBOUND |
> -                                             
> I915_SHRINK_WRITEBACK);
> +                                              I915_SHRINK_UNBOUND);
>  
>         /* Because we may be allocating inside our own driver, we
> cannot
>          * assert that there are no objects with pinned pages that
> are not
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.h
> b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.h
> index 8512470f6fd6..789d6947f9b9 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.h
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.h
> @@ -22,7 +22,6 @@ unsigned long i915_gem_shrink(struct
> i915_gem_ww_ctx *ww,
>  #define I915_SHRINK_BOUND      BIT(1)
>  #define I915_SHRINK_ACTIVE     BIT(2)
>  #define I915_SHRINK_VMAPS      BIT(3)
> -#define I915_SHRINK_WRITEBACK  BIT(4)
>  
>  unsigned long i915_gem_shrink_all(struct drm_i915_private *i915);
>  void i915_gem_driver_register__shrinker(struct drm_i915_private
> *i915);
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
> b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
> index 218a9b3037c7..b7ca7b66afe7 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
> @@ -425,8 +425,7 @@ int i915_ttm_purge(struct drm_i915_gem_object
> *obj)
>  }
>  
>  static int i915_ttm_shrinker_release_pages(struct
> drm_i915_gem_object *obj,
> -                                          bool no_wait_gpu,
> -                                          bool should_writeback)
> +                                          bool no_wait_gpu)
>  {
>         struct ttm_buffer_object *bo = i915_gem_to_ttm(obj);
>         struct i915_ttm_tt *i915_tt =
> @@ -467,9 +466,6 @@ static int i915_ttm_shrinker_release_pages(struct
> drm_i915_gem_object *obj,
>                 return ret;
>         }
>  
> -       if (should_writeback)
> -               __shmem_writeback(obj->base.size, i915_tt->filp-
> >f_mapping);
> -
>         return 0;
>  }
>  
> diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
> b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
> index c69c7d45aabc..24bbf4d6a63d 100644
> --- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
> +++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
> @@ -1647,8 +1647,7 @@ static int igt_shrink_thp(void *arg)
>         i915_gem_shrink(NULL, i915, -1UL, NULL,
>                         I915_SHRINK_BOUND |
>                         I915_SHRINK_UNBOUND |
> -                       I915_SHRINK_ACTIVE |
> -                       I915_SHRINK_WRITEBACK);
> +                       I915_SHRINK_ACTIVE);
>         if (should_swap == i915_gem_object_has_pages(obj)) {
>                 pr_err("unexpected pages mismatch, should_swap=%s\n",
>                        yesno(should_swap));


