Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8280244CDCB
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 00:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhKJX2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 18:28:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234191AbhKJX2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 18:28:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1CCB6112E;
        Wed, 10 Nov 2021 23:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636586747;
        bh=w5E48ojVJEf9pLnUJB3vpyZm4JjYM02yvXnZ070vT1U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=s0maOYW9m0CwiD3Vvmc4J+Ys368QVEkECaoGuXhcfvlMniFHdVtg2J3CKbYbXPc+m
         /aGotfx+SY/l4F6hwN7EqcqeoAnl4Y/00bmGeypUx1v04HNalUahENxsQ8XEVd0MYc
         +zSv4Tgsr4owu1RKh+GTwOwzR9tqKB8F91uQuz5SC0gON6uG1WeP2Y8I3b22gMtxZY
         S3pxq92Bi4JKGU7ZCdqO95qU8gAPOh/di8/ui73MfhQrgmA2y60UUkwHjfp3J/eXi8
         i2l8DVMdnH/wBXNinuL6gyuLuIT9ftJyjKb8BO4EoD3qRMROCy4fNMZzZl1y0SoVhU
         SmpSYO3v4iX7w==
Received: by mail-ot1-f54.google.com with SMTP id g91-20020a9d12e4000000b0055ae68cfc3dso6278622otg.9;
        Wed, 10 Nov 2021 15:25:47 -0800 (PST)
X-Gm-Message-State: AOAM533SPUIrmF7LGNFYOT8uaXKKNWWTnRsImm3qX+bxCE0bZQ3sUxfh
        0PQ8CsoB5XGSgSDAB9N5vHp10UinIcGc8L2b06w=
X-Google-Smtp-Source: ABdhPJxqHkTXeHhqwAm7NMJDHQQm5a+fqWJbtR4CwSdRrgysO6oYvId3c/L3y0SjVJEl4S81SAZ/Q+wLq41jA+pFeDE=
X-Received: by 2002:a05:6830:1514:: with SMTP id k20mr2280823otp.147.1636586747125;
 Wed, 10 Nov 2021 15:25:47 -0800 (PST)
MIME-Version: 1.0
References: <20211110200253.rfudkt3edbd3nsyj@lahvuun> <CAMj1kXHuU8dFBUeM41bHu13nd2qQVPJizt8Epw596K89_samiQ@mail.gmail.com>
 <20211110232157.xfeue3sbquyhtqmf@lahvuun>
In-Reply-To: <20211110232157.xfeue3sbquyhtqmf@lahvuun>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 11 Nov 2021 00:25:35 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEY=Jp_mtLFGG2_7r97zZcan2bXpotfRdNeuLOsraoPWg@mail.gmail.com>
Message-ID: <CAMj1kXEY=Jp_mtLFGG2_7r97zZcan2bXpotfRdNeuLOsraoPWg@mail.gmail.com>
Subject: Re: [REGRESSION]: drivers/firmware: move x86 Generic System
 Framebuffers support
To:     Ilya Trukhanov <lahvuun@gmail.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>, regressions@lists.linux.dev,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <len.brown@intel.com>, pavel@ucw.cz
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 11 Nov 2021 at 00:22, Ilya Trukhanov <lahvuun@gmail.com> wrote:
>
> On Wed, Nov 10, 2021 at 11:24:03PM +0100, Ard Biesheuvel wrote:
> > Hi Ilya,
> >
> > On Wed, 10 Nov 2021 at 21:02, Ilya Trukhanov <lahvuun@gmail.com> wrote:
> > >
> > > Suspend-to-RAM with elogind under Wayland stopped working in 5.15.
> > >
> > > This occurs with 5.15, 5.15.1 and latest master at
> > > 89d714ab6043bca7356b5c823f5335f5dce1f930. 5.14 and earlier releases work
> > > fine.
> > >
> > > git bisect gives d391c58271072d0b0fad93c82018d495b2633448.
> > >
> > > To reproduce:
> > > - Use elogind and Linux 5.15.1 with CONFIG_SYSFB_SIMPLEFB=n.
> > > - Start a Wayland session. I tested sway and weston, neither worked.
> > > - In a terminal emulator (I used alacritty) execute `loginctl suspend`.
> > >
> > > Normally after the last step the system would suspend, but it no longer
> > > does so after I upgraded to Linux 5.15. After running `loginctl suspend`
> > > in dmesg I get the following:
> > > [  103.098782] elogind-daemon[2357]: Suspending system...
> > > [  103.098794] PM: suspend entry (deep)
> > > [  103.124621] Filesystems sync: 0.025 seconds
> > >
> > > But nothing happens afterwards.
> > >
> > > Suspend works as expected if I do any of the following:
> > > - Revert d391c58271072d0b0fad93c82018d495b2633448.
> > > - Build with CONFIG_SYSFB_SIMPLEFB=y.
> >
> > If this solves the issue, what else is there to discuss?
> Sorry, I'm not a kernel developer, but I was under the impression
> that this is a regression and should at least be brought to attention.
>
> I also think I'm probably not the last person to encounter this. I'm
> fortunate because I had the time to bisect and get the idea to try
> enabling that option, but others may not know how to fix it.
>
> The suspend not working is also not the only effect. After you execute
> `loginctl suspend`, for example, the compositor just hangs if you try to
> exit. Should you kill it with SysRq+I, the system suspends but after
> resume doesn't respond to anything and has to be hard reset. I think
> this is a pretty serious issue, even if it won't affect most users.
>
> Sorry if I wasn't meant to CC you. The issue reporting guide says that
> you should CC maintainers of affected subsystems.

No worries. You cc'ed the right people, and we appreciate the time you
have spent to track down the root cause.

So can you explain why the solution to this issue is not simply
'enable CONFIG_SYSFB_SIMPLEFB' ?
