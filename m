Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A9E2A3CD8
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 07:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgKCGfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 01:35:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:34384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725982AbgKCGfd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 01:35:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E003922277;
        Tue,  3 Nov 2020 06:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604385332;
        bh=KIGBZzLW6/iyV4lqJAjCeoOE0mdh9RR33cupiGx3qLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ptQei5gQUn6zh++ttwvBgdiuBN1W4ruRZufMNqIql9EVxnU2u/isEUrmBJvI4FxWU
         5gpibSCmETD2fS2sK88vzq4Cc8Q+lXFiWsocKfBCZPQl5ADcszlTpTVMzY8SFruwsr
         3UcUxRPpWMj7P2pkX4f6z1aT7efq1abfIF2I/OKA=
Date:   Tue, 3 Nov 2020 07:35:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans-Peter Jansen <hpj@urpla.net>
Cc:     linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 5.9 24/74] x86, powerpc: Rename memcpy_mcsafe() to
 copy_mc_to_{user, kernel}()
Message-ID: <20201103063529.GB74163@kroah.com>
References: <20201031113500.031279088@linuxfoundation.org>
 <20201031113501.207349375@linuxfoundation.org>
 <5149714.arhZky3dcl@xrated>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5149714.arhZky3dcl@xrated>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 02, 2020 at 10:34:08PM +0100, Hans-Peter Jansen wrote:
> Hi Greg, hi Dan,
> 
> Am Samstag, 31. Oktober 2020, 12:36:06 CET schrieb Greg Kroah-Hartman:
> > From: Dan Williams <dan.j.williams@intel.com>
> > 
> > commit ec6347bb43395cb92126788a1a5b25302543f815 upstream.
> > 
> > In reaction to a proposal to introduce a memcpy_mcsafe_fast()
> > implementation Linus points out that memcpy_mcsafe() is poorly named
> > relative to communicating the scope of the interface. Specifically what
> > addresses are valid to pass as source, destination, and what faults /
> > exceptions are handled.
> > 
> > 
> > Introduce an x86 copy_mc_fragile() name as the rename for the
> > low-level x86 implementation formerly named memcpy_mcsafe(). It is used
> > as the slow / careful backend that is supplanted by a fast
> > copy_mc_generic() in a follow-on patch.
> > 
> > One side-effect of this reorganization is that separating copy_mc_64.S
> > to its own file means that perf no longer needs to track dependencies
> > for its memcpy_64.S benchmarks.
> > 
> > ---
> > arch/powerpc/lib/copy_mc_64.S                          |  242 +++++++++++++++++
> > arch/powerpc/lib/memcpy_mcsafe_64.S                    |  242 -----------------
> 
> > tools/testing/selftests/powerpc/copyloops/copy_mc_64.S |  242 +++++++++++++++++ 
> 
> This change leaves a dangling symlink in 
> tools/testing/selftests/powerpc/copyloops behind. At least, this is, what I 
> could track down, when building 5.9.3 within an environment, that bails out 
> on this:
> 
> [ 2908s] calling /usr/lib/rpm/brp-suse.d/brp-25-symlink
> [ 2908s] ERROR: link target doesn't exist (neither in build root nor in installed system):
> [ 2908s]   /usr/src/linux-5.9.3-lp152.3-vanilla/tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S -> /usr/src/linux-5.9.3-lp152.3-vanilla/arch/powerpc/lib/memcpy_mcsafe_64.S
> [ 2908s] Add the package providing the target to BuildRequires and Requires
> [ 2909s] INFO: relinking /usr/src/linux-5.9.3-lp152.3-vanilla/tools/testing/selftests/powerpc/primitives/asm/asm-compat.h -> ../../../../../../arch/powerpc/include/asm/asm-compat.h (was ../.././../../../../arch/powerpc/include/asm/asm-compat.h)
> 
> Linus` tree seems to not suffer from this, though.

Ah, that kind of makes sense, I saw odd things with these patches that I
couldn't figure out.

So, is there a symlink that I need to add/fix to resolve this?

thanks,

greg k-h
