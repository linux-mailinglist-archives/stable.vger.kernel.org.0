Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A117250162
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 17:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgHXPpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 11:45:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25854 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728084AbgHXPo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 11:44:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598283893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n4X+McYKm2HPSDcgicm1bNMEAs9UALlLnJpaukedpRI=;
        b=ERipWCwzvClJ2XlSBMoG6u/SeKB9i2Jl6qolKG0o7hpd46xfWpMOnJ7scGKjpqoBDgpwjx
        0NDO5K6BobWbq2yM8l/otML4ps1pmVvxEo5K9FzEuEWa669tAQKATrM1W27HmR+QkZloE0
        CfoGTnApPwoFW4GYIOU454+zmA8MFVM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-pOch92lbPdqsPTtwkScMyw-1; Mon, 24 Aug 2020 11:44:51 -0400
X-MC-Unique: pOch92lbPdqsPTtwkScMyw-1
Received: by mail-qt1-f200.google.com with SMTP id q6so2489382qtn.15
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 08:44:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n4X+McYKm2HPSDcgicm1bNMEAs9UALlLnJpaukedpRI=;
        b=bMGADTSnOcWkiLVUhcUxS1GPFE15onT7oQ79WcjVO5SOb2Rn4uCSzppKLrGrABh4za
         u8eEmCJopMNLpZf8c60X6EeJTL+euAyiu/YHhUQyYOQq9RZG8t+5yGWOVaIxSKhXHQdl
         RTVjskmG115CJhJ8zZVJrFam/WFKRRBH7m36hPjz+hcdiLqSQGrv9YQYNqHtDGVd9cV0
         zfg6AMlxgNsjC9hBpPNQ7S7AgM0R0KvELw6I6OyxuS2Kn3x8OSw0voNcG+bM0jh2iDzz
         deiEkoAzQD9lHL1zQIokTAJWdKBVOvXW4EDnhS65viv3drbcsSxS02WiInVlxNHhHNiZ
         dyMQ==
X-Gm-Message-State: AOAM533QowROtTYAZrzTWBCBbwNu7Gau+cnVOsbRnMvoVZ9efOJjhO+K
        5c88s1CNoFcycpTLsErRG72EBLtHM6p9o+XBw2j8c+EKcBa3iJO60yuXVssIJyCfbcYVjYQ5Dxf
        MW+tinVyQ6qg/si3q
X-Received: by 2002:ac8:794f:: with SMTP id r15mr5292559qtt.383.1598283890944;
        Mon, 24 Aug 2020 08:44:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyj33JTZ3mBohbfbvoSOhP7o0yBfz9MoVA2SvBqR0S20h54m5UaHWiw9nh8PxL9WOsgX6JFQw==
X-Received: by 2002:ac8:794f:: with SMTP id r15mr5292543qtt.383.1598283890719;
        Mon, 24 Aug 2020 08:44:50 -0700 (PDT)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-11-70-53-122-15.dsl.bell.ca. [70.53.122.15])
        by smtp.gmail.com with ESMTPSA id 199sm7679284qkm.13.2020.08.24.08.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 08:44:50 -0700 (PDT)
Date:   Mon, 24 Aug 2020 11:44:52 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alistair Popple <alistair@popple.id.au>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/migrate: Fixup setting UFFD_WP flag
Message-ID: <20200824154452.GB8605@xz-x1>
References: <20200824083128.12684-1-alistair@popple.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200824083128.12684-1-alistair@popple.id.au>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 06:31:27PM +1000, Alistair Popple wrote:
> Commit f45ec5ff16a75 ("userfaultfd: wp: support swap and page
> migration") introduced support for tracking the uffd wp bit during page
> migration. However the non-swap PTE variant was used to set the flag for
> zone device private pages which are a type of swap page.
> 
> This leads to corruption of the swap offset if the original PTE has the
> uffd_wp flag set.
> 
> Fixes: f45ec5ff16a75 ("userfaultfd: wp: support swap and page migration")
> Signed-off-by: Alistair Popple <alistair@popple.id.au>
> Cc: stable@vger.kernel.org
> ---
>  mm/migrate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 34a842a8eb6a..ddb64253fe3e 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -251,7 +251,7 @@ static bool remove_migration_pte(struct page *page, struct vm_area_struct *vma,
>  				entry = make_device_private_entry(new, pte_write(pte));
>  				pte = swp_entry_to_pte(entry);
>  				if (pte_swp_uffd_wp(*pvmw.pte))
> -					pte = pte_mkuffd_wp(pte);
> +					pte = pte_swp_mkuffd_wp(pte);
>  			}
>  		}

Looks correct... thanks!

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

