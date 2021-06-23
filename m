Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3EF73B1491
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 09:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhFWHaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 03:30:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhFWHaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 03:30:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FC0D61076;
        Wed, 23 Jun 2021 07:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624433264;
        bh=MfGpAhkgNAsV4Gs6J3HXShXQ6oCjPOD50RyhMvI5TIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VL3P8zhD1J20JIY2+okRVn52pWiyX0awT2ZEVB1iqKyPEBYhY9PaQjYqUQzPkriup
         d9d1+2/QNqASXUYg+5eheF++kEPxPVMbHSwrOsoBQbv/e3FSK+pudi4Plpyu9fxbpe
         GV+0b11T757IsJ8cMWyS/7IkjBHHTatjN+TCeVsw=
Date:   Wed, 23 Jun 2021 09:27:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Siddharth Gupta <sidgup@codeaurora.org>
Cc:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 1/4] remoteproc: core: Move cdev add before device add
Message-ID: <YNLibU0/kMfZ3Hio@kroah.com>
References: <1623723671-5517-1-git-send-email-sidgup@codeaurora.org>
 <1623723671-5517-2-git-send-email-sidgup@codeaurora.org>
 <YMgy7eg3wde0eVfe@kroah.com>
 <0a196786-f624-d9bb-8ef9-55c04ed57497@codeaurora.org>
 <YMmTGD6hAKbpGWMp@kroah.com>
 <f81acd52-fe59-a296-b221-febbf8281606@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f81acd52-fe59-a296-b221-febbf8281606@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 11:47:01AM -0700, Siddharth Gupta wrote:
> 
> On 6/15/2021 10:58 PM, Greg KH wrote:
> > On Tue, Jun 15, 2021 at 12:03:26PM -0700, Siddharth Gupta wrote:
> > > On 6/14/2021 9:56 PM, Greg KH wrote:
> > > > On Mon, Jun 14, 2021 at 07:21:08PM -0700, Siddharth Gupta wrote:
> > > > > When cdev_add is called after device_add has been called there is no
> > > > > way for the userspace to know about the addition of a cdev as cdev_add
> > > > > itself doesn't trigger a uevent notification, or for the kernel to
> > > > > know about the change to devt. This results in two problems:
> > > > >    - mknod is never called for the cdev and hence no cdev appears on
> > > > >      devtmpfs.
> > > > >    - sysfs links to the new cdev are not established.
> > > > > 
> > > > > The cdev needs to be added and devt assigned before device_add() is
> > > > > called in order for the relevant sysfs and devtmpfs entries to be
> > > > > created and the uevent to be properly populated.
> > > > So this means no one ever ran this code on a system that used devtmpfs?
> > > > 
> > > > How was it ever tested?
> > > My testing was done with toybox + Android's ueventd ramdisk.
> > > As I mentioned in the discussion, the race became evident
> > > recently. I will make sure to test all such changes without
> > > systemd/ueventd in the future.
> > It isn't an issue of systemd/ueventd, those do not control /dev on a
> > normal system, that is what devtmpfs is for.
> I am not fully aware of when devtmpfs is enabled or not, but in
> case it is not - systemd/ueventd will create these files with
> mknod, right?

No, systemd does not create device nodes, and neither does udev.  Hasn't
done so for well over 10 years now.

> I was even manually able to call mknod from the
> terminal when some of the remoteproc character device entries
> showed up (using major number from there, and minor number being
> the remoteproc id), and that allowed me to boot up the
> remoteprocs as well.

Yes, that is fine, but that also means that this was not working from
the very beginning :(

> > And devtmpfs nodes are only created if you create a struct device
> > somewhere with a proper major/minor, which you were not doing here, so
> > you must have had a static /dev on your test systems, right?
> I am not sure of what you mean by a static /dev? Could you
> explain? In case you mean the character device would be
> non-functional, that is not the case. They have been working
> for us since the beginning.

/dev on modern systems is managed by devtmpfs, which knows to create the
device nodes when you properly register the device with the driver core.
A "static" /dev is managed by mknod from userspace, like you did "by
hand", and that is usually only done by older systems.

thanks,

greg k-h
