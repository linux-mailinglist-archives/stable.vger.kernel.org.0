Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993FE290D53
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 23:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411386AbgJPVfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 17:35:03 -0400
Received: from linux.microsoft.com ([13.77.154.182]:56648 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411382AbgJPVfC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 17:35:02 -0400
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4FBBA20BE4BC;
        Fri, 16 Oct 2020 14:35:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4FBBA20BE4BC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1602884102;
        bh=PP8fzJsZM2/tnu0344Yrxpp1Zf5DPv6rUlSO+jHv0+I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=acrW9VgQAg57vtOho6Eoy5fMGetptStkrZb+O1ZldshPDbydifndM2+5a1+rmiPUR
         nnAS2DwjGLjtwbL6URYfYwsXfBVjFWp9eS9k2kVzUxvVlOX0S2fVMbK8pUIUBUTd01
         IvMnQLvzm5PtUj4EuxKWiQB7r4xyV0/ruAEfT4kU=
Received: by mail-qk1-f175.google.com with SMTP id 140so3115934qko.2;
        Fri, 16 Oct 2020 14:35:02 -0700 (PDT)
X-Gm-Message-State: AOAM5311xNuTXuEKTeuFInhngYgZ0Oa8bEdSynxwEt4ng3U1ESLGu//c
        T00jPDHk33o8R6BzLzbahD3KYh0SDejj0/CKDA0=
X-Google-Smtp-Source: ABdhPJxQFqCgKm5rsFqzQtX6A7BOI5i02qVgsnqLoa7xal+AMdpRql8C839vr07TA/gQ9/xvE6hsP5llKMQM5AO8+AE=
X-Received: by 2002:ae9:e108:: with SMTP id g8mr5887207qkm.220.1602884101304;
 Fri, 16 Oct 2020 14:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <20201016180907.171957-1-mcroce@linux.microsoft.com>
 <20201016180907.171957-3-mcroce@linux.microsoft.com> <202010161226.B136CDC8@keescook>
In-Reply-To: <202010161226.B136CDC8@keescook>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Fri, 16 Oct 2020 23:34:25 +0200
X-Gmail-Original-Message-ID: <CAFnufp30qPaTgWSnoDkAGfwqhS+D7ov56M6g0u8jO0JQ4DPMXg@mail.gmail.com>
Message-ID: <CAFnufp30qPaTgWSnoDkAGfwqhS+D7ov56M6g0u8jO0JQ4DPMXg@mail.gmail.com>
Subject: Re: [PATCH 2/2] reboot: fix parsing of reboot cpu number
To:     Kees Cook <keescook@chromium.org>, Petr Mladek <pmladek@suse.com>
Cc:     linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>, Mike Rapoport <rppt@kernel.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 9:26 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Oct 16, 2020 at 08:09:07PM +0200, Matteo Croce wrote:
> > From: Matteo Croce <mcroce@microsoft.com>
> >
> > The kernel cmdline reboot= argument allows to specify the CPU used
> > for rebooting, with the syntax `s####` among the other flags, e.g.
> >
> >   reboot=soft,s4
> >   reboot=warm,s31,force
> >
> > In the early days the parsing was done with simple_strtoul(), later
> > deprecated in favor of the safer kstrtoint() which handles overflow.
> >
> > But kstrtoint() returns -EINVAL if there are non-digit characters
> > in a string, so if this flag is not the last given, it's silently
> > ignored as well as the subsequent ones.
> >
> > To fix it, revert the usage of simple_strtoul(), which is no longer
> > deprecated, and restore the old behaviour.
>
> It is? Is there a reference, because this was never updated:
> https://www.kernel.org/doc/html/latest/process/deprecated.html#simple-strtol-simple-strtoll-simple-strtoul-simple-strtoull
>
> --
> Kees Cook

Seems so, Petr Mladek replied to the previous patch:

> I suggest to go back to simple_strtoul(). It is not longer obsolete.
> It still exists because it is needed for exactly this purpose,
> see the comment in include/linux/kernel.h

The comment says:

/*
 * Use kstrto<foo> instead.
 *
 * NOTE: simple_strto<foo> does not check for the range overflow and,
 * depending on the input, may give interesting results.
 *
 * Use these functions if and only if you cannot use kstrto<foo>, because
 * the conversion ends on the first non-digit character, which may be far
 * beyond the supported range. It might be useful to parse the strings like
 * 10x50 or 12:21 without altering original string or temporary buffer in use.
 * Keep in mind above caveat.
 */

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/kernel.h?h=v5.9#n452

Cheers,
-- 
per aspera ad upstream
