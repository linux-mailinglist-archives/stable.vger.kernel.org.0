Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74731CC03C
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 12:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgEIKNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 06:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbgEIKNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 May 2020 06:13:15 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF1DC061A0C
        for <stable@vger.kernel.org>; Sat,  9 May 2020 03:13:14 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id j16so10771280oih.10
        for <stable@vger.kernel.org>; Sat, 09 May 2020 03:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j7df/sGANfMjiL3GSPbHESG02xuyrHmMRu09XEfC5cc=;
        b=Wn+Eodka0YNyvoAmF6uP1TxgTtL16UWHeIIJMF8944NiJG48P7/tjsgHM0HRx35gQH
         o9tHCBrYIEXYx9YqfCDWUYMkYBAYQ0oK3WtgevQvnRHhqDA7qug7coVmbI02X9t0kVXk
         ZpUlW6TatoB4jxnqguiJ5fq0bxSjePF/UWxWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j7df/sGANfMjiL3GSPbHESG02xuyrHmMRu09XEfC5cc=;
        b=H3p/JUSUcUpPDL9WcAtEVhBpvqp+mNyXkOOqM2FPfngPI6nSFj17NmBSeESdatHw2w
         W9LJXslWZGH8iYGrLTTLJYs2yBTQcAYVwx89y0b4ZKc3LAA6BLob32fD+SQ2If5VwDJW
         fpuqT4x3A8/062WY+8uAFamu76QHRmMlUCeOemiaCi7KE13paY2CEa8ErXAwp24sa4jh
         b7buOqR2sS9nm7zV4eencNQnC+Bw98UW3rGzqaTZHdlTGhT2IIPg46cTUitZ57eR83jZ
         dgibVEN7Q7StUehOJ1PHdDrEkVjDsEhzpOYAqaf8NXpt/hNwxG53NbLZdmWV0tQTAIJS
         mnCQ==
X-Gm-Message-State: AGi0PuYJIzinHbikrURn7eZ3JujtHAypkZhMghuYGf2tE/+8IZGMMe4i
        l+vYox/4uJrFrBtaGBGwXm2HArf9YxAGeZgA8+C7TA==
X-Google-Smtp-Source: APiQypLwpKu++5ndRDIqJgJuD9WqFtMtTMuI+84Adx1SXSReftDsQCBbdoG1hg1C66PKvJGaYMeAg2Q9Wc2xDD0ZRGU=
X-Received: by 2002:aca:2113:: with SMTP id 19mr4949493oiz.128.1589019194103;
 Sat, 09 May 2020 03:13:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200416170420.23657-1-ville.syrjala@linux.intel.com>
 <20200417152310.GQ3456981@phenom.ffwll.local> <20200417154313.GO6112@intel.com>
 <CAKMK7uGBWyPtm0dva=Ndk6xJx7nUKJ20kn8S37iFB8s85WWmdw@mail.gmail.com>
 <20200417182834.GS6112@intel.com> <20200508170840.GE1219060@intel.com>
In-Reply-To: <20200508170840.GE1219060@intel.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Sat, 9 May 2020 12:13:02 +0200
Message-ID: <CAKMK7uHm+CmM6noHbMnmW9bSzk0dZ=9-CTpu+hxUwFbXmMkZ4g@mail.gmail.com>
Subject: Re: [PATCH] drm: Fix page flip ioctl format check
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
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

