Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B452F2C7E
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 11:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbhALKSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 05:18:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42413 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404565AbhALKSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 05:18:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610446614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U4eg0K2Y42rlDcaFlSc0InWSXj6Mh1nlrY28P8UwpZY=;
        b=TNERkULKAkAtkkUBA0CKoFjvxnKlhkDd5RA3L+kSGto+00ONcPOf92RYIbBKEsRr5lQo+9
        pJ2gvDB2om99ZNBqNHauTGUH4rAuJ38FKdy4pYF8QJ2yFvOdwcopnBpofA1FpdQCyISwHi
        xY3vSCDVr5dpzcQBlVDqoNtJROe7GIE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-xh76z7DZNvmKh8o0hMopaQ-1; Tue, 12 Jan 2021 05:16:53 -0500
X-MC-Unique: xh76z7DZNvmKh8o0hMopaQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1B37100F340;
        Tue, 12 Jan 2021 10:16:50 +0000 (UTC)
Received: from [10.36.115.140] (ovpn-115-140.ams2.redhat.com [10.36.115.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABB495B4A1;
        Tue, 12 Jan 2021 10:16:48 +0000 (UTC)
Subject: Re: [PATCH v2 4/5] mm: Fix page reference leak in soft_offline_page()
To:     Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Oscar Salvador <osalvador@suse.de>, stable@vger.kernel.org,
        vishal.l.verma@intel.com, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
References: <161044407603.1482714.16630477578392768273.stgit@dwillia2-desk3.amr.corp.intel.com>
 <161044409809.1482714.11965583624142790079.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <95b8c874-7236-dc84-ed36-c29b060ada7a@redhat.com>
Date:   Tue, 12 Jan 2021 11:16:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <161044409809.1482714.11965583624142790079.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12.01.21 10:34, Dan Williams wrote:
> The conversion to move pfn_to_online_page() internal to
> soft_offline_page() missed that the get_user_pages() reference needs to
> be dropped when pfn_to_online_page() fails.
> 
> When soft_offline_page() is handed a pfn_valid() &&
> !pfn_to_online_page() pfn the kernel hangs at dax-device shutdown due to
> a leaked reference.
> 
> Fixes: feec24a6139d ("mm, soft-offline: convert parameter to pfn")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  mm/memory-failure.c |   20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 5a38e9eade94..78b173c7190c 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1885,6 +1885,12 @@ static int soft_offline_free_page(struct page *page)
>  	return rc;
>  }
>  
> +static void put_ref_page(struct page *page)
> +{
> +	if (page)
> +		put_page(page);
> +}
> +
>  /**
>   * soft_offline_page - Soft offline a page.
>   * @pfn: pfn to soft-offline
> @@ -1910,20 +1916,26 @@ static int soft_offline_free_page(struct page *page)
>  int soft_offline_page(unsigned long pfn, int flags)
>  {
>  	int ret;
> -	struct page *page;
>  	bool try_again = true;
> +	struct page *page, *ref_page = NULL;
> +
> +	WARN_ON_ONCE(!pfn_valid(pfn) && (flags & MF_COUNT_INCREASED));
>  
>  	if (!pfn_valid(pfn))
>  		return -ENXIO;
> +	if (flags & MF_COUNT_INCREASED)
> +		ref_page = pfn_to_page(pfn);
> +
>  	/* Only online pages can be soft-offlined (esp., not ZONE_DEVICE). */
>  	page = pfn_to_online_page(pfn);
> -	if (!page)
> +	if (!page) {
> +		put_ref_page(ref_page);
>  		return -EIO;
> +	}
>  
>  	if (PageHWPoison(page)) {
>  		pr_info("%s: %#lx page already poisoned\n", __func__, pfn);
> -		if (flags & MF_COUNT_INCREASED)
> -			put_page(page);
> +		put_ref_page(ref_page);
>  		return 0;
>  	}

Reviewed-by: David Hildenbrand <david@redhat.com>


-- 
Thanks,

David / dhildenb

