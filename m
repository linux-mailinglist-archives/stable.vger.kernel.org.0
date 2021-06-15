Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609413A772C
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 08:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhFOGj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 02:39:59 -0400
Received: from mail-bn8nam12on2055.outbound.protection.outlook.com ([40.107.237.55]:7040
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229488AbhFOGj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 02:39:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ETWLxL2YegBWM0pwHrqCWtOzLXu7dPm/jhobQG5tx+z0zVH2mVE9JXFjb4zSf/B6VVq5EZzOimo6TqoJ/b2SDNndsJhCpdcHsFM6ko7xz/LJhCvtJ3BtzZbEujrA4RWnOrLFeOhj51tSFfQ7elTWgxWsS70wFpS7R/l26tebaIx+/bl/f6rDuq/uXI5pGw9d2MKXXw7kJb5Px4vhkqb6Wnsq7CSBek8Fulvkqdlkn7T8cjQcwqCEUscfq1x1SfjJgmk3/be/5D8s3z+i83bKQqbfEjnDXKssLbW5urzCkaKJgOFKpoj+9ZiDzKzA2rUF/KLmsi3/CbRQF8ALh9X9JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLvY8I88nEOqAREMACPw8oxrUTmzXT3CQkFP2um3mF0=;
 b=AKkGWJ3rc7pz7PfFIjRdikSGc34CEE3wfnuQRBYUzdVqsgIlD3EPAFkK7Dsfgz/KpD2EO5Ujs7sY1i7aV9LORSHVwPH7hnanO42zkktQwWLMbFqvK+7R3cdEqlAvamLY4h0skgc7AqkcQdMdYqE9cckwzyfue9L+8/tKXnTLzDqEyIM4C1NGPt4YNTZcQM8DoIOPpwEf27qMP2br1VHqCK/TR+e+xzKQGyivJTwJh9bboSErXcw8nQIMjwXUxC4Ok7O4gn5LG8nZ3kVN044rCDhxAKP27dh2Q4SfVEwIgpnf0AlpdreuUEhRqfto5vHW1L3bbKvMQsDNAqDoytekVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLvY8I88nEOqAREMACPw8oxrUTmzXT3CQkFP2um3mF0=;
 b=DSKM3UoUHktjqhm02DPTLqCU/cYKQeMZB7vlrTx6lYqkwO+8l2JSf0+i+k2Xm6bqnBx4YB2b61tUQ6Oass4lzDpmqq26ao3UG0Z8ma1XvilFXLBXAM9pr5lI3hqFMfUdfMzpns2G+A0EbKtAc2ITcDjfuAZqWM5pOTR70toHT57yUdHhskJtiyWbsKxiO/8srlmYG6Mos3jjjiROGqTPacACGsje0V0e7Wx2CBPOc+TnbsM0jJfMzfmF17bgkPM9R3RcK93kQN6o39hAyqs8nWWe2VehodOUj8qT+LQvDPob+u1RtZv0ocp7RN9uNElkysgiZbZlbzmWIbn9ZKfOSg==
Received: from BN6PR16CA0032.namprd16.prod.outlook.com (2603:10b6:405:14::18)
 by DM6PR12MB3659.namprd12.prod.outlook.com (2603:10b6:5:14a::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Tue, 15 Jun
 2021 06:37:52 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::e1) by BN6PR16CA0032.outlook.office365.com
 (2603:10b6:405:14::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend
 Transport; Tue, 15 Jun 2021 06:37:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Tue, 15 Jun 2021 06:37:52 +0000
Received: from [10.2.81.70] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Jun
 2021 06:37:52 +0000
Subject: Re: [PATCH v2] mm/gup: fix try_grab_compound_head() race with
 split_huge_page()
To:     Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>, <stable@vger.kernel.org>
References: <20210615012014.1100672-1-jannh@google.com>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <50d828d1-2ce6-21b4-0e27-fb15daa77561@nvidia.com>
Date:   Mon, 14 Jun 2021 23:37:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210615012014.1100672-1-jannh@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fe914a5-4ac5-4496-fb4b-08d92fc81a1c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3659:
X-Microsoft-Antispam-PRVS: <DM6PR12MB365979230FD11D2250D48B4BA8309@DM6PR12MB3659.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2SPGz6+Z8R+YEg9lQl+jwqlOArBTrGvQ+wwnTJsAzTZtR41AXZG0qknRUtLMT8Zc3r2/ZzQxJt24JnxYuZ+QECFd99ZhG0hi28omcvDi3IO+67qfg0pv73JHT0bQCxVrDn0y1vVuv68miENcxLo87XVcIMTXtXjl0oD537k7ojISrK3GxrQr9pOw05GJ+rVj3hi5lH5VNPZVeqv5XlyBHl0j3xmTbc1+SJ1OfkjoS45VJ7itaMTFS+Qef/jBSEZuwUjTMHSSATHXvpEK7FRkFrzQg96+q26mQ//wpISvc2HM1KZV9JQ4SpvLU2lBz3L7tDEy2K92nTRlms2rVgNse7TET7eD6FJWuF/qlfEGSafguqSkKpCt6BTy6lFAav2kJ4zsOWBW3fkayTf/2KsrhuYaBLyzgchFINkQwjvR63Qar5peOZMXyUcpFWImJxdi5TXkIGCUyQcALE3TjGYRAFSB2lKb1/KzlyaYUZ58lYM0xS9AfZe1k66x4KrDus92dXcX7qTolKbh98k/n7dxYHAXj5EBEq3PFIGeHyQMkCkso64WIgBiw9hTh2dRbAqBjgI5zazC0u5vruw9UVxDtfvEnO3CRC/wpQm2cPtTsMx3fAzcrxPAw7qTl20M234ukZtTTWzoH81Bfc3a6herHgB06T7zmSU86NBGjA8zD0e4u+XI/UCRwT4ZSmFbjbzgh2T8JulrqU6gMeoyb9SL6A==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(46966006)(36840700001)(70206006)(70586007)(8676002)(8936002)(5660300002)(82740400003)(47076005)(356005)(7636003)(31686004)(53546011)(2906002)(31696002)(16576012)(186003)(4326008)(86362001)(478600001)(36906005)(83380400001)(54906003)(316002)(82310400003)(110136005)(2616005)(26005)(336012)(426003)(36756003)(16526019)(36860700001)(14583001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 06:37:52.5868
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fe914a5-4ac5-4496-fb4b-08d92fc81a1c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3659
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/21 6:20 PM, Jann Horn wrote:
> try_grab_compound_head() is used to grab a reference to a page from
> get_user_pages_fast(), which is only protected against concurrent
> freeing of page tables (via local_irq_save()), but not against
> concurrent TLB flushes, freeing of data pages, or splitting of compound
> pages.
> 
> Because no reference is held to the page when try_grab_compound_head()
> is called, the page may have been freed and reallocated by the time its
> refcount has been elevated; therefore, once we're holding a stable
> reference to the page, the caller re-checks whether the PTE still points
> to the same page (with the same access rights).
> 
> The problem is that try_grab_compound_head() has to grab a reference on
> the head page; but between the time we look up what the head page is and
> the time we actually grab a reference on the head page, the compound
> page may have been split up (either explicitly through split_huge_page()
> or by freeing the compound page to the buddy allocator and then
> allocating its individual order-0 pages).
> If that happens, get_user_pages_fast() may end up returning the right
> page but lifting the refcount on a now-unrelated page, leading to
> use-after-free of pages.
> 
> To fix it:
> Re-check whether the pages still belong together after lifting the
> refcount on the head page.
> Move anything else that checks compound_head(page) below the refcount
> increment.
> 
> This can't actually happen on bare-metal x86 (because there, disabling
> IRQs locks out remote TLB flushes), but it can happen on virtualized x86
> (e.g. under KVM) and probably also on arm64. The race window is pretty
> narrow, and constantly allocating and shattering hugepages isn't exactly
> fast; for now I've only managed to reproduce this in an x86 KVM guest with
> an artificially widened timing window (by adding a loop that repeatedly
> calls `inl(0x3f8 + 5)` in `try_get_compound_head()` to force VM exits,
> so that PV TLB flushes are used instead of IPIs).
> 
> As requested on the list, also replace the existing VM_BUG_ON_PAGE()
> with a warning and bailout. Since the existing code only performed the
> BUG_ON check on DEBUG_VM kernels, ensure that the new code also only
> performs the check under that configuration - I don't want to mix two
> logically separate changes together too much.
> The macro VM_WARN_ON_ONCE_PAGE() doesn't return a value on !DEBUG_VM,
> so wrap the whole check in an #ifdef block.
> An alternative would be to change the VM_WARN_ON_ONCE_PAGE() definition
> for !DEBUG_VM such that it always returns false, but since that would
> differ from the behavior of the normal WARN macros, it might be too
> confusing for readers.
> 
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org
> Fixes: 7aef4172c795 ("mm: handle PTE-mapped tail pages in gerneric fast gup implementaiton")
> Signed-off-by: Jann Horn <jannh@google.com>

Looks good. I'll poke around maybe tomorrow and see if there is anything
that might possibly improve the VM_WARN*() macro situation, as a follow up.

One small question below, but in any case,

Reviewed-by: John Hubbard <jhubbard@nvidia.com>

> ---
>   mm/gup.c | 58 +++++++++++++++++++++++++++++++++++++++++---------------
>   1 file changed, 43 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 3ded6a5f26b2..90262e448552 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -43,8 +43,25 @@ static void hpage_pincount_sub(struct page *page, int refs)
>   
>   	atomic_sub(refs, compound_pincount_ptr(page));
>   }
>   
> +/* Equivalent to calling put_page() @refs times. */
> +static void put_page_refs(struct page *page, int refs)
> +{
> +#ifdef CONFIG_DEBUG_VM
> +	if (VM_WARN_ON_ONCE_PAGE(page_ref_count(page) < refs, page))
> +		return;
> +#endif
> +
> +	/*
> +	 * Calling put_page() for each ref is unnecessarily slow. Only the last
> +	 * ref needs a put_page().
> +	 */
> +	if (refs > 1)
> +		page_ref_sub(page, refs - 1);
> +	put_page(page);
> +}
> +
>   /*
>    * Return the compound head page with ref appropriately incremented,
>    * or NULL if that failed.
>    */
> @@ -55,8 +72,23 @@ static inline struct page *try_get_compound_head(struct page *page, int refs)
>   	if (WARN_ON_ONCE(page_ref_count(head) < 0))
>   		return NULL;
>   	if (unlikely(!page_cache_add_speculative(head, refs)))
>   		return NULL;
> +
> +	/*
> +	 * At this point we have a stable reference to the head page; but it
> +	 * could be that between the compound_head() lookup and the refcount
> +	 * increment, the compound page was split, in which case we'd end up
> +	 * holding a reference on a page that has nothing to do with the page
> +	 * we were given anymore.
> +	 * So now that the head page is stable, recheck that the pages still
> +	 * belong together.
> +	 */
> +	if (unlikely(compound_head(page) != head)) {

I was just wondering about what all could happen here. Such as: page gets split,
reallocated into a different-sized compound page, one that still has page pointing
to head. I think that's OK, because we don't look at or change other huge page
fields.

But I thought I'd mention the idea in case anyone else has any clever ideas about
how this simple check might be insufficient here. It seems fine to me, but I
routinely lack enough imagination about concurrent operations. :)

