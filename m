Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5000B44B056
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 16:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbhKIPbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 10:31:42 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:38364 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbhKIPbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 10:31:42 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id AA53B1FD34;
        Tue,  9 Nov 2021 15:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636471735; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bYZvCk7TC17nhUsmytlsyV1+O84D0RZ9WWJ4pcFTE5E=;
        b=Uv8GPUMJjq19g1cjPc1tzRmtDg+zmq/KcvQo53xEEcu6iUSt3sops3hmq8XekBuy2gku7t
        m+wXUHBtwZZ83LWcQGsH3Z+jy+MssfNwMyiAtkvJczE+Rx4EQlOEFMYVe47sP9XJIMKYXo
        OmaN9B7D2OJzbHDbp7NlV4Ji8r75x24=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 88042A3B83;
        Tue,  9 Nov 2021 15:28:55 +0000 (UTC)
Date:   Tue, 9 Nov 2021 16:28:55 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Yi Fan <yfa@google.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@google.com>,
        shreyas.joshi@biamp.com, Joshua Levasseur <jlevasseur@google.com>,
        sashal@kernel.org
Subject: Re: null console related kerne performance issue
Message-ID: <YYqTt27ZGutMJyZc@alley>
References: <CA+DW03VfQpOJUWAM9CZMCM4Vkw8KVbNWAxgsq-g615QPz_3=YQ@mail.gmail.com>
 <CA+DW03WPM1b_01eNB3cE7kVsp+tRbzv-O-=TvX627ATOUSywBQ@mail.gmail.com>
 <YYQsw+GBLr1WXidM@kroah.com>
 <CA+DW03WkHiq1tpfVJ33onMytp-0AmqTYGcvtNwdkzwxm+7qpQA@mail.gmail.com>
 <YYjZIxabCA95Lvbw@kroah.com>
 <CA+DW03X8mAPq7-z6ts0zYqvPeOZpFyqVyC8pEyaAyUdPfcGorQ@mail.gmail.com>
 <YYoU19O/NNb9uZ5x@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYoU19O/NNb9uZ5x@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 2021-11-09 07:27:35, Greg KH wrote:
> On Mon, Nov 08, 2021 at 11:17:07AM -0800, Yi Fan wrote:
> > On Mon, Nov 8, 2021 at 12:00 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Nov 04, 2021 at 12:40:32PM -0700, Yi Fan wrote:
> > > > Reply inline.
> > > >
> > > > On Thu, Nov 4, 2021 at 11:56 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Thu, Nov 04, 2021 at 11:14:55AM -0700, Yi Fan wrote:
> > > > > > Resend the email using plain text.
> > > > > >
> > > > > > I found some kernel performance regression issues that might be
> > > > > > related w/ 4.14.y LTS commit.
> > > > > >
> > > > > > 4.14.y commit: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.14.253&id=27d185697322f9547bfd381c71252ce0bc1c0ee4
> > > > > >
> > > > > > The issue is observed when "console=" is used as a kernel parameter to
> > > > > > disable the kernel console.

I think that I see the problem. linux-4.14.y stable branch currently
ignores "console=" parameter. As a result, a console (ttyX) is enabled
by default.

> > > > > What exact "performance issue" are you seeing?
> > > > >
> > > > [YF] one kernel thread was randomly blocked for more than ~40
> > > > milliseconds, causing a certain task to fail to process in time.
> > > > [YF] the issue is highly random on a single device. But it might
> > > > happen a few times per 24 hours on a certain percentage of devices.
> > > > The overall percentage of devices that show the issue seems quite
> > > > stable over a long period of time (somehow the magic number is ~40%.).
> > > > [YF] local test on a pool of devices does not show any correlation w/
> > > > any particular devices.

This might happen when there is a flood of messages to be printed to
the console. It does not happen when there is no console.

It has been fixed by the upstream commit 3cffa06aeef7ece30f6b5ac0
("printk/console: Allow to disable console output by using  console=""
or console=null")

The fix needs some tweaking for the stable branches because
__add_preferred_console() has gained more parameters over time.

It seems that all longterm stable branches are affected. I am going
to prepare the backports.

Best Regards,
Petr
