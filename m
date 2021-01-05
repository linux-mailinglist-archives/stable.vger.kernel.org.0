Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A412EA92B
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 11:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbhAEKte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 05:49:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728808AbhAEKtd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 05:49:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8FA122515;
        Tue,  5 Jan 2021 10:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609843733;
        bh=EyYal2Siqh778BFa5mPkxWqX8g4H2qQ37E8p3Y4cv5E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wDuYujxRs6T0EhFvdyXewChmi3cHUBmDu1OPQDYrqBWkh7PzDM0AVocFDJbEHtREf
         bpAvmAYspul/pAo4q8WQBZLBFTnVmbGMceLQLsdQPMn17dzQB66uTjJnKdToyPlyjd
         WnvRKG0uSHD7MU3+/FkE/ct3Ukrwo70Q2t3zuwoY=
Date:   Tue, 5 Jan 2021 11:50:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: Re: [PATCH] Revert "mtd: spinand: Fix OOB read"
Message-ID: <X/REacOFxaKyMnb1@kroah.com>
References: <20210105101821.47138-1-nbd@nbd.name>
 <X/Q//pErSOfQj/Gd@kroah.com>
 <e869888f-66fe-a931-2225-544938368d83@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e869888f-66fe-a931-2225-544938368d83@nbd.name>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 11:40:11AM +0100, Felix Fietkau wrote:
> 
> On 2021-01-05 11:31, Greg KH wrote:
> > On Tue, Jan 05, 2021 at 11:18:21AM +0100, Felix Fietkau wrote:
> >> This reverts stable commit baad618d078c857f99cc286ea249e9629159901f.
> >> 
> >> This commit is adding lines to spinand_write_to_cache_op, wheras the upstream
> >> commit 868cbe2a6dcee451bd8f87cbbb2a73cf463b57e5 that this was supposed to
> >> backport was touching spinand_read_from_cache_op.
> >> It causes a crash on writing OOB data by attempting to write to read-only
> >> kernel memory.
> >> 
> >> Cc: Miquel Raynal <miquel.raynal@bootlin.com>
> >> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> >> ---
> >>  drivers/mtd/nand/spi/core.c | 4 ----
> >>  1 file changed, 4 deletions(-)
> > 
> > So the backport to 5.10.y broke, but not the backport to 4.19.y or
> > 5.4.y?  Can you provide a "correct" backport for this instead of just
> > removing this fix?
> I just checked, it seems that 4.19.y and 5.4.y are broken in exactly the
> same way.
> 
> On a first glance, it seems that the upstream commit has a wrong Fixes
> line and is fixing 3d1f08b032dc ("mtd: spinand: Use the external ECC
> engine logic") instead, which is not in 5.10.
> If that is correct, then we don't need any stable backport at all.

Ah, then yes, this should be reverted everywhere.  If that is the case,
otherwise, I went off of the fixes: value in the original commit, which
is in the 4.19.0 release.

> In my opinion it's best to just revert the broken commit in all the
> stable trees as quickly as possible and let Miquel sort out the mess
> afterwards, if needed.

I can do that, but need an ack from the maintainer...

thanks,

greg k-h
