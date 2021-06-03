Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0E139A48F
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 17:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhFCPax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 11:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhFCPaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 11:30:52 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C1AC06174A
        for <stable@vger.kernel.org>; Thu,  3 Jun 2021 08:29:08 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id s107so9412619ybi.3
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 08:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jlekstrand-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+qmChvkUqLl5eiHvAygjqmUTJgz8BfnTf0lgkePYOmM=;
        b=tyUTOaHNBnOwMuEDBregOohrJanvW1ShWtRY8DANSyfHZj5thC9vU/65uK/mJlnA8J
         kv+JGyWwqYA+5DzXZawqxBkAMlgI0kcVHvOQo4EWXZRoPialUBO/cyh6O8Sq9krX7f/9
         ogA7dbQ5BgKgIh/vWY0cfAJkybk3x8Bw9K+WYUYwVnlEGiCHuEtJt2lcqhdy9C8Fbml1
         wJyac1g3rAVHc+JCyYsdu23z7aEGCGb91h2LIKh/6bI8nCGmQJdTHS2CmDiBeq3+sEEL
         xlOgvsRj3+OAhTKPIp27gw4oawft4nw9UJ1iR6KIT9PjsbjZbXXPLHLF/WMdMHnD7aJ/
         /4pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+qmChvkUqLl5eiHvAygjqmUTJgz8BfnTf0lgkePYOmM=;
        b=tzjgR7pm1NS35P2LVzx7hazsZwaEcBW8uUoPBZvudXPHSeCGkvJEsjq9IR0P+RDNfJ
         Rw4z4qvGGLgk7fw6gCHfhcjKZ/OfKtYOznHB8oJD5tUjLWgnrcGINMasTmg4gvqGGTIi
         8GGSMCGfGHZqPrDQJfduv2JrRWuPkBbqcFxMwTKf4JbjI1GrGQtalpGEaAbwfY2xcJYJ
         jIgzLpc53H1yQds6vcjQjNPZ1VJHfuYCGr6IzE0f9WgNqKtTp0YeB9nqxfSemxe9D95y
         TjVohJYrbcc4pZ5W2zfN7E3Pesyuxbj1wP/YEWPnVLEWawutWwdlj6xVbFaVNr93w61u
         EJAA==
X-Gm-Message-State: AOAM532Uuq4C7Br7D59M4XroH3sFbZRJU6cSliXKUwCWZQlZixUZv1pN
        CKxkaVApUBAczfnfZTwBE7/vf4XgnZ+FOpviWCxVFg==
X-Google-Smtp-Source: ABdhPJwNpJChX+SmEXLtlJPn/FHzt84CXrubZ5MRG4B8F6iW5QGbMPG8x4eF90iqgwIJMolo+f5j8CNTtV+vEFZSaOs=
X-Received: by 2002:a25:81c5:: with SMTP id n5mr719557ybm.323.1622734147322;
 Thu, 03 Jun 2021 08:29:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210602164149.391653-1-jason@jlekstrand.net> <20210602164149.391653-5-jason@jlekstrand.net>
 <YLiRtZUuloF0qy0b@phenom.ffwll.local> <YLiR3CKMYjE9u4+T@phenom.ffwll.local> <YLiSk5bTpt1ZJvYr@phenom.ffwll.local>
In-Reply-To: <YLiSk5bTpt1ZJvYr@phenom.ffwll.local>
From:   Jason Ekstrand <jason@jlekstrand.net>
Date:   Thu, 3 Jun 2021 10:28:56 -0500
Message-ID: <CAOFGe94Syp5JPv4+i7aOaPLOSYgdvaL7J0v0kAQ5Z7P+jHFJtw@mail.gmail.com>
Subject: Re: [PATCH 4/5] Revert "drm/i915: Propagate errors on awaiting
 already signaled fences"
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
        Intel GFX <intel-gfx@lists.freedesktop.org>,
        Jason Ekstrand <jason.ekstrand@intel.com>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        stable <stable@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jon Bloomfield <jon.bloomfield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 3, 2021 at 3:28 AM Daniel Vetter <daniel@ffwll.ch> wrote:
