Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC9A48889D
	for <lists+stable@lfdr.de>; Sun,  9 Jan 2022 11:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiAIKB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jan 2022 05:01:56 -0500
Received: from mail-pj1-f52.google.com ([209.85.216.52]:43532 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiAIKB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jan 2022 05:01:56 -0500
Received: by mail-pj1-f52.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo3915831pjb.2;
        Sun, 09 Jan 2022 02:01:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qVWt1AOHq8FaZK5a1Obn95ziGdwNeIdN+dxQ37ARsjk=;
        b=paHBr5bKG2rQheXCmwJ4dS4H1fR4dM2sVTmiQc4NjgLn+mEQzwb9bouxwCTTbNMZJC
         2nJZ7mQ+05I6vzTBjRx725+ln+fA+pg4h1uFtvrxsY7yByZqC5W29D1Ze37ooQMhAfDc
         JO9GCfJ/YTitm33Of0RwuI8eB+5wq/8Q3dMDaNWe+tbJHQGcrLDOpIEAoxmbW2JIMzVi
         n52N7y9D6ezx2XPPBbAmj3OtYqI1QFs67vPO6JNzWxItqPcbQUI6vr1pvri8rkjVEcgO
         6fYnYasf89+xDNrrxk5HJFizNN5wbSt7QJeCptXT/JwA3ZLTJrmxr9sNQukrKHA9wxGn
         Vw1w==
X-Gm-Message-State: AOAM5302CCymzWrCTwjjg6BMHNcaubHc5svULCHOZcsG9cZhKPTR325u
        zdhBIkjRpAuhJuRCuAdWQk+MmdcWBKG91g==
X-Google-Smtp-Source: ABdhPJxCDVKm/loC0NBZH667A2F59JO4QcPTUVleIWxENLM/W4d5qDnzA+Qiu3h0O9MYPNX0kCv1Cw==
X-Received: by 2002:a05:6102:3746:: with SMTP id u6mr23168225vst.60.1641722505077;
        Sun, 09 Jan 2022 02:01:45 -0800 (PST)
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com. [209.85.222.45])
        by smtp.gmail.com with ESMTPSA id c15sm2190459uaj.13.2022.01.09.02.01.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Jan 2022 02:01:44 -0800 (PST)
Received: by mail-ua1-f45.google.com with SMTP id m15so4136949uap.6;
        Sun, 09 Jan 2022 02:01:44 -0800 (PST)
X-Received: by 2002:ab0:2118:: with SMTP id d24mr23782568ual.78.1641722504022;
 Sun, 09 Jan 2022 02:01:44 -0800 (PST)
MIME-Version: 1.0
References: <20220107110723.323276-1-javierm@redhat.com> <20220107110723.323276-3-javierm@redhat.com>
In-Reply-To: <20220107110723.323276-3-javierm@redhat.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sun, 9 Jan 2022 11:01:32 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWvFL9GYM-dMdZeyZrQjr13Sgt-XXN19bc6jA3emn2Dcw@mail.gmail.com>
Message-ID: <CAMuHMdWvFL9GYM-dMdZeyZrQjr13Sgt-XXN19bc6jA3emn2Dcw@mail.gmail.com>
Subject: Re: [PATCH 2/2] video: vga16fb: Only probe for EGA and VGA 16 color
 graphic cards
To:     Javier Martinez Canillas <javierm@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kris Karas <bugs-a21@moonlit-rail.com>,
        stable <stable@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Javier,

On Fri, Jan 7, 2022 at 9:00 PM Javier Martinez Canillas
<javierm@redhat.com> wrote:
> The vga16fb framebuffer driver only supports Enhanced Graphics Adapter
> (EGA) and Video Graphics Array (VGA) 16 color graphic cards.
>
> But it doesn't check if the adapter is one of those or if a VGA16 mode
> is used. This means that the driver will be probed even if a VESA BIOS
> Extensions (VBE) or Graphics Output Protocol (GOP) interface is used.
>
> This issue has been present for a long time but it was only exposed by
> commit d391c5827107 ("drivers/firmware: move x86 Generic System
> Framebuffers support") since the platform device registration to match
> the {vesa,efi}fb drivers is done later as a consequence of that change.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=215001
> Fixes: d391c5827107 ("drivers/firmware: move x86 Generic System Framebuffers support")
> Reported-by: Kris Karas <bugs-a21@moonlit-rail.com>
> Cc: <stable@vger.kernel.org> # 5.15.x
> Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
> Tested-by: Kris Karas <bugs-a21@moonlit-rail.com>

Thanks for your patch!

> --- a/drivers/video/fbdev/vga16fb.c
> +++ b/drivers/video/fbdev/vga16fb.c
> @@ -1422,6 +1422,18 @@ static int __init vga16fb_init(void)
>
>         vga16fb_setup(option);
>  #endif
> +
> +       /* only EGA and VGA in 16 color graphic mode are supported */
> +       if (screen_info.orig_video_isVGA != VIDEO_TYPE_EGAC &&
> +           screen_info.orig_video_isVGA != VIDEO_TYPE_VGAC)
> +               return -ENODEV;

Probably these checks should be wrapped inside a check for CONFIG_X86?

All non-x86 architectures (except for 2 MIPS platforms) treat
orig_video_isVGA as a boolean flag, and just assign 1 to it.

> +
> +       if (screen_info.orig_video_mode != 0x0D &&      /* 320x200/4 (EGA) */
> +           screen_info.orig_video_mode != 0x0E &&      /* 640x200/4 (EGA) */
> +           screen_info.orig_video_mode != 0x10 &&      /* 640x350/4 (EGA) */
> +           screen_info.orig_video_mode != 0x12)        /* 640x480/4 (VGA) */
> +               return -ENODEV;
> +

Likewise.

A long time ago, I used vga16fb on a PPC box to use a standard PC
graphics card (initialized using an emulator for the card's BIOS ROM),
as a second display. The above changes would break such a use case.

>         ret = platform_driver_register(&vga16fb_driver);
>
>         if (!ret) {

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