On Fri, May 8, 2020 at 7:09 PM Rodrigo Vivi <rodrigo.vivi@intel.com> wrote:
>
> On Fri, Apr 17, 2020 at 09:28:34PM +0300, Ville Syrj=C3=A4l=C3=A4 wrote:
> > On Fri, Apr 17, 2020 at 08:10:26PM +0200, Daniel Vetter wrote:
> > > On Fri, Apr 17, 2020 at 5:43 PM Ville Syrj=C3=A4l=C3=A4
> > > <ville.syrjala@linux.intel.com> wrote:
> > > >
> > > > On Fri, Apr 17, 2020 at 05:23:10PM +0200, Daniel Vetter wrote:
> > > > > On Thu, Apr 16, 2020 at 08:04:20PM +0300, Ville Syrjala wrote:
> > > > > > From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> > > > > >
> > > > > > Revert back to comparing fb->format->format instead fb->format =
for the
> > > > > > page flip ioctl. This check was originally only here to disallo=
w pixel
> > > > > > format changes, but when we changed it to do the pointer compar=
ison
> > > > > > we potentially started to reject some (but definitely not all) =
modifier
> > > > > > changes as well. In fact the current behaviour depends on wheth=
er the
> > > > > > driver overrides the format info for a specific format+modifier=
 combo.
