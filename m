Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E470652882
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 22:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiLTVrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 16:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLTVro (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 16:47:44 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF15D9FF8;
        Tue, 20 Dec 2022 13:47:42 -0800 (PST)
Date:   Tue, 20 Dec 2022 21:47:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671572860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F8vncucEWH39FBSuf1NnVt7IbuX950skFxSPVBgF758=;
        b=g7sDNrmjEw882WLwugZWhzOWLajcNfdZ0lKszT3hSDuIUqvwr+CC6J7FqCCuCOHC4zMZVa
        I/s6HIIH6YmrnM7/vu3hxItl0kNkKG6CbGjPm3+oJc9qpklSXt20AgBgIiQ632xJj2atIK
        aHZZAGEdLNVqwNxB2TgmZVTxv762ydI=
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
Message-ID: <Y6IteDoK406o9pM+@google.com>
References: <20221220200923.1532710-1-maz@kernel.org>
 <20221220200923.1532710-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220200923.1532710-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On Tue, Dec 20, 2022 at 08:09:21PM +0000, Marc Zyngier wrote:
> A recent development on the EFI front has resulted in guests having
> their page tables baked in the firmware binary, and mapped into
> the IPA space as part as a read-only memslot.

as part of a

> Not only this is legitimate, but it also results in added security,
> so thumbs up. However, this clashes mildly with our handling of a S1PTW
> as a write to correctly handle AF/DB updates to the S1 PTs, and results
> in the guest taking an abort it won't recover from (the PTs mapping the
> vectors will suffer freom the same problem...).

To be clear, the read-only page tables already have the AF set, right?
They certainly must, or else the guest isn't getting far :)

I understand you're trying to describe _why_ we promote S1PTW to
a write, but doing it inline with the context of the EFI issue makes it
slightly unclear. Could you break these ideas up into two paragraphs and
maybe spell out the fault conditions a bit more?

  A recent development on the EFI front has resulted in guests having
  their page tables baked in the firmware binary, and mapped into the
  IPA space as part of a read-only memslot. Not only is this legitimate,
  but it also results in added security, so thumbs up.

  It is possible to take an S1PTW translation fault if the S1 PTs are
  unmapped at stage-2. However, KVM unconditionally treats S1PTW as a
  write to correctly handle hardware AF/DB updates to the S1 PTs.
  Furthermore, KVM injects a data abort into the guest for S1PTW writes.
  In the aforementioned case this results in the guest taking an abort
  it won't recover from, as the S1 PTs mapping the vectors suffer from
  the same problem.

Dunno, maybe I stink at reading which is why I got confused in the first
place.

> So clearly our handling is... wrong.
> 
> Instead, switch to a two-pronged approach:
> 
> - On S1PTW translation fault, handle the fault as a read
> 
> - On S1PTW permission fault, handle the fault as a write
> 
> This is of no consequence to SW that *writes* to its PTs (the write
> will trigger a non-S1PTW fault), and SW that uses RO PTs will not
> use AF/DB anyway, as that'd be wrong.
> 
> Only in the case described in c4ad98e4b72c ("KVM: arm64: Assume write
> fault on S1PTW permission fault on instruction fetch") do we end-up
> with two back-to-back faults (page being evicted and faulted back).
> I don't think this is a case worth optimising for.
> 
> Fixes: c4ad98e4b72c ("KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 9bdba47f7e14..fd6ad8b21f85 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -373,8 +373,26 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
>  
>  static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_vcpu_abt_iss1tw(vcpu))
> -		return true;
> +	if (kvm_vcpu_abt_iss1tw(vcpu)) {
> +		/*
> +		 * Only a permission fault on a S1PTW should be
> +		 * considered as a write. Otherwise, page tables baked
> +		 * in a read-only memslot will result in an exception
> +		 * being delivered in the guest.

Somewhat of a tangent, but:

Aren't we somewhat unaligned with the KVM UAPI by injecting an
exception in this case? I know we've been doing it for a while, but it
flies in the face of the rules outlined in the
KVM_SET_USER_MEMORY_REGION documentation.

> +		 * The drawback is that we end-up fauling twice if the

typo: s/fauling/faulting/

> +		 * guest is using any of HW AF/DB: a translation fault
> +		 * to map the page containing the PT (read only at
> +		 * first), then a permission fault to allow the flags
> +		 * to be set.
> +		 */
> +		switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
> +		case ESR_ELx_FSC_PERM:
> +			return true;
> +		default:
> +			return false;
> +		}
> +	}
>  
>  	if (kvm_vcpu_trap_is_iabt(vcpu))
>  		return false;
> -- 
> 2.34.1
> 

Besides the changelog/comment suggestions, the patch looks good to me.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
