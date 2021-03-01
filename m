Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D184327FFE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbhCANvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbhCANvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:51:09 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCE3C061756
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 05:50:29 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id 105so16504342otd.3
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 05:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nIffz32e7kAOtkoqIqyEDBNP7zhp7pvgm4BWl6oF0S8=;
        b=eCJ4C0VGRnEZ990nEBnOBVfx9ul4Sc6XuIfeNBVbtmIr+Pb11XDnOaQoSPwJEoBHlk
         nUMsX9TtmdTqJU3CY/Ou2OE31tHS7QLfRACm4dKhWsAE+2MPd9/6XfELsiv3leNhKXxg
         gfhLZ9KI8aJjE91mzlK5SEI+j070Od0w163uo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nIffz32e7kAOtkoqIqyEDBNP7zhp7pvgm4BWl6oF0S8=;
        b=nUclWRsfISNWejlFlZVG0acBTnMom7etqF+ihStSNJXlVy93PMQqAaN1X7v/upsFMF
         9WYpD3TwVCeJreJ1YLga/UfSAsoCX/VTPMSOLrttVmfmm6YpmkV70PdWw9kv/Wz0Y25e
         qafIBxwzUyptm+BPk3B25tsLMdJS1FPTSGtWg4+mEE1hlpNoKu0WPp4xYYEZe0twOGWJ
         qCDtmqG0DfSC/oXtLW/UsS+Y+JmV6+vzU2+DfKTrNDoml1/ExIfZynRTXiVX+Yluli5X
         8T/KDxDhS3m6XM9UYIGS5NunaBhwfNaeGNc1ihhHRSVE/8b8utOECsllVb3oBp/HKkm1
         FoBw==
X-Gm-Message-State: AOAM5318XIFY4XvcZrYFMDZ8ht3SXj5oiOR7lM3WBm9dWQqCES9lNP+x
        oafVuqaYFTCwXN7M5t6CQBCyyM4PEKCLkr6pChSBCw==
X-Google-Smtp-Source: ABdhPJyTfgJWCRHmfoKEzGOlCqbPjKj+k/wx+ukdGtunHsAPt9GgA7MxTewb9hMPYCOBWZ4NwQUfHEjPJHt95+iowO4=
X-Received: by 2002:a9d:6481:: with SMTP id g1mr3764106otl.303.1614606628709;
 Mon, 01 Mar 2021 05:50:28 -0800 (PST)
MIME-Version: 1.0
References: <20210301095254.1946084-1-daniel.vetter@ffwll.ch> <f0e85747e101a9078f1e1d158f1eea29a9f31684.camel@pengutronix.de>
In-Reply-To: <f0e85747e101a9078f1e1d158f1eea29a9f31684.camel@pengutronix.de>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon, 1 Mar 2021 14:50:17 +0100
Message-ID: <CAKMK7uHqHTVnnhwrS9SWgcqTR4DDJkftm5Ru2fYb1h8m2v9XMw@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/etnaviv: Use FOLL_FORCE for userptr
To:     Lucas Stach <l.stach@pengutronix.de>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        The etnaviv authors <etnaviv@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 1, 2021 at 11:28 AM Lucas Stach <l.stach@pengutronix.de> wrote:
>
> Am Montag, dem 01.03.2021 um 10:52 +0100 schrieb Daniel Vetter:
> > Nothing checks userptr.ro except this call to pup_fast, which means
> > there's nothing actually preventing userspace from writing to this.
> > Which means you can just read-only mmap any file you want, userptr it
> > and then write to it with the gpu. Not good.
>
> I agree about the "not good" part.
>
> > The right way to handle this is FOLL_WRITE | FOLL_FORCE, which will
> > break any COW mappings and update tracking for MAY_WRITE mappings so
> > there's no exploit and the vm isn't confused about what's going on.
> > For any legit use case there's no difference from what userspace can
> > observe and do.
>
> This however seems pretty heavy handed. Does this mean we do a full COW
> cycle of the userpages on BO creation? This most likely kills a lot of
> the performance benefits that one might seek by using userptr. If
> that's the case I might still take this patch for stable, but then we
> should rather just disallow writable GPU mappings to this BO.

That's not what's happening. If the mmap is writeable already (like
any malloc'ed area, and anything you might vacuum up with Xshm), then
FOLL_FORCE does nothing. The difference only happens when the current
mmap region (or some of the pte at least) is read-only. Then:
- for MAP_SHARED with the VM_MAYWRITE flag set, we simply adjust some
book-keeping (no copying of pages), so that the core mm doesn't get
confused about the potentially changed pages contents due to gpu
writes. Without this you could corrupt fs state (e.g. when the fs
checksums file contents or does in-place mmap and stuff like that).
- for MAP_PRIVATE we force the CoW. Just don't do userptr on these,
really, it doesn't make much sense anyway. And note again, if the
mapping is currently writeable, then there's no copying going on, this
is only when the mmap/pte is currently read-only. This is the "let's
overwrite libc.so" attack vector :-)

So really in practice nothing should happen here aside from plugging
the "not good" part. Note that on recent kernels the CoW breaking on
fork() happens irrespective of FOLL_FORCE or not once you have the
mapping established. So if you do a lot of userptr on MAP_PRIVATE
already and applications are using fork(), then you're already
suffering big time (since 5.10 or so iirc, John probably knows the
exact commit without looking).
-Daniel

> Regards,
> Lucas
>
> >
> > Cc: stable@vger.kernel.org
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > Cc: Lucas Stach <l.stach@pengutronix.de>
> > Cc: Russell King <linux+etnaviv@armlinux.org.uk>
> > Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
> > Cc: etnaviv@lists.freedesktop.org
> > ---
> >  drivers/gpu/drm/etnaviv/etnaviv_gem.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem.c b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
> > index 6d38c5c17f23..a9e696d05b33 100644
> > --- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
> > +++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
> > @@ -689,7 +689,7 @@ static int etnaviv_gem_userptr_get_pages(struct etnaviv_gem_object *etnaviv_obj)
> >               struct page **pages = pvec + pinned;
> >
> >
> >
> >
> >
> >
> >
> >
> >               ret = pin_user_pages_fast(ptr, num_pages,
> > -                                       !userptr->ro ? FOLL_WRITE : 0, pages);
> > +                                       FOLL_WRITE | FOLL_FORCE, pages);
> >               if (ret < 0) {
> >                       unpin_user_pages(pvec, pinned);
> >                       kvfree(pvec);
>
>


-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
