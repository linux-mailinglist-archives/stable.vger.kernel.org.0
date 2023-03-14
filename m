Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A261E6B9C47
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 17:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjCNQyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 12:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjCNQyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 12:54:38 -0400
X-Greylist: delayed 463 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Mar 2023 09:54:35 PDT
Received: from out-61.mta1.migadu.com (out-61.mta1.migadu.com [95.215.58.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884CCAA706
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 09:54:35 -0700 (PDT)
Date:   Tue, 14 Mar 2023 16:46:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678812408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nN1ruB34XKN2TR/Mn59lswl8p+LnmEyQ6lSmXWeTg3Q=;
        b=IK8ERWcubM7JPuKHvLUU8t8Z67f4skdhEmwArcgkWz7czAvnr/DfWUugtjqrQPrGEge1G6
        zXxXVyKVRGA1odVn4BQr1SK8tk5rHkuEZKm9J/66hZIHQaOENalltl/Om67AODEGrQxS9i
        OqhZJIFEBth0z/aKFTjdsuB534cwT4E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: arm64: Retry fault if vma_lookup() results become
 invalid
Message-ID: <ZBCk8/EPWhRgmP4j@linux.dev>
References: <20230313235454.2964067-1-dmatlack@google.com>
 <86fsa7xpjp.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86fsa7xpjp.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 14, 2023 at 04:31:38PM +0000, Marc Zyngier wrote:
> [Dropping Christoffer's 11 year obsolete address...]
> 
> On Mon, 13 Mar 2023 23:54:54 +0000,
> David Matlack <dmatlack@google.com> wrote:
> > 
> > Read mmu_invalidate_seq before dropping the mmap_lock so that KVM can
> > detect if the results of vma_lookup() (e.g. vma_shift) become stale
> > before it acquires kvm->mmu_lock. This fixes a theoretical bug where a
> > VMA could be changed by userspace after vma_lookup() and before KVM
> > reads the mmu_invalidate_seq, causing KVM to install page table entries
> > based on a (possibly) no-longer-valid vma_shift.
> > 
> > Re-order the MMU cache top-up to earlier in user_mem_abort() so that it
> > is not done after KVM has read mmu_invalidate_seq (i.e. so as to avoid
> > inducing spurious fault retries).
> > 
> > This bug has existed since KVM/ARM's inception. It's unlikely that any
> > sane userspace currently modifies VMAs in such a way as to trigger this
> > race. And even with directed testing I was unable to reproduce it. But a
> > sufficiently motivated host userspace might be able to exploit this
> > race.
> > 
> > Fixes: 94f8e6418d39 ("KVM: ARM: Handle guest faults in KVM")
> 
> Ah, good luck with that one! :D user_mem_abort() used to be so nice
> and simple at the time! And yet...
> 
> > Cc: stable@vger.kernel.org
> > Reported-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> 
> Oliver, how do you want to deal with this one? queue it right now? Or
> wait until the dust settles on my two other patches?
> 
> I don't mind either way, I can either take it as part of the same
> series, or rebase my stuff on it.

I'll go ahead and grab it if you want to base your series on top of
this, thanks both of you!

-- 
Thanks,
Oliver
