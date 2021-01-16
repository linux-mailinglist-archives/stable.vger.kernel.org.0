Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5822F8B68
	for <lists+stable@lfdr.de>; Sat, 16 Jan 2021 06:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbhAPFNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jan 2021 00:13:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbhAPFNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Jan 2021 00:13:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3939C23A34;
        Sat, 16 Jan 2021 05:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610773980;
        bh=XjHYfZhoEozBWkWnRtYvEXm1JhtV+IohCAnqoPyxpp0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nedo86rhUMEYWWZTGQLmJe+9Hi+obI37NvHWROzDwLsdH64Paj54PUbFZaKLsxk4N
         h2U/cL6LvMOeMYLrrJUhaWGqoNxmP3NLyOz35MgdKKVM3sfTfqEGshLqlZQ1Q2hIoL
         hyoDx2+rGRpj5NAxKDHhUikbakYx2Leu7e0YdHtG5Gt5pucDeiLVf93unP6IdjXy4n
         dkBmTVGip6cYCokNzAwsCws+BsRLxvnilziyXVewHK4igUeUoEAMOjQ+bil+Gooh/Z
         tRZFz2o2lQ8KAm3Qidxx7grGqHWubB0ML+G6q+gILQX2a1x4wGa0bGd6rUagDhkcwx
         V2ceAUNEZ4DLQ==
Date:   Sat, 16 Jan 2021 07:12:54 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        kai.huang@intel.com, haitao.huang@intel.com, seanjc@google.com,
        stable@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v4] x86/sgx: Fix the call order of synchronize_srcu() in
 sgx_release()
Message-ID: <YAJ11v5tuS2uMuNm@kernel.org>
References: <20210115014638.15037-1-jarkko@kernel.org>
 <20210115071809.GA9138@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115071809.GA9138@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 08:18:09AM +0100, Borislav Petkov wrote:
> On Fri, Jan 15, 2021 at 03:46:38AM +0200, jarkko@kernel.org wrote:
> > From: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > The most trivial example of a race condition can be demonstrated with this
> > example where mm_list contains just one entry:
> > 
> > CPU A                   CPU B
> > sgx_release()
> >                         sgx_mmu_notifier_release()
> >                         list_del_rcu()
> > sgx_encl_release()
> >                         synchronize_srcu()
> > cleanup_srcu_struct()
> > 
> > To fix this, call synchronize_srcu() before checking whether mm_list is
> > empty in sgx_release().
> 
> To fix what?
> 
> Lemme explain one more time: a commit message for a race condition
> fix needs to explain in *detail* what the race condition is. And that
> explanation needs to be understandable months and years from now.
> 
> You have the function call order above, now you have to explain what can
> happen. Just how you did here:
> 
> https://lkml.kernel.org/r/X/zoarV7gd/LNo4A@kernel.org

OK, I could recall the race that from but that must be partly because I've
been proactively working on it, i.e. getting your point.

So let's say I add this after the sequence:

"The sequence demonstrates a scenario where CPU B starts a new
grace period, which goes unnoticed by CPU A in sgx_release(),
because it did not remove the final entry from the enclave's
mm list."

Would this be sufficient or not?

> > Cc: stable@vger.kernel.org
> > Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Suggested-by: Haitao Huang <haitao.huang@linux.intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> > v4:
> > - Rewrite the commit message.
> > - Just change the call order. *_expedited() is out of scope for this
> >   bug fix.
> > v3: Fine-tuned tags, and added missing change log for v2.
> > v2: Switch to synchronize_srcu_expedited().
> >  arch/x86/kernel/cpu/sgx/driver.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> > index f2eac41bb4ff..53056345f5f8 100644
> > --- a/arch/x86/kernel/cpu/sgx/driver.c
> > +++ b/arch/x86/kernel/cpu/sgx/driver.c
> > @@ -65,11 +65,16 @@ static int sgx_release(struct inode *inode, struct file *file)
> >  
> >  		spin_unlock(&encl->mm_lock);
> >  
> > +		/*
> > +		 * The call is need even if the list empty, because sgx_encl_mmu_notifier_release()
> 
> "The call is need"?
> 
> 
> $ git grep sgx_encl_mmu_notifier_release
> $
> 
> WTF?
> 
> Please be more careful.

Note taken.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
