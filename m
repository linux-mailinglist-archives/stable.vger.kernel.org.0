Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C418A1AB95A
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 09:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438015AbgDPHHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 03:07:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437060AbgDPHHW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 03:07:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0F9420771;
        Thu, 16 Apr 2020 07:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587020842;
        bh=ixfgvY9Vg9xnZlGvnnitkf2LOO4leytTOdUCR0cYTqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=11amfw9jCM2rrYOmzRX7sdNM9zMTNkHxFgHDwIt0Lk0yJGgsx4LTYk4PpFYJgEyqL
         i6EZXYjhZjI0G1Uq8Ix5Ikx/SBrjqFfFx84rfrwGgyrpUL+pdN2pRX7/jOGxCJpU+6
         1wzowxd4TDSMr2p4efL3GhHFeZVCzO5Jj96yJT7I=
Date:   Thu, 16 Apr 2020 09:07:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        nborisov@suse.com, wqu@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: handle logged extent failure
 properly" failed to apply to 5.6-stable tree
Message-ID: <20200416070720.GC372946@kroah.com>
References: <158687410512288@kroah.com>
 <20200416004154.GN1068@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416004154.GN1068@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 08:41:54PM -0400, Sasha Levin wrote:
> On Tue, Apr 14, 2020 at 04:21:45PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.6-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > > From ab9b2c7b32e6be53cac2e23f5b2db66815a7d972 Mon Sep 17 00:00:00 2001
> > From: Josef Bacik <josef@toxicpanda.com>
> > Date: Thu, 13 Feb 2020 10:47:30 -0500
> > Subject: [PATCH] btrfs: handle logged extent failure properly
> > 
> > If we're allocating a logged extent we attempt to insert an extent
> > record for the file extent directly.  We increase
> > space_info->bytes_reserved, because the extent entry addition will call
> > btrfs_update_block_group(), which will convert the ->bytes_reserved to
> > ->bytes_used.  However if we fail at any point while inserting the
> > extent entry we will bail and leave space on ->bytes_reserved, which
> > will trigger a WARN_ON() on umount.  Fix this by pinning the space if we
> > fail to insert, which is what happens in every other failure case that
> > involves adding the extent entry.
> > 
> > CC: stable@vger.kernel.org # 5.4+
> > Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> > Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> > Reviewed-by: Qu Wenruo <wqu@suse.com>
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > Reviewed-by: David Sterba <dsterba@suse.com>
> > Signed-off-by: David Sterba <dsterba@suse.com>
> 
> Greg, I've noticed that you've fixed it up for 5.5 and 5.4 but no for
> 5.6? I've queued it up for 5.6 as well.

I didn't include this in 5.5 or 5.4, so please queue it up in those two
trees as well.

thanks,

greg k-h
