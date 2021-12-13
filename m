Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428DC472DA8
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 14:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237820AbhLMNna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 08:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhLMNn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 08:43:29 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0291FC061574;
        Mon, 13 Dec 2021 05:43:29 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 8so14974639pfo.4;
        Mon, 13 Dec 2021 05:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+J3ydLfhX23J+J777y07I1sRvhVRSNugp1dJU717hFI=;
        b=S1I8QihitM5wvI9tD6XzXlNydYqjNAAXPtl/VXl7NK9c8iI9NG15DdzchdF75oP6qj
         6F84H4aDqOlbTMhwBVOlIidAKRUU2R4Jm8s7FErfer2aFgodqpEzwLrk6m61vke1UERT
         ioVbiN6UQQVnrJLjFJJWSNk4abRyTrzpZ3IDtjCcdnvOY10aM3bLFS8m//NHAq3yrzIA
         v2DP5PYK4KUrkRpqcHf0yGnBVY+x0emX046coW/2GI7S7ldsIxfGwpMdPM/9hxq5VBfq
         vTKetK6qo23lGda7hPKFnUyWLHr4roGx2qHi+5x+IAu+Esaf2xpBNtJFqs/kgLtEANmQ
         Qf3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+J3ydLfhX23J+J777y07I1sRvhVRSNugp1dJU717hFI=;
        b=6/HghDs0LLsLCJwQW6zouK8QnaW0VyQqrNhYB9umw9NM5P3H3bOMVMPObrJ6PGZYsU
         OFUYgbnILCSfZmOEfZwiLqnranhFHBz65hi8mgYMEF9OB35oNMKi+sEeuz72AbYCBKwh
         +6aO3CnqkzywAm11leNmd0wESkAiyUnoqwkm5+FUX2FGrWoZm4opP9IZ/O0BFtXaeDuh
         Qs1FrQS0U33w3NW0b5IZZ8IJ/jTnI3LpkewGHT1UmKi2CmWKFr8O3ts5njtAiYVpHpYH
         QgxBDM8HwphmruDJhFSTt6MJhpnIIYDH2eqBAkphIuR/2pNTll3lKRy5momZJ1dkG45i
         Ul1Q==
X-Gm-Message-State: AOAM530msm/i8po2/tzo5y6nuR5cuLugZWebt7x16b1woDzsgPzHeWP0
        7sWXxoSl6z95z3rw4dE6slM=
X-Google-Smtp-Source: ABdhPJxrK8CSXwJ9wJcqa131184oXUIWwfLmqn2EON2QuG7DBdvI31pZFgWPEQAEO6i1D0/GFedfsw==
X-Received: by 2002:a63:5a18:: with SMTP id o24mr52037322pgb.459.1639403008517;
        Mon, 13 Dec 2021 05:43:28 -0800 (PST)
Received: from odroid ([114.29.23.242])
        by smtp.gmail.com with ESMTPSA id x1sm10226500pgh.1.2021.12.13.05.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 05:43:28 -0800 (PST)
Date:   Mon, 13 Dec 2021 13:43:19 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Baoquan He <bhe@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hch@lst.de, cl@linux.com,
        John.p.donnelly@oracle.com, kexec@lists.infradead.org,
        stable@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no managed
 pages in DMA zone
Message-ID: <20211213134319.GA997240@odroid>
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-6-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213122712.23805-6-bhe@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Baoquan. I have a question on your code.

