Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7265936419E
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 14:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239183AbhDSMYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 08:24:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233749AbhDSMYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 08:24:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C8EE61284;
        Mon, 19 Apr 2021 12:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618835048;
        bh=PnLkcUvmeLpTmVtCYg4PVDQByf5ZTCOEknbtDZL9yUA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MU0ol+iOdZQlMMpEL8sEslV/hWUMi0K5KY3ZDZqrttRKrpzmEXpkt9cHVF2MjeStM
         nUwevVAdLXNNhq3gAG3r/rNYo8hbQtypZf9ba/o+aZfm82jpzHLFd4b4HXVR3TD0Oj
         2nnIqgxKplPoISiJhqz0xP6XO50zTXIx1v98ZyHQ=
Date:   Mon, 19 Apr 2021 14:23:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Tom Seewald <tseewald@gmail.com>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] usbip: add sysfs_lock to synchronize sysfs code paths
Message-ID: <YH12XjHqkH66HgdC@kroah.com>
References: <20210416205319.14075-1-tseewald@gmail.com>
 <ea81015d-79f3-f22e-0b96-e0ae58acfc14@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea81015d-79f3-f22e-0b96-e0ae58acfc14@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 16, 2021 at 03:43:45PM -0600, Shuah Khan wrote:
> On 4/16/21 2:53 PM, Tom Seewald wrote:
> > From: Shuah Khan <skhan@linuxfoundation.org>
> > 
> > commit 4e9c93af7279b059faf5bb1897ee90512b258a12 upstream.
> > 
> > Fuzzing uncovered race condition between sysfs code paths in usbip
> > drivers. Device connect/disconnect code paths initiated through
> > sysfs interface are prone to races if disconnect happens during
> > connect and vice versa.
> > 
> > This problem is common to all drivers while it can be reproduced easily
> > in vhci_hcd. Add a sysfs_lock to usbip_device struct to protect the paths.
> > 
> > Use this in vhci_hcd to protect sysfs paths. For a complete fix, usip_host
> > and usip-vudc drivers and the event handler will have to use this lock to
> > protect the paths. These changes will be done in subsequent patches.
> > 
> > Cc: stable@vger.kernel.org # 4.9.x
> > Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
> > Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> > Link: https://lore.kernel.org/r/b6568f7beae702bbc236a545d3c020106ca75eac.1616807117.git.skhan@linuxfoundation.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Tom Seewald <tseewald@gmail.com>
> > ---
> >   drivers/usb/usbip/usbip_common.h |  3 +++
> >   drivers/usb/usbip/vhci_hcd.c     |  1 +
> >   drivers/usb/usbip/vhci_sysfs.c   | 30 +++++++++++++++++++++++++-----
> >   3 files changed, 29 insertions(+), 5 deletions(-)
> > 
> 
> Thank you for the backport.
> 
> Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> Greg, please pick this up for 4.9.x

Also for 4.14.y, right?
