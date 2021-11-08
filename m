Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F691447B7D
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 09:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237378AbhKHIDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 03:03:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230103AbhKHIDW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 03:03:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 051B161208;
        Mon,  8 Nov 2021 08:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636358438;
        bh=tqu30Ls3jqH8qP5ybm2cZPk6iDQyP34VG7dzFK8+5aQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kqj7QUntQ+MW+zxPP2ODUephaHgoAPJCfUWEWB1zQyPoaCv5ZCYJBeVVtIew/2uQE
         2t/g9s/jT7gCoRCCu2b7lwlqa/L0N4Qsr05ga4PagRcY62fuc2HFY6ovssuPxvWFxI
         GNj4/bDVQ9RP3RUzic4xE6whu3vifl2BHu1oTUoY=
Date:   Mon, 8 Nov 2021 09:00:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yi Fan <yfa@google.com>
Cc:     stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@google.com>,
        shreyas.joshi@biamp.com, Joshua Levasseur <jlevasseur@google.com>,
        pmladek@suse.com, sashal@kernel.org
Subject: Re: null console related kerne performance issue
Message-ID: <YYjZIxabCA95Lvbw@kroah.com>
References: <CA+DW03VfQpOJUWAM9CZMCM4Vkw8KVbNWAxgsq-g615QPz_3=YQ@mail.gmail.com>
 <CA+DW03WPM1b_01eNB3cE7kVsp+tRbzv-O-=TvX627ATOUSywBQ@mail.gmail.com>
 <YYQsw+GBLr1WXidM@kroah.com>
 <CA+DW03WkHiq1tpfVJ33onMytp-0AmqTYGcvtNwdkzwxm+7qpQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+DW03WkHiq1tpfVJ33onMytp-0AmqTYGcvtNwdkzwxm+7qpQA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 12:40:32PM -0700, Yi Fan wrote:
> Reply inline.
> 
> On Thu, Nov 4, 2021 at 11:56 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Nov 04, 2021 at 11:14:55AM -0700, Yi Fan wrote:
> > > Resend the email using plain text.
> > >
> > > I found some kernel performance regression issues that might be
> > > related w/ 4.14.y LTS commit.
> > >
> > > 4.14.y commit: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.14.253&id=27d185697322f9547bfd381c71252ce0bc1c0ee4
> > >
> > > The issue is observed when "console=" is used as a kernel parameter to
> > > disable the kernel console.
> >
> > What exact "performance issue" are you seeing?
> >
> [YF] one kernel thread was randomly blocked for more than ~40
> milliseconds, causing a certain task to fail to process in time.
> [YF] the issue is highly random on a single device. But it might
> happen a few times per 24 hours on a certain percentage of devices.
> The overall percentage of devices that show the issue seems quite
> stable over a long period of time (somehow the magic number is ~40%.).
> [YF] local test on a pool of devices does not show any correlation w/
> any particular devices.
> [YF] local test after reverting the above single commit passes, no
> issue is observed.

And what type of device is this?

If you see this thread:
	https://lore.kernel.org/r/f19c18fd-20b3-b694-5448-7d899966a868@roeck-us.net
it looks like chromeos devices have now disabled this change, and there
was a long discussion about possible issues and solutions.

Can you try the patch set referenced in that thread to see if that
resolves the issue for you or not?  Given that I have not seen any
reports of this being an issue since over a year ago, odds are it has
been resolved already with some change that we probably also need to
backport to 4.14.y.

So any help in identifying that change would be appreciated.

> > And what kernel version are you seeing it on?
> >
> [YF] it was first found on some products w/ kernel version 4.14.210.
> through bisection, we located the commit on 4.14.200.
> 
> > > I browsed android common kernel logs and the upstream stable kernel
> > > tree, found some related changes.
> > >
> > > printk: handle blank console arguments passed in. (link:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.14.15&id=3cffa06aeef7ece30f6b5ac0ea51f264e8fea4d0)
> > > Revert "init/console: Use ttynull as a fallback when there is no
> > > console" (link:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.14.15&id=a91bd6223ecd46addc71ee6fcd432206d39365d2)
> > >
> > > It looks like upstream also noticed the regression introduced by the
> > > commit, and the workaround is to use "ttynull" to handle "console="
> > > case. But the "ttynull" was reverted due to some other reasons
> > > mentioned in the commit message.
> > >
> > > Any insight or recommendation will be appreciated.
> >
> > What problem exactly are you now seeing?  And does it also happen on
> > 5.15?
> >
> [YF] we do not perform any tests on 5.15 yet. so no idea about whether
> the issue happens on 5.15.

How about any other newer stable kernel version like 5.4.y or 5.10.y?

thanks,

greg k-h
