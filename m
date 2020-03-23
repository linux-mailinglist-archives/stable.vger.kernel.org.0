Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7622F18FC51
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 19:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbgCWSHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 14:07:12 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:44201 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbgCWSHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 14:07:10 -0400
Received: by mail-qv1-f68.google.com with SMTP id f7so1399282qvr.11
        for <stable@vger.kernel.org>; Mon, 23 Mar 2020 11:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ve+05QZoYPi0YuCClTc3ohV/03rfuQ4cI5EZopsltg8=;
        b=E35zVOramVTjTIS6drDV83CSHrAgJPiYFUoVqNBHtPyK9X35M60UZwZG6SSSLLDYKr
         q/RqNqf6mOSsd+zI56V1XOoxQZbXKVhpHBYHt5MZHQUFkGhzyG1hNHYzEhnAot+WSWfO
         kfFNOMiVnVUVs5USpcWkGRWwMiWJi64X9THbLAV55FJRRzpwhfCl7HJZNPWOqra5Sv8h
         4NV/Qyj1sQxJHR4LySQ3DXTfik7aePNd5x21MPt/McAvqKJ3a+leXieu9VRHrESgh8jS
         tRVfxpBZTL43WBIXoijBiFGORijdgIhNfgBX5fRq99kzb7x00bFvRBs0si5toj6xo8+o
         NxBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ve+05QZoYPi0YuCClTc3ohV/03rfuQ4cI5EZopsltg8=;
        b=bZVAthVqL+mhzqayNcWc5S2WbVt58iAmFsyK7G4Xdz6RzLrtWa6yhkujAOj6aYdseg
         o8l+2mn+MXYcchPf0f5dxVfyoEhR4Y3yEQHOU79zLZ4HVAeoNMlZtMGE4+AtuvMyhUd1
         wu7PcW1Vgs0oMuGY8ndZ74DuqmD4DgO+n7fH9xp9Q88cBcRdj1xynXmXPqZPBpcr1PdJ
         SaAF9vii+FyCqDlTwrK0+znRPsae0JtSnOJ55ZYsLQBUJPB0gK+xF6pc+FjNOW6a6vnl
         76AU5CMn+0oOQc7JV+HkIsyw7KwE7Ss+GUQwiMHDTWCozqvh34M5oczXfdcOZcow1fHO
         yyqA==
X-Gm-Message-State: ANhLgQ3nEwZa2Cr/qjRLXeBrKqbmaUrlN9f4UoyXUbrkkYLP1phSRykK
        BHgZajyss360AAcXNW/wVEHBMA==
X-Google-Smtp-Source: ADFU+vuowy4C5rdMepqxAT9zd7FYcK5Ujxe+LT8j7Las+WeIQGlDbrUdlqbheocEhFlIdJyQaD+iDQ==
X-Received: by 2002:ad4:5401:: with SMTP id f1mr1081151qvt.209.1584986827928;
        Mon, 23 Mar 2020 11:07:07 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id c27sm1504978qkk.0.2020.03.23.11.07.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Mar 2020 11:07:07 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jGRTe-0007Xi-GP; Mon, 23 Mar 2020 15:07:06 -0300
Date:   Mon, 23 Mar 2020 15:07:06 -0300
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
Message-ID: <20200323180706.GC20941@ziepe.ca>
References: <1582342427-230392-1-git-send-email-longpeng2@huawei.com>
 <51a25d55-de49-4c0a-c994-bf1a8cfc8638@oracle.com>
 <20200323160955.GY20941@ziepe.ca>
 <69055395-e7e5-a8e2-7f3e-f61607149318@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69055395-e7e5-a8e2-7f3e-f61607149318@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 23, 2020 at 10:27:48AM -0700, Mike Kravetz wrote:

> >  	pgd = pgd_offset(mm, addr);
> > -	if (!pgd_present(*pgd))
> > +	if (!pgd_present(READ_ONCE(*pgd)))
> >  		return NULL;
> >  	p4d = p4d_offset(pgd, addr);
> > -	if (!p4d_present(*p4d))
> > +	if (!p4d_present(READ_ONCE(*p4d)))
> >  		return NULL;
> >  
> >       pud = pud_offset(p4d, addr);
> 
> One would argue that pgd and p4d can not change from present to !present
> during the execution of this code.  To me, that seems like the issue which
> would cause an issue.  Of course, I could be missing something.

This I am not sure of, I think it must be true under the read side of
the mmap_sem, but probably not guarenteed under RCU..

In any case, it doesn't matter, the fact that *p4d can change at all
is problematic. Unwinding the above inlines we get:

  p4d = p4d_offset(pgd, addr)
  if (!p4d_present(*p4d))
      return NULL;
  pud = (pud_t *)p4d_page_vaddr(*p4d) + pud_index(address);

According to our memory model the compiler/CPU is free to execute this
as:

  p4d = p4d_offset(pgd, addr)
  p4d_for_vaddr = *p4d;
  if (!p4d_present(*p4d))
      return NULL;
  pud = (pud_t *)p4d_page_vaddr(p4d_for_vaddr) + pud_index(address);

In the case where p4 goes from !present -> present (ie
handle_mm_fault()):

p4d_for_vaddr == p4d_none, and p4d_present(*p4d) == true, meaning the
p4d_page_vaddr() will crash.

Basically the problem here is not just missing READ_ONCE, but that the
p4d is read multiple times at all. It should be written like gup_fast
does, to guarantee a single CPU read of the unstable data:

  p4d = READ_ONCE(*p4d_offset(pgdp, addr));
  if (!p4d_present(p4))
      return NULL;
  pud = pud_offset(&p4d, addr);

At least this is what I've been able to figure out :\

> > Also, the remark about pmd_offset() seems accurate. The
> > get_user_fast_pages() pattern seems like the correct one to emulate:
> > 
> >   pud = READ_ONCE(*pudp);
> >   if (pud_none(pud)) 
> >      ..
> >   if (!pud_'is a pmd pointer')
> >      ..
> >   pmdp = pmd_offset(&pud, address);
> >   pmd = READ_ONCE(*pmd);
> >   [...]
> > 
> > Passing &pud in avoids another de-reference of the pudp. Honestly all
> > these APIs that take in page table pointers and internally
> > de-reference them seem very hard to use correctly when the page table
> > access isn't fully locked against write.

And the same protocol for the PUD, etc.

> > It looks like at least the p4d read from the pgd is also unlocked here
> > as handle_mm_fault() writes to it??
> 
> Yes, there is no locking required to call huge_pte_offset().

None? Not RCU or read mmap_sem?

Jason
