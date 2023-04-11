Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563146DE026
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjDKP6H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 11 Apr 2023 11:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjDKP6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:58:04 -0400
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0CFE59;
        Tue, 11 Apr 2023 08:58:01 -0700 (PDT)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-54f6a796bd0so51666827b3.12;
        Tue, 11 Apr 2023 08:58:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681228681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f+3w89leq3eEIkwoZcDVhq9F0DoH4q/Sj2floJIfCG0=;
        b=b9hehx53Rg1EmjVFQKFOlDYTgMzfZofyjGHtV0ndEj55dn89EllA85Aom8EwOYhVCu
         my3dyoOmI5qiqEygWwSkJkm5Nkbp6MqvsufxT9U1u8rGpVQsM9KwllGzyDNSN5QhFsMR
         u2Z5XNGfnMplnsdh3r28I7D6ooZYTU7ExBZVnKpuktkmvPz4tc5e9LxCppiTnr+t6QXj
         ygYXge5T22CRuKa4YYMjV0u2/Z3tH/1tEwQL1BqhvA087agkxE2oe1U6KNdMXu6pUQiV
         e3zB6mLFUTVBByfSUUXQtQKPutPqmKox6k+nmwyxN8i0UmHBnKgqOGbbtsrmvdlfAs/v
         16mA==
X-Gm-Message-State: AAQBX9eB+24gNh4orGEYLNl8L+Uz5gvo91G0YMZDq3rDuID2KfMuJZGS
        xDF/99C7M+8zz0+8EnMkDojSE7YcHOsrAQ==
X-Google-Smtp-Source: AKy350aq7hf0rfi34qVVccbfpKSa6XDOF8m7qcps4XHyA956RA44VLNIX8EXuK/mJncZPV5K12GKjg==
X-Received: by 2002:a0d:ddcc:0:b0:54f:baa:2c with SMTP id g195-20020a0dddcc000000b0054f0baa002cmr2455815ywe.0.1681228680749;
        Tue, 11 Apr 2023 08:58:00 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id s189-20020a819bc6000000b00545a0818483sm3592683ywg.19.2023.04.11.08.57.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 08:57:58 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id a13so8716783ybl.11;
        Tue, 11 Apr 2023 08:57:58 -0700 (PDT)
X-Received: by 2002:a25:7654:0:b0:b8e:e0db:5b9d with SMTP id
 r81-20020a257654000000b00b8ee0db5b9dmr4304677ybc.12.1681228677832; Tue, 11
 Apr 2023 08:57:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230404193934.472457-1-daniel.vetter@ffwll.ch> <ZDVkSaskEvwix8Bz@phenom.ffwll.local>
In-Reply-To: <ZDVkSaskEvwix8Bz@phenom.ffwll.local>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 11 Apr 2023 17:57:44 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUVME6RnXkq-0FsUdH6-hqe5BqeT2UzgtW1uK+sg0GsQg@mail.gmail.com>
Message-ID: <CAMuHMdUVME6RnXkq-0FsUdH6-hqe5BqeT2UzgtW1uK+sg0GsQg@mail.gmail.com>
Subject: Re: [PATCH] fbmem: Reject FB_ACTIVATE_KD_TEXT from userspace
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>, shlomo@fastmail.com,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        =?UTF-8?Q?Noralf_Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Qiujun Huang <hqjagain@gmail.com>,
        Peter Rosin <peda@axentia.se>, linux-fbdev@vger.kernel.org,
        Helge Deller <deller@gmx.de>, Sam Ravnborg <sam@ravnborg.org>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Shigeru Yoshida <syoshida@redhat.com>
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

Hi Daniel,

On Tue, Apr 11, 2023 at 3:44 PM Daniel Vetter <daniel@ffwll.ch> wrote:
> On Tue, Apr 04, 2023 at 09:39:34PM +0200, Daniel Vetter wrote:
> > This is an oversight from dc5bdb68b5b3 ("drm/fb-helper: Fix vt
> > restore") - I failed to realize that nasty userspace could set this.
> >
> > It's not pretty to mix up kernel-internal and userspace uapi flags
> > like this, but since the entire fb_var_screeninfo structure is uapi
> > we'd need to either add a new parameter to the ->fb_set_par callback
> > and fb_set_par() function, which has a _lot_ of users. Or some other
> > fairly ugly side-channel int fb_info. Neither is a pretty prospect.
> >
> > Instead just correct the issue at hand by filtering out this
> > kernel-internal flag in the ioctl handling code.
> >
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > Fixes: dc5bdb68b5b3 ("drm/fb-helper: Fix vt restore")

> An Ack on this (or a better idea) would be great, so I can stuff it into
> -fixes.

I don't understand what the original commit this fixes is doing anyway...

> > --- a/drivers/video/fbdev/core/fbmem.c
> > +++ b/drivers/video/fbdev/core/fbmem.c
> > @@ -1116,6 +1116,8 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
> >       case FBIOPUT_VSCREENINFO:
> >               if (copy_from_user(&var, argp, sizeof(var)))
> >                       return -EFAULT;
> > +             /* only for kernel-internal use */
> > +             var.activate &= ~FB_ACTIVATE_KD_TEXT;
> >               console_lock();
> >               lock_fb_info(info);
> >               ret = fbcon_modechange_possible(info, &var);

Perhaps FB_ACTIVATE_KD_TEXT should be removed (marked as
reserved) from include/uapi/linux/fb.h, too?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
