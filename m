Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCC5279720
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 07:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgIZFhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 01:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgIZFhO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Sep 2020 01:37:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C85420809;
        Sat, 26 Sep 2020 05:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601098634;
        bh=m/+tCMsoktPttAD5uC/qPyGIB/ngsvXNkpn4LVvCSgo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xcpsyZ/UDbKYYe7TAm9kwyeAXJSkcdJwjmwGqcuIX9J2S28Rgk1+r/1bw/+iwH2Oq
         ploFkCNM3jemJlN+6KSU82cq2fg6EdLzMr/oSclVnX/O+Y42YeyW+DYxWbFFBo85u7
         yvSFvTxY2jYxtKaIxd7zYa5EoDQx+hpvJZSmIsRg=
Date:   Sat, 26 Sep 2020 07:37:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "M. Vefa Bicakci" <m.v.b@runbox.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Bastien Nocera <hadess@hadess.net>,
        Shuah Khan <shuah@kernel.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        syzkaller@googlegroups.com
Subject: Re: [PATCH v3 3/4] usbcore/driver: Fix incorrect downcast
Message-ID: <20200926053710.GA630745@kroah.com>
References: <20200922110703.720960-1-m.v.b@runbox.com>
 <20200922110703.720960-4-m.v.b@runbox.com>
 <20200925145118.GA3114228@kroah.com>
 <40bf9432-d878-5c16-2dc1-3f03964a8057@runbox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40bf9432-d878-5c16-2dc1-3f03964a8057@runbox.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 25, 2020 at 07:31:44PM +0300, M. Vefa Bicakci wrote:
> On 9/25/20 5:51 PM, Greg Kroah-Hartman wrote:
> > On Tue, Sep 22, 2020 at 02:07:02PM +0300, M. Vefa Bicakci wrote:
> > > This commit resolves a minor bug in the selection/discovery of more
> > > specific USB device drivers for devices that are currently bound to
> > > generic USB device drivers.
> > > 
> > > The bug is related to the way a candidate USB device driver is
> > > compared against the generic USB device driver. The code in
> > > is_dev_usb_generic_driver() assumes that the device driver in question
> > > is a USB device driver by calling to_usb_device_driver(dev->driver)
> > > to downcast; however I have observed that this assumption is not always
> > > true, through code instrumentation.
> > > 
> > > This commit avoids the incorrect downcast altogether by comparing
> > > the USB device's driver (i.e., dev->driver) to the generic USB
> > > device driver directly. This method was suggested by Alan Stern.
> > > 
> > > This bug was found while investigating Andrey Konovalov's report
> > > indicating usbip device driver misbehaviour with the recently merged
> > > generic USB device driver selection feature. The report is linked
> > > below.
> > > 
> > > Fixes: d5643d2249 ("USB: Fix device driver race")
> > 
> > Nit, this should have been:
> > 	Fixes: d5643d2249b2 ("USB: Fix device driver race")
> > 
> > I'll go fix it up as my scripts are rejecting it as-is...
> 
> Noted; sorry for missing this. I will use 12 characters from now on.

No worries.  There's a nice git configuration line you can do that is
documented in the submitting patches file in the kernel documentation
directory, if you want to use that.  I have a alias that does it easily
as well as it gets annoying to have to type:

	git show -s --abbrev-commit --abbrev=12 --pretty=format:"%h (\"%s\")%n"

A lot :)

> I also wanted to thank you for committing the patches.

Thanks for fixing this all up!

greg k-h
