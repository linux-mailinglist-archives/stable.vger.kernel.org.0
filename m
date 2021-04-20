Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2861365340
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 09:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbhDTHbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 03:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:32900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhDTHbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 03:31:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17F6560238;
        Tue, 20 Apr 2021 07:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618903841;
        bh=RjgDDmSmn1Y8IjygmfRp4thRkMJvX2QH8MmocohwXME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hUoinyJGjR11NJ1KwqOPX9QcsnakHr37jb1DgwzPc+egToqjNI7M4L2RnMmd+ghLo
         mln82/f8Ma3aibUSwM+MCZvszlhuY9PQzrE+N3jAs5eGhxb1QrSYslIcLlascG4fl6
         7Aaevu7aTMAEeE9+I9W85ydGZD9jGOSXP7JTuxCU=
Date:   Tue, 20 Apr 2021 09:30:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Tom Seewald <tseewald@gmail.com>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] usbip: add sysfs_lock to synchronize sysfs code paths
Message-ID: <YH6DHgl9wODpX1Fl@kroah.com>
References: <20210416205319.14075-1-tseewald@gmail.com>
 <ea81015d-79f3-f22e-0b96-e0ae58acfc14@linuxfoundation.org>
 <YH12XjHqkH66HgdC@kroah.com>
 <9b401378-1acd-fd5b-a7b9-4ec6a1ee777f@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b401378-1acd-fd5b-a7b9-4ec6a1ee777f@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 03:42:06PM -0600, Shuah Khan wrote:
> On 4/19/21 6:23 AM, Greg Kroah-Hartman wrote:
> > On Fri, Apr 16, 2021 at 03:43:45PM -0600, Shuah Khan wrote:
> > > On 4/16/21 2:53 PM, Tom Seewald wrote:
> > > > From: Shuah Khan <skhan@linuxfoundation.org>
> > > > 
> > > > commit 4e9c93af7279b059faf5bb1897ee90512b258a12 upstream.
> > > > 
> > > > Fuzzing uncovered race condition between sysfs code paths in usbip
> > > > drivers. Device connect/disconnect code paths initiated through
> > > > sysfs interface are prone to races if disconnect happens during
> > > > connect and vice versa.
> > > > 
> > > > This problem is common to all drivers while it can be reproduced easily
> > > > in vhci_hcd. Add a sysfs_lock to usbip_device struct to protect the paths.
> > > > 
> > > > Use this in vhci_hcd to protect sysfs paths. For a complete fix, usip_host
> > > > and usip-vudc drivers and the event handler will have to use this lock to
> > > > protect the paths. These changes will be done in subsequent patches.
> > > > 
> > > > Cc: stable@vger.kernel.org # 4.9.x
> > > > Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
> > > > Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> > > > Link: https://lore.kernel.org/r/b6568f7beae702bbc236a545d3c020106ca75eac.1616807117.git.skhan@linuxfoundation.org
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Signed-off-by: Tom Seewald <tseewald@gmail.com>
> > > > ---
> > > >    drivers/usb/usbip/usbip_common.h |  3 +++
> > > >    drivers/usb/usbip/vhci_hcd.c     |  1 +
> > > >    drivers/usb/usbip/vhci_sysfs.c   | 30 +++++++++++++++++++++++++-----
> > > >    3 files changed, 29 insertions(+), 5 deletions(-)
> > > > 
> > > 
> > > Thank you for the backport.
> > > 
> > > Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
> > > 
> > > Greg, please pick this up for 4.9.x
> > 
> > Also for 4.14.y, right?
> > 
> 
> It made it into 4.14 already. We are good with 4.14.y
> 
> 5f2a149564ee2b41ab09e90add21153bd5be64d3

Ugh, sorry, my fault, I hadn't updated my "what was released in what
stable version" on my laptop that I was working from yesterday.  They
are obviously all merged in 4.14 :(

Thanks for this.

greg k-h
