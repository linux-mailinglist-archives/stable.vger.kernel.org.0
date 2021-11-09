Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38A744A473
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 03:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240381AbhKICLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 21:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240206AbhKICLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 21:11:39 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1060C061764;
        Mon,  8 Nov 2021 18:08:54 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id y1so18049037plk.10;
        Mon, 08 Nov 2021 18:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nuIPdnvIF8rGskbyb/raN9C5Xy0Y5NftDXzCqbiXGYE=;
        b=AH9QWPEsMWY5Y2X1LmK1rIKY8YOFSC4hn1T1xUOe3HTCJem0PwGq8aROL5NbN3eRHx
         eoKcbYWdCC219ty2wZ3ZQDfwEvfdWTzSPocW5ulhayeRrdcvU5YRvXg70b2lC791TkHR
         kVJ+d1/Ez5E4tL+BPajaqMSKqncNnsbRduIKSITNs3ZW/iMJoL5w0EqoP559HZARIIAQ
         NDPvsYSlD7ZL8qr8dAgCwqae0AUa3n7nownxF3lbkCKg2KjAMLWjbDopN/kfVtYPU6Jq
         6mIXYPoK37s1JjqAh5C0y7F8U2rdVRiH2p0GMgdaRTvoZ0Xb7VG40Qw7khaMgvNt5DJQ
         UpKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nuIPdnvIF8rGskbyb/raN9C5Xy0Y5NftDXzCqbiXGYE=;
        b=2sMdVbOVYsM6nLIGDYKxmRIWFoXgG7/5aVc8L1tq75dWpgHG5iH9bB5z9PMahkNkp0
         k4ngva/tdKLRaMxzC5/SbLrXOdx2qfvv4usnD/pEV4Zp7mLI3CgdVR22fSnoTeagEznK
         NKr/fQFrsgxx1aIv8nbcn1Ybq5Tr2gK1K9KE9OwWxGvvL/OgkajVxtq88A5UQUNy9Iiv
         tu058VTGrN+FrmHBAKysjdoqV/YiCuCnbmxtrTm5eQEhjZy8SIO87qOwAa0qpCKkPW3M
         6/E6VdROZFVX1CeyCaRa7KOOl4gJ6XrG/g8lLoJuv7AC+vhndfjuuzfXUW5U/cxJQhEA
         rWmA==
X-Gm-Message-State: AOAM532vOJ9HrLZlMv8MVoXPcLP4xFP8xQV0VSezL7q5AwsYWyfOsChO
        i1TSaTI/2BTMnoRsuHp17gNnsHyfwas=
X-Google-Smtp-Source: ABdhPJzFVMYq7FKSbBlhbIK/GaWghuRe2076O7z19n4If5/0Ax5qCk8bLqKRsiWDPtHSi91iC2kWtw==
X-Received: by 2002:a17:902:e5ce:b0:142:780:78db with SMTP id u14-20020a170902e5ce00b00142078078dbmr3807610plf.12.1636423733999;
        Mon, 08 Nov 2021 18:08:53 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id cv1sm552622pjb.48.2021.11.08.18.08.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 18:08:53 -0800 (PST)
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
To:     Alexey Makhalov <amakhalov@vmware.com>, linux-mm@kvack.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <908909e0-4815-b580-7ff5-d824d36a141c@redhat.com>
 <20211108202325.20304-1-amakhalov@vmware.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2e191db3-286f-90c6-bf96-3f89891e9926@gmail.com>
Date:   Mon, 8 Nov 2021 18:08:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211108202325.20304-1-amakhalov@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/8/21 12:23 PM, Alexey Makhalov wrote:
> There is a kernel panic caused by pcpu_alloc_pages() passing
> offlined and uninitialized node to alloc_pages_node() leading
> to panic by NULL dereferencing uninitialized NODE_DATA(nid).
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
> Panic can be easily reproduced by disabling udev rule for
> automatic onlining hot added CPU followed by CPU with
> memoryless node (NUMA node with CPU only) hot add.
> 
> Hot adding CPU and memoryless node does not bring the node
> to online state. Memoryless node will be onlined only during
> the onlining its CPU.
> 
> Node can be in one of the following states:
> 1. not present.(nid == NUMA_NO_NODE)
> 2. present, but offline (nid > NUMA_NO_NODE, node_online(nid) == 0,
> 				NODE_DATA(nid) == NULL)
> 3. present and online (nid > NUMA_NO_NODE, node_online(nid) > 0,
> 				NODE_DATA(nid) != NULL)
> 
> Percpu code is doing allocations for all possible CPUs. The
> issue happens when it serves hot added but not yet onlined
> CPU when its node is in 2nd state. This node is not ready
> to use, fallback to numa_mem_id().
> 
> Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  mm/percpu-vm.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
> index 2054c9213..f58d73c92 100644
> --- a/mm/percpu-vm.c
> +++ b/mm/percpu-vm.c
> @@ -84,15 +84,19 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
>  			    gfp_t gfp)
>  {
>  	unsigned int cpu, tcpu;
> -	int i;
> +	int i, nid;
>  
>  	gfp |= __GFP_HIGHMEM;
>  
>  	for_each_possible_cpu(cpu) {
> +		nid = cpu_to_node(cpu);
> +		if (nid == NUMA_NO_NODE || !node_online(nid))
> +			nid = numa_mem_id();

Maybe we should fail this fallback if (gfp & __GFP_THISNODE) ?

Or maybe there is no support for this constraint in per-cpu allocator anyway.

I am a bit worried that we do not really know if pages are
allocated on the right node or not.

Some workloads could really be hurt if all per-cpu pages were
put on a single NUMA node.

> +
>  		for (i = page_start; i < page_end; i++) {
>  			struct page **pagep = &pages[pcpu_page_idx(cpu, i)];
>  
> -			*pagep = alloc_pages_node(cpu_to_node(cpu), gfp, 0);
> +			*pagep = alloc_pages_node(nid, gfp, 0);
>  			if (!*pagep)
>  				goto err;
>  		}
> 
