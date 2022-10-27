Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB16C60ED4B
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 03:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbiJ0BM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 21:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiJ0BM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 21:12:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B051004A0
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 18:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666833176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7LHEwZt6NE9p0O2o9rqZG9ZD7dBOAwFNfTboGZKKsJo=;
        b=LZHdtqgQahgccevnRYGeUkVU0k0aHcz/KBOZz1k3m/9yhE9aIRva0Q3K/gVEAjGDzUSFU0
        vG+E7NVKGcVqzCFzfp2PloalRJ20Et93exyGfePJiHm5LWpbeUJn3U2iXHazGh8GRtHj+m
        o6bgvB2KD7BFUbmKf7U8z7xkuJT305Q=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-483-hM7pKHb_O-i5lsWkdZ5SOw-1; Wed, 26 Oct 2022 21:12:54 -0400
X-MC-Unique: hM7pKHb_O-i5lsWkdZ5SOw-1
Received: by mail-il1-f197.google.com with SMTP id h8-20020a056e021b8800b002f9c2e31750so247367ili.1
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 18:12:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7LHEwZt6NE9p0O2o9rqZG9ZD7dBOAwFNfTboGZKKsJo=;
        b=mHBopOk8U2jo8GdiWyjVMvj3vSFImVAA8pntDHDhuNMoO6VMMflAKsoYgAxFQ7Zdj9
         rG7Zqh0ZwfQPAy7hMV3OuTfanDUX24U+39ZjQsXpjqwsD/t8tTK4Kb6oXq684AfXAAay
         raK8qanDb+33ORaP39Nagw7mAt2FnDcXjybuwk5Mp4jf8PMS8jQW8dZnTkklJYTzg/NQ
         /sa7gBSZBByQghtavr+y2RVmTxcGTFEx0T8kRIiC/UqmmkYxMcsOvXGl/IWiVRGg3J++
         7kh3VJ/3NXEKpt3oUVmPL09IbP1ahm504+is6vrL7KU2Kni+nxtipofJAuF3NdOEYYJX
         Ad9Q==
X-Gm-Message-State: ACrzQf1uZ7mnHzXKcCRk6V6OvSeLb5gIWwGfTDt6ZLrkgDs3F3NrQ25Q
        BeuelExXJxQ+HYYFjQ0RtekwITW4+0q1Oilc3lcB4KysLz3r+gPIqA+GzNd4Vk9tDjCXpyozynS
        /SXaj/445qzx2OHls
X-Received: by 2002:a05:6638:258b:b0:375:1760:601a with SMTP id s11-20020a056638258b00b003751760601amr3609710jat.306.1666833174053;
        Wed, 26 Oct 2022 18:12:54 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM77oRkrGA5POPQJaFtphITuaickTFdK+V8/HWV7o8VWC5zaUNiIgRNb8IfOubF1U5Yj1+5fCA==
X-Received: by 2002:a05:6638:258b:b0:375:1760:601a with SMTP id s11-20020a056638258b00b003751760601amr3609666jat.306.1666833173584;
        Wed, 26 Oct 2022 18:12:53 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id cn11-20020a0566383a0b00b00349e1922573sm43680jab.170.2022.10.26.18.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 18:12:52 -0700 (PDT)
Date:   Wed, 26 Oct 2022 21:12:50 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
Message-ID: <Y1nbErXmHkyrzt8F@x1n>
References: <20221023025047.470646-1-mike.kravetz@oracle.com>
 <Y1mpwKpwsiN6u6r7@x1n>
 <Y1nImUVseAOpXwPv@monkey>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YVsPJK3aT2ohvMA8"
