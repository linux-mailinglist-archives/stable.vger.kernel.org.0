Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3576EA96F7
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 01:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbfIDXP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 19:15:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36606 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfIDXP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 19:15:59 -0400
Received: by mail-wm1-f67.google.com with SMTP id p13so585250wmh.1;
        Wed, 04 Sep 2019 16:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=D+jh77ZLgNensDYPn2dN2wL4k27PJ6BpfuVV6pgmL7g=;
        b=E0hH/5KZPUbuapqt3Z57/i+myQE/X/8+9T1h7ZwzooTZFrauoJKpwhyX2YG21HRAly
         5ZPac6JEX2A0gPXuwBVMuX4LbTwVUws7ZdBidSR5KDozTQXQYfMwl88kRfMHS/OkTMq0
         cotN8RM2UrUFC8JZpSkMJm6h4cCwj8lL0cZJF7Z+6vyPR9I2a5lHJ8ltH8gTtqM/a9qk
         fUR4h3x3Nk03WFcUmF633tW7lJGnGNZx8EoMnrK/hphQ6mCIaQd/sURbEX/UdRfl47L8
         6WAGON3hJk4HT+fv5HhYXo3BC/w9GTdUPEBETmCLkHQclpPvFkxikQQVE0EQk8MW3m4V
         U6Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=D+jh77ZLgNensDYPn2dN2wL4k27PJ6BpfuVV6pgmL7g=;
        b=cWLBMsup3Tw5HLl2eyHuNFDrGSqYAbtPki5RyIs+IrRwKP5hRmNdXCxeYiSykuWoNm
         Aan/YWRB/lrnvxM3YkB2L2l1YJGir88g41xhTgRY512p7p6Iel2c78shbFrnDVkLflqd
         gnpRmH/fB3fA3NrqujvCd94k5jeQazK+UY07+uqwiBCaPNM9dlg37ak35iD8v2wKh0cS
         LxXF2Sx+oITUuNStWHbJAcGK/eEpb48lUU491K5YWA0T33u5qysP0jXwwrMBBoiKNY4A
         zBmfNFzlkAyh2VhnXvbyS2xj2krzBU51OCMGMvU8LG9N1i1760ShHexiyVl3S5TYoiYi
         2TCw==
X-Gm-Message-State: APjAAAWIm1vfPwgybhYhkLI4g6tQ+eTy+JX4nTZPBJmA4CMCHML+4Fz0
        O6+NOvvwnZ8sqSfvq7jAH6E=
X-Google-Smtp-Source: APXvYqznil+fqfMulqs43QZJNRB7vW35OcADELC0oZ/vgbpO2vg2C3b20RkPKZ41YzhNwbmyWSb20A==
X-Received: by 2002:a7b:c766:: with SMTP id x6mr514054wmk.51.1567638957553;
        Wed, 04 Sep 2019 16:15:57 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id z189sm788009wmc.25.2019.09.04.16.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 16:15:56 -0700 (PDT)
Date:   Wed, 4 Sep 2019 16:15:54 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     David Laight <David.Laight@aculab.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] powerpc: Avoid clang warnings around setjmp and longjmp
Message-ID: <20190904231554.GA42450@archlinux-threadripper>
References: <878srdv206.fsf@mpe.ellerman.id.au>
 <20190828175322.GA121833@archlinux-threadripper>
 <CAKwvOdmXbYrR6n-cxKt3XxkE4Lmj0sSoZBUtHVb0V2LTUFHmug@mail.gmail.com>
 <20190828184529.GC127646@archlinux-threadripper>
 <6801a83ed6d54d95b87a41c57ef6e6b0@AcuMS.aculab.com>
 <20190903055553.GC60296@archlinux-threadripper>
 <20190903193128.GC9749@gate.crashing.org>
 <20190904002401.GA70635@archlinux-threadripper>
 <1bcd7086f3d24dfa82eec03980f30fbc@AcuMS.aculab.com>
 <20190904130135.GN9749@gate.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904130135.GN9749@gate.crashing.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 08:01:35AM -0500, Segher Boessenkool wrote:
> On Wed, Sep 04, 2019 at 08:16:45AM +0000, David Laight wrote:
> > From: Nathan Chancellor [mailto:natechancellor@gmail.com]
> > > Fair enough so I guess we are back to just outright disabling the
> > > warning.
> > 
> > Just disabling the warning won't stop the compiler generating code
> > that breaks a 'user' implementation of setjmp().
> 
> Yeah.  I have a patch (will send in an hour or so) that enables the
> "returns_twice" attribute for setjmp (in <asm/setjmp.h>).  In testing
> (with GCC trunk) it showed no difference in code generation, but
> better save than sorry.
> 
> It also sets "noreturn" on longjmp, and that *does* help, it saves a
> hundred insns or so (all in xmon, no surprise there).
> 
> I don't think this will make LLVM shut up about this though.  And
> technically it is right: the C standard does say that in hosted mode
> setjmp is a reserved name and you need to include <setjmp.h> to access
> it (not <asm/setjmp.h>).

It does not fix the warning, I tested your patch.

> So why is the kernel compiled as hosted?  Does adding -ffreestanding
> hurt anything?  Is that actually supported on LLVM, on all relevant
> versions of it?  Does it shut up the warning there (if not, that would
> be an LLVM bug)?

It does fix this warning because -ffreestanding implies -fno-builtin,
which also solves the warning. LLVM has supported -ffreestanding since
at least 3.0.0. There are some parts of the kernel that are compiled
with this and it probably should be used in more places but it sounds
like there might be some good codegen improvements that are disabled
with it:

https://lore.kernel.org/lkml/CAHk-=wi-epJZfBHDbKKDZ64us7WkF=LpUfhvYBmZSteO8Q0RAg@mail.gmail.com/

Cheers,
Nathan
