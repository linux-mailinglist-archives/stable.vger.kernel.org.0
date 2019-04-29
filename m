Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9A0E434
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 16:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbfD2OEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 10:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbfD2OEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 10:04:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE09A20652;
        Mon, 29 Apr 2019 14:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556546691;
        bh=WjLzG0YBcfKioIVvSYzjSt09wCG00ZuAs3SjhBceggg=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=R8LewGLo4SaW7njZJRXs2oV+2KXZuC0YNvuTR6NKfVX/5S2YaOBcSfcZKQomgRgmq
         pII805pGeKPfpYE5MSLFHt+aRWSMvaZM68HmqRGAwIrbOkflVzz03AGT4K1jEqwzXt
         yiHL9VfuRd+wLjxjkdbE7mbCckwZlnxzNphXDWv0=
Date:   Mon, 29 Apr 2019 16:04:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        928125@bugs.debian.org, Brad Barnett <debian-bugs2@l8r.net>
Subject: Re: Revert commit 310ca162d77
Message-ID: <20190429140449.GA8525@kroah.com>
References: <20190320125806.GD9485@quack2.suse.cz>
 <20190429120542.wybwf5vqwzhv6nkf@lorien.valinor.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429120542.wybwf5vqwzhv6nkf@lorien.valinor.li>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 02:05:42PM +0200, Salvatore Bonaccorso wrote:
> Hi Jan, hi Greg,
> 
> On Wed, Mar 20, 2019 at 01:58:06PM +0100, Jan Kara wrote:
> > Hello,
> > 
> > commit 310ca162d77 "block/loop: Use global lock for ioctl() operation." has
> > been pushed to multiple stable trees. This patch is a part of larger series
> > that overhauls the locking inside loopback device upstream and for 4.4,
> > 4.9, and 4.14 stable trees only this patch from the series is applied. Our
> > testing now has shown [1] that the patch alone makes present deadlocks
> > inside loopback driver more likely (the openqa test in our infrastructure
> > didn't hit the deadlock before whereas with the new kernel it hits it
> > reliably every time). So I would suggest we revert 310ca162d77 from 4.4,
> > 4.9, and 4.14 kernels.
> 
> A user in Debian reported [1], providing the following testcase which showed up
> after the recent update to 4.9.168-1 in Debian stretch (based on upstream
> v4.9.168) as follows:
> 
> 	dd if=/dev/zero of=/tmp/ff1.raw bs=1G seek=8 count=0
> 	sync
> 	sleep 1
> 	parted /tmp/ff1.raw mklabel msdos
> 	parted -s /tmp/ff1.raw mkpart primary linux-swap 1 100
> 	parted -s -- /tmp/ff1.raw mkpart primary ext2 101 -1
> 	parted -s -- /tmp/ff1.raw set 2 boot on
> 	sleep 5
> 	losetup -Pf /tmp/ff1.raw --show
> 
> I have verified that the same happens with v4.9.171 where the mentioned commit
> was not reverted, and bisecting of the testcase showed it was introduced with
> 3ae3d167f5ec2c7bb5fcd12b7772cfadc93b2305 (v4.9.152~9) (which is the backport of
> 310ca162d77 for 4.9).
> 
> Reverting 3ae3d167f5ec2c7bb5fcd12b7772cfadc93b2305 on top of v4.9.171 worked
> and fixed the respective issue.
> 
> Can this commit in meanwhile be reverted or is there further ongoing work in
> integrating the followup fixes as mentioned in
> https://lore.kernel.org/stable/20190321104110.GF29086@quack2.suse.cz/ .

Sorry for the delay here.  No, I didn't find any time for the followup
stuff here, and Jan is right, this should just be dropped.

I've now reverted it from 3.18.y, 4.4.y, 4.9.y, and 4.14.y.

thanks,

greg k-h
