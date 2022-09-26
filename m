Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EDE5EACF9
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiIZQrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiIZQrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:47:32 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8939214979F
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:39:26 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id x29so7931399ljq.2
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=T6QODcIsXlzIuuCSqD2cd8HlXjbJPWnOdHV6w4+nooc=;
        b=mr3QIaR9GDTNzekeO2RXpny+80Qkd+MlIJNS5MEJcZrPaZG8JZiq7ToEnMDn2jd2Tu
         +WfA3epIoG4jbUWdKHMlVhEjEQ5/GhmcYUdP8HgzFbdBKMZBMVlsH7SJ05pdguPzZnYj
         LPO3MQc0Oyc3IcYqaBw0HTbismYH4vYma7KqA0QfM1ZCWvILpIELYsAj5gxjy1WaxWBK
         KXdV1Ln6IcIQpmHFV1Zs11XBrXB3eIQsuiLzpzGkHSFNs2pRCgx09uc1LOFcyPnR5pzJ
         25fEmbOnqwnh16IZ2T1SqpMspJq5DhPqJVxlWAkB5/cwlIW4epc5ZWubI2JdLu2UDR21
         8sEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=T6QODcIsXlzIuuCSqD2cd8HlXjbJPWnOdHV6w4+nooc=;
        b=RAESw1rNsY14z5fTsE35z06HymAw7EkhwRg/ik/lFfYcwqeY1sW6FG07Bq8LD3+e+g
         2Ahle5atVcGhpJySjwPk5LDxYpx/0r5mqOpuCmH0tA4mIvGt2QlKEgt4+hPVT4WtViLJ
         kdXg7LgkV9wX8tTLkLRUFqFYSiTK+lqLvi1buVP1t4NaLi+0pvvq1fHjK5cBsN7d2Lcv
         5s0khOsEfpLFCckj+HBxu8Xa9qi4/e1AymevjJb6VCvL8C7MkozaRyg8hdxz3000Zy7H
         Sg6CdcAdpwIACI213ilVAlsbBzrxmYhy+vqW06zNs/KJMx1WNP7kGr6aYMAoecE+ICTD
         iUFg==
X-Gm-Message-State: ACrzQf0A6axz1pSlT+23pd9isbRLe2cKqnLeAVvpeq/7oQoC7eHDuLUE
        fQP/7ijlQEdhbtwq1ZEJS/p5wfRdOB2JTzgyxhP000p+qyDfzw==
X-Google-Smtp-Source: AMsMyM4jgazyi6oylVt0mM9mxtasZn/sQwKZrh59EpH4KSCm1W67IQGKxDAC2Jqz9LwKVEFOZj95vEJmYYcv9wSodiU=
X-Received: by 2002:a2e:b0eb:0:b0:26c:561b:7cff with SMTP id
 h11-20020a2eb0eb000000b0026c561b7cffmr7643941ljl.269.1664206764739; Mon, 26
 Sep 2022 08:39:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220926153333.102195-1-matthew.auld@intel.com>
In-Reply-To: <20220926153333.102195-1-matthew.auld@intel.com>
From:   Matthew Auld <matthew.william.auld@gmail.com>
Date:   Mon, 26 Sep 2022 16:38:57 +0100
Message-ID: <CAM0jSHPprVcVywyVwUH=2j96YYJK5rEOvHUyEofCY51GguizrA@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Use i915_vm_put on ppgtt_create
 error paths
To:     Matthew Auld <matthew.auld@intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>, stable@vger.kernel.org,
        Chris Wilson <chris.p.wilson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Sept 2022 at 16:34, Matthew Auld <matthew.auld@intel.com> wrote:
>
> From: Chris Wilson <chris.p.wilson@intel.com>
>
> Now that the scratch page and page directories have a reference back to
> the i915_address_space, we cannot do an immediate free of the ppgtt upon
> error as those buffer objects will perform a later i915_vm_put in their
> deferred frees.
>
> The downside is that by replacing the onion unwind along the error
> paths, the ppgtt cleanup must handle a partially constructed vm. This
> includes ensuring that the vm->cleanup is set prior to the error path.
>
> Fixes: https://gitlab.freedesktop.org/drm/intel/-/issues/6900
> Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
> Fixes: 4d8151ae5329 ("drm/i915: Don't free shared locks while shared")
> Cc: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> Cc: Matthew Auld <matthew.auld@intel.com>
> Cc: <stable@vger.kernel.org> # v5.14+

