Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B962743CB
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 16:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgIVOEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 10:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgIVOEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 10:04:37 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80096C061755
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 07:04:37 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id m13so11223660otl.9
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 07:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4wgsKb3OxXUR5z4H154VpwPi1Z3KYkIOiID7wIY/k60=;
        b=VuFbLfEkHjH/cqWfMgjOT1SBBW/VmcOZqmgV9/23MU+ZebYLhjw6ZxNSK7QeDY1nps
         vFdkzJgmBfJmbbz1bLI8yzePYGFfIX0SU9TTcX2dIsY4uN+cS4vZ1qWiH69Veq+qgLeY
         Lib7wisL9um7XAFnG2j4K0NDro2WwTdN3zD5g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4wgsKb3OxXUR5z4H154VpwPi1Z3KYkIOiID7wIY/k60=;
        b=anMZ5ry3fYVQyEAgfc45thgTX36gzoKhKs6cE/rOu3gwUb9eM7UMC+XyKTq3stpnuU
         XZzGK40EPFchXxPiM9bTAjm9fLDiMkkbBiKD290TKw5UlWWRniu3g8nVxdqHMoOuJN0m
         SIbOlBzleNorOxwMn3P3VagSA0KIIbM4W5P9SlqrHjfZHOBaY1bFBMq9C+mqegE5oBwY
         NZggxV1EjakY3pXzumfHaUfAACv62GEGwLsZSKT8nSpRbYazLpV4ZDFlQ2b1pIiG5x78
         CsTCFTHI5qOi+0vihCoyLtnCJzNx/nX2rsKikoeylEJjkdn0MVYzGUyrtxNPchWYX1WJ
         EcIw==
X-Gm-Message-State: AOAM532GCCej67JwjhTsLH/N2RwDaJdr8FCDlKKLQB7isxihjKzgKuq4
        9/I6EV5a0X0+JMaoQyJgOAuPf2Dd3Dsh5WggNhp89x/5z1nxpg==
X-Google-Smtp-Source: ABdhPJyBv0gaPZG8IMejxtaWlLqVobObYy9jnCpfJVkRMSl5clWfYxjah6xzCFeAm32mJoMmmJgojTQBRrTDfhZWFQ4=
X-Received: by 2002:a05:6830:1e56:: with SMTP id e22mr2796996otj.303.1600783476894;
 Tue, 22 Sep 2020 07:04:36 -0700 (PDT)
MIME-Version: 1.0
References: <20180705101043.4883-1-daniel.vetter@ffwll.ch> <20180705102121.5091-1-daniel.vetter@ffwll.ch>
 <CAPj87rN48S8+pLd0ksOX4pdCTqtO=bDgjhkPxpWr_AnpVvgaSQ@mail.gmail.com> <20200922133636.GA2369@xpredator>
In-Reply-To: <20200922133636.GA2369@xpredator>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 22 Sep 2020 16:04:26 +0200
Message-ID: <CAKMK7uHCeFan4+agMn0sr-z9UDyZwEJv0_dL-K-gA1n0=m+A2w@mail.gmail.com>
Subject: Re: [PATCH] drm: avoid spurious EBUSY due to nonblocking atomic modesets
To:     Marius Vlad <marius.vlad@collabora.com>
Cc:     Daniel Stone <daniel@fooishbar.org>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 3:36 PM Marius Vlad <marius.vlad@collabora.com> wrote:
>
> On Fri, Jan 31, 2020 at 07:34:00AM +0000, Daniel Stone wrote:
> > On Thu, 5 Jul 2018 at 11:21, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > > When doing an atomic modeset with ALLOW_MODESET drivers are allowed to
> > > pull in arbitrary other resources, including CRTCs (e.g. when
> > > reconfiguring global resources).
> > >
> > > But in nonblocking mode userspace has then no idea this happened,
> > > which can lead to spurious EBUSY calls, both:
> > > - when that other CRTC is currently busy doing a page_flip the
> > >   ALLOW_MODESET commit can fail with an EBUSY
> > > - on the other CRTC a normal atomic flip can fail with EBUSY because
> > >   of the additional commit inserted by the kernel without userspace's
> > >   knowledge
> > >
> > > For blocking commits this isn't a problem, because everyone else will
> > > just block until all the CRTC are reconfigured. Only thing userspace
> > > can notice is the dropped frames without any reason for why frames got
> > > dropped.
> > >
> > > Consensus is that we need new uapi to handle this properly, but no one
> > > has any idea what exactly the new uapi should look like. As a stop-gap
> > > plug this problem by demoting nonblocking commits which might cause
> > > issues by including CRTCs not in the original request to blocking
> > > commits.
> Gentle ping. I've tried out Linus's master tree and, and like Pekka,
> I've noticed this isn't integrated/added.

Defacto the uapi we have now is that userspace needs to ignore "spurious" EBUSY.

> Noticed this is fixing (also) DPMS when multiple outputs are in use.
> Wondering if we can just use a _ONCE() variant instead of WARN_ON(). I'm seeing
> the warning quite often.

This would be a driver bug I think. That really shouldn't happen for
normal page flips.
-Daniel

> >
> > Thanks for writing this up Daniel, and for reminding me about it some
> > time later as well ...
> >
> > Reviewed-by: Daniel Stone <daniels@collabora.com>
> >
> > Cheers,
> > Daniel
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/dri-devel



-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
