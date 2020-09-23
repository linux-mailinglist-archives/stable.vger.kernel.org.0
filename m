Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CE227609A
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 20:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgIWS5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 14:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbgIWS5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 14:57:51 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA7AC0613CE
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 11:57:51 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id u126so896357oif.13
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 11:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=icR61wv8najvIJn/WSZgKJba4OzzEQXiPErbuwb/qS8=;
        b=DyCI6+hPpN6dphJ1otPEEqJqI/uF8FhWbNzRsIuWHrHXZijve5LbQS8oMtaWPYrXhk
         9GlQ/0SsGMP+mOoKrJ281PRl8iOBt0fyLbVAr0jXBMteDS79GzM1ZnZPvmgRbg1VZngQ
         la0tUNxNU2Ls4YC3idOBoAWKd6I7m2SXZfPVY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=icR61wv8najvIJn/WSZgKJba4OzzEQXiPErbuwb/qS8=;
        b=Fl2nM2CK4Mf7uLaIH6DCMtgHdRj3gBkNur+uIiezs6896s6UAXm3WTL+xYLqorwkV+
         BiY5e8ZEDntGnqQiINc3kQgma2uAYOv6CS7gG8c/ZuME4EVduLlbXmQ6Q/h3DL1BwzeH
         xWA2BI1e3ysgB2dRt07j7FhmgJm1Jlcp+5K4+FLTIdZNer7t8kol0A4gitua9CkOx31V
         pTYQWHfYRhsMg/bkeF1GNUptGp1cCVfE8oegYgaz/oYsjBiYcBikZ1MwpVoLrG0A9fhp
         6A2HT8DGM5sdMlK8kscQHqyCgpOXLn3aDbupic1xBN60fe9N0GfcTdEPuE0bx39otFzZ
         X/3g==
X-Gm-Message-State: AOAM530tJcTIbTJMAJ4nxm0K2desdCUYSRgpGLQa/HSjOpOMJyxWVOpG
        lEps02DSZoTnLNjEoFWSSJtmv+pozT2mevVQR7XcUQ==
X-Google-Smtp-Source: ABdhPJx02yK5DwEW5VWbECGWbbXCa5yslayGzi16db83bHRWul4VKzYaTXD2I6gxffNWjtU2Dowlwy0PrIrCoUc6D6E=
X-Received: by 2002:aca:6083:: with SMTP id u125mr553915oib.14.1600887469415;
 Wed, 23 Sep 2020 11:57:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200915140633.552502750@linuxfoundation.org> <20200915140636.861676717@linuxfoundation.org>
 <20200916075759.GC32537@duo.ucw.cz> <20200916082510.GB509119@kroah.com>
 <20200916090723.GA4151@duo.ucw.cz> <20200916091420.GF13670@1wt.eu>
 <20200923084427.GA32110@amd> <CAHk-=whe4ZdTdCebneWqC4gSQZwsVJ5-Emg0BucOGCwPhOAJpw@mail.gmail.com>
In-Reply-To: <CAHk-=whe4ZdTdCebneWqC4gSQZwsVJ5-Emg0BucOGCwPhOAJpw@mail.gmail.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 23 Sep 2020 20:57:38 +0200
Message-ID: <CAKMK7uEy-b_nPmoh9WYA4NCsK8AL_Jk+-+FRZsrk6NOqqrvriA@mail.gmail.com>
Subject: Re: [PATCH 4.19 66/78] fbcon: remove soft scrollback code
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Machek <pavel@denx.de>, Willy Tarreau <w@1wt.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jikos@suse.cz,
        vojtech@suse.cz,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Yuan Ming <yuanmingbuaa@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 23, 2020 at 8:19 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Sep 23, 2020 at 1:44 AM Pavel Machek <pavel@denx.de> wrote:
> >
> > >
> > >   https://www.openwall.com/lists/oss-security/2020/09/15/2
> >
> > Thank you for the pointer!
>
> Note that for me to be willing to take the softscollback code back, it
> really would have to be more than just a revert and a trivial fix.
>
> It would have to be more along the lines of "this is simplified and
> verified". For example, at a minimum all the VT_RESIZE etc stuff would
> have to clearly and obviously reset the soft-scrollback, so that we
> simply can't have those kinds of issues.
>
> If you look at that commit 50145474f6ef ("fbcon: remove soft
> scrollback code") that removes the code, most of that code really
> doesn't make much sense.
>
> I dare anybody looking at that removed fbcon_redraw_softback()
> function (or the different cases in fbcon_scrolldelta(), for that
> matter) to claim they understand what it is doing. It's very odd code,
> and it handles a lot of odd special cases.
>
> So I wouldn't mind re-introducing the scrollback code, but the
> reintroduced version needs to be simple and fairly _obvious_.  It
> would need to not have all those odd special cases, and it would need
> to clearly not have any subtle issues with things like font or screen
> resizing.
>
> I'd also suggest that it not even try to handle the multiple virtual
> console case.
>
> And yes, some of it may involve also clarifying the code in the VT
> code itself, so that the interactions with the cursor and VT switching
> is more obvious. Maybe instead of trying to deal with a SW cursor when
> scrollback is active, just hide the cursor entirely before doing
> scrollback. And make change_console (and all the resizing) explicitly
> reset scrollback etc.
>
> So the reason the code got removed was that it was just very grotty
> and hasn't really been maintained for over a decade.
>
> In order to resurrect it we'd not just have to have a maintainer, the
> whole "it's grotty and incomprehensible and has these nasty
> interactions with random other things" would need to be addressed too.

fbcon has the additional issue that the locking is completely busted,
because fbcon is both accessed through vt, protected by console_lock,
and through the fbdev chardev, protected by the fb_info lock. Ofc both
sides call into the other side, so atm a few operations are just not
protected by locks to avoid deadlock issues. I ripped out the notifier
in the middle that was angering lockdep completely, so not it's at
least fixable. But this still needs someone to sit down and come up
with something that works.

Locking is one, but in general there's all kinds of resizing fun when
you switch modes through the fbdev chardev. Not looking forward to
when syzbot figures out how to race fbcon/vt against fbdev. It's all a
rather big mess.

Oh and add in hotunplug for additional fun.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
