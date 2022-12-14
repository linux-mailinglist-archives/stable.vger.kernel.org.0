Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01A364C2CD
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 04:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbiLNDc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 22:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiLNDc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 22:32:58 -0500
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C94B9C
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 19:32:57 -0800 (PST)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-14449b7814bso15112654fac.3
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 19:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yHKuHXmXIqmncHIFNewnNyGOQVnpLME4y5lTywUMmUk=;
        b=Iu/Hc6z/w8Rx2A1QwT0I+doPYM4ciizLkgSvRtRbtc1BuOzzBHi/Kq5Fsxg0990C8R
         9ocoxoyAjYLZhjdA8r5cQOv4XxK6J11/22y4x6+G7nsA+BGKYdSsv2tTIC9u30mblSnJ
         tS5rr7RoYF/lTrH4gnyAoxaEC7F1bQob7EfnI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yHKuHXmXIqmncHIFNewnNyGOQVnpLME4y5lTywUMmUk=;
        b=FfZV5qEBruBYlAgxcaKce7IyjlxzFmnsI18vCU/Z0gA+PVOjxT0Z8gUF5l1In3/jZM
         Lxx6ljOXJVUeJ48PteAW+Dz8xzlmjhQ3qwJ5fMQKh4Qd3dLXmThIkQkZJnqqewuGdTHL
         GCiPWekTyBqMuIXItQatDDX9ulkYzHRJIuCDMXA6VKlEnQz36E7Kx5Idpch79LTpo2Gn
         SyKystJxIHapazdykBcsBtinbp41CMLUp3mc+MBb0FByY9KQYDnCAOR+YrOqCMHSlN2P
         NODc29vzzz/jtLE2oFjGsJ+r9kbMY/TIhf5XZpKOz67K3ZrQDgPglE0iC+QLnUDoeEsS
         k7gw==
X-Gm-Message-State: AFqh2krK56Vs6B/HWQT4FUUfzM7st1JNDnO44Q66HbI5FNWu6VOGALY7
        p5DrK5d7tJvfgFKGGGfwEyLom7Ln3oPn2x69UjZuREOycS9Ngok4
X-Google-Smtp-Source: AA0mqf4e1lGTadTAJcBI1FuFpd7Pycdz8A94gV06+GlHuporV57kF5kIngoqeLtC8g+c1pb8yy1CWlG6AwoENE0s2tg=
X-Received: by 2002:a05:6870:638b:b0:144:96b3:5fd7 with SMTP id
 t11-20020a056870638b00b0014496b35fd7mr76194oap.173.1670988776811; Tue, 13 Dec
 2022 19:32:56 -0800 (PST)
MIME-Version: 1.0
References: <20221206161141.128921-1-matthew.auld@intel.com>
In-Reply-To: <20221206161141.128921-1-matthew.auld@intel.com>
From:   Mani Milani <mani@chromium.org>
Date:   Wed, 14 Dec 2022 14:32:45 +1100
Message-ID: <CAHzEqDkd5u5A+2EfeVpnMoqHLWS=d5uLQquGDQ5TLAcx8Oydqw@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: improve the catch-all evict to handle lock contention
To:     Matthew Auld <matthew.auld@intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thank you for the patch.

I briefly tested this patch and it does fix my original problem of
"user-space application crashing due to receiving an -ENOSPC". Once
the code is reviewed, I can test it further and report back.

However, there are a few changes in this patch that change the code
behaviour, which I do not understand. I must admit that I am not very
familiar with this code, but I decided to raise these points anyway, I
hope that is OK.
Please find my comments inline below:

