Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852442756BB
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 12:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgIWK6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 06:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgIWK6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 06:58:41 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697E8C0613CE
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 03:58:41 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id x69so24520635oia.8
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 03:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wDiVGOW2BwVoj+byF8GmVc4hZoZxCN4FNEDgvLDpQ1k=;
        b=Qdl9ZA+ZTkR35bC8SLkZu9gmZz0yIkZzf7fKlMtexw60Ein4nPVkpSZdq9H4b/uQNE
         ym/7FKqm2OjdqPm5ssrHThHs7fQORtaSTkbYAoMJcXd6zsMkSRPtq+uCBJ7yDajwu2T7
         3POcxNH9Erym7dLnHVvozChqgrTpMfAQqddds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wDiVGOW2BwVoj+byF8GmVc4hZoZxCN4FNEDgvLDpQ1k=;
        b=q8d9BdBPaiRwQNzPgMk9Eiav5Dt+Qh4dtbYblHcoquix+V8yBE9BTyiXd/iyRvHs2s
         icL41WX/M3xgQwJDPV+OjxL1OPfCmQFtUR1TmzQ9jpyHlGDDiTYiQefHCN11fUn276wC
         WKqhQMDgf/7l9KsOMX4UMgfmUM2d1nDMxPWUiO0wbpgr2lroVKWXwriF81ze3pbnctdu
         9QJaEZzrpFbSMKeD+Xu3kuXwNHd3k7kDkem9mo7s0/5f0PQcros+A6/Fl0FVcMY/A5BS
         aS7bES0eArUy9n8nq6Sg1aTbRi5kGZZxKJQ95LCQdzCqPTVntNFRXO0Mw3xD3RhO0LLg
         t25w==
X-Gm-Message-State: AOAM530DAiq7hZBjMnfyM+lUoavaSZJm/EEtRD6IRMgLM7uwe4Obf1+h
        NZFAMFLD6i94XzZGM5T94TIMo51Qhm93D9sudP0HcQ==
X-Google-Smtp-Source: ABdhPJxfxLPKhyX0sj8rLdjW3NuP47epv2iLZ1JCv3JNotaYE+HIg78XpuC6HN1WlipJCa2mmIVWRxwkFtnAzZPhCt0=
X-Received: by 2002:aca:49c2:: with SMTP id w185mr4818246oia.101.1600858720790;
 Wed, 23 Sep 2020 03:58:40 -0700 (PDT)
MIME-Version: 1.0
References: <20180705101043.4883-1-daniel.vetter@ffwll.ch> <20180705102121.5091-1-daniel.vetter@ffwll.ch>
 <CAPj87rN48S8+pLd0ksOX4pdCTqtO=bDgjhkPxpWr_AnpVvgaSQ@mail.gmail.com> <20200922133636.GA2369@xpredator>
In-Reply-To: <20200922133636.GA2369@xpredator>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 23 Sep 2020 12:58:30 +0200
Message-ID: <CAKMK7uHr3dKu8o4e3hoSe3S5MfVtZ92nLk1VGZTqSuDsH6kphg@mail.gmail.com>
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
>
> Noticed this is fixing (also) DPMS when multiple outputs are in use.
> Wondering if we can just use a _ONCE() variant instead of WARN_ON(). I'm seeing
> the warning quite often.

On which driver/chip does this happen?
-Daniel

>
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
