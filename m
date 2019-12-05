Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBC31149AC
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 00:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbfLEXIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 18:08:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbfLEXIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Dec 2019 18:08:15 -0500
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 934D324670
        for <stable@vger.kernel.org>; Thu,  5 Dec 2019 23:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575587294;
        bh=CeEq+cfBX/gAyD/rZxuk9vUaxOtOXyqAmhbxth/RGxY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fEe3IdstOxkYd+80F7cYNhCKIo//MQIkLe3pUGqmQH3xEImCutKQIxQocYR58IVdV
         ks+e9LPtkLztzHApd14yjm+LQqWsn7g5GHDVVgzsyNfc1okVTD8tmRvARn7qMemETi
         qIrRkBuTp0LQTY75lFSaBPRyW2L7yK5ZJ54X054c=
Received: by mail-qv1-f41.google.com with SMTP id z3so2003175qvn.0
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 15:08:14 -0800 (PST)
X-Gm-Message-State: APjAAAVylVOWkdXiMAn31uTt9SuxHtrnfzf6KL5K6FWdvCmAQrJ3jm64
        kOwStGEi96vtFPd5NjCcNZWCU5i8xF0TRSxn9w==
X-Google-Smtp-Source: APXvYqyxkxAoggGPptj2IEwBrr4+FXZBSbsJ155K6UH5SeCimRJy0v+hBW/RkTmFJnYtOCrIFOGTSiAbvdfbdw9AmbM=
X-Received: by 2002:ad4:4511:: with SMTP id k17mr5733756qvu.135.1575587293693;
 Thu, 05 Dec 2019 15:08:13 -0800 (PST)
MIME-Version: 1.0
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
 <20191129135908.2439529-3-boris.brezillon@collabora.com> <dd8a946c-5666-a7b8-f7bc-06647e0d0bbc@arm.com>
 <20191129153310.2f9c80e1@collabora.com>
In-Reply-To: <20191129153310.2f9c80e1@collabora.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 5 Dec 2019 17:08:02 -0600
X-Gmail-Original-Message-ID: <CAL_JsqK_+U4G-EZXfBo+NhwZRsSyyndxuuh8LH88im0C5EKzeA@mail.gmail.com>
Message-ID: <CAL_JsqK_+U4G-EZXfBo+NhwZRsSyyndxuuh8LH88im0C5EKzeA@mail.gmail.com>
Subject: Re: [PATCH 2/8] drm/panfrost: Fix a race in panfrost_ioctl_madvise()
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Steven Price <steven.price@arm.com>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        stable <stable@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 29, 2019 at 8:33 AM Boris Brezillon
<boris.brezillon@collabora.com> wrote:
>
> On Fri, 29 Nov 2019 14:24:48 +0000
> Steven Price <steven.price@arm.com> wrote:
>
> > On 29/11/2019 13:59, Boris Brezillon wrote:
> > > If 2 threads change the MADVISE property of the same BO in parallel we
> > > might end up with an shmem->madv value that's inconsistent with the
> > > presence of the BO in the shrinker list.
> >
> > I'm a bit worried from the point of view of user space sanity that you
> > observed this - but clearly the kernel should be robust!
>
> It's not something I observed, just found the race by inspecting the
> code, and I thought it was worth fixing it.

I'm not so sure there's a race. If there is, we still check madv value
when purging, so it would be harmless even if the state is
inconsistent.

> > > The easiest solution to fix that is to protect the
> > > drm_gem_shmem_madvise() call with the shrinker lock.
> > >
> > > Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> >
> > Reviewed-by: Steven Price <steven.price@arm.com>
>
> Thanks.
>
> >
> > > ---
> > >  drivers/gpu/drm/panfrost/panfrost_drv.c | 9 ++++-----
> > >  1 file changed, 4 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
> > > index f21bc8a7ee3a..efc0a24d1f4c 100644
> > > --- a/drivers/gpu/drm/panfrost/panfrost_drv.c
> > > +++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
> > > @@ -347,20 +347,19 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
> > >             return -ENOENT;
> > >     }
> > >
> > > +   mutex_lock(&pfdev->shrinker_lock);
> > >     args->retained = drm_gem_shmem_madvise(gem_obj, args->madv);

This means we now hold the shrinker_lock while we take the pages_lock.
Is lockdep happy with this change? I suspect not given all the fun I
had getting lockdep happy.

Rob
