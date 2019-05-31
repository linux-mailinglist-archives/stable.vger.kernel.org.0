Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D282314ED
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 20:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfEaSuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 14:50:25 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39516 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfEaSuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 14:50:25 -0400
Received: by mail-ed1-f68.google.com with SMTP id e24so15950056edq.6;
        Fri, 31 May 2019 11:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9F1WuqVm5Nwgt2J2M3yybMSAaWZKrJwC/jdTGtkMibQ=;
        b=i/FN5emthvipoIzFp3zGS9/f6xBcQBDTkQ7GC/lmQe0TwDLTHCS3IgiVtCQRBB44uB
         6WEp7SwcJyAqdjMEYkv19i0jR/gVwbKMEhj2oMHnhpkKRJZ5d0RmumzwB+qOHE1anNKc
         0EoAj2WEuDVIMfXdkxJ3IGB25hWm23hdRd/FWTJFpXyho+ouicbkZl4TX2nNirMfcJ64
         mai4mjwMYtQ6nXS7rThoZY8t1lc4IYhFlbouzCfip/E3hE+7kuTzGaxnhDM8chWESfLK
         33z4dteGs8q9xfQWTk8CUAzFuf3deuNaSOza9pxhkogn2H2EOi/hLl8Wobn2pzywPjxr
         xrfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9F1WuqVm5Nwgt2J2M3yybMSAaWZKrJwC/jdTGtkMibQ=;
        b=RJh9o9MV3rfUIu2h0nNdDOZO7JgeoBidWqeCXH2hBCsyCG4sT5Nzzp02lsTwg7foHL
         KMWkn4jflkC9Mr8bXkiAEpfXFMkEtuyZpxSKJFBlLIw42tXUsFD1kmSu5J7dh/pJ8+/o
         xdTS5Y5+xAsX7G6NkAQnrW5ZursvoJHYsoQQxZiOBu2uvev8WTC4aKU2+L5bO9UFulVF
         C8xK9fg64X0bH5uVNnYBH9Uo98aNcfaNZS5WcjNCM5YKuQyQl1aIdzrp//203hLrl+A1
         nW2Lr/LZynjGC2leScEOfllBMCC0gl/714+Whrk2LLmIb5/wPr1JegbYfn/Y75XIMHP5
         xBCw==
X-Gm-Message-State: APjAAAV9qePpBsgcZ85CQrMQ3SRfxN4NdRgWVxN/wD9qBFo7kOdG9BmA
        xlVW3wpuWnjza1cZGn0IRtLQ/hNpCccKYzTwXQpyQhWp
X-Google-Smtp-Source: APXvYqzPMqyWQ+/oc5RiQ0JtssEbM6wdvalwO7IL3dmiggPgXl4aCaKyvkmw+wPethuMjUFG0dLNSwtXsRd8qIV8JHw=
X-Received: by 2002:a50:bc15:: with SMTP id j21mr13082718edh.163.1559328623286;
 Fri, 31 May 2019 11:50:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190314002027.7833-1-helen.koike@collabora.com>
 <20190314002027.7833-4-helen.koike@collabora.com> <c591d04c-a7f8-f64b-aff9-4a79b61356e7@koikeco.de>
In-Reply-To: <c591d04c-a7f8-f64b-aff9-4a79b61356e7@koikeco.de>
From:   Rob Clark <robdclark@gmail.com>
Date:   Fri, 31 May 2019 11:50:09 -0700
Message-ID: <CAF6AEGsRzgqNPPuNTopiqXWXQ8GLd1Zi2DsWZFQQ5PuCsDnmBA@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] drm/msm: fix fb references in async update
To:     Helen Koike <helen@koikeco.de>
Cc:     Helen Koike <helen.koike@collabora.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        nicholas.kazlauskas@amd.com,
        "Grodzovsky, Andrey" <andrey.grodzovsky@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        David Airlie <airlied@linux.ie>,
        Sean Paul <seanpaul@google.com>, kernel@collabora.com,
        Harry Wentland <harry.wentland@amd.com>,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@google.com>,
        stable <stable@vger.kernel.org>, Sean Paul <sean@poorly.run>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        freedreno <freedreno@lists.freedesktop.org>,
        Mamta Shukla <mamtashukla555@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 31, 2019 at 10:54 AM Helen Koike <helen@koikeco.de> wrote:
>
> Hello,
>
> On 3/13/19 9:20 PM, Helen Koike wrote:
> > Async update callbacks are expected to set the old_fb in the new_state
> > so prepare/cleanup framebuffers are balanced.
> >
> > Cc: <stable@vger.kernel.org> # v4.14+
> > Fixes: 224a4c970987 ("drm/msm: update cursors asynchronously through atomic")
> > Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
> > Signed-off-by: Helen Koike <helen.koike@collabora.com>

Thanks, I'm not super happy about the refcnt'ing subtleness here
(mostly because it makes it harder to page in how things work on
kernel/display side after spending most of my time in userspace/mesa),
but I don't want to hold this up..

Acked-by: Rob Clark <robdclark@gmail.com>

> >
> > ---
> > Hello,
> >
> > As mentioned in the cover letter,
> > But I couldn't test on MSM because I don't have the hardware and I would
> > appreciate if anyone could test it.
>
> I got this tested on a dragonboard 410c, no regressions where found and
> no extra warnings.
>
> These two tests where already failing for other reasons:
> flip-vs-cursor-crc-atomic
> flip-vs-cursor-crc-legacy
>
> If you want to see the full log:
>
> https://people.collabora.com/~koike/drm-fixes-results.zip
>
> Thanks
> Helen
>
> >
> > In other platforms (VC4, AMD, Rockchip), there is a hidden
> > drm_framebuffer_get(new_fb)/drm_framebuffer_put(old_fb) in async_update
> > that is wrong, but I couldn't identify those here, not sure if it is hidden
> > somewhere else, but if tests fail this is probably the cause.
> >
> > Thanks!
> > Helen
> >
> > Changes in v3: None
> > Changes in v2:
> > - update CC stable and Fixes tag
> >
> >  drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
> > index be13140967b4..b854f471e9e5 100644
> > --- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
> > +++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
> > @@ -502,6 +502,8 @@ static int mdp5_plane_atomic_async_check(struct drm_plane *plane,
> >  static void mdp5_plane_atomic_async_update(struct drm_plane *plane,
> >                                          struct drm_plane_state *new_state)
> >  {
> > +     struct drm_framebuffer *old_fb = plane->state->fb;
> > +
> >       plane->state->src_x = new_state->src_x;
> >       plane->state->src_y = new_state->src_y;
> >       plane->state->crtc_x = new_state->crtc_x;
> > @@ -524,6 +526,8 @@ static void mdp5_plane_atomic_async_update(struct drm_plane *plane,
> >
> >       *to_mdp5_plane_state(plane->state) =
> >               *to_mdp5_plane_state(new_state);
> > +
> > +     new_state->fb = old_fb;
> >  }
> >
> >  static const struct drm_plane_helper_funcs mdp5_plane_helper_funcs = {
> >
