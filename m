Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D2B2FEAD2
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 13:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731172AbhAUM4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 07:56:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbhAUM4A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Jan 2021 07:56:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D91F23A00;
        Thu, 21 Jan 2021 12:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611233719;
        bh=1BNzVy1B4d8KkBuUW90iFZgA5HwyTa84DBFqPiEQ+1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U8Rvy+vfheS8CGdDoPazhTsYcGa9DkDU1QSP6a/ZYr/grk0ZzK6tUu62TBB8MzWXO
         XZqQ4D14Ed9yTmmVdi/saqNzFiBzX+dtqvCysPWcusR+9B3ReS1eUHeo5GkpUJ4IeS
         CNO0PqIFaj5pplAbdxPGGOgfhsl+FSsG2GrJvgP80PO13/HqTZTWeISaCPj9UaAbv8
         3qnSj9Gly63KOisMX1yHtfmpBCTmKKZk159GVpWNqXE0eCQ/eSMCrL/h+792fZ/HI/
         NhhKEwiJTqpAfFEEo8s1HZo6hFxhyIvZ43jejTHYhVbB1qHYERYekUFT0RJKBsRHqw
         GyqjnqCUie2ww==
Date:   Thu, 21 Jan 2021 14:55:17 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, linux-sgx@vger.kernel.org,
        kai.huang@intel.com, haitao.huang@intel.com,
        stable@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v4] x86/sgx: Fix the call order of synchronize_srcu() in
 sgx_release()
Message-ID: <YAl5tR5uvDqv/Is6@suppilovahvero.lan>
References: <20210115014638.15037-1-jarkko@kernel.org>
 <YAhp4Jrj6hIcvgRC@google.com>
 <YAjK9n6zct2VTp74@kernel.org>
 <042741ff-1436-f3f2-df23-a524d1d7026d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <042741ff-1436-f3f2-df23-a524d1d7026d@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 20, 2021 at 05:19:44PM -0800, Dave Hansen wrote:
> On 1/20/21 4:29 PM, Jarkko Sakkinen wrote:
> > On Wed, Jan 20, 2021 at 09:35:28AM -0800, Sean Christopherson wrote:
> >> On Fri, Jan 15, 2021, jarkko@kernel.org wrote:
> >>> From: Jarkko Sakkinen <jarkko@kernel.org>
> >>>
> >>> The most trivial example of a race condition can be demonstrated with this
> >>> example where mm_list contains just one entry:
> >>>
> >>> CPU A                   CPU B
> >>> sgx_release()
> >>>                         sgx_mmu_notifier_release()
> >>>                         list_del_rcu()
> >>> sgx_encl_release()
> >>>                         synchronize_srcu()
> >>> cleanup_srcu_struct()
> >>>
> >>> To fix this, call synchronize_srcu() before checking whether mm_list is
> >>> empty in sgx_release().
> >> Why haven't you included the splat that Haitao provided?  That would go a long
> >> way to helping answer Boris' question about exactly what is broken...
> > I've lost the klog.
> 
> Haitao said he thought it was this:
> 
> > void cleanup_srcu_struct(struct srcu_struct *ssp)
> > {
> ...
> >         if (WARN_ON(srcu_readers_active(ssp)))
> >                 return; /* Just leak it! */
> 
> Which would indicate that an 'encl' kref reached 0 while some other
> thread was inside a
> 
>         idx = srcu_read_lock(&encl->srcu);
> 	...
> 	srcu_read_unlock(&encl->srcu, idx);
> 
> critical section.  A quick audit didn't turn up any obvious suspects,
> though.
> 
> If that *is* it, it might be nice to try to catch the culprit at
> srcu_read_{un}lock() time.  If there's ever a 0 refcount at those sites,
> it would be nice to spew a warning:
> 
>         idx = srcu_read_lock(&encl->srcu);
> 	WARN_ON(!atomic_read(&encl->refcount->refcount);
> 	...
> 	WARN_ON(!atomic_read(&encl->refcount->refcount);
> 	srcu_read_unlock(&encl->srcu, idx);
> 
> at each site.

The root cause is fully known already and audited.

An mm_list entry is kept up until the process exits *or* when
VFS close happens, and sgx_release() executes and removes it.

It's entirely possible that MMU notifier callback registered
by a process happens while sgx_release() is executing, which
causes list_del_rcu() to happen, unnoticed by sgx_release().

If that empties the list, cleanup_srcu_struct() is executed
unsynchronized in the middle a unfinished grace period.

/Jarkko
