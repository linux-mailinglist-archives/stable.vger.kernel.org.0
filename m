Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8D3680DD3
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 13:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjA3MhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 07:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjA3MhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 07:37:01 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F68210F8;
        Mon, 30 Jan 2023 04:37:00 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F34A51FD67;
        Mon, 30 Jan 2023 12:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675082219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1450QT1I5sWl0OhZRQWY9u52Bs4XcX/IrDlMZ/w1pZc=;
        b=Z+WmqlLuRjOFu1Oh8r1mI+f1kJ1O3XSdQ8+mzoO2lqUfzYf3EeCXsiGp0FLZyLF/0wcuPD
        zA1vPqXNoF7H6hOT5MsrvYxx5n2w8Im1fF3wfEGLn912gySg0+atCk1FzZ2bXG3BvieulG
        Q4jhG1b4zjl6uDmJhvuCHFf1KUEOjtc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D912B13444;
        Mon, 30 Jan 2023 12:36:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SrUrNOq512MlRQAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 30 Jan 2023 12:36:58 +0000
Date:   Mon, 30 Jan 2023 13:36:58 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Peter Xu <peterx@redhat.com>, Yang Shi <shy828301@gmail.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: hugetlb: proc: check for hugetlb shared PMD in
 /proc/PID/smaps
Message-ID: <Y9e56ofZ+E4buuam@dhcp22.suse.cz>
References: <20230126222721.222195-1-mike.kravetz@oracle.com>
 <20230126222721.222195-2-mike.kravetz@oracle.com>
 <4ad5163f-5368-0bd8-de9b-1400a7a653ed@redhat.com>
 <20230127150411.7c3b7b99fa4884a6af0b9351@linux-foundation.org>
 <Y9R2ZXMxeF6Lpw4g@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9R2ZXMxeF6Lpw4g@monkey>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 27-01-23 17:12:05, Mike Kravetz wrote:
> On 01/27/23 15:04, Andrew Morton wrote:
> > On Fri, 27 Jan 2023 17:23:39 +0100 David Hildenbrand <david@redhat.com> wrote:
> > 
> > > On 26.01.23 23:27, Mike Kravetz wrote:
> > > > A hugetlb page will have a mapcount of 1 if mapped by multiple processes
> > > > via a shared PMD.  This is because only the first process increases the
> > > > map count, and subsequent processes just add the shared PMD page to
> > > > their page table.
> > > > 
> > > > page_mapcount is being used to decide if a hugetlb page is shared or
> > > > private in /proc/PID/smaps.  Pages referenced via a shared PMD were
> > > > incorrectly being counted as private.
> > > > 
> > > > To fix, check for a shared PMD if mapcount is 1.  If a shared PMD is
> > > > found count the hugetlb page as shared.  A new helper to check for a
> > > > shared PMD is added.
> > > > 
> > > ...
> > >
> > > > --- a/fs/proc/task_mmu.c
> > > > +++ b/fs/proc/task_mmu.c
> > > > @@ -749,8 +749,14 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
> > > >   
> > > >   		if (mapcount >= 2)
> > > >   			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
> > > > -		else
> > > > -			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
> > > > +		else {
> > > 
> > > Better:
> > > 
> > > if (mapcount >= 2 || hugetlb_pmd_shared(pte))
> > > 	mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
> > > else
> > > 	mss->private_hugetlb += huge_page_size(hstate_vma(vma));
> > 
> > Yup.  And that local doesn't add any value?
> > 
> > --- a/fs/proc/task_mmu.c~mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix
> > +++ a/fs/proc/task_mmu.c
> > @@ -745,18 +745,10 @@ static int smaps_hugetlb_range(pte_t *pt
> >  			page = pfn_swap_entry_to_page(swpent);
> >  	}
> >  	if (page) {
> > -		int mapcount = page_mapcount(page);
> > -
> > -		if (mapcount >= 2)
> > +		if (page_mapcount(page) >= 2 || hugetlb_pmd_shared(pte))
> >  			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
> > -		else {
> > -			if (hugetlb_pmd_shared(pte))
> > -				mss->shared_hugetlb +=
> > -						huge_page_size(hstate_vma(vma));
> > -			else
> > -				mss->private_hugetlb +=
> > -						huge_page_size(hstate_vma(vma));
> > -		}
> > +		else
> > +			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
> >  	}
> >  	return 0;
> >  }
> 
> Thank you both!  That looks much better.

Yes, this looks simple enough. My only concern would be that this
special casing might be required on other places which is hard to
evaluate. I thought PSS reported by smaps would be broken as well but it
seems pss is not really accounted for hugetlb mappings at all.

Have you tried to look into {in,de}creasing the map count of the page when
the the pte is {un}shared for it?
-- 
Michal Hocko
SUSE Labs