On Mon, Dec 13, 2021 at 08:27:12PM +0800, Baoquan He wrote:
> Dma-kmalloc will be created as long as CONFIG_ZONE_DMA is enabled.
> However, it will fail if DMA zone has no managed pages. The failure
> can be seen in kdump kernel of x86_64 as below:
> 
>  CPU: 0 PID: 65 Comm: kworker/u2:1 Not tainted 5.14.0-rc2+ #9
>  Hardware name: Intel Corporation SandyBridge Platform/To be filled by O.E.M., BIOS RMLSDP.86I.R2.28.D690.1306271008 06/27/2013
>  Workqueue: events_unbound async_run_entry_fn
>  Call Trace:
>   dump_stack_lvl+0x57/0x72
>   warn_alloc.cold+0x72/0xd6
>   __alloc_pages_slowpath.constprop.0+0xf56/0xf70
>   __alloc_pages+0x23b/0x2b0
>   allocate_slab+0x406/0x630
>   ___slab_alloc+0x4b1/0x7e0
>   ? sr_probe+0x200/0x600
>   ? lock_acquire+0xc4/0x2e0
>   ? fs_reclaim_acquire+0x4d/0xe0
>   ? lock_is_held_type+0xa7/0x120
>   ? sr_probe+0x200/0x600
>   ? __slab_alloc+0x67/0x90
>   __slab_alloc+0x67/0x90
>   ? sr_probe+0x200/0x600
>   ? sr_probe+0x200/0x600
>   kmem_cache_alloc_trace+0x259/0x270
>   sr_probe+0x200/0x600
>   ......
>   bus_probe_device+0x9f/0xb0
>   device_add+0x3d2/0x970
>   ......
>   __scsi_add_device+0xea/0x100
>   ata_scsi_scan_host+0x97/0x1d0
>   async_run_entry_fn+0x30/0x130
>   process_one_work+0x2b0/0x5c0
>   worker_thread+0x55/0x3c0
>   ? process_one_work+0x5c0/0x5c0
>   kthread+0x149/0x170
>   ? set_kthread_struct+0x40/0x40
>   ret_from_fork+0x22/0x30
>  Mem-Info:
>  ......
> 
> The above failure happened when calling kmalloc() to allocate buffer with
> GFP_DMA. It requests to allocate slab page from DMA zone while no managed
> pages in there.
>  sr_probe()
>  --> get_capabilities()
>      --> buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
> 
> The DMA zone should be checked if it has managed pages, then try to create
> dma-kmalloc.
>

What is problem here?

The slab allocator requested buddy allocator with GFP_DMA,
and then buddy allocator failed to allocate page in DMA zone because
there was no page in DMA zone. and then the buddy allocator called warn_alloc
because it failed at allocating page.

Looking at warn, I don't understand what the problem is.

> ---
>  mm/slab_common.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index e5d080a93009..ae4ef0f8903a 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -878,6 +878,9 @@ void __init create_kmalloc_caches(slab_flags_t flags)
>  {
>  	int i;
>  	enum kmalloc_cache_type type;
> +#ifdef CONFIG_ZONE_DMA
> +	bool managed_dma;
> +#endif
>  
>  	/*
>  	 * Including KMALLOC_CGROUP if CONFIG_MEMCG_KMEM defined
> @@ -905,10 +908,16 @@ void __init create_kmalloc_caches(slab_flags_t flags)
>  	slab_state = UP;
>  
>  #ifdef CONFIG_ZONE_DMA
> +	managed_dma = has_managed_dma();
> +
>  	for (i = 0; i <= KMALLOC_SHIFT_HIGH; i++) {
>  		struct kmem_cache *s = kmalloc_caches[KMALLOC_NORMAL][i];
>  
>  		if (s) {
> +			if (!managed_dma) {
> +				kmalloc_caches[KMALLOC_DMA][i] = kmalloc_caches[KMALLOC_NORMAL][i];
> +				continue;
> +			}

This code is copying normal kmalloc caches to DMA kmalloc caches.
With this code, the kmalloc() with GFP_DMA will succeed even if allocated
memory is not actually from DMA zone. Is that really what you want?

Maybe the function get_capabilities() want to allocate memory
even if it's not from DMA zone, but other callers will not expect that.

Thanks,
Hyeonggon.

>  			kmalloc_caches[KMALLOC_DMA][i] = create_kmalloc_cache(
>  				kmalloc_info[i].name[KMALLOC_DMA],
>  				kmalloc_info[i].size,
> -- 
> 2.17.2
> 
> 
