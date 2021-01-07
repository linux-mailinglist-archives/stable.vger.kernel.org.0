Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F1A2ECBA7
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 09:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbhAGIOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 03:14:02 -0500
Received: from mail-oi1-f177.google.com ([209.85.167.177]:44720 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbhAGIOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 03:14:02 -0500
Received: by mail-oi1-f177.google.com with SMTP id d189so6490131oig.11;
        Thu, 07 Jan 2021 00:13:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2sNU56Ph9zOh5AccBeHHxNWeCtZj6RXCAKwJxVBMKmE=;
        b=UunNUgONTNSLs9KQH9szadf8eYTaPHc7X+IR67UsD/7/utczvqG7173tay/KazIZoN
         jtMaFekKPASOb81DdC3hZbakxN3q6LNcAU7jA9RrOzNi6IqHWE1j9lJEIAVmkUl3xR9a
         Mxcy4yvhf2RDay9H0l3uMro2+GBfWoS6dxW9PcaMTTiJiA7PD9ZbHsiLKtMNrbVhRRuI
         NGED7BfRVLws1Iaing6f/r2zJCI3RnvcN7PICWhOBaOCmEItx2+e4CbQVrNMa7s4Yfyz
         7nAzfo66o9Q8a9gImc1FtMFhUmal8ZID9OrLVCPBj9ssxcs7lD+7JlBWBgWUF9gSp++l
         5fog==
X-Gm-Message-State: AOAM531XxIv3jd2jkNv7F6FFWHrCdmtOhwBunGG69AoiefRKv2Xr2vs5
        wu6CTD+SF3ZSZNrA/FuBKRTXnHZ4S2YBhoHY8kTXD2AhJOw=
X-Google-Smtp-Source: ABdhPJwrnQjPXBYzM2SyYW1CfGTO1vgkI2yKYDdyKTlIhuNFDs8Idq4cEQdtVae6Q4iQGMePy4f/z4WxW1zGTn3wWGI=
X-Received: by 2002:aca:3cc5:: with SMTP id j188mr684519oia.54.1610007201402;
 Thu, 07 Jan 2021 00:13:21 -0800 (PST)
MIME-Version: 1.0
References: <20210104155708.800470590@linuxfoundation.org> <20210104155710.187945647@linuxfoundation.org>
In-Reply-To: <20210104155710.187945647@linuxfoundation.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 7 Jan 2021 09:13:10 +0100
Message-ID: <CAMuHMdXRgam2zahPEGcw8+76Xm-0AO-Ci9-YmVa5JpTKVHphRw@mail.gmail.com>
Subject: Re: [PATCH 5.10 28/63] fbcon: Disable accelerated scrolling
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Nouveau Dev <nouveau@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        George Kennedy <george.kennedy@oracle.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Peter Rosin <peda@axentia.se>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 4, 2021 at 5:58 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> From: Daniel Vetter <daniel.vetter@ffwll.ch>
>
> commit 39aead8373b3c20bb5965c024dfb51a94e526151 upstream.
>
> So ever since syzbot discovered fbcon, we have solid proof that it's
> full of bugs. And often the solution is to just delete code and remove
> features, e.g.  50145474f6ef ("fbcon: remove soft scrollback code").
>
> Now the problem is that most modern-ish drivers really only treat
> fbcon as an dumb kernel console until userspace takes over, and Oops
> printer for some emergencies. Looking at drm drivers and the basic
> vesa/efi fbdev drivers shows that only 3 drivers support any kind of
> acceleration:
>
> - nouveau, seems to be enabled by default
> - omapdrm, when a DMM remapper exists using remapper rewriting for
>   y/xpanning
> - gma500, but that is getting deleted now for the GTT remapper trick,
>   and the accelerated copyarea never set the FBINFO_HWACCEL_COPYAREA
>   flag, so unused (and could be deleted already I think).
>
> No other driver supportes accelerated fbcon. And fbcon is the only

Note that there are 32 more drivers using acceleration under
drivers/video/fbdev/.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
