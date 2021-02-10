Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D6031629C
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 10:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhBJJpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 04:45:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:53724 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230125AbhBJJnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 04:43:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A5634AE91;
        Wed, 10 Feb 2021 09:42:31 +0000 (UTC)
Date:   Wed, 10 Feb 2021 10:42:28 +0100
From:   Oscar Salvador <osalvador@suse.de>
To:     Dave Hansen <dave.hansen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ben.widawsky@intel.com, rientjes@google.com, cl@linux.com,
        alex.shi@linux.alibaba.com, dwagner@suse.de, tobin@kernel.org,
        akpm@linux-foundation.org, ying.huang@intel.com,
        dan.j.williams@intel.com, cai@lca.pw, stable@vger.kernel.org
Subject: Re: [RFC][PATCH 01/13] mm/vmscan: restore zone_reclaim_mode ABI
Message-ID: <20210210094222.GA27173@linux>
References: <20210126003411.2AC51464@viggo.jf.intel.com>
 <20210126003412.59594AA9@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126003412.59594AA9@viggo.jf.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 04:34:13PM -0800, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> I went to go add a new RECLAIM_* mode for the zone_reclaim_mode
> sysctl.  Like a good kernel developer, I also went to go update the
> documentation.  I noticed that the bits in the documentation didn't
> match the bits in the #defines.
> 
> The VM never explicitly checks the RECLAIM_ZONE bit.  The bit is,
> however implicitly checked when checking 'node_reclaim_mode==0'.
> The RECLAIM_ZONE #define was removed in a cleanup.  That, by itself
> is fine.
> 
> But, when the bit was removed (bit 0) the _other_ bit locations also
> got changed.  That's not OK because the bit values are documented to
> mean one specific thing and users surely rely on them meaning that one
> thing and not changing from kernel to kernel.  The end result is that
> if someone had a script that did:
> 
> 	sysctl vm.zone_reclaim_mode=1
> 
> This script would have gone from enalbing node reclaim for clean
> unmapped pages to writing out pages during node reclaim after the
> commit in question.  That's not great.
> 
> Put the bits back the way they were and add a comment so something
> like this is a bit harder to do again.  Update the documentation to
> make it clear that the first bit is ignored.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Fixes: 648b5cf368e0 ("mm/vmscan: remove unused RECLAIM_OFF/RECLAIM_ZONE")
> Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Acked-by: Christoph Lameter <cl@linux.com>
> Cc: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: "Tobin C. Harding" <tobin@kernel.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Qian Cai <cai@lca.pw>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: osalvador <osalvador@suse.de>
> Cc: stable@vger.kernel.org

Reviewed-by: Oscar Salvador <osalvador@suse.de>

> 
> --
> 
> Changes from v2:
>  * Update description to indicate that bit0 was used for clean
>    unmapped page node reclaim.
> ---
> 
>  b/Documentation/admin-guide/sysctl/vm.rst |   10 +++++-----
>  b/mm/vmscan.c                             |    9 +++++++--
>  2 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff -puN Documentation/admin-guide/sysctl/vm.rst~mm-vmscan-restore-old-zone_reclaim_mode-abi Documentation/admin-guide/sysctl/vm.rst
> --- a/Documentation/admin-guide/sysctl/vm.rst~mm-vmscan-restore-old-zone_reclaim_mode-abi	2021-01-25 16:23:06.048866718 -0800
> +++ b/Documentation/admin-guide/sysctl/vm.rst	2021-01-25 16:23:06.056866718 -0800
> @@ -978,11 +978,11 @@ that benefit from having their data cach
>  left disabled as the caching effect is likely to be more important than
>  data locality.
>  
> -zone_reclaim may be enabled if it's known that the workload is partitioned
> -such that each partition fits within a NUMA node and that accessing remote
> -memory would cause a measurable performance reduction.  The page allocator
> -will then reclaim easily reusable pages (those page cache pages that are
> -currently not used) before allocating off node pages.
> +Consider enabling one or more zone_reclaim mode bits if it's known that the
> +workload is partitioned such that each partition fits within a NUMA node
> +and that accessing remote memory would cause a measurable performance
> +reduction.  The page allocator will take additional actions before
> +allocating off node pages.
>  
>  Allowing zone reclaim to write out pages stops processes that are
>  writing large amounts of data from dirtying pages on other nodes. Zone
> diff -puN mm/vmscan.c~mm-vmscan-restore-old-zone_reclaim_mode-abi mm/vmscan.c
> --- a/mm/vmscan.c~mm-vmscan-restore-old-zone_reclaim_mode-abi	2021-01-25 16:23:06.052866718 -0800
> +++ b/mm/vmscan.c	2021-01-25 16:23:06.057866718 -0800
> @@ -4086,8 +4086,13 @@ module_init(kswapd_init)
>   */
>  int node_reclaim_mode __read_mostly;
>  
> -#define RECLAIM_WRITE (1<<0)	/* Writeout pages during reclaim */
> -#define RECLAIM_UNMAP (1<<1)	/* Unmap pages during reclaim */
> +/*
> + * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
> + * ABI.  New bits are OK, but existing bits can never change.
> + */
> +#define RECLAIM_ZONE  (1<<0)   /* Run shrink_inactive_list on the zone */
> +#define RECLAIM_WRITE (1<<1)   /* Writeout pages during reclaim */
> +#define RECLAIM_UNMAP (1<<2)   /* Unmap pages during reclaim */
>  
>  /*
>   * Priority for NODE_RECLAIM. This determines the fraction of pages
> _
> 

-- 
Oscar Salvador
SUSE L3
