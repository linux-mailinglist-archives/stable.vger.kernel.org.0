Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01AA8AE279
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 05:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbfIJDJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 23:09:52 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46380 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfIJDJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 23:09:51 -0400
Received: by mail-io1-f66.google.com with SMTP id d17so12224988ios.13
        for <stable@vger.kernel.org>; Mon, 09 Sep 2019 20:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qOVOKZVgjmlW6Zpq1gN6HvDKrqzeVYxQNDKBPmhL/9c=;
        b=RASqfkL6oEBRL6Qd508T+JGbHB7Ubb5duDRC4ZPol7oaDf2GWOWhLyQeydGQfPosUc
         WQt4HlWF2UTwDHlzQfn021wE+Q0g9kPSsPqqZrkZSsYtj/aZtlIK8O02JwW1KBM6OVd+
         GSKfvDoXn05z0ZvHxZtNmstOa31C7CDYvUNiV/tZuMEsqyKt0wEQIg5qoq6P9x+XnTKO
         6RWIWiiJ8T8vtqCVbM0hc2sEMkgKt9A3bvdt2a5z1qcyGJ+K5Vq0RA/KQn/ANoqnOs6E
         i9BaJ1kiq7Wo7uctW1YQSV1IBz0Irf7ThBoAVwJ8QYHhay/iTO0oj/gNj/Hrosu2jkGh
         5zfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qOVOKZVgjmlW6Zpq1gN6HvDKrqzeVYxQNDKBPmhL/9c=;
        b=VTq1qx3j7uC/Hyepvt/vdwZMGJQJ5FsCZK8OEv/tLx+8W1EsurPMpjGLA7CHi2O5a7
         y91GIrin9jkPY4rzrwqH3PCS32XRpFunT28mOUqqnRfneYHBiBZkCpRW6kE/d59XTGXX
         mwenGfgjSoo8WWs2xVr2ux/YG5Awy2yiAwg/XrjSnFh62DeaSYHuMBrDZaPC2x2PWiK+
         un8F/wMiFyfpWLHszpFIuhVvhvLhzjBTpWvnZLrG5ghpcKVtWQ1Cbr+ADTeB5weXtsBO
         UnEqHtRvcf4lQSD8JZHaADsrwWm7m7BhUdVZKLsc9cVvtPoBy/V+Eb+dK9kP9YrG3kUP
         2cpw==
X-Gm-Message-State: APjAAAVFS9yzGU4kRFO24ggfLIQDR+jFobJ6s7p080S8f4BTc2uub7nn
        L2rKgzk1PKlZbNVLKEriZ96Lm75XLLrFVE7d95s=
X-Google-Smtp-Source: APXvYqwYW4p+ltV7NCUzOgTROiF3zlMmry3YmQjoX9gTVOD1LaOjaEzL4cEIJouJtW1yxeG4YwqKq2SMvga+9SuV5bI=
X-Received: by 2002:a5d:9b02:: with SMTP id y2mr4928775ion.146.1568084990931;
 Mon, 09 Sep 2019 20:09:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190908024800.23229-1-anarsoul@gmail.com> <CAKGbVbt056DyZHer1bKnAv8uBCX6zbsWeMjE6AQy8HYQf7L1wg@mail.gmail.com>
 <3263343.nbYvo8rMJO@diego> <CA+E=qVfWYd8QdEi=h7JL=AVV+ehpP=GZ3cUsZ1Cbhh0O5xn1ng@mail.gmail.com>
 <CAKGbVbskXmWJOrRWOSJ2f1dN7VAKTosLmYEA_n6fn+AjQnBj9Q@mail.gmail.com>
In-Reply-To: <CAKGbVbskXmWJOrRWOSJ2f1dN7VAKTosLmYEA_n6fn+AjQnBj9Q@mail.gmail.com>
From:   Qiang Yu <yuq825@gmail.com>
Date:   Tue, 10 Sep 2019 11:09:39 +0800
Message-ID: <CAKGbVbvaYgSkVXsBsrgrXDF1mK1t8dwGVdrH-6AOXLReOQX_OQ@mail.gmail.com>
Subject: Re: [Lima] [PATCH] drm/lima: fix lima_gem_wait() return value
To:     Vasily Khoruzhick <anarsoul@gmail.com>
Cc:     =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        lima@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        stable@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I've pushed this patch to drm-misc-fixes:
https://cgit.freedesktop.org/drm/drm-misc/commit/?h=3Ddrm-misc-fixes&id=3D2=
1670bd78a25001cf8ef2679b378c73fb73b904f

