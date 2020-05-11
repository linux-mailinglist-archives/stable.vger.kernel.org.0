Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99BC1CDA43
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 14:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbgEKMl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 08:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729470AbgEKMlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 May 2020 08:41:25 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733DAC061A0C
        for <stable@vger.kernel.org>; Mon, 11 May 2020 05:41:25 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id 72so7409269otu.1
        for <stable@vger.kernel.org>; Mon, 11 May 2020 05:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mj+lXskCJ9RI1PVGEinHCy7GOMwX3mpGpXnJ71EL/K4=;
        b=Ng5Q8dGs4KZg1cHx8WHAvYFmT+wWyc8hQo7eMa/FdnJOSzqasB/5u0SiFj+bka0dN8
         /Q902QQUQQHt+Lgj9/5LMBnGKWjg3J+2Mgts7lDpGWiyHv+ZEcaQnlrbkweMmDqB+SD7
         nMBsnRa4EgyR8TjXDmmNE/nHv0nWJKOcH3jOw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mj+lXskCJ9RI1PVGEinHCy7GOMwX3mpGpXnJ71EL/K4=;
        b=joSF8Nn7rRm6v2BFeSIPRZzFRg53JwREGHVjtQxap7r1/EPunNEks2VFFqgVkCTGiu
         LGlLXZTCzeCm7PehLb+2P/ch/94aICq7a3aYMd9P+Nhe75SnB0f/WpjDTtFMLavOZf0r
         bDsxJ4MQDGifHfY4utUZ6pk0bd5NHRhRPcQcD65sAsuLCI1OnE/ErDHN13a+qK0eQEAt
         kB45UnW5VvsazGt4SXB0ppqwJAzmUcgnA70N0I7qxK+9REcGvkG/5Y6EZZxQOb7iFUra
         dWJBSs4CrK2izhP4/4WrFnWefpXNW3kqNVGMW7XtVjCEorCUYYnvgZmQVVzRfSgMVu59
         yMnQ==
X-Gm-Message-State: AGi0PubYam/V0yqlJ96a8LMQVelqDwHa6e4qNcnhEY2CqsI/nob2JqSJ
        kN5XX//fzod7I85m8PCWsXmjeE2l/S9o8u0UYrYxA9M5
X-Google-Smtp-Source: APiQypJYskHt4xZ6qHK6mgfLMUQRgQVql9uUQQfTdZBJUNM3d+oCk11PmofzO3n9jLivw1gNEVmDzhLikko2+EBMgT4=
X-Received: by 2002:a9d:7c92:: with SMTP id q18mr13019563otn.281.1589200884502;
 Mon, 11 May 2020 05:41:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200416170420.23657-1-ville.syrjala@linux.intel.com>
 <20200417152310.GQ3456981@phenom.ffwll.local> <20200417154313.GO6112@intel.com>
 <CAKMK7uGBWyPtm0dva=Ndk6xJx7nUKJ20kn8S37iFB8s85WWmdw@mail.gmail.com>
 <20200417182834.GS6112@intel.com> <20200508170840.GE1219060@intel.com>
 <CAKMK7uHm+CmM6noHbMnmW9bSzk0dZ=9-CTpu+hxUwFbXmMkZ4g@mail.gmail.com> <20200511123715.GI6112@intel.com>
In-Reply-To: <20200511123715.GI6112@intel.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Mon, 11 May 2020 14:41:13 +0200
Message-ID: <CAKMK7uFxObdsNM7PETpipr0AJs_qfTY8NEpQ6M+x9NPC5gUuEg@mail.gmail.com>
Subject: Re: [PATCH] drm: Fix page flip ioctl format check
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     Rodrigo Vivi <rodrigo.vivi@intel.com>,
        stable <stable@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 2:37 PM Ville Syrj=C3=A4l=C3=A4
<ville.syrjala@linux.intel.com> wrote:
>
> On Sat, May 09, 2020 at 12:13:02PM +0200, Daniel Vetter wrote:
> > On Fri, May 8, 2020 at 7:09 PM Rodrigo Vivi <rodrigo.vivi@intel.com> wr=
ote:
> > >
> > > On Fri, Apr 17, 2020 at 09:28:34PM +0300, Ville Syrj=C3=A4l=C3=A4 wro=
te:
> > > > On Fri, Apr 17, 2020 at 08:10:26PM +0200, Daniel Vetter wrote:
> > > > > On Fri, Apr 17, 2020 at 5:43 PM Ville Syrj=C3=A4l=C3=A4
> > > > > <ville.syrjala@linux.intel.com> wrote:
> > > > > >
> > > > > > On Fri, Apr 17, 2020 at 05:23:10PM +0200, Daniel Vetter wrote:
> > > > > > > On Thu, Apr 16, 2020 at 08:04:20PM +0300, Ville Syrjala wrote=
:
> > > > > > > > From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.co=
m>
> > > > > > > >
> > > > > > > > Revert back to comparing fb->format->format instead fb->for=
mat for the
> > > > > > > > page flip ioctl. This check was originally only here to dis=
allow pixel
> > > > > > > > format changes, but when we changed it to do the pointer co=
mparison
> > > > > > > > we potentially started to reject some (but definitely not a=
ll) modifier
> > > > > > > > changes as well. In fact the current behaviour depends on w=
hether the
> > > > > > > > driver overrides the format info for a specific format+modi=
fier combo.
> > > > > > > > Eg. on i915 this now rejects compression vs. no compression=
 changes but
