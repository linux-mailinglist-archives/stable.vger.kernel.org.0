Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77E624D13F
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 11:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgHUJOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 05:14:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbgHUJOv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 05:14:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACA6B20732;
        Fri, 21 Aug 2020 09:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598001291;
        bh=ERSQV8sBOM057rO5On9HvFosogyUK9w7fG9VUpjBiKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kO5pfl3oaqNdxAXB5uZ7cdYVPc4LBJovEFWW2R5ZjdDfaIXCAcov9t3cVZIVd5Ova
         u5yUKkEtGL4oQ16V+bhcoOF2KIIEFyNstz3yPScxSC0zBUMswOeQKpDFnn+F5g7f8m
         Nav72BwJFXnfImeKCgjLnurNtXF6XG4u06jiPCVE=
Date:   Fri, 21 Aug 2020 11:15:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 83/92] mfd: dln2: Run event handler loop under
 spinlock
Message-ID: <20200821091510.GA1894407@kroah.com>
References: <20200820091537.490965042@linuxfoundation.org>
 <20200820091541.964627271@linuxfoundation.org>
 <20200821072123.GC23823@amd>
 <CAHp75Vcbmc-PV-gQxuj9i8sAcFCzhJKe_qzEfrkUTZbnf3Vupg@mail.gmail.com>
 <20200821091416.GA1894114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821091416.GA1894114@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 11:14:16AM +0200, Greg Kroah-Hartman wrote:
> On Fri, Aug 21, 2020 at 12:06:45PM +0300, Andy Shevchenko wrote:
> > On Fri, Aug 21, 2020 at 10:26 AM Pavel Machek <pavel@denx.de> wrote:
> > > > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > >
> > > > [ Upstream commit 3d858942250820b9adc35f963a257481d6d4c81d ]
> > > >
> > > > The event handler loop must be run with interrupts disabled.
> > > > Otherwise we will have a warning:
> > > ...
> > > > Recently xHCI driver switched to tasklets in the commit 36dc01657b49
> > > > ("usb: host: xhci: Support running urb giveback in tasklet
> > > > context").
> > >
> > > AFAICT, 36dc01657b49 is not included in 4.19.141, so this commit
> > > should not be needed, either.
> > 
> > I'm wondering if there are any other USB host controller drivers that
> > use URB giveback in interrupt enabled context.
> 
> Almost all do.

Sorry, read that the wrong way, most have interrupts disabled, so this
change should be fine.

thanks,

greg k-h
