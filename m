Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0D8653669
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 19:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiLUSet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 13:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiLUSes (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 13:34:48 -0500
X-Greylist: delayed 473 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 21 Dec 2022 10:34:47 PST
Received: from out-143.mta0.migadu.com (out-143.mta0.migadu.com [91.218.175.143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C832655C
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 10:34:47 -0800 (PST)
Date:   Wed, 21 Dec 2022 18:26:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671647212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oCiAxJiKxcSU5UorQx7uMbenKIARcOlfI4FuMp6UPQI=;
        b=XYkz2RtIvG63Ms5qZ0nHvVbllVtrnrqKun6b7hlGxdceeiZSsaJ6GT9MGFJZReWHwcRqtV
        Hj7s/l4rLk+Ahr4+sh5zi7jaq0HCx4nbkWXoWOeGfJMfVraw6WQUGERd2oUWtkIN7jxxJp
        ZY+b0NUaxImbzey19b2CT36oAshvQ04=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: Fix S1PTW handling on RO memslots
Message-ID: <Y6NP54MjCW/doZYS@google.com>
References: <20221220200923.1532710-1-maz@kernel.org>
 <20221220200923.1532710-2-maz@kernel.org>
 <Y6IteDoK406o9pM+@google.com>
 <86pmcdaylx.wl-maz@kernel.org>
 <Y6M5Vh+EGOhkR5hd@google.com>
 <86k02kbq2x.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86k02kbq2x.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 05:53:58PM +0000, Marc Zyngier wrote:
> On Wed, 21 Dec 2022 16:50:30 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Wed, Dec 21, 2022 at 09:35:06AM +0000, Marc Zyngier wrote:
> > 
> > [...]
> > 
> > > > > +	if (kvm_vcpu_abt_iss1tw(vcpu)) {
> > > > > +		/*
> > > > > +		 * Only a permission fault on a S1PTW should be
> > > > > +		 * considered as a write. Otherwise, page tables baked
> > > > > +		 * in a read-only memslot will result in an exception
> > > > > +		 * being delivered in the guest.
> > > > 
> > > > Somewhat of a tangent, but:
> > > > 
> > > > Aren't we somewhat unaligned with the KVM UAPI by injecting an
> > > > exception in this case? I know we've been doing it for a while, but it
> > > > flies in the face of the rules outlined in the
> > > > KVM_SET_USER_MEMORY_REGION documentation.
> > > 
> > > That's an interesting point, and I certainly haven't considered that
> > > for faults introduced by page table walks.
> > > 
> > > I'm not sure what userspace can do with that though. The problem is
> > > that this is a write for which we don't have useful data: although we
> > > know it is a page-table walker access, we don't know what it was about
> > > to write. The instruction that caused the write is meaningless (it
> > > could either be a load, a store, or an instruction fetch). How do you
> > > populate the data[] field then?
> > > 
> > > If anything, this is closer to KVM_EXIT_ARM_NISV, for which we give
> > > userspace the full ESR and ask it to sort it out. I doubt it will be
> > > able to, but hey, maybe it is worth a shot. This would need to be a
> > > different exit reason though, as NISV is explicitly for non-memslot
> > > stuff.
> > > 
> > > In any case, the documentation for KVM_SET_USER_MEMORY_REGION needs to
> > > reflect the fact that KVM_EXIT_MMIO cannot represent a fault due to a
> > > S1 PTW.
> > 
> > Oh I completely agree with you here. I probably should have said before,
> > I think the exit would be useless anyway. Getting the documentation in
> > line with the intended behavior seems to be the best fix.
> 
> Right. How about something like this?

Looks good to me, thanks!

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 226b40baffb8..72abd018a618 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1381,6 +1381,14 @@ It is recommended to use this API instead of the KVM_SET_MEMORY_REGION ioctl.
>  The KVM_SET_MEMORY_REGION does not allow fine grained control over memory
>  allocation and is deprecated.
>  
> +Note: On arm64, a write generated by the page-table walker (to update
> +the Access and Dirty flags, for example) never results in a
> +KVM_EXIT_MMIO exit when the slot has the KVM_MEM_READONLY flag. This
> +is because KVM cannot provide the data that would be written by the
> +page-table walker, making it impossible to emulate the access.
> +Instead, an abort (data abort if the cause of the page-table update
> +was a load or a store, instruction abort if it was an instruction
> +fetch) is injected in the guest.
>  
>  4.36 KVM_SET_TSS_ADDR
>  ---------------------

--
Best,
Oliver
