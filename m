Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F75453268
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 13:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236418AbhKPMxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 07:53:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236307AbhKPMxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 07:53:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84E3861548;
        Tue, 16 Nov 2021 12:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637067016;
        bh=mrvEq5wnkMuAzToky9aXug/TyOK6An+807oCmVO4+k0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SNZnnzyJqAwSoPzBnJC4cUpuMcrIMlCu9dAelnBtmVEJt43LdYWL/uQFfrYWOkrTT
         QNF5nfEBdhyWgXbFsW1V4A+IIK5IoWyDEwo5hwPhggoKVBl3z++4TKIgt8c6+VZEeq
         T2DEGZQZm9UXTiU6Lj5YR4bN4wGM0qNSUlFqGfs8=
Date:   Tue, 16 Nov 2021 13:50:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     brijesh.singh@amd.com, thomas.lendacky@amd.com,
        stable@vger.kernel.org,
        =?iso-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
Subject: Re: FAILED: patch "[PATCH] x86/sev: Make the #VC exception stacks
 part of the default" failed to apply to 5.15-stable tree
Message-ID: <YZOpBS+oASQVB4ae@kroah.com>
References: <1637060086211132@kroah.com>
 <YZORuI1FLTO39Xt7@zn.tnic>
 <YZOU0ViYGD24/Al0@kroah.com>
 <YZObjPyuhsHmREd7@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZObjPyuhsHmREd7@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 12:52:44PM +0100, Borislav Petkov wrote:
> On Tue, Nov 16, 2021 at 12:24:01PM +0100, Greg KH wrote:
> > Nope, planning ahead:
> > 	$ ~/linux/stable/commit_tree/id_found_in 7fae4c24a2b8
> > 	5.16-rc1 queue-4.4 queue-4.9 queue-4.14 queue-4.19 queue-5.4 queue-5.10 queue-5.14 queue-5.15
> > 
> > That commit is in the current -rc releases right now.
> 
> Bah, there's stuff in-flight.
> 
> > The problem with this commit is that the cc_platform_has() function is
> > not present.  I thought about backporting it as well, but that seemed
> > odd as I do not think that feature is in the 5.15 and older kernels,
> > right?
> 
> The cc_platform_has() was a small set:
> 
> https://lore.kernel.org/r/YX%2B5ekjTbK3rhX%2BY@zn.tnic
> 
> which wants to keep all those checks confidential guests are going to do
> around the code, sane. So you don't really need it but...
> 
> > Or is it ok to take the cc_platform_has() function?
> 
> ... it will simplify all those backports which use it in the future. And
> we will use cc_platform_has() from now on in common code.
> 
> In any case, we're going to backport it into SLE just for that reason -
> so that it can ease backports and there's no kABI nightmares.

Ok, sounds good, I'll go queue them up now and see how the builds go to
save you the trouble of backporting into SLE...

greg k-h
