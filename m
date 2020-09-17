Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF36926E0C6
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 18:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgIQQcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 12:32:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728419AbgIQQcs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 12:32:48 -0400
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2205F22244
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 16:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600360365;
        bh=UDnf3IREiyw2euRvGQM7rzF6Y4TR+WX+NcIvD+ugudE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NYYGO1W9mAXkZuhUVO6Y6L2ioaTm69njsOiz956DuPatVMLXjEOMakpQLAC8TnpKc
         4iYeVyukASZSm+hf20tK0OnRNG5sSjC1TliYP1FruK+0+W0Ntpo+yxeHz+kFA3eG//
         ZcQsULVdSf1k0luzdvprTwHETbWvZAEeXhMFslOE=
Received: by mail-wr1-f41.google.com with SMTP id w5so2752072wrp.8
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 09:32:45 -0700 (PDT)
X-Gm-Message-State: AOAM530f6krgsqsDjAx30ZQeTcQjMcOgoJ8TJu7Jh1lYGAo6WictVP3A
        5usGovH8/Rob0dNWNgnKxwrxmye2FZTkq/aewf3GSA==
X-Google-Smtp-Source: ABdhPJzQHsv5KOOJ8HO3NJ8qYnGzHb8S1Gxpn/9DUWUzZVpO9MblLZxfCuqdaXBDWVT+IasvV7RYQjIKMu6Li9tO5bs=
X-Received: by 2002:a5d:5111:: with SMTP id s17mr32904987wrt.70.1600360363524;
 Thu, 17 Sep 2020 09:32:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOdnjHbyamsW71FJ=Cd36YfVppp55ftcE_eSDO_z+KE9zeQ@mail.gmail.com>
 <441AA771-A859-4145-9425-E9D041580FE4@amacapital.net> <7233f4cf-5b1d-0fca-0880-f1cf2e6e765b@citrix.com>
 <20200916082621.GB2643@zn.tnic> <be498e49-b467-e04c-d833-372f7d83cb1f@citrix.com>
 <20200917060432.GA31960@zn.tnic> <ec617df229514fbaa9897683ac88dfda@AcuMS.aculab.com>
 <20200917115733.GH31960@zn.tnic> <823af5fadd464c48ade635498d07ba4e@AcuMS.aculab.com>
 <20200917143920.GJ31960@zn.tnic>
In-Reply-To: <20200917143920.GJ31960@zn.tnic>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 17 Sep 2020 09:32:32 -0700
X-Gmail-Original-Message-ID: <CALCETrXuV1rucx7=+nx339G43K_8pigfFU5cT-emqpJG4TwjoA@mail.gmail.com>
Message-ID: <CALCETrXuV1rucx7=+nx339G43K_8pigfFU5cT-emqpJG4TwjoA@mail.gmail.com>
Subject: Re: [PATCH] x86/smap: Fix the smap_save() asm
To:     Borislav Petkov <bp@alien8.de>
Cc:     David Laight <David.Laight@aculab.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Bill Wendling <morbo@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Thelen <gthelen@google.com>,
        John Sperbeck <jsperbeck@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 7:39 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Sep 17, 2020 at 02:25:50PM +0000, David Laight wrote:
> > I actually wonder if there is any code that really benefits from
> > the red-zone.
>
> The kernel has been without a red zone since 2002 at least:
>
>   commit 47f16da277d10ef9494f3e9da2a9113bb22bcd75
>   Author: Andi Kleen <ak@muc.de>
>   Date:   Tue Feb 12 20:17:35 2002 -0800
>
>       [PATCH] x86_64 merge: arch + asm
>
>       This adds the x86_64 arch and asm directories and a Documentation/x86_64.
>
>   ...
>   +CFLAGS += $(shell if $(CC) -mno-red-zone -S -o /dev/null -xc /dev/null >/dev/null 2>&1; then echo "-mno-red-zone"; fi )
>
>
> Also, from the ABI doc:
>
> "A.2.2 Stack Layout
>
> The Linux kernel may align the end of the input argument area to a
> 8, instead of 16, byte boundary. It does not honor the red zone (see
> section 3.2.2) and therefore this area is not allowed to be used by
> kernel code. Kernel code should be compiled by GCC with the option
> -mno-red-zone."
>
> so forget the red zone.
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

Regardless of anything that any docs may or may not say, the kernel
*can't* use a redzone -- an interrupt would overwrite it.