Tested locally on dg2 (with small-bar), and no longer goes down in
flames it seems,
Reviewed-by: Matthew Auld <matthew.auld@intel.com>

> Signed-off-by: Matthew Auld <matthew.auld@intel.com>
> ---
>  drivers/gpu/drm/i915/gt/gen6_ppgtt.c | 16 ++++----
>  drivers/gpu/drm/i915/gt/gen8_ppgtt.c | 58 ++++++++++++++--------------
>  drivers/gpu/drm/i915/gt/intel_gtt.c  |  3 ++
>  3 files changed, 41 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/gen6_ppgtt.c b/drivers/gpu/drm/i915/=
gt/gen6_ppgtt.c
> index 1bb766c79dcb..5aaacc53fa4c 100644
> --- a/drivers/gpu/drm/i915/gt/gen6_ppgtt.c
> +++ b/drivers/gpu/drm/i915/gt/gen6_ppgtt.c
> @@ -247,6 +247,7 @@ static int gen6_ppgtt_init_scratch(struct gen6_ppgtt =
*ppgtt)
>         i915_gem_object_put(vm->scratch[1]);
>  err_scratch0:
>         i915_gem_object_put(vm->scratch[0]);
> +       vm->scratch[0] =3D NULL;
>         return ret;
>  }
>
> @@ -268,9 +269,10 @@ static void gen6_ppgtt_cleanup(struct i915_address_s=
pace *vm)
>         gen6_ppgtt_free_pd(ppgtt);
>         free_scratch(vm);
>
> -       mutex_destroy(&ppgtt->flush);
> +       if (ppgtt->base.pd)
> +               free_pd(&ppgtt->base.vm, ppgtt->base.pd);
>
> -       free_pd(&ppgtt->base.vm, ppgtt->base.pd);
> +       mutex_destroy(&ppgtt->flush);
>  }
>
>  static void pd_vma_bind(struct i915_address_space *vm,
> @@ -449,19 +451,17 @@ struct i915_ppgtt *gen6_ppgtt_create(struct intel_g=
t *gt)
>
>         err =3D gen6_ppgtt_init_scratch(ppgtt);
>         if (err)
> -               goto err_free;
> +               goto err_put;
>
>         ppgtt->base.pd =3D gen6_alloc_top_pd(ppgtt);
>         if (IS_ERR(ppgtt->base.pd)) {
>                 err =3D PTR_ERR(ppgtt->base.pd);
> -               goto err_scratch;
> +               goto err_put;
>         }
>
>         return &ppgtt->base;
>
> -err_scratch:
> -       free_scratch(&ppgtt->base.vm);
> -err_free:
> -       kfree(ppgtt);
> +err_put:
> +       i915_vm_put(&ppgtt->base.vm);
>         return ERR_PTR(err);
>  }
> diff --git a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c b/drivers/gpu/drm/i915/=
gt/gen8_ppgtt.c
> index c7bd5d71b03e..2128b7a72a25 100644
> --- a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
> +++ b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
> @@ -196,7 +196,10 @@ static void gen8_ppgtt_cleanup(struct i915_address_s=
pace *vm)
>         if (intel_vgpu_active(vm->i915))
>                 gen8_ppgtt_notify_vgt(ppgtt, false);
>
> -       __gen8_ppgtt_cleanup(vm, ppgtt->pd, gen8_pd_top_count(vm), vm->to=
p);
> +       if (ppgtt->pd)
> +               __gen8_ppgtt_cleanup(vm, ppgtt->pd,
> +                                    gen8_pd_top_count(vm), vm->top);
> +
>         free_scratch(vm);
>  }
>
> @@ -803,8 +806,10 @@ static int gen8_init_scratch(struct i915_address_spa=
ce *vm)
>                 struct drm_i915_gem_object *obj;
>
>                 obj =3D vm->alloc_pt_dma(vm, I915_GTT_PAGE_SIZE_4K);
> -               if (IS_ERR(obj))
> +               if (IS_ERR(obj)) {
> +                       ret =3D PTR_ERR(obj);
>                         goto free_scratch;
> +               }
>
>                 ret =3D map_pt_dma(vm, obj);
>                 if (ret) {
> @@ -823,7 +828,8 @@ static int gen8_init_scratch(struct i915_address_spac=
e *vm)
>  free_scratch:
>         while (i--)
>                 i915_gem_object_put(vm->scratch[i]);
> -       return -ENOMEM;
> +       vm->scratch[0] =3D NULL;
> +       return ret;
>  }
>
>  static int gen8_preallocate_top_level_pdp(struct i915_ppgtt *ppgtt)
> @@ -901,6 +907,7 @@ gen8_alloc_top_pd(struct i915_address_space *vm)
>  struct i915_ppgtt *gen8_ppgtt_create(struct intel_gt *gt,
>                                      unsigned long lmem_pt_obj_flags)
>  {
> +       struct i915_page_directory *pd;
>         struct i915_ppgtt *ppgtt;
>         int err;
>
> @@ -946,21 +953,7 @@ struct i915_ppgtt *gen8_ppgtt_create(struct intel_gt=
 *gt,
>                 ppgtt->vm.alloc_scratch_dma =3D alloc_pt_dma;
>         }
>
> -       err =3D gen8_init_scratch(&ppgtt->vm);
> -       if (err)
> -               goto err_free;
> -
> -       ppgtt->pd =3D gen8_alloc_top_pd(&ppgtt->vm);
> -       if (IS_ERR(ppgtt->pd)) {
> -               err =3D PTR_ERR(ppgtt->pd);
> -               goto err_free_scratch;
> -       }
> -
> -       if (!i915_vm_is_4lvl(&ppgtt->vm)) {
> -               err =3D gen8_preallocate_top_level_pdp(ppgtt);
> -               if (err)
> -                       goto err_free_pd;
> -       }
> +       ppgtt->vm.pte_encode =3D gen8_pte_encode;
>
>         ppgtt->vm.bind_async_flags =3D I915_VMA_LOCAL_BIND;
>         ppgtt->vm.insert_entries =3D gen8_ppgtt_insert;
> @@ -971,22 +964,31 @@ struct i915_ppgtt *gen8_ppgtt_create(struct intel_g=
t *gt,
>         ppgtt->vm.allocate_va_range =3D gen8_ppgtt_alloc;
>         ppgtt->vm.clear_range =3D gen8_ppgtt_clear;
>         ppgtt->vm.foreach =3D gen8_ppgtt_foreach;
> +       ppgtt->vm.cleanup =3D gen8_ppgtt_cleanup;
>
> -       ppgtt->vm.pte_encode =3D gen8_pte_encode;
> +       err =3D gen8_init_scratch(&ppgtt->vm);
> +       if (err)
> +               goto err_put;
> +
> +       pd =3D gen8_alloc_top_pd(&ppgtt->vm);
> +       if (IS_ERR(pd)) {
> +               err =3D PTR_ERR(pd);
> +               goto err_put;
> +       }
> +       ppgtt->pd =3D pd;
> +
> +       if (!i915_vm_is_4lvl(&ppgtt->vm)) {
> +               err =3D gen8_preallocate_top_level_pdp(ppgtt);
> +               if (err)
> +                       goto err_put;
> +       }
>
>         if (intel_vgpu_active(gt->i915))
>                 gen8_ppgtt_notify_vgt(ppgtt, true);
>
> -       ppgtt->vm.cleanup =3D gen8_ppgtt_cleanup;
> -
>         return ppgtt;
>
> -err_free_pd:
> -       __gen8_ppgtt_cleanup(&ppgtt->vm, ppgtt->pd,
> -                            gen8_pd_top_count(&ppgtt->vm), ppgtt->vm.top=
);
> -err_free_scratch:
> -       free_scratch(&ppgtt->vm);
> -err_free:
> -       kfree(ppgtt);
> +err_put:
> +       i915_vm_put(&ppgtt->vm);
>         return ERR_PTR(err);
>  }
> diff --git a/drivers/gpu/drm/i915/gt/intel_gtt.c b/drivers/gpu/drm/i915/g=
t/intel_gtt.c
> index b67831833c9a..2eaeba14319e 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gtt.c
> +++ b/drivers/gpu/drm/i915/gt/intel_gtt.c
> @@ -405,6 +405,9 @@ void free_scratch(struct i915_address_space *vm)
>  {
>         int i;
>
> +       if (!vm->scratch[0])
> +               return;
> +
>         for (i =3D 0; i <=3D vm->top; i++)
>                 i915_gem_object_put(vm->scratch[i]);
>  }
> --
> 2.37.3
>
