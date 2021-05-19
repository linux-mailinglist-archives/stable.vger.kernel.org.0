Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B75389484
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 19:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242386AbhESRRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 13:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240864AbhESRRg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 13:17:36 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59715C06175F
        for <stable@vger.kernel.org>; Wed, 19 May 2021 10:16:15 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id w127so9944888oig.12
        for <stable@vger.kernel.org>; Wed, 19 May 2021 10:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XHK8qMEJKNTFYFzFd6RoA4EfyentocUkphGdZ4KCkHI=;
        b=MJp/pwAnVlgikEUJ8nPxwtmlZ8BiEmXiZO1xdZXQgrkgszKd9K17mYPqfj2EnOvf0/
         S4CJYQATsu9qgI7PwtF3TRQ4glyF3fiPVqPxAMa2EgtfTnqGW9rplUgJb9XZ/cxfo8FE
         OU5oawKFOqEnMt6ddv3ETTtpw4L8IOwUWjpFQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XHK8qMEJKNTFYFzFd6RoA4EfyentocUkphGdZ4KCkHI=;
        b=MaJuD464Gy/AB48xMuTItUNJddU1TPtcV3/8cysMhZeSMLNTIQa9gcjfViiMdliUbU
         NwrYcpAZ3BMUT/9+IfWIb0th3aQQ7cMFf1oVvNeykaAGOl/oyZvsOFfY2WPLMLO3MfFB
         mC7GV1VfOTLUe7APu4n4xj/kzoceW6UlHYqNc4e412+b72qJVPZ32Fg7zFaxTyv7p8Cn
         UkHzSZ7/sXAOCq/KePx2bKW7gSGJShnKYOxp4KUFFzDWSweQTp/EiJXcBkVJ0ZUuNieC
         X6zKgA7hp44uIYoLKm2FLo2svy2NsEhgI3uXagWW6pHWQkXMduTp2k7X3i9Jcnc5DCLw
         9SLw==
X-Gm-Message-State: AOAM533T1c9Zvebu7id85hIIulzNBdZcpvgWTfLpCNiPQjvmcfexlnqY
        sUNKQvNQhywuXnbgq3DFfij4/UOy9DAfq7haA+hivXuZKN4=
X-Google-Smtp-Source: ABdhPJx1kbYG9t+VNEzF7OjTU7L/jyg2twCz2tzq/cYvpMh5TuX4pHgKVzGR5dUELETsXL/O9x9SiDB1hn5KvBjSDtc=
X-Received: by 2002:a05:6808:1142:: with SMTP id u2mr249040oiu.101.1621444574682;
 Wed, 19 May 2021 10:16:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210519074323.665872-2-daniel.vetter@ffwll.ch>
 <20210519101523.688398-1-daniel.vetter@ffwll.ch> <CAOFGe968OKdHu9BL0hU6KWM3J5Fc6popg4GJ5kEDd-3bf4HjJw@mail.gmail.com>
In-Reply-To: <CAOFGe968OKdHu9BL0hU6KWM3J5Fc6popg4GJ5kEDd-3bf4HjJw@mail.gmail.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 19 May 2021 19:16:03 +0200
Message-ID: <CAKMK7uFAXBU6Ot8xJkrXBVppnWi058pEyMjNOAChtepgcCKsrw@mail.gmail.com>
Subject: Re: [PATCH] Revert "drm/i915: Propagate errors on awaiting already
 signaled fences"
To:     Jason Ekstrand <jason@jlekstrand.net>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Jason Ekstrand <jason.ekstrand@intel.com>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        stable <stable@vger.kernel.org>,
        Jon Bloomfield <jon.bloomfield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 19, 2021 at 5:06 PM Jason Ekstrand <jason@jlekstrand.net> wrote:
>
> Once we no longer rely on error propagation, I think there's a lot we
> can rip out.

I honestly did not find that much ... what did you uncover?
-Daniel

>
> --Jason
>
> On Wed, May 19, 2021 at 5:15 AM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> >
> > From: Jason Ekstrand <jason@jlekstrand.net>
> >
> > This reverts commit 9e31c1fe45d555a948ff66f1f0e3fe1f83ca63f7.  Ever
> > since that commit, we've been having issues where a hang in one client
> > can propagate to another.  In particular, a hang in an app can propagate
> > to the X server which causes the whole desktop to lock up.
> >
> > Error propagation along fences sound like a good idea, but as your bug
> > shows, surprising consequences, since propagating errors across security
> > boundaries is not a good thing.
> >
> > What we do have is track the hangs on the ctx, and report information to
> > userspace using RESET_STATS. That's how arb_robustness works. Also, if my
> > understanding is still correct, the EIO from execbuf is when your context
> > is banned (because not recoverable or too many hangs). And in all these
> > cases it's up to userspace to figure out what is all impacted and should
> > be reported to the application, that's not on the kernel to guess and
> > automatically propagate.
> >
> > What's more, we're also building more features on top of ctx error
> > reporting with RESET_STATS ioctl: Encrypted buffers use the same, and the
> > userspace fence wait also relies on that mechanism. So it is the path
> > going forward for reporting gpu hangs and resets to userspace.
> >
> > So all together that's why I think we should just bury this idea again as
> > not quite the direction we want to go to, hence why I think the revert is
> > the right option here.Signed-off-by: Jason Ekstrand <jason.ekstrand@intel.com>
> >
> > v2: Augment commit message. Also restore Jason's sob that I
> > accidentally lost.
> >
> > Signed-off-by: Jason Ekstrand <jason.ekstrand@intel.com> (v1)
> > Reported-by: Marcin Slusarz <marcin.slusarz@intel.com>
> > Cc: <stable@vger.kernel.org> # v5.6+
> > Cc: Jason Ekstrand <jason.ekstrand@intel.com>
> > Cc: Marcin Slusarz <marcin.slusarz@intel.com>
> > Cc: Jon Bloomfield <jon.bloomfield@intel.com>
> > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3080
> > Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
> > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > ---
> >  drivers/gpu/drm/i915/i915_request.c | 8 ++------
> >  1 file changed, 2 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> > index 970d8f4986bb..b796197c0772 100644
> > --- a/drivers/gpu/drm/i915/i915_request.c
> > +++ b/drivers/gpu/drm/i915/i915_request.c
> > @@ -1426,10 +1426,8 @@ i915_request_await_execution(struct i915_request *rq,
> >
> >         do {
> >                 fence = *child++;
> > -               if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
> > -                       i915_sw_fence_set_error_once(&rq->submit, fence->error);
> > +               if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
> >                         continue;
> > -               }
> >
> >                 if (fence->context == rq->fence.context)
> >                         continue;
> > @@ -1527,10 +1525,8 @@ i915_request_await_dma_fence(struct i915_request *rq, struct dma_fence *fence)
> >
> >         do {
> >                 fence = *child++;
> > -               if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
> > -                       i915_sw_fence_set_error_once(&rq->submit, fence->error);
> > +               if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
> >                         continue;
> > -               }
> >
> >                 /*
> >                  * Requests on the same timeline are explicitly ordered, along
> > --
> > 2.31.0
> >



-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
