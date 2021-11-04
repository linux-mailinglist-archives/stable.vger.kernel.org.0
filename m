Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A2B445A0F
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 19:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhKDS50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 14:57:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231684AbhKDS5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 14:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0B9A6112E;
        Thu,  4 Nov 2021 18:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636052086;
        bh=vB1LbcttBwp8vLqGtNl7l8YpDqhiHiaThXlmJVbnig8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MNuEPS8z3TzgAIwvxTF8Kvx2xwDKkG2Rx55yw6OPp5dOY4Ft9DRuGxhd/jGPal/Y8
         RFq+s62a4p5tfUQeLKD8NWVZeh4KsuBwwApzznZw6OjrhuQ5cJOLkpFCX2BChvHoeM
         D4ioRwCnYElTLvZqGcxP0ZGoMbJRStcwzrDITieI=
Date:   Thu, 4 Nov 2021 19:54:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, jarkko@kernel.org, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, linux-sgx@vger.kernel.org,
        x86@kernel.org, seanjc@google.com, tony.luck@intel.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Fix free page accounting
Message-ID: <YYQsc0kktaOdOXb0@kroah.com>
References: <373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 11:28:54AM -0700, Reinette Chatre wrote:
> The SGX driver maintains a single global free page counter,
> sgx_nr_free_pages, that reflects the number of free pages available
> across all NUMA nodes. Correspondingly, a list of free pages is
> associated with each NUMA node and sgx_nr_free_pages is updated
> every time a page is added or removed from any of the free page
> lists. The main usage of sgx_nr_free_pages is by the reclaimer
> that will run when the total free pages go below a watermark to
> ensure that there are always some free pages available to, for
> example, support efficient page faults.
> 
> With sgx_nr_free_pages accessed and modified from a few places
> it is essential to ensure that these accesses are done safely but
> this is not the case. sgx_nr_free_pages is sometimes accessed
> without any protection and when it is protected it is done
> inconsistently with any one of the spin locks associated with the
> individual NUMA nodes.
> 
> The consequence of sgx_nr_free_pages not being protected is that
> its value may not accurately reflect the actual number of free
> pages on the system, impacting the availability of free pages in
> support of many flows. The problematic scenario is when the
> reclaimer never runs because it believes there to be sufficient
> free pages while any attempt to allocate a page fails because there
> are no free pages available. The worst scenario observed was a
> user space hang because of repeated page faults caused by
> no free pages ever made available.
> 
> Change the global free page counter to an atomic type that
> ensures simultaneous updates are done safely. While doing so, move
> the updating of the variable outside of the spin lock critical
> section to which it does not belong.
> 
> Cc: stable@vger.kernel.org
> Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 63d3de02bbcc..8558d7d5f3e7 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -28,8 +28,7 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
>  static LIST_HEAD(sgx_active_page_list);
>  static DEFINE_SPINLOCK(sgx_reclaimer_lock);
>  
> -/* The free page list lock protected variables prepend the lock. */
> -static unsigned long sgx_nr_free_pages;
> +atomic_long_t sgx_nr_free_pages = ATOMIC_LONG_INIT(0);
>  
>  /* Nodes with one or more EPC sections. */
>  static nodemask_t sgx_numa_mask;
> @@ -403,14 +402,15 @@ static void sgx_reclaim_pages(void)
>  
>  		spin_lock(&node->lock);
>  		list_add_tail(&epc_page->list, &node->free_page_list);
> -		sgx_nr_free_pages++;
>  		spin_unlock(&node->lock);
> +		atomic_long_inc(&sgx_nr_free_pages);
>  	}
>  }
>  
>  static bool sgx_should_reclaim(unsigned long watermark)
>  {
> -	return sgx_nr_free_pages < watermark && !list_empty(&sgx_active_page_list);
> +	return atomic_long_read(&sgx_nr_free_pages) < watermark &&
> +	       !list_empty(&sgx_active_page_list);

What prevents the value from changing right after you test this?  Why is
an atomic value somehow solving the problem?

The value changes were happening safely, it was just the reading of the
value that was not.  You have not changed the fact that the value can
change right after reading given that there was not going to be a
problem with reading a stale value before.

In other words, what did you really fix here?  And how did you test it
to verify it did fix things?

thanks,

greg k-h
