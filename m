Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F22F212EF9
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 23:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgGBVlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 17:41:08 -0400
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:46689 "EHLO
        4.mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgGBVlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 17:41:07 -0400
X-Greylist: delayed 3598 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2020 17:41:07 EDT
Received: from player698.ha.ovh.net (unknown [10.110.115.5])
        by mo2.mail-out.ovh.net (Postfix) with ESMTP id AE8701E0C3A
        for <stable@vger.kernel.org>; Thu,  2 Jul 2020 22:25:54 +0200 (CEST)
Received: from etezian.org (213-243-141-64.bb.dnainternet.fi [213.243.141.64])
        (Authenticated sender: andi@etezian.org)
        by player698.ha.ovh.net (Postfix) with ESMTPSA id 80B4313F8DEFB;
        Thu,  2 Jul 2020 20:25:46 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-100R003153a45de-222d-4edc-8908-80945713e232,FB3D8E5C650F7CFAB96446367E683FB3BA96C23C) smtp.auth=andi@etezian.org
Date:   Thu, 2 Jul 2020 23:25:45 +0300
From:   Andi Shyti <andi@etezian.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        andi@etezian.org, andi.shyti@intel.com
Subject: Re: [Intel-gfx] [PATCH 01/23] drm/i915: Drop vm.ref for duplicate
 vma on construction
Message-ID: <20200702202545.GA1969@jack.zhora.eu>
References: <20200702083225.20044-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702083225.20044-1-chris@chris-wilson.co.uk>
X-Ovh-Tracer-Id: 4814910953956229641
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduiedrtdeggddugeegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhguihcuufhhhihtihcuoegrnhguihesvghtvgiiihgrnhdrohhrgheqnecuggftrfgrthhtvghrnheptdfgudduhfefueeujeefieehtdeftefggeevhefgueellefhudetgeeikeduieefnecukfhppedtrddtrddtrddtpddvudefrddvgeefrddugedurdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrheileekrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheprghnughisegvthgviihirghnrdhorhhgpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Chris,

> diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
> index 1f63c4a1f055..7fe1f317cd2b 100644
> --- a/drivers/gpu/drm/i915/i915_vma.c
> +++ b/drivers/gpu/drm/i915/i915_vma.c
> @@ -198,6 +198,7 @@ vma_create(struct drm_i915_gem_object *obj,
>  		cmp = i915_vma_compare(pos, vm, view);
>  		if (cmp == 0) {
>  			spin_unlock(&obj->vma.lock);
> +			i915_vm_put(vm);
>  			i915_vma_free(vma);

You are forgettin one return without dereferencing it.

would this be a solution:

@@ -106,6 +106,7 @@ vma_create(struct drm_i915_gem_object *obj,
 {
        struct i915_vma *vma;
        struct rb_node *rb, **p;
+       struct i915_vma *pos = ERR_PTR(-E2BIG);
 
        /* The aliasing_ppgtt should never be used directly! */
        GEM_BUG_ON(vm == &vm->gt->ggtt->alias->vm);
@@ -185,7 +186,6 @@ vma_create(struct drm_i915_gem_object *obj,
        rb = NULL;
        p = &obj->vma.tree.rb_node;
        while (*p) {
-               struct i915_vma *pos;
                long cmp;
 
                rb = *p;
@@ -197,12 +197,8 @@ vma_create(struct drm_i915_gem_object *obj,
                 * and dispose of ours.
                 */
                cmp = i915_vma_compare(pos, vm, view);
-               if (cmp == 0) {
-                       spin_unlock(&obj->vma.lock);
-                       i915_vm_put(vm);
-                       i915_vma_free(vma);
-                       return pos;
-               }
+               if (!cmp)
+                       goto err_unlock;
 
                if (cmp < 0)
                        p = &rb->rb_right;
@@ -230,8 +226,9 @@ vma_create(struct drm_i915_gem_object *obj,
 err_unlock:
        spin_unlock(&obj->vma.lock);
 err_vma:
+       i915_vm_put(vm);
        i915_vma_free(vma);
-       return ERR_PTR(-E2BIG);
+       return pos;
 }

Andi
