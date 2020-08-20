Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B97C24ADEB
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 06:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725290AbgHTElk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 00:41:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51697 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725768AbgHTElh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 00:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597898495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FawlYeQPcm1j7Zq9lJ25yGvGfdLQoOkhrat1d3Sia+Y=;
        b=dpxPi/hxNEWgjYrDs+JrpkzGMvgeSIzSuFth1lAQweA93FRBvl6WatfbSigarQb6aCb+FB
        rKt98zetjiqcLZhteQ6egs7IQp1jVDrLcjg7yUNpKRTxm850LNbUW7Ww7qh4EPlUD0aalY
        N9d+KAPTmATAg6MHVeAp+dEISuDhuow=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-R6VNpJTMNTqEjqIWQs0rHA-1; Thu, 20 Aug 2020 00:41:33 -0400
X-MC-Unique: R6VNpJTMNTqEjqIWQs0rHA-1
Received: by mail-pf1-f200.google.com with SMTP id 19so486408pfu.20
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 21:41:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FawlYeQPcm1j7Zq9lJ25yGvGfdLQoOkhrat1d3Sia+Y=;
        b=O/wO9a0SR/18RBQnxjwchha2XVux69D2u3Yhxl8nJ3X43P9ypO6cjo22iuOEOMy5Gp
         x7BLLNbASfZOkT7gNHsPIwgu4eHDwI6k0GMRQ/wk3FF0b7AlS+y3N2mmsmnHkMHNEdw/
         48fuqb1KhqwatfC5d+AMghsWqca3N3asmbikUyUkKYh1g/lkOX0zn/gQ6dQv1zKG65ZR
         16WR5bgbXaclTVNLeAa37zH61Tkj+RujPmvhMcgTA0l2VsQaBcqxFSykrZM+rQ6yvh0S
         dbDSBLbeJW8RciOp2xU2ITL66zRyr3FhRj9M6wBd3LqzkqZmOSL5UoqTdKrmpnq3lCDb
         8Efg==
X-Gm-Message-State: AOAM532xP5x524OCG74G/g7JaAyPE0ZZSTLOL/kKtIN8e5hv0SffSWGT
        lntF3vlTXHb1UE8VEDFGM0j2hMZubVbSrq1ZpdgTv9oGbwPg0LRlMGsrRJbqoS9cp9NX1Fy68Nl
        el2+SHl3I40EXxSlX
X-Received: by 2002:a17:90a:6a8d:: with SMTP id u13mr959845pjj.166.1597898492011;
        Wed, 19 Aug 2020 21:41:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDV5HicPAU/dYLjNBDH689m2WckfoWML+OpLh4ESvPaJhPhNe3pktnZl4ZzLv/bV7HCMJXPw==
X-Received: by 2002:a17:90a:6a8d:: with SMTP id u13mr959833pjj.166.1597898491774;
        Wed, 19 Aug 2020 21:41:31 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v128sm961284pfc.14.2020.08.19.21.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 21:41:31 -0700 (PDT)
Date:   Thu, 20 Aug 2020 12:41:20 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Huang, Ying" <ying.huang@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rafael Aquini <aquini@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] mm, THP, swap: fix allocating cluster for swapfile by
 mistake
Message-ID: <20200820044120.GB12374@xiangao.remote.csb>
References: <20200819195613.24269-1-hsiangkao@redhat.com>
 <871rk2x7bb.fsf@yhuang-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rk2x7bb.fsf@yhuang-dev.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ying,

On Thu, Aug 20, 2020 at 12:36:08PM +0800, Huang, Ying wrote:
> Gao Xiang <hsiangkao@redhat.com> writes:
> 
> > SWP_FS doesn't mean the device is file-backed swap device,
> > which just means each writeback request should go through fs
> > by DIO. Or it'll just use extents added by .swap_activate(),
> > but it also works as file-backed swap device.
> >
> > So in order to achieve the goal of the original patch,
> > SWP_BLKDEV should be used instead.
> >
> > FS corruption can be observed with SSD device + XFS +
> > fragmented swapfile due to CONFIG_THP_SWAP=y.
> >
> > Fixes: f0eea189e8e9 ("mm, THP, swap: Don't allocate huge cluster for file backed swap device")
> > Fixes: 38d8b4e6bdc8 ("mm, THP, swap: delay splitting THP during swap out")
> > Cc: "Huang, Ying" <ying.huang@intel.com>
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> 
> Good catch!  The fix itself looks good me!  Although the description is
> a little confusing.
> 
> After some digging, it seems that SWP_FS is set on the swap devices
> which make swap entry read/write go through the file system specific
> callback (now used by swap over NFS only).

Okay, let me send out v2 with the updated commit message in
https://lore.kernel.org/r/20200820012409.GB5846@xiangao.remote.csb/

Thanks,
Gao Xiang

> 
> Best Regards,
> Huang, Ying
> 
> > ---
> >
> > I reproduced the issue with the following details:
> >
> > Environment:
> > QEMU + upstream kernel + buildroot + NVMe (2 GB)
> >
> > Kernel config:
> > CONFIG_BLK_DEV_NVME=y
> > CONFIG_THP_SWAP=y
> >
> > Some reproducable steps:
> > mkfs.xfs -f /dev/nvme0n1
> > mkdir /tmp/mnt
> > mount /dev/nvme0n1 /tmp/mnt
> > bs="32k"
> > sz="1024m"    # doesn't matter too much, I also tried 16m
> > xfs_io -f -c "pwrite -R -b $bs 0 $sz" -c "fdatasync" /tmp/mnt/sw
> > xfs_io -f -c "pwrite -R -b $bs 0 $sz" -c "fdatasync" /tmp/mnt/sw
> > xfs_io -f -c "pwrite -R -b $bs 0 $sz" -c "fdatasync" /tmp/mnt/sw
> > xfs_io -f -c "pwrite -F -S 0 -b $bs 0 $sz" -c "fdatasync" /tmp/mnt/sw
> > xfs_io -f -c "pwrite -R -b $bs 0 $sz" -c "fsync" /tmp/mnt/sw
> >
> > mkswap /tmp/mnt/sw
> > swapon /tmp/mnt/sw
> >
> > stress --vm 2 --vm-bytes 600M   # doesn't matter too much as well
> >
> > Symptoms:
> >  - FS corruption (e.g. checksum failure)
> >  - memory corruption at: 0xd2808010
> >  - segfault
> >  ... 
> >
> >  mm/swapfile.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
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

