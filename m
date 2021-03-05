Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AD232E39F
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 09:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCEI1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 03:27:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhCEI1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 03:27:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 502B265014;
        Fri,  5 Mar 2021 08:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614932830;
        bh=BOASgRiX/anyBYwyGt5CoZ1avHZlm10qLQx9FzJQMQQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rmTOuV1dgAPy4LsKiOB1P2ZRT8wBd6gxH+xJMcSDY+xbjp76e+87zg4v4Sh3L6DmF
         PlS3kc4euNYVnjiGvdpSIlCYDaUlIsyfifKhLdKW32m+u+0A1JXKophgL8+7zRGN3v
         sOFf1PIFHxcSaXCbqlVnX87jKkOOfWOv3ONtHfCo=
Date:   Fri, 5 Mar 2021 09:27:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH STABLE 5.10 5.11] swap: fix swapfile page to sector
 mapping
Message-ID: <YEHrXLxeDT0fieXf@kroah.com>
References: <20210304150824.29878-1-ailiop@suse.com>
 <20210304150824.29878-5-ailiop@suse.com>
 <YED5ypwsrExHWD7N@kroah.com>
 <YEELCJkGx78SP34d@technoir>
 <YEERyfs8QSB5lGVz@kroah.com>
 <YEFOVDk1bTgrw6bt@technoir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEFOVDk1bTgrw6bt@technoir>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04, 2021 at 10:17:08PM +0100, Anthony Iliopoulos wrote:
> On Thu, Mar 04, 2021 at 05:58:49PM +0100, Greg Kroah-Hartman wrote:
> > On Thu, Mar 04, 2021 at 05:30:00PM +0100, Anthony Iliopoulos wrote:
> > > On Thu, Mar 04, 2021 at 04:16:26PM +0100, Greg Kroah-Hartman wrote:
> > > > On Thu, Mar 04, 2021 at 04:08:24PM +0100, Anthony Iliopoulos wrote:
> > > > > commit caf6912f3f4af7232340d500a4a2008f81b93f14 upstream.
> > > > 
> > > > No, this does not look like that commit.
> > > > 
> > > > Why can I not just take caf6912f3f4a ("swap: fix swapfile read/write
> > > > offset") directly for 5.10 and 5.11?  WHat has changed to prevent that?
> > > 
> > > You're right of course, the upstream fix applies even on v5.4 so you
> > > could just take it directly for those branches if this is preferable.
> > 
> > But, that commit says it fixes 48d15436fde6 ("mm: remove get_swap_bio"),
> > which is NOT what you are saying here in these patches.
> 
> It is admittedly a bit confusing as the upstream commit fixes two issues
> in one swoop:
> 
> - the bug which was introduced in v5.12-rc1 via 48d15436fde6 ("mm:
>   remove get_swap_bio"), which affected swapfiles running on regular
>   block devices, in addition to:
> 
> - an identical bug which up until 48d15436fde6 was only applicable to
>   swapfiles on top of blockdevs that can do page io without the block
>   layer, which was introduced with dd6bd0d9c7db ("swap: use
>   bdev_read_page() / bdev_write_page()")
> 
> > So which is it?  Is there a problem in 5.11 and older kernels
> > (48d15436fde6 ("mm: remove get_swap_bio") showed up in 5.12-rc1), that
> > requires this fix, or is there nothing needed to be backported?
> 
> The second point/bug mentioned above is present on 5.11 and all older
> kernels, so some form of this fix is required.
> 
> > As a note, I've been running swapfiles on 5.11 and earlier just fine for
> > a very long time now, so is this really an issue?
> 
> Yes there is an issue on all kernels since v3.16-rc1 when dd6bd0d9c7db
> was introduced, but it is applicable only to setups with swapfiles on
> filesystems sitting on top of brd, zram, btt or pmem.
> 
> I can trivially reproduce this e.g. on v5.11 by creating a swapfile on
> top of a zram or pmem blockdev and pushing the system to swap out pages,
> at which point it corrupts filesystem blocks that don't belong to the
> swapfile.

Ok, thanks for the detailed description, all now queued up.

greg k-h
