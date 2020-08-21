Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A0024C927
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 02:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgHUA21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 20:28:27 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45015 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727033AbgHUA20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 20:28:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597969704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L3JIlPvsMRwkM1mgCcR4mBSnOH7ubXhXyleqb1KzD8U=;
        b=hzi2czJb/h7wsN3T9CCJrMYXiByc1oVK7P3bAU5mcwCCi0D1C1gQUc5vYN1zb0qYJuAGLJ
        p2cZ35p2jTLsMRi4ph309hgKcQKiK4jpNRLLZsnEa7CpIg1U2qP7pBOHFOFCPQMgv1iVEI
        EPSF3EHG9OwS6kEBG6HJ36fFZ61oaTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-e07Wxl8qNreqFdkVdHJf3g-1; Thu, 20 Aug 2020 20:28:23 -0400
X-MC-Unique: e07Wxl8qNreqFdkVdHJf3g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C95BA1074649;
        Fri, 21 Aug 2020 00:28:21 +0000 (UTC)
Received: from optiplex-lnx (unknown [10.3.128.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4ED4A10098A7;
        Fri, 21 Aug 2020 00:28:12 +0000 (UTC)
Date:   Thu, 20 Aug 2020 20:28:10 -0400
From:   Rafael Aquini <aquini@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Gao Xiang <hsiangkao@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm, THP, swap: fix allocating cluster for swapfile by
 mistake
Message-ID: <20200821002810.GA3096383@optiplex-lnx>
References: <20200820045323.7809-1-hsiangkao@redhat.com>
 <20200820233446.GB7728@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820233446.GB7728@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 09:34:46AM +1000, Dave Chinner wrote:
> On Thu, Aug 20, 2020 at 12:53:23PM +0800, Gao Xiang wrote:
> > SWP_FS is used to make swap_{read,write}page() go through
> > the filesystem, and it's only used for swap files over
> > NFS. So, !SWP_FS means non NFS for now, it could be either
> > file backed or device backed. Something similar goes with
> > legacy SWP_FILE.
> > 
> > So in order to achieve the goal of the original patch,
> > SWP_BLKDEV should be used instead.
> > 
> > FS corruption can be observed with SSD device + XFS +
> > fragmented swapfile due to CONFIG_THP_SWAP=y.
> > 
> > I reproduced the issue with the following details:
> > 
> > Environment:
> > QEMU + upstream kernel + buildroot + NVMe (2 GB)
> > 
> > Kernel config:
> > CONFIG_BLK_DEV_NVME=y
> > CONFIG_THP_SWAP=y
> 
> Ok, so at it's core this is a swap file extent versus THP swap
> cluster alignment issue?
> 
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 6c26916e95fd..2937daf3ca02 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1074,7 +1074,7 @@ int get_swap_pages(int n_goal, swp_entry_t swp_entries[], int entry_size)
> >  			goto nextsi;
> >  		}
> >  		if (size == SWAPFILE_CLUSTER) {
> > -			if (!(si->flags & SWP_FS))
> > +			if (si->flags & SWP_BLKDEV)
> >  				n_ret = swap_alloc_cluster(si, swp_entries);
> >  		} else
> >  			n_ret = scan_swap_map_slots(si, SWAP_HAS_CACHE,
> 
> IOWs, if you don't make this change, does the corruption problem go
> away if you align swap extents in iomap_swapfile_add_extent() to
> (SWAPFILE_CLUSTER * PAGE_SIZE) instead of just PAGE_SIZE?
> 

I suspect that will have to come with the 3rd, and final, part of the THP_SWAP
work Intel is doing. Right now, basically, all that's accomplished is deferring 
the THP split step when swapping out, so this change is what we need to
avoid stomping outside the file extent boundaries.


> I.e. if the swapfile extents are aligned correctly to huge page swap
> cluster size and alignment, does the swap clustering optimisations
> for swapping THP pages work correctly? And, if so, is there any
> performance benefit we get from enabling proper THP swap clustering
> on swapfiles?
>
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

