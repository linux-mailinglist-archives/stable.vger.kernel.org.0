Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04DD864C85A
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 12:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiLNLrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 06:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237942AbiLNLrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 06:47:12 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810C1F4
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 03:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671018430; x=1702554430;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iJAT49p4bDPZaDkT2AKkRc3cw9FJtcOKyc44kCq9u/A=;
  b=PR/oL53BFH6k8Apnp1tYpcHHWslKk0wI1HWGhT1k4Lf9KP8BzCy/9Ode
   v3I2DKlGxjcwGHGWm3RinqElNdKQyKEyuzMvTN5qoss73zfgG650fCrak
   1IWluPnB+vLtzG2iGuvlZdJqqYwm8xfRsO9xkgADLo/zd1pIbwaG8VSSZ
   iIVjwAV6Q5isiGTl6NTVHrBX6M6df20ikj4C2zgDsQgN1vBH+F3Rec1Mz
   yaqausqLYH9aW/roSj+HcnfOfQ6nGurJ/zkZtZz9c+FdGGZYmgA1UTbXe
   uDmPkvwlm8wmMP3kSQN9vBjfETkBD73X35SD+3HGXR7y5Qwe3zvAE13Ma
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="380585490"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="380585490"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 03:47:10 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="977805308"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="977805308"
Received: from msivosuo-mobl1.ger.corp.intel.com (HELO [10.252.20.193]) ([10.252.20.193])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 03:47:07 -0800
Message-ID: <db6eccfa-4536-0212-c9a9-4a0ea6e4c877@intel.com>
Date:   Wed, 14 Dec 2022 11:47:05 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH] drm/i915: improve the catch-all evict to handle lock
 contention
Content-Language: en-GB
To:     Mani Milani <mani@chromium.org>
Cc:     intel-gfx@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>, stable@vger.kernel.org
References: <20221206161141.128921-1-matthew.auld@intel.com>
 <CAHzEqDkd5u5A+2EfeVpnMoqHLWS=d5uLQquGDQ5TLAcx8Oydqw@mail.gmail.com>
From:   Matthew Auld <matthew.auld@intel.com>
In-Reply-To: <CAHzEqDkd5u5A+2EfeVpnMoqHLWS=d5uLQquGDQ5TLAcx8Oydqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14/12/2022 03:32, Mani Milani wrote:
> Thank you for the patch.
> 
> I briefly tested this patch and it does fix my original problem of
> "user-space application crashing due to receiving an -ENOSPC". Once
> the code is reviewed, I can test it further and report back.
> 
> However, there are a few changes in this patch that change the code
> behaviour, which I do not understand. I must admit that I am not very
> familiar with this code, but I decided to raise these points anyway, I
> hope that is OK.

Thanks a lot for taking a look.

