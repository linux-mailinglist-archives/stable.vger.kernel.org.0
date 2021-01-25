Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942C9302E19
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 22:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733022AbhAYVkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 16:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733044AbhAYVkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 16:40:09 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E61C061573
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 13:39:28 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id l9so20178746ejx.3
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 13:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jlekstrand-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=t9M0ITSOMveR16He0Zm7nxQPCeyzBQO582YAXWbdC2o=;
        b=t0oz/yLhImMScrEx2TROt6/Yj3l4nmrPWnMrhRHCnMxVDCMTlsIzNkdZ2eROmvDMrv
         5vP69HxELvTiYSAVQG12RN9H75We6yVDbMFNnlh/WRORv5i1NCttzVBb9EZaLWjQGmHK
         gFdLbjNX6TaGRsiA8XbqMMdq4vxqnAvTfZRQfetfURkUfkHu1iKKl+Sv+MkkUNhB9VgQ
         XQ6QvEthiGSNOSfBlPzNXv4jLO3IXy1c/By1rKpMKaO7+p0ZhrOP7Ec73hT9G52jzYGU
         J3kyZ7bLTYApYSG6wDla3CvjivJ3oUKtMpuhL21VxUYq6SjJHw2dhSMkSzdW8vpXLdc+
         bhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=t9M0ITSOMveR16He0Zm7nxQPCeyzBQO582YAXWbdC2o=;
        b=bdlex1q93Dzgk/s58n6InAHOevANVGFRrwQTZ2D+9yKshtUK/ZG3wAhXnSwe/gzW54
         1lhBJ7G+hIUSJ99PIP4Kn1Egj/X4ivPFOSS7Y4kKr4oNaePIkjwP1uMHTKdly3291Zj0
         oiRh5eZ5NGweqUp6IH00p6sEzR70uKMILZSIzrhKmc6EdYJAVLl7e0RRG+UJECIFylmB
         iuLe4mXZyPCvEHV6KMAEtvPs7gydGZpR7vDLG+yRFFa1KkzWKH108nie8BOxfHU0y/T5
         cn/fjBjgc+UqKMbte+c+XcYnpkWNEvU36hvbFM32+IEK4TC48d12Kfe/nt4Y3nO/IClz
         Ot0g==
X-Gm-Message-State: AOAM532R2dXKQQoFigmfgNfMucHBfHiIQHMf7NHb1RDI1JYvTxdpTyZP
        Z5io7HbhvvKaNALcFgMD0AfkK6wNctf6C4WcyZYPk6qZQdY=
X-Google-Smtp-Source: ABdhPJzrO99CGgskBefYU39omC9nnH6nw3FKnnSGsYGK8edxEXo2adNViTXnxzMLTczwgTE6VE4u7ypkvTn2T/5MSYY=
X-Received: by 2002:a17:906:4893:: with SMTP id v19mr1544854ejq.454.1611610767093;
 Mon, 25 Jan 2021 13:39:27 -0800 (PST)
MIME-Version: 1.0
References: <20201126105539.2661-1-chris@chris-wilson.co.uk>
 <20201126140841.1982-1-chris@chris-wilson.co.uk> <20201126155010.GD6112@intel.com>
In-Reply-To: <20201126155010.GD6112@intel.com>
From:   Jason Ekstrand <jason@jlekstrand.net>
Date:   Mon, 25 Jan 2021 15:39:15 -0600
Message-ID: <CAOFGe96x7bDEo_g7ga97q=sRCNNSrKcJvBK=fguwwCaSobFSRQ@mail.gmail.com>
Subject: Re: [PATCH] drm/i915/gt: Program mocs:63 for cache eviction on gen9
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Intel GFX <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I just pulled drm-tip with both this and "drm/i915/gt: Declare gen9
has 64 mocs entries!" and the hang persists.  You really had my hopes
up there....  I think we need to merge the L3$ disable patch.

--Jason


On Thu, Nov 26, 2020 at 9:50 AM Ville Syrj=C3=A4l=C3=A4
<ville.syrjala@linux.intel.com> wrote:
>
> On Thu, Nov 26, 2020 at 02:08:41PM +0000, Chris Wilson wrote:
> > Ville noticed that the last mocs entry is used unconditionally by the H=
W
> > when it performs cache evictions, and noted that while the value is not
> > meant to be writable by the driver, we should program it to a reasonabl=
e
> > value nevertheless.
> >
> > As it turns out, we can change the value of mocs:63 and the value we
> > were programming into it would cause hard hangs in conjunction with
> > atomic operations.
> >
> > v2: Add details from bspec about how it is used by HW
> >
> > Suggested-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2707
> > Fixes: 3bbaba0ceaa2 ("drm/i915: Added Programming of the MOCS")
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> > Cc: Jason Ekstrand <jason@jlekstrand.net>
> > Cc: <stable@vger.kernel.org> # v4.3+
> > ---
> >  drivers/gpu/drm/i915/gt/intel_mocs.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/i915/gt/intel_mocs.c b/drivers/gpu/drm/i91=
5/gt/intel_mocs.c
> > index 254873e1646e..26cedde80476 100644
> > --- a/drivers/gpu/drm/i915/gt/intel_mocs.c
> > +++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
> > @@ -131,7 +131,19 @@ static const struct drm_i915_mocs_entry skl_mocs_t=
able[] =3D {
> >       GEN9_MOCS_ENTRIES,
> >       MOCS_ENTRY(I915_MOCS_CACHED,
> >                  LE_3_WB | LE_TC_2_LLC_ELLC | LE_LRUM(3),
> > -                L3_3_WB)
> > +                L3_3_WB),
> > +
> > +     /*
> > +      * mocs:63
> > +      * - used by the L3 for all its evictions.
> > +      *   Thus it is expected to allow LLC cacheability to enable cohe=
rent
> > +      *   flows to be maintained.
> > +      * - used to force L3 uncachable cycles.
> > +      *   Thus it is expected to make the surce L3 uncacheable.
>
> "surce"?
>
> > +      */
> > +     MOCS_ENTRY(63,
> > +                LE_3_WB | LE_TC_1_LLC | LE_LRUM(3),
> > +                L3_1_UC)
> >  };
> >
> >  /* NOTE: the LE_TGT_CACHE is not used on Broxton */
> > --
> > 2.20.1
>
> --
> Ville Syrj=C3=A4l=C3=A4
> Intel
