Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032511D28AE
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 09:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgENHZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 03:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgENHZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 03:25:18 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA11C061A0C
        for <stable@vger.kernel.org>; Thu, 14 May 2020 00:25:18 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id q11so1581702oti.6
        for <stable@vger.kernel.org>; Thu, 14 May 2020 00:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4m4GsWsg3moFd2EMtxekqKsuJbaE5pcNAv0WoPBeQ3I=;
        b=etx/9+3k/PN31xvhF9ZvlqlxADInKL8MNC1uIGe0Pc5i7/kRGLG1Jmz0DDD4A/2qZt
         Bgsd7L79bH35Mwl6gRK8nf2gCm9a1XYeW410LR/c0YTun6fIoLql2v8UzE8i+yQii1m8
         oikTiCHcQlCNu3RjEl/aMSKKGmA8jcj2+z4w8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4m4GsWsg3moFd2EMtxekqKsuJbaE5pcNAv0WoPBeQ3I=;
        b=DmydCm0uua/9j18un//0BQfTPAyVtCpnKLfMy5tM9VPdmdmPu8CgUsKDqfEr8DlaO2
         Jf9cdTHCltuz12eaAqQY2xCyqnvGb8iJRld165CV9467AsQEtv6wrVpm66L+AgvwaHlr
         yIEsmqEgwNHwIfbpDlb+vaLWMcYd8/aUsLf4+mVUlC1WtNv9j8D3MPiNrVoWdBzfA+np
         9yySzAWXTQvGaUpDS/fUnucQBPAjsM7KgTd0EvLVKnTIohxkpmo5/plTNX2PknLzK+Ep
         wi208NFielE8aA6xBx9pXFieL5QUpRXfC0KHCZbi815mYYJHI2uI2ZTQ2kU+wOFXguXH
         UxlQ==
X-Gm-Message-State: AOAM531YxpY1Ldr3YyZ6amxZl/IIJGwbNYR6xB6LpvqlON/jRTiCkeRJ
        Hu7FA8YZOVC56ZzC3uYR13s08jeDAtH6VIZ+xajOZHZI
X-Google-Smtp-Source: ABdhPJx4+owiZJ/zx4xR1kDM6DcrXQiTCwgv8pUXCsVluHYgsIYT+dirW430+vSExoNU/GRYPcidlxUcRCrvrPsNHBM=
X-Received: by 2002:a05:6830:1d0:: with SMTP id r16mr2368598ota.303.1589441118124;
 Thu, 14 May 2020 00:25:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200408162403.3616785-1-daniel.vetter@ffwll.ch>
 <CAPj87rMJNwp0t4B0KxH7J_2__4eT7+ZJeG-=_juLSDhPc2hLHQ@mail.gmail.com>
 <CAKMK7uFU7ST9LWmpfhTuk1-_ES6VU-cUogMnPjA15BWFsEVacw@mail.gmail.com> <CAPj87rNRLsGJcGEM3dYnitYMwjh7iMNjo9KT=xcDZ0hebRC9iw@mail.gmail.com>
In-Reply-To: <CAPj87rNRLsGJcGEM3dYnitYMwjh7iMNjo9KT=xcDZ0hebRC9iw@mail.gmail.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu, 14 May 2020 09:25:06 +0200
Message-ID: <CAKMK7uG6krmntPW6Mud7aouvM=NRspYHoBdKeSwxS8wDwDZRkQ@mail.gmail.com>
Subject: Re: [PATCH] drm: avoid spurious EBUSY due to nonblocking atomic modesets
To:     Daniel Stone <daniel@fooishbar.org>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        stable <stable@vger.kernel.org>,
        Daniel Stone <daniels@collabora.com>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 14, 2020 at 9:18 AM Daniel Stone <daniel@fooishbar.org> wrote:
>
> Hi,
>
> On Thu, 14 May 2020 at 08:08, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > > Did anything happen with this?
> >
> > Nope. There's an igt now that fails with this, and I'm not sure
> > whether changing the igt is the right idea or not.
> >
> > I'm kinda now thinking about changing this to instead document under
> > which exact situations you can get a spurious EBUSY, and enforcing
> > that in the code with some checks. Essentially only possible if you do
> > a ALLOW_MODESET | NONBLOCKING on the other crtc. And then tell
> > userspace you get to eat that. We've been shipping with this for so
> > long by now that's defacto the uapi anyway :-/
> >
> > Thoughts? Too horrible?
>
> I've been trying to avoid that, to be honest. Taking a random delay
> because the kernel needs to do global things is fine. But making
> userspace either do an expensive/complicated cross-CRTC
> synchronisation is less easy; for some compositors, that means
> reaching across threads to make sure all CRTCs are quiescent. Either
> that, or deferring your ALLOW_MODESET to somewhere else, like an idle
> handler, far away from where you were originally trying to do it,
> which wouldn't be pleasant. The other option is that we teach people
> to ignore EBUSY as random noise which can just sometimes happen and to
> try again (when? how often? and you still have cross-CRTC
> synchronisation issues), which doesn't scream compositor best practice
> to me.
>
> I'd be very much in favour of putting the blocking down in the kernel
> at least until the kernel can give us a clear indication to tell us
> what's going on, and ideally which other resources need to be dragged
> in, in a way which is distinguishable from your compositor having
> broken synchronisation.

We know, the patch already computes that ... So would be a matter of
exporting that to userspace. We have a mask of all additional crtc
that will get an event and will -EBUSY until that's done.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
