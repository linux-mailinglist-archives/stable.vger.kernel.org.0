Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A59F4A5D9A
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 14:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238809AbiBANp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 08:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238818AbiBANp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 08:45:28 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E27C06173D
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 05:45:28 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id o9-20020a9d7189000000b0059ee49b4f0fso16268476otj.2
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 05:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2/6KNv9/sT6GkrKOK9WEHCnafWs+1/uASbFZJ68bfvw=;
        b=g5/k9Xnyqr4hCFjiKV9VdFUS0An5UbQmLXEd7/TNbrj3V41u9lCYKOgsPddlPSzOpE
         5eqbEqANjmcVoZeGc/sV7FiuBIFY1wnxkZxKtGkWuM2niUacHpSeS+rYvK+OTJxP7yfd
         /DTGhTzkjZ+3FIkC1a5uMQ1BeznnJ9geArMzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2/6KNv9/sT6GkrKOK9WEHCnafWs+1/uASbFZJ68bfvw=;
        b=Hws/tVlg9gAPywjOCjj2lJol6EPIbVZNZjlAm3rWD4F7IPU1hFdvtgaAtpixnWnLdW
         1s83B9x0fVDjc1cU0RQa+GcwMxVzRkoSI82d17hyY492dqVg5vGXk9xEJWdPQO6ZVGx/
         iyxZtFhhuA9tBMW9dQgOEzqv/zP+EJemhOu3W86Va0WkYKNFnVM2KRe34pxxKl2R0d5T
         kkQcC19u755eYvXMPDD4dM29/uSnGMQABtAuSD9HqVi3Zu6YFxo3ZApfc/inO7kK72JF
         +wppT07Iq4whKD5L+opxZOIfUqhVQGJ7y083PcYcR6FZTc4M3Eu5IZS4L9UvV7U5ngbG
         s6Iw==
X-Gm-Message-State: AOAM530p8UExNwYxW6y3SgLNbVGjOZ7AGv5XRLQzJSpFHw6gV1CimHXf
        bKYLvBK79owtVhTOWBK5CelzQuzu77ZmVDE0Vqh00g==
X-Google-Smtp-Source: ABdhPJyiUj0c4GiekrFNbqyjKRt2R7hyjIozmCDshxUT1STqLVwWfIk54gQfCldA3xLyzL/9RMHmTB93woo3MVX5US8=
X-Received: by 2002:a05:6830:1153:: with SMTP id x19mr13573050otq.321.1643723128054;
 Tue, 01 Feb 2022 05:45:28 -0800 (PST)
MIME-Version: 1.0
References: <20220131210552.482606-1-daniel.vetter@ffwll.ch>
 <20220131210552.482606-4-daniel.vetter@ffwll.ch> <9c22b709-cbcf-6a29-a45e-5a57ba0b9c14@gmx.de>
 <CAKMK7uGvOVe8kkJCTkQBEFw+3i2iAMANsyG9vGqZkcROZ9he4A@mail.gmail.com> <63018892-68e8-01b6-1e8f-853892e15c97@gmx.de>
In-Reply-To: <63018892-68e8-01b6-1e8f-853892e15c97@gmx.de>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 1 Feb 2022 14:45:16 +0100
Message-ID: <CAKMK7uHPn77GA12fFjmvkRUDQXSBkbYK5X=rJp8sfO_xarys_g@mail.gmail.com>
Subject: Re: [PATCH 03/21] fbcon: Restore fbcon scrolling acceleration
To:     Helge Deller <deller@gmx.de>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Claudio Suarez <cssk@net-c.es>,
        Dave Airlie <airlied@gmail.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sven Schnelle <svens@stackframe.org>,
        Gerd Hoffmann <kraxel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 1, 2022 at 12:01 PM Helge Deller <deller@gmx.de> wrote:
> On 2/1/22 11:36, Daniel Vetter wrote:
> > On Tue, Feb 1, 2022 at 11:16 AM Helge Deller <deller@gmx.de> wrote:
> >>
> >> On 1/31/22 22:05, Daniel Vetter wrote:
> >>> This functionally undoes 39aead8373b3 ("fbcon: Disable accelerated
> >>> scrolling"), but behind the FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
> >>> option.
> >>
> >> you have two trivial copy-n-paste errors in this patch which still prevent the
> >> console acceleration.
> >
> > Duh :-(
> >
> > But before we dig into details I think the big picture would be
> > better. I honestly don't like the #ifdef pile here that much.
>
> Me neither.
> The ifdefs give a better separation, but prevents that the compiler
> checks the various paths when building.
>
> > I wonder whether your approach, also with GETVX/YRES adjusted
> > somehow, wouldn't look cleaner?
> I think so.
> You wouldn't even need to touch GETVX/YRES because the compiler
> will optimize/reduce it from
>
> #define GETVYRES(s,i) ({                           \
>         (s == SCROLL_REDRAW || s == SCROLL_MOVE) ? \
>         (i)->var.yres : (i)->var.yres_virtual; })
>
> to just become:
>
> #define GETVYRES(s,i) ((i)->var.yres)

Yeah, but you need to roll out your helper to all the callsites. But
since you #ifdef out info->scrollmode we should catch them all I
guess.

> > Like I said in the cover letter I got mostly distracted with fbcon
> > locking last week, not really with this one here at all, so maybe
> > going with your 4 (or 2 if we squash them like I did here) patches is
> > neater?
>
> The benefit of my patch series was, that it could be easily backported first,
> and then cleaned up afterwards. Even a small additional backport patch to disable
> the fbcon acceleration for DRM in the old releases would be easy.
> But I'm not insisting on backporting the patches, if we find good way forward.
>
> So, either with the 4 (or 2) patches would be OK for me (or even your approach).

The idea behind the squash was that it's then impossible to backport
without the Kconfig, and so we'll only enable this code when people
intentionally want it. Maybe I'm too paranoid?

Anyway, you feel like finishing off your approach? Or should I send
out v2 of this with the issues fixed you spotted? Like I said either
is fine with me.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
