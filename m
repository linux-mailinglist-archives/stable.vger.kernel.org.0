Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE5849CC57
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 15:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242144AbiAZObE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 09:31:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51808 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbiAZObE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 09:31:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5098B81E71;
        Wed, 26 Jan 2022 14:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245ECC340E3;
        Wed, 26 Jan 2022 14:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643207461;
        bh=+ZcOBP4gSDqRyHURZxSEAOeJhrvKQsJlVC7k9KKTdpE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WqlHZ0Hd0JjNp/3YqPQCi33cZfCT04Xu9acFdbanAAY21ATZ8savAbDkHAJV8DH9b
         AGGqY164luOorcSRnKn7n4dWP/ukOwKjlT6E7OKuBgHF2L5nKnmyvf2uo5bibwOsSF
         o9toVGk87HRPfOY9IAlAdCPQbFqYnD6Pe2CblJVD9P7KOehM2INWAzglKXKtxuUg4N
         ws3pUYPSjpszT4PGCZOIs9O9fWU4KQK5oMnxa5sIMAK09tIEqLwrROyZaxWEbUDMJm
         Rzs4qGBGJdS89itI8HJXbe2kK2o4ZC6idvfDjsWVZJyEq2Vs0aW7SMg8CSiGtaNCwu
         rQyYDwP0tUcXw==
Date:   Wed, 26 Jan 2022 16:30:41 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        luto@kernel.org, mingo@redhat.com, linux-sgx@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Silence softlockup detection when releasing
 large enclaves
Message-ID: <YfFbEaMhqae/jFiM@iki.fi>
References: <1aa037705e5aa209d8b7a075873c6b4190327436.1642530802.git.reinette.chatre@intel.com>
 <e4e8fbe757860cd24e2f66b25be60d76663935d8.camel@kernel.org>
 <71032a38-e1ab-ac73-09f7-9eefffd53674@intel.com>
 <YfFauJSPU5TNetSe@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YfFauJSPU5TNetSe@iki.fi>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 04:29:12PM +0200, Jarkko Sakkinen wrote:
> On Thu, Jan 20, 2022 at 08:28:36AM -0800, Reinette Chatre wrote:
> > Hi Jarkko,
> > 
> > On 1/20/2022 5:01 AM, Jarkko Sakkinen wrote:
> > > On Tue, 2022-01-18 at 11:14 -0800, Reinette Chatre wrote:
> > >> Vijay reported that the "unclobbered_vdso_oversubscribed" selftest
> > >> triggers the softlockup detector.
> > >>
> > >> Actual SGX systems have 128GB of enclave memory or more.  The
> > >> "unclobbered_vdso_oversubscribed" selftest creates one enclave which
> > >> consumes all of the enclave memory on the system. Tearing down such a
> > >> large enclave takes around a minute, most of it in the loop where
> > >> the EREMOVE instruction is applied to each individual 4k enclave
> > >> page.
> > >>
> > >> Spending one minute in a loop triggers the softlockup detector.
> > >>
> > >> Add a cond_resched() to give other tasks a chance to run and placate
> > >> the softlockup detector.
> > >>
> > >> Cc: stable@vger.kernel.org
> > >> Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> > >> Reported-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > >> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> > >> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> > >> ---
> > >> Softlockup message:
> > >> watchdog: BUG: soft lockup - CPU#7 stuck for 22s! [test_sgx:11502]
> > >> Kernel panic - not syncing: softlockup: hung tasks
> > >> <snip>
> > >> sgx_encl_release+0x86/0x1c0
> > >> sgx_release+0x11c/0x130
> > >> __fput+0xb0/0x280
> > >> ____fput+0xe/0x10
> > >> task_work_run+0x6c/0xc0
> > >> exit_to_user_mode_prepare+0x1eb/0x1f0
> > >> syscall_exit_to_user_mode+0x1d/0x50
> > >> do_syscall_64+0x46/0xb0
> > >> entry_SYSCALL_64_after_hwframe+0x44/0xae
> > >>
> > >>  arch/x86/kernel/cpu/sgx/encl.c | 1 +
> > >>  1 file changed, 1 insertion(+)
> > >>
> > >> diff --git a/arch/x86/kernel/cpu/sgx/encl.c
> > >> b/arch/x86/kernel/cpu/sgx/encl.c
> > >> index 001808e3901c..ab2b79327a8a 100644
> > >> --- a/arch/x86/kernel/cpu/sgx/encl.c
> > >> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > >> @@ -410,6 +410,7 @@ void sgx_encl_release(struct kref *ref)
> > >>                 }
> > >>  
> > >>                 kfree(entry);
> > >> +               cond_resched();
> > >>         }
> > >>  
> > >>         xa_destroy(&encl->page_array);
> > > 
> > > I'd add a comment, e.g.
> > > 
> > > /* Invoke scheduler to prevent soft lockups. */
> > 
> > I could do that. I would like to point out though that there are already
> > six other usages of cond_resched() in the driver and it does indeed
> > seem to be the common pattern. When adding this comment to the now
> > seventh usage it would be the first comment documenting the usage of
> > cond_resched() in the driver.
> > 
> > > 
> > > Other than that makes sense.
> > 
> > Thank you very much for taking a look.
> 
> Well, I believe in inline comments to evolution. As in here it was missing,
> a reminder makes sense.

E.g. there gazillion uses of kmalloc() in kernel but still not all of them
have a comment bound to them...

BR, Jarkko
