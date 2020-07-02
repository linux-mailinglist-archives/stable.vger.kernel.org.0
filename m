Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21E1212DF1
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 22:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgGBUi6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 2 Jul 2020 16:38:58 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:54534 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725937AbgGBUi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 16:38:58 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 21695362-1500050 
        for multiple; Thu, 02 Jul 2020 21:38:40 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200702202545.GA1969@jack.zhora.eu>
References: <20200702083225.20044-1-chris@chris-wilson.co.uk> <20200702202545.GA1969@jack.zhora.eu>
Subject: Re: [Intel-gfx] [PATCH 01/23] drm/i915: Drop vm.ref for duplicate vma on construction
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        andi@etezian.org, andi.shyti@intel.com
To:     Andi Shyti <andi@etezian.org>
Date:   Thu, 02 Jul 2020 21:38:41 +0100
Message-ID: <159372232179.22925.7779642345726039521@build.alporthouse.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Andi Shyti (2020-07-02 21:25:45)
> Hi Chris,
> 
> > diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
> > index 1f63c4a1f055..7fe1f317cd2b 100644
> > --- a/drivers/gpu/drm/i915/i915_vma.c
> > +++ b/drivers/gpu/drm/i915/i915_vma.c
> > @@ -198,6 +198,7 @@ vma_create(struct drm_i915_gem_object *obj,
> >               cmp = i915_vma_compare(pos, vm, view);
> >               if (cmp == 0) {
> >                       spin_unlock(&obj->vma.lock);
> > +                     i915_vm_put(vm);
> >                       i915_vma_free(vma);
> 
> You are forgettin one return without dereferencing it.
> 
> would this be a solution:
> 
> @@ -106,6 +106,7 @@ vma_create(struct drm_i915_gem_object *obj,
>  {
>         struct i915_vma *vma;
>         struct rb_node *rb, **p;
> +       struct i915_vma *pos = ERR_PTR(-E2BIG);
>  
>         /* The aliasing_ppgtt should never be used directly! */
>         GEM_BUG_ON(vm == &vm->gt->ggtt->alias->vm);
> @@ -185,7 +186,6 @@ vma_create(struct drm_i915_gem_object *obj,
>         rb = NULL;
>         p = &obj->vma.tree.rb_node;
>         while (*p) {
> -               struct i915_vma *pos;
>                 long cmp;
>  
>                 rb = *p;
> @@ -197,12 +197,8 @@ vma_create(struct drm_i915_gem_object *obj,
>                  * and dispose of ours.
>                  */
>                 cmp = i915_vma_compare(pos, vm, view);
> -               if (cmp == 0) {
> -                       spin_unlock(&obj->vma.lock);
> -                       i915_vm_put(vm);
> -                       i915_vma_free(vma);
> -                       return pos;
> -               }
> +               if (!cmp)
> +                       goto err_unlock;

Yeah, but you might as well do

if (cmp < 0)
 	p = right;
else if (cmp > 0)
 	p = left;
else
	goto err_unlock;
 
>                 if (cmp < 0)
>                         p = &rb->rb_right;
> @@ -230,8 +226,9 @@ vma_create(struct drm_i915_gem_object *obj,
>  err_unlock:
>         spin_unlock(&obj->vma.lock);
>  err_vma:
> +       i915_vm_put(vm);
>         i915_vma_free(vma);
> -       return ERR_PTR(-E2BIG);
> +       return pos;
>  }
> 
> Andi

Ta, going to send that as a patch?
-Chris
