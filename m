Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1FCCA840B
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 15:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbfIDNCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 09:02:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:42884 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbfIDNCA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 09:02:00 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x84D1aT1025468;
        Wed, 4 Sep 2019 08:01:36 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id x84D1ZS7025467;
        Wed, 4 Sep 2019 08:01:35 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Wed, 4 Sep 2019 08:01:35 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "'Nathan Chancellor'" <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] powerpc: Avoid clang warnings around setjmp and longjmp
Message-ID: <20190904130135.GN9749@gate.crashing.org>
References: <20190812023214.107817-1-natechancellor@gmail.com> <878srdv206.fsf@mpe.ellerman.id.au> <20190828175322.GA121833@archlinux-threadripper> <CAKwvOdmXbYrR6n-cxKt3XxkE4Lmj0sSoZBUtHVb0V2LTUFHmug@mail.gmail.com> <20190828184529.GC127646@archlinux-threadripper> <6801a83ed6d54d95b87a41c57ef6e6b0@AcuMS.aculab.com> <20190903055553.GC60296@archlinux-threadripper> <20190903193128.GC9749@gate.crashing.org> <20190904002401.GA70635@archlinux-threadripper> <1bcd7086f3d24dfa82eec03980f30fbc@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bcd7086f3d24dfa82eec03980f30fbc@AcuMS.aculab.com>
User-Agent: Mutt/1.4.2.3i
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 08:16:45AM +0000, David Laight wrote:
> From: Nathan Chancellor [mailto:natechancellor@gmail.com]
> > Fair enough so I guess we are back to just outright disabling the
> > warning.
> 
> Just disabling the warning won't stop the compiler generating code
> that breaks a 'user' implementation of setjmp().

Yeah.  I have a patch (will send in an hour or so) that enables the
"returns_twice" attribute for setjmp (in <asm/setjmp.h>).  In testing
(with GCC trunk) it showed no difference in code generation, but
better save than sorry.

It also sets "noreturn" on longjmp, and that *does* help, it saves a
hundred insns or so (all in xmon, no surprise there).

I don't think this will make LLVM shut up about this though.  And
technically it is right: the C standard does say that in hosted mode
setjmp is a reserved name and you need to include <setjmp.h> to access
it (not <asm/setjmp.h>).

So why is the kernel compiled as hosted?  Does adding -ffreestanding
hurt anything?  Is that actually supported on LLVM, on all relevant
versions of it?  Does it shut up the warning there (if not, that would
be an LLVM bug)?


Segher
