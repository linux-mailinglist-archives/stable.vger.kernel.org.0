Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DD349CC53
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 15:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbiAZO3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 09:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbiAZO3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 09:29:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B4CC06161C;
        Wed, 26 Jan 2022 06:29:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A163B81E66;
        Wed, 26 Jan 2022 14:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDBFC340E3;
        Wed, 26 Jan 2022 14:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643207372;
        bh=pWEEutZGmoLYplYAkdgznvxnwOPUR3rQhhgjKa18Waw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rN73OAcpkdhzmwGpRyhbVsfs0wx0G+AEvN+N2+ahYZTUceIo3Zj5x7crC1Xt4mXKq
         gbxaZ/nRoJvOsWG+wleKubMpi13rwBRKlPvZteTwOssL+Qu44e+60NaO46fgH+thw6
         4Hi1EZ9GJKLPrtFKOGFl0U7bXdSicOJY/Te4rBOb7Cl4Y1SonDYQLEKcsui2JpN5Ux
         7t9bYMlBNdN4FGhMU88CrvJHt04WijzMI932IXS5YLTF+aadROyglqf0gddCLr6ISQ
         gkjD30wO0I4oUDxmc7QjRDsIrFDTO8bpuAs21In7uacXdDke1aNctkBhDCuWzNbEvd
         Vo+H5VFTO9/RA==
Date:   Wed, 26 Jan 2022 16:29:12 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        luto@kernel.org, mingo@redhat.com, linux-sgx@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Silence softlockup detection when releasing
 large enclaves
Message-ID: <YfFauJSPU5TNetSe@iki.fi>
References: <1aa037705e5aa209d8b7a075873c6b4190327436.1642530802.git.reinette.chatre@intel.com>
 <e4e8fbe757860cd24e2f66b25be60d76663935d8.camel@kernel.org>
 <71032a38-e1ab-ac73-09f7-9eefffd53674@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71032a38-e1ab-ac73-09f7-9eefffd53674@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 20, 2022 at 08:28:36AM -0800, Reinette Chatre wrote:
> Hi Jarkko,
> 
> On 1/20/2022 5:01 AM, Jarkko Sakkinen wrote:
> > On Tue, 2022-01-18 at 11:14 -0800, Reinette Chatre wrote:
> >> Vijay reported that the "unclobbered_vdso_oversubscribed" selftest
> >> triggers the softlockup detector.
> >>
> >> Actual SGX systems have 128GB of enclave memory or more.  The
> >> "unclobbered_vdso_oversubscribed" selftest creates one enclave which
> >> consumes all of the enclave memory on the system. Tearing down such a
> >> large enclave takes around a minute, most of it in the loop where
> >> the EREMOVE instruction is applied to each individual 4k enclave
> >> page.
> >>
> >> Spending one minute in a loop triggers the softlockup detector.
> >>
> >> Add a cond_resched() to give other tasks a chance to run and placate
> >> the softlockup detector.
> >>
> >> Cc: stable@vger.kernel.org
> >> Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> >> Reported-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
> >> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> >> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> >> ---
> >> Softlockup message:
> >> watchdog: BUG: soft lockup - CPU#7 stuck for 22s! [test_sgx:11502]
> >> Kernel panic - not syncing: softlockup: hung tasks
> >> <snip>
> >> sgx_encl_release+0x86/0x1c0
> >> sgx_release+0x11c/0x130
> >> __fput+0xb0/0x280
> >> ____fput+0xe/0x10
> >> task_work_run+0x6c/0xc0
> >> exit_to_user_mode_prepare+0x1eb/0x1f0
> >> syscall_exit_to_user_mode+0x1d/0x50
> >> do_syscall_64+0x46/0xb0
> >> entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>
> >>  arch/x86/kernel/cpu/sgx/encl.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/arch/x86/kernel/cpu/sgx/encl.c
> >> b/arch/x86/kernel/cpu/sgx/encl.c
> >> index 001808e3901c..ab2b79327a8a 100644
> >> --- a/arch/x86/kernel/cpu/sgx/encl.c
> >> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> >> @@ -410,6 +410,7 @@ void sgx_encl_release(struct kref *ref)
> >>                 }
> >>  
> >>                 kfree(entry);
> >> +               cond_resched();
> >>         }
> >>  
> >>         xa_destroy(&encl->page_array);
> > 
> > I'd add a comment, e.g.
> > 
> > /* Invoke scheduler to prevent soft lockups. */
> 
> I could do that. I would like to point out though that there are already
> six other usages of cond_resched() in the driver and it does indeed
> seem to be the common pattern. When adding this comment to the now
> seventh usage it would be the first comment documenting the usage of
> cond_resched() in the driver.
> 
> > 
> > Other than that makes sense.
> 
> Thank you very much for taking a look.

Well, I believe in inline comments to evolution. As in here it was missing,
a reminder makes sense.

/Jarkko
