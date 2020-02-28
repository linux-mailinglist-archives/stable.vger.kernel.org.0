Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03609173572
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 11:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgB1KjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 05:39:19 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:46730 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgB1KjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 05:39:18 -0500
Received: by mail-vs1-f65.google.com with SMTP id t12so1602246vso.13;
        Fri, 28 Feb 2020 02:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IVkeix1fcnYZXRBUxfNVTT56PIOklSoyZMm+hTUJTz0=;
        b=Ameog9Zplz9fAzkjb6NxOLgSMttnlM8uqXZaWcCJ1N+7pd6rAmQgf1NkyDX0hZOt3T
         wWV2Xrl+rAqWG8MwHYmsMGLU4pB4suuNd06Ev9ZeFjdo3oxqO40wHYIoR3qw2MNWRo/K
         UCFlIxe9qUeFjcFgfwUShKXmY8xiI0/srqeQ/W279OjO4bcsX7SpbqBh24dNwiDt++aL
         zmHJ6n7Th3+Eqfh2JJ5xVp0GS1UATfwzqohFkVaDFNsqV6591Eap7TtCPbvqwqeSMFhu
         8wxA/A2lAHK0xqRohlG4FBFOIRxWAtjchpgAso7x67VHxq8QpeHBqRnXNb80rchhR3uM
         BfPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IVkeix1fcnYZXRBUxfNVTT56PIOklSoyZMm+hTUJTz0=;
        b=l39XTe7cR2Ig6chcmEKSNHcZbgXnw0Vtq4edxDAi+QEYYMebsRQGXaJdVdDfcVwp76
         tfFjF2wvq0W2zyno69htsL/XUAT7n5cyVfFH1BD2hgnZav8kEeKwq6tlIjSuaPhwj7Lw
         5u/K8qneWiVqduLwQFTkPGn/PL5U7iLqRRJBSbUD0QoIXGxWfEuJ5S9LihzXYKyPIo+Y
         EdLASgk2aCEcqqpWrwxROWGflZpuHLdhmZIzJcH/eFuZiCoeC4wtl9C91vPAlaYwRQin
         LHyLLBRHkB5kQkitrVj9E7sQDoOMMU3IDl4+CDx/4tQsCiGWGDNxGI/ASk3T5DQBQw1z
         WNJA==
X-Gm-Message-State: ANhLgQ2w/ZY+g2be4HPYB6GFckyxiTgvIRK6gWOl5RMDsbrLoxvSDceG
        rd3fKnNUNeUkCtQer6q75lgKHeb6K3vZd/ijGLfdpXXG
X-Google-Smtp-Source: ADFU+vueeYEl9uMwIRv51UteUXQvmnDkMiNGIO2wkpX77fcl1BU/O4Ks+yfXVc+t5PicvqKK+dNtCRByY+iZ7df3CnA=
X-Received: by 2002:a67:e912:: with SMTP id c18mr2058699vso.72.1582886357500;
 Fri, 28 Feb 2020 02:39:17 -0800 (PST)
MIME-Version: 1.0
References: <20200106104339.215511-1-christian.gmeiner@gmail.com> <78e5e739269ee8f7467284ad88d2097e2ad991ba.camel@pengutronix.de>
In-Reply-To: <78e5e739269ee8f7467284ad88d2097e2ad991ba.camel@pengutronix.de>
From:   Christian Gmeiner <christian.gmeiner@gmail.com>
Date:   Fri, 28 Feb 2020 11:39:05 +0100
Message-ID: <CAH9NwWe85qELoLisKgVdZYeeBkngAk9qQVNDA3=cp4_uRwXsEw@mail.gmail.com>
Subject: Re: [PATCH] drm/etnaviv: rework perfmon query infrastructure
To:     Lucas Stach <l.stach@pengutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        The etnaviv authors <etnaviv@lists.freedesktop.org>,
        stable@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lucas,

Am Mi., 26. Feb. 2020 um 16:19 Uhr schrieb Lucas Stach <l.stach@pengutronix.de>:
>
> Hi Christian,
>
> sorry for taking so long to get around to this.
>

No problem...

> On Mo, 2020-01-06 at 11:43 +0100, Christian Gmeiner wrote:
> > Report the correct perfmon domains and signals depending
> > on the supported feature flags.
> >
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Fixes: 9e2c2e273012 ("drm/etnaviv: add infrastructure to query perf counter")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
> > ---
> >  drivers/gpu/drm/etnaviv/etnaviv_perfmon.c | 57 ++++++++++++++++++++---
> >  1 file changed, 50 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> > index 8adbf2861bff..7ae8f347ca06 100644
> > --- a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> > +++ b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> > @@ -32,6 +32,7 @@ struct etnaviv_pm_domain {
> >  };
> >
> >  struct etnaviv_pm_domain_meta {
> > +     unsigned int feature;
> >       const struct etnaviv_pm_domain *domains;
> >       u32 nr_domains;
> >  };
> > @@ -410,36 +411,78 @@ static const struct etnaviv_pm_domain doms_vg[] = {
> >
> >  static const struct etnaviv_pm_domain_meta doms_meta[] = {
> >       {
> > +             .feature = chipFeatures_PIPE_3D,
> >               .nr_domains = ARRAY_SIZE(doms_3d),
> >               .domains = &doms_3d[0]
> >       },
> >       {
> > +             .feature = chipFeatures_PIPE_2D,
> >               .nr_domains = ARRAY_SIZE(doms_2d),
> >               .domains = &doms_2d[0]
> >       },
> >       {
> > +             .feature = chipFeatures_PIPE_VG,
> >               .nr_domains = ARRAY_SIZE(doms_vg),
> >               .domains = &doms_vg[0]
> >       }
> >  };
> >
> > +static unsigned int num_pm_domains(const struct etnaviv_gpu *gpu)
> > +{
> > +     unsigned int num = 0, i;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(doms_meta); i++) {
> > +             const struct etnaviv_pm_domain_meta *meta = &doms_meta[i];
> > +
> > +             if (gpu->identity.features & meta->feature)
> > +                     num += meta->nr_domains;
> > +     }
> > +
> > +     return num;
> > +}
> > +
> > +static const struct etnaviv_pm_domain *pm_domain(const struct etnaviv_gpu *gpu,
> > +     unsigned int index)
> > +{
> > +     const struct etnaviv_pm_domain *domain = NULL;
> > +     unsigned int offset = 0, i;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(doms_meta); i++) {
> > +             const struct etnaviv_pm_domain_meta *meta = &doms_meta[i];
> > +
> > +             if (!(gpu->identity.features & meta->feature))
> > +                     continue;
> > +
> > +             if (meta->nr_domains < (index - offset)) {
> > +                     offset += meta->nr_domains;
> > +                     continue;
> > +             }
> > +
> > +             domain = meta->domains + (index - offset);
> > +     }
> > +
> > +     BUG_ON(!domain);
>
> This is a no-go. BUG_ON is reserved for only the most severe kernel
> bugs where you can't possibly continue without risking a corruption of
> non-volatile state. This isn't the case here, please instead just make
> the callers handle a NULL return gracefully.
>

Fixed it in V2.

-- 
greets
--
Christian Gmeiner, MSc

https://christian-gmeiner.info/privacypolicy