> Please find my comments inline below:
> 
> On Wed, Dec 7, 2022 at 3:11 AM Matthew Auld <matthew.auld@intel.com> wrote:
>>
>> The catch-all evict can fail due to object lock contention, since it
>> only goes as far as trylocking the object, due to us already holding the
>> vm->mutex. Doing a full object lock here can deadlock, since the
>> vm->mutex is always our inner lock. Add another execbuf pass which drops
>> the vm->mutex and then tries to grab the object will the full lock,
>> before then retrying the eviction. This should be good enough for now to
>> fix the immediate regression with userspace seeing -ENOSPC from execbuf
>> due to contended object locks during GTT eviction.
>>
>> Testcase: igt@gem_ppgtt@shrink-vs-evict-*
>> Fixes: 7e00897be8bf ("drm/i915: Add object locking to i915_gem_evict_for_node and i915_gem_evict_something, v2.")
>> References: https://gitlab.freedesktop.org/drm/intel/-/issues/7627
>> References: https://gitlab.freedesktop.org/drm/intel/-/issues/7570
>> References: https://bugzilla.mozilla.org/show_bug.cgi?id=1779558
>> Signed-off-by: Matthew Auld <matthew.auld@intel.com>
>> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
>> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
>> Cc: Andrzej Hajda <andrzej.hajda@intel.com>
>> Cc: Mani Milani <mani@chromium.org>
>> Cc: <stable@vger.kernel.org> # v5.18+
>> ---
>>   .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 25 +++++++++++--
>>   drivers/gpu/drm/i915/gem/i915_gem_mman.c      |  2 +-
>>   drivers/gpu/drm/i915/i915_gem_evict.c         | 37 ++++++++++++++-----
>>   drivers/gpu/drm/i915/i915_gem_evict.h         |  4 +-
>>   drivers/gpu/drm/i915/i915_vma.c               |  2 +-
>>   .../gpu/drm/i915/selftests/i915_gem_evict.c   |  4 +-
>>   6 files changed, 56 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
>> index 86956b902c97..e2ce1e4e9723 100644
>> --- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
>> +++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
>> @@ -745,25 +745,44 @@ static int eb_reserve(struct i915_execbuffer *eb)
>>           *
>>           * Defragmenting is skipped if all objects are pinned at a fixed location.
>>           */
>> -       for (pass = 0; pass <= 2; pass++) {
>> +       for (pass = 0; pass <= 3; pass++) {
>>                  int pin_flags = PIN_USER | PIN_VALIDATE;
>>
>>                  if (pass == 0)
>>                          pin_flags |= PIN_NONBLOCK;
>>
>>                  if (pass >= 1)
>> -                       unpinned = eb_unbind(eb, pass == 2);
>> +                       unpinned = eb_unbind(eb, pass >= 2);
>>
>>                  if (pass == 2) {
>>                          err = mutex_lock_interruptible(&eb->context->vm->mutex);
>>                          if (!err) {
>> -                               err = i915_gem_evict_vm(eb->context->vm, &eb->ww);
>> +                               err = i915_gem_evict_vm(eb->context->vm, &eb->ww, NULL);
>>                                  mutex_unlock(&eb->context->vm->mutex);
>>                          }
>>                          if (err)
>>                                  return err;
>>                  }
>>
>> +               if (pass == 3) {
>> +retry:
>> +                       err = mutex_lock_interruptible(&eb->context->vm->mutex);
>> +                       if (!err) {
>> +                               struct drm_i915_gem_object *busy_bo = NULL;
>> +
>> +                               err = i915_gem_evict_vm(eb->context->vm, &eb->ww, &busy_bo);
>> +                               mutex_unlock(&eb->context->vm->mutex);
>> +                               if (err && busy_bo) {
>> +                                       err = i915_gem_object_lock(busy_bo, &eb->ww);
>> +                                       i915_gem_object_put(busy_bo);
>> +                                       if (!err)
>> +                                               goto retry;
> Could we possibly get stuck in a never-ending 'retry' loop here?

Each time we encounter a contended object lock we do the backoff here, 
drop the vm->mutex and retry the lock with the full lock. When 
re-entering evict_vm() that is one less object we need to lock again (we 
don't drop it until we destroy the ww ctx). The number of objects in a 
VM is finite (hopefully not too many for normal workloads).

Note that in in evict_vm() there is: 
dma_resv_locking_ctx(vma->obj->base.resv) == &ww->ctx, which returns 
true if we have already locked this object, with the given ww ctx (so 
eb->ww here).

> 
>> +                               }
>> +                       }
>> +                       if (err)
>> +                               return err;
>> +               }
>> +
>>                  list_for_each_entry(ev, &eb->unbound, bind_link) {
>>                          err = eb_reserve_vma(eb, ev, pin_flags);
>>                          if (err)
>> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
>> index d73ba0f5c4c5..4f69bff63068 100644
>> --- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
>> +++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
>> @@ -369,7 +369,7 @@ static vm_fault_t vm_fault_gtt(struct vm_fault *vmf)
>>                  if (vma == ERR_PTR(-ENOSPC)) {
>>                          ret = mutex_lock_interruptible(&ggtt->vm.mutex);
>>                          if (!ret) {
>> -                               ret = i915_gem_evict_vm(&ggtt->vm, &ww);
>> +                               ret = i915_gem_evict_vm(&ggtt->vm, &ww, NULL);
>>                                  mutex_unlock(&ggtt->vm.mutex);
>>                          }
>>                          if (ret)
>> diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i915/i915_gem_evict.c
>> index 4cfe36b0366b..c02ebd6900ae 100644
>> --- a/drivers/gpu/drm/i915/i915_gem_evict.c
>> +++ b/drivers/gpu/drm/i915/i915_gem_evict.c
>> @@ -441,6 +441,11 @@ int i915_gem_evict_for_node(struct i915_address_space *vm,
>>    * @vm: Address space to cleanse
>>    * @ww: An optional struct i915_gem_ww_ctx. If not NULL, i915_gem_evict_vm
>>    * will be able to evict vma's locked by the ww as well.
>> + * @busy_bo: Optional pointer to struct drm_i915_gem_object. If not NULL, then
>> + * in the event i915_gem_evict_vm() is unable to trylock an object for eviction,
>> + * then @busy_bo will point to it. -EBUSY is also returned. The caller must drop
>> + * the vm->mutex, before trying again to acquire the contended lock. The caller
>> + * also owns a reference to the object.
>>    *
>>    * This function evicts all vmas from a vm.
>>    *
>> @@ -450,7 +455,8 @@ int i915_gem_evict_for_node(struct i915_address_space *vm,
>>    * To clarify: This is for freeing up virtual address space, not for freeing
>>    * memory in e.g. the shrinker.
>>    */
>> -int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww)
>> +int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww,
>> +                     struct drm_i915_gem_object **busy_bo)
>>   {
>>          int ret = 0;
>>
>> @@ -482,15 +488,22 @@ int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww)
>>                           * the resv is shared among multiple objects, we still
>>                           * need the object ref.
>>                           */
>> -                       if (dying_vma(vma) ||
>> +                       if (!i915_gem_object_get_rcu(vma->obj) ||
>>                              (ww && (dma_resv_locking_ctx(vma->obj->base.resv) == &ww->ctx))) {
>>                                  __i915_vma_pin(vma);
>>                                  list_add(&vma->evict_link, &locked_eviction_list);
>>                                  continue;
>>                          }
>>
>> -                       if (!i915_gem_object_trylock(vma->obj, ww))
>> +                       if (!i915_gem_object_trylock(vma->obj, ww)) {
>> +                               if (busy_bo) {
>> +                                       *busy_bo = vma->obj; /* holds ref */
>> +                                       ret = -EBUSY;
>> +                                       break;
>> +                               }
>> +                               i915_gem_object_put(vma->obj);
> If the 'trylock' above fails and 'busy_bo' is NULL, then the code
> reaches here twice for every call of this function. This means the
> 'i915_gem_object_put()' above gets called twice, as opposed to the
> previous behaviour where it was never called. I wonder why the change?

We now do i915_gem_object_get_rcu() above (still returns false if 
dying), since busy_bo will need a reference to the BO to keep it alive, 
when returning from evict_vm(). If busy_bo is NULL we just drop that 
reference here to keep it all balanced.

> 
>>                                  continue;
>> +                       }
>>
>>                          __i915_vma_pin(vma);
>>                          list_add(&vma->evict_link, &eviction_list);
>> @@ -498,25 +511,29 @@ int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww)
>>                  if (list_empty(&eviction_list) && list_empty(&locked_eviction_list))
>>                          break;
>>
>> -               ret = 0;
> I don't understand why the line above is removed? This causes the
> inconsistencies I have explained in my comments further down.
> Whereas if we keep this line, then all the vma's already in
> 'locked_eviction_list' and 'eviction_list' lists get evicted normally,
> and with 'trylock' failing again on the consecutive loop iteration(s)
> where the eviction lists are empty, we will return with the correct
> -EBUSY code anyway.

Ignoring this patch, the ret = 0 here looks to not be needed. The only 
time ret is non zero is below when unbinding stuff, and here the "while 
(ret == 0)" at the end will catch that and bail anyway. So this 
shouldn't have any change in behaviour AFAICT.

With this patch I just want to set ret = -EBUSY and eventually return 
that to the caller, and setting ret = 0 here gets in the way.

> 
>>                  /* Unbind locked objects first, before unlocking the eviction_list */
>>                  list_for_each_entry_safe(vma, vn, &locked_eviction_list, evict_link) {
>>                          __i915_vma_unpin(vma);
>>
>> -                       if (ret == 0)
>> +                       if (ret == 0) {
>>                                  ret = __i915_vma_unbind(vma);
>> -                       if (ret != -EINTR) /* "Get me out of here!" */
>> -                               ret = 0;
>> +                               if (ret != -EINTR) /* "Get me out of here!" */
>> +                                       ret = 0;
>> +                       }
>> +                       if (!dying_vma(vma))
>> +                               i915_gem_object_put(vma->obj);
> If 'busy_bo' != NULL and the 'trylock' above fails resulting in 'ret'
> = -EBUSY, then for vma's prior to that, we end up calling
> 'i915_gem_object_put()' without calling '__i915_vma_unbind()'.
> IIUC, this means we effectively end up calling 'i915_gem_object_put()'
> twice for vma's appearing before 'trylock' failure in the list, and
> only once for vma's appearing after. This:

The unbind() here just nukes the GPU page-tables for this VMA (once we 
are sure the GPU is not still accessing them) and deletes the drm_mm 
node from the VM, so the next user can use that GPU address/range. I 
guess we could still do the unbind with -EBUSY, but not doing it 
shouldn't break anything.

> 1. Does not seem correct!
> 2. Is different from previous code behaviour.
> Why the change?

Above we do i915_gem_object_get_rcu(), so this is just balancing that. 
We get here either because the object is dying, in which case we don't 
have or need a reference (or lock it seems). If it's not dying then we 
already locked it, either because of the new retry thing added in this 
patch, or if the object was locked as part of the execbuf. We also hold 
a ref in that case.

> 
>>                  }
>>
>>                  list_for_each_entry_safe(vma, vn, &eviction_list, evict_link) {
>>                          __i915_vma_unpin(vma);
>> -                       if (ret == 0)
>> +                       if (ret == 0) {
>>                                  ret = __i915_vma_unbind(vma);
>> -                       if (ret != -EINTR) /* "Get me out of here!" */
>> -                               ret = 0;
>> +                               if (ret != -EINTR) /* "Get me out of here!" */
>> +                                       ret = 0;
>> +                       }
>>
>>                          i915_gem_object_unlock(vma->obj);
>> +                       i915_gem_object_put(vma->obj);
> Same as my previous comment above.
> 
>>                  }
>>          } while (ret == 0);
>>
>> diff --git a/drivers/gpu/drm/i915/i915_gem_evict.h b/drivers/gpu/drm/i915/i915_gem_evict.h
>> index e593c530f9bd..bf0ee0e4fe60 100644
>> --- a/drivers/gpu/drm/i915/i915_gem_evict.h
>> +++ b/drivers/gpu/drm/i915/i915_gem_evict.h
>> @@ -11,6 +11,7 @@
>>   struct drm_mm_node;
>>   struct i915_address_space;
>>   struct i915_gem_ww_ctx;
>> +struct drm_i915_gem_object;
>>
>>   int __must_check i915_gem_evict_something(struct i915_address_space *vm,
>>                                            struct i915_gem_ww_ctx *ww,
>> @@ -23,6 +24,7 @@ int __must_check i915_gem_evict_for_node(struct i915_address_space *vm,
>>                                           struct drm_mm_node *node,
>>                                           unsigned int flags);
>>   int i915_gem_evict_vm(struct i915_address_space *vm,
>> -                     struct i915_gem_ww_ctx *ww);
>> +                     struct i915_gem_ww_ctx *ww,
>> +                     struct drm_i915_gem_object **busy_bo);
>>
>>   #endif /* __I915_GEM_EVICT_H__ */
>> diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
>> index 34f0e6c923c2..7d044888ac33 100644
>> --- a/drivers/gpu/drm/i915/i915_vma.c
>> +++ b/drivers/gpu/drm/i915/i915_vma.c
>> @@ -1599,7 +1599,7 @@ static int __i915_ggtt_pin(struct i915_vma *vma, struct i915_gem_ww_ctx *ww,
>>                           * locked objects when called from execbuf when pinning
>>                           * is removed. This would probably regress badly.
>>                           */
>> -                       i915_gem_evict_vm(vm, NULL);
>> +                       i915_gem_evict_vm(vm, NULL, NULL);
>>                          mutex_unlock(&vm->mutex);
>>                  }
>>          } while (1);
>> diff --git a/drivers/gpu/drm/i915/selftests/i915_gem_evict.c b/drivers/gpu/drm/i915/selftests/i915_gem_evict.c
>> index 8c6517d29b8e..37068542aafe 100644
>> --- a/drivers/gpu/drm/i915/selftests/i915_gem_evict.c
>> +++ b/drivers/gpu/drm/i915/selftests/i915_gem_evict.c
>> @@ -344,7 +344,7 @@ static int igt_evict_vm(void *arg)
>>
>>          /* Everything is pinned, nothing should happen */
>>          mutex_lock(&ggtt->vm.mutex);
>> -       err = i915_gem_evict_vm(&ggtt->vm, NULL);
>> +       err = i915_gem_evict_vm(&ggtt->vm, NULL, NULL);
>>          mutex_unlock(&ggtt->vm.mutex);
>>          if (err) {
>>                  pr_err("i915_gem_evict_vm on a full GGTT returned err=%d]\n",
>> @@ -356,7 +356,7 @@ static int igt_evict_vm(void *arg)
>>
>>          for_i915_gem_ww(&ww, err, false) {
>>                  mutex_lock(&ggtt->vm.mutex);
>> -               err = i915_gem_evict_vm(&ggtt->vm, &ww);
>> +               err = i915_gem_evict_vm(&ggtt->vm, &ww, NULL);
>>                  mutex_unlock(&ggtt->vm.mutex);
>>          }
>>
>> --
>> 2.38.1
>>
