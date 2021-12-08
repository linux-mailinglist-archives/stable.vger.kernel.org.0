Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55ABD46D407
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 14:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbhLHNJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 08:09:55 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:53372 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbhLHNJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 08:09:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9176ACE2180
        for <stable@vger.kernel.org>; Wed,  8 Dec 2021 13:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F52DC00446;
        Wed,  8 Dec 2021 13:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638968779;
        bh=jBjNCeVJHLsxhV+tXkdj+uvYJOsHT+jIBqBjO7s6QGQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uMOmxQYbSMwMUVb/FQsmeM9GpPswZnL6FM5C+OK2wNmvy7Zwruy1COEidijMYGVs3
         KyMSzI7SzIR64YOMXNpzePo+SA76sBNjxPPAw/Lsil+TgblTMXZH/WDi+G9oPqNmy7
         qyb5b/MUatwxjypJzEy4TZYbfi/znz2nYUEhEQ/E=
Date:   Wed, 8 Dec 2021 14:06:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Thomas Lindroth <thomas.lindroth@gmail.com>, stable@vger.kernel.org
Subject: Re: Could the fix for broken gcc-plugins with gcc-11 be backported
 to 5.10?
Message-ID: <YbCtxhUlnyr8N4Ij@kroah.com>
References: <a11f5d22-658c-44e9-51ab-d39c5e8776da@gmail.com>
 <Ya4KYD9lpKaQI9G7@kroah.com>
 <dbf6b329-03ae-fc92-80a6-8f80d88e28cf@gmail.com>
 <Ya4PqyRnxqB+5VaV@kroah.com>
 <ba94ea3b-c2df-9ddb-1074-d6b58389a686@gmail.com>
 <Ya4hM4dsWYxw8nJW@kroah.com>
 <202112061220.79D1A6823E@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202112061220.79D1A6823E@keescook>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 12:29:31PM -0800, Kees Cook wrote:
> On Mon, Dec 06, 2021 at 03:41:55PM +0100, Greg KH wrote:
> > On Mon, Dec 06, 2021 at 02:59:57PM +0100, Thomas Lindroth wrote:
> > > On 12/6/21 14:27, Greg KH wrote:
> > > > On Mon, Dec 06, 2021 at 02:24:29PM +0100, Thomas Lindroth wrote:
> > > > > On 12/6/21 14:04, Greg KH wrote:
> > > > > > On Mon, Dec 06, 2021 at 01:59:31PM +0100, Thomas Lindroth wrote:
> > > > > > > Build support for gcc-plugins are not detected with gcc-11 in lts kernels.
> > > > > > > Gentoo and Arch apply their own patch to fix the problem in their distribution
> > > > > > > kernels but I would prefer if a proper fix was applied upstream.
> > > > > > > 
> > > > > > > https://bugs.gentoo.org/814200 a gentoo report with the relevant info.
> > > > > > > 
> > > > > > > I've searched for any upstream discussions about the problem but I've only found
> > > > > > > one message saying the backport needs an additional fix. That was almost a year
> > > > > > > ago. https://www.spinics.net/lists/stable/msg438000.html
> > > > > > 
> > > > > > We can not take a patch in a stable kernel release unless it is already
> > > > > > in Linus's tree.  Please work to get a patch accepted there first,
> > > > > > before worrying about older kernel versions.
> > > > > > 
> > > > > > thanks,
> > > > > > 
> > > > > > greg k-h
> > > > > > 
> > > > > 
> > > > > The problem was fixed in Linus tree in commit 67a5a68013056cbcf0a647e36cb6f4622fb6a470
> > > > > "gcc-plugins: fix gcc 11 indigestion with plugins..." added in v5.11
> > > > > 
> > > > > That's the patch that needed some kind of additional fix before it could be backported
> > > > > but that fix never materialized.
> > > > 
> > > > If you have a working version, based on a distro's use, please provide
> > > > it and I will be glad to pick it up.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > 
> > > https://dev.gentoo.org/~mpagano/genpatches/trunk/5.10/2910_fix-gcc-detection-method.patch
> > > 
> > > Here is the patch gentoo applies to 5.10. It seems to be a combination of two upstream
> > > commits:
> > > 67a5a68013056cbcf0a647e36cb6f4622fb6a470 "gcc-plugins: fix gcc 11 indigestion with plugins..."
> > > 1e860048c53ee77ee9870dcce94847a28544b753 "gcc-plugins: simplify GCC plugin-dev capability test"
> > 
> > That's not how I can take a patch, sorry.  Please submit these as
> > individual emails so that then could be applied.
> > 
> > > I can't vouch for the correctness of that fix. I'm just a regular user who stumbled upon this
> > > problem and found that gentoo bug report. Check with Kees Cook for that "additional fix". I
> > > don't know what fix that is.
> > 
> > I don't think either of them differ from what is in mainline, so I do
> > not know.
> 
> Hi!
> 
> Yeah, the two fixes that I think are needed for v5.10 are:
> 
> 1e860048c53ee77ee9870dcce94847a28544b753
> 67a5a68013056cbcf0a647e36cb6f4622fb6a470
> 
> This additionally appears to match the combo patch in gentoo:
> https://814200.bugs.gentoo.org/attachment.cgi?id=746715
> 
> Local build testing shows the plugins working...

Ok, both now queued up, thanks.

greg k-h
