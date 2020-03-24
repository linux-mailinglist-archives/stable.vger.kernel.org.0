Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C8D191852
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 18:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgCXR7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 13:59:22 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44966 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbgCXR7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 13:59:22 -0400
Received: by mail-qt1-f196.google.com with SMTP id x16so6592583qts.11
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 10:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zH+BGadp4OmNkvzUZhTO73HLGjoJtfJzYl50kGaQ9wk=;
        b=IXdBQHqeUJOCCZkIgPOwwZgSnBKeFld/XRqmME+TSc3rxoiYnHV8EgAK6SY/rP6xlv
         U9fRw/vb55F1clIFXva7MNTzhItj4RSG2F+XGgFYAgrTipDRAZm8z5ZUkQovc4EumeOs
         zD6Kyyh5KWPcv5DLAV5hgqZQl1m9uaA/XaEvYSfKhMa9585c2w9rlfQpnoi7VQas3S8R
         UKKPXYTQuHwDenMlqq4JexbrdUBPTBkflax1BCdCMURi+HSFOLlzoah9ss0ZWBxd6OuC
         VrOBUG1xvv8OAVpd0tD11cCKbQ5FeCGEa/rZq5SnlOwIM5oAz3ohlQFSs9MH6AhA9HQa
         cZ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zH+BGadp4OmNkvzUZhTO73HLGjoJtfJzYl50kGaQ9wk=;
        b=RGq1yFtMhILNepK/+X+6u59c7BmyYO0r8ezXRulAvd36umPSThSLwBkzEMEKFqgsE8
         4BmWNNNDfikaXtuHzxSYW/rl6vw0zTU8Ez2Ubzk8K7FjiOXp+dfYdp/ffbQGE69wyrA3
         bYab5x7FkVbDlb5iK6qfBEKc8jnjwKxmp54wQp9MfLdOdov4QF7Fl1Cvm61+06JdW58F
         VHMcEgA7wrMEBQnzXIdtNbHgkl0KkBviOA8ATGQKdPRRPlpi8StFZdhibnS8lRXKcaD3
         J591FWLC+67yAKI1gBXKE01lkD8CycC3rtTRqSoDdShl01vB9Qv7qvlsbJA3rgfz3m75
         q31g==
X-Gm-Message-State: ANhLgQ3fJJUdFgocOoHYXcwzSLw6GRssb3t2GHF6ZrDu78yk1HfDT3xj
        K6bnjcimm3QRP651RborOGE2Gw==
X-Google-Smtp-Source: ADFU+vuQ4Q4V+mScJFlextfScElcSW54hioCdgee8HN9LPyP5FKMTC3Ckqq0+uSRdg0bOwuphm/SkA==
X-Received: by 2002:ac8:1c17:: with SMTP id a23mr28141558qtk.239.1585072760748;
        Tue, 24 Mar 2020 10:59:20 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id d72sm13434428qkg.102.2020.03.24.10.59.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Mar 2020 10:59:20 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jGnpe-0006sJ-Ql; Tue, 24 Mar 2020 14:59:18 -0300
Date:   Tue, 24 Mar 2020 14:59:18 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org,
        arei.gonglei@huawei.com, weidong.huang@huawei.com,
        weifuqiang@huawei.com, kvm@vger.kernel.org, linux-mm@kvack.org,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset()
Message-ID: <20200324175918.GL20941@ziepe.ca>
References: <20200323160955.GY20941@ziepe.ca>
 <69055395-e7e5-a8e2-7f3e-f61607149318@oracle.com>
 <20200323180706.GC20941@ziepe.ca>
 <88698dd7-eb87-4b0b-7ba7-44ef6eab6a6c@oracle.com>
 <20200323225225.GF20941@ziepe.ca>
 <e8e71ba4-d609-269a-6160-153e373e7563@huawei.com>
 <20200324115541.GH20941@ziepe.ca>
 <98d35563-8af0-2693-7e76-e6435da0bbee@oracle.com>
 <20200324155552.GK20941@ziepe.ca>
 <66583587-ca4f-9847-c173-4a3d7938fec6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66583587-ca4f-9847-c173-4a3d7938fec6@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 24, 2020 at 09:19:29AM -0700, Mike Kravetz wrote:
> On 3/24/20 8:55 AM, Jason Gunthorpe wrote:
> > On Tue, Mar 24, 2020 at 08:25:09AM -0700, Mike Kravetz wrote:
> >> On 3/24/20 4:55 AM, Jason Gunthorpe wrote:
> >>> Also, since CH moved all the get_user_pages_fast code out of the
> >>> arch's many/all archs can drop their arch specific version of this
> >>> routine. This is really just a specialized version of gup_fast's
> >>> algorithm..
> >>>
> >>> (also the arch versions seem different, why do some return actual
> >>>  ptes, not null?)
> >>
> >> Not sure I understand that last question.  The return value should be
> >> a *pte or null.
> > 
> > I mean the common code ends like this:
> > 
> > 	pmd = pmd_offset(pud, addr);
> > 	if (sz != PMD_SIZE && pmd_none(*pmd))
> > 		return NULL;
> > 	/* hugepage or swap? */
> > 	if (pmd_huge(*pmd) || !pmd_present(*pmd))
> > 		return (pte_t *)pmd;
> > 
> > 	return NULL;
> > 
> > So it always returns a pointer into a PUD or PMD, while say, ppc
> > in __find_linux_pte() ends like:
> > 
> > 	return pte_offset_kernel(&pmd, ea);
> > 
> > Which is pointing to a PTE
> 
> Ok, now I understand the question.  huge_pte_offset will/should only be
> called for addresses that are in a vma backed by hugetlb pages.  So,
> pte_offset_kernel() will only return page table type (PUD/PMD/etc) associated
> with a huge page supported by the particular arch.

I thought pte_offset_kernel always returns PTEs (ie the 4k entries on
x86), I suppose what you are saying is that since the caller knows
this is always a PUD or PMD due to the VMA the pte_offset is dead code.

> > So does sparc:
> > 
> >         pmd = pmd_offset(pud, addr);
> >         if (pmd_none(*pmd))
> >                 return NULL;
> >         if (is_hugetlb_pmd(*pmd))
> >                 return (pte_t *)pmd;
> >         return pte_offset_map(pmd, addr);
> > 
> > Which is even worse because it is leaking a kmap..

Particularly here which is buggy dead code :)

Jason
