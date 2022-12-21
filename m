Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC12653456
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 17:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbiLUQuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 11:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiLUQui (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 11:50:38 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EDA24BD6;
        Wed, 21 Dec 2022 08:50:36 -0800 (PST)
Date:   Wed, 21 Dec 2022 16:50:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671641435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xdjf8bxiYHpI/EXjIs05wPVvAMrqG6J7dZ0Cm96qYYk=;
        b=qxoDmMVkSPwg3Qz24+AUYA0y6lpWSkYf2PUOZNWsPkHLlkZmsiNsyWI3G8/uHbGwAMUeUA
        JQf9aZ5PKPis0vEWtlTS1mvtDL3/dB8Hvl3yvja4684hiQ4Ws8MJp3lzApIvYoozbbHiux
        QIczvU9G9oZOR1c6d/2ickYaol8Yw5A=
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
Message-ID: <Y6M5Vh+EGOhkR5hd@google.com>
References: <20221220200923.1532710-1-maz@kernel.org>
 <20221220200923.1532710-2-maz@kernel.org>
 <Y6IteDoK406o9pM+@google.com>
 <86pmcdaylx.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86pmcdaylx.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 09:35:06AM +0000, Marc Zyngier wrote:

[...]

> > > +	if (kvm_vcpu_abt_iss1tw(vcpu)) {
> > > +		/*
> > > +		 * Only a permission fault on a S1PTW should be
> > > +		 * considered as a write. Otherwise, page tables baked
> > > +		 * in a read-only memslot will result in an exception
> > > +		 * being delivered in the guest.
> > 
> > Somewhat of a tangent, but:
> > 
> > Aren't we somewhat unaligned with the KVM UAPI by injecting an
> > exception in this case? I know we've been doing it for a while, but it
> > flies in the face of the rules outlined in the
> > KVM_SET_USER_MEMORY_REGION documentation.
> 
> That's an interesting point, and I certainly haven't considered that
> for faults introduced by page table walks.
> 
> I'm not sure what userspace can do with that though. The problem is
> that this is a write for which we don't have useful data: although we
> know it is a page-table walker access, we don't know what it was about
> to write. The instruction that caused the write is meaningless (it
> could either be a load, a store, or an instruction fetch). How do you
> populate the data[] field then?
> 
> If anything, this is closer to KVM_EXIT_ARM_NISV, for which we give
> userspace the full ESR and ask it to sort it out. I doubt it will be
> able to, but hey, maybe it is worth a shot. This would need to be a
> different exit reason though, as NISV is explicitly for non-memslot
> stuff.
> 
> In any case, the documentation for KVM_SET_USER_MEMORY_REGION needs to
> reflect the fact that KVM_EXIT_MMIO cannot represent a fault due to a
> S1 PTW.

Oh I completely agree with you here. I probably should have said before,
I think the exit would be useless anyway. Getting the documentation in
line with the intended behavior seems to be the best fix.

> >
> > > +		 * The drawback is that we end-up fauling twice if the
> > 
> > typo: s/fauling/faulting/
> > 
> > > +		 * guest is using any of HW AF/DB: a translation fault
> > > +		 * to map the page containing the PT (read only at
> > > +		 * first), then a permission fault to allow the flags
> > > +		 * to be set.
> > > +		 */
> > > +		switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
> > > +		case ESR_ELx_FSC_PERM:
> > > +			return true;
> > > +		default:
> > > +			return false;
> > > +		}
> > > +	}
> > >  
> > >  	if (kvm_vcpu_trap_is_iabt(vcpu))
> > >  		return false;
> > > -- 
> > > 2.34.1
> > > 
> > 
> > Besides the changelog/comment suggestions, the patch looks good to me.
> > 
> > Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> 
> Thanks for the quick review! I'll wait a bit before respinning the
> series, as I'd like to get closure on the UAPI point you have raised.

I'm satisfied if you are :)

--
Thanks,
Oliver
