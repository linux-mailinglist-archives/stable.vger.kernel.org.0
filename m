Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C534190136
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 23:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgCWWw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 18:52:28 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35015 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgCWWw1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 18:52:27 -0400
Received: by mail-qk1-f193.google.com with SMTP id k13so5633161qki.2
        for <stable@vger.kernel.org>; Mon, 23 Mar 2020 15:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EN3/8nPrGjDFP5FiRDwnVv0jq98uFBAuJO6UXCJg8/8=;
        b=XW7sHiomY4SolQ/XAgSERiGDv3GH1MG/5Sg/9yKQZY9xK/GcJ/pgyjjbWnF26Hys1A
         cWeCjqUaPylhKJKv1+cbeNWqxJ2Q9mwTLJX9na4EwpF4MZJwCOBuOY8jpBBJtaarX00E
         0zZAJXGiYhxFzkMlLRSCeTR2ZvMriueZTkDO71LwFyhKw3Ablck5cwnBHsjUQWH+o5/Y
         +ikI1lSYDO2bWvz/8Na3VIilw2UY95CrKTdNv87bnnv0xIMyhmQ3VK4DqipqQpIRgU+g
         J3b1FfXDPb7KChYjzS+o0o/c/sYpj1P8FOOxTx8n2TeqP25KA5E5wjO4LHKp3HSo0X6v
         l45Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EN3/8nPrGjDFP5FiRDwnVv0jq98uFBAuJO6UXCJg8/8=;
        b=M03QYjgsKP/10Lopn+jWdKMm6W0ypEx/r7G1twdIdSu3+zcGG/eopf88444C3N8Ogu
         xoWOTzKIjRdIWK9F3U5zjYG97xSoDgVyNC6a9ya/Exhujh3/3B7E0C6r/qSLkpwEpmL/
         wjPC2k2wAo+YZhUe2Yo1yrg5qHUfnu8NWEd9bOIraj2ngMbXFMbjXajG+4ArGG4co6Ox
         TMt9+Krjqq2VdO79lPTtHHCk3VsB4/dmFHJ8m4IlkAo3YNhNrTm+UnCbdNepyNwtyVKG
         BX/c45x9FkA5DibRFaOCy3PY2tgwAvb//727UPr8+kqiaxP5ChAGnU722i538sqDJ7eD
         Assg==
X-Gm-Message-State: ANhLgQ2wCeWsb3zaHgLN4NLrgz81dqcLjETYOV6jq2s6k0GSNlvMEdgw
        FQ9wHcUOqbwj+NP4pMYlCf7QWA==
X-Google-Smtp-Source: ADFU+vuIxvcXkLHkkUwg/gcivfQjs9y5Wtz9wozt9Y4PWM35iGAs1MxHMJOPkfq43QrdfzminBi6Qw==
X-Received: by 2002:a37:4fc3:: with SMTP id d186mr24438557qkb.100.1585003946439;
        Mon, 23 Mar 2020 15:52:26 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id w132sm11883304qkb.96.2020.03.23.15.52.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Mar 2020 15:52:25 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jGVvl-00063l-6Z; Mon, 23 Mar 2020 19:52:25 -0300
Date:   Mon, 23 Mar 2020 19:52:25 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     "Longpeng (Mike)" <longpeng2@huawei.com>,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org, arei.gonglei@huawei.com,
        weidong.huang@huawei.com, weifuqiang@huawei.com,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset()
Message-ID: <20200323225225.GF20941@ziepe.ca>
References: <1582342427-230392-1-git-send-email-longpeng2@huawei.com>
 <51a25d55-de49-4c0a-c994-bf1a8cfc8638@oracle.com>
 <20200323160955.GY20941@ziepe.ca>
 <69055395-e7e5-a8e2-7f3e-f61607149318@oracle.com>
 <20200323180706.GC20941@ziepe.ca>
 <88698dd7-eb87-4b0b-7ba7-44ef6eab6a6c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88698dd7-eb87-4b0b-7ba7-44ef6eab6a6c@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 23, 2020 at 01:35:07PM -0700, Mike Kravetz wrote:
