Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2215F5AA1DE
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 00:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbiIAWBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 18:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbiIAWBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 18:01:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570B04BA71;
        Thu,  1 Sep 2022 15:01:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0C35B82962;
        Thu,  1 Sep 2022 22:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C69C433D6;
        Thu,  1 Sep 2022 22:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662069702;
        bh=5J2fZaY2SZYVV/qA8tQvMcVyQP2JhpvBw27qwVceS8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mxn3dWKzcR6Qr5530izk0wFMLq05/qVM71vPJqle5+XlMHRqK2r00BKauhLXe8OmB
         R0xwlZ+tUF4SURCgOcM4swTD3Gqo/MGat5thqmIte3i07UxCa5cjkekAhukgH7FoLD
         FWVD196/JEKCBou1Py3n61DbSkgC3JRF0LXqj0Od7MTv4nrYte1uI0gSCWly81KuWo
         7FNzjNMNwX79qPfzV0HOM5wZ7BewYrrSnsb+0IFKAGe6iyyzKurU1R9AN8QUHrbt5i
         Oyt/vKOWpccRP2SgEPKbNsWZE83M4Rk+wz6GXOlYtRaflyRtcqY/BC8RUnbanbLvhw
         RZn1L1JhiO/JA==
Date:   Fri, 2 Sep 2022 01:01:36 +0300
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
Message-ID: <YxErwGYfY5JI+/Ex@kernel.org>
References: <20220831173829.126661-1-jarkko@kernel.org>
 <20220831173829.126661-3-jarkko@kernel.org>
 <24906e57-461f-6c94-9e78-0d8507df01bb@intel.com>
 <YxEp8Ji+ukLBoNE+@kernel.org>
 <YxEqj8/+VXlaIT4m@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxEqj8/+VXlaIT4m@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 02, 2022 at 12:56:34AM +0300, Jarkko Sakkinen wrote:
> On Fri, Sep 02, 2022 at 12:53:55AM +0300, Jarkko Sakkinen wrote:
> > On Wed, Aug 31, 2022 at 01:39:53PM -0700, Reinette Chatre wrote:
> > > Hi Jarkko,
> > > 
> > > On 8/31/2022 10:38 AM, Jarkko Sakkinen wrote:
> > > > In sgx_init(), if misc_register() fails or misc_register() succeeds but
> > > > neither sgx_drv_init() nor sgx_vepc_init() succeeds, then ksgxd will be
> > > > prematurely stopped. This may leave some unsanitized pages, which does
> > > > not matter, because SGX will be disabled for the whole power cycle.
> > > > 
> > > > This triggers WARN_ON() because sgx_dirty_page_list ends up being
> > > > non-empty, and dumps the call stack:
> > > > 
> > > > [    0.268103] sgx: EPC section 0x40200000-0x45f7ffff
> > > > [    0.268591] ------------[ cut here ]------------
> > > > [    0.268592] WARNING: CPU: 6 PID: 83 at
> > > > arch/x86/kernel/cpu/sgx/main.c:401 ksgxd+0x1b7/0x1d0
> > > > [    0.268598] Modules linked in:
> > > > [    0.268600] CPU: 6 PID: 83 Comm: ksgxd Not tainted 6.0.0-rc2 #382
> > > > [    0.268603] Hardware name: Dell Inc. XPS 13 9370/0RMYH9, BIOS 1.21.0
> > > > 07/06/2022
> > > > [    0.268604] RIP: 0010:ksgxd+0x1b7/0x1d0
> > > > [    0.268607] Code: ff e9 f2 fe ff ff 48 89 df e8 75 07 0e 00 84 c0 0f
> > > > 84 c3 fe ff ff 31 ff e8 e6 07 0e 00 84 c0 0f 85 94 fe ff ff e9 af fe ff
> > > > ff <0f> 0b e9 7f fe ff ff e8 dd 9c 95 00 66 66 2e 0f 1f 84 00 00 00 00
> > > > [    0.268608] RSP: 0000:ffffb6c7404f3ed8 EFLAGS: 00010287
> > > > [    0.268610] RAX: ffffb6c740431a10 RBX: ffff8dcd8117b400 RCX:
> > > > 0000000000000000
> > > > [    0.268612] RDX: 0000000080000000 RSI: ffffb6c7404319d0 RDI:
> > > > 00000000ffffffff
> > > > [    0.268613] RBP: ffff8dcd820a4d80 R08: ffff8dcd820a4180 R09:
> > > > ffff8dcd820a4180
> > > > [    0.268614] R10: 0000000000000000 R11: 0000000000000006 R12:
> > > > ffffb6c74006bce0
> > > > [    0.268615] R13: ffff8dcd80e63880 R14: ffffffffa8a60f10 R15:
> > > > 0000000000000000
> > > > [    0.268616] FS:  0000000000000000(0000) GS:ffff8dcf25580000(0000)
> > > > knlGS:0000000000000000
> > > > [    0.268617] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [    0.268619] CR2: 0000000000000000 CR3: 0000000213410001 CR4:
> > > > 00000000003706e0
> > > > [    0.268620] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > > 0000000000000000
> > > > [    0.268621] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > > > 0000000000000400
> > > > [    0.268622] Call Trace:
> > > > [    0.268624]  <TASK>
> > > > [    0.268627]  ? _raw_spin_lock_irqsave+0x24/0x60
> > > > [    0.268632]  ? _raw_spin_unlock_irqrestore+0x23/0x40
> > > > [    0.268634]  ? __kthread_parkme+0x36/0x90
> > > > [    0.268637]  kthread+0xe5/0x110
> > > > [    0.268639]  ? kthread_complete_and_exit+0x20/0x20
> > > > [    0.268642]  ret_from_fork+0x1f/0x30
> > > > [    0.268647]  </TASK>
> > > > [    0.268648] ---[ end trace 0000000000000000 ]---
> > > > 
> > > 
> > > Are you still planning to trim this?
> > > 
> > > > Ultimately this can crash the kernel, if the following is set:
> > > > 
> > > > 	/proc/sys/kernel/panic_on_warn
> > > > 
> > > > In premature stop, print nothing, as the number is by practical means a
> > > > random number. Otherwise, it is an indicator of a bug in the driver, and
> > > > therefore print the number of unsanitized pages with pr_err().
> > > 
> > > I think that "print the number of unsanitized pages with pr_err()" 
> > > contradicts the patch subject of "Do not consider unsanitized pages
> > > an error".
> > > 
> > > ...
> > > 
> > > > @@ -388,17 +393,40 @@ void sgx_reclaim_direct(void)
> > > >  
> > > >  static int ksgxd(void *p)
> > > >  {
> > > > +	long ret;
> > > > +
> > > >  	set_freezable();
> > > >  
> > > >  	/*
> > > >  	 * Sanitize pages in order to recover from kexec(). The 2nd pass is
> > > >  	 * required for SECS pages, whose child pages blocked EREMOVE.
> > > >  	 */
> > > > -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> > > > -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> > > > +	ret = __sgx_sanitize_pages(&sgx_dirty_page_list);
> > > > +	if (ret == -ECANCELED)
> > > > +		/* kthread stopped */
> > > > +		return 0;
> > > >  
> > > > -	/* sanity check: */
> > > > -	WARN_ON(!list_empty(&sgx_dirty_page_list));
> > > > +	ret = __sgx_sanitize_pages(&sgx_dirty_page_list);
> > > > +	switch (ret) {
> > > > +	case 0:
> > > > +		/* success, no unsanitized pages */
> > > > +		break;
> > > > +
> > > > +	case -ECANCELED:
> > > > +		/* kthread stopped */
> > > > +		return 0;
> > > > +
> > > > +	default:
> > > > +		/*
> > > > +		 * Never expected to happen in a working driver. If it happens
> > > > +		 * the bug is expected to be in the sanitization process, but
> > > > +		 * successfully sanitized pages are still valid and driver can
> > > > +		 * be used and most importantly debugged without issues. To put
> > > > +		 * short, the global state of kernel is not corrupted so no
> > > > +		 * reason to do any more complicated rollback.
> > > > +		 */
> > > > +		pr_err("%ld unsanitized pages\n", ret);
> > > > +	}
> > > >  
> > > >  	while (!kthread_should_stop()) {
> > > >  		if (try_to_freeze())
> > > 
> > > 
> > > I think I am missing something here. A lot of logic is added here but I
> > > do not see why it is necessary.  ksgxd() knows via kthread_should_stop() if
> > > the reclaimer was canceled. I am thus wondering, could the above not be
> > > simplified to something similar to V1:
> > > 
> > > @@ -388,6 +393,8 @@ void sgx_reclaim_direct(void)
> > >  
> > >  static int ksgxd(void *p)
> > >  {
> > > +	unsigned long left_dirty;
> > > +
> > >  	set_freezable();
> > >  
> > >  	/*
> > > @@ -395,10 +402,10 @@ static int ksgxd(void *p)
> > >  	 * required for SECS pages, whose child pages blocked EREMOVE.
> > >  	 */
> > >  	__sgx_sanitize_pages(&sgx_dirty_page_list);
> > 
> > IMHO, would make sense also to have here:
> > 
> >         if (!kthread_should_stop())
> >                 return 0;
> > 
> > > -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> > >  
> > > -	/* sanity check: */
> > > -	WARN_ON(!list_empty(&sgx_dirty_page_list));
> > > +	left_dirty = __sgx_sanitize_pages(&sgx_dirty_page_list);
> > > +	if (left_dirty && !kthread_should_stop())
> > > +		pr_err("%lu unsanitized pages\n", left_dirty);
> > 
> > That would be incorrect, if the function returned
> > because of kthread stopped.
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
> If you add my long comment explaining the error case, the SLOC
> size is almost the same. That takes most space in my patch.

Printing pages if the thread was stopped is just making
the bug look different and have less output, it does not
fix anything, except prevent kernel panic.

BR, Jarkko
