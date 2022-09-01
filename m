Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA025AA1B3
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 23:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbiIAVr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 17:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbiIAVr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 17:47:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C764D7B1C9;
        Thu,  1 Sep 2022 14:47:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98A9B61F5F;
        Thu,  1 Sep 2022 21:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EA2C433C1;
        Thu,  1 Sep 2022 21:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662068869;
        bh=OrQnwaTJvbac1g67sWB/Jasesgbc3kuqbK5ldTdmRTs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uc5QxIjrQmSi65A9U0YDxDP1Sui0Cx3iWO3J8hFA3Rzwk1LmWpAG0Bl5Af5x3u7j2
         9X2R9uVLdqLPhcgAMX0viFW0PNbtR1+vf0B5+g9axQw3qSRdoQRK9kD9OpKizpmuKT
         R/JDn+6zQaID9VZA3SQyAk13ZDShYIOr3aw3Qcf8Ea/j3g2x/haflXgs7NM+pA49rY
         VhRvkzi4RTZNMZ1A06ZFPx5ZjuB7lFJYSZyvReKC3H6IeIk1tA6NWmHyuWPFpDgVEL
         /tcNp1RpxCSn0RpU8f4aAQS6UW7Cn8EN8XKSbi9SS5DnPgQTO6Rk4YzLiKQ6y2UAUE
         AkwTXYBk90qjw==
Date:   Fri, 2 Sep 2022 00:47:43 +0300
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] x86/sgx: Do not consider unsanitized pages an
 error
Message-ID: <YxEof73XWYc8pYdZ@kernel.org>
References: <20220831173829.126661-1-jarkko@kernel.org>
 <20220831173829.126661-3-jarkko@kernel.org>
 <24906e57-461f-6c94-9e78-0d8507df01bb@intel.com>
 <d6a3212aa11c2788d35094739abe40909373cd68.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6a3212aa11c2788d35094739abe40909373cd68.camel@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 01, 2022 at 10:50:07AM +0000, Huang, Kai wrote:
> On Wed, 2022-08-31 at 13:39 -0700, Reinette Chatre wrote:
> > >   static int ksgxd(void *p)
> > >   {
> > > +	long ret;
> > > +
> > >   	set_freezable();
> > >   
> > >   	/*
> > >   	 * Sanitize pages in order to recover from kexec(). The 2nd pass is
> > >   	 * required for SECS pages, whose child pages blocked EREMOVE.
> > >   	 */
> > > -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> > > -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> > > +	ret = __sgx_sanitize_pages(&sgx_dirty_page_list);
> > > +	if (ret == -ECANCELED)
> > > +		/* kthread stopped */
> > > +		return 0;
> > >   
> > > -	/* sanity check: */
> > > -	WARN_ON(!list_empty(&sgx_dirty_page_list));
> > > +	ret = __sgx_sanitize_pages(&sgx_dirty_page_list);
> > > +	switch (ret) {
> > > +	case 0:
> > > +		/* success, no unsanitized pages */
> > > +		break;
> > > +
> > > +	case -ECANCELED:
> > > +		/* kthread stopped */
> > > +		return 0;
> > > +
> > > +	default:
> > > +		/*
> > > +		 * Never expected to happen in a working driver. If it
> > > happens
> > > +		 * the bug is expected to be in the sanitization process,
> > > but
> > > +		 * successfully sanitized pages are still valid and driver
> > > can
> > > +		 * be used and most importantly debugged without issues. To
> > > put
> > > +		 * short, the global state of kernel is not corrupted so no
> > > +		 * reason to do any more complicated rollback.
> > > +		 */
> > > +		pr_err("%ld unsanitized pages\n", ret);
> > > +	}
> > >   
> > >   	while (!kthread_should_stop()) {
> > >   		if (try_to_freeze())
> > 
> > 
> > I think I am missing something here. A lot of logic is added here but I
> > do not see why it is necessary.  ksgxd() knows via kthread_should_stop() if
> > the reclaimer was canceled. I am thus wondering, could the above not be
> > simplified to something similar to V1:
> > 
> > @@ -388,6 +393,8 @@ void sgx_reclaim_direct(void)
> >  
> >  static int ksgxd(void *p)
> >  {
> > +	unsigned long left_dirty;
> > +
> >  	set_freezable();
> >  
> >  	/*
> > @@ -395,10 +402,10 @@ static int ksgxd(void *p)
> >  	 * required for SECS pages, whose child pages blocked EREMOVE.
> >  	 */
> >  	__sgx_sanitize_pages(&sgx_dirty_page_list);
> > -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> >  
> > -	/* sanity check: */
> > -	WARN_ON(!list_empty(&sgx_dirty_page_list));
> > +	left_dirty = __sgx_sanitize_pages(&sgx_dirty_page_list);
> > +	if (left_dirty && !kthread_should_stop())
> > +		pr_err("%lu unsanitized pages\n", left_dirty);
> >  
> 
> This basically means driver bug if I understand correctly.  To be consistent
> with the behaviour of existing code, how about just WARN()?
> 	
> 	...
> 	left_dirty = __sgx_sanitize_pages(&sgx_dirty_page_list);
> 	WARN_ON(left_dirty && !kthread_should_stop());
> 
> It seems there's little value to print out the unsanitized pages here.  The
> existing code doesn't print it anyway.

Using WARN IMHO here is too strong measure, given that
it tear down the whole kernel, if panic_on_warn is enabled.

For debugging, any information is useful information, so
would not make sense not print the number of pages, if 
that is available. That could very well point out the
issue why all pages are not sanitized if there was a bug.

BR, Jarkko