On Wed, Dec 7, 2022 at 3:11 AM Matthew Auld <matthew.auld@intel.com> wrote:
>
> The catch-all evict can fail due to object lock contention, since it
> only goes as far as trylocking the object, due to us already holding the
> vm->mutex. Doing a full object lock here can deadlock, since the
> vm->mutex is always our inner lock. Add another execbuf pass which drops
> the vm->mutex and then tries to grab the object will the full lock,
> before then retrying the eviction. This should be good enough for now to
> fix the immediate regression with userspace seeing -ENOSPC from execbuf
> due to contended object locks during GTT eviction.
>
> Testcase: igt@gem_ppgtt@shrink-vs-evict-*
> Fixes: 7e00897be8bf ("drm/i915: Add object locking to i915_gem_evict_for_=
node and i915_gem_evict_something, v2.")
> References: https://gitlab.freedesktop.org/drm/intel/-/issues/7627
> References: https://gitlab.freedesktop.org/drm/intel/-/issues/7570
> References: https://bugzilla.mozilla.org/show_bug.cgi?id=3D1779558
> Signed-off-by: Matthew Auld <matthew.auld@intel.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> Cc: Andrzej Hajda <andrzej.hajda@intel.com>
> Cc: Mani Milani <mani@chromium.org>
> Cc: <stable@vger.kernel.org> # v5.18+
> ---
>  .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 25 +++++++++++--
>  drivers/gpu/drm/i915/gem/i915_gem_mman.c      |  2 +-
>  drivers/gpu/drm/i915/i915_gem_evict.c         | 37 ++++++++++++++-----
>  drivers/gpu/drm/i915/i915_gem_evict.h         |  4 +-
>  drivers/gpu/drm/i915/i915_vma.c               |  2 +-
>  .../gpu/drm/i915/selftests/i915_gem_evict.c   |  4 +-
>  6 files changed, 56 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu=
/drm/i915/gem/i915_gem_execbuffer.c
> index 86956b902c97..e2ce1e4e9723 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> @@ -745,25 +745,44 @@ static int eb_reserve(struct i915_execbuffer *eb)
>          *
>          * Defragmenting is skipped if all objects are pinned at a fixed =
location.
>          */
> -       for (pass =3D 0; pass <=3D 2; pass++) {
> +       for (pass =3D 0; pass <=3D 3; pass++) {
>                 int pin_flags =3D PIN_USER | PIN_VALIDATE;
>
>                 if (pass =3D=3D 0)
>                         pin_flags |=3D PIN_NONBLOCK;
>
>                 if (pass >=3D 1)
> -                       unpinned =3D eb_unbind(eb, pass =3D=3D 2);
> +                       unpinned =3D eb_unbind(eb, pass >=3D 2);
>
>                 if (pass =3D=3D 2) {
>                         err =3D mutex_lock_interruptible(&eb->context->vm=
->mutex);
>                         if (!err) {
> -                               err =3D i915_gem_evict_vm(eb->context->vm=
, &eb->ww);
> +                               err =3D i915_gem_evict_vm(eb->context->vm=
, &eb->ww, NULL);
>                                 mutex_unlock(&eb->context->vm->mutex);
>                         }
>                         if (err)
>                                 return err;
>                 }
>
> +               if (pass =3D=3D 3) {
> +retry:
> +                       err =3D mutex_lock_interruptible(&eb->context->vm=
->mutex);
> +                       if (!err) {
> +                               struct drm_i915_gem_object *busy_bo =3D N=
ULL;
> +
> +                               err =3D i915_gem_evict_vm(eb->context->vm=
, &eb->ww, &busy_bo);
> +                               mutex_unlock(&eb->context->vm->mutex);
> +                               if (err && busy_bo) {
> +                                       err =3D i915_gem_object_lock(busy=
_bo, &eb->ww);
> +                                       i915_gem_object_put(busy_bo);
> +                                       if (!err)
> +                                               goto retry;
Could we possibly get stuck in a never-ending 'retry' loop here?

> +                               }
> +                       }
> +                       if (err)
> +                               return err;
> +               }
> +
>                 list_for_each_entry(ev, &eb->unbound, bind_link) {
>                         err =3D eb_reserve_vma(eb, ev, pin_flags);
>                         if (err)
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i=
915/gem/i915_gem_mman.c
> index d73ba0f5c4c5..4f69bff63068 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
> @@ -369,7 +369,7 @@ static vm_fault_t vm_fault_gtt(struct vm_fault *vmf)
>                 if (vma =3D=3D ERR_PTR(-ENOSPC)) {
>                         ret =3D mutex_lock_interruptible(&ggtt->vm.mutex)=
;
>                         if (!ret) {
> -                               ret =3D i915_gem_evict_vm(&ggtt->vm, &ww)=
;
> +                               ret =3D i915_gem_evict_vm(&ggtt->vm, &ww,=
 NULL);
>                                 mutex_unlock(&ggtt->vm.mutex);
>                         }
>                         if (ret)
> diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i915=
/i915_gem_evict.c
> index 4cfe36b0366b..c02ebd6900ae 100644
> --- a/drivers/gpu/drm/i915/i915_gem_evict.c
> +++ b/drivers/gpu/drm/i915/i915_gem_evict.c
> @@ -441,6 +441,11 @@ int i915_gem_evict_for_node(struct i915_address_spac=
e *vm,
>   * @vm: Address space to cleanse
>   * @ww: An optional struct i915_gem_ww_ctx. If not NULL, i915_gem_evict_=
vm
>   * will be able to evict vma's locked by the ww as well.
> + * @busy_bo: Optional pointer to struct drm_i915_gem_object. If not NULL=
, then
> + * in the event i915_gem_evict_vm() is unable to trylock an object for e=
viction,
> + * then @busy_bo will point to it. -EBUSY is also returned. The caller m=
ust drop
> + * the vm->mutex, before trying again to acquire the contended lock. The=
 caller
> + * also owns a reference to the object.
>   *
>   * This function evicts all vmas from a vm.
>   *
> @@ -450,7 +455,8 @@ int i915_gem_evict_for_node(struct i915_address_space=
 *vm,
>   * To clarify: This is for freeing up virtual address space, not for fre=
eing
>   * memory in e.g. the shrinker.
>   */
> -int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_=
ctx *ww)
> +int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_=
ctx *ww,
> +                     struct drm_i915_gem_object **busy_bo)
>  {
>         int ret =3D 0;
>
> @@ -482,15 +488,22 @@ int i915_gem_evict_vm(struct i915_address_space *vm=
, struct i915_gem_ww_ctx *ww)
>                          * the resv is shared among multiple objects, we =
still
>                          * need the object ref.
>                          */
> -                       if (dying_vma(vma) ||
> +                       if (!i915_gem_object_get_rcu(vma->obj) ||
>                             (ww && (dma_resv_locking_ctx(vma->obj->base.r=
esv) =3D=3D &ww->ctx))) {
>                                 __i915_vma_pin(vma);
>                                 list_add(&vma->evict_link, &locked_evicti=
on_list);
>                                 continue;
>                         }
>
> -                       if (!i915_gem_object_trylock(vma->obj, ww))
> +                       if (!i915_gem_object_trylock(vma->obj, ww)) {
> +                               if (busy_bo) {
> +                                       *busy_bo =3D vma->obj; /* holds r=
ef */
> +                                       ret =3D -EBUSY;
> +                                       break;
> +                               }
> +                               i915_gem_object_put(vma->obj);
If the 'trylock' above fails and 'busy_bo' is NULL, then the code
reaches here twice for every call of this function. This means the
'i915_gem_object_put()' above gets called twice, as opposed to the
previous behaviour where it was never called. I wonder why the change?

>                                 continue;
> +                       }
>
>                         __i915_vma_pin(vma);
>                         list_add(&vma->evict_link, &eviction_list);
> @@ -498,25 +511,29 @@ int i915_gem_evict_vm(struct i915_address_space *vm=
, struct i915_gem_ww_ctx *ww)
>                 if (list_empty(&eviction_list) && list_empty(&locked_evic=
tion_list))
>                         break;
>
> -               ret =3D 0;
I don't understand why the line above is removed? This causes the
inconsistencies I have explained in my comments further down.
Whereas if we keep this line, then all the vma's already in
'locked_eviction_list' and 'eviction_list' lists get evicted normally,
and with 'trylock' failing again on the consecutive loop iteration(s)
where the eviction lists are empty, we will return with the correct
-EBUSY code anyway.

>                 /* Unbind locked objects first, before unlocking the evic=
tion_list */
>                 list_for_each_entry_safe(vma, vn, &locked_eviction_list, =
evict_link) {
>                         __i915_vma_unpin(vma);
>
> -                       if (ret =3D=3D 0)
> +                       if (ret =3D=3D 0) {
>                                 ret =3D __i915_vma_unbind(vma);
> -                       if (ret !=3D -EINTR) /* "Get me out of here!" */
> -                               ret =3D 0;
> +                               if (ret !=3D -EINTR) /* "Get me out of he=
re!" */
> +                                       ret =3D 0;
> +                       }
> +                       if (!dying_vma(vma))
> +                               i915_gem_object_put(vma->obj);
If 'busy_bo' !=3D NULL and the 'trylock' above fails resulting in 'ret'
=3D -EBUSY, then for vma's prior to that, we end up calling
'i915_gem_object_put()' without calling '__i915_vma_unbind()'.
IIUC, this means we effectively end up calling 'i915_gem_object_put()'
twice for vma's appearing before 'trylock' failure in the list, and
only once for vma's appearing after. This:
1. Does not seem correct!
2. Is different from previous code behaviour.
Why the change?

>                 }
>
>                 list_for_each_entry_safe(vma, vn, &eviction_list, evict_l=
ink) {
>                         __i915_vma_unpin(vma);
> -                       if (ret =3D=3D 0)
> +                       if (ret =3D=3D 0) {
>                                 ret =3D __i915_vma_unbind(vma);
> -                       if (ret !=3D -EINTR) /* "Get me out of here!" */
> -                               ret =3D 0;
> +                               if (ret !=3D -EINTR) /* "Get me out of he=
re!" */
> +                                       ret =3D 0;
> +                       }
>
>                         i915_gem_object_unlock(vma->obj);
> +                       i915_gem_object_put(vma->obj);
Same as my previous comment above.

>                 }
>         } while (ret =3D=3D 0);
>
> diff --git a/drivers/gpu/drm/i915/i915_gem_evict.h b/drivers/gpu/drm/i915=
/i915_gem_evict.h
> index e593c530f9bd..bf0ee0e4fe60 100644
> --- a/drivers/gpu/drm/i915/i915_gem_evict.h
> +++ b/drivers/gpu/drm/i915/i915_gem_evict.h
> @@ -11,6 +11,7 @@
>  struct drm_mm_node;
>  struct i915_address_space;
>  struct i915_gem_ww_ctx;
> +struct drm_i915_gem_object;
>
>  int __must_check i915_gem_evict_something(struct i915_address_space *vm,
>                                           struct i915_gem_ww_ctx *ww,
> @@ -23,6 +24,7 @@ int __must_check i915_gem_evict_for_node(struct i915_ad=
dress_space *vm,
>                                          struct drm_mm_node *node,
>                                          unsigned int flags);
>  int i915_gem_evict_vm(struct i915_address_space *vm,
> -                     struct i915_gem_ww_ctx *ww);
> +                     struct i915_gem_ww_ctx *ww,
> +                     struct drm_i915_gem_object **busy_bo);
>
>  #endif /* __I915_GEM_EVICT_H__ */
> diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_=
vma.c
> index 34f0e6c923c2..7d044888ac33 100644
> --- a/drivers/gpu/drm/i915/i915_vma.c
> +++ b/drivers/gpu/drm/i915/i915_vma.c
> @@ -1599,7 +1599,7 @@ static int __i915_ggtt_pin(struct i915_vma *vma, st=
ruct i915_gem_ww_ctx *ww,
>                          * locked objects when called from execbuf when p=
inning
>                          * is removed. This would probably regress badly.
>                          */
> -                       i915_gem_evict_vm(vm, NULL);
> +                       i915_gem_evict_vm(vm, NULL, NULL);
>                         mutex_unlock(&vm->mutex);
>                 }
>         } while (1);
> diff --git a/drivers/gpu/drm/i915/selftests/i915_gem_evict.c b/drivers/gp=
u/drm/i915/selftests/i915_gem_evict.c
> index 8c6517d29b8e..37068542aafe 100644
> --- a/drivers/gpu/drm/i915/selftests/i915_gem_evict.c
> +++ b/drivers/gpu/drm/i915/selftests/i915_gem_evict.c
> @@ -344,7 +344,7 @@ static int igt_evict_vm(void *arg)
>
>         /* Everything is pinned, nothing should happen */
>         mutex_lock(&ggtt->vm.mutex);
> -       err =3D i915_gem_evict_vm(&ggtt->vm, NULL);
> +       err =3D i915_gem_evict_vm(&ggtt->vm, NULL, NULL);
>         mutex_unlock(&ggtt->vm.mutex);
>         if (err) {
>                 pr_err("i915_gem_evict_vm on a full GGTT returned err=3D%=
d]\n",
> @@ -356,7 +356,7 @@ static int igt_evict_vm(void *arg)
>
>         for_i915_gem_ww(&ww, err, false) {
>                 mutex_lock(&ggtt->vm.mutex);
> -               err =3D i915_gem_evict_vm(&ggtt->vm, &ww);
> +               err =3D i915_gem_evict_vm(&ggtt->vm, &ww, NULL);
>                 mutex_unlock(&ggtt->vm.mutex);
>         }
>
> --
> 2.38.1
>
