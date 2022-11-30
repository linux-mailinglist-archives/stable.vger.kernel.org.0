Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3C963D45B
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 12:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbiK3LW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 06:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbiK3LVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 06:21:39 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F177721E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 03:21:23 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id ja4-20020a05600c556400b003cf6e77f89cso1325475wmb.0
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 03:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RuSCu6Sc5O77Oj3wELaaUy6VtrciSxnoo8y2CPFyY+U=;
        b=M5OU+UwmCE1dEQUm9MGdXnRpdzmbCWLfqjalSYP23MuqwTZ9RwFy/pfMOsPhuvK6s3
         RiK7JxFxDC/TRdJDjog5UlAx3+QHvvk+4eHlFtUCvbrEYR1WO7WCBR59V08EJk4u9QnO
         N8B08dkiBlp3ZJc8e7cHv8OxsGRBeXy47Ce3k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RuSCu6Sc5O77Oj3wELaaUy6VtrciSxnoo8y2CPFyY+U=;
        b=U1YhQxYOexpQfqrB2c0ZyHFUor/Z9e+nON5vcrnv+ofFiFlUBm0iixFSpFMFdIZrOI
         mxwAmGDNZ3ryYbycDesL0fEdX0zqv/Cn5TTniDZARkbnBi2ZUkJVHq4qMwU1RjcOGbWR
         DBWG4MdO4chK+S/kf0dxe8Jzrg6U2U6DwTILEoTULeAnRl/e5ywBFDVdXfe2OPS2rQoF
         3SdaBgFJyB2KUMphN7dVIw/4Bp/+34RpTZW8TvAjzhNtnXFOLd0PTjD9Hss0Z7vk1e/C
         GGLjHi/9bI/m+zMMi3ZUHEwx2K/nqeHxmpvwtNHcXxjXCji5KZcAd/L4B+J2bhk6T/kK
         Grdg==
X-Gm-Message-State: ANoB5pmkJrGj7C7UiCjKGbMMxidjZhLMREY5IwoUj5YvgKq0qMa+bV2t
        EgWTJbNZlVeKPTGrXkuVq4BgXg==
X-Google-Smtp-Source: AA0mqf7Y6ivv5bQ1OH3MnYDxUtlCUbzKEC1tIMe0iHw9hdRx5C5HeGZP24b3Lywyd5EKm1ITulLBpg==
X-Received: by 2002:a05:600c:2241:b0:3cf:9ced:dce4 with SMTP id a1-20020a05600c224100b003cf9ceddce4mr43768262wmm.120.1669807281946;
        Wed, 30 Nov 2022 03:21:21 -0800 (PST)
Received: from phenom.ffwll.local (212-51-149-33.fiber7.init7.net. [212.51.149.33])
        by smtp.gmail.com with ESMTPSA id f11-20020a05600c154b00b003c6f3e5ba42sm5960234wmg.46.2022.11.30.03.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 03:21:21 -0800 (PST)
Date:   Wed, 30 Nov 2022 12:21:19 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Rob Clark <robdclark@gmail.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Rob Clark <robdclark@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Noralf =?iso-8859-1?Q?Tr=F8nnes?= <noralf@tronnes.org>,
        dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [2/2] drm/shmem-helper: Avoid vm_open error paths
Message-ID: <Y4c8r0fxjI+WsvhM@phenom.ffwll.local>
Mail-Followup-To: Rob Clark <robdclark@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Rob Clark <robdclark@chromium.org>,
        open list <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Eric Anholt <eric@anholt.net>,
        Noralf =?iso-8859-1?Q?Tr=F8nnes?= <noralf@tronnes.org>,
        dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>
References: <20221129200242.298120-3-robdclark@gmail.com>
 <20221129203205.GA2132357@roeck-us.net>
 <CAF6AEGuK4jv25cQ4p-rrytx9Qn4JZdRRfkVJn9T3nf7vJmG5VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGuK4jv25cQ4p-rrytx9Qn4JZdRRfkVJn9T3nf7vJmG5VQ@mail.gmail.com>
X-Operating-System: Linux phenom 5.19.0-2-amd64 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 29, 2022 at 12:47:42PM -0800, Rob Clark wrote:
> On Tue, Nov 29, 2022 at 12:32 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > On Tue, Nov 29, 2022 at 12:02:42PM -0800, Rob Clark wrote:
> > > From: Rob Clark <robdclark@chromium.org>
> > >
> > > vm_open() is not allowed to fail.  Fortunately we are guaranteed that
> > > the pages are already pinned, and only need to increment the refcnt.  So
> > > just increment it directly.
> >
> > I don't know anything about drm or gem, but I am wondering _how_
> > this would be guaranteed. Would it be through the pin function ?
> > Just wondering, because that function does not seem to be mandatory.
> 
> We've pinned the pages already in mmap.. vm->open() is perhaps not the
> best name for the callback function, but it is called for copying an
> existing vma into a new process (and for some other cases which do not
> apply here because VM_DONTEXPAND).
> 
> (Other drivers pin pages in the fault handler, where there is actually
> potential to return an error, but that change was a bit more like
> re-writing shmem helper ;-))

Yhea vm_ops->open should really be called vm_ops->dupe or ->copy or
something like that ...
-Daniel

> 
> BR,
> -R
> 
> > >
> > > Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Rob Clark <robdclark@chromium.org>
> > > ---
> > >  drivers/gpu/drm/drm_gem_shmem_helper.c | 14 +++++++++++---
> > >  1 file changed, 11 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > > index 110a9eac2af8..9885ba64127f 100644
> > > --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > > +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > > @@ -571,12 +571,20 @@ static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
> > >  {
> > >       struct drm_gem_object *obj = vma->vm_private_data;
> > >       struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
> > > -     int ret;
> > >
> > >       WARN_ON(shmem->base.import_attach);
> > >
> > > -     ret = drm_gem_shmem_get_pages(shmem);
> > > -     WARN_ON_ONCE(ret != 0);
> > > +     mutex_lock(&shmem->pages_lock);
> > > +
> > > +     /*
> > > +      * We should have already pinned the pages, vm_open() just grabs
> >
> > should or guaranteed ? This sounds a bit weaker than the commit
> > description.
> >
> > > +      * an additional reference for the new mm the vma is getting
> > > +      * copied into.
> > > +      */
> > > +     WARN_ON_ONCE(!shmem->pages_use_count);
> > > +
> > > +     shmem->pages_use_count++;
> > > +     mutex_unlock(&shmem->pages_lock);
> >
> > The previous code, in that situation, would not increment pages_use_count,
> > and it would not set not set shmem->pages. Hopefully, it would not try to
> > do anything with the pages it was unable to get. The new code assumes that
> > shmem->pages is valid even if pages_use_count is 0, while at the same time
> > taking into account that this can possibly happen (or the WARN_ON_ONCE
> > would not be needed).
> >
> > Again, I don't know anything about gem and drm, but it seems to me that
> > there might now be a severe problem later on if the WARN_ON_ONCE()
> > ever triggers.
> >
> > Thanks,
> > Guenter
> >
> > >
> > >       drm_gem_vm_open(vma);
> > >  }

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
