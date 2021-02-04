Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1105430EF11
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 09:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbhBDIvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 03:51:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234966AbhBDIvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 03:51:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3424D64F4D;
        Thu,  4 Feb 2021 08:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612428666;
        bh=7uCkM47OIUuWPJjtJG/o3Oocyx2ATU2RpCB1ZqlaX4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0TgoXiujRPg2i+I4COX+3BRNrCQytaX536kxCwDEYwC3iA3adXL0ts9Q/dqfUfIa8
         gECBaG9uJNwmeHGrwUCpKsk70QL1H/SXfErR8fk+V0/sZzmBJBEOIMIwFlB8CljSLK
         0Vh5qEYiCXyhhTq9iePZp4/xrPSaGu5bbg9iwQwc=
Date:   Thu, 4 Feb 2021 09:51:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Jari Ruusu <jariruusu@protonmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        masahiroy@kernel.org
Subject: Re: Kernel version numbers after 4.9.255 and 4.4.255
Message-ID: <YBu1d0+nfbWGfMtj@kroah.com>
References: <7pR0YCctzN9phpuEChlL7_SS6auHOM80bZBcGBTZPuMkc6XjKw7HUXf9vZUPi-IaV2gTtsRVXgywQbja8xpzjGRDGWJsVYSGQN5sNuX1yaQ=@protonmail.com>
 <YBuSJqIG+AeqDuMl@kroah.com>
 <78ada91b-21ee-563f-9f75-3cbaeffafad4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78ada91b-21ee-563f-9f75-3cbaeffafad4@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 04, 2021 at 08:26:04AM +0100, Jiri Slaby wrote:
> On 04. 02. 21, 7:20, Greg Kroah-Hartman wrote:
> > On Thu, Feb 04, 2021 at 05:59:42AM +0000, Jari Ruusu wrote:
> > > Greg,
> > > I hope that your linux kernel release scripts are
> > > implemented in a way that understands that PATCHLEVEL= and
> > > SUBLEVEL= numbers in top-level linux Makefile are encoded
> > > as 8-bit numbers for LINUX_VERSION_CODE and
> > > KERNEL_VERSION() macros, and must stay in range 0...255.
> > > These 8-bit limits are hardcoded in both kernel source and
> > > userspace ABI.
> > > 
> > > After 4.9.255 and 4.4.255, your scripts should be
> > > incrementing a number in EXTRAVERSION= in top-level
> > > linux Makefile.
> > 
> > Should already be fixed in linux-next, right?
> 
> I assume you mean:
> commit 537896fabed11f8d9788886d1aacdb977213c7b3
> Author: Sasha Levin <sashal@kernel.org>
> Date:   Mon Jan 18 14:54:53 2021 -0500
> 
>     kbuild: give the SUBLEVEL more room in KERNEL_VERSION
> 
> That would IMO break userspace as definition of kernel version has changed.
> And that one is UAPI/ABI (see include/generated/uapi/linux/version.h) as
> Jari writes. For example will glibc still work:
> http://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/unix/sysv/linux/configure.ac;h=13abda0a51484c5951ffc6d718aa36b72f3a9429;hb=HEAD#l14
> 
> ? Or gcc 10 (11 will have this differently):
> https://gcc.gnu.org/git/?p=gcc.git;a=blob;f=gcc/config/bpf/bpf.c;hb=ee5c3db6c5b2c3332912fb4c9cfa2864569ebd9a#l165
> 
> and
> 
> https://gcc.gnu.org/git/?p=gcc.git;a=blob;f=gcc/config/bpf/bpf-helpers.h;hb=ee5c3db6c5b2c3332912fb4c9cfa2864569ebd9a#l53

Ugh, I thought this was an internal representation, not an external one
:(

> It might work somewhere, but there are a lot of (X * 65536 + Y * 256 + Z)
> assumptions all around the world. So this doesn't look like a good idea.

Ok, so what happens if we "wrap"?  What will break with that?  At first
glance, I can't see anything as we keep the padding the same, and our
build scripts seem to pick the number up from the Makefile and treat it
like a string.

It's only the crazy out-of-tree kernel stuff that wants to do minor
version checks that might go boom.  And frankly, I'm not all that
concerned if they have problems :)

So, let's leave it alone and just see what happens!

greg k-h
