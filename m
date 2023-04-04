Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DE96D65C3
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 16:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjDDOwE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 4 Apr 2023 10:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjDDOv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 10:51:59 -0400
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88FE4481
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 07:51:58 -0700 (PDT)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-5445009c26bso618243397b3.8
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 07:51:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680619917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yqbEKKpaE4PIYS+ITrNwhkrKR/seTx+VrHN0WKCC4QQ=;
        b=Tz+Ltjf8zmQaJz9kgCi0mSQJaO8AmdaTMNdJ2rc4771Wqpw/xy9teEzySlzilFZBL2
         zO2KCNNriELnry7vF2hms/UbN2jP1WUTEx9TQ5WvKfmB6jzDjsok8sppPQMVTfdCQC7s
         3WMMOfVCClijlMMbga3SgnDaQtPnyI58SpaRfCcnOIH8KQbXz3IPUMQbGN+8nU5Oaa/1
         lthrWN+Q/56YYUk6aaNxdxm6GlvtWx9gyFitLg7ubpWb9CHsXzWNAzldn9BhLxKZgUyF
         GDvfIRPEhfN+qH8r+R4YDQWhdJJ8ybUDNxCIS/33P63XNiunQyAWBe2qcqLZAMSBsliq
         VTLA==
X-Gm-Message-State: AAQBX9e/bHx6VE0fVcDjcKgzufrSLrTbtq+cha7Wqa1qS10ijOhtlH3e
        QWOVCor8UFyo7uBifAEY4K043YdSi53g6Zxl
X-Google-Smtp-Source: AKy350aP8RqJ2p5g7PRnlUSKMY0LahY6Ee4xtUoqlCiszY9NARRigIH2BHExsHlQwVFXQsZMo2vnPA==
X-Received: by 2002:a0d:ea92:0:b0:541:8f14:e848 with SMTP id t140-20020a0dea92000000b005418f14e848mr2448403ywe.40.1680619917689;
        Tue, 04 Apr 2023 07:51:57 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id bg2-20020a05690c030200b00545a08184bbsm3248199ywb.75.2023.04.04.07.51.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 07:51:57 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id e65so38961119ybh.10
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 07:51:57 -0700 (PDT)
X-Received: by 2002:a25:1185:0:b0:a27:3ecc:ffe7 with SMTP id
 127-20020a251185000000b00a273eccffe7mr11286072ybr.3.1680619916862; Tue, 04
 Apr 2023 07:51:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230404123624.360384-1-daniel.vetter@ffwll.ch>
 <CAMuHMdUR=rx2QPvpzsSCwXTSTsPQOudNMzyL3dtZGQdQfrQGDA@mail.gmail.com>
 <ZCwtMJEAJiId/TJe@phenom.ffwll.local> <ZCwx+2hAmyDqOfWu@phenom.ffwll.local>
In-Reply-To: <ZCwx+2hAmyDqOfWu@phenom.ffwll.local>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 4 Apr 2023 16:51:44 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVt+fsHhk73hPe=bN5e_vTjKEM014Q1AJ9tnankvsXcHg@mail.gmail.com>
Message-ID: <CAMuHMdVt+fsHhk73hPe=bN5e_vTjKEM014Q1AJ9tnankvsXcHg@mail.gmail.com>
Subject: Re: [PATCH] fbdev: Don't spam dmesg on bad userspace ioctl input
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com,
        Helge Deller <deller@gmx.de>, stable@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Melissa Wen <melissa.srw@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CC linux-fbdev

On Tue, Apr 4, 2023 at 4:19 PM Daniel Vetter <daniel@ffwll.ch> wrote:
> On Tue, Apr 04, 2023 at 03:59:12PM +0200, Daniel Vetter wrote:
> > On Tue, Apr 04, 2023 at 03:53:09PM +0200, Geert Uytterhoeven wrote:
> > > On Tue, Apr 4, 2023 at 2:36 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > > > There's a few reasons the kernel should not spam dmesg on bad
> > > > userspace ioctl input:
> > > > - at warning level it results in CI false positives
> > > > - it allows userspace to drown dmesg output, potentially hiding real
> > > >   issues.
> > > >
> > > > None of the other generic EINVAL checks report in the
> > > > FBIOPUT_VSCREENINFO ioctl do this, so it's also inconsistent.
> > > >
> > > > I guess the intent of the patch which introduced this warning was that
> > > > the drivers ->fb_check_var routine should fail in that case. Reality
> > > > is that there's too many fbdev drivers and not enough people
> > > > maintaining them by far, and so over the past few years we've simply
> > > > handled all these validation gaps by tighning the checks in the core,
> > > > because that's realistically really all that will ever happen.
> > > >
> > > > Reported-by: syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com
> > > > Link: https://syzkaller.appspot.com/bug?id=c5faf983bfa4a607de530cd3bb008888bf06cefc
> > >
> > >     WARNING: fbcon: Driver 'vkmsdrmfb' missed to adjust virtual screen
> > > size (0x0 vs. 64x768)
> > >
> > > This is a bug in the vkmsdrmfb driver and/or DRM helpers.
> > >
> > > The message was added to make sure the individual drivers are fixed.
> > > Perhaps it should be changed to BUG() instead, so dmesg output
> > > cannot be drown?
> >
> > So you're solution is to essentially force us to replicate this check over
> > all the drivers which cannot change the virtual size?
> >
> > Are you volunteering to field that audit and type all the patches?
>
> Note that at least efifb, vesafb and offb seem to get this wrong. I didn't
> bother checking any of the non-fw drivers. Iow there is a _lot_ of work in
> your nack.

Please don't spread FUD: efifb, vesafb and offb do not implement
fb_ops.fb_check_var(), so they are not affected.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