Content-Disposition: inline
In-Reply-To: <Y1nImUVseAOpXwPv@monkey>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YVsPJK3aT2ohvMA8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Oct 26, 2022 at 04:54:01PM -0700, Mike Kravetz wrote:
> On 10/26/22 17:42, Peter Xu wrote:
> > Hi, Mike,
> > 
> > On Sat, Oct 22, 2022 at 07:50:47PM -0700, Mike Kravetz wrote:
> > 
> > [...]
> > 
> > > -void __unmap_hugepage_range_final(struct mmu_gather *tlb,
> > > +static void __unmap_hugepage_range_locking(struct mmu_gather *tlb,
> > >  			  struct vm_area_struct *vma, unsigned long start,
> > >  			  unsigned long end, struct page *ref_page,
> > > -			  zap_flags_t zap_flags)
> > > +			  zap_flags_t zap_flags, bool final)
> > >  {
> > >  	hugetlb_vma_lock_write(vma);
> > >  	i_mmap_lock_write(vma->vm_file->f_mapping);
> > >  
> > >  	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
> > >  
> > > -	/*
> > > -	 * Unlock and free the vma lock before releasing i_mmap_rwsem.  When
> > > -	 * the vma_lock is freed, this makes the vma ineligible for pmd
> > > -	 * sharing.  And, i_mmap_rwsem is required to set up pmd sharing.
> > > -	 * This is important as page tables for this unmapped range will
> > > -	 * be asynchrously deleted.  If the page tables are shared, there
> > > -	 * will be issues when accessed by someone else.
> > > -	 */
> > > -	__hugetlb_vma_unlock_write_free(vma);
> > > +	if (final) {
> > > +		/*
> > > +		 * Unlock and free the vma lock before releasing i_mmap_rwsem.
> > > +		 * When the vma_lock is freed, this makes the vma ineligible
> > > +		 * for pmd sharing.  And, i_mmap_rwsem is required to set up
> > > +		 * pmd sharing.  This is important as page tables for this
> > > +		 * unmapped range will be asynchrously deleted.  If the page
> > > +		 * tables are shared, there will be issues when accessed by
> > > +		 * someone else.
> > > +		 */
> > > +		__hugetlb_vma_unlock_write_free(vma);
> > > +		i_mmap_unlock_write(vma->vm_file->f_mapping);
> > 
> > Pure question: can we rely on hugetlb_vm_op_close() to destroy the hugetlb
> > vma lock?
> > 
> > I read the comment above, it seems we are trying to avoid racing with pmd
> > sharing, but I don't see how that could ever happen, since iiuc there
> > should only be two places that unmaps the vma (final==true):
> > 
> >   (1) munmap: we're holding write lock, so no page fault possible
> >   (2) exit_mmap: we've already reset current->mm so no page fault possible
> > 
> 
> Thanks for taking a look Peter!
> 
> The possible sharing we are trying to stop would be initiated by a fault
> in a different process on the same underlying mapping object (inode).  The
> specific vma in exit processing is still linked into the mapping interval
> tree.  So, even though we call huge_pmd_unshare in the unmap processing (in
> __unmap_hugepage_range) the sharing could later be initiated by another
> process.
> 
> Hope that makes sense.  That is also the reason the routine
> page_table_shareable contains this check:
> 
> 	/*
> 	 * match the virtual addresses, permission and the alignment of the
> 	 * page table page.
> 	 *
> 	 * Also, vma_lock (vm_private_data) is required for sharing.
> 	 */
> 	if (pmd_index(addr) != pmd_index(saddr) ||
> 	    vm_flags != svm_flags ||
> 	    !range_in_vma(svma, sbase, s_end) ||
> 	    !svma->vm_private_data)
> 		return 0;

Ah, makes sense.  Hmm, then I'm wondering whether hugetlb_vma_lock_free()
would ever be useful at all?  Because remove_vma() (or say, the close()
hook) seems to always be called after an precedent unmap_vmas().

> 
> FYI - The 'flags' check also prevents a non-uffd mapping from initiating
> sharing with a uffd mapping.
> 
> > > +	} else {
> > > +		i_mmap_unlock_write(vma->vm_file->f_mapping);
> > > +		hugetlb_vma_unlock_write(vma);
> > > +	}
> > > +}
> > >  
> > > -	i_mmap_unlock_write(vma->vm_file->f_mapping);
> > > +void __unmap_hugepage_range_final(struct mmu_gather *tlb,
> > > +			  struct vm_area_struct *vma, unsigned long start,
> > > +			  unsigned long end, struct page *ref_page,
> > > +			  zap_flags_t zap_flags)
> > > +{
> > > +	__unmap_hugepage_range_locking(tlb, vma, start, end, ref_page,
> > > +					zap_flags, true);
> > >  }
> > >  
> > > +#ifdef CONFIG_ADVISE_SYSCALLS
> > > +/*
> > > + * Similar setup as in zap_page_range().  madvise(MADV_DONTNEED) can not call
> > > + * zap_page_range for hugetlb vmas as __unmap_hugepage_range_final will delete
> > > + * the associated vma_lock.
> > > + */
> > > +void clear_hugetlb_page_range(struct vm_area_struct *vma, unsigned long start,
> > > +				unsigned long end)
> > > +{
> > > +	struct mmu_notifier_range range;
> > > +	struct mmu_gather tlb;
> > > +
> > > +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
> > > +				start, end);
> > 
> > Is mmu_notifier_invalidate_range_start() missing here?
> > 
> 
> It certainly does look like it.  When I created this routine, I was trying to
> mimic what was done in the current calling path zap_page_range to
> __unmap_hugepage_range_final.  Now when I look at that, I am not seeing
> a mmu_notifier_invalidate_range_start/end.  Am I missing something, or
> are these missing today?

