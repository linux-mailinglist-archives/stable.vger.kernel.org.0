Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5818E6C7F8F
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 15:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbjCXOMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 10:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbjCXOMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 10:12:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4F1CC2A
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 07:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679667096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=67+EwHu+QToRo/sF9RBeGijI61E5QqD34PaUertJaVA=;
        b=XoNmC+Xqq28yp/NgZmy1ENWY1Rtp9Z5OwKAUcXt1fX03xUjVFcsDoAOufd8vpxy7tA9AoT
        4PXwUvqagsGtte9RO/fNjVDkkGTESF4Mmyf1EheVqqb/hqAuoRmaOu+7Y4/x37uj+Xlr1A
        tksDRqYlTJjSqWvtLCA+C3lpsA2Rlc8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-T-hsMmt1NoGZVMvyZVbXFw-1; Fri, 24 Mar 2023 10:11:34 -0400
X-MC-Unique: T-hsMmt1NoGZVMvyZVbXFw-1
Received: by mail-qt1-f200.google.com with SMTP id w13-20020ac857cd000000b003e37d3e6de2so1095408qta.16
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 07:11:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679667094; x=1682259094;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=67+EwHu+QToRo/sF9RBeGijI61E5QqD34PaUertJaVA=;
        b=jycUzSUMlKpMpgngTDok3IL3NaWqgtCcMlUJFgHvfFI0B4FFPhBfvsK1KCQJ/PmL/l
         a/XnblbghHB7Biw4Ka4mhU4K/BxsbGvMmP476quqLTIREQm8D1vDvnJ3Js833HY9PPy4
         u8NzSgctQgjUk7M4IyPGhO1Z0EE9ADQ/XzNj3i3Vnt3hVdIORqKb/08HT2lFU0zk9pts
         RVFu3N2oxoLbHOD1ncvDUuMoGwPXQC3V6R+jCDTF0JZwQwIr/Hf1wp1sNpYQV7q+idEA
         1cBOpMktpQbkooIX9YKWCBKWKJtzGzAjL45VK/wHMRipspvgYuJdtzq+srC0LXuiT1DA
         RTBQ==
X-Gm-Message-State: AO0yUKXgV9IbTZG+hbKGzMzSnJPTiZHgtV0992d4fkAt1JiFkQLryhtK
        8XUjTUrXGNF1rDlL9BtxQa5zmBg7uQg50IjdzDmNDmrFPtL5mhHcWViNIb3DxpPg36Wn7kCflFi
        jKdDzNCwm4RuLtUot
X-Received: by 2002:a05:622a:1829:b0:3e3:8f8c:b92f with SMTP id t41-20020a05622a182900b003e38f8cb92fmr5523899qtc.5.1679667094001;
        Fri, 24 Mar 2023 07:11:34 -0700 (PDT)
X-Google-Smtp-Source: AK7set8y3AMK7uJVBJ0ROFsgRE9C0G+cSC8bK88uYmM8vWRjvzsRIBReBY87Ayov21XFeK4yUFjTSg==
X-Received: by 2002:a05:622a:1829:b0:3e3:8f8c:b92f with SMTP id t41-20020a05622a182900b003e38f8cb92fmr5523859qtc.5.1679667093676;
        Fri, 24 Mar 2023 07:11:33 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id c9-20020ac80549000000b003d8d1ec2672sm12584782qth.89.2023.03.24.07.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 07:11:33 -0700 (PDT)
Date:   Fri, 24 Mar 2023 10:11:31 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/hugetlb: Fix uffd wr-protection for CoW optimization
 path
Message-ID: <ZB2vkzirmb3rgXCW@x1n>
References: <20230321191840.1897940-1-peterx@redhat.com>
 <44aae7fc-fb1f-b38e-bc17-504abf054e3f@redhat.com>
 <ZBoKod6+twRYvSYz@x1n>
 <f411b983-0c47-73f8-775b-928fcf61620a@collabora.com>
 <ZBzOqwF2wrHgBVZb@x1n>
 <bade768b-5078-1657-802d-fe20e50a5725@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bade768b-5078-1657-802d-fe20e50a5725@redhat.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 24, 2023 at 09:51:27AM +0100, David Hildenbrand wrote:
