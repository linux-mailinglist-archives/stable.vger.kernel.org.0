Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005C8446008
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 08:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhKEHNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 03:13:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232486AbhKEHNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 03:13:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8855F61250;
        Fri,  5 Nov 2021 07:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636096238;
        bh=y7PYD7ScSEup1sTtkL4KaiBLwigwF2LB1vwyYh51tlo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ebRh0mlrSrrXXndaFcCsR564XXUFyaWoNyrQgUwZI9BztSKDXmCIa9psaa+sGJPez
         /0Ma9ooUJ0I+mrXtq3EG9GdkIzIWBvjHjlYNVz8HuxFxIVLBE8VNDKNEJM5a3L4i26
         AxKfI/f5QhYeyNmUzCHRYU6j3H6IKWgZVhujaRF8=
Date:   Fri, 5 Nov 2021 08:10:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, jarkko@kernel.org, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, linux-sgx@vger.kernel.org,
        x86@kernel.org, seanjc@google.com, tony.luck@intel.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Fix free page accounting
Message-ID: <YYTY60T7YzycEAmp@kroah.com>
References: <373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com>
 <YYQsc0kktaOdOXb0@kroah.com>
 <a636290d-db04-be16-1c86-a8dcc3719b39@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a636290d-db04-be16-1c86-a8dcc3719b39@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 01:57:31PM -0700, Reinette Chatre wrote:
