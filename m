Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D407A2FCC74
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 09:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbhATILW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 03:11:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:53466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730330AbhATIJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 03:09:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AC3423158;
        Wed, 20 Jan 2021 08:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611130150;
        bh=/HfBzBSANlICHrP1a1WpTnfk5fzRQn9cCG7zDTD+eW4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=krNfbDUiux3nXeyPVn7hWFleQ1PHX6PyV3LMaa26LG7zKROGj+0yQ6CPOHERxpHhw
         jMM+RDQIJ8naiklv/9gbGTNyHbR1yaWxAUQDJn//YK4fpjbVQW7WLdJiSnydH9GphX
         KZJ6uoBHI1suLLjQ8kKqXRdEutvPhR1QUDBLEsJ+zK/Xx3PG1OLPrs2X5OiL14Of18
         6OwW6kSsnKNVg47ftLC0sKTIB5FwT31gkn/o5jze7bbXwkySSaVNwfnZ4mHu11pnWV
         EhE9K2aeWF1P+zuTJ+RxjooNuSReyFh2a8vg7JnD8fldNGOMWKUSKj2W6+AUDI8KEr
         7wL8gvV+U67yQ==
Received: by mail-ot1-f49.google.com with SMTP id i30so9682145ota.6;
        Wed, 20 Jan 2021 00:09:10 -0800 (PST)
X-Gm-Message-State: AOAM532hrcxL89tJwghTl5+hqhlUJpHvg339jmseA/Aw83JifjnrYhul
        VlVpJAbA9LBdJ76CtGFeqRl6wTdyWwEwEVktRg0=
X-Google-Smtp-Source: ABdhPJy263plUMjcPMTIVN3pL3Jkd6CPPS2dJO1OqpkFOp14dJ54PQ5qw8rErGyq4JKShXK4lfkGA6JHY5Swjy6e/k0=
X-Received: by 2002:a05:6830:139a:: with SMTP id d26mr6249681otq.305.1611130149279;
 Wed, 20 Jan 2021 00:09:09 -0800 (PST)
MIME-Version: 1.0
References: <20210118135426.17372-1-will@kernel.org> <CAKwvOdmShphZV96PjaHbUW17mKhhRi_X0AZotryKmiGVKyiQyw@mail.gmail.com>
 <20210119232952.GA2650682@ubuntu-m3-large-x86>
In-Reply-To: <20210119232952.GA2650682@ubuntu-m3-large-x86>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 20 Jan 2021 09:08:52 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2+VC4oNU_DjLrBnB8YhWtU5vee5aGfNgtOrNw=-smWWw@mail.gmail.com>
Message-ID: <CAK8P3a2+VC4oNU_DjLrBnB8YhWtU5vee5aGfNgtOrNw=-smWWw@mail.gmail.com>
Subject: Re: [STABLE BACKPORT 4.4.y, 4.9.y and 4.14.y] compiler.h: Raise
 minimum version of GCC to 5.1 for arm64
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Will Deacon <will@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Florian Weimer <fweimer@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Caroline Tice <cmtice@google.com>,
        Luis Lozano <llozano@google.com>,
        Stephen Hines <srhines@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 20, 2021 at 12:29 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
> On Tue, Jan 19, 2021 at 02:15:43PM -0800, Nick Desaulniers wrote:
> >
> > Merging this from stable into "Android Common Kernel" trees that were
> > built with AOSP GCC 4.9, I expect this to break some builds.  Arnd,
> > IIRC did you mention that AOSP GCC had picked up a fix?  If so, did
> > you verify that via disassembly, or gerrit patch file?

The only information I had was the fact that the gcc bug tracker
mentioned it being picked up into the Android gcc and gcc-linaro.
I verified that it was present in gcc-linaro, but did not also check
the Android sources.

> If so, it looks like that patch was picked up in this commit.
>
> https://android.googlesource.com/toolchain/gcc/+/5ae0308a147ec3f6502fd321860524e634a647a6

Right.

          Arnd
