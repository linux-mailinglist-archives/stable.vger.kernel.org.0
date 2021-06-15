Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8733A76D5
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 08:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhFOGDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 02:03:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhFOGDW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 02:03:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35EE860720;
        Tue, 15 Jun 2021 06:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623736878;
        bh=6+Xsjc6mhzFwkeVtJlWg7rfSXLGzA8yfj6gPeHytIjk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HeClBzVnN5StT2aEIrpy6h6FjrvrEj6Hmq1BmbSTY5vL4TD0JLvVXKsP/JjWujddP
         Z9lfxC8bSyNgN25G59UHj5YC3GT4B6dUsR1dzC5AzxpzpoKysYhxTiZstURNolWlaB
         d8f5zF8NS6UNmQAHTqxkm7EuQvF+acDJJX24z4s8=
Date:   Tue, 15 Jun 2021 08:01:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adam Edge <baronedge@protonmail.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: Regression after 5.7.19 causing major freezes on CPU loads
Message-ID: <YMhCK8x7R4TbnLAF@kroah.com>
References: <HnYKcqmY_z0ERb5qOOUauOLY1vt6nxuKHXzuKVrZ297elyqtzpsWTrjUUnlIDG7mQUYnJMfS8HkFceFMf0Fd_GLzOMghgf4btNt9YhwwZK0=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HnYKcqmY_z0ERb5qOOUauOLY1vt6nxuKHXzuKVrZ297elyqtzpsWTrjUUnlIDG7mQUYnJMfS8HkFceFMf0Fd_GLzOMghgf4btNt9YhwwZK0=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 07:21:55PM +0000, Adam Edge wrote:
> Hello,
> 
> After I've upgraded from 5.7.11 (didn't have access to this machine for
> about 10 months) to 5.12.10, I've noticed that anytime I used all my
> cores to, for example, compile a project, the system would degrade
> significantly in performance and applications would start to stutter.
> Compiles are also about 3-4x slower on kernels with the regression vs.
> without. After debugging this for the past 24 hours or so, I've narrowed
> it down to a change between 5.7.19 and 5.8.1. Sadly, bisect does not
> help, because trying to run any of the 5.8 RC kernels causes the kernel
> to be stuck before init, without any apparent errors on the screen (and
> I don't have a serial cable to dump the kernel output to). I'm listing
> all the information I know and my system information below.
> 
> Reproduction steps (dunno if this helps, but):
> 1. Boot with kernel with the regression
> 2. Do something that uses all cores, like compiling the Linux kernel
> 3. Observe long compile times and stuttering applications (which doesn't
> happen even on full load with a working kernel)
> 
> Regression between kernel versions:
> 5.7 - working
> 5.7.11 - working
> 5.7.19 - working
> 5.8.1 - broken
> 5.8.18 - broken
> 5.12.10 - broken
> 8ecfa36cd4db3275bf3b6c6f32c7e3c6bb537de2 (master on 2021-06-13) - broken

Can you use 'git bisect' to track down the commit that caused the
problem?

thanks,

greg k-h