> Hi Greg,
> 
> On 11/4/2021 11:54 AM, Greg KH wrote:
> > On Thu, Nov 04, 2021 at 11:28:54AM -0700, Reinette Chatre wrote:
> > > The SGX driver maintains a single global free page counter,
> > > sgx_nr_free_pages, that reflects the number of free pages available
> > > across all NUMA nodes. Correspondingly, a list of free pages is
> > > associated with each NUMA node and sgx_nr_free_pages is updated
> > > every time a page is added or removed from any of the free page
> > > lists. The main usage of sgx_nr_free_pages is by the reclaimer
> > > that will run when the total free pages go below a watermark to
> > > ensure that there are always some free pages available to, for
> > > example, support efficient page faults.
> > > 
> > > With sgx_nr_free_pages accessed and modified from a few places
> > > it is essential to ensure that these accesses are done safely but
> > > this is not the case. sgx_nr_free_pages is sometimes accessed
> > > without any protection and when it is protected it is done
> > > inconsistently with any one of the spin locks associated with the
> > > individual NUMA nodes.
> > > 
> > > The consequence of sgx_nr_free_pages not being protected is that
> > > its value may not accurately reflect the actual number of free
> > > pages on the system, impacting the availability of free pages in
> > > support of many flows. The problematic scenario is when the
> > > reclaimer never runs because it believes there to be sufficient
> > > free pages while any attempt to allocate a page fails because there
> > > are no free pages available. The worst scenario observed was a
> > > user space hang because of repeated page faults caused by
> > > no free pages ever made available.
> > > 
> > > Change the global free page counter to an atomic type that
> > > ensures simultaneous updates are done safely. While doing so, move
> > > the updating of the variable outside of the spin lock critical
> > > section to which it does not belong.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
> > > Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> > > ---
> > >   arch/x86/kernel/cpu/sgx/main.c | 12 ++++++------
> > >   1 file changed, 6 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > > index 63d3de02bbcc..8558d7d5f3e7 100644
> > > --- a/arch/x86/kernel/cpu/sgx/main.c
> > > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > > @@ -28,8 +28,7 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
> > >   static LIST_HEAD(sgx_active_page_list);
> > >   static DEFINE_SPINLOCK(sgx_reclaimer_lock);
> > > -/* The free page list lock protected variables prepend the lock. */
> > > -static unsigned long sgx_nr_free_pages;
> > > +atomic_long_t sgx_nr_free_pages = ATOMIC_LONG_INIT(0);
> > >   /* Nodes with one or more EPC sections. */
> > >   static nodemask_t sgx_numa_mask;
> > > @@ -403,14 +402,15 @@ static void sgx_reclaim_pages(void)
> > >   		spin_lock(&node->lock);
> > >   		list_add_tail(&epc_page->list, &node->free_page_list);
> > > -		sgx_nr_free_pages++;
> > >   		spin_unlock(&node->lock);
> > > +		atomic_long_inc(&sgx_nr_free_pages);
> > >   	}
> > >   }
> > >   static bool sgx_should_reclaim(unsigned long watermark)
> > >   {
> > > -	return sgx_nr_free_pages < watermark && !list_empty(&sgx_active_page_list);
> > > +	return atomic_long_read(&sgx_nr_free_pages) < watermark &&
> > > +	       !list_empty(&sgx_active_page_list);
> > 
> 
> Thank you very much for taking a look.
> 
> > What prevents the value from changing right after you test this?
> 
> You are correct. It is indeed possible for the value to change after this
> test. This test decides when to reclaim more pages so an absolute accurate
> value is not required but knowing that the amount of free pages are running
> low is.
> 
> >  Why is
> > an atomic value somehow solving the problem?
> 
> During stress testing it was found that page allocation during hot path (for
> example page fault) is failing because there were no free pages available in
> any of the free page lists while the global counter contained a value that
> does not reflect the actual free pages and was higher than the watermark and
> thus the reclaimer is never run.
> 
> Changing it to atomic fixed this issue. I also reverted to how this counter
> was managed before with a spin lock protected free counter per free list and
> that also fixes the issue.
>
> > The value changes were happening safely, it was just the reading of the
> > value that was not.  You have not changed the fact that the value can
> > change right after reading given that there was not going to be a
> > problem with reading a stale value before.
> 
> I am testing on a two socket system and I am seeing that the value of
> sgx_nr_free_pages does not accurately reflect the actual free pages.
> 
> It does not look to me like the value is updated safely as it is updated
> with inconsistent protection on a system like this. There is a spin lock
> associated with each NUMA node and which lock is used to update the variable
> depends on which NUMA node memory is being modified - it is not always
> protected with the same lock:
> 
> spin_lock(&node->lock);
> sgx_nr_free_pages++;
> spin_unlock(&node->lock);

Ah, I missed that the original code was using a different lock for every
call place, while now you are just using a single lock (the atomic value
itself.)  That makes more sense, sorry for the noise.

But isn't this going to cause more thrashing and slow things down as you
are hitting the "global" lock for this variable for every allocation?
Or is this not in the hot path?



> 
> 
> > In other words, what did you really fix here?  And how did you test it
> > to verify it did fix things?
> 
> To test this I created a stress test that builds on top of the new
> "oversubscription" test case that we are trying to add to the SGX
> kselftests:
> https://lore.kernel.org/lkml/7715db4882ab9fd52d21de6f62bb3b7e94dc4885.1635447301.git.reinette.chatre@intel.com/
> 
> In the changed test an enclave is created with as much heap as SGX memory.
> After that all the pages are accessed, their type is changed, then the
> enclave is entered to run EACCEPT on each page, after that the pages are
> removed (EREMOVE).
> 
> This test places significant stress on the SGX memory allocation and reclaim
> subsystems. The troublesome part of the test is when the enclave is entered
> so that EACCEPT can be run on each page. During this time, because of the
> oversubscription and previous accesses, there are many page faults. During
> this time a new page needs to be allocated in the SGX memory into which the
> page being faulted needs to be decrypted and loaded back into SGX memory. At
> this point the test hangs.
> 
> Below I show the following:
> * perf top showing that the test hangs because user space is stuck just
> encountering page faults
> * below that I show the code traces explaining why the repeated page faults
> occur (because reclaimer never runs)
> * below that shows the perf top traces after this patch is applied showing
> that the reclaimer now gets a chance to run and the test can complete
> 
> 
> Here is the perf top trace before this patch is applied showing how user
> space is stuck hitting page faults over and over:
>    PerfTop:    4569 irqs/sec  kernel:25.0%  exact: 100.0% lost: 0/0 drop:
> 0/0 [4000Hz cycles],  (all, 224 CPUs)

<ascii art that line-wrapped snipped>

> With this patch the test is able to complete and the tracing shows that the
> reclaimer is getting a chance to run. Previously the system was spending
> almost all its time in page faults but now the time is split between the
> page faults and the reclaimer.
> 
> 
>    PerfTop:    7432 irqs/sec  kernel:81.5%  exact: 100.0% lost: 0/0 drop:
> 0/0 [4000Hz cycles],  (all, 224 CPUs)

Ok, that's better, you need the reclaim in order to make forward
progress.

Thanks for the detailed explaination, no objection from me, sorry for
the misunderstanding.

greg k-h
