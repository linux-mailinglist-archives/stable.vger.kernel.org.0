Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A542F32DBAB
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 22:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbhCDVSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 16:18:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:51908 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234894AbhCDVR4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 16:17:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614892629; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/tZ880Yp/AKHzG1rpWeDp9V30VjIiNL6pvc/O/61Sck=;
        b=nCoW2/W4dLR8+pG1rRhirVZ+Z9b+K4gJulKogHhl2KxAUI3Q1MY/2G1W7U3tCZTIOMpHPF
        5vl7YKo1McvzNVmkXuYzU77vtyz+lrpGiKEy9WprGWE8uPhkWUWnlXAT64Z9QIcOQJ276K
        hQIubeeMqKJtIEjp+l2+3+97NKjOUi8=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 88BD6AFB0;
        Thu,  4 Mar 2021 21:17:09 +0000 (UTC)
Date:   Thu, 4 Mar 2021 22:17:08 +0100
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH STABLE 5.10 5.11] swap: fix swapfile page to sector
 mapping
Message-ID: <YEFOVDk1bTgrw6bt@technoir>
References: <20210304150824.29878-1-ailiop@suse.com>
 <20210304150824.29878-5-ailiop@suse.com>
 <YED5ypwsrExHWD7N@kroah.com>
 <YEELCJkGx78SP34d@technoir>
 <YEERyfs8QSB5lGVz@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEERyfs8QSB5lGVz@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04, 2021 at 05:58:49PM +0100, Greg Kroah-Hartman wrote:
> On Thu, Mar 04, 2021 at 05:30:00PM +0100, Anthony Iliopoulos wrote:
> > On Thu, Mar 04, 2021 at 04:16:26PM +0100, Greg Kroah-Hartman wrote:
> > > On Thu, Mar 04, 2021 at 04:08:24PM +0100, Anthony Iliopoulos wrote:
> > > > commit caf6912f3f4af7232340d500a4a2008f81b93f14 upstream.
> > > 
> > > No, this does not look like that commit.
> > > 
> > > Why can I not just take caf6912f3f4a ("swap: fix swapfile read/write
> > > offset") directly for 5.10 and 5.11?  WHat has changed to prevent that?
> > 
> > You're right of course, the upstream fix applies even on v5.4 so you
> > could just take it directly for those branches if this is preferable.
> 
> But, that commit says it fixes 48d15436fde6 ("mm: remove get_swap_bio"),
> which is NOT what you are saying here in these patches.

It is admittedly a bit confusing as the upstream commit fixes two issues
in one swoop:

- the bug which was introduced in v5.12-rc1 via 48d15436fde6 ("mm:
  remove get_swap_bio"), which affected swapfiles running on regular
  block devices, in addition to:

- an identical bug which up until 48d15436fde6 was only applicable to
  swapfiles on top of blockdevs that can do page io without the block
  layer, which was introduced with dd6bd0d9c7db ("swap: use
  bdev_read_page() / bdev_write_page()")

> So which is it?  Is there a problem in 5.11 and older kernels
> (48d15436fde6 ("mm: remove get_swap_bio") showed up in 5.12-rc1), that
> requires this fix, or is there nothing needed to be backported?

The second point/bug mentioned above is present on 5.11 and all older
kernels, so some form of this fix is required.

> As a note, I've been running swapfiles on 5.11 and earlier just fine for
> a very long time now, so is this really an issue?

Yes there is an issue on all kernels since v3.16-rc1 when dd6bd0d9c7db
was introduced, but it is applicable only to setups with swapfiles on
filesystems sitting on top of brd, zram, btt or pmem.

I can trivially reproduce this e.g. on v5.11 by creating a swapfile on
top of a zram or pmem blockdev and pushing the system to swap out pages,
at which point it corrupts filesystem blocks that don't belong to the
swapfile.

Regards,
Anthony
