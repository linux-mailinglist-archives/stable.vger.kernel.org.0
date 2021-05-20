Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EDC38ABC1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239380AbhETL1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:27:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241814AbhETLZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:25:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5562610A1;
        Thu, 20 May 2021 10:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621508378;
        bh=ErWk98vzrForhE3SzoXim0biwXq3y3R8u0Q+s0olTjs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uAUg38sxA+TEk/ciN9KzSw30zOGHA3wAihTITwKIJaqe8WohUEiH/7B3tb8uz763X
         p5w596CDMKcMYBLNAvIR4zZt91ZeaBpr58coNVbjotzJQnE7HKOw1iWOCoG3c02g2e
         3EZGa98xW6WJRijNaw+sLa9JrmBr1maJJy2DiyBM=
Date:   Thu, 20 May 2021 12:59:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.12 06/45] ARM: 9058/1: cache-v7: refactor
 v7_invalidate_l1 to avoid clobbering r5/r6
Message-ID: <YKZBGG4iJ0Wwpk7+@kroah.com>
References: <20210520092053.516042993@linuxfoundation.org>
 <20210520092053.731407333@linuxfoundation.org>
 <CAMj1kXECeTz5T+0Pi77POE-uo65D_+gXFHZh=wi6EDVBDK2Rsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXECeTz5T+0Pi77POE-uo65D_+gXFHZh=wi6EDVBDK2Rsg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 11:59:40AM +0200, Ard Biesheuvel wrote:
> On Thu, 20 May 2021 at 11:25, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Ard Biesheuvel <ardb@kernel.org>
> >
> > [ Upstream commit f9e7a99fb6b86aa6a00e53b34ee6973840e005aa ]
> >
> > The cache invalidation code in v7_invalidate_l1 can be tweaked to
> > re-read the associativity from CCSIDR, and keep the way identifier
> > component in a single register that is assigned in the outer loop. This
> > way, we need 2 registers less.
> >
> > Given that the number of sets is typically much larger than the
> > associativity, rearrange the code so that the outer loop has the fewer
> > number of iterations, ensuring that the re-read of CCSIDR only occurs a
> > handful of times in practice.
> >
> > Fix the whitespace while at it, and update the comment to indicate that
> > this code is no longer a clone of anything else.
> >
> > Acked-by: Nicolas Pitre <nico@fluxnic.net>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Please do NOT backport this to any stable trees.
> 
> It has no cc:stable tag
> It has no fixes: tag
> It was part of a 3 part series, but only the middle patch was selected.
> It touches ARM assembly that may assemble without problems but be
> completely broken at runtime when used out of the original intended
> context.

Now dropped from all stable queues, thanks for letting us know.

greg k-h