There is a conflict when drm-tip merge process which has been solved
by following the doc:
https://drm.pages.freedesktop.org/maintainer-tools/drm-tip.html
drm_gem_reservation_object_wait() has been renamed to
drm_gem_dma_resv_wait() in drm-misc-next and drm-next.

Please let me know if I have to also push this fix to drm-misc-next by my o=
wn.

Thanks,
Qiang

On Tue, Sep 10, 2019 at 9:16 AM Qiang Yu <yuq825@gmail.com> wrote:
>
> Thanks Heiko, I'll push this patch to drm-misc-fixes.
>
> I can add the Fixes tag before push.
>
> Thanks,
> Qiang
>
> On Tue, Sep 10, 2019 at 12:23 AM Vasily Khoruzhick <anarsoul@gmail.com> w=
rote:
> >
> > On Mon, Sep 9, 2019 at 5:18 AM Heiko St=C3=BCbner <heiko@sntech.de> wro=
te:
> > >
> > > Hi Qiang,
> > >
> > > Am Montag, 9. September 2019, 04:30:43 CEST schrieb Qiang Yu:
> > > > Oh, I was miss leading by the drm_gem_reservation_object_wait
> > > > comments. Patch is:
> > > > Reviewed-by: Qiang Yu <yuq825@gmail.com>
> > > >
> > > > I'll apply this patch to drm-misc-next.
> > > >
> > > > Current kernel release is 5.3-rc8, is it too late for this fix to g=
o
> > > > into the mainline 5.3 release?
> > > > I'd like to know how to apply this fix for current rc kernels, by
> > > > drm-misc-fixes? Can I push
> > > > to drm-misc-fixes by dim or I can only push to drm-misc-next and
> > > > drm-misc maintainer will
> > > > pick fixes from it to drm-misc-fixes?
> > >
> > > drm-misc-fixes gets merged into drm-misc-next by maintainers regularl=
y,
> > > so I _think_ you should apply the fix-patch to drm-misc-fixes first.
> > > [I also always have to read the documentation ;-) ]
> > >
> > > In any case you might want to add a "Fixes: ....." tag as well as a
> > > "Cc: stable@vger.kernel.org" tag, so it can be backported to stable
> > > kernels if applicable.
> >
> > Cc: stable is already here, but I think it still needs "Fixes: " tag.
> >
> > Qiang, can you add it at your side or you want me to resend the patch?
> >
> > >
> > > Heiko
> > >
> > > > On Sun, Sep 8, 2019 at 10:48 AM Vasily Khoruzhick <anarsoul@gmail.c=
om> wrote:
> > > > >
> > > > > drm_gem_reservation_object_wait() returns 0 if it succeeds and -E=
TIME
> > > > > if it timeouts, but lima driver assumed that 0 is error.
> > > > >
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> > > > > ---
> > > > >  drivers/gpu/drm/lima/lima_gem.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/drivers/gpu/drm/lima/lima_gem.c b/drivers/gpu/drm/li=
ma/lima_gem.c
> > > > > index 477c0f766663..b609dc030d6c 100644
> > > > > --- a/drivers/gpu/drm/lima/lima_gem.c
> > > > > +++ b/drivers/gpu/drm/lima/lima_gem.c
> > > > > @@ -342,7 +342,7 @@ int lima_gem_wait(struct drm_file *file, u32 =
handle, u32 op, s64 timeout_ns)
> > > > >         timeout =3D drm_timeout_abs_to_jiffies(timeout_ns);
> > > > >
> > > > >         ret =3D drm_gem_reservation_object_wait(file, handle, wri=
te, timeout);
> > > > > -       if (ret =3D=3D 0)
> > > > > +       if (ret =3D=3D -ETIME)
> > > > >                 ret =3D timeout ? -ETIMEDOUT : -EBUSY;
> > > > >
> > > > >         return ret;
> > > > > --
> > > > > 2.23.0
> > > > >
> > > > _______________________________________________
> > > > lima mailing list
> > > > lima@lists.freedesktop.org
> > > > https://lists.freedesktop.org/mailman/listinfo/lima
> > >
> > >
> > >
> > >
