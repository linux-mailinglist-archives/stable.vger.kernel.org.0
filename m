Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478FE6C3B04
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 20:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjCUTwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 15:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCUTwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 15:52:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2FE580FA
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679428261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b040N8CNxfbYJhZz1b4CUOkkZsaH37yKg0qihqmHA8c=;
        b=Gn/+ylrGGxwKesZJkMdCyvg4hoB6bK/waMmaIFZhtbUSyIY49I3itNR77VOT3soGns5wki
        LhGvXcVGg9clFmln/v949wOawmxPUBL7ldh/6IqETpB9ay2S2AUafzI7Fez6emSNMpld6l
        Ev/1o4DE8ofj1EB+leIGCySkA04YYx4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-75TqA8wbMX6CHV7V0mGTLw-1; Tue, 21 Mar 2023 15:51:00 -0400
X-MC-Unique: 75TqA8wbMX6CHV7V0mGTLw-1
Received: by mail-qt1-f198.google.com with SMTP id c14-20020ac87d8e000000b003e38726ec8bso1063041qtd.23
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:51:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679428259; x=1682020259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b040N8CNxfbYJhZz1b4CUOkkZsaH37yKg0qihqmHA8c=;
        b=nCkC1PUn0CGd2u9DP+zwHHoDuzF+VoJwLL9QjXBe4PAZapJQc8sJ2ipG6GvDL/bNZc
         4fAjxZOEqKnWE/jEZLs7qOFMPMJ/LzIe0gMM+Bd4bJ8Kkl0+/6UZI73y960vEzuyni0I
         2O9rVqsOfVTpUvmBjsSy85UpF/pUCgJlyzjXbPK+AzfjrgNLdlwfINTZ3QE6xDASOLfy
         BBQC1/fcAefX+0/vMLuphUE2IlZSHKb/GcSo+f8LxWfw3sMJ2Zyqb86BlA5sh+Yj8cBn
         CzJWDLamHxyS3gBZCONgrSQ9+XnGETZDlflyerlSDY/JQhTHRzanx/ZH1EJnaW00lPY0
         ncIw==
X-Gm-Message-State: AO0yUKWAEg/WH97Eh7TzPmlVQ/3y2DZclT8XrQyF6evtdtgD4zX93+PC
        QRN6jIdft9OaKtdtkMgb9yTYuSBEKFfCr8QwEzVO2BC1nS2cV/IrWJnQavjdJ6pPQ5PQx4kTWl6
        3of1WxS3ec+j+IKr88sP6Vgtr
X-Received: by 2002:a05:6214:528e:b0:56e:f7dd:47ad with SMTP id kj14-20020a056214528e00b0056ef7dd47admr5782767qvb.5.1679428259572;
        Tue, 21 Mar 2023 12:50:59 -0700 (PDT)
X-Google-Smtp-Source: AK7set+sVDRBm/gwJm/iFwMYO6SbODkEMeOMDTM6JC6ocZJrlH5/OeyrDjWyRXgOS0eDEVvUVqyHGA==
X-Received: by 2002:a05:6214:528e:b0:56e:f7dd:47ad with SMTP id kj14-20020a056214528e00b0056ef7dd47admr5782743qvb.5.1679428259230;
        Tue, 21 Mar 2023 12:50:59 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id c23-20020a379a17000000b007436d0e9408sm4882350qke.127.2023.03.21.12.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 12:50:58 -0700 (PDT)
Date:   Tue, 21 Mar 2023 15:50:57 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/hugetlb: Fix uffd wr-protection for CoW optimization
 path
Message-ID: <ZBoKod6+twRYvSYz@x1n>
References: <20230321191840.1897940-1-peterx@redhat.com>
 <44aae7fc-fb1f-b38e-bc17-504abf054e3f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <44aae7fc-fb1f-b38e-bc17-504abf054e3f@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 08:36:35PM +0100, David Hildenbrand wrote:
> On 21.03.23 20:18, Peter Xu wrote:
> > This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
> > writable even with uffd-wp bit set.  It only happens with all these
> > conditions met: (1) hugetlb memory (2) private mapping (3) original mapping
> > was missing, then (4) being wr-protected (IOW, pte marker installed).  Then
> > write to the page to trigger.
> > 
> > Userfaultfd-wp trap for hugetlb was implemented in hugetlb_fault() before
> > even reaching hugetlb_wp() to avoid taking more locks that userfault won't
> > need.  However there's one CoW optimization path for missing hugetlb page
> > that can trigger hugetlb_wp() inside hugetlb_no_page(), that can bypass the
> > userfaultfd-wp traps.
> > 
> > A few ways to resolve this:
> > 
> >    (1) Skip the CoW optimization for hugetlb private mapping, considering
> >    that private mappings for hugetlb should be very rare, so it may not
> >    really be helpful to major workloads.  The worst case is we only skip the
> >    optimization if userfaultfd_wp(vma)==true, because uffd-wp needs another
> >    fault anyway.
> > 
> >    (2) Move the userfaultfd-wp handling for hugetlb from hugetlb_fault()
> >    into hugetlb_wp().  The major cons is there're a bunch of locks taken
> >    when calling hugetlb_wp(), and that will make the changeset unnecessarily
> >    complicated due to the lock operations.
> > 
> >    (3) Carry over uffd-wp bit in hugetlb_wp(), so it'll need to fault again
> >    for uffd-wp privately mapped pages.
> > 
> > This patch chose option (3) which contains the minimum changeset (simplest
> > for backport) and also make sure hugetlb_wp() itself will start to be
> > always safe with uffd-wp ptes even if called elsewhere in the future.
> > 
> > This patch will be needed for v5.19+ hence copy stable.
> > 
> > Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> > Cc: linux-stable <stable@vger.kernel.org>
> > Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >   mm/hugetlb.c | 8 +++++---
> >   1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 8bfd07f4c143..22337b191eae 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -5478,7 +5478,7 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
> >   		       struct folio *pagecache_folio, spinlock_t *ptl)
> >   {
> >   	const bool unshare = flags & FAULT_FLAG_UNSHARE;
> > -	pte_t pte;
> > +	pte_t pte, newpte;
> >   	struct hstate *h = hstate_vma(vma);
> >   	struct page *old_page;
> >   	struct folio *new_folio;
> > @@ -5622,8 +5622,10 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
> >   		mmu_notifier_invalidate_range(mm, range.start, range.end);
> >   		page_remove_rmap(old_page, vma, true);
> >   		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
> > -		set_huge_pte_at(mm, haddr, ptep,
> > -				make_huge_pte(vma, &new_folio->page, !unshare));
> > +		newpte = make_huge_pte(vma, &new_folio->page, !unshare);
> > +		if (huge_pte_uffd_wp(pte))
> > +			newpte = huge_pte_mkuffd_wp(newpte);
> > +		set_huge_pte_at(mm, haddr, ptep, newpte);
> >   		folio_set_hugetlb_migratable(new_folio);
> >   		/* Make the old page be freed below */
> >   		new_folio = page_folio(old_page);
> 
> Looks correct to me. Do we have a reproducer?

I used a reproducer for the async mode I wrote (patch 2 attached, need to
change to VM_PRIVATE):

https://lore.kernel.org/all/ZBNr4nohj%2FTw4Zhw@x1n/

I don't think kernel kselftest can trigger it because we don't do strict
checks yet with uffd-wp bits.  I've already started looking into cleanup
the test cases and I do plan to add new tests to cover this.

Meanwhile, let's also wait for an ack from Muhammad.  Even though the async
mode is not part of the code base, it'll be a good test for verifying every
single uffd-wp bit being set or cleared as expected.

> Acked-by: David Hildenbrand <david@redhat.com>

Thanks,

-- 
Peter Xu

