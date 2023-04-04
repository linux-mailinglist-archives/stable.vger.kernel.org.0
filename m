Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D346D647C
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 16:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbjDDOAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 10:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235459AbjDDOAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 10:00:10 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BAB5580
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 06:59:50 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w9so131003386edc.3
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 06:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1680616755; x=1683208755;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uLEuV/Rl46soliUStjZYzbp5mrB4rM2FAfYiZ88IN4s=;
        b=JIyDEprHKxSRgFuUoVoP6J4fm6FBO/Bya/iT8DK6sNmQ/su8mly7zp/eoocfkTMFvv
         2RIvfIAqzCkoVkRV2ptzmzRfH9otx0CcKUf3ZBkombAElmJuX0lolnobMrldhyy1mI70
         eBTNQbW75H8gYVdS9tHoXUDN6bXQC57dGerTM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680616755; x=1683208755;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uLEuV/Rl46soliUStjZYzbp5mrB4rM2FAfYiZ88IN4s=;
        b=SHwefoBVlChV0pzdsRRDHMA2Q2Sbdxzm4RHgou2Vv2ojbR27b1E+fvSkiZBTOMVSpx
         qg0MKcSRFVvY4yWMepDywD4bJSVdsmYuwMF3WQD/gBFtacvVhq8AjO06PHjYFfmvc9WC
         AfC/0y8ywhkHLWFUYeLNVtnohdqbCgrDHu3k1EstohdQD3U2zUgodbhP7KNOC6oHQKu/
         bi6g8KHJc2LnWXm1EKUinvlFG9O5AKgZu1ku/PhymyMHKr2SCGT/FpE2qpEwlwVA/HXs
         b2ZXDSDdKoC4D+y9WM9w3QNP1IIriYvt9FBsqrb0JUJfI5LxPcK5shkU+oq8DhV9qm03
         8y9A==
X-Gm-Message-State: AAQBX9dfJKs6ZWszd1vtKSsWuAor+qp4U4xkzCxqDFwmUQXUzuALited
        maqQpOPMOAC7/BJqQ/Zde4On8Q==
X-Google-Smtp-Source: AKy350ZQ2169yE1rB1BJp4fG6JZwW1v/+RAG4h5U7/xxHXAUJmV+SW6z/y2GGPtzKAVftALY9fJ82g==
X-Received: by 2002:a17:906:208a:b0:929:b101:937d with SMTP id 10-20020a170906208a00b00929b101937dmr2057638ejq.1.1680616754907;
        Tue, 04 Apr 2023 06:59:14 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-33.fiber7.init7.net. [212.51.149.33])
        by smtp.gmail.com with ESMTPSA id ld10-20020a1709079c0a00b00949173bdad1sm835044ejc.213.2023.04.04.06.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 06:59:14 -0700 (PDT)
Date:   Tue, 4 Apr 2023 15:59:12 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com,
        Helge Deller <deller@gmx.de>, stable@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Melissa Wen <melissa.srw@gmail.com>
Subject: Re: [PATCH] fbdev: Don't spam dmesg on bad userspace ioctl input
Message-ID: <ZCwtMJEAJiId/TJe@phenom.ffwll.local>
References: <20230404123624.360384-1-daniel.vetter@ffwll.ch>
 <CAMuHMdUR=rx2QPvpzsSCwXTSTsPQOudNMzyL3dtZGQdQfrQGDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdUR=rx2QPvpzsSCwXTSTsPQOudNMzyL3dtZGQdQfrQGDA@mail.gmail.com>
X-Operating-System: Linux phenom 6.1.0-7-amd64 
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 04, 2023 at 03:53:09PM +0200, Geert Uytterhoeven wrote:
> Hi Daniel,
> 
> CC vkmsdrm maintainer
> 
> Thanks for your patch!
> 
> On Tue, Apr 4, 2023 at 2:36 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
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
> 
>     WARNING: fbcon: Driver 'vkmsdrmfb' missed to adjust virtual screen
> size (0x0 vs. 64x768)
> 
> This is a bug in the vkmsdrmfb driver and/or DRM helpers.
> 
> The message was added to make sure the individual drivers are fixed.
> Perhaps it should be changed to BUG() instead, so dmesg output
> cannot be drown?

So you're solution is to essentially force us to replicate this check over
all the drivers which cannot change the virtual size?

Are you volunteering to field that audit and type all the patches?

> > Fixes: 6c11df58fd1a ("fbmem: Check virtual screen sizes in fb_set_var()")
> > Cc: Helge Deller <deller@gmx.de>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: stable@vger.kernel.org # v5.4+
> > Cc: Daniel Vetter <daniel@ffwll.ch>
> > Cc: Javier Martinez Canillas <javierm@redhat.com>
> > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> 
> NAKed-by: Geert Uytterhoeven <geert@linux-m68k.org>

Yes I know it's not pretty, but realistically unless someone starts typing
a _lot_ of patches this is the solution. It's exactly the same solution
we've implemented for all other gaps syzcaller has find in fbdev input
validation. Unless you can show that this is papering over a more severe
bug somewhere, but then I guess it really should be a BUG to prevent worse
things from happening.
-Daniel

> 
> > --- a/drivers/video/fbdev/core/fbmem.c
> > +++ b/drivers/video/fbdev/core/fbmem.c
> > @@ -1021,10 +1021,6 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
> >         /* verify that virtual resolution >= physical resolution */
> >         if (var->xres_virtual < var->xres ||
> >             var->yres_virtual < var->yres) {
> > -               pr_warn("WARNING: fbcon: Driver '%s' missed to adjust virtual screen size (%ux%u vs. %ux%u)\n",
> > -                       info->fix.id,
> > -                       var->xres_virtual, var->yres_virtual,
> > -                       var->xres, var->yres);
> >                 return -EINVAL;
> >         }
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
