Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7D924CB14
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 04:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgHUC7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 22:59:16 -0400
Received: from mga05.intel.com ([192.55.52.43]:15865 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgHUC7O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 22:59:14 -0400
IronPort-SDR: fRFhhQgm34nxBgQegBM22Mcwm29cCgLJliPh6V13jrBYFaEhhtTTTUUNJ/y3Sy4xApDZ3Fnyep
 sVfkunuU1VDg==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="240268650"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="240268650"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2020 19:59:13 -0700
IronPort-SDR: HsHkPk12FpU091H67hyVGHN+fyXnU1tcswRmp+L1e70WC0Lg2cctbfTvjmT+Ak6sDZ/MBN7emc
 G75NVWkkyjmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="293693132"
Received: from yhuang-dev.sh.intel.com (HELO yhuang-dev) ([10.239.159.164])
  by orsmga003.jf.intel.com with ESMTP; 20 Aug 2020 19:59:09 -0700
From:   "Huang\, Ying" <ying.huang@intel.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Gao Xiang <hsiangkao@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Rafael Aquini <aquini@redhat.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm, THP, swap: fix allocating cluster for swapfile by mistake
References: <20200820045323.7809-1-hsiangkao@redhat.com>
        <20200820233446.GB7728@dread.disaster.area>
        <20200821002145.GA28298@xiangao.remote.csb>
        <20200821010330.GC7728@dread.disaster.area>
Date:   Fri, 21 Aug 2020 10:59:08 +0800
In-Reply-To: <20200821010330.GC7728@dread.disaster.area> (Dave Chinner's
        message of "Fri, 21 Aug 2020 11:03:30 +1000")
Message-ID: <87mu2ovh4z.fsf@yhuang-dev.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Fri, Aug 21, 2020 at 08:21:45AM +0800, Gao Xiang wrote:
>> Hi Dave,
>> 
>> On Fri, Aug 21, 2020 at 09:34:46AM +1000, Dave Chinner wrote:
>> > On Thu, Aug 20, 2020 at 12:53:23PM +0800, Gao Xiang wrote:
>> > > SWP_FS is used to make swap_{read,write}page() go through
>> > > the filesystem, and it's only used for swap files over
>> > > NFS. So, !SWP_FS means non NFS for now, it could be either
>> > > file backed or device backed. Something similar goes with
>> > > legacy SWP_FILE.
>> > > 
>> > > So in order to achieve the goal of the original patch,
>> > > SWP_BLKDEV should be used instead.
>> > > 
>> > > FS corruption can be observed with SSD device + XFS +
>> > > fragmented swapfile due to CONFIG_THP_SWAP=y.
>> > > 
>> > > I reproduced the issue with the following details:
>> > > 
>> > > Environment:
>> > > QEMU + upstream kernel + buildroot + NVMe (2 GB)
>> > > 
>> > > Kernel config:
>> > > CONFIG_BLK_DEV_NVME=y
>> > > CONFIG_THP_SWAP=y
>> > 
>> > Ok, so at it's core this is a swap file extent versus THP swap
>> > cluster alignment issue?
>> 
>> I think yes.
>> 
>> > 
>> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
>> > > index 6c26916e95fd..2937daf3ca02 100644
>> > > --- a/mm/swapfile.c
>> > > +++ b/mm/swapfile.c
>> > > @@ -1074,7 +1074,7 @@ int get_swap_pages(int n_goal, swp_entry_t swp_entries[], int entry_size)
>> > >  			goto nextsi;
>> > >  		}
>> > >  		if (size == SWAPFILE_CLUSTER) {
>> > > -			if (!(si->flags & SWP_FS))
>> > > +			if (si->flags & SWP_BLKDEV)
>> > >  				n_ret = swap_alloc_cluster(si, swp_entries);
>> > >  		} else
>> > >  			n_ret = scan_swap_map_slots(si, SWAP_HAS_CACHE,
>> > 
>> > IOWs, if you don't make this change, does the corruption problem go
>> > away if you align swap extents in iomap_swapfile_add_extent() to
>> > (SWAPFILE_CLUSTER * PAGE_SIZE) instead of just PAGE_SIZE?
>> > 
>> > I.e. if the swapfile extents are aligned correctly to huge page swap
>> > cluster size and alignment, does the swap clustering optimisations
>> > for swapping THP pages work correctly? And, if so, is there any
>> > performance benefit we get from enabling proper THP swap clustering
>> > on swapfiles?
>> > 
>> 
>> Yeah, I once think about some similiar thing as well. My thought for now is
>> 
>>  - First, SWAP THP doesn't claim to support such swapfile for now.
>>    And the original author tried to explicitly avoid the whole thing in
>> 
>>    f0eea189e8e9 ("mm, THP, swap: Don't allocate huge cluster for file backed swap device")
>> 
>>    So such thing would be considered as some new feature and need
>>    more testing at least. But for now I think we just need a quick
>>    fix to fix the commit f0eea189e8e9 to avoid regression and for
>>    backport use.
>
> Sure, a quick fix is fine for the current issue. I'm asking
> questions about the design/architecture of how THP_SWAP is supposed
> to work and whether swapfiles are violating some other undocumented
> assumption about swapping THP files...

The main requirement for THP_SWAP is that the swap cluster need to be
mapped to the continuous block device space.

So Yes.  In theory, it's possible to support THP_SWAP for swapfile.  But
I don't know whether people need it or not.

Best Regards,
Huang, Ying

>>  - It is hard for users to control swapfile in
>>    SWAPFILE_CLUSTER * PAGE_SIZE extents, especially users'
>>    disk are fragmented or have some on-disk metadata limitation or
>>    something. It's very hard for users to utilize this and arrange
>>    their swapfile physical addr alignment and fragments for now.
>
> This isn't something users control. The swapfile extent mapping code
> rounds the swap extents inwards so that the parts of the on-disk
> extents that are not aligned or cannot hold a full page are
> omitted from the ranges of the file that can be swapped to.
>
> i.e. a file that extents aligned to 4kB is fine for a 4KB page size
> machine, but needs additional alignment to allow swapping to work on
> a 64kB page size machine. Hence the swap code rounds the file
> extents inwards to PAGE_SIZE to align them correctly. We really
> should be doing this for THP page size rather than PAGE_SIZE if
> THP_SWAP is enabled, regardless of whether swap clustering is
> enabled or not...
>
> Cheers,
>
> Dave.
