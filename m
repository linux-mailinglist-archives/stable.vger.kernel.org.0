Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566714A5BEC
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 13:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235516AbiBAMLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 07:11:15 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:53580 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237805AbiBAMLO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 07:11:14 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DB5481F383;
        Tue,  1 Feb 2022 12:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643717473; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=waTSXVBuauKX5YnIa/Qo7/CVnbpIOue+UFyeuExs0gY=;
        b=hNJhJH1i2ZicjCdh5dcouWfJ4t3wurHaTB8N9eASUJgI+bv1w9u0NDFacQILWhK69y7sE+
        R1CydIbT1KdbAlXKRW4gwb1yZa7pdwYZUBj8bMNIs+aGgce+a4fvnGmEYnb4+LL3ccXnW5
        od8ZYIZ/FhWRGt97afnwYV1pLqFTYRw=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C426EA3B85;
        Tue,  1 Feb 2022 12:11:13 +0000 (UTC)
Date:   Tue, 1 Feb 2022 13:11:13 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v1] drivers/base/memory: add memory block to memory group
 after registration succeeded
Message-ID: <YfkjYZK5EsYjg57Z@dhcp22.suse.cz>
References: <20220128144540.153902-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128144540.153902-1-david@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 28-01-22 15:45:40, David Hildenbrand wrote:
> If register_memory() fails, we freed the memory block but already added
> the memory block to the group list, not good. Let's defer adding the
> block to the memory group to after registering the memory block device.
> 
> We do handle it properly during unregister_memory(), but that's not
> called when the registration fails.
> 
> Fixes: 028fc57a1c36 ("drivers/base/memory: introduce "memory groups" to logically group memory blocks")
> Cc: stable@vger.kernel.org # v5.15+
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> ---
>  drivers/base/memory.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 365cd4a7f239..60c38f9cf1a7 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -663,14 +663,16 @@ static int init_memory_block(unsigned long block_id, unsigned long state,
>  	mem->nr_vmemmap_pages = nr_vmemmap_pages;
>  	INIT_LIST_HEAD(&mem->group_next);
>  
> +	ret = register_memory(mem);
> +	if (ret)
> +		return ret;
> +
>  	if (group) {
>  		mem->group = group;
>  		list_add(&mem->group_next, &group->memory_blocks);
>  	}
>  
> -	ret = register_memory(mem);
> -
> -	return ret;
> +	return 0;
>  }
>  
>  static int add_memory_block(unsigned long base_section_nr)
> -- 
> 2.34.1

-- 
Michal Hocko
SUSE Labs