>
> On Thu, Jun 03, 2021 at 10:25:00AM +0200, Daniel Vetter wrote:
> > On Thu, Jun 03, 2021 at 10:24:21AM +0200, Daniel Vetter wrote:
> > > On Wed, Jun 02, 2021 at 11:41:48AM -0500, Jason Ekstrand wrote:
> > > > This reverts commit 9e31c1fe45d555a948ff66f1f0e3fe1f83ca63f7.  Ever
> > > > since that commit, we've been having issues where a hang in one client
> > > > can propagate to another.  In particular, a hang in an app can propagate
> > > > to the X server which causes the whole desktop to lock up.
> > >
> > > I think we need a note to backporters here:
> > >
> > > "For backporters: Please note that you _must_ have a backport of
> > > https://lore.kernel.org/dri-devel/20210602164149.391653-2-jason@jlekstrand.net/
> > > for otherwise backporting just this patch opens up a security bug."

Done.

> > > Or something like that.
> >
> > Oh also reordering the patch set so the 2 reverts which are cc: stable are
> > first, then the other stuff on top that cleans up the fallout.

Done.

> Oh also the longer commit message I've done would be nice to add. Or at
> least link it or something like that.
>
> https://lore.kernel.org/dri-devel/20210519101523.688398-1-daniel.vetter@ffwll.ch/
>
> I think I mentioned this on irc, but got lost I guess.

Drp.  I thought I'd gotten that but I guess I failed.  Fixed now.

> -Daniel
>
> > -Daniel
> >
> > > -Daniel
> > >
> > > > Signed-off-by: Jason Ekstrand <jason.ekstrand@intel.com>
> > > > Reported-by: Marcin Slusarz <marcin.slusarz@intel.com>
> > > > Cc: <stable@vger.kernel.org> # v5.6+
> > > > Cc: Jason Ekstrand <jason.ekstrand@intel.com>
> > > > Cc: Marcin Slusarz <marcin.slusarz@intel.com>
> > > > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3080
> > > > Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
> > > > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > > Reviewed-by: Jon Bloomfield <jon.bloomfield@intel.com>
> > > > ---
> > > >  drivers/gpu/drm/i915/i915_request.c | 8 ++------
> > > >  1 file changed, 2 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> > > > index 970d8f4986bbe..b796197c07722 100644
> > > > --- a/drivers/gpu/drm/i915/i915_request.c
> > > > +++ b/drivers/gpu/drm/i915/i915_request.c
> > > > @@ -1426,10 +1426,8 @@ i915_request_await_execution(struct i915_request *rq,
> > > >
> > > >   do {
> > > >           fence = *child++;
> > > > -         if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
> > > > -                 i915_sw_fence_set_error_once(&rq->submit, fence->error);
> > > > +         if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
> > > >                   continue;
> > > > -         }
> > > >
> > > >           if (fence->context == rq->fence.context)
> > > >                   continue;
> > > > @@ -1527,10 +1525,8 @@ i915_request_await_dma_fence(struct i915_request *rq, struct dma_fence *fence)
> > > >
> > > >   do {
> > > >           fence = *child++;
> > > > -         if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
> > > > -                 i915_sw_fence_set_error_once(&rq->submit, fence->error);
> > > > +         if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
> > > >                   continue;
> > > > -         }
> > > >
> > > >           /*
> > > >            * Requests on the same timeline are explicitly ordered, along
> > > > --
> > > > 2.31.1
> > > >
> > >
> > > --
> > > Daniel Vetter
> > > Software Engineer, Intel Corporation
> > > http://blog.ffwll.ch
> >
> > --
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > http://blog.ffwll.ch
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch
