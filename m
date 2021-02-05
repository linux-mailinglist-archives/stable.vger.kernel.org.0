Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FC1310804
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 10:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhBEJgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 04:36:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230192AbhBEJeB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 04:34:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D735564F87;
        Fri,  5 Feb 2021 09:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612517600;
        bh=sEJ206tK8tfWovLmF9zh6XZG7atL05JuXezYQtriNBw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UPzAb0GvJ+zfqZaRj+jnoizNb7fyyDlHpsNPEyn87lqK9Yzg56Qdt8ERu14vUT4xt
         71e2cstB2jH2l5z7jdgZShNvmjIsjb46wxu6uNXubOd+/AyaOHJzZ756dTJer3vymL
         2/Czw/RFBS5uzL/govTHnuUBrsxKVgVN1mggYBl4=
Date:   Fri, 5 Feb 2021 10:33:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Jari Ruusu <jariruusu@protonmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        masahiroy@kernel.org
Subject: Re: Kernel version numbers after 4.9.255 and 4.4.255
Message-ID: <YB0Q3UUzTUmgvH7V@kroah.com>
References: <7pR0YCctzN9phpuEChlL7_SS6auHOM80bZBcGBTZPuMkc6XjKw7HUXf9vZUPi-IaV2gTtsRVXgywQbja8xpzjGRDGWJsVYSGQN5sNuX1yaQ=@protonmail.com>
 <YBuSJqIG+AeqDuMl@kroah.com>
 <78ada91b-21ee-563f-9f75-3cbaeffafad4@kernel.org>
 <YBu1d0+nfbWGfMtj@kroah.com>
 <20210205090659.GA22517@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205090659.GA22517@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 10:06:59AM +0100, Pavel Machek wrote:
> On Thu 2021-02-04 09:51:03, Greg Kroah-Hartman wrote:
> > On Thu, Feb 04, 2021 at 08:26:04AM +0100, Jiri Slaby wrote:
> > > On 04. 02. 21, 7:20, Greg Kroah-Hartman wrote:
> > > > On Thu, Feb 04, 2021 at 05:59:42AM +0000, Jari Ruusu wrote:
> > > > > Greg,
> > > > > I hope that your linux kernel release scripts are
> > > > > implemented in a way that understands that PATCHLEVEL= and
> > > > > SUBLEVEL= numbers in top-level linux Makefile are encoded
> > > > > as 8-bit numbers for LINUX_VERSION_CODE and
> > > > > KERNEL_VERSION() macros, and must stay in range 0...255.
> > > > > These 8-bit limits are hardcoded in both kernel source and
> > > > > userspace ABI.
> > > > > 
> > > > > After 4.9.255 and 4.4.255, your scripts should be
> > > > > incrementing a number in EXTRAVERSION= in top-level
> > > > > linux Makefile.
> > > > 
> > > > Should already be fixed in linux-next, right?
> > > 
> > > I assume you mean:
> > > commit 537896fabed11f8d9788886d1aacdb977213c7b3
> > > Author: Sasha Levin <sashal@kernel.org>
> > > Date:   Mon Jan 18 14:54:53 2021 -0500
> > > 
> > >     kbuild: give the SUBLEVEL more room in KERNEL_VERSION
> > > 
> > > That would IMO break userspace as definition of kernel version has changed.
> > > And that one is UAPI/ABI (see include/generated/uapi/linux/version.h) as
> > > Jari writes. For example will glibc still work:
> > > http://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/unix/sysv/linux/configure.ac;h=13abda0a51484c5951ffc6d718aa36b72f3a9429;hb=HEAD#l14
> > > 
> > > ? Or gcc 10 (11 will have this differently):
> > > https://gcc.gnu.org/git/?p=gcc.git;a=blob;f=gcc/config/bpf/bpf.c;hb=ee5c3db6c5b2c3332912fb4c9cfa2864569ebd9a#l165
> > > 
> > > and
> > > 
> > > https://gcc.gnu.org/git/?p=gcc.git;a=blob;f=gcc/config/bpf/bpf-helpers.h;hb=ee5c3db6c5b2c3332912fb4c9cfa2864569ebd9a#l53
> > 
> > Ugh, I thought this was an internal representation, not an external one
> > :(
> > 
> > > It might work somewhere, but there are a lot of (X * 65536 + Y * 256 + Z)
> > > assumptions all around the world. So this doesn't look like a good idea.
> > 
> > Ok, so what happens if we "wrap"?  What will break with that?  At first
> > glance, I can't see anything as we keep the padding the same, and our
> > build scripts seem to pick the number up from the Makefile and treat it
> > like a string.
> > 
> > It's only the crazy out-of-tree kernel stuff that wants to do minor
> > version checks that might go boom.  And frankly, I'm not all that
> > concerned if they have problems :)
> > 
> > So, let's leave it alone and just see what happens!
> 
> Yeah, stable is a great place to do the experiments. Not that this is
> the first time :-(.

How else can we "test this out"?

Should I do an "empty" release of 4.4.256 and see if anyone complains?

Any other ideas are gladly welcome...

thanks,

greg k-h
