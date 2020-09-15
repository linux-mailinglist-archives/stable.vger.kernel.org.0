Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24270269F95
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 09:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgIOHXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 03:23:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20618 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726048AbgIOHXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 03:23:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600154610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=GmdJeJPWutQtLSHR1n5lblWrWRsNYsl1gfCplur9TbI=;
        b=MDs9oIqMU+bWOXbKJ6iAvFb8/lTLVDIctx3Med+fdRVeMT3z6K+0vRZVR+o3+CUw8q/Lx9
        r47rGPgfXV9k9yYRGCczSSw11zh6EMFL1jhCtSkMjpplqYpwuAgJEhAohONG4E0sENOFDi
        cAcg0825XEjq3/bpuQvNuB1XPg62ezA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-x1uvFzTsN0KlqewEU6U5Nw-1; Tue, 15 Sep 2020 03:23:26 -0400
X-MC-Unique: x1uvFzTsN0KlqewEU6U5Nw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 808B91007B2A;
        Tue, 15 Sep 2020 07:23:24 +0000 (UTC)
Received: from [10.36.114.89] (ovpn-114-89.ams2.redhat.com [10.36.114.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7086968D60;
        Tue, 15 Sep 2020 07:23:21 +0000 (UTC)
Subject: Re: [PATCH v2 3/3] mm: don't panic when links can't be created in
 sysfs
To:     Laurent Dufour <ldufour@linux.ibm.com>, akpm@linux-foundation.org,
        Oscar Salvador <osalvador@suse.de>, mhocko@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>
References: <20200914165042.96218-1-ldufour@linux.ibm.com>
 <20200914165042.96218-4-ldufour@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 WNyWQQ==
Organization: Red Hat GmbH
Message-ID: <a62d5cde-85c9-8650-d5e0-d277c6f7360f@redhat.com>
Date:   Tue, 15 Sep 2020 09:23:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200914165042.96218-4-ldufour@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14.09.20 18:50, Laurent Dufour wrote:
> At boot time, or when doing memory hot-add operations, if the links in
> sysfs can't be created, the system is still able to run, so just report the
> error in the kernel log rather than BUG_ON and potentially make system
> unusable because the callpath can be called with locks held.
> 
> Since the number of memory blocks managed could be high, the messages are
> rate limited.
> 
> As a consequence, link_mem_sections() has no status to report anymore.
> 
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/base/node.c  | 33 +++++++++++++++++++++------------
>  include/linux/node.h | 16 +++++++---------
>  mm/memory_hotplug.c  |  5 ++---
>  3 files changed, 30 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 01ee73c9d675..249b2ba6dc81 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -761,8 +761,8 @@ static int __ref get_nid_for_pfn(unsigned long pfn)
>  	return pfn_to_nid(pfn);
>  }
>  
> -static int do_register_memory_block_under_node(int nid,
> -					       struct memory_block *mem_blk)
> +static void do_register_memory_block_under_node(int nid,
> +						struct memory_block *mem_blk)
>  {
>  	int ret;
>  
> @@ -775,12 +775,19 @@ static int do_register_memory_block_under_node(int nid,
>  	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
>  				       &mem_blk->dev.kobj,
>  				       kobject_name(&mem_blk->dev.kobj));
> -	if (ret)
> -		return ret;
> +	if (ret && ret != -EEXIST)
> +		dev_err_ratelimited(&node_devices[nid]->dev,
> +				    "can't create link to %s in sysfs (%d)\n",
> +				    kobject_name(&mem_blk->dev.kobj), ret);
>  
> -	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
> +	ret = sysfs_create_link_nowarn(&mem_blk->dev.kobj,
>  				&node_devices[nid]->dev.kobj,
>  				kobject_name(&node_devices[nid]->dev.kobj));
> +	if (ret && ret != -EEXIST)
> +		dev_err_ratelimited(&mem_blk->dev,
> +				    "can't create link to %s in sysfs (%d)\n",
> +				    kobject_name(&node_devices[nid]->dev.kobj),
> +				    ret);
>  }
>  
>  /* register memory section under specified node if it spans that node */
> @@ -817,7 +824,8 @@ static int register_mem_block_under_node_early(struct memory_block *mem_blk,
>  			continue;
>  
>  		/* The memory block is registered to the first matching node */
> -		return do_register_memory_block_under_node(nid, mem_blk);
> +		do_register_memory_block_under_node(nid, mem_blk);
> +		return 0;
>  	}
>  	/* mem section does not span the specified node */
>  	return 0;
> @@ -832,7 +840,8 @@ static int register_mem_block_under_node_hotplug(struct memory_block *mem_blk,
>  {
>  	int nid = *(int *)arg;
>  
> -	return do_register_memory_block_under_node(nid, mem_blk);
> +	do_register_memory_block_under_node(nid, mem_blk);
> +	return 0;
>  }
>  
>  /*
> @@ -850,8 +859,8 @@ void unregister_memory_block_under_nodes(struct memory_block *mem_blk)
>  			  kobject_name(&node_devices[mem_blk->nid]->dev.kobj));
>  }
>  
> -int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
> -		      enum meminit_context context)
> +void link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
> +		       enum meminit_context context)
>  {
>  	walk_memory_blocks_func_t func;
>  
> @@ -860,9 +869,9 @@ int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
>  	else
>  		func = register_mem_block_under_node_early;
>  
> -	return walk_memory_blocks(PFN_PHYS(start_pfn),
> -				  PFN_PHYS(end_pfn - start_pfn), (void *)&nid,
> -				  func);
> +	walk_memory_blocks(PFN_PHYS(start_pfn), PFN_PHYS(end_pfn - start_pfn),
> +			   (void *)&nid, func);
> +	return;
>  }
>  
>  #ifdef CONFIG_HUGETLBFS
> diff --git a/include/linux/node.h b/include/linux/node.h
> index 014ba3ab2efd..8e5a29897936 100644
> --- a/include/linux/node.h
> +++ b/include/linux/node.h
> @@ -99,15 +99,14 @@ extern struct node *node_devices[];
>  typedef  void (*node_registration_func_t)(struct node *);
>  
>  #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_NUMA)
> -int link_mem_sections(int nid, unsigned long start_pfn,
> -		      unsigned long end_pfn,
> -		      enum meminit_context context);
> +void link_mem_sections(int nid, unsigned long start_pfn,
> +		       unsigned long end_pfn,
> +		       enum meminit_context context);
>  #else
> -static inline int link_mem_sections(int nid, unsigned long start_pfn,
> -				    unsigned long end_pfn,
> -				    enum meminit_context context)
> +static inline void link_mem_sections(int nid, unsigned long start_pfn,
> +				     unsigned long end_pfn,
> +				     enum meminit_context context)
>  {
> -	return 0;
>  }
>  #endif
>  
> @@ -130,8 +129,7 @@ static inline int register_one_node(int nid)
>  		if (error)
>  			return error;
>  		/* link memory sections under this node */
> -		error = link_mem_sections(nid, start_pfn, end_pfn,
> -					  MEMINIT_EARLY);
> +		link_mem_sections(nid, start_pfn, end_pfn, MEMINIT_EARLY);
>  	}
>  
>  	return error;
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 03df20078827..01e01a530d38 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1080,9 +1080,8 @@ int __ref add_memory_resource(int nid, struct resource *res)
>  	}
>  
>  	/* link memory sections under this node.*/
> -	ret = link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1),
> -				MEMINIT_HOTPLUG);
> -	BUG_ON(ret);
> +	link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1),
> +			  MEMINIT_HOTPLUG);
>  
>  	/* create new memmap entry */
>  	if (!strcmp(res->name, "System RAM"))
> 

I just remember that I still have some cleanup patches lying around that
rework the whole node onlining on the add_memory() path, being able to
fail in a nice way rather than ignoring errors. Anyhow, this is good
enough for now

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

