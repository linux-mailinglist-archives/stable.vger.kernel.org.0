Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D84431A1B4
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 16:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhBLPbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 10:31:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229917AbhBLPbd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 10:31:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2570A64E65;
        Fri, 12 Feb 2021 15:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613143852;
        bh=2GikqJ76Pgc7I30iCl8osvQH0Fze6qbpvM2PmeBOsWk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bGyIaPrlayhiG4sd7omkCau887oZhQK4o2OEsex4fQwRz626PQe2b/p9KTbYjxdgZ
         Hvq36OVPzq5ZykACksRWi7rVJWXGNcD6VTV4rzu9D8x/oqh0zm3fHcIqz6EYf6an62
         VNaHGdywrpcPajZSvT6tGNp4IvcyEuYxggXNrldI=
Date:   Fri, 12 Feb 2021 16:30:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Xi Ruoyao <xry111@mengyan1223.wang>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip: objtool/urgent] objtool: Fix seg fault with Clang
 non-section symbols
Message-ID: <YCafKVSTX9MxDBMd@kroah.com>
References: <ba6b6c0f0dd5acbba66e403955a967d9fdd1726a.1607983452.git.jpoimboe@redhat.com>
 <160812658044.3364.4188208281079332844.tip-bot2@tip-bot2>
 <dded80b60d9136ea90987516c28f93273385651f.camel@mengyan1223.wang>
 <YCU3Vdoqd+EI+zpv@kroah.com>
 <CAKwvOd=GHdkvAU3u6ROSgtGqC_wrkXo8siL1nZHE-qsqSx0gsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=GHdkvAU3u6ROSgtGqC_wrkXo8siL1nZHE-qsqSx0gsw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 10:46:05AM -0800, Nick Desaulniers wrote:
> On Thu, Feb 11, 2021 at 5:55 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Feb 11, 2021 at 09:32:03PM +0800, Xi Ruoyao wrote:
> > > Hi all,
> > >
> > > The latest GNU assembler (binutils-2.36.1) is removing unused section symbols
> > > like Clang [1].  So linux-5.10.15 can't be built with binutils-2.36.1 now.  It
> > > has been reported as https://bugzilla.kernel.org/show_bug.cgi?id=211693.
> 
> Xi,
> Happy Lunar New Year to you, too, and thanks for the report.  Did you
> observe such segfaults for older branches of stable?
> 
> > 2.36 of binutils fails to build the 4.4.y tree right now as well, but as
> > objtool isn't there, I don't know what to do about it :(
> 
> Greg,
> There may be multiple issues in the latest binutils release for the
> kernel; we should still avoid segfaults in host tools so I do
> recommend considering this patch for inclusion at least into 5.10.y.
> Arnd's report in https://github.com/ClangBuiltLinux/linux/issues/1207
> mentions this was found via randconfig testing, so likely some set of
> configs is needed to reproduce reliably.
> 
> Do you have more info about the failure you're observing? Trolling
> lore, I only see:
> https://lore.kernel.org/stable/YCLeJcQFsDIsrAEc@kroah.com/
> (Maybe it was reported on a different list; I only searched stable ML).

I didn't report it anywhere.

Here's the output of doing a 'make allmodconfig' on the latest 4.4.257
release failing with binutils 2.36

Cannot find symbol for section 8: .text.unlikely.
kernel/kexec_file.o: failed
make[1]: *** [scripts/Makefile.build:277: kernel/kexec_file.o] Error 1
make[1]: *** Deleting file 'kernel/kexec_file.o'
make[1]: *** Waiting for unfinished jobs....

4.9.257 works fine, probably because we are using objtool?

Any ideas are appreciated.

thanks,

greg k-h
