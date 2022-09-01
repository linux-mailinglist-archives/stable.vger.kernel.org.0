Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867E45AA3F8
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 01:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbiIAX5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 19:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233383AbiIAX5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 19:57:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CCE6C747;
        Thu,  1 Sep 2022 16:57:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6A2262053;
        Thu,  1 Sep 2022 23:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF13CC433C1;
        Thu,  1 Sep 2022 23:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662076623;
        bh=zE/wXzSl+/jPt/VWLTWmSJ0RojmsRRUa7I24GI1j9QA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jMAzlkh88dRgZ1jsq1RL8DRGyy0Q0uRkJjb1rwwL9Q4dqCct70nOjU7WElQF3J6jV
         chbyRXcq6IxAnDmeIwSu6uo/S3D2DKPASCLY4oo3GZrom9LH6tW3H3/cAxwjustUg5
         ++chlRe51UZXYw/zXUjjtTstdPOf+0G8ixuU/Zi2725byr3Z+S8+rLTwkXb51uAjpM
         JB/cxzrpnAlLe0b3uWjZdEwrL6Nq5HEykQ7jrMAXxon6/o5yuFiAhG7OiSA94KKjUp
         vkComRhFTXggMGGfLh64U7p5+NwleoUj6E2wx/7/LVM31wBF/S2XulXhWWKF026GYI
         ViTlZknTlXRjQ==
Date:   Fri, 2 Sep 2022 02:56:58 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] x86/sgx: Do not consider unsanitized pages an
 error
Message-ID: <YxFGykqMb+TD4L4l@kernel.org>
References: <20220831173829.126661-1-jarkko@kernel.org>
 <20220831173829.126661-3-jarkko@kernel.org>
 <24906e57-461f-6c94-9e78-0d8507df01bb@intel.com>
 <YxEp8Ji+ukLBoNE+@kernel.org>
 <84b8eb06-7b77-675f-5bc8-292fe27dd2f5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84b8eb06-7b77-675f-5bc8-292fe27dd2f5@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 01, 2022 at 03:34:10PM -0700, Reinette Chatre wrote:
> Hi Jarkko,
> 
> On 9/1/2022 2:53 PM, Jarkko Sakkinen wrote:
> > On Wed, Aug 31, 2022 at 01:39:53PM -0700, Reinette Chatre wrote:
> >> On 8/31/2022 10:38 AM, Jarkko Sakkinen wrote:
> 
> >> I think I am missing something here. A lot of logic is added here but I
> >> do not see why it is necessary.  ksgxd() knows via kthread_should_stop() if
> >> the reclaimer was canceled. I am thus wondering, could the above not be
> >> simplified to something similar to V1:
> >>
> >> @@ -388,6 +393,8 @@ void sgx_reclaim_direct(void)
> >>  
> >>  static int ksgxd(void *p)
> >>  {
> >> +	unsigned long left_dirty;
> >> +
> >>  	set_freezable();
> >>  
> >>  	/*
> >> @@ -395,10 +402,10 @@ static int ksgxd(void *p)
> >>  	 * required for SECS pages, whose child pages blocked EREMOVE.
> >>  	 */
> >>  	__sgx_sanitize_pages(&sgx_dirty_page_list);
> > 
> > IMHO, would make sense also to have here:
> > 
> >         if (!kthread_should_stop())
> >                 return 0;
> > 
> 
> Would this not prematurely stop the thread when it should not be?
> 
> >> -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> >>  
> >> -	/* sanity check: */
> >> -	WARN_ON(!list_empty(&sgx_dirty_page_list));
> >> +	left_dirty = __sgx_sanitize_pages(&sgx_dirty_page_list);
> >> +	if (left_dirty && !kthread_should_stop())
> >> +		pr_err("%lu unsanitized pages\n", left_dirty);
> > 
> > That would be incorrect, if the function returned
> > because of kthread stopped.
> 
> 
> I should have highlighted this but in my example I changed
> left_dirty to be "unsigned long" with the intention that the
> "return -ECANCELED" is replaced with "return 0".

It wasn't supposed to be, it's an error. Thanks for spotting
that.

> 
> __sgx_sanitize_pages() returns 0 when it exits because of
> kthread stopped.
> 
> To elaborate I was thinking about:
> 
> +static unsigned long __sgx_sanitize_pages(struct list_head *dirty_page_list)
>  {
> +	unsigned long left_dirty = 0;
>  	struct sgx_epc_page *page;
>  	LIST_HEAD(dirty);
>  	int ret;
>  
> -	/* dirty_page_list is thread-local, no need for a lock: */
>  	while (!list_empty(dirty_page_list)) {
>  		if (kthread_should_stop())
> -			return;
> +			return 0;
>  
>  		page = list_first_entry(dirty_page_list, struct sgx_epc_page, list);
>  
> @@ -92,12 +95,14 @@ static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
>  		} else {
>  			/* The page is not yet clean - move to the dirty list. */
>  			list_move_tail(&page->list, &dirty);
> +			left_dirty++;
>  		}
>  
>  		cond_resched();
>  	}
>  
>  	list_splice(&dirty, dirty_page_list);
> +	return left_dirty;
>  }
> 
> 
> and then with what I had in previous email the checks should work:
> 
> @@ -388,6 +393,8 @@ void sgx_reclaim_direct(void)
>  
>  static int ksgxd(void *p)
>  {
> +	unsigned long left_dirty;
> +
>  	set_freezable();
>  
>  	/*
> @@ -395,10 +402,10 @@ static int ksgxd(void *p)
>  	 * required for SECS pages, whose child pages blocked EREMOVE.
>  	 */
>  	__sgx_sanitize_pages(&sgx_dirty_page_list);
> -	__sgx_sanitize_pages(&sgx_dirty_page_list);
>  
> -	/* sanity check: */
> -	WARN_ON(!list_empty(&sgx_dirty_page_list));
> +	left_dirty = __sgx_sanitize_pages(&sgx_dirty_page_list);
> +	if (left_dirty && !kthread_should_stop())
> +		pr_err("%lu unsanitized pages\n", left_dirty);
>  
>  	while (!kthread_should_stop()) {
>  		if (try_to_freeze())
> 
> 
> > 
> > If you do the check here you already have a window
> > where kthread could have been stopped anyhow.
> > 
> > So even this would be less correct:
> > 
> >         if (kthreas_should_stop()) {
> >                 return 0;
> >         }  else if (left_dirty) {
> >                 pr_err("%lu unsanitized pages\n", left_dirty);
> >         }
> > 
> > So in the end you end as complicated and less correct
> > fix. This all is explained in the commit message.
> > 
> > If you unconditionally print error, you don't have
> > a meaning for the number of unsanitized pags.
> 
> Understood that the goal is to only print the
> number of unsanitized pages if ksgxd has not been
> stopped prematurely.

Yeah, and thus give as useful information for sysadmin/developer
as we can.

BR, Jarkko
