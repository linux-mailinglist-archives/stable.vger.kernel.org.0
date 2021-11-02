Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968224428CD
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 08:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhKBHuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 03:50:03 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:52730 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhKBHuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 03:50:02 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0830621956;
        Tue,  2 Nov 2021 07:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635839247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vf5M1Mpg3PLYYCAoR7F2Jy+Y+jIdkLco+jWhQ+1V2wk=;
        b=Xs8UvH0vLV/fN1vfUmhPvUQ9clgv+HgeQ8jrPHHf0UhIGTRji1qaNbROwkvkD3nTkBPY5t
        ikmCOFbLZ8Q8JzTCC9GfNcvze1bZLWl8CejAou/8A41oDtA1bxx7gVOh9wsmnTIyyB+YVD
        2o+yZz+Bbiz2nYOB1nE9K26YA9PGnc8=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id CF618A3B87;
        Tue,  2 Nov 2021 07:47:26 +0000 (UTC)
Date:   Tue, 2 Nov 2021 08:47:26 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oscar Salvador <OSalvador@suse.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
Message-ID: <YYDtDkGNylpAgPIS@dhcp22.suse.cz>
References: <20211101201312.11589-1-amakhalov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101201312.11589-1-amakhalov@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[CC Oscar and David]

On Mon 01-11-21 13:13:12, Alexey Makhalov wrote:
> There is a kernel panic caused by __alloc_pages() accessing
> uninitialized NODE_DATA(nid). Uninitialized node data exists
> during the time when CPU with memoryless node was added but
> not onlined yet. Panic can be easy reproduced by disabling
> udev rule for automatic onlining hot added CPU followed by
> CPU with memoryless node hot add.
> 
> This is a panic caused by percpu code doing allocations for
> all possible CPUs and hitting this issue:
> 
>  CPU2 has been hot-added
>  BUG: unable to handle page fault for address: 0000000000001608
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 0 P4D 0
>  Oops: 0000 [#1] SMP PTI
>  CPU: 0 PID: 1 Comm: systemd Tainted: G            E     5.15.0-rc7+ #11
>  Hardware name: VMware, Inc. VMware7,1/440BX Desktop Reference Platform, BIOS VMW
> 
>  RIP: 0010:__alloc_pages+0x127/0x290

Could you resolve this into a specific line of the source code please?

>  Code: 4c 89 f0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 44 89 e0 48 8b 55 b8 c1 e8 0c 83 e0 01 88 45 d0 4c 89 c8 48 85 d2 0f 85 1a 01 00 00 <45> 3b 41 08 0f 82 10 01 00 00 48 89 45 c0 48 8b 00 44 89 e2 81 e2
>  RSP: 0018:ffffc900006f3bc8 EFLAGS: 00010246
>  RAX: 0000000000001600 RBX: 0000000000000000 RCX: 0000000000000000
>  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000cc2
>  RBP: ffffc900006f3c18 R08: 0000000000000001 R09: 0000000000001600
>  R10: ffffc900006f3a40 R11: ffff88813c9fffe8 R12: 0000000000000cc2
>  R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000cc2
>  FS:  00007f27ead70500(0000) GS:ffff88807ce00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000001608 CR3: 000000000582c003 CR4: 00000000001706b0
>  Call Trace:
>   pcpu_alloc_pages.constprop.0+0xe4/0x1c0
>   pcpu_populate_chunk+0x33/0xb0
>   pcpu_alloc+0x4d3/0x6f0
>   __alloc_percpu_gfp+0xd/0x10
>   alloc_mem_cgroup_per_node_info+0x54/0xb0
>   mem_cgroup_alloc+0xed/0x2f0
>   mem_cgroup_css_alloc+0x33/0x2f0
>   css_create+0x3a/0x1f0
>   cgroup_apply_control_enable+0x12b/0x150
>   cgroup_mkdir+0xdd/0x110
>   kernfs_iop_mkdir+0x4f/0x80
>   vfs_mkdir+0x178/0x230
>   do_mkdirat+0xfd/0x120
>   __x64_sys_mkdir+0x47/0x70
>   ? syscall_exit_to_user_mode+0x21/0x50
>   do_syscall_64+0x43/0x90
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Node can be in one of the following states:
> 1. not present (nid == NUMA_NO_NODE)
> 2. present, but offline (nid > NUMA_NO_NODE, node_online(nid) == 0,
> 				NODE_DATA(nid) == NULL)
> 3. present and online (nid > NUMA_NO_NODE, node_online(nid) > 0,
> 				NODE_DATA(nid) != NULL)
> 
> alloc_page_{bulk_array}node() functions verify for nid validity only
> and do not check if nid is online. Enhanced verification check allows
> to handle page allocation when node is in 2nd state.

I do not think this is a correct approach. We should make sure that the
proper fallback node is used instead. This means that the zone list is
initialized properly. IIRC this has been a problem in the past and it
has been fixed. The initialization code is quite subtle though so it is
possible that this got broken again.

> Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  include/linux/gfp.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 55b2ec1f9..34a5a7def 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -551,7 +551,8 @@ alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **page_arr
>  static inline unsigned long
>  alloc_pages_bulk_array_node(gfp_t gfp, int nid, unsigned long nr_pages, struct page **page_array)
>  {
> -	if (nid == NUMA_NO_NODE)
> +	if (nid == NUMA_NO_NODE || (!node_online(nid) &&
> +					!(gfp & __GFP_THISNODE)))
>  		nid = numa_mem_id();
>  
>  	return __alloc_pages_bulk(gfp, nid, NULL, nr_pages, NULL, page_array);
> @@ -578,7 +579,8 @@ __alloc_pages_node(int nid, gfp_t gfp_mask, unsigned int order)
>  static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
>  						unsigned int order)
>  {
> -	if (nid == NUMA_NO_NODE)
> +	if (nid == NUMA_NO_NODE || (!node_online(nid) &&
> +					!(gfp_mask & __GFP_THISNODE)))
>  		nid = numa_mem_id();
>  
>  	return __alloc_pages_node(nid, gfp_mask, order);
> -- 
> 2.30.0

-- 
Michal Hocko
SUSE Labs
