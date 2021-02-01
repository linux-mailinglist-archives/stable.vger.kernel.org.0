Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBEC30A917
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 14:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhBANvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 08:51:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232261AbhBANvU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 08:51:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7252564E94;
        Mon,  1 Feb 2021 13:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612187440;
        bh=PIRJZK+50M37ZgXe3W9pJrPrPAO1eBSYKluQ8bQE4Vw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PcEKqAzepQq3ymtGabAgBZrb38AZ/4IbpowU9A0Qsm6CH/+22OuDKHXFF4GmuURtS
         DCd7VeVW0N3FB7BAeeMZWJnWCqwJWzTTDFTd7kl3zeb4LddurPWRZ75yftkBMDZNw4
         f29F4utx4YEoDsOQPUETL3G6iumn5OPfVDxMbpck=
Date:   Mon, 1 Feb 2021 14:50:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     catalin.marinas@arm.com, rick.p.edgecombe@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: Forbid the use of tagged userspace
 addresses for" failed to apply to 5.4-stable tree
Message-ID: <YBgHLR9XKTV2bnYE@kroah.com>
References: <16121832895919@kroah.com>
 <6253bf3c8ccea96cd36bc225ff5f7ed6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6253bf3c8ccea96cd36bc225ff5f7ed6@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 01, 2021 at 01:29:02PM +0000, Marc Zyngier wrote:
> Hi Greg,
> 
> On 2021-02-01 12:41, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From 139bc8a6146d92822c866cf2fd410159c56b3648 Mon Sep 17 00:00:00 2001
> > From: Marc Zyngier <maz@kernel.org>
> > Date: Thu, 21 Jan 2021 12:08:15 +0000
> > Subject: [PATCH] KVM: Forbid the use of tagged userspace addresses for
> >  memslots
> > 
> > The use of a tagged address could be pretty confusing for the
> > whole memslot infrastructure as well as the MMU notifiers.
> > 
> > Forbid it altogether, as it never quite worked the first place.
> > 
> > Cc: stable@vger.kernel.org
> > Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > 
> > diff --git a/Documentation/virt/kvm/api.rst
> > b/Documentation/virt/kvm/api.rst
> > index 4e5316ed10e9..c347b7083abf 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -1269,6 +1269,9 @@ field userspace_addr, which must point at user
> > addressable memory for
> >  the entire memory slot size.  Any object may back this memory,
> > including
> >  anonymous memory, ordinary files, and hugetlbfs.
> > 
> > +On architectures that support a form of address tagging, userspace_addr
> > must
> > +be an untagged address.
> > +
> >  It is recommended that the lower 21 bits of guest_phys_addr and
> > userspace_addr
> >  be identical.  This allows large pages in the guest to be backed by
> > large
> >  pages in the host.
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 2541a17ff1c4..a9abaf5f8e53 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1290,6 +1290,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >  		return -EINVAL;
> >  	/* We can read the guest memory with __xxx_user() later on. */
> >  	if ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
> > +	    (mem->userspace_addr != untagged_addr(mem->userspace_addr)) ||
> >  	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
> >  			mem->memory_size))
> >  		return -EINVAL;
> 
> I'll post a revised patch for 5.4. No need to go beyond that as that's
> the point where we allowed tagged addresses at the syscall boundary.

Great, thanks, I didn't know how far back to take it :)
