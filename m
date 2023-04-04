Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC326D6509
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 16:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbjDDOTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 10:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbjDDOTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 10:19:44 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FB39B
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 07:19:42 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id ew6so131207655edb.7
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 07:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1680617981; x=1683209981;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yg0zujWjsopYUHjj/y+1CC+hIjRDJCkaqpnc9IDoyFU=;
        b=OGq4hw/UGyxuTDszYF65QSy806LADhMokUbgWW5lP6nOoKUgekC/Ji2fWE2jqmD850
         Un5XJE7fuFDWtOnoZfr0ieyiKsTFUiPCYn+Ybm9pV7E9a2oJVR+cVFLltxR/dKPYN6Jz
         gZG2xD/zH640DT3yMAelSZ0YUwuad2U7y8L3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680617981; x=1683209981;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yg0zujWjsopYUHjj/y+1CC+hIjRDJCkaqpnc9IDoyFU=;
        b=EC+yDhiVA6TQ0pPdtKsnzusecedAeXjm229yDBK9kbgbRzC3sAekOv/ITgz6bjv71f
         vbvVE3eqPfJxiFlmUNXTLHy67SXypYwuSnLLh6jExtXSM7wvxULHuoCbb94/QwGoPw7e
         RQ+ZXODCEfDvDujEVjJ/xEZ0vhoBQIvrZ3032QYtXd+coR3lMmPYRflUBAKRsns3c4HS
         Y2+ZUQXZpvjAxguCUurU/8/1PEajluatIejgwJGfaqmJiiCfFtM2N0v7fkqBclaaiI6I
         sUVaRfIsDTwW5boA/eaddrL4TO666+O7nKj/sNMEYRyQtLMPWNk7LgyCDAVlAUmhIjwI
         fbKg==
X-Gm-Message-State: AAQBX9cbo4AW1PTCR6hagAUUmQU7gYueHBiFVRBibiqcw98otBiQzq+a
        tEYYmIQL81E3wGmJe7n2OLYbdA==
X-Google-Smtp-Source: AKy350b7a4TD8FYSmHY2Aiy+aQltFcZpP3gwei1H5/KEonXw0dG0bORtZVBS/rfhJUcvbB0RwEuGag==
X-Received: by 2002:a17:906:2d2:b0:93f:e5e4:8c13 with SMTP id 18-20020a17090602d200b0093fe5e48c13mr2432631ejk.5.1680617981470;
        Tue, 04 Apr 2023 07:19:41 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-33.fiber7.init7.net. [212.51.149.33])
        by smtp.gmail.com with ESMTPSA id t13-20020a1709067c0d00b009353047c02dsm5995973ejo.167.2023.04.04.07.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:19:41 -0700 (PDT)
Date:   Tue, 4 Apr 2023 16:19:39 +0200
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
Message-ID: <ZCwx+2hAmyDqOfWu@phenom.ffwll.local>
References: <20230404123624.360384-1-daniel.vetter@ffwll.ch>
 <CAMuHMdUR=rx2QPvpzsSCwXTSTsPQOudNMzyL3dtZGQdQfrQGDA@mail.gmail.com>
 <ZCwtMJEAJiId/TJe@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZCwtMJEAJiId/TJe@phenom.ffwll.local>
X-Operating-System: Linux phenom 6.1.0-7-amd64 
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 04, 2023 at 03:59:12PM +0200, Daniel Vetter wrote:
> On Tue, Apr 04, 2023 at 03:53:09PM +0200, Geert Uytterhoeven wrote:
> > Hi Daniel,
> > 
> > CC vkmsdrm maintainer
> > 
> > Thanks for your patch!
> > 
> > On Tue, Apr 4, 2023 at 2:36 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > > There's a few reasons the kernel should not spam dmesg on bad
> > > userspace ioctl input:
> > > - at warning level it results in CI false positives
> > > - it allows userspace to drown dmesg output, potentially hiding real
> > >   issues.
> > >
> > > None of the other generic EINVAL checks report in the
> > > FBIOPUT_VSCREENINFO ioctl do this, so it's also inconsistent.
> > >
> > > I guess the intent of the patch which introduced this warning was that
> > > the drivers ->fb_check_var routine should fail in that case. Reality
> > > is that there's too many fbdev drivers and not enough people
> > > maintaining them by far, and so over the past few years we've simply
> > > handled all these validation gaps by tighning the checks in the core,
> > > because that's realistically really all that will ever happen.
> > >
> > > Reported-by: syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com
> > > Link: https://syzkaller.appspot.com/bug?id=c5faf983bfa4a607de530cd3bb008888bf06cefc
> > 
> >     WARNING: fbcon: Driver 'vkmsdrmfb' missed to adjust virtual screen
> > size (0x0 vs. 64x768)
> > 
> > This is a bug in the vkmsdrmfb driver and/or DRM helpers.
> > 
> > The message was added to make sure the individual drivers are fixed.
> > Perhaps it should be changed to BUG() instead, so dmesg output
> > cannot be drown?
> 
> So you're solution is to essentially force us to replicate this check over
> all the drivers which cannot change the virtual size?
> 
> Are you volunteering to field that audit and type all the patches?

Note that at least efifb, vesafb and offb seem to get this wrong. I didn't
bother checking any of the non-fw drivers. Iow there is a _lot_ of work in
your nack.
-Daniel

> > > Fixes: 6c11df58fd1a ("fbmem: Check virtual screen sizes in fb_set_var()")
> > > Cc: Helge Deller <deller@gmx.de>
> > > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > > Cc: stable@vger.kernel.org # v5.4+
> > > Cc: Daniel Vetter <daniel@ffwll.ch>
> > > Cc: Javier Martinez Canillas <javierm@redhat.com>
> > > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > 
> > NAKed-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Yes I know it's not pretty, but realistically unless someone starts typing
> a _lot_ of patches this is the solution. It's exactly the same solution
> we've implemented for all other gaps syzcaller has find in fbdev input
> validation. Unless you can show that this is papering over a more severe
> bug somewhere, but then I guess it really should be a BUG to prevent worse
> things from happening.
> -Daniel
> 
> > 
> > > --- a/drivers/video/fbdev/core/fbmem.c
> > > +++ b/drivers/video/fbdev/core/fbmem.c
> > > @@ -1021,10 +1021,6 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
> > >         /* verify that virtual resolution >= physical resolution */
> > >         if (var->xres_virtual < var->xres ||
> > >             var->yres_virtual < var->yres) {
> > > -               pr_warn("WARNING: fbcon: Driver '%s' missed to adjust virtual screen size (%ux%u vs. %ux%u)\n",
> > > -                       info->fix.id,
> > > -                       var->xres_virtual, var->yres_virtual,
> > > -                       var->xres, var->yres);
> > >                 return -EINVAL;
> > >         }
> > 
> > Gr{oetje,eeting}s,
> > 
> >                         Geert
> > 
> > 
> > --
> > Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> > 
> > In personal conversations with technical people, I call myself a hacker. But
> > when I'm talking to journalists I just say "programmer" or something like that.
> >                                 -- Linus Torvalds
> 
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
