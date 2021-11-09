Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CADA44A6D5
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 07:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhKIGae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 01:30:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229990AbhKIGad (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 01:30:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D15C76109D;
        Tue,  9 Nov 2021 06:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636439268;
        bh=TiMVlvOfbcxj2/gi7PHUh70vijF2v/Noe4mO/P7fIw4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QzQr8gjMHOGuL9M8iFlRKJ0UefA4aZreVS3RDvbqPKMQJ//6pmDT4xblyLVJ8S1y1
         qWnoiRf2YQgb5CpTNg7772bT7wAEvLLATUnrS9mjn9XNSpEsE3I8ETWZP1IXSDJvZr
         UXcRxN84hlvppgfBCAg3X741unEqxu+fdJjBSfnM=
Date:   Tue, 9 Nov 2021 07:27:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yi Fan <yfa@google.com>
Cc:     stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@google.com>,
        shreyas.joshi@biamp.com, Joshua Levasseur <jlevasseur@google.com>,
        pmladek@suse.com, sashal@kernel.org
Subject: Re: null console related kerne performance issue
Message-ID: <YYoU19O/NNb9uZ5x@kroah.com>
References: <CA+DW03VfQpOJUWAM9CZMCM4Vkw8KVbNWAxgsq-g615QPz_3=YQ@mail.gmail.com>
 <CA+DW03WPM1b_01eNB3cE7kVsp+tRbzv-O-=TvX627ATOUSywBQ@mail.gmail.com>
 <YYQsw+GBLr1WXidM@kroah.com>
 <CA+DW03WkHiq1tpfVJ33onMytp-0AmqTYGcvtNwdkzwxm+7qpQA@mail.gmail.com>
 <YYjZIxabCA95Lvbw@kroah.com>
 <CA+DW03X8mAPq7-z6ts0zYqvPeOZpFyqVyC8pEyaAyUdPfcGorQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+DW03X8mAPq7-z6ts0zYqvPeOZpFyqVyC8pEyaAyUdPfcGorQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 08, 2021 at 11:17:07AM -0800, Yi Fan wrote:
> On Mon, Nov 8, 2021 at 12:00 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Nov 04, 2021 at 12:40:32PM -0700, Yi Fan wrote:
> > > Reply inline.
> > >
> > > On Thu, Nov 4, 2021 at 11:56 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Thu, Nov 04, 2021 at 11:14:55AM -0700, Yi Fan wrote:
> > > > > Resend the email using plain text.
> > > > >
> > > > > I found some kernel performance regression issues that might be
> > > > > related w/ 4.14.y LTS commit.
> > > > >
> > > > > 4.14.y commit: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.14.253&id=27d185697322f9547bfd381c71252ce0bc1c0ee4
> > > > >
> > > > > The issue is observed when "console=" is used as a kernel parameter to
> > > > > disable the kernel console.
> > > >
> > > > What exact "performance issue" are you seeing?
> > > >
> > > [YF] one kernel thread was randomly blocked for more than ~40
> > > milliseconds, causing a certain task to fail to process in time.
> > > [YF] the issue is highly random on a single device. But it might
> > > happen a few times per 24 hours on a certain percentage of devices.
> > > The overall percentage of devices that show the issue seems quite
> > > stable over a long period of time (somehow the magic number is ~40%.).
> > > [YF] local test on a pool of devices does not show any correlation w/
> > > any particular devices.
> > > [YF] local test after reverting the above single commit passes, no
> > > issue is observed.
> >
> > And what type of device is this?
> [YF] it happens on multiple devices on the 4.14.y kernel. (sorry
> cannot disclose the device type here.)

That's not helpful :(

Can you say "server" or "tiny device you hold in your hand"?

How about architecture type?

> > If you see this thread:
> >         https://lore.kernel.org/r/f19c18fd-20b3-b694-5448-7d899966a868@roeck-us.net
> > it looks like chromeos devices have now disabled this change, and there
> > was a long discussion about possible issues and solutions.
> >
> > Can you try the patch set referenced in that thread to see if that
> > resolves the issue for you or not?  Given that I have not seen any
> > reports of this being an issue since over a year ago, odds are it has
> > been resolved already with some change that we probably also need to
> > backport to 4.14.y.
> >
> > So any help in identifying that change would be appreciated.
> >
> 
> [YF] thanks for the context. I did not find a clear patch that seems
> to solve this issue yet.
> [YF] for the time being, reverting the offending commit seems the
> safest solution for the 4.14.y.

What about for the 4.19.y kernel tree?  Why is this limited to just
4.14.y?

Can you send a patch that reverts this from 4.14 that explains why it
should be removed?

thanks,

greg k-h