> On 3/23/20 11:07 AM, Jason Gunthorpe wrote:
> > On Mon, Mar 23, 2020 at 10:27:48AM -0700, Mike Kravetz wrote:
> > 
> >>>  	pgd = pgd_offset(mm, addr);
> >>> -	if (!pgd_present(*pgd))
> >>> +	if (!pgd_present(READ_ONCE(*pgd)))
> >>>  		return NULL;
> >>>  	p4d = p4d_offset(pgd, addr);
> >>> -	if (!p4d_present(*p4d))
> >>> +	if (!p4d_present(READ_ONCE(*p4d)))
> >>>  		return NULL;
> >>>  
> >>>       pud = pud_offset(p4d, addr);
> >>
> >> One would argue that pgd and p4d can not change from present to !present
> >> during the execution of this code.  To me, that seems like the issue which
> >> would cause an issue.  Of course, I could be missing something.
> > 
> > This I am not sure of, I think it must be true under the read side of
> > the mmap_sem, but probably not guarenteed under RCU..
> > 
> > In any case, it doesn't matter, the fact that *p4d can change at all
> > is problematic. Unwinding the above inlines we get:
> > 
> >   p4d = p4d_offset(pgd, addr)
> >   if (!p4d_present(*p4d))
> >       return NULL;
> >   pud = (pud_t *)p4d_page_vaddr(*p4d) + pud_index(address);
> > 
> > According to our memory model the compiler/CPU is free to execute this
> > as:
> > 
> >   p4d = p4d_offset(pgd, addr)
> >   p4d_for_vaddr = *p4d;
> >   if (!p4d_present(*p4d))
> >       return NULL;
> >   pud = (pud_t *)p4d_page_vaddr(p4d_for_vaddr) + pud_index(address);
> > 
> 
> Wow!  How do you know this?  You don't need to answer :)

It says explicitly in Documentation/memory-barriers.txt - see
section COMPILER BARRIER:

 (*) The compiler is within its rights to reorder loads and stores
     to the same variable, and in some cases, the CPU is within its
     rights to reorder loads to the same variable.  This means that
     the following code:

        a[0] = x;
        a[1] = x;

     Might result in an older value of x stored in a[1] than in a[0].

It also says READ_ONCE puts things in program order, but we don't use
READ_ONCE inside pud_offset(), so it doesn't help us.

Best answer is to code things so there is exactly one dereference of
the pointer protected by READ_ONCE. Very clear to read, very safe.

Maybe Longpeng can rework the patch around these principles?

Also I wonder if the READ_ONCE(*pmdp) is OK. gup_pmd_range() uses it,
but I can't explain why it shouldn't be pmd_read_atomic().

> > In the case where p4 goes from !present -> present (ie
> > handle_mm_fault()):
> > 
> > p4d_for_vaddr == p4d_none, and p4d_present(*p4d) == true, meaning the
> > p4d_page_vaddr() will crash.
> > 
> > Basically the problem here is not just missing READ_ONCE, but that the
> > p4d is read multiple times at all. It should be written like gup_fast
> > does, to guarantee a single CPU read of the unstable data:
> > 
> >   p4d = READ_ONCE(*p4d_offset(pgdp, addr));
> >   if (!p4d_present(p4))
> >       return NULL;
> >   pud = pud_offset(&p4d, addr);
> > 
> > At least this is what I've been able to figure out :\
> 
> In that case, I believe there are a bunch of similar routines with this issue.

Yes, my look around page walk related users makes me come to a similar
worry.

Fortunately, I think this is largely theoretical as most likely the
compiler will generate a single store for these coding patterns. 

That said, there have been bugs in the past, see commit 26c191788f18
("mm: pmd_read_atomic: fix 32bit PAE pmd walk vs pmd_populate SMP race
condition") which is significantly related to the compiler lifting a
load inside pte_offset to before the required 'if (pmd_*)' checks.

> For this patch, I was primarily interested in seeing the obvious
> multiple dereferences in C fixed up.  This is above and beyond that!
> :)

Well, I think it is worth solving the underlying problem
properly. Otherwise we get weird solutions to data races like
pmd_trans_unstable()...

Jason
