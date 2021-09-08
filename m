Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32EA4033D5
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 07:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345480AbhIHFcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 01:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhIHFcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 01:32:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37B4761154;
        Wed,  8 Sep 2021 05:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631079068;
        bh=PU7VPW7BVHnbqIP/swEyrW6pQgImIHvji2Nqm/ys0rE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m7EVUmyULko/IP8jskMjlOba/tiF9s7yjcnUlIttFzXmTSVHY5oqkTq3Gi6FH6n9y
         ON5T+BCaB4yno/Ux6eV4uUy+Ao6u3woTWmRqokzrXLXaFKAiuQVkfnsjthj38vXbIq
         Umz3AZt06mMGQ1x8T369I/MavtdCDswlPXUGnxEs=
Date:   Wed, 8 Sep 2021 07:30:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     wim <wim@djo.tudelft.nl>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kernel-4.9.270 crash
Message-ID: <YThKidnH3d1fb18g@kroah.com>
References: <20210904235231.GA31607@djo.tudelft.nl>
 <20210905190045.GA10991@djo.tudelft.nl>
 <YTWgKo4idyocDuCD@kroah.com>
 <20210906093611.GA20123@djo.tudelft.nl>
 <YTXy5BmzQpY0SprA@kroah.com>
 <20210908015139.GA26272@djo.tudelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908015139.GA26272@djo.tudelft.nl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 08, 2021 at 03:51:39AM +0200, wim wrote:
> On Mon, Sep 06, 2021 at 12:52:20PM +0200, Greg KH wrote:
> > > > > > 
> > > > > > from kernel-4.9.270 up until now (4.9.282) I experience kernel crashes upon
> > > > > > loading a GPU module.
> > > > > > ...
> > > > 
> > > > Do you have any kernel log messages when these crashes happen?
> > > ...
> > > Aug  1 20:51:24 djo kernel:  [<f8bc4ef7>] ? 0xf8bc4ef7
> > 
> > <snip>
> > 
> > These aren't going to help us much, can you turn on debugging symbols
> > for these crashes for us to see the symbol names?
> 
> ERROR: not enough memory to load nouveau.ko

That's the only error?  Maybe you don't have enough memory?

> i915.ko is smaller and my laptop is bigger. Identical crash, no symbols.

Odd.

> > > > Can you use 'git bisect' to track down the offending commit?
> > > 
> > > If I would know how to do that
> > 
> > 'man git bisect' should provide a tutorial on how to do this.
> 
> No, it does not.
> It would have taken an enormous amount of time and GBs less if I'd found
> earlier the only pointer on internet that stated:
> 
>   cd linux
>   git remote add stable git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
>  
> and that brought me reasonably fast to this:
> 
>   3bd3a8ca5a7b1530f463b6e1cc811c085e6ffa01 is the first bad commit
>   commit 3bd3a8ca5a7b1530f463b6e1cc811c085e6ffa01
>   Author: Maciej W. Rozycki <macro@orcam.me.uk>
>   Date:   Thu May 13 11:51:50 2021 +0200
>   ...

That is a vt change that handles an issue with a console driver, so this
feels like a false failure.

If you revert this change on a newer kernel release, does it work?

And what about showing us the symbols of that traceback?

thanks,

greg k-h
