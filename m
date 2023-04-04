Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F706D65EE
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 16:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbjDDOzJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 4 Apr 2023 10:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbjDDOzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 10:55:08 -0400
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4187C525F;
        Tue,  4 Apr 2023 07:54:47 -0700 (PDT)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-5416698e889so618993317b3.2;
        Tue, 04 Apr 2023 07:54:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ik+XVDuVY5uU69jOiX1kKbBmdHoMOQd3oBGc6LuK8RQ=;
        b=MLZeAvo9z7J3/gB1AakbB2OFrzaBhchZQhUfWrwkMLTuhOV0l4HOt+kl+ZMBVzX1ZQ
         cZbD56ji55mw041IJLc0ghn+7UloCmsL+3a2UB+pUq9DZKHYhf+abCf9DXVKOCdD3F9b
         fy3aRGKoSQjObpwICLKDBElFaDGAuLb07X5JcOZVJEewpXpxv18ZT7jgTkn80edjr23c
         mvDoyFilAnfcI/t8dT1uKSN01Yl3g7YDPg3zw6mIriISoZK1aHpbB8+f11shYwHzECNQ
         7gmg/vp3UTm9VKQUlE5PeiRvSwMkDlzCxM1E3w5/6KFNf10ofRiXuA1u47JzNWsjPkGe
         6exQ==
X-Gm-Message-State: AAQBX9egoOPip530bHX21JZK3v5nFuVHEDnr8YC/PG/UMWU3JtP5334Q
        8GBqYedOR5LU/2RhbeK3uWrnBz2F/w9OB3vx
X-Google-Smtp-Source: AKy350bLwI2VzYJpoNxuulQpcrfUkCTkpJnYzCkr9dBDPMqVuISgxqoP94dE/UxxAW/XneXSIqRQTw==
X-Received: by 2002:a0d:c341:0:b0:541:8285:1593 with SMTP id f62-20020a0dc341000000b0054182851593mr2905231ywd.7.1680620085904;
        Tue, 04 Apr 2023 07:54:45 -0700 (PDT)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com. [209.85.128.177])
        by smtp.gmail.com with ESMTPSA id bo17-20020a05690c059100b00545b42732d0sm3173736ywb.143.2023.04.04.07.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 07:54:45 -0700 (PDT)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-545e907790fso502777737b3.3;
        Tue, 04 Apr 2023 07:54:45 -0700 (PDT)
X-Received: by 2002:a81:4304:0:b0:541:7f69:aa9b with SMTP id
 q4-20020a814304000000b005417f69aa9bmr1667876ywa.4.1680620085205; Tue, 04 Apr
 2023 07:54:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230404123624.360384-1-daniel.vetter@ffwll.ch>
 <CAMuHMdUR=rx2QPvpzsSCwXTSTsPQOudNMzyL3dtZGQdQfrQGDA@mail.gmail.com>
 <ZCwtMJEAJiId/TJe@phenom.ffwll.local> <ZCwx+2hAmyDqOfWu@phenom.ffwll.local> <fab035dd-6276-5343-7422-69969afb8006@suse.de>
In-Reply-To: <fab035dd-6276-5343-7422-69969afb8006@suse.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 4 Apr 2023 16:54:33 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVkSbYrQesuGyEcdufZ6WH2CFTMEEpCP6atDMq11abn3A@mail.gmail.com>
Message-ID: <CAMuHMdVkSbYrQesuGyEcdufZ6WH2CFTMEEpCP6atDMq11abn3A@mail.gmail.com>
Subject: Re: [PATCH] fbdev: Don't spam dmesg on bad userspace ioctl input
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Daniel Vetter <daniel@ffwll.ch>,
        Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Helge Deller <deller@gmx.de>,
        syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com,
        Javier Martinez Canillas <javierm@redhat.com>,
        stable@vger.kernel.org, Melissa Wen <melissa.srw@gmail.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
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

CC linux-fbdev

