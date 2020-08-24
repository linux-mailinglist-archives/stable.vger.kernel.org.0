Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A2625015F
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 17:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgHXPoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 11:44:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30853 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728048AbgHXPoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 11:44:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598283844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0i9IZKkc0Dhp8DbMenSviRn9HstWX9W90fOqMQhInh8=;
        b=e+P+x6rrI88yQGhyku9pKy6/wIGRM2PiJca4hjg+itT3J4HGM8S1YPgecvJerRe/mMaieh
        z0tKrnSGcM267QM5/McryqvXDIKpE3jSRu6c6XjRsLc1lBIpAUTOQdale4ZlfEsvp+Ft/T
        XOPBkzOfPDMrkbc56aacoOOit/+X/oU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-sg7hVPb_O0qaQPgkA17hmw-1; Mon, 24 Aug 2020 11:43:58 -0400
X-MC-Unique: sg7hVPb_O0qaQPgkA17hmw-1
Received: by mail-qv1-f69.google.com with SMTP id d19so6603484qvm.23
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 08:43:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0i9IZKkc0Dhp8DbMenSviRn9HstWX9W90fOqMQhInh8=;
        b=Il20ySBPXDahJnbxzfx6C9DgcbA4jeAhr93sjiKC+VQIjz3/c23E549nnbfqiGk1uQ
         DDmp0WfjOGJHK1duzGKACcmgYGK0KXUMwo08mT08ugpdXgXjhJhkrWtToaU4ns6zGVZM
         A23qhz163abkbEuuixwxVDozCu/HBt/EaEQeY1n3St2VSSZnPzAmcHgiuX/Hr+bM961E
         bN4QDdMh0ZPtbGf8CXVX7aGTmZlY9UoanHEeq6vnut5/W2SCQWyS5P1J84gtZiaMDVEs
         JaqV6J234Pw+EYug4sj2TTTbJv4PO/7symiwLl5WSat8Gt09fWH6B/NGlnqoVtjO0I+x
         p39Q==
X-Gm-Message-State: AOAM533xMyZT2RcKGSJj5bOeZ4AQF7GoAwQn349+LYrg9oTzTbmA/K6i
        XTvDCn5A2P5XxlOBr16mePgiOyanrYIP9ByM5OjStcgoYczEPtU2thxeYM7kf4s5OtixzAH3IS6
        mM631bxJLwqKvtYaC
X-Received: by 2002:ac8:7609:: with SMTP id t9mr5240821qtq.158.1598283838048;
        Mon, 24 Aug 2020 08:43:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxf1nPQ6m44jqCsojNRTxobh/8MYBqMZU7QtrQAUw5wKoCqbw5zZlf7RuA0vstQT31cJBGWCQ==
X-Received: by 2002:ac8:7609:: with SMTP id t9mr5240796qtq.158.1598283837705;
        Mon, 24 Aug 2020 08:43:57 -0700 (PDT)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-11-70-53-122-15.dsl.bell.ca. [70.53.122.15])
        by smtp.gmail.com with ESMTPSA id s20sm3111044qtj.63.2020.08.24.08.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 08:43:56 -0700 (PDT)
Date:   Mon, 24 Aug 2020 11:43:59 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alistair Popple <alistair@popple.id.au>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/rmap: Fixup copying of soft dirty and uffd ptes
Message-ID: <20200824154359.GA8605@xz-x1>
References: <20200824083128.12684-1-alistair@popple.id.au>
 <20200824083128.12684-2-alistair@popple.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200824083128.12684-2-alistair@popple.id.au>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 06:31:28PM +1000, Alistair Popple wrote:
> During memory migration a pte is temporarily replaced with a migration
> swap pte. Some pte bits from the existing mapping such as the soft-dirty
> and uffd write-protect bits are preserved by copying these to the
> temporary migration swap pte.
> 
> However these bits are not stored at the same location for swap and
> non-swap ptes. Therefore testing these bits requires using the
> appropriate helper function for the given pte type.
> 
> Unfortunately several code locations were found where the wrong helper
> function is being used to test soft_dirty and uffd_wp bits which leads
> to them getting incorrectly set or cleared during page-migration.
> 
> Fix these by using the correct tests based on pte type.
> 
> Fixes: a5430dda8a3a ("mm/migrate: support un-addressable ZONE_DEVICE page in migration")
> Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
> Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
> Signed-off-by: Alistair Popple <alistair@popple.id.au>
> Cc: stable@vger.kernel.org
> ---
>  mm/migrate.c | 6 ++++--
>  mm/rmap.c    | 9 +++++++--
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ddb64253fe3e..5bea19c496af 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2427,9 +2427,11 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			entry = make_migration_entry(page, mpfn &
>  						     MIGRATE_PFN_WRITE);
>  			swp_pte = swp_entry_to_pte(entry);
> -			if (pte_soft_dirty(pte))
> +			if ((is_swap_pte(pte) && pte_swp_soft_dirty(pte))
> +				|| (!is_swap_pte(pte) && pte_soft_dirty(pte)))
>  				swp_pte = pte_swp_mksoft_dirty(swp_pte);
> -			if (pte_uffd_wp(pte))
> +			if ((is_swap_pte(pte) && pte_swp_uffd_wp(pte))
> +				|| (!is_swap_pte(pte) && pte_uffd_wp(pte)))
>  				swp_pte = pte_swp_mkuffd_wp(swp_pte);
>  			set_pte_at(mm, addr, ptep, swp_pte);

The worst case is we'll call is_swap_pte() four times for each entry. Also
considering we know it's not a pte_none() when reach here, how about:

  if (pte_present(pte)) {
    // pte handling of both soft dirty and uffd-wp
  } else {
    // swap handling of both soft dirty and uffd-wp
  }

?

Thanks,

-- 
Peter Xu

