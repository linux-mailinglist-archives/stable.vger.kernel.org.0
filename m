Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD551315720
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 20:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhBITqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 14:46:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233556AbhBITmZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 14:42:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F6EB64EAA;
        Tue,  9 Feb 2021 19:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612897832;
        bh=iPKdwNyQUQe78NDbY01WUS5126jm07K18bv8SkZfo/E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hfgPQ8OEg0YOC9BEEGOR7nY6VyK+1sOrR/Ik8aLTQWfBBo5kFQ0Eg9fRZZ1xf4i5Y
         sCM9IQBo+/LuHt3DYpGMZUMxQjylcR4QT04CAUCmLOUxaFQ1vvYk/qB9M3Q5CfUDZx
         7gY6hvBxcyZPUByRWHYBVzBxBRVBB1PtJvYTLQlU=
Date:   Tue, 9 Feb 2021 20:10:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Barret Rhoden <brho@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.4 22/38] elfcore: fix building with clang
Message-ID: <YCLeJcQFsDIsrAEc@kroah.com>
References: <20210208145805.279815326@linuxfoundation.org>
 <20210208145806.154119176@linuxfoundation.org>
 <20210209125252.GA23392@duo.ucw.cz>
 <YCKHsf0sTKRcMXCD@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCKHsf0sTKRcMXCD@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 02:01:37PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Feb 09, 2021 at 01:52:52PM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > From: Arnd Bergmann <arnd@arndb.de>
> > > 
> > > commit 6e7b64b9dd6d96537d816ea07ec26b7dedd397b9 upstream.
> > > 
> > > kernel/elfcore.c only contains weak symbols, which triggers a bug with
> > > clang in combination with recordmcount:
> > > 
> > >   Cannot find symbol for section 2: .text.
> > >   kernel/elfcore.o: failed
> > > 
> > > Move the empty stubs into linux/elfcore.h as inline functions.  As only
> > > two architectures use these, just use the architecture specific Kconfig
> > > symbols to key off the declaration.
> > 
> > 4.4 has this:
> > 
> > config BINFMT_ELF32
> >         bool
> >         default y if MIPS32_O32 || MIPS32_N32
> >                 select ELFCORE
> > 
> > in arch/mips. So I believe we'll see problems in that
> > configuration...?
> 
> Hm, did I miss a patch to backport?  This is needed to keep 4.4 building
> with newer versions of gcc.  Well, close to building, I'm still haveing
> local issues with 10.2.0 and the 4.4.y tree right now...

Not a gcc issue, looks like a binutils issue on my side...

And the builders seem to have worked ok.

thanks,

greg k-h