> > > > > > > > does not reject any other tiling changes. That's just incon=
sistent
> > > > > > > > nonsense.
> > > > > > > >
> > > > > > > > The main reason we have to go back to the old behaviour is =
to fix page
> > > > > > > > flipping with Xorg. At some point Xorg got its atomic right=
s taken away
> > > > > > > > and since then we can't page flip between compressed and no=
n-compressed
> > > > > > > > fbs on i915. Currently we get no page flipping for any game=
s pretty much
> > > > > > > > since Mesa likes to use compressed buffers. Not sure how co=
mpositors are
> > > > > > > > working around this (don't use one myself). I guess they mu=
st be doing
> > > > > > > > something to get non-compressed buffers instead. Either tha=
t or
> > > > > > > > somehow no one noticed the tearing from the blit fallback.
> > > > > > >
> > > > > > > Mesa only uses compressed buffers if you enable modifiers, an=
d there's a
> > > > > > > _loooooooooooot_ more that needs to be fixed in Xorg to enabl=
e that for
> > > > > > > real. Like real atomic support.
> > > > > >
> > > > > > Why would you need atomic for modifiers? Xorg doesn't even have
> > > > > > any sensible framework for atomic and I suspect it never will.
> > > > >
> > > > > Frankly if no one cares about atomic in X I don't think we should=
 do
> > > > > work-arounds for lack of atomic in X.
> > > > >
> > > > > > > Without modifiers all you get is X tiling,
> > > > > > > and that works just fine.
> > > > > > >
> > > > > > > Which would also fix this issue here you're papering over.
> > > > > > >
> > > > > > > So if this is the entire reason for this, I'm inclined to not=
 do this.
> > > > > > > Current Xorg is toast wrt modifiers, that's not news.
> > > > > >
> > > > > > Works just fine. Also pretty sure modifiers are even enabled by
> > > > > > default now in modesetting.
> > > > >
> > > > > Y/CSS is harder to scan out, you need to verify with TEST_ONLY wh=
ether
> > > > > it works. Otherwise good chances for some oddball black screens o=
n
> > > > > configurations that worked before. Which is why all non-atomic
> > > > > compositors reverted modifiers by default again.
> > > >
> > > > Y alone is hard to scanout also, and yet we do nothing to reject th=
at.
> > > > It's just an inconsistent mess.
> > > >
> > > > If we really want to keep this check then we should rewrite it
> > > > to be explicit:
> > > >
> > > > if (old_fb->format->format !=3D new_fb->format->format ||
> > > >     is_ccs(old_fb->modifier) !=3D is_ccs(new_fb->modifier))
> > > >     return -EINVAL;
> > > >
> > > > Now it's just a random thing that may even stop doing what it's
> > > > currently doing if anyone touches their .get_format_info()
> > > > implementation.
> > > >
> > > > >
> > > > > > And as stated the current check doesn't have consistent behavio=
ur
> > > > > > anyway. You can still flip between different modifiers as long =
a the
> > > > > > driver doesn't override .get_format_info() for one of them. The=
 *only*
> > > > > > case where that happens is CCS on i915. There is no valid reaso=
n to
> > > > > > special case that one.
> > > > >
> > > > > The thing is, you need atomic to make CCS work reliably enough fo=
r
> > > > > compositors and distros to dare enabling it by default.
> > > >
> > > > If it's not enabled by default then there is no harm in letting peo=
ple
> > > > explicitly enable it and get better performance.
> > > >
> > > > > CCS flipping
> > > > > works with atomic. I really see no point in baking this in with a=
s
> > > > > uapi.
> > > >
> > > > It's just going back to the original intention of the check.
> > > > Heck, the debug message doesn't even match what it's doing now.
> > > >
> > > > > Just fix Xorg.
> > > >
> > > > Be serious. No one is going to rewrite all the randr code to be ato=
mic.
> > >
> > > I fully understand Daniel's concern here, but I also believe this won=
't be
> > > done so soon at least. Meanwhile would it be acceptable to have a com=
ment
> > > with the code /* XXX: Xorg blah... */ or /* FIXME: After Xorg blah.. =
*/
> > > ?
> >
> > Here's a few numbers:
> >
> > - skl shipped in Aug 2015, so about 5 years. Since then would we like
> > to have modifiers enabled for intel, because it costs us quite a bit
> > of performance. This isn't new at all.
> > - the last Xorg release is from May 2018, so two years. Meanwhile even
> > patches to fix some of the atomic mixups in -modesetting landed, but
> > they never shipped so not useful.
> > - I spent a few hours (which really is nothing) reading Xorg code
> > yesterday, and I concur with Daniel Stone's napkin estimate that this
> > will take about half to one year to fix properly. It's not happening,
> > no one is working on that.
> >
> > Conclusion: No one cares about modifiers on Xorg-modesetting. I don't
> > see why the kernel should bend over for that.
> >
> > Once that has changed (I'm not betting on that) and there's clear
> > effort behind modifiers for Xorg-modesetting I guess we can look into
> > stop-gap measures, but meanwhile the best imo is to not disturb the
> > dead.
>
> The alternative interpretation is that the current kernel code is
> just nonsense, and since no one is depending on the current nonsense
> behaviour we can safely change it it back to make sense.
>
> Would allow people to at least test modifier plumbing via dri3/etc.
> Also those of us who know what they're doing and want to actually
> play games on Intel GPUs can flip it on for a a bit extra performance.
> In the meantime I'll just have to keep carrying this patch in my own
> kernels.

You can also carry a one-liner for -modesetting to re-enable atomic on
master (it's fixed up there, simply never released, why we've had to
take it away). And then you can also play with modifiers.
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
