Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFAB6D69C0
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 19:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbjDDRE4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 4 Apr 2023 13:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbjDDREz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 13:04:55 -0400
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558A149C3
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 10:04:53 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id p204so39521654ybc.12
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 10:04:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680627892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DN8+oIYkNGb8Y5r2uRgiwjJT4v6XcCTZNjemsUmI+JY=;
        b=5AguuxkzWlMfkq8QhRWt8j1ajCQOh11VvqVJ1KyhBs7iMKCyZNqruLIHe5KS0sQTuN
         xSPW/ugdGnH/6sRWYgjSgzJBpEuFzy5DDGfE8UlSy5NOtP2Kujiy4IRnoFRjlhYfBuEC
         9hHTgju1J5YyN0164jM/VpOChA8k9WSK1vIkQPciGymKj7I31nfQpdr7sVgfMW4dr+YY
         dbpcJrqPtyY1gxKC7xza9BSyU2nIQmftTSD++FW/vPsknfmqiEx+tI4oKF7p0pS/t8sN
         fW69RiL0w2dFp25n6Ut8mUrz0UeA+j8yWwLVvzCSTbP8R577owDVJ98H+1yGjryArE0z
         RrCQ==
X-Gm-Message-State: AAQBX9egQRCh/EGG/5VnDvO3nKQi7nmlsTpokRAA7F1bKHrQm1K6j3xi
        XE3fCO0Sh9xs487hZ34jGpKv6th+Kqz0fhyh
X-Google-Smtp-Source: AKy350YGcfaXxPBtRSO8ec64mVy9oO/eFSPlOqoK/EKtvKo6vd3277jt4RlYzl2lI504Psw8suAWIA==
X-Received: by 2002:a25:6d04:0:b0:aac:87e:49f0 with SMTP id i4-20020a256d04000000b00aac087e49f0mr143333ybc.9.1680627892156;
        Tue, 04 Apr 2023 10:04:52 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id g16-20020a256b10000000b00b7767ca7466sm3429870ybc.3.2023.04.04.10.04.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 10:04:51 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id cf7so39551032ybb.5
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 10:04:51 -0700 (PDT)
X-Received: by 2002:a25:ca4b:0:b0:b77:d2db:5f8f with SMTP id
 a72-20020a25ca4b000000b00b77d2db5f8fmr2271273ybg.12.1680627890888; Tue, 04
 Apr 2023 10:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230404123624.360384-1-daniel.vetter@ffwll.ch>
 <CAMuHMdUR=rx2QPvpzsSCwXTSTsPQOudNMzyL3dtZGQdQfrQGDA@mail.gmail.com>
 <ZCwtMJEAJiId/TJe@phenom.ffwll.local> <ZCwx+2hAmyDqOfWu@phenom.ffwll.local>
 <CAMuHMdVt+fsHhk73hPe=bN5e_vTjKEM014Q1AJ9tnankvsXcHg@mail.gmail.com> <CAKMK7uFEmt1=4jDi1xDbnTVH6M2iEZSjcY-UN93do0NiH=GogA@mail.gmail.com>
In-Reply-To: <CAKMK7uFEmt1=4jDi1xDbnTVH6M2iEZSjcY-UN93do0NiH=GogA@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 4 Apr 2023 19:04:39 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUpyxuAZVxZmVCzspbzCBPFdnhbrYOJPMjFnqwtwNCAsw@mail.gmail.com>
Message-ID: <CAMuHMdUpyxuAZVxZmVCzspbzCBPFdnhbrYOJPMjFnqwtwNCAsw@mail.gmail.com>
Subject: Re: [PATCH] fbdev: Don't spam dmesg on bad userspace ioctl input
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
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
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Daniel,

On Tue, Apr 4, 2023 at 5:55 PM Daniel Vetter <daniel@ffwll.ch> wrote:
> On Tue, 4 Apr 2023 at 16:51, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Tue, Apr 4, 2023 at 4:19 PM Daniel Vetter <daniel@ffwll.ch> wrote:
> > > On Tue, Apr 04, 2023 at 03:59:12PM +0200, Daniel Vetter wrote:
> > > > On Tue, Apr 04, 2023 at 03:53:09PM +0200, Geert Uytterhoeven wrote:
> > > > > On Tue, Apr 4, 2023 at 2:36 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > > > > > There's a few reasons the kernel should not spam dmesg on bad
> > > > > > userspace ioctl input:
> > > > > > - at warning level it results in CI false positives
> > > > > > - it allows userspace to drown dmesg output, potentially hiding real
> > > > > >   issues.
> > > > > >
> > > > > > None of the other generic EINVAL checks report in the
> > > > > > FBIOPUT_VSCREENINFO ioctl do this, so it's also inconsistent.
> > > > > >
> > > > > > I guess the intent of the patch which introduced this warning was that
> > > > > > the drivers ->fb_check_var routine should fail in that case. Reality
> > > > > > is that there's too many fbdev drivers and not enough people
> > > > > > maintaining them by far, and so over the past few years we've simply
> > > > > > handled all these validation gaps by tighning the checks in the core,
> > > > > > because that's realistically really all that will ever happen.
> > > > > >
> > > > > > Reported-by: syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com
> > > > > > Link: https://syzkaller.appspot.com/bug?id=c5faf983bfa4a607de530cd3bb008888bf06cefc
> > > > >
> > > > >     WARNING: fbcon: Driver 'vkmsdrmfb' missed to adjust virtual screen
> > > > > size (0x0 vs. 64x768)
> > > > >
> > > > > This is a bug in the vkmsdrmfb driver and/or DRM helpers.
> > > > >
> > > > > The message was added to make sure the individual drivers are fixed.
> > > > > Perhaps it should be changed to BUG() instead, so dmesg output
> > > > > cannot be drown?
> > > >
> > > > So you're solution is to essentially force us to replicate this check over
> > > > all the drivers which cannot change the virtual size?
> > > >
> > > > Are you volunteering to field that audit and type all the patches?
> > >
> > > Note that at least efifb, vesafb and offb seem to get this wrong. I didn't
> > > bother checking any of the non-fw drivers. Iow there is a _lot_ of work in
> > > your nack.
> >
> > Please don't spread FUD: efifb, vesafb and offb do not implement
> > fb_ops.fb_check_var(), so they are not affected.
>
> Hm I missed that early out. I'll do a patch to fix the drm fb helpers,
> as mentioned in the other thread I don't think we can actually just
> delete that because it would short-circuit out the fb_set_par call
> too.

As I said to the other thread earlier today[1], I think we can keep
the .fb_set_par() implementation.
There's just no point in providing a .fb_check_var() callback if
you don't support changing the video mode.

[1] https://lore.kernel.org/all/CAMuHMdUaHd1jgrsCSxCqF-HP2rAo2ODM_ZOjhk7Q4vjuqvt36w@mail.gmail.com
Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
