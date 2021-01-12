Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928042F2BE7
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 10:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392860AbhALJye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 04:54:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:33960 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730628AbhALJye (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 04:54:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 840D8AF58;
        Tue, 12 Jan 2021 09:53:52 +0000 (UTC)
Date:   Tue, 12 Jan 2021 10:53:50 +0100
From:   Oscar Salvador <osalvador@suse.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@kernel.org>, stable@vger.kernel.org,
        vishal.l.verma@intel.com, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] mm: Fix page reference leak in soft_offline_page()
Message-ID: <20210112095345.GA12534@linux>
References: <161044407603.1482714.16630477578392768273.stgit@dwillia2-desk3.amr.corp.intel.com>
 <161044409809.1482714.11965583624142790079.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161044409809.1482714.11965583624142790079.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 01:34:58AM -0800, Dan Williams wrote:
> The conversion to move pfn_to_online_page() internal to
> soft_offline_page() missed that the get_user_pages() reference needs to
> be dropped when pfn_to_online_page() fails.

I would be more specific here wrt. get_user_pages (madvise).
soft_offline_page gets called from more places besides madvise_*.

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

LGTM, thanks for catching this:

Reviewed-by: Oscar Salvador <osalvador@suse.de>

A nit below.

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

I am not sure this warrants a function.
I would probably go with "if (ref_page).." in the two corresponding places,
but not feeling strong here.

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

Did you see any scenario where this could happen? I understand that you are
adding this because we will leak a reference in case pfn is not valid anymore.

-- 
Oscar Salvador
SUSE L3
