Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B173B19408A
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 14:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgCZNzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 09:55:32 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45660 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgCZNzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 09:55:32 -0400
Received: by mail-wr1-f67.google.com with SMTP id t7so7847295wrw.12;
        Thu, 26 Mar 2020 06:55:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7DhQ81xB5vr9hXa2g1FwnLrKtnMXgla+HRaUPhbyaoo=;
        b=NQmSEDVL4eBrlJujlMQNhR7K5MjF56T4cBfDev8xnWv4wvWiekbVkUjSC633qY+7NQ
         jlQZOQXOXvGCw0xsai5Qm8UGs7+C3SvkXq4yE59Dz1PyXuhdPzaqbA9aKZZO0AxOKqjZ
         rq5G34Os2iWEF8DRWjGmdfMzgpmR8AiSSYMvj/v5DS2GO2pOVmybwP3xG6Ce7I/efrxW
         sCucBYauSUVWyxHrj3RMmsxUdnJ39OjpA7CairHQHdzmBbY1Cn0XwDcwu12IUUPxoEnj
         Xjx4nkiSZB9Und5GKs+/UKgs0wvf03t4GY4n0TQB+XLJut/x6IhYrRGUJsVRIj+ahLCP
         MduQ==
X-Gm-Message-State: ANhLgQ0i9Okj87yHKDTpAHFBcO6w3ug22DYyyjrgbJNv4MNgv1iY2AwS
        50S79uBRzULQLeV04ws7xXA=
X-Google-Smtp-Source: ADFU+vvEEPOwwRoeOhyk4YebJIpLTpao+Hm8vHrlkqoL6TfU0mSXariPvVLxBhbuPFmLzmcPmKqMLg==
X-Received: by 2002:adf:f4d1:: with SMTP id h17mr10269409wrp.276.1585230928056;
        Thu, 26 Mar 2020 06:55:28 -0700 (PDT)
Received: from localhost (ip-37-188-135-150.eurotel.cz. [37.188.135.150])
        by smtp.gmail.com with ESMTPSA id t16sm3816015wra.17.2020.03.26.06.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 06:55:27 -0700 (PDT)
Date:   Thu, 26 Mar 2020 14:55:26 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, mpe@ellerman.id.au,
        linuxppc-dev@lists.ozlabs.org,
        Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Wei Yang <richardw.yang@linux.intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/sparse: Fix kernel crash with pfn_section_valid
 check
Message-ID: <20200326135526.GR27965@dhcp22.suse.cz>
References: <20200326133235.343616-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326133235.343616-1-aneesh.kumar@linux.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 26-03-20 19:02:35, Aneesh Kumar K.V wrote:
> Fixes the below crash
> 
> BUG: Kernel NULL pointer dereference on read at 0x00000000
> Faulting instruction address: 0xc000000000c3447c
> Oops: Kernel access of bad area, sig: 11 [#1]
> LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
> CPU: 11 PID: 7519 Comm: lt-ndctl Not tainted 5.6.0-rc7-autotest #1
> ...
> NIP [c000000000c3447c] vmemmap_populated+0x98/0xc0
> LR [c000000000088354] vmemmap_free+0x144/0x320
> Call Trace:
>  section_deactivate+0x220/0x240
>  __remove_pages+0x118/0x170
>  arch_remove_memory+0x3c/0x150
>  memunmap_pages+0x1cc/0x2f0
>  devm_action_release+0x30/0x50
>  release_nodes+0x2f8/0x3e0
>  device_release_driver_internal+0x168/0x270
>  unbind_store+0x130/0x170
>  drv_attr_store+0x44/0x60
>  sysfs_kf_write+0x68/0x80
>  kernfs_fop_write+0x100/0x290
>  __vfs_write+0x3c/0x70
>  vfs_write+0xcc/0x240
>  ksys_write+0x7c/0x140
>  system_call+0x5c/0x68
> 
> The crash is due to NULL dereference at
> 
> test_bit(idx, ms->usage->subsection_map); due to ms->usage = NULL; in pfn_section_valid()
> 
> With commit: d41e2f3bd546 ("mm/hotplug: fix hot remove failure in SPARSEMEM|!VMEMMAP case")
> section_mem_map is set to NULL after depopulate_section_mem(). This
> was done so that pfn_page() can work correctly with kernel config that disables
> SPARSEMEM_VMEMMAP. With that config pfn_to_page does
> 
> 	__section_mem_map_addr(__sec) + __pfn;
> where
> 
> static inline struct page *__section_mem_map_addr(struct mem_section *section)
> {
> 	unsigned long map = section->section_mem_map;
> 	map &= SECTION_MAP_MASK;
> 	return (struct page *)map;
> }
> 
> Now with SPASEMEM_VMEMAP enabled, mem_section->usage->subsection_map is used to
> check the pfn validity (pfn_valid()). Since section_deactivate release
> mem_section->usage if a section is fully deactivated, pfn_valid() check after
> a subsection_deactivate cause a kernel crash.
> 
> static inline int pfn_valid(unsigned long pfn)
> {
> ...
> 	return early_section(ms) || pfn_section_valid(ms, pfn);
> }
> 
> where
> 
> static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
> {
> 	int idx = subsection_map_index(pfn);
> 
> 	return test_bit(idx, ms->usage->subsection_map);
> }
> 
> Avoid this by clearing SECTION_HAS_MEM_MAP when mem_section->usage is freed.
> For architectures like ppc64 where large pages are used for vmmemap mapping (16MB),
> a specific vmemmap mapping can cover multiple sections. Hence before a vmemmap
> mapping page can be freed, the kernel needs to make sure there are no valid sections
> within that mapping. Clearing the section valid bit before
> depopulate_section_memap enables this.

I believe that the necessity of clearing the section before the tear
down is worth a comment into the code. Because this is just way to easy
to miss or not be aware at all while looking into the code without git
balme.

> Fixes: d41e2f3bd546 ("mm/hotplug: fix hot remove failure in SPARSEMEM|!VMEMMAP case")
> Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
> Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Wei Yang <richardw.yang@linux.intel.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> ---
>  mm/sparse.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index aadb7298dcef..65599e8bd636 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -781,6 +781,12 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
>  			ms->usage = NULL;
>  		}
>  		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
> +		/*
> +		 * Mark the section invalid so that valid_section()
> +		 * return false. This prevents code from dereferencing
> +		 * ms->usage array.
> +		 */
> +		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
>  	}
>  
>  	if (section_is_early && memmap)
> -- 
> 2.25.1
> 

-- 
Michal Hocko
SUSE Labs
