Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B388C3F12C4
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 07:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhHSFcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 01:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229868AbhHSFcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 01:32:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF80860EBD;
        Thu, 19 Aug 2021 05:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629351103;
        bh=/fSLQfLREbzgwCm1OuDOyLec5LslhpOi9wvWPkjYQkU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YCytjbha8Wynnvy3GXCOnwWHnvxlSwNlQKlTGaK0EJ7L5ph4QFBverzah1ypnjFAS
         WV6UOyVRHxz6dPRVJQfpM5LMfi7wiKvsSXnW1VIw8ntB9OvDOJK1tN6i9wX2Pw23P1
         0ynS5+wC6yKsPIUtIBFvqOHT3batKYw5cU83mLoM=
Date:   Thu, 19 Aug 2021 07:31:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hui Wang <hui.wang@canonical.com>
Cc:     Marek Vasut <marex@denx.de>, Stable <stable@vger.kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>
Subject: Re: the commit c434e5e48dc4 (rsi: Use resume_noirq for SDIO)
 introduced driver crash in the 4.15 kernel
Message-ID: <YR3svHFF1vheoQyb@kroah.com>
References: <2b77868b-c1e6-9f30-9640-5c82a82f5b31@canonical.com>
 <YRybjZdFngJr9R8i@kroah.com>
 <6abb6c93-b9d6-c173-7fe1-fcf3b0abd615@denx.de>
 <4a29398d-4253-201d-11bb-30a5c511f7b2@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4a29398d-4253-201d-11bb-30a5c511f7b2@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 19, 2021 at 10:57:03AM +0800, Hui Wang wrote:
> 
> On 8/18/21 5:04 PM, Marek Vasut wrote:
> > On 8/18/21 7:33 AM, Greg Kroah-Hartman wrote:
> > > On Wed, Aug 18, 2021 at 12:06:15PM +0800, Hui Wang wrote:
> > > > Hi Marex,
> > > > 
> > > > We backported this patch to ubuntu 4.15.0-generic kernel, and
> > > > found this
> > > > patch introduced the rsi driver crashing when running system
> > > > resume on the
> > > > Dell 300x IoT platform (100% rate). Below is the log, After
> > > > seeing this log,
> > > > the rsi wifi can't work anymore, need to run 'rmmod rsi_sdio;modprobe
> > > > rsi_sdio" to make it work again.
> > > > 
> > > > So do you know what is missing apart from this patch or this
> > > > patch is not
> > > > suitable for 4.15 kernel at all?
> > > 
> > > Does 4.19.191 work for this system?  Why not just use that or newer
> > > instead?
> > 
> > I haven't seen this on linux-stable 5.4.y or 5.10.y, if that information
> > is of any use.
> > 
> > But I have to admit, I am tempted to mark the whole driver as BROKEN and
> > submit that for stable backports.
> > 
> > Because that is what it is, it is buggy, broken, and the hardware lacks
> > any documentation. I spent an insane amount of time talking to RedPine
> > Signals / SiLabs trying to get help with basic things like association
> > problems against various APs, no result there. I tried getting hardware
> > docs from them so I can fix the driver myself, no result either. So far
> > I tried to pick various fixes from their downstream driver and submit
> > them, but that is massively time consuming and the changes there are not
> > separated or documented, it is just one large chunk of code.
> > 
> > As far as I can tell, they also have no interest in fixing the driver or
> > helping others with fixing it, so maybe we should just mark it as broken
> > ... :-(
> 
> Hi Marek,
> 
> Got it, thanks for sharing it.
> 
> Hi Greg,
> 
> I just tested the 4.19.191, got the same result, the wifi will crash after
> resume under 4.19.191:
> 
> admin@HW6VB02:~$ uname -a
> Linux HW6VB02 4.19.191 #1 SMP Thu Aug 19 10:19:32 CST 2021 x86_64 x86_64
> x86_64 GNU/Linux
> 
> [   59.682908] sdhci-acpi INT33BB:00: pre_suspend failed for non-removable
> host: -38
> [   59.682917] Freezing user space processes ... (elapsed 0.003 seconds)
> done.
> [   59.686063] OOM killer disabled.
> [   59.686065] Freezing remaining freezable tasks ... (elapsed 0.001
> seconds) done.
> [   59.687385] Suspending console(s) (use no_console_suspend to debug)
> [   59.687931] rsi_91x: ===> Interface DOWN <===
> [   70.068983] mmc1: Controller never released inhibit bit(s).
> [   70.068992] mmc1: sdhci: ============ SDHCI REGISTER DUMP ===========
> [   70.069002] mmc1: sdhci: Sys addr:  0xffffffff | Version: 0x0000ffff
> [   70.069009] mmc1: sdhci: Blk size:  0x0000ffff | Blk cnt: 0x0000ffff
> [   70.069016] mmc1: sdhci: Argument:  0xffffffff | Trn mode: 0x0000ffff
> [   70.069023] mmc1: sdhci: Present:   0xffffffff | Host ctl: 0x000000ff
> [   70.069030] mmc1: sdhci: Power:     0x000000ff | Blk gap: 0x000000ff
> [   70.069036] mmc1: sdhci: Wake-up:   0x000000ff | Clock: 0x0000ffff
> [   70.069043] mmc1: sdhci: Timeout:   0x000000ff | Int stat: 0xffffffff
> 
> 
> So let us revert this commit from 4.19.y?

If you revert it, does it work properly?  What about in Linus's tree?

thanks,

greg k-h
