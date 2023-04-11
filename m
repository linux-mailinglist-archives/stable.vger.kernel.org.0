Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DACD6DD64D
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 11:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjDKJLL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 11 Apr 2023 05:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjDKJKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 05:10:54 -0400
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D2D194
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 02:10:35 -0700 (PDT)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-54f64b29207so38237787b3.8
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 02:10:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681204234;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KCkkco9adKfwM1mqsRyiXm9kdgSxvcC5TKthffG1ZPk=;
        b=Rr9cp8VmvBXI28iKSupOnFNpvg3AVOzaJDi/BIy9gKAuEIHj6HNabfFb6L+TWUrpyZ
         B+ChVdWJPJcSeLG/LDabp/4YiTidibdreJBNg9xVwhIET57CXoHAWNOxUR7PS2kgvngc
         3Gm9VJUc9ZsYPNXtCnoJgVsRVfjIvrASR9SWLY7WUG6M9LHEXTsBpi4MpwDSYFhSR1Th
         W+kExzWIR02pgYSVYhctvACbzerf3FkJ+6048ovGInw3/IU5sMr3rYy3/Ta98Wg7Vvpd
         1TzFppO8uM/EOuSIRzb7wJBGBzc1pLJz35/yN/xQy+f7IXFEGUgUzSLTud+QgvdNYU8r
         IJZA==
X-Gm-Message-State: AAQBX9f5z4dox+91dVhWWsCdP5hur1h7y8s/RnslzO+VRs+166e6zw58
        hUPS0gZaGQPh/tkbQz2r1Igp+m0i2c7MEQ==
X-Google-Smtp-Source: AKy350YR33XU8Pkcn3nVNjPlidQEX6PihP/386+8cWvIAphJ1HFc8OtdrYeEZnOoXRcVmy2BYgPUgw==
X-Received: by 2002:a0d:e605:0:b0:54f:e6a:5d10 with SMTP id p5-20020a0de605000000b0054f0e6a5d10mr5022304ywe.22.1681204234183;
        Tue, 11 Apr 2023 02:10:34 -0700 (PDT)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com. [209.85.128.177])
        by smtp.gmail.com with ESMTPSA id i6-20020a81f206000000b00545cb6adc16sm3358542ywm.6.2023.04.11.02.10.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 02:10:33 -0700 (PDT)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-54ee0b73e08so148995877b3.0
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 02:10:33 -0700 (PDT)
X-Received: by 2002:a81:c54d:0:b0:544:8bc1:a179 with SMTP id
 o13-20020a81c54d000000b005448bc1a179mr7428390ywj.4.1681204232496; Tue, 11 Apr
 2023 02:10:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230404123624.360384-1-daniel.vetter@ffwll.ch> <03a575e1-b4ed-7bd6-b68a-0583d76803ff@mailbox.org>
In-Reply-To: <03a575e1-b4ed-7bd6-b68a-0583d76803ff@mailbox.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 11 Apr 2023 11:10:19 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXj8PG=aidRbSaP-792wGZuRyZE6VF1BARRz7LeUrWfeA@mail.gmail.com>
Message-ID: <CAMuHMdXj8PG=aidRbSaP-792wGZuRyZE6VF1BARRz7LeUrWfeA@mail.gmail.com>
Subject: Re: [PATCH] fbdev: Don't spam dmesg on bad userspace ioctl input
To:     =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel.daenzer@mailbox.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Helge Deller <deller@gmx.de>,
        syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com,
        Javier Martinez Canillas <javierm@redhat.com>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Michel,

On Wed, Apr 5, 2023 at 10:50 AM Michel Dänzer
<michel.daenzer@mailbox.org> wrote:
> On 4/4/23 14:36, Daniel Vetter wrote:
> > There's a few reasons the kernel should not spam dmesg on bad
> > userspace ioctl input:
> > - at warning level it results in CI false positives
> > - it allows userspace to drown dmesg output, potentially hiding real
> >   issues.
> >
> > None of the other generic EINVAL checks report in the
> > FBIOPUT_VSCREENINFO ioctl do this, so it's also inconsistent.
> >
> > I guess the intent of the patch which introduced this warning was that
> > the drivers ->fb_check_var routine should fail in that case. Reality
> > is that there's too many fbdev drivers and not enough people
> > maintaining them by far, and so over the past few years we've simply
> > handled all these validation gaps by tighning the checks in the core,
> > because that's realistically really all that will ever happen.
> >
> > Reported-by: syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?id=c5faf983bfa4a607de530cd3bb008888bf06cefc
> > Fixes: 6c11df58fd1a ("fbmem: Check virtual screen sizes in fb_set_var()")
> > Cc: Helge Deller <deller@gmx.de>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: stable@vger.kernel.org # v5.4+
> > Cc: Daniel Vetter <daniel@ffwll.ch>
> > Cc: Javier Martinez Canillas <javierm@redhat.com>
> > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > ---
> >  drivers/video/fbdev/core/fbmem.c | 4 ----
> >  1 file changed, 4 deletions(-)
> >
> > diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
> > index 875541ff185b..9757f4bcdf57 100644
> > --- a/drivers/video/fbdev/core/fbmem.c
> > +++ b/drivers/video/fbdev/core/fbmem.c
> > @@ -1021,10 +1021,6 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
> >       /* verify that virtual resolution >= physical resolution */
> >       if (var->xres_virtual < var->xres ||
> >           var->yres_virtual < var->yres) {
> > -             pr_warn("WARNING: fbcon: Driver '%s' missed to adjust virtual screen size (%ux%u vs. %ux%u)\n",
> > -                     info->fix.id,
> > -                     var->xres_virtual, var->yres_virtual,
> > -                     var->xres, var->yres);
> >               return -EINVAL;
> >       }
> >
>
> Make it pr_warn_once? 99.9...% of the benefit, without spam.

Except that it should be pr_warn_once_per_fb_info, which requires
a flag in fb_info.

If fb_info.fbops wasn't const, we could also nuke
info->fbops->check_var() ;-)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
