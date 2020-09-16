Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C617126C472
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 17:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgIPPkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 11:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbgIPPa1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 11:30:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01EDE20715;
        Wed, 16 Sep 2020 15:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600269955;
        bh=L3ATN5SkAg5QienUVgSnHS6amRSeN8XZTpAIwp8DitY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V8ZewoTBOL5l0jFfC96BgwpiJ+ivSbCO4hZD3xfFCotWrrVPWPgOflJGJ/gieF4SS
         S0Ie5aCWSPLp8nJhoKxr05Kw6R/0ChNkl3symgCA3pVhuTUf0NU4GwYj1E2yxENXpB
         Vd3xSHrXr5oA+4z3Uju2fVOSjxacrj6WwEuWgqbE=
Date:   Wed, 16 Sep 2020 17:26:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Prateek Sood <prsood@codeaurora.org>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/177] 5.8.10-rc1 review
Message-ID: <20200916152629.GD3018065@kroah.com>
References: <20200915140653.610388773@linuxfoundation.org>
 <b94c29b3-ef68-897b-25a8-e6fcc181a22a@linuxfoundation.org>
 <8277900f-d300-79fa-eac7-096686a6fbc3@linuxfoundation.org>
 <20200916062958.GH142621@kroah.com>
 <69e7c908-4332-91fd-bdb2-6be19fcbf126@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69e7c908-4332-91fd-bdb2-6be19fcbf126@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 08:26:48AM -0600, Shuah Khan wrote:
> On 9/16/20 12:29 AM, Greg Kroah-Hartman wrote:
> > On Tue, Sep 15, 2020 at 08:54:24PM -0600, Shuah Khan wrote:
> > > On 9/15/20 3:06 PM, Shuah Khan wrote:
> > > > On 9/15/20 8:11 AM, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 5.8.10 release.
> > > > > There are 177 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
> > > > > Anything received after that time might be too late.
> > > > > 
> > > > > The whole patch series can be found in one patch at:
> > > > >      https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.10-rc1.gz
> > > > > 
> > > > > or in the git tree and branch at:
> > > > >      git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > > > linux-5.8.y
> > > > > and the diffstat can be found below.
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > > 
> > > > 
> > > > Compiled and booted fine. wifi died:
> > > > 
> > > > ath10k_pci 0000:02:00.0: could not init core (-110)
> > > > ath10k_pci 0000:02:00.0: could not probe fw (-110)
> > > > 
> > > > This is regression from 5.8.9 and 5.9-rc5 works just fine.
> > > > 
> > > > I will try to bisect later this evening to see if I can isolate the
> > > > commit.
> > > > 
> > > 
> > > The following commit is what caused ath10k_pci driver problem
> > > that killed wifi.
> > > 
> > > Prateek Sood <prsood@codeaurora.org>
> > >      firmware_loader: fix memory leak for paged buffer
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.8.y&id=ec0a59266c9c9f46037efd3dcc0323973e102271
> > 
> > Ugh, that's not good, is this also a problem in 5.9-rc5 as well?  For
> > reference, this is commit 4965b8cd1bc1 ("firmware_loader: fix memory
> > leak for paged buffer") in Linus's tree.
> > 
> 
> I am not seeing this on Linux 5.9-rc5 for sure.
> 
> > And it should be showing up in 5.4.y at the moment too, as this patch is
> > in that tree right now...
> > 
> 
> I don't see this patch in  4.19.146-rc1

It's not there, it's in 5.4.66-rc1, which worked for you somehow, right?

> Linus's tree works for with this patch in. I compared the two files
> for differences in commit between Linus's tree and 5.8.10-rc1
> 
> Couldn't find anything obvious.

Again, really odd...

I don't have a problem dropping it, but I should drop it from both 5.4.y
and 5.8.y, right?

thanks,

greg k-h
