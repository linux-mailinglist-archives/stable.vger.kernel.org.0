Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE1664E624
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 04:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiLPDMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 22:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLPDMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 22:12:43 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3486D2A42E
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 19:12:42 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id m204so925562oib.6
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 19:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KmrU2BLFIDoLJz3iLHrGFN1AkiedowkjpxGp+Pf2jMA=;
        b=ef84ho4lBKKzMMyiyJag4LVOqecBEoJ5gENy7eYhhObOQjOsVIVs4XEc6U9wYkeaQu
         Bmsy3I8IOZmdC9lkIl7nemFySj1P06y77jPsxNp6Rhdcf574I+CO3a22Hu6QZvx5n1Aj
         KOhVW6fkibmhX8m/X/o9c5jb4CH0GSiksFVq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KmrU2BLFIDoLJz3iLHrGFN1AkiedowkjpxGp+Pf2jMA=;
        b=xxEOSuNtWNTMkQdVMzd0ljzia6ZCRIpXBKndCfHbBZQ9m2S8y3MfSTy5Btk3LvhJQq
         hN08szZE9sqsFqDa3EMmNbqiZ1nNAmvSciupUXb5TK4ToyfSGwlKymAc8gxgzf00+JGR
         dceWfK8FohnmuXXxmwb6mijSLsZKzgLTIcOl2DNuw4X9EmtWZ3D87X/+oB9zuAjt0dx+
         Czs85RfwV3npUqju02YEjZx65VnKNpKgCN3j2FTkfbrBLmHTGqkXg8TdO/kgu+20oJxF
         urqHt9HysYs+QjnZvsMMmzXBgXL5HkmNkxFgbyrMWRYDJboL1IiPVdkuL8a6Ct5RUWpq
         zGSg==
X-Gm-Message-State: ANoB5pmAKUX8GxUjlBcUsLnmpODfYFQE1RcSICVjEIGlgBXkU2zVNley
        YlszesnYQIz3tm1aJHuggLEep6FTDm0oX4zwLg3FlzMPDN/3n2KZ
X-Google-Smtp-Source: AA0mqf4To/1T7jVD113uB2bfLajiVWMqWS5JUBfKbAKeI6mlfpMFU8kTWzKWpJsfVzRtTLKem/QfvGuUaR3qAB4x1kk=
X-Received: by 2002:aca:1c0f:0:b0:35b:a08d:5d71 with SMTP id
 c15-20020aca1c0f000000b0035ba08d5d71mr354854oic.173.1671160361522; Thu, 15
 Dec 2022 19:12:41 -0800 (PST)
MIME-Version: 1.0
References: <20221206161141.128921-1-matthew.auld@intel.com>
 <CAHzEqDkd5u5A+2EfeVpnMoqHLWS=d5uLQquGDQ5TLAcx8Oydqw@mail.gmail.com>
 <db6eccfa-4536-0212-c9a9-4a0ea6e4c877@intel.com> <CAHzEqDkmLMUBMZTwiOhuoiW_yJH4SsAEbsFy_bzGoNvP0gaoxg@mail.gmail.com>
In-Reply-To: <CAHzEqDkmLMUBMZTwiOhuoiW_yJH4SsAEbsFy_bzGoNvP0gaoxg@mail.gmail.com>
From:   Mani Milani <mani@chromium.org>
Date:   Fri, 16 Dec 2022 14:12:30 +1100
Message-ID: <CAHzEqDnjEN67g-Y+35h-pw4bwmSe4ZtwyWjQ9pEe1vPD_B3GYQ@mail.gmail.com>
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

This patch passed all my tests, some of which were failing before
applying the patch. Thanks.

Reviewed-by: Mani Milani <mani@chromium.org>
Tested-by: Mani Milani <mani@chromium.org>

