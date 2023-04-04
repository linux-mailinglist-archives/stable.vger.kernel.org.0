Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0771A6D6803
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 17:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbjDDPzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 11:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235903AbjDDPzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 11:55:37 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D781BEA
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 08:55:17 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id r14so18868205oiw.12
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 08:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1680623716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vSWsk9Y++g6/hpC5vSHS+QJ/lNQNHpTZMHP/2shPmbs=;
        b=VlNEmhrPwxVCbnsPwcFSrwRYrK/x4h05qNwnViQcjea1CQFWrmdbbkzjQeHpHzHKJQ
         1FwZRgRTeJZ0EFQ8eFJaySZ3lK80zRW0+weOLucFgS5XJXMuna6FF7XKjWJFQivwQRpM
         A7e2nkCSnUne7lXs1WN4aqebWq7hyuScfx35Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680623716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vSWsk9Y++g6/hpC5vSHS+QJ/lNQNHpTZMHP/2shPmbs=;
        b=cCuKnHnmheAg/aeGIoehzrTZ8+DPjb7xFC6XcCQRI4rJ0pHQV+P2FXqKFXkBUKQHpu
         ANELYJFCOt1ewa3jz0GOPT+tSZ6y8EcyvQt0/Vm1xbQzq3bNaYWjvtTOL4xuGw6hYUEj
         g1xGPUUFlDJqH/9ynbRjsElGGGEwZZZLMa+u+I39Nw5EATayLU/bQuToPI8Pqi6U3eZD
         2KcPFgAMgxI64EIvYHeatXt49jq9JHG4GcTMdqe1A1sL/zn+OhrlQBPXJp3dCjaBNCDY
         i9JQwk2lC8wKeXa+gZasRRJi4E0fEcq9esYi8X4fWlEZug3Av2WS8aGbIvnxMAUIphmb
         sc2w==
X-Gm-Message-State: AAQBX9dVhK8WDCGNo3ffVtGOQlbi5xJsTqIpG6BUAqj2qCSush+EO8NL
        TE/uIHdJZr38PhihcWWXkEqIDm5orU5rpsmPwQs0wg==
X-Google-Smtp-Source: AKy350YkVp980Bga0qAHmZX81SmximEY846/RtSXXbmAGEafONPYNvmd18elnjsGWqf8OMiuMAkKYyZmwqwkLXoJHzc=
X-Received: by 2002:a05:6808:280a:b0:389:2b9b:fe5f with SMTP id
 et10-20020a056808280a00b003892b9bfe5fmr1166765oib.8.1680623715961; Tue, 04
 Apr 2023 08:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230404123624.360384-1-daniel.vetter@ffwll.ch>
 <CAMuHMdUR=rx2QPvpzsSCwXTSTsPQOudNMzyL3dtZGQdQfrQGDA@mail.gmail.com>
 <ZCwtMJEAJiId/TJe@phenom.ffwll.local> <ZCwx+2hAmyDqOfWu@phenom.ffwll.local> <CAMuHMdVt+fsHhk73hPe=bN5e_vTjKEM014Q1AJ9tnankvsXcHg@mail.gmail.com>
In-Reply-To: <CAMuHMdVt+fsHhk73hPe=bN5e_vTjKEM014Q1AJ9tnankvsXcHg@mail.gmail.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 4 Apr 2023 17:55:04 +0200
Message-ID: <CAKMK7uFEmt1=4jDi1xDbnTVH6M2iEZSjcY-UN93do0NiH=GogA@mail.gmail.com>
Subject: Re: [PATCH] fbdev: Don't spam dmesg on bad userspace ioctl input
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com,
        Helge Deller <deller@gmx.de>, stable@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Melissa Wen <melissa.srw@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 4 Apr 2023 at 16:51, Geert Uytterhoeven <geert@linux-m68k.org> wrot=
e:
>
> CC linux-fbdev
>
> On Tue, Apr 4, 2023 at 4:19=E2=80=AFPM Daniel Vetter <daniel@ffwll.ch> wr=
ote:
> > On Tue, Apr 04, 2023 at 03:59:12PM +0200, Daniel Vetter wrote:
> > > On Tue, Apr 04, 2023 at 03:53:09PM +0200, Geert Uytterhoeven wrote:
> > > > On Tue, Apr 4, 2023 at 2:36=E2=80=AFPM Daniel Vetter <daniel.vetter=
@ffwll.ch> wrote:
> > > > > There's a few reasons the kernel should not spam dmesg on bad
> > > > > userspace ioctl input:
> > > > > - at warning level it results in CI false positives
> > > > > - it allows userspace to drown dmesg output, potentially hiding r=
eal
> > > > >   issues.
> > > > >
> > > > > None of the other generic EINVAL checks report in the
> > > > > FBIOPUT_VSCREENINFO ioctl do this, so it's also inconsistent.
> > > > >
> > > > > I guess the intent of the patch which introduced this warning was=
 that
> > > > > the drivers ->fb_check_var routine should fail in that case. Real=
ity
> > > > > is that there's too many fbdev drivers and not enough people
> > > > > maintaining them by far, and so over the past few years we've sim=
ply
> > > > > handled all these validation gaps by tighning the checks in the c=
ore,
> > > > > because that's realistically really all that will ever happen.
> > > > >
> > > > > Reported-by: syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.co=
m
> > > > > Link: https://syzkaller.appspot.com/bug?id=3Dc5faf983bfa4a607de53=
0cd3bb008888bf06cefc
> > > >
> > > >     WARNING: fbcon: Driver 'vkmsdrmfb' missed to adjust virtual scr=
een
> > > > size (0x0 vs. 64x768)
> > > >
> > > > This is a bug in the vkmsdrmfb driver and/or DRM helpers.
> > > >
> > > > The message was added to make sure the individual drivers are fixed=
.
> > > > Perhaps it should be changed to BUG() instead, so dmesg output
> > > > cannot be drown?
> > >
> > > So you're solution is to essentially force us to replicate this check=
 over
> > > all the drivers which cannot change the virtual size?
> > >
> > > Are you volunteering to field that audit and type all the patches?
> >
> > Note that at least efifb, vesafb and offb seem to get this wrong. I did=
n't
> > bother checking any of the non-fw drivers. Iow there is a _lot_ of work=
 in
> > your nack.
>
> Please don't spread FUD: efifb, vesafb and offb do not implement
> fb_ops.fb_check_var(), so they are not affected.

Hm I missed that early out. I'll do a patch to fix the drm fb helpers,
as mentioned in the other thread I don't think we can actually just
delete that because it would short-circuit out the fb_set_par call
too.
-Daniel

> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org
>
> In personal conversations with technical people, I call myself a hacker. =
But
> when I'm talking to journalists I just say "programmer" or something like=
 that.
>                                 -- Linus Torvalds



--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
