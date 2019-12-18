Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28C8C1246B0
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 13:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfLRMWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 07:22:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbfLRMWA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 07:22:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D114121582;
        Wed, 18 Dec 2019 12:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576671719;
        bh=mwUG7T4wiluvDMoa+8uM1MTApMMhiYa8/vECsa8OAxE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ucr2Uf3eUh2mEBA62plUWANWmrqEmolSuEx8tTmm+okxdOQ13Aeegy8KhfAVwjKp9
         72hB7zUnKvDuzwQM06zyPIoAuoX9th/aNWWQ1jnQ/LKYlqo0XUvfLfN1NQiqBZK23l
         qiG/XbRV18woNVgm8AnBtPO7Ztxa3rOPd3wJs3EA=
Date:   Wed, 18 Dec 2019 13:21:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Siddharth Kapoor <ksiddharth@google.com>, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Kernel panic on Google Pixel devices due to regulator patch
Message-ID: <20191218122157.GA17086@kroah.com>
References: <CAJRo92+eD9F6Q60yVY2PfwaPWO_8Dts8QwH7mhpJaem7SpLihg@mail.gmail.com>
 <20191218113458.GA3219@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218113458.GA3219@sirena.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 11:34:58AM +0000, Mark Brown wrote:
> On Tue, Dec 17, 2019 at 11:51:55PM +0800, Siddharth Kapoor wrote:
> 
> > I would like to share a concern with the regulator patch which is part of
> > 4.9.196 LTS kernel.
> 
> That's an *extremely* old kernel.

It is, but it's the latest stable kernel (well close to), and your patch
was tagged by you to be backported to here, so if there's a problem with
a stable branch, I want to know about it as I don't want to see
regressions happen in it.

> > https://lore.kernel.org/lkml/20190904124250.25844-1-broonie@kernel.org/
> 
> That's the patch "[PATCH] regulator: Defer init completion for a while
> after late_initcall" which defers disabling of idle regulators for a
> while.
> 
> Please include human readable descriptions of things like commits and
> issues being discussed in e-mail in your mails, this makes them much
> easier for humans to read especially when they have no internet access.
> I do frequently catch up on my mail on flights or while otherwise
> travelling so this is even more pressing for me than just being about
> making things a bit easier to read.
> 
> > We have reverted the patch in Pixel kernels and would like you to look into
> > this and consider reverting it upstream as well.
> 
> I've got nothing to do with the stable kernels so there's nothing I can
> do here, sorry.

Should I revert it everywhere?  This patch reads as it should be fixing
problems, not causing them :)

> However if this is triggering anything it's almost
> certainly some kind of timing issue (this code isn't new, it's just
> being run a bit later) and is only currently working through luck so I
> do strongly recommend trying to figure out the actual problem since it's
> liable to come back and bite you later - we did find one buggy driver in
> mainline as a result of this change, it's possible you've got another
> one.  
> 
> Possibly your GPU supplies need to be flagged as always on, possibly
> your GPU driver is forgetting to enable some supplies it needs, or
> possibly there's a missing always-on constraint on one of the regulators
> depending on how the driver expects this to work (if it's a proprietary
> driver it shouldn't be using the regulator API itself).  I'm quite
> surprised you've not seen any issue before given that the supplies would
> still be being disabled earlier.

Timing "luck" is probably something we shouldn't be messing with in
stable kernels.  How about I revert this for the 4.14 and older releases
and let new devices deal with the timing issues when they are brought up
on new hardware?

thanks,

greg k-h