On Thu, Dec 15, 2022 at 4:46 PM Mani Milani <mani@chromium.org> wrote:
>
> Thanks for the explanations Matthew. It all makes sense now. I will
> now test this patch further and report back the results.
>
> There is just one comment block that needs to be updated I think. See below:
>
> On Wed, Dec 14, 2022 at 10:47 PM Matthew Auld <matthew.auld@intel.com> wrote:
> >
> ...
> > >> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> > >> index 86956b902c97..e2ce1e4e9723 100644
> > >> --- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> > >> +++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> > >> @@ -745,25 +745,44 @@ static int eb_reserve(struct i915_execbuffer *eb)
> > >>           *
> > >>           * Defragmenting is skipped if all objects are pinned at a fixed location.
> > >>           */
> Could you please update the comment block above and add a little
> explanation for the new pass=3 you added?
>
> > >> -       for (pass = 0; pass <= 2; pass++) {
> > >> +       for (pass = 0; pass <= 3; pass++) {
> > >>                  int pin_flags = PIN_USER | PIN_VALIDATE;
> > >>
> > >>                  if (pass == 0)
> > >>                          pin_flags |= PIN_NONBLOCK;
> > >>
> > >> diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i915/i915_gem_evict.c
> > >> index 4cfe36b0366b..c02ebd6900ae 100644
> > >> --- a/drivers/gpu/drm/i915/i915_gem_evict.c
> > >> +++ b/drivers/gpu/drm/i915/i915_gem_evict.c
> > >> @@ -441,6 +441,11 @@ int i915_gem_evict_for_node(struct i915_address_space *vm,
> > >>    * @vm: Address space to cleanse
> > >>    * @ww: An optional struct i915_gem_ww_ctx. If not NULL, i915_gem_evict_vm
> > >>    * will be able to evict vma's locked by the ww as well.
> > >> + * @busy_bo: Optional pointer to struct drm_i915_gem_object. If not NULL, then
> > >> + * in the event i915_gem_evict_vm() is unable to trylock an object for eviction,
> > >> + * then @busy_bo will point to it. -EBUSY is also returned. The caller must drop
> > >> + * the vm->mutex, before trying again to acquire the contended lock. The caller
> > >> + * also owns a reference to the object.
> > >>    *
> > >>    * This function evicts all vmas from a vm.
> > >>    *
> > >> @@ -450,7 +455,8 @@ int i915_gem_evict_for_node(struct i915_address_space *vm,
> > >>    * To clarify: This is for freeing up virtual address space, not for freeing
> > >>    * memory in e.g. the shrinker.
> > >>    */
> > >> -int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww)
> > >> +int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww,
> > >> +                     struct drm_i915_gem_object **busy_bo)
> > >>   {
> > >>          int ret = 0;
> > >>
> > >> @@ -482,15 +488,22 @@ int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww)
> > >>                           * the resv is shared among multiple objects, we still
> > >>                           * need the object ref.
> > >>                           */
> > >> -                       if (dying_vma(vma) ||
> > >> +                       if (!i915_gem_object_get_rcu(vma->obj) ||
> Oops, sorry, I had missed the one line change above. After you pointed
> that out, all the 'i915_gem_object_put()' calls now make perfect
> sense. Thanks.
>
> > >>                              (ww && (dma_resv_locking_ctx(vma->obj->base.resv) == &ww->ctx))) {
> > >>                                  __i915_vma_pin(vma);
> > >>                                  list_add(&vma->evict_link, &locked_eviction_list);
> > >>                                  continue;
> > >>                          }
> > >>
> > >> -                       if (!i915_gem_object_trylock(vma->obj, ww))
> > >> +                       if (!i915_gem_object_trylock(vma->obj, ww)) {
> > >> +                               if (busy_bo) {
> > >> +                                       *busy_bo = vma->obj; /* holds ref */
> > >> +                                       ret = -EBUSY;
> > >> +                                       break;
> > >> +                               }
> > >> +                               i915_gem_object_put(vma->obj);
> > >>                                  continue;
> > >> +                       }