I'm not sure whether we're looking at the same code base; here it's in
zap_page_range() itself.

	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
				start, start + size);
	tlb_gather_mmu(&tlb, vma->vm_mm);
	update_hiwater_rss(vma->vm_mm);
	mmu_notifier_invalidate_range_start(&range);
	do {
		unmap_single_vma(&tlb, vma, start, range.end, NULL);
	} while ((vma = mas_find(&mas, end - 1)) != NULL);
	mmu_notifier_invalidate_range_end(&range);

> Do note that we do MMU_NOTIFY_UNMAP in __unmap_hugepage_range.

Hmm, I think we may want CLEAR for zap-only and UNMAP only for unmap.

 * @MMU_NOTIFY_UNMAP: either munmap() that unmap the range or a mremap() that
 * move the range
 * @MMU_NOTIFY_CLEAR: clear page table entry (many reasons for this like
 * madvise() or replacing a page by another one, ...).

The other thing is that unmap_vmas() also notifies (same to
zap_page_range), it looks a duplicated notification if any of them calls
__unmap_hugepage_range() at last.

> 
> > > +	tlb_gather_mmu(&tlb, vma->vm_mm);
> > > +	update_hiwater_rss(vma->vm_mm);
> > > +
> > > +	__unmap_hugepage_range_locking(&tlb, vma, start, end, NULL, 0, false);
> > > +
> > > +	mmu_notifier_invalidate_range_end(&range);
> > > +	tlb_finish_mmu(&tlb);
> > > +}
> > > +#endif
> > > +
> > >  void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
> > >  			  unsigned long end, struct page *ref_page,
> > >  			  zap_flags_t zap_flags)
> > > diff --git a/mm/madvise.c b/mm/madvise.c
> > > index 2baa93ca2310..90577a669635 100644
> > > --- a/mm/madvise.c
> > > +++ b/mm/madvise.c
> > > @@ -790,7 +790,10 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
> > >  static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
> > >  					unsigned long start, unsigned long end)
> > >  {
> > > -	zap_page_range(vma, start, end - start);
> > > +	if (!is_vm_hugetlb_page(vma))
> > > +		zap_page_range(vma, start, end - start);
> > > +	else
> > > +		clear_hugetlb_page_range(vma, start, end);
> > >  	return 0;
> > >  }
> > 
> > This does look a bit unfortunate - zap_page_range() contains yet another
> > is_vm_hugetlb_page() check (further down in unmap_single_vma), it can be
> > very confusing on which code path is really handling hugetlb.
> > 
> > The other mm_users check in v3 doesn't need this change, but was a bit
> > hackish to me, because IIUC we're clear on the call paths to trigger this
> > (unmap_vmas), so it seems clean to me to pass that info from the upper
> > stack.
> > 
> > Maybe we can have a new zap_flags passed into unmap_single_vma() showing
> > that it's destroying the vma?
> 
> I thought about that.  However, we would need to start passing the flag
> here into zap_page_range as this is the beginning of that call down into
> the hugetlb code where we do not want to remove zap_page_rangethe
> vma_lock.

Right.  I was thinking just attach the new flag in unmap_vmas().  A pesudo
(not compiled) code attached.

Thanks,

-- 
Peter Xu

--YVsPJK3aT2ohvMA8
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=patch

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 978c17df053e..37091f8a6a12 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3463,5 +3463,6 @@ madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
  * default, the flag is not set.
  */
 #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
+#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
 
 #endif /* _LINUX_MM_H */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4a8c8456555e..245954d85553 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5201,8 +5201,10 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 static void __unmap_hugepage_range_locking(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page,
-			  zap_flags_t zap_flags, bool final)
+			  zap_flags_t zap_flags)
 {
+	bool final = zap_flags & ZAP_FLAG_UNMAP;
+
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(vma->vm_file->f_mapping);
 
@@ -5232,7 +5234,7 @@ void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 			  zap_flags_t zap_flags)
 {
 	__unmap_hugepage_range_locking(tlb, vma, start, end, ref_page,
-					zap_flags, true);
+				       zap_flags);
 }
 
 #ifdef CONFIG_ADVISE_SYSCALLS
@@ -5252,7 +5254,7 @@ void clear_hugetlb_page_range(struct vm_area_struct *vma, unsigned long start,
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 	update_hiwater_rss(vma->vm_mm);
 
-	__unmap_hugepage_range_locking(&tlb, vma, start, end, NULL, 0, false);
+	__unmap_hugepage_range_locking(&tlb, vma, start, end, NULL, 0);
 
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
diff --git a/mm/memory.c b/mm/memory.c
index c5599a9279b1..679b702af4ce 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1671,7 +1671,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 {
 	struct mmu_notifier_range range;
 	struct zap_details details = {
-		.zap_flags = ZAP_FLAG_DROP_MARKER,
+		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
 		/* Careful - we need to zap private pages too! */
 		.even_cows = true,
 	};

--YVsPJK3aT2ohvMA8--

