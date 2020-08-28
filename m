Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE67255EC0
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 18:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgH1Q0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 12:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbgH1Q0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Aug 2020 12:26:42 -0400
Received: from localhost (104.sub-72-107-126.myvzw.com [72.107.126.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 765D22080C;
        Fri, 28 Aug 2020 16:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598632001;
        bh=4Vnh1C/RoVVBKrT7SjMj6aee4KReTZw02BiPUaRhAQ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=QVOV/M0eLCw2BVGQp4zvew/mE1Q4RL7hiEsH79cNpyPCxwSZe05WMETsy+9Db+hDj
         sKvWOaB1vh6jVlK2lN5CmqNofr7zadr76rZ5qfeZphI3NzUxMq7O8ZX0a8uuo4+Hex
         1gmGg+jCAvGxgygQHK+NpsxfUpiX7u90xwPUIC7M=
Date:   Fri, 28 Aug 2020 11:26:40 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jean Delvare <jdelvare@suse.de>
Cc:     Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>
Subject: Re: [PATCH 1/2] i2c: i801: Fix runtime PM
Message-ID: <20200828162640.GA2160001@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180627212340.GA161569@bhelgaas-glaptop.roam.corp.google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+cc Vaibhav]

On Wed, Jun 27, 2018 at 04:23:40PM -0500, Bjorn Helgaas wrote:
> [+cc Rafael, linux-pm, linux-kernel]
> 
> On Wed, Jun 27, 2018 at 10:15:50PM +0200, Jean Delvare wrote:
> > Hi Jarkko,
> > 
> > On Tue, 26 Jun 2018 17:39:12 +0300, Jarkko Nikula wrote:
> > > Commit 9c8088c7988 ("i2c: i801: Don't restore config registers on
> > > runtime PM") nullified the runtime PM suspend/resume callback pointers
> > > while keeping the runtime PM enabled. This causes that device stays in
> > > D0 power state and sysfs /sys/bus/pci/devices/.../power/runtime_status
> > > shows "error" when runtime PM framework attempts to autosuspend the
> > > device.
> > > 
> > > This is due PCI bus runtime PM which checks for driver runtime PM
> > > callbacks and returns with -ENOSYS if they are not set. Fix this by
> > > having a shared dummy runtime PM callback that returns with success.
> > > 
> > > Fixes: a9c8088c7988 ("i2c: i801: Don't restore config registers on runtime PM")
> > 
> > I don't want to sound like I'm trying to decline all responsibility for
> > a regression I caused, but frankly, if just using SIMPLE_DEV_PM_OPS()
> > breaks runtime PM, then it's the PM model which is broken, not the
> > i2c-i801 driver.
> > 
> > I will boldly claim that the PCI bus runtime code is simply wrong in
> > returning -ENOSYS in the absence of runtime PM callbacks, and it should
> > be changed to return 0 instead. Or whoever receives that -ENOSYS should
> > not treat it as an error - whatever makes more sense.
> > 
> > Having to add dummy functions in every PCI driver that doesn't need to
> > do anything special for runtime PM sounds plain stupid. It should be
> > pretty obvious that a whole lot of drivers are going to use
> > SIMPLE_DEV_PM_OPS() because it exists and seems to do what they want,
> > and all of them will be bugged because the PCI core is doing something
> > silly and unexpected.
> > 
> > So please let's fix it at the PCI subsystem core level. Adding Bjorn
> > and the linux-pci list to Cc.
> 
> Thanks Jean.  What you describe does sound broken.  I think the PM
> guys (cc'd) will have a better idea of how to deal with this.

Did we ever get anywhere with this?  It seems like the thread petered
out.
