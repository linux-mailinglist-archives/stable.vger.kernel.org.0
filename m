Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD066505C3
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 00:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiLRXuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 18:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbiLRXug (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 18:50:36 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CDC63AB
        for <stable@vger.kernel.org>; Sun, 18 Dec 2022 15:50:33 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id v19-20020a9d5a13000000b0066e82a3872dso4547761oth.5
        for <stable@vger.kernel.org>; Sun, 18 Dec 2022 15:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MoAhorohdWLbJhBVy8IWApxJEGCwa7noGLJpkcJ1xxc=;
        b=i79NGUJaT6Ms9QCE3hN0lQiazETNR1M70XfxZi0VIXB7lz7fqCXUlI8e1YKPtCXcGa
         uhHHhZMYUgEYJnNdh62Mqjwaskym/6BJHenpEyPH+QTbuCg1f1e2itq7Hk68KP38bXlv
         lWLYypmYE07Djtt1PMH23RR4wkgL9TQdpeCIM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MoAhorohdWLbJhBVy8IWApxJEGCwa7noGLJpkcJ1xxc=;
        b=lr+O7jjGCLJBmvarZDZsoHAQQ7Dda+25xyBYuiarCbDiHhATx5b3iUTsk9Yxn7wLK5
         FPdn+Y88bCZPuv9vm/vLc7SEAF5M9/agt/ltqnGjj0+KIz2GmmSI1XiJo94W3FLkuo2B
         xBqLXHibkjJPZQ1gH9kqOebOK60da//p7SSxpPzkZZMoc/VRWiMe6OBZBxlNNiorlIAY
         t7FDbmEH8B7Y/ZHhZHWcLIHLmIjYg6tKMPo1a+y8RcK6Q4il9LMy9nGYRGeVcb/iPvYe
         ISXboJQFlsb78qRkFN9TiySOZyUXfwPp0g1bGdTzcZo403L44+UmHeHIhlVhgyX//qTG
         WXxg==
X-Gm-Message-State: ANoB5pn2a2b7EDsaJrFIv9mSYDS2cYC1HHwkIUZWUnMqAtnhCrw0AzVt
        1YSGMH8lD1itOqzbWD+J/bwX610aUPkYJKR3dCTtgw==
X-Google-Smtp-Source: AA0mqf5OWazahbWxtrD7JrItxhQu7BPNgYp7cbdxS3odR1UAQcC8qTnwvVWhdDyHr76diflvkrkHbOyTsV/Cc1KtkOA=
X-Received: by 2002:a05:6830:6311:b0:66d:334d:ba27 with SMTP id
 cg17-20020a056830631100b0066d334dba27mr40273743otb.7.1671407432851; Sun, 18
 Dec 2022 15:50:32 -0800 (PST)
MIME-Version: 1.0
References: <20221216113456.414183-1-matthew.auld@intel.com>
In-Reply-To: <20221216113456.414183-1-matthew.auld@intel.com>
From:   Mani Milani <mani@chromium.org>
Date:   Mon, 19 Dec 2022 10:50:21 +1100
Message-ID: <CAHzEqDn8Vyrsidv14tU6dwxxf4oP1S-ZgNW7MJiwhcJm6NJeAQ@mail.gmail.com>
Subject: Re: [PATCH v2] drm/i915: improve the catch-all evict to handle lock contention
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

Thank you for updating the docs Matthew. I am looking forward to this
patch landing.

On Fri, Dec 16, 2022 at 10:35 PM Matthew Auld <matthew.auld@intel.com> wrot=
e:
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
> v2 (Mani)
>   - Also revamp the docs for the different passes.
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
> Reviewed-by: Mani Milani <mani@chromium.org>
> Tested-by: Mani Milani <mani@chromium.org>
> ---
>  .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 59 +++++++++++++++----
>  drivers/gpu/drm/i915/gem/i915_gem_mman.c      |  2 +-
>  drivers/gpu/drm/i915/i915_gem_evict.c         | 37 ++++++++----
>  drivers/gpu/drm/i915/i915_gem_evict.h         |  4 +-
>  drivers/gpu/drm/i915/i915_vma.c               |  2 +-
>  .../gpu/drm/i915/selftests/i915_gem_evict.c   |  4 +-
>  6 files changed, 82 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu=
/drm/i915/gem/i915_gem_execbuffer.c
> index 192bb3f10733..f98600ca7557 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> @@ -733,32 +733,69 @@ static int eb_reserve(struct i915_execbuffer *eb)
>         bool unpinned;
>
>         /*
> -        * Attempt to pin all of the buffers into the GTT.
> -        * This is done in 2 phases:
> +        * We have one more buffers that we couldn't bind, which could be=
 due to
> +        * various reasons. To resolve this we have 4 passes, with every =
next
> +        * level turning the screws tighter:
>          *
> -        * 1. Unbind all objects that do not match the GTT constraints fo=
r
> -        *    the execbuffer (fenceable, mappable, alignment etc).
> -        * 2. Bind new objects.
> +        * 0. Unbind all objects that do not match the GTT constraints fo=
r the
> +        * execbuffer (fenceable, mappable, alignment etc). Bind all new
> +        * objects.  This avoids unnecessary unbinding of later objects i=
n order
> +        * to make room for the earlier objects *unless* we need to defra=
gment.
>          *
> -        * This avoid unnecessary unbinding of later objects in order to =
make
> -        * room for the earlier objects *unless* we need to defragment.
> +        * 1. Reorder the buffers, where objects with the most restrictiv=
e
> +        * placement requirements go first (ignoring fixed location buffe=
rs for
> +        * now).  For example, objects needing the mappable aperture (the=
 first
> +        * 256M of GTT), should go first vs objects that can be placed ju=
st
> +        * about anywhere. Repeat the previous pass.
>          *
> -        * Defragmenting is skipped if all objects are pinned at a fixed =
location.
> +        * 2. Consider buffers that are pinned at a fixed location. Also =
try to
> +        * evict the entire VM this time, leaving only objects that we we=
re
> +        * unable to lock. Try again to bind the buffers. (still using th=
e new
> +        * buffer order).
> +        *
> +        * 3. We likely have object lock contention for one or more stubb=
orn
> +        * objects in the VM, for which we need to evict to make forward
> +        * progress (perhaps we are fighting the shrinker?). When evictin=
g the
> +        * VM this time around, anything that we can't lock we now track =
using
> +        * the busy_bo, using the full lock (after dropping the vm->mutex=
 to
> +        * prevent deadlocks), instead of trylock. We then continue to ev=
ict the
> +        * VM, this time with the stubborn object locked, which we can no=
w
> +        * hopefully unbind (if still bound in the VM). Repeat until the =
VM is
> +        * evicted. Finally we should be able bind everything.
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
> +                               mutex_unlock(&eb->context->vm->mutex);
> +                       }
> +                       if (err)
> +                               return err;
> +               }
> +
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
>                                 mutex_unlock(&eb->context->vm->mutex);
> +                               if (err && busy_bo) {
> +                                       err =3D i915_gem_object_lock(busy=
_bo, &eb->ww);
> +                                       i915_gem_object_put(busy_bo);
> +                                       if (!err)
> +                                               goto retry;
> +                               }
>                         }
>                         if (err)
>                                 return err;
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