> On 23.03.23 23:11, Peter Xu wrote:
> > On Thu, Mar 23, 2023 at 08:33:07PM +0500, Muhammad Usama Anjum wrote:
> > > Hi Peter,
> > > 
> > > Sorry for late reply.
> > > 
> > > On 3/22/23 12:50 AM, Peter Xu wrote:
> > > > On Tue, Mar 21, 2023 at 08:36:35PM +0100, David Hildenbrand wrote:
> > > > > On 21.03.23 20:18, Peter Xu wrote:
> > > > > > This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
> > > > > > writable even with uffd-wp bit set.  It only happens with all these
> > > > > > conditions met: (1) hugetlb memory (2) private mapping (3) original mapping
> > > > > > was missing, then (4) being wr-protected (IOW, pte marker installed).  Then
> > > > > > write to the page to trigger.
> > > > > > 
> > > > > > Userfaultfd-wp trap for hugetlb was implemented in hugetlb_fault() before
> > > > > > even reaching hugetlb_wp() to avoid taking more locks that userfault won't
> > > > > > need.  However there's one CoW optimization path for missing hugetlb page
> > > > > > that can trigger hugetlb_wp() inside hugetlb_no_page(), that can bypass the
> > > > > > userfaultfd-wp traps.
> > > > > > 
> > > > > > A few ways to resolve this:
> > > > > > 
> > > > > >     (1) Skip the CoW optimization for hugetlb private mapping, considering
> > > > > >     that private mappings for hugetlb should be very rare, so it may not
> > > > > >     really be helpful to major workloads.  The worst case is we only skip the
> > > > > >     optimization if userfaultfd_wp(vma)==true, because uffd-wp needs another
> > > > > >     fault anyway.
> > > > > > 
> > > > > >     (2) Move the userfaultfd-wp handling for hugetlb from hugetlb_fault()
> > > > > >     into hugetlb_wp().  The major cons is there're a bunch of locks taken
> > > > > >     when calling hugetlb_wp(), and that will make the changeset unnecessarily
> > > > > >     complicated due to the lock operations.
> > > > > > 
> > > > > >     (3) Carry over uffd-wp bit in hugetlb_wp(), so it'll need to fault again
> > > > > >     for uffd-wp privately mapped pages.
> > > > > > 
> > > > > > This patch chose option (3) which contains the minimum changeset (simplest
> > > > > > for backport) and also make sure hugetlb_wp() itself will start to be
> > > > > > always safe with uffd-wp ptes even if called elsewhere in the future.
> > > > > > 
> > > > > > This patch will be needed for v5.19+ hence copy stable.
> > > > > > 
> > > > > > Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> > > > > > Cc: linux-stable <stable@vger.kernel.org>
> > > > > > Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
> > > > > > Signed-off-by: Peter Xu <peterx@redhat.com>
> > > > > > ---
> > > > > >    mm/hugetlb.c | 8 +++++---
> > > > > >    1 file changed, 5 insertions(+), 3 deletions(-)
> > > > > > 
> > > > > > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > > > > > index 8bfd07f4c143..22337b191eae 100644
> > > > > > --- a/mm/hugetlb.c
> > > > > > +++ b/mm/hugetlb.c
> > > > > > @@ -5478,7 +5478,7 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
> > > > > >    		       struct folio *pagecache_folio, spinlock_t *ptl)
> > > > > >    {
> > > > > >    	const bool unshare = flags & FAULT_FLAG_UNSHARE;
> > > > > > -	pte_t pte;
> > > > > > +	pte_t pte, newpte;
> > > > > >    	struct hstate *h = hstate_vma(vma);
> > > > > >    	struct page *old_page;
> > > > > >    	struct folio *new_folio;
> > > > > > @@ -5622,8 +5622,10 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
> > > > > >    		mmu_notifier_invalidate_range(mm, range.start, range.end);
> > > > > >    		page_remove_rmap(old_page, vma, true);
> > > > > >    		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
> > > > > > -		set_huge_pte_at(mm, haddr, ptep,
> > > > > > -				make_huge_pte(vma, &new_folio->page, !unshare));
> > > > > > +		newpte = make_huge_pte(vma, &new_folio->page, !unshare);
> > > > > > +		if (huge_pte_uffd_wp(pte))
> > > > > > +			newpte = huge_pte_mkuffd_wp(newpte);
> > > > > > +		set_huge_pte_at(mm, haddr, ptep, newpte);
> > > > > >    		folio_set_hugetlb_migratable(new_folio);
> > > > > >    		/* Make the old page be freed below */
> > > > > >    		new_folio = page_folio(old_page);
> > > > > 
> > > > > Looks correct to me. Do we have a reproducer?
> > > > 
> > > > I used a reproducer for the async mode I wrote (patch 2 attached, need to
> > > > change to VM_PRIVATE):
> > > > 
> > > > https://lore.kernel.org/all/ZBNr4nohj%2FTw4Zhw@x1n/
> > > > 
> > > > I don't think kernel kselftest can trigger it because we don't do strict
> > > > checks yet with uffd-wp bits.  I've already started looking into cleanup
> > > > the test cases and I do plan to add new tests to cover this.
> > > > 
> > > > Meanwhile, let's also wait for an ack from Muhammad.  Even though the async
> > > > mode is not part of the code base, it'll be a good test for verifying every
> > > > single uffd-wp bit being set or cleared as expected.
> > > I've tested by applying this patch. But the bug is still there. Just like
> > > Peter has mentioned, we are using our in progress patches related to
> > > pagemap_scan ioctl and userfaultd wp async patches to reproduce it.
> > > 
> > > To reproduce please build kernel and run pagemap_ioctl test in mm in
> > > hugetlb_mem_reproducer branch:
> > > https://gitlab.collabora.com/usama.anjum/linux-mainline/-/tree/hugetlb_mem_reproducer
> > > 
> > > In case you have any question on how to reproduce, please let me know. I'll
> > > try to provide a cleaner alternative.
> > 
> > Hmm, I think my current fix is incomplete if not wrong.  The root cause
> > should still be valid, however I overlooked another path:
> > 
> > 	if (page_mapcount(old_page) == 1 && PageAnon(old_page)) {
> > 		if (!PageAnonExclusive(old_page))
> > 			page_move_anon_rmap(old_page, vma);
> > 		if (likely(!unshare))
> > 			set_huge_ptep_writable(vma, haddr, ptep);
> > 
> > 		delayacct_wpcopy_end();
> > 		return 0;
> > 	}
> > 
> > We should bail out early in this path, and it'll be even easier we always
> > bail out hugetlb_wp() as long as uffd-wp is detected because userfault
> > should always be handled before any decision to CoW.
> > 
> > v2 attached.. Please give it another shot.
> 
> Hmmm, I think you must only do that for !unshare (FAULT_FLAG_WRITE).
> Otherwise you'll never be able to resolve an unsharing request on a r/o
> mapped hugetlb page that has the uffd-wp set?
> 
> Or am I missing something?

No, I think you're right. I'll fix that up when posting a v3. Thanks,

-- 
Peter Xu

