Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE203132E4
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 14:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhBHNEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 08:04:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229993AbhBHNEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 08:04:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E25664DEE;
        Mon,  8 Feb 2021 13:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612789410;
        bh=bETiuTGyJzRrkPM08sFMEeeymGXeVkr5IZqwRHPvyuk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ghDqYqgIHwdgMylS8xDfalMdh0lwSDhYYj9PatglZwRF/yuzcobiCOvBvBKYi6Naz
         ntHzmE9EewGbXLu3tb2Nyqd2eHOIkck24IhG3wl3tjW+mpfa4eeLVdYR2P8g8VKQG5
         YmHWJtO0MNPYVCsJDM+bB2ti77mWzrsWj2wplxzc=
Date:   Mon, 8 Feb 2021 14:03:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: Linux 4.9.256
Message-ID: <YCE2nw66fHfk6lFt@kroah.com>
References: <1612535085125226@kroah.com>
 <87czxa3efr.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czxa3efr.fsf@oldenburg.str.redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 01:57:12PM +0100, Florian Weimer wrote:
> * Greg Kroah-Hartman:
> 
> > I'm announcing the release of the 4.9.256 kernel.
> >
> > This, and the 4.4.256 release are a little bit "different" than normal.
> >
> > This contains only 1 patch, just the version bump from .255 to .256 which ends
> > up causing the userspace-visable LINUX_VERSION_CODE to behave a bit differently
> > than normal due to the "overflow".
> >
> > With this release, KERNEL_VERSION(4, 9, 256) is the same as KERNEL_VERSION(4, 10, 0).
> >
> > Nothing in the kernel build itself breaks with this change, but given
> > that this is a userspace visible change, and some crazy tools (like
> > glibc and gcc) have logic that checks the kernel version for different
> > reasons, I wanted to do this release as an "empty" release to ensure
> > that everything still works properly.
> 
> I'm looking at this from a glibc perspective.  glibc took the
> KERNEL_VERSION definition and embedded the bit layout into the
> /etc/ld.so.cache, as part of the file format.  Exact impact is still
> unclear at this point.

If we "cap" this at 4, 9, 255 according to what userspace sees, will
that be a problem if we increase the number reported by uname(2)?

And when is the ld.so.cache file "regenerated"?

thanks,

greg k-h
