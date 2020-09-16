Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17A526BD11
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 08:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgIPG30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 02:29:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbgIPG3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 02:29:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4CA9206A4;
        Wed, 16 Sep 2020 06:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600237764;
        bh=Yix4z+4H+DLzZ2+r9t2oKhaZc2zybFOpeyeNsSC8584=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gxGddWHWTd5xf5qEEcjJf8i7VqKcJS/BR9Yq/mn8nvMI6ybJmQWULfW/VVRUBzWmQ
         SM4oCjNfSpw/VzyewtgG27RvsRx6Qm95P/4RVZeUJxF0mSwXueDIsEc8k7Z+xdH33H
         wBP245lHiSdgeanuwcviZiMqSWWxeliuLs93XuB8=
Date:   Wed, 16 Sep 2020 08:29:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Prateek Sood <prsood@codeaurora.org>,
        Takashi Iwai <tiwai@suse.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/177] 5.8.10-rc1 review
Message-ID: <20200916062958.GH142621@kroah.com>
References: <20200915140653.610388773@linuxfoundation.org>
 <b94c29b3-ef68-897b-25a8-e6fcc181a22a@linuxfoundation.org>
 <8277900f-d300-79fa-eac7-096686a6fbc3@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8277900f-d300-79fa-eac7-096686a6fbc3@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 08:54:24PM -0600, Shuah Khan wrote:
> On 9/15/20 3:06 PM, Shuah Khan wrote:
> > On 9/15/20 8:11 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.8.10 release.
> > > There are 177 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.10-rc1.gz
> > > 
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > linux-5.8.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > 
> > Compiled and booted fine. wifi died:
> > 
> > ath10k_pci 0000:02:00.0: could not init core (-110)
> > ath10k_pci 0000:02:00.0: could not probe fw (-110)
> > 
> > This is regression from 5.8.9 and 5.9-rc5 works just fine.
> > 
> > I will try to bisect later this evening to see if I can isolate the
> > commit.
> > 
> 
> The following commit is what caused ath10k_pci driver problem
> that killed wifi.
> 
> Prateek Sood <prsood@codeaurora.org>
>     firmware_loader: fix memory leak for paged buffer
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.8.y&id=ec0a59266c9c9f46037efd3dcc0323973e102271

Ugh, that's not good, is this also a problem in 5.9-rc5 as well?  For
reference, this is commit 4965b8cd1bc1 ("firmware_loader: fix memory
leak for paged buffer") in Linus's tree.

And it should be showing up in 5.4.y at the moment too, as this patch is
in that tree right now...

odd,

greg k-h