On Tue, Apr 4, 2023 at 4:41 PM Thomas Zimmermann <tzimmermann@suse.de> wrote:
> Am 04.04.23 um 16:19 schrieb Daniel Vetter:
> > On Tue, Apr 04, 2023 at 03:59:12PM +0200, Daniel Vetter wrote:
> >> On Tue, Apr 04, 2023 at 03:53:09PM +0200, Geert Uytterhoeven wrote:
> >>> CC vkmsdrm maintainer
> >>>
> >>> Thanks for your patch!
> >>>
> >>> On Tue, Apr 4, 2023 at 2:36 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> >>>> There's a few reasons the kernel should not spam dmesg on bad
> >>>> userspace ioctl input:
> >>>> - at warning level it results in CI false positives
> >>>> - it allows userspace to drown dmesg output, potentially hiding real
> >>>>    issues.
> >>>>
> >>>> None of the other generic EINVAL checks report in the
> >>>> FBIOPUT_VSCREENINFO ioctl do this, so it's also inconsistent.
> >>>>
> >>>> I guess the intent of the patch which introduced this warning was that
> >>>> the drivers ->fb_check_var routine should fail in that case. Reality
> >>>> is that there's too many fbdev drivers and not enough people
> >>>> maintaining them by far, and so over the past few years we've simply
> >>>> handled all these validation gaps by tighning the checks in the core,
> >>>> because that's realistically really all that will ever happen.
> >>>>
> >>>> Reported-by: syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com
> >>>> Link: https://syzkaller.appspot.com/bug?id=c5faf983bfa4a607de530cd3bb008888bf06cefc
> >>>
> >>>      WARNING: fbcon: Driver 'vkmsdrmfb' missed to adjust virtual screen
> >>> size (0x0 vs. 64x768)
> >>>
> >>> This is a bug in the vkmsdrmfb driver and/or DRM helpers.
> >>>
> >>> The message was added to make sure the individual drivers are fixed.
> >>> Perhaps it should be changed to BUG() instead, so dmesg output
> >>> cannot be drown?
> >>
> >> So you're solution is to essentially force us to replicate this check over
> >> all the drivers which cannot change the virtual size?
> >>
> >> Are you volunteering to field that audit and type all the patches?

The message is there to invite people to look at .fb_check_var()
implementations, and fix the issues.

> As most of us really only care about DRM, we can add this test to
> drm_fb_helper_check_var() [1] and that's it. No need to fix all of the
> fbdev drivers.

Either drm_fb_helper_check_var() (which is the most used buggy
implementation) has to be fixed, or it should be removed, cfr.
https://lore.kernel.org/all/20220629105658.1373770-1-geert@linux-m68k.org

> Having said that, I think the few remaining fbdev devs should decide if
> they want to actually put effort into fbdev, or accept it to bitrot
> away. The current state of 'non-maintenance' is the worst situation.
> I've been working on the console emulation and it is hard to get
> qualified reviews of the related fbdev code. At the same time, it's also
> not possible to get Ack-bys rubber-stamped.
>
> Best regards
> Thomas
>
> [1]
> https://elixir.bootlin.com/linux/latest/source/drivers/gpu/drm/drm_fb_helper.c#L1514
>
> > -Daniel
> >
> >>>> Fixes: 6c11df58fd1a ("fbmem: Check virtual screen sizes in fb_set_var()")
> >>>> Cc: Helge Deller <deller@gmx.de>
> >>>> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> >>>> Cc: stable@vger.kernel.org # v5.4+
> >>>> Cc: Daniel Vetter <daniel@ffwll.ch>
> >>>> Cc: Javier Martinez Canillas <javierm@redhat.com>
> >>>> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> >>>> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> >>>
> >>> NAKed-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >>
> >> Yes I know it's not pretty, but realistically unless someone starts typing
> >> a _lot_ of patches this is the solution. It's exactly the same solution
> >> we've implemented for all other gaps syzcaller has find in fbdev input
> >> validation. Unless you can show that this is papering over a more severe
> >> bug somewhere, but then I guess it really should be a BUG to prevent worse
> >> things from happening.
> >> -Daniel
> >>
> >>>
> >>>> --- a/drivers/video/fbdev/core/fbmem.c
> >>>> +++ b/drivers/video/fbdev/core/fbmem.c
> >>>> @@ -1021,10 +1021,6 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
> >>>>          /* verify that virtual resolution >= physical resolution */
> >>>>          if (var->xres_virtual < var->xres ||
> >>>>              var->yres_virtual < var->yres) {
> >>>> -               pr_warn("WARNING: fbcon: Driver '%s' missed to adjust virtual screen size (%ux%u vs. %ux%u)\n",
> >>>> -                       info->fix.id,
> >>>> -                       var->xres_virtual, var->yres_virtual,
> >>>> -                       var->xres, var->yres);
> >>>>                  return -EINVAL;
> >>>>          }

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
