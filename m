Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8211D64D63F
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 06:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiLOFq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 00:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiLOFqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 00:46:54 -0500
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B5D36D71
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 21:46:53 -0800 (PST)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1442977d77dso19673774fac.6
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 21:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8u7cxy/3xV68RzXCR9Wnk6dzstb0hBoTs9nATH0oh5g=;
        b=jTONlSJJrz7XrhhvEjNegXJB8lytqJAAata1H755BeBLHLPrixgZa7502iu1j5uykN
         0bB647zAaz7Nb4HvNDXIdmvW+Br93reuyUC4tCPABHHoXtoouKiW3zFhBNZVzo/hzvy7
         wqKRbY3+PsiCVPrMynRPnAMuBzRudTDPDqmwk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8u7cxy/3xV68RzXCR9Wnk6dzstb0hBoTs9nATH0oh5g=;
        b=7J3LIntEGTa3kzladU0rBToF4diZnvs6wKhDgZS4NOL5D+DAyKQ7I/+tSg7B3hQ8iy
         XTV5RvhapuELPL3eb75WglQxPSj1E9tm1fatBiYSk3aPc4PoSd9h/Fnzv3ECilEB2YgU
         YR7bqRIQgMbYlcyKXNlVM/bFMll/Ws/EOD3YAN2k91lNPxNUebUQsEHk7UA5zYEPoMeN
         vjKaKX2WMCLzI03UuEEfECAFDl266hugSRkwrXr0zw18f0YQHIybCrpU/iPQrlPgfbUo
         ihOCOkkUsh0kRG4hAzllLaN5xRvW9tn1+AtvxLbL0iALHEASHjCjz5XWhrHoYM7ZU3vW
         sUFg==
X-Gm-Message-State: AFqh2kqlMhOsgqN7ZVwV5rFF+LvrC0z8dPLB7lrL3XNUibpBYdiQQpH4
        j5rdOGLyKouqdNPo9S80hXpJ5eZgECE0uKVLy8b5ifGqRv84xU7l
X-Google-Smtp-Source: AMrXdXt70nfF0jNyaRmHUOVp/Sq1zPBWz8MtAmeo5Utauuiq1SiyfXEHlXIS8xeuGOWZSyUEALkQJb/IsvqYzExsJ2M=
X-Received: by 2002:a05:6870:698b:b0:148:2c02:5323 with SMTP id
 my11-20020a056870698b00b001482c025323mr675289oab.298.1671083213046; Wed, 14
 Dec 2022 21:46:53 -0800 (PST)
MIME-Version: 1.0
References: <20221206161141.128921-1-matthew.auld@intel.com>
 <CAHzEqDkd5u5A+2EfeVpnMoqHLWS=d5uLQquGDQ5TLAcx8Oydqw@mail.gmail.com> <db6eccfa-4536-0212-c9a9-4a0ea6e4c877@intel.com>
In-Reply-To: <db6eccfa-4536-0212-c9a9-4a0ea6e4c877@intel.com>
From:   Mani Milani <mani@chromium.org>
Date:   Thu, 15 Dec 2022 16:46:42 +1100
Message-ID: <CAHzEqDkmLMUBMZTwiOhuoiW_yJH4SsAEbsFy_bzGoNvP0gaoxg@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: improve the catch-all evict to handle lock contention
To:     Matthew Auld <matthew.auld@intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for the explanations Matthew. It all makes sense now. I will
now test this patch further and report back the results.

There is just one comment block that needs to be updated I think. See below:

On Wed, Dec 14, 2022 at 10:47 PM Matthew Auld <matthew.auld@intel.com> wrote:
>
...
> >> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> >> index 86956b902c97..e2ce1e4e9723 100644
> >> --- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> >> +++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> >> @@ -745,25 +745,44 @@ static int eb_reserve(struct i915_execbuffer *eb)
> >>           *
> >>           * Defragmenting is skipped if all objects are pinned at a fixed location.
> >>           */
Could you please update the comment block above and add a little
explanation for the new pass=3 you added?

> >> -       for (pass = 0; pass <= 2; pass++) {
> >> +       for (pass = 0; pass <= 3; pass++) {
> >>                  int pin_flags = PIN_USER | PIN_VALIDATE;
> >>
> >>                  if (pass == 0)
> >>                          pin_flags |= PIN_NONBLOCK;
> >>
> >> diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i915/i915_gem_evict.c
> >> index 4cfe36b0366b..c02ebd6900ae 100644
> >> --- a/drivers/gpu/drm/i915/i915_gem_evict.c
> >> +++ b/drivers/gpu/drm/i915/i915_gem_evict.c
> >> @@ -441,6 +441,11 @@ int i915_gem_evict_for_node(struct i915_address_space *vm,
> >>    * @vm: Address space to cleanse
> >>    * @ww: An optional struct i915_gem_ww_ctx. If not NULL, i915_gem_evict_vm
> >>    * will be able to evict vma's locked by the ww as well.
> >> + * @busy_bo: Optional pointer to struct drm_i915_gem_object. If not NULL, then
> >> + * in the event i915_gem_evict_vm() is unable to trylock an object for eviction,
> >> + * then @busy_bo will point to it. -EBUSY is also returned. The caller must drop
> >> + * the vm->mutex, before trying again to acquire the contended lock. The caller
> >> + * also owns a reference to the object.
> >>    *
> >>    * This function evicts all vmas from a vm.
> >>    *
> >> @@ -450,7 +455,8 @@ int i915_gem_evict_for_node(struct i915_address_space *vm,
> >>    * To clarify: This is for freeing up virtual address space, not for freeing
> >>    * memory in e.g. the shrinker.
> >>    */
> >> -int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww)
> >> +int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww,
> >> +                     struct drm_i915_gem_object **busy_bo)
> >>   {
> >>          int ret = 0;
> >>
> >> @@ -482,15 +488,22 @@ int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww)
> >>                           * the resv is shared among multiple objects, we still
> >>                           * need the object ref.
> >>                           */
> >> -                       if (dying_vma(vma) ||
> >> +                       if (!i915_gem_object_get_rcu(vma->obj) ||
Oops, sorry, I had missed the one line change above. After you pointed
that out, all the 'i915_gem_object_put()' calls now make perfect
sense. Thanks.

> >>                              (ww && (dma_resv_locking_ctx(vma->obj->base.resv) == &ww->ctx))) {
> >>                                  __i915_vma_pin(vma);
> >>                                  list_add(&vma->evict_link, &locked_eviction_list);
> >>                                  continue;
> >>                          }
> >>
> >> -                       if (!i915_gem_object_trylock(vma->obj, ww))
> >> +                       if (!i915_gem_object_trylock(vma->obj, ww)) {
> >> +                               if (busy_bo) {
> >> +                                       *busy_bo = vma->obj; /* holds ref */
> >> +                                       ret = -EBUSY;
> >> +                                       break;
> >> +                               }
> >> +                               i915_gem_object_put(vma->obj);
> >>                                  continue;
> >> +                       }
