Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3969B268825
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 11:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgINJTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 05:19:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22393 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726287AbgINJTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 05:19:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600075161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=d/VHcnD9+iyee8hVCb0cdHMMI41k5WsqaJSVgsRT7Lo=;
        b=RBqNUf9ONv+PYghXBZJLcKWKep5iXhpR3sqw9TXxJrXSr8E0+25+rMpnp95kQ5ZuMdRphl
        z7fkwafW99KxkNeOBnBp7BOkp2G5YQUsXW+oyh9b+F09q/L2tEGzvc0az6WFcyUmzxgJHK
        lRylld36M7rbg7AWKwoDHo3Wn40D668=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-c2cIyhRdMLK9h6jSH6fkRg-1; Mon, 14 Sep 2020 05:19:17 -0400
X-MC-Unique: c2cIyhRdMLK9h6jSH6fkRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA037104D3E0;
        Mon, 14 Sep 2020 09:19:14 +0000 (UTC)
Received: from [10.36.114.162] (ovpn-114-162.ams2.redhat.com [10.36.114.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 795CA60CD1;
        Mon, 14 Sep 2020 09:19:06 +0000 (UTC)
Subject: Re: [PATCH 2/3] mm: don't rely on system state to detect hot-plug
 operations
To:     Laurent Dufour <ldufour@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.de>
Cc:     akpm@linux-foundation.org, mhocko@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>
References: <20200911134831.53258-1-ldufour@linux.ibm.com>
 <20200911134831.53258-3-ldufour@linux.ibm.com>
 <f50fe4ae-faf0-6e03-b87e-45ca8c53960d@redhat.com>
 <20200914081921.GA15113@linux>
 <96736256-a0a6-3126-3810-3380532b9621@redhat.com>
 <9990141a-a4e7-6166-c7aa-e0c1199afa38@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 WNyWQQ==
Organization: Red Hat GmbH
Message-ID: <c7fba55b-8f26-771c-2c23-ae88d1630b91@redhat.com>
Date:   Mon, 14 Sep 2020 11:19:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <9990141a-a4e7-6166-c7aa-e0c1199afa38@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14.09.20 11:16, Laurent Dufour wrote:
> Le 14/09/2020 à 10:31, David Hildenbrand a écrit :
>>>> static int register_mem_sect_under_node_hotplug(struct memory_block *mem_blk,
>>>> 						void *arg)
>>>> {
>>>> 	const int nid = *(int *)arg;
>>>> 	int ret;
>>>>
>>>> 	/* Hotplugged memory has no holes and belongs to a single node. */
>>>> 	mem_blk->nid = nid;
>>>> 	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
>>>> 				       &mem_blk->dev.kobj,
>>>> 				       kobject_name(&mem_blk->dev.kobj));
>>>> 	if (ret)
>>>> 		returnr et;
>>>> 	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
>>>> 					&node_devices[nid]->dev.kobj,
>>>> 					kobject_name(&node_devices[nid]->dev.kobj));
>>>>
>>>> }
>>>>
>>>> Cleaner, right? :) No unnecessary checks.
>>>
>>> I tend to agree here, I like more a simplistic version for hotplug.
>>>
>>
>> ... and while we're at it, we should rename register_mem_sect_under_node
>> to something like "register_memory_block_under_node" - "section" is a
>> legacy leftover here.
>>
>> We could factor out both sysfs_create_link_nowarn() calls into something
>> like "do_register_memory_block_under_node" or similar, to minimize code
>> duplication.
>>
>>>> One could argue if link_mem_section_hotplug() would be better than passing around the context.
>>>
>>> I am not sure if I would duplicate the code there.
>>> We could just pass the pointer of the function we want to call to
>>> link_mem_sections? either register_mem_sect_under_node_hotplug or
>>> register_mem_sect_under_node_early?
>>> Would not that be clean and clear enough?
>>
>> I don't particularly like passing around function pointers where it can
>> be avoided (e.g., here exporting 3 functions now instead 1). Makes the
>> interface harder to get IMHO. But I don't really care about that
>> interface, easy to change later on.
>>
> 
> This would lead to the following.
> 
> Do everyone agree?
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 508b80f6329b..444808a7c9b6 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -761,9 +761,32 @@ static int __ref get_nid_for_pfn(unsigned long pfn)
>   	return pfn_to_nid(pfn);
>   }
> 
> +static int do_register_memory_block_under_node(int nid,
> +					       struct memory_block *mem_blk)
> +{
> +	int ret;
> +
> +	/*
> +	 * If this memory block spans multiple nodes, we only indicate
> +	 * the last processed node.
> +	 */
> +	mem_blk->nid = nid;
> +
> +	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
> +				       &mem_blk->dev.kobj,
> +				       kobject_name(&mem_blk->dev.kobj));
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
> +				&node_devices[nid]->dev.kobj,
> +				kobject_name(&node_devices[nid]->dev.kobj));
> +
> +}
> +
>   /* register memory section under specified node if it spans that node */
> -static int register_mem_sect_under_node(struct memory_block *mem_blk,
> -					 void *arg)
> +static int register_mem_block_under_node_early(struct memory_block *mem_blk,
> +					       void *arg)
>   {
>   	unsigned long memory_block_pfns = memory_block_size_bytes() / PAGE_SIZE;
>   	unsigned long start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
> @@ -785,38 +808,35 @@ static int register_mem_sect_under_node(struct 
> memory_block *mem_blk,
>   		}
> 
>   		/*
> -		 * We need to check if page belongs to nid only for the boot
> -		 * case, during hotplug we know that all pages in the memory
> -		 * block belong to the same node.
> +		 * We need to check if page belongs to nid only at the boot
> +		 * case because node's ranges can be interleaved.
>   		 */
> -		if (system_state == SYSTEM_BOOTING) {
> -			page_nid = get_nid_for_pfn(pfn);
> -			if (page_nid < 0)
> -				continue;
> -			if (page_nid != nid)
> -				continue;
> -		}
> -
> -		/*
> -		 * If this memory block spans multiple nodes, we only indicate
> -		 * the last processed node.
> -		 */
> -		mem_blk->nid = nid;
> +		page_nid = get_nid_for_pfn(pfn);
> +		if (page_nid < 0)
> +			continue;
> +		if (page_nid != nid)
> +			continue;
> 
> -		ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
> -					&mem_blk->dev.kobj,
> -					kobject_name(&mem_blk->dev.kobj));
> +		ret = do_register_memory_block_under_node(nid, mem_blk);
>   		if (ret)
>   			return ret;

You have to do an unconditional

return ret;

here AFAIKS. For me this looks much better.

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

