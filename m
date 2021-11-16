Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F405453067
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 12:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbhKPL2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 06:28:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234960AbhKPL1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 06:27:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDA5861994;
        Tue, 16 Nov 2021 11:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637061843;
        bh=gcQaZSd8bA1nsAdQbXHCCOA6m+efoCs5f2EfbldMh8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zvkll4lTgHmoOYmMAQ1rGigHaRQqDCoCA3J6mFt1BSn+4w9MDSmZbxbpP/dBw1lLU
         Y9l8ZzUG3DIUKfcPD6Agzw7Z3h43A1mX1FDm9KEpaHQ10TKSb2404KV31mviTB8YtL
         kFBZycAvwPlxC38CGdoymrd9E1ioClPvr/BGWLks=
Date:   Tue, 16 Nov 2021 12:24:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     brijesh.singh@amd.com, thomas.lendacky@amd.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/sev: Make the #VC exception stacks
 part of the default" failed to apply to 5.15-stable tree
Message-ID: <YZOU0ViYGD24/Al0@kroah.com>
References: <1637060086211132@kroah.com>
 <YZORuI1FLTO39Xt7@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZORuI1FLTO39Xt7@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 12:10:48PM +0100, Borislav Petkov wrote:
> On Tue, Nov 16, 2021 at 11:54:46AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From 541ac97186d9ea88491961a46284de3603c914fd Mon Sep 17 00:00:00 2001
> > From: Borislav Petkov <bp@suse.de>
> > Date: Fri, 1 Oct 2021 21:41:20 +0200
> > Subject: [PATCH] x86/sev: Make the #VC exception stacks part of the default
> >  stacks storage
> > 
> > The size of the exception stacks was increased by the commit in Fixes,
> > resulting in stack sizes greater than a page in size. The #VC exception
> > handling was only mapping the first (bottom) page, resulting in an
> > SEV-ES guest failing to boot.
> > 
> > Make the #VC exception stacks part of the default exception stacks
> > storage and allocate them with a CONFIG_AMD_MEM_ENCRYPT=y .config. Map
> > them only when a SEV-ES guest has been detected.
> > 
> > Rip out the custom VC stacks mapping and storage code.
> > 
> >  [ bp: Steal and adapt Tom's commit message. ]
> > 
> > Fixes: 7fae4c24a2b8 ("x86: Increase exception stack sizes")
> 
> $ git tag --contains 7fae4c24a2b8 | grep -E "^v"
> v5.16-rc1
> 
> Scripts kaputtski?

Nope, planning ahead:
	$ ~/linux/stable/commit_tree/id_found_in 7fae4c24a2b8
	5.16-rc1 queue-4.4 queue-4.9 queue-4.14 queue-4.19 queue-5.4 queue-5.10 queue-5.14 queue-5.15

That commit is in the current -rc releases right now.

The problem with this commit is that the cc_platform_has() function is
not present.  I thought about backporting it as well, but that seemed
odd as I do not think that feature is in the 5.15 and older kernels,
right?

Or is it ok to take the cc_platform_has() function?

thanks,

greg k-h
