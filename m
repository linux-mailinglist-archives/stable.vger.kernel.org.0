Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0E433C660
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 20:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbhCOTHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 15:07:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231395AbhCOTGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 15:06:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F66864F3F;
        Mon, 15 Mar 2021 19:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615835194;
        bh=F18ElFOXSGX1ry2CfQ8bzhp1q+Cb4FNL1mMC+C3wq1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2mtkBkYcTO2vDjRyNk87ovL8BYKAuRkOPOQfKCc7xs7+SAx4QI2IGXQuO6r/FLZ8e
         RVR6oLpEBLWA6IjJNygxxRcLntsiUEagCg/H56LMnhqszN5xbEJnom4o9hK5YXfjUd
         3BUX1FNc5OYyHECbkF+S6YRO4LPcqz8gY7BxXEgo=
Date:   Mon, 15 Mar 2021 20:06:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>, Stefan Agner <stefan@agner.ch>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>, candle.sun@unisoc.com,
        Miles Chen =?utf-8?B?KOmZs+awkeaouik=?= 
        <miles.chen@mediatek.com>, Stephen Hines <srhines@google.com>,
        Luis Lozano <llozano@google.com>,
        Sandeep Patil <sspatil@google.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: ARCH=arm LLVM_IAS=1 patches for 5.10, 5.4, and 4.19
Message-ID: <YE+wNS1iiVTU8YGb@kroah.com>
References: <CAKwvOdka=y54W=ssgCZRgr2B+NaYFHF07KnnNDfrwv79-geSQw@mail.gmail.com>
 <YEs+iaQzEQYNgXcw@kroah.com>
 <CAKwvOd=xr5je726djQeMMrZAuNcJpX9=R-X19epVy85cjbNbqw@mail.gmail.com>
 <YEw6i39k6hqZJS8+@sashalap>
 <YE8kIbyWKSojC1SV@kroah.com>
 <YE8k/2WTPFGwMpHk@kroah.com>
 <YE8l2qhycaGPYdNn@kroah.com>
 <CAMj1kXGLrVXZPAoxTtMueB9toeoktuKza-mRpd4vZ0SLN6bSSQ@mail.gmail.com>
 <CAKwvOdmJm3v3sHfopWXrSPFn46qaSX9cna=Nd+FZiN=Nz9zmQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmJm3v3sHfopWXrSPFn46qaSX9cna=Nd+FZiN=Nz9zmQQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 10:43:26AM -0700, Nick Desaulniers wrote:
> On Mon, Mar 15, 2021 at 3:37 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > Note that the 5.4 Thumb2 build is still broken today because
> > it carries
> >
> > eff8728fe698 vmlinux.lds.h: Add PGO and AutoFDO input sections
> >
> > but does not carry
> >
> > f77ac2e378be ARM: 9030/1: entry: omit FP emulation for UND exceptions
> > taken in kernel mode
> >
> > which is tagged as a fix for the former patch, and landed in v5.11.
> > (Side question: anyone have a clue why the patch in question was never
> > selected for backporting?)
> 
> I will follow up on the rest, but some quick forensics.
> 
> f77ac2e378be ("ARM: 9030/1: entry: omit FP emulation for UND
> exceptions taken in kernel mode")
> 
> was selected for inclusion into 5.10.y on 2020-12-20:
> https://lore.kernel.org/stable/20201228125038.405690346@linuxfoundation.org/
> 
> I actually don't have a
> Subject: FAILED: patch "[PATCH] <oneline>" failed to apply to X.YY-stable tree
> email for this, which seems unusual. I don't know if one wasn't sent,
> or message engine had a hiccup or what, so I don't know if it simply
> failed to apply to older trees.  Ard, did you as the author receive
> such an email?  Usually everyone cc'ed on the patch gets such emails
> from autosel, it looks like.

autosel does not send out "FAILED" emails.  I only send them out for
when a patch is cc: stable and is said to fix a older commit and the
patch does not apply properly.

> Then *later*
> eff8728fe698 ("vmlinux.lds.h: Add PGO and AutoFDO input sections")
> was sent to stable on 2021-01-13:
> https://lore.kernel.org/stable/20210113185758.GA571703@ubuntu-m3-large-x86/
> 
> I was cc'ed on both, and didn't notice or forgot that one had
> additional fixes necessary.  My mistake.
> 
> I think one way to avoid that in the future in a semi automated
> fashion would be to have an in tree script like checkpatch that given
> a sha from mainline would check git log for any Fixes tag that may
> exist on subsequent patches.

I have a script like that, as does Guenter and Sasha.  It's very
computationaly expensive so I doubt we can reduce it down into something
for scripts/ as it's only really needed for those of us maintaining
stable kernels.  It's not for a normal developer.

> Then it should be possible for any patch
> that itself is backported (contains "commit XXX upstream") to be fed
> in when auto selected or submitted to stable (or before then) to check
> for new fixes.  Probably would still need to be run periodically, as
> Fixes: aren't necessarily available when AutoSel runs.  For the
> toolchain, we have a bot that watches for reverts for example, but
> non-standard commit messages denoting one patch fixes another makes
> this far from perfect.  Would still need to be run periodically,
> because if a Fixes: exists, but hasn't been merged yet, it could get
> missed.

I do re-run my script at times, it does require it to be run every once
in a while.  But again, who is going to care about this except me and
Sasha?

> Though I'm curious how the machinery that picks up Fixes: tags works.
> Does it run on a time based cadence?  Is it only run as part of
> AutoSel, but not for manual backports sent to the list?  Would it have
> picked up on f77ac2e378be at some point?

Maybe it will, mine might have picked it up, who knows, I haven't run it
in a while.  But as you say, because it fails to apply, that's a good
reason for me to not backport it.

Anyway, I'm with Arnd here, I don't see the need for these as it's not
fixing a regression and it's not a "simple" set of changes at all for no
real users.

I do backport changes for newer versions of gcc for older stable kernels
in order for my build systems to stay alive, but I never test with clang
so I don't care about those systems :)

thanks,

greg k-h
