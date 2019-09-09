Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B548EAD8C6
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 14:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbfIIMSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 08:18:44 -0400
Received: from gloria.sntech.de ([185.11.138.130]:44864 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbfIIMSo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Sep 2019 08:18:44 -0400
Received: from ip5f5a6266.dynamic.kabel-deutschland.de ([95.90.98.102] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <heiko@sntech.de>)
        id 1i7Icz-00071q-47; Mon, 09 Sep 2019 14:18:41 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     lima@lists.freedesktop.org
Cc:     Qiang Yu <yuq825@gmail.com>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        David Airlie <airlied@linux.ie>, stable@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [Lima] [PATCH] drm/lima: fix lima_gem_wait() return value
Date:   Mon, 09 Sep 2019 14:18:40 +0200
Message-ID: <3263343.nbYvo8rMJO@diego>
In-Reply-To: <CAKGbVbt056DyZHer1bKnAv8uBCX6zbsWeMjE6AQy8HYQf7L1wg@mail.gmail.com>
References: <20190908024800.23229-1-anarsoul@gmail.com> <CAKGbVbt056DyZHer1bKnAv8uBCX6zbsWeMjE6AQy8HYQf7L1wg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Qiang,

Am Montag, 9. September 2019, 04:30:43 CEST schrieb Qiang Yu:
> Oh, I was miss leading by the drm_gem_reservation_object_wait
> comments. Patch is:
> Reviewed-by: Qiang Yu <yuq825@gmail.com>
> 
> I'll apply this patch to drm-misc-next.
> 
> Current kernel release is 5.3-rc8, is it too late for this fix to go
> into the mainline 5.3 release?
> I'd like to know how to apply this fix for current rc kernels, by
> drm-misc-fixes? Can I push
> to drm-misc-fixes by dim or I can only push to drm-misc-next and
> drm-misc maintainer will
> pick fixes from it to drm-misc-fixes?

drm-misc-fixes gets merged into drm-misc-next by maintainers regularly,
so I _think_ you should apply the fix-patch to drm-misc-fixes first.
[I also always have to read the documentation ;-) ]

In any case you might want to add a "Fixes: ....." tag as well as a
"Cc: stable@vger.kernel.org" tag, so it can be backported to stable
kernels if applicable.


Heiko

> On Sun, Sep 8, 2019 at 10:48 AM Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> >
> > drm_gem_reservation_object_wait() returns 0 if it succeeds and -ETIME
> > if it timeouts, but lima driver assumed that 0 is error.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> > ---
> >  drivers/gpu/drm/lima/lima_gem.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/lima/lima_gem.c b/drivers/gpu/drm/lima/lima_gem.c
> > index 477c0f766663..b609dc030d6c 100644
> > --- a/drivers/gpu/drm/lima/lima_gem.c
> > +++ b/drivers/gpu/drm/lima/lima_gem.c
> > @@ -342,7 +342,7 @@ int lima_gem_wait(struct drm_file *file, u32 handle, u32 op, s64 timeout_ns)
> >         timeout = drm_timeout_abs_to_jiffies(timeout_ns);
> >
> >         ret = drm_gem_reservation_object_wait(file, handle, write, timeout);
> > -       if (ret == 0)
> > +       if (ret == -ETIME)
> >                 ret = timeout ? -ETIMEDOUT : -EBUSY;
> >
> >         return ret;
> > --
> > 2.23.0
> >
> _______________________________________________
> lima mailing list
> lima@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/lima