thanks,
-- 
John Hubbard
NVIDIA

> +		put_page_refs(head, refs);
> +		return NULL;
> +	}
> +
>   	return head;
>   }
>   
>   /*
> @@ -94,25 +126,28 @@ __maybe_unused struct page *try_grab_compound_head(struct page *page,
>   		if (unlikely((flags & FOLL_LONGTERM) &&
>   			     !is_pinnable_page(page)))
>   			return NULL;
>   
> +		/*
> +		 * CAUTION: Don't use compound_head() on the page before this
> +		 * point, the result won't be stable.
> +		 */
> +		page = try_get_compound_head(page, refs);
> +		if (!page)
> +			return NULL;
> +
>   		/*
>   		 * When pinning a compound page of order > 1 (which is what
>   		 * hpage_pincount_available() checks for), use an exact count to
>   		 * track it, via hpage_pincount_add/_sub().
>   		 *
>   		 * However, be sure to *also* increment the normal page refcount
>   		 * field at least once, so that the page really is pinned.
>   		 */
> -		if (!hpage_pincount_available(page))
> -			refs *= GUP_PIN_COUNTING_BIAS;
> -
> -		page = try_get_compound_head(page, refs);
> -		if (!page)
> -			return NULL;
> -
>   		if (hpage_pincount_available(page))
>   			hpage_pincount_add(page, refs);
> +		else
> +			page_ref_add(page, refs * (GUP_PIN_COUNTING_BIAS - 1));
>   
>   		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_ACQUIRED,
>   				    orig_refs);
>   
> @@ -134,16 +169,9 @@ static void put_compound_head(struct page *page, int refs, unsigned int flags)
>   		else
>   			refs *= GUP_PIN_COUNTING_BIAS;
>   	}
>   
> -	VM_BUG_ON_PAGE(page_ref_count(page) < refs, page);
> -	/*
> -	 * Calling put_page() for each ref is unnecessarily slow. Only the last
> -	 * ref needs a put_page().
> -	 */
> -	if (refs > 1)
> -		page_ref_sub(page, refs - 1);
> -	put_page(page);
> +	put_page_refs(page, refs);
>   }
>   
>   /**
>    * try_grab_page() - elevate a page's refcount by a flag-dependent amount
> 
> base-commit: 614124bea77e452aa6df7a8714e8bc820b489922
> 

