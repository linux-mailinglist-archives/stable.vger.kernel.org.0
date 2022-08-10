Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375DB58E957
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 11:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiHJJND convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 10 Aug 2022 05:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiHJJNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 05:13:02 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B12D86C22
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 02:13:00 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-252-W1bmLIhxOFKkLHIJ4pvk4Q-1; Wed, 10 Aug 2022 10:12:58 +0100
X-MC-Unique: W1bmLIhxOFKkLHIJ4pvk4Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Wed, 10 Aug 2022 10:12:57 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Wed, 10 Aug 2022 10:12:57 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Hildenbrand' <david@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH v2] mm/gup: fix FOLL_FORCE COW security issue and remove
 FOLL_COW
Thread-Topic: [PATCH v2] mm/gup: fix FOLL_FORCE COW security issue and remove
 FOLL_COW
Thread-Index: AQHYrJfABWLOSW6JU02QVOI07vnRa62n2Fmw
Date:   Wed, 10 Aug 2022 09:12:57 +0000
Message-ID: <afab7f23d10145b590aef44b3242db64@AcuMS.aculab.com>
References: <20220809205640.70916-1-david@redhat.com>
In-Reply-To: <20220809205640.70916-1-david@redhat.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand
> Sent: 09 August 2022 21:57
...

These two functions seem to contain a lot of the same tests.
They also seem a bit large for 'inline'.

> -static inline bool can_follow_write_pte(pte_t pte, unsigned int flags)
> +/* FOLL_FORCE can write to even unwritable PTEs in COW mappings. */
> +static inline bool can_follow_write_pte(pte_t pte, struct page *page,
> +					struct vm_area_struct *vma,
> +					unsigned int flags)
>  {
> -	return pte_write(pte) ||
> -		((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte));
> +	/* If the pte is writable, we can write to the page. */
> +	if (pte_write(pte))
> +		return true;
> +
> +	/* Maybe FOLL_FORCE is set to override it? */
> +	if (!(flags & FOLL_FORCE))
> +		return false;
> +
> +	/* But FOLL_FORCE has no effect on shared mappings */
> +	if (vma->vm_flags & (VM_MAYSHARE | VM_SHARED))
> +		return false;
> +
> +	/* ... or read-only private ones */
> +	if (!(vma->vm_flags & VM_MAYWRITE))
> +		return false;
> +
> +	/* ... or already writable ones that just need to take a write fault */
> +	if (vma->vm_flags & VM_WRITE)
> +		return false;
> +
> +	/*
> +	 * See can_change_pte_writable(): we broke COW and could map the page
> +	 * writable if we have an exclusive anonymous page ...
> +	 */
> +	if (!page || !PageAnon(page) || !PageAnonExclusive(page))
> +		return false;
> +
> +	/* ... and a write-fault isn't required for other reasons. */
> +	if (vma_soft_dirty_enabled(vma) && !pte_soft_dirty(pte))
> +		return false;
> +	return !userfaultfd_pte_wp(vma, pte);
>  }
...
> -static inline bool can_follow_write_pmd(pmd_t pmd, unsigned int flags)
> +/* FOLL_FORCE can write to even unwritable PMDs in COW mappings. */
> +static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
> +					struct vm_area_struct *vma,
> +					unsigned int flags)
>  {
> -	return pmd_write(pmd) ||
> -	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));
> +	/* If the pmd is writable, we can write to the page. */
> +	if (pmd_write(pmd))
> +		return true;
> +
> +	/* Maybe FOLL_FORCE is set to override it? */
> +	if (!(flags & FOLL_FORCE))
> +		return false;
> +
> +	/* But FOLL_FORCE has no effect on shared mappings */
> +	if (vma->vm_flags & (VM_MAYSHARE | VM_SHARED))
> +		return false;
> +
> +	/* ... or read-only private ones */
> +	if (!(vma->vm_flags & VM_MAYWRITE))
> +		return false;
> +
> +	/* ... or already writable ones that just need to take a write fault */
> +	if (vma->vm_flags & VM_WRITE)
> +		return false;
> +
> +	/*
> +	 * See can_change_pte_writable(): we broke COW and could map the page
> +	 * writable if we have an exclusive anonymous page ...
> +	 */
> +	if (!page || !PageAnon(page) || !PageAnonExclusive(page))
> +		return false;
> +
> +	/* ... and a write-fault isn't required for other reasons. */
> +	if (vma_soft_dirty_enabled(vma) && !pmd_soft_dirty(pmd))
> +		return false;
> +	return !userfaultfd_huge_pmd_wp(vma, pmd);
>  }

Perhaps only the initial call (common success path?) should
be inlined?
With the flags and vma tests being moved to an inline helper.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