> > > > > > Eg. on i915 this now rejects compression vs. no compression cha=
nges but
> > > > > > does not reject any other tiling changes. That's just inconsist=
ent
> > > > > > nonsense.
> > > > > >
> > > > > > The main reason we have to go back to the old behaviour is to f=
ix page
> > > > > > flipping with Xorg. At some point Xorg got its atomic rights ta=
ken away
> > > > > > and since then we can't page flip between compressed and non-co=
mpressed
> > > > > > fbs on i915. Currently we get no page flipping for any games pr=
etty much
> > > > > > since Mesa likes to use compressed buffers. Not sure how compos=
itors are
> > > > > > working around this (don't use one myself). I guess they must b=
e doing
> > > > > > something to get non-compressed buffers instead. Either that or
> > > > > > somehow no one noticed the tearing from the blit fallback.
> > > > >
> > > > > Mesa only uses compressed buffers if you enable modifiers, and th=
ere's a
> > > > > _loooooooooooot_ more that needs to be fixed in Xorg to enable th=
at for
> > > > > real. Like real atomic support.
> > > >
> > > > Why would you need atomic for modifiers? Xorg doesn't even have
> > > > any sensible framework for atomic and I suspect it never will.
> > >
> > > Frankly if no one cares about atomic in X I don't think we should do
> > > work-arounds for lack of atomic in X.
> > >
> > > > > Without modifiers all you get is X tiling,
> > > > > and that works just fine.
> > > > >
> > > > > Which would also fix this issue here you're papering over.
> > > > >
> > > > > So if this is the entire reason for this, I'm inclined to not do =
this.
> > > > > Current Xorg is toast wrt modifiers, that's not news.
> > > >
> > > > Works just fine. Also pretty sure modifiers are even enabled by
> > > > default now in modesetting.
> > >
> > > Y/CSS is harder to scan out, you need to verify with TEST_ONLY whethe=
r
> > > it works. Otherwise good chances for some oddball black screens on
> > > configurations that worked before. Which is why all non-atomic
> > > compositors reverted modifiers by default again.
> >
> > Y alone is hard to scanout also, and yet we do nothing to reject that.
> > It's just an inconsistent mess.
> >
> > If we really want to keep this check then we should rewrite it
> > to be explicit:
> >
> > if (old_fb->format->format !=3D new_fb->format->format ||
> >     is_ccs(old_fb->modifier) !=3D is_ccs(new_fb->modifier))
> >     return -EINVAL;
> >
> > Now it's just a random thing that may even stop doing what it's
> > currently doing if anyone touches their .get_format_info()
> > implementation.
> >
> > >
> > > > And as stated the current check doesn't have consistent behaviour
> > > > anyway. You can still flip between different modifiers as long a th=
e
> > > > driver doesn't override .get_format_info() for one of them. The *on=
ly*
> > > > case where that happens is CCS on i915. There is no valid reason to
> > > > special case that one.
> > >
> > > The thing is, you need atomic to make CCS work reliably enough for
> > > compositors and distros to dare enabling it by default.
> >
> > If it's not enabled by default then there is no harm in letting people
> > explicitly enable it and get better performance.
> >
> > > CCS flipping
> > > works with atomic. I really see no point in baking this in with as
> > > uapi.
> >
> > It's just going back to the original intention of the check.
> > Heck, the debug message doesn't even match what it's doing now.
> >
> > > Just fix Xorg.
> >
> > Be serious. No one is going to rewrite all the randr code to be atomic.
>
> I fully understand Daniel's concern here, but I also believe this won't b=
e
> done so soon at least. Meanwhile would it be acceptable to have a comment
> with the code /* XXX: Xorg blah... */ or /* FIXME: After Xorg blah.. */
> ?

Here's a few numbers:

- skl shipped in Aug 2015, so about 5 years. Since then would we like
to have modifiers enabled for intel, because it costs us quite a bit
of performance. This isn't new at all.
- the last Xorg release is from May 2018, so two years. Meanwhile even
patches to fix some of the atomic mixups in -modesetting landed, but
they never shipped so not useful.
- I spent a few hours (which really is nothing) reading Xorg code
yesterday, and I concur with Daniel Stone's napkin estimate that this
will take about half to one year to fix properly. It's not happening,
no one is working on that.

Conclusion: No one cares about modifiers on Xorg-modesetting. I don't
see why the kernel should bend over for that.

Once that has changed (I'm not betting on that) and there's clear
effort behind modifiers for Xorg-modesetting I guess we can look into
stop-gap measures, but meanwhile the best imo is to not disturb the
dead.

Cheers, Daniel

> >
> > > -Daniel
> > >
> > > >
> > > > > -Daniel
> > > > >
> > > > > >
> > > > > > Looking back at the original discussion on this change we prett=
y much
> > > > > > just did it in the name of skipping a few extra pointer derefer=
ences.
> > > > > > However, I've decided not to revert the whole thing in case som=
eone
> > > > > > has since started to depend on these changes. None of the other=
 checks
> > > > > > are relevant for i915 anyways.
> > > > > >
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > > > Fixes: dbd4d5761e1f ("drm: Replace 'format->format' comparisons=
 to just 'format' comparisons")
> > > > > > Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.int=
el.com>
> > > > > > ---
> > > > > >  drivers/gpu/drm/drm_plane.c | 2 +-
> > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/drivers/gpu/drm/drm_plane.c b/drivers/gpu/drm/drm_=
plane.c
> > > > > > index d6ad60ab0d38..f2ca5315f23b 100644
> > > > > > --- a/drivers/gpu/drm/drm_plane.c
> > > > > > +++ b/drivers/gpu/drm/drm_plane.c
> > > > > > @@ -1153,7 +1153,7 @@ int drm_mode_page_flip_ioctl(struct drm_d=
evice *dev,
> > > > > >     if (ret)
> > > > > >             goto out;
> > > > > >
> > > > > > -   if (old_fb->format !=3D fb->format) {
> > > > > > +   if (old_fb->format->format !=3D fb->format->format) {
> > > > > >             DRM_DEBUG_KMS("Page flip is not allowed to change f=
rame buffer format.\n");
> > > > > >             ret =3D -EINVAL;
> > > > > >             goto out;
> > > > > > --
> > > > > > 2.24.1
> > > > > >
> > > > > > _______________________________________________
> > > > > > dri-devel mailing list
> > > > > > dri-devel@lists.freedesktop.org
> > > > > > https://lists.freedesktop.org/mailman/listinfo/dri-devel
> > > > >
> > > > > --
> > > > > Daniel Vetter
> > > > > Software Engineer, Intel Corporation
> > > > > http://blog.ffwll.ch
> > > >
> > > > --
> > > > Ville Syrj=C3=A4l=C3=A4
> > > > Intel
> > >
> > >
> > >
> > > --
> > > Daniel Vetter
> > > Software Engineer, Intel Corporation
> > > +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> >
> > --
> > Ville Syrj=C3=A4l=C3=A4
> > Intel
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/dri-devel



--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
