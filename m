Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE10330A922
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 14:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhBANzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 08:55:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhBANzw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 08:55:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0C9B64D9D;
        Mon,  1 Feb 2021 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612187711;
        bh=dmMa6igSrfr8Kqr11tNDaLEvYhkM+qbuD/1gq1a+Pp8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d9OMeoSn54heoMcY93O8Sy1eY721FH6QtFz00ZXp8ZGiMQMkGCDPYcmWheefS5PI6
         3jqsL16flnObQNxUGRQ8ox/U0Q6bamMm9xcMqtcEPCan52yhV4bbAWWVI0DWM/q2J8
         DVVuk0GCVkslZKKb7uCZ97lTb0xv/44ZES64p5QU=
Date:   Mon, 1 Feb 2021 14:55:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        kvm@vger.kernel.org, Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [stable-5.4][PATCH] KVM: Forbid the use of tagged userspace
 addresses for memslots
Message-ID: <YBgIPLYuf3P4lqB3@kroah.com>
References: <20210201133137.3541896-1-maz@kernel.org>
 <b08e3ccf-9a69-819a-8632-46c82dade2fa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b08e3ccf-9a69-819a-8632-46c82dade2fa@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 01, 2021 at 02:38:05PM +0100, Paolo Bonzini wrote:
> On 01/02/21 14:31, Marc Zyngier wrote:
> > commit 139bc8a6146d92822c866cf2fd410159c56b3648 upstream.
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
> > ---
> >   Documentation/virt/kvm/api.txt | 3 +++
> >   virt/kvm/kvm_main.c            | 1 +
> >   2 files changed, 4 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> > index a18e996fa54b..7064efd3b5ea 100644
> > --- a/Documentation/virt/kvm/api.txt
> > +++ b/Documentation/virt/kvm/api.txt
> > @@ -1132,6 +1132,9 @@ field userspace_addr, which must point at user addressable memory for
> >   the entire memory slot size.  Any object may back this memory, including
> >   anonymous memory, ordinary files, and hugetlbfs.
> > +On architectures that support a form of address tagging, userspace_addr must
> > +be an untagged address.
> > +
> >   It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
> >   be identical.  This allows large pages in the guest to be backed by large
> >   pages in the host.
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 8f3b40ec02b7..f25b5043cbca 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1017,6 +1017,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >   	/* We can read the guest memory with __xxx_user() later on. */
> >   	if ((id < KVM_USER_MEM_SLOTS) &&
> >   	    ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
> > +	     (mem->userspace_addr != untagged_addr(mem->userspace_addr)) ||
> >   	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
> >   			mem->memory_size)))
> >   		goto out;
> > 
> 
> Indeed untagged_addr was added in 5.3.
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Now queued up, thanks.

greg k-h
