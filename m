Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5A44AF125
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 20:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfIJSh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 14:37:58 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52497 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbfIJSh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 14:37:58 -0400
Received: by mail-wm1-f66.google.com with SMTP id t17so664593wmi.2;
        Tue, 10 Sep 2019 11:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Jpk6aWfDsr+wjLXvq2B45mZ3x2l5amVRwHa9kiI1c0I=;
        b=EqsljV6R1Oc8io09+E+9JENgvuhVia+vCgepJpEF5LoHg1IvSODazF1pbnc6Ik5mcZ
         CP41BRoQpdz4FscoDCzm9koKcGOLU4p4HFeLGKc+OxIoDj2cJ3N92wKM9FMkvQHwGpRR
         OKvxvWwVvhdbJkwTMzGQ/cdxuYt704h9RfCiPE4cZIy94+HxnN6UJ4BXvjBHJEf2erGF
         iwE9mckoqYvLxQbzURoSbAMjexskGkQw1khtDcqsd8LivkHoIldnU45INf6I7bbJAg7D
         rhUoDmSy4ogXq7I3GgqCKxV4ZxdOpx7dwnaYmk72vLN85GnC0Lw9R3TMz25sD4qkWi4t
         02rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Jpk6aWfDsr+wjLXvq2B45mZ3x2l5amVRwHa9kiI1c0I=;
        b=ACw8h2N210o7c0UdvBu7v17GC0kn0uII1Amyilfi5MG7RF/xneOU4izdJHxPaNjL2j
         fdYXZAyz9Mu0dd0M2bZiNeOfSfRtkftjV6wFHTGjuva5bMPHGWKodn3U2UShBfDX3TsM
         Yg8tGF14R8bLp+UHi/7Mm2qPvdq2OAwtNy/9CjYPDOcCITKS5k2/o6rnhKan8cLm+2xb
         mTqdux0kGuGoxReRzNmdRoggj0/pRV09JEEfiZFqvgEueWMFf3Zr1LFKoCjzd60xloa1
         RzPboaaQmVHSP0fGt/rcnaYrZUGRAKZq67nv/HYhCe9vcK4Tl/TDq9G0bc8pvlzFIk88
         bnRg==
X-Gm-Message-State: APjAAAUTI3T1HafI3hgj47sexDCRijFbGiFfAOEpyDXfTNpp3rV1OgWR
        iex6Wt5zKaOT8Ccq96VpynO+c9k2OZp1Gw==
X-Google-Smtp-Source: APXvYqz0Vt46FkrYxvE8sC2zsou4Fu/K2OM0uY0eeF0c2HkTXA8vITv7APcKVJHnhRDi0P/kPjTb/w==
X-Received: by 2002:a1c:a014:: with SMTP id j20mr165157wme.69.1568140676561;
        Tue, 10 Sep 2019 11:37:56 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id y15sm278829wmj.32.2019.09.10.11.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 11:37:55 -0700 (PDT)
Date:   Tue, 10 Sep 2019 11:37:54 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Segher Boessenkool <segher@kernel.crashing.org>,
        David Laight <David.Laight@aculab.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] powerpc: Avoid clang warnings around setjmp and longjmp
Message-ID: <20190910183754.GA42190@archlinux-threadripper>
References: <CAKwvOdmXbYrR6n-cxKt3XxkE4Lmj0sSoZBUtHVb0V2LTUFHmug@mail.gmail.com>
 <20190828184529.GC127646@archlinux-threadripper>
 <6801a83ed6d54d95b87a41c57ef6e6b0@AcuMS.aculab.com>
 <20190903055553.GC60296@archlinux-threadripper>
 <20190903193128.GC9749@gate.crashing.org>
 <20190904002401.GA70635@archlinux-threadripper>
 <1bcd7086f3d24dfa82eec03980f30fbc@AcuMS.aculab.com>
 <20190904130135.GN9749@gate.crashing.org>
 <20190904231554.GA42450@archlinux-threadripper>
 <87mufcypf5.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mufcypf5.fsf@mpe.ellerman.id.au>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 11, 2019 at 04:30:38AM +1000, Michael Ellerman wrote:
> Nathan Chancellor <natechancellor@gmail.com> writes:
> > On Wed, Sep 04, 2019 at 08:01:35AM -0500, Segher Boessenkool wrote:
> >> On Wed, Sep 04, 2019 at 08:16:45AM +0000, David Laight wrote:
> >> > From: Nathan Chancellor [mailto:natechancellor@gmail.com]
> >> > > Fair enough so I guess we are back to just outright disabling the
> >> > > warning.
> >> > 
> >> > Just disabling the warning won't stop the compiler generating code
> >> > that breaks a 'user' implementation of setjmp().
> >> 
> >> Yeah.  I have a patch (will send in an hour or so) that enables the
> >> "returns_twice" attribute for setjmp (in <asm/setjmp.h>).  In testing
> >> (with GCC trunk) it showed no difference in code generation, but
> >> better save than sorry.
> >> 
> >> It also sets "noreturn" on longjmp, and that *does* help, it saves a
> >> hundred insns or so (all in xmon, no surprise there).
> >> 
> >> I don't think this will make LLVM shut up about this though.  And
> >> technically it is right: the C standard does say that in hosted mode
> >> setjmp is a reserved name and you need to include <setjmp.h> to access
> >> it (not <asm/setjmp.h>).
> >
> > It does not fix the warning, I tested your patch.
> >
> >> So why is the kernel compiled as hosted?  Does adding -ffreestanding
> >> hurt anything?  Is that actually supported on LLVM, on all relevant
> >> versions of it?  Does it shut up the warning there (if not, that would
> >> be an LLVM bug)?
> >
> > It does fix this warning because -ffreestanding implies -fno-builtin,
> > which also solves the warning. LLVM has supported -ffreestanding since
> > at least 3.0.0. There are some parts of the kernel that are compiled
> > with this and it probably should be used in more places but it sounds
> > like there might be some good codegen improvements that are disabled
> > with it:
> >
> > https://lore.kernel.org/lkml/CAHk-=wi-epJZfBHDbKKDZ64us7WkF=LpUfhvYBmZSteO8Q0RAg@mail.gmail.com/
> 
> For xmon.c and crash.c I think using -ffreestanding would be fine.
> They're both crash/debug code, so we don't care about minor optimisation
> differences. If anything we don't want the compiler being too clever
> when generating that code.
> 
> cheers

I will send a v2 later today along with another patch to fix this
warning and another build error.

Cheers,
Nathan
