Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04120456FB5
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 14:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbhKSNhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 08:37:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhKSNhq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 08:37:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3822610D2;
        Fri, 19 Nov 2021 13:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637328884;
        bh=jyBafbVzKyYoDQJ95eq1NEiSIax7aw0SPP62yvraZ+0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x02BfOtmAjEZVVrF/EMLYjOw218st5aOzmX7EJSkjGWtwWRrAx4Qr8yugjwzDm4os
         EBfG8sxfOHeZMR3Q7B99p572p5jBJF9D+/tNHZvvd2OfmMNf5sXpUp4uwNrV5wfBP6
         gvEgTB34Cx7RRjoLHXQFe5cilbcfadiDwcIYZ2/4=
Date:   Fri, 19 Nov 2021 14:34:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ondrej Zary <linux@zary.sk>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v5.10 backport of x86/iopl: Fake iopl(3) CLI/STI usage
Message-ID: <YZen8SiRcsTVU6e8@kroah.com>
References: <20211116191514.17854-1-linux@zary.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116191514.17854-1-linux@zary.sk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 08:15:14PM +0100, Ondrej Zary wrote:
> Backport of the following patch for 5.10-stable:
> 
> >>>From b968e84b509da593c50dc3db679e1d33de701f78 Mon Sep 17 00:00:00 2001
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri, 17 Sep 2021 11:20:04 +0200
> 
> Since commit c8137ace5638 ("x86/iopl: Restrict iopl() permission
> scope") it's possible to emulate iopl(3) using ioperm(), except for
> the CLI/STI usage.
> 
> Userspace CLI/STI usage is very dubious (read broken), since any
> exception taken during that window can lead to rescheduling anyway (or
> worse). The IOPL(2) manpage even states that usage of CLI/STI is highly
> discouraged and might even crash the system.
> 
> Of course, that won't stop people and HP has the dubious honour of
> being the first vendor to be found using this in their hp-health
> package.
> 
> In order to enable this 'software' to still 'work', have the #GP treat
> the CLI/STI instructions as NOPs when iopl(3). Warn the user that
> their program is doing dubious things.
> 
> Fixes: a24ca9976843 ("x86/iopl: Remove legacy IOPL option")
> Reported-by: Ondrej Zary <linux@zary.sk>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> Link: https://lkml.kernel.org/r/20210918090641.GD5106@worktop.programming.kicks-ass.net
> Signed-off-by: Ondrej Zary <linux@zary.sk>

Now queued up, thanks.

greg k-h
