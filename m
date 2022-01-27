Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E476649E66F
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237747AbiA0Pn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234341AbiA0Pn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:43:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80B3C061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:43:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3587B80184
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 15:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F089DC340E4;
        Thu, 27 Jan 2022 15:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643298233;
        bh=YtXdrC+uB2Ls8vG7cSTcvucedWbX7juLY4/SfKftYbM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wk6Trv7t03VXlkg+hTCCYO2kEM77PseUD5YepI9084bS3dDSnF/Nx7XtWETtxe6dA
         2p+UeSAszfJ5QMofmmEKJC9sAkw381gsH14sriGoEUbIsal2kYM/4q9cGFO6NkH2qY
         miB79wMypuKpHABj0tUBklmZFNZcJv97Jtnd0gAE=
Date:   Thu, 27 Jan 2022 16:43:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>, stable@vger.kernel.org,
        seanjc@google.com
Subject: Re: [PATCH 5.10] KVM: x86/mmu: Fix write-protection of PTs mapped by
 the TDP MMU
Message-ID: <YfK9tmSu0kj4qtWx@kroah.com>
References: <20220124183302.263017-1-dmatlack@google.com>
 <51961d32-f45f-15d4-b21f-3ed75465c5da@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51961d32-f45f-15d4-b21f-3ed75465c5da@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 07:34:13PM +0100, Paolo Bonzini wrote:
> On 1/24/22 19:33, David Matlack wrote:
> > commit 7c8a4742c4abe205ec9daf416c9d42fd6b406e8e upstream.
> > 
> > When the TDP MMU is write-protection GFNs for page table protection (as
> > opposed to for dirty logging, or due to the HVA not being writable), it
> > checks if the SPTE is already write-protected and if so skips modifying
> > the SPTE and the TLB flush.
> > 
> > This behavior is incorrect because it fails to check if the SPTE
> > is write-protected for page table protection, i.e. fails to check
> > that MMU-writable is '0'.  If the SPTE was write-protected for dirty
> > logging but not page table protection, the SPTE could locklessly be made
> > writable, and vCPUs could still be running with writable mappings cached
> > in their TLB.
> > 
> > Fix this by only skipping setting the SPTE if the SPTE is already
> > write-protected *and* MMU-writable is already clear.  Technically,
> > checking only MMU-writable would suffice; a SPTE cannot be writable
> > without MMU-writable being set.  But check both to be paranoid and
> > because it arguably yields more readable code.
> > 
> > Fixes: 46044f72c382 ("kvm: x86/mmu: Support write protection for nesting in tdp MMU")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > Message-Id: <20220113233020.3986005-2-dmatlack@google.com>
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >   arch/x86/kvm/mmu/tdp_mmu.c | 6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index f2ddf663e72e..7e08efb06839 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1130,12 +1130,12 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
> >   	bool spte_set = false;
> >   	tdp_root_for_each_leaf_pte(iter, root, gfn, gfn + 1) {
> > -		if (!is_writable_pte(iter.old_spte))
> > -			break;
> > -
> >   		new_spte = iter.old_spte &
> >   			~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
> > +		if (new_spte == iter.old_spte)
> > +			break;
> > +
> >   		tdp_mmu_set_spte(kvm, &iter, new_spte);
> >   		spte_set = true;
> >   	}
> > 
> > base-commit: fd187a4925578f8743d4f266c821c7544d3cddae
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> 

Now queued up, thanks.

greg k-h
