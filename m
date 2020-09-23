Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6022756FB
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 13:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgIWLQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 07:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgIWLQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 07:16:54 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F240C0613CE
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 04:16:54 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id 26so16244082ois.5
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 04:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rTSXpPPpcxIeMmfzwprfzSe0gqeoKE7piFOaQTAnR88=;
        b=U3ePQ6UANsmOqJvqkSDwhxC0dOVjzUOwE4x0udnLdKAnZwfoH54D6zA2aFyQNBZ6wx
         2nPN0NSQMoR5XgpW6AE5wFrsDvhtBtVH1i8rDX+nIRku/Hn3aKl/NydxLBvMqP61YHXK
         klri+iTBjmr1dXBgHh5qcNJuaXoUc/kGEvHXM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rTSXpPPpcxIeMmfzwprfzSe0gqeoKE7piFOaQTAnR88=;
        b=YHocXlB/DgZ3gvv4vV8/Dtbnx+G6YsRrY1+3hJFNFvBcceZFReIqRixbGitb5+UYVi
         I/z6MrXovsHD1Rms0apO3SE21294OjlDT0dzCR4RgY+Y5SPcBvZK1CyKI9RuJdjcXWwc
         7XffMW6kzlOCGZQYzOljP/IiGHdyQ10gxfFqWCf/hBIC+OjQdpEGfL0B+Acud1dnvI1P
         b7bGoDfM+SfuTix5sqag0qydgpQIyt+XYnsTgi0GRkotW+3FRFGTXM0vvroA2MFCE8v0
         1C/is1MF2yAtbZhNsthl774rXXPVlh34rq6z+e8NlQXg2Yk7Q4M+9U3YThg0ZNjhxp+V
         VSCw==
X-Gm-Message-State: AOAM533BK2cc5LQx0LfQh0gAQlENtjjJ7NfvoB/jUJzsgGnDoZB0eTfa
        WUh+QKi5V3G23FC3hHphSsohTeNf1RvGLFwyzM+D7Q==
X-Google-Smtp-Source: ABdhPJym2IcGvMv5rOZjsbiRqhxPjtR71Yu3t2aEm8NnZePkvZj0lvdMkwwEEHrfVsZ043SiVMMfQ1JGyPCTmC7z9Bw=
X-Received: by 2002:a05:6808:206:: with SMTP id l6mr5446894oie.128.1600859813680;
 Wed, 23 Sep 2020 04:16:53 -0700 (PDT)
MIME-Version: 1.0
References: <20180705101043.4883-1-daniel.vetter@ffwll.ch> <20180705102121.5091-1-daniel.vetter@ffwll.ch>
 <CAPj87rN48S8+pLd0ksOX4pdCTqtO=bDgjhkPxpWr_AnpVvgaSQ@mail.gmail.com>
 <20200922133636.GA2369@xpredator> <CAKMK7uHr3dKu8o4e3hoSe3S5MfVtZ92nLk1VGZTqSuDsH6kphg@mail.gmail.com>
 <20200923111443.GA8478@xpredator>
In-Reply-To: <20200923111443.GA8478@xpredator>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 23 Sep 2020 13:16:42 +0200
Message-ID: <CAKMK7uGwTbt4OdfVGVLk_0i_F5LNTx1RAaNz_D8LxnpwJo-i2Q@mail.gmail.com>
Subject: Re: [PATCH] drm: avoid spurious EBUSY due to nonblocking atomic modesets
To:     Marius Vlad <marius.vlad@collabora.com>,
        "Syrjala, Ville" <ville.syrjala@linux.intel.com>
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

On Wed, Sep 23, 2020 at 1:14 PM Marius Vlad <marius.vlad@collabora.com> wrote:
>
> On Wed, Sep 23, 2020 at 12:58:30PM +0200, Daniel Vetter wrote:
> > On Tue, Sep 22, 2020 at 3:36 PM Marius Vlad <marius.vlad@collabora.com> wrote:
> > >
> > > On Fri, Jan 31, 2020 at 07:34:00AM +0000, Daniel Stone wrote:
> > > > On Thu, 5 Jul 2018 at 11:21, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > > > > When doing an atomic modeset with ALLOW_MODESET drivers are allowed to
> > > > > pull in arbitrary other resources, including CRTCs (e.g. when
> > > > > reconfiguring global resources).
> > > > >
> > > > > But in nonblocking mode userspace has then no idea this happened,
> > > > > which can lead to spurious EBUSY calls, both:
> > > > > - when that other CRTC is currently busy doing a page_flip the
> > > > >   ALLOW_MODESET commit can fail with an EBUSY
> > > > > - on the other CRTC a normal atomic flip can fail with EBUSY because
> > > > >   of the additional commit inserted by the kernel without userspace's
> > > > >   knowledge
> > > > >
> > > > > For blocking commits this isn't a problem, because everyone else will
> > > > > just block until all the CRTC are reconfigured. Only thing userspace
> > > > > can notice is the dropped frames without any reason for why frames got
> > > > > dropped.
> > > > >
> > > > > Consensus is that we need new uapi to handle this properly, but no one
> > > > > has any idea what exactly the new uapi should look like. As a stop-gap
> > > > > plug this problem by demoting nonblocking commits which might cause
> > > > > issues by including CRTCs not in the original request to blocking
> > > > > commits.
> > > Gentle ping. I've tried out Linus's master tree and, and like Pekka,
> > > I've noticed this isn't integrated/added.
> > >
> > > Noticed this is fixing (also) DPMS when multiple outputs are in use.
> > > Wondering if we can just use a _ONCE() variant instead of WARN_ON(). I'm seeing
> > > the warning quite often.
> >
> > On which driver/chip does this happen?
> I've tried it out on i915.

lspci -nn please.

Also adding Ville, who has an idea where this can all go wrong. The
one he pointed out thus far is gen12+ only though.
-Daniel

> > -Daniel
> >
> > >
> > > >
> > > > Thanks for writing this up Daniel, and for reminding me about it some
> > > > time later as well ...
> > > >
> > > > Reviewed-by: Daniel Stone <daniels@collabora.com>
> > > >
> > > > Cheers,
> > > > Daniel
> > > > _______________________________________________
> > > > dri-devel mailing list
> > > > dri-devel@lists.freedesktop.org
> > > > https://lists.freedesktop.org/mailman/listinfo/dri-devel
> >
> >
> >
> > --
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > http://blog.ffwll.ch



-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
