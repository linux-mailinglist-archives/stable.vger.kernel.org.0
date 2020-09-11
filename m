Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1782662C1
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 18:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgIKP75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 11:59:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgIKP7U (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 11:59:20 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7034021D47;
        Fri, 11 Sep 2020 15:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599839958;
        bh=+HimZcClfEp/hB2NLGhAPb0y7aED313uyvMLU7dfEFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NhPZx6zVsZ2jmLqKh5aSqxuCiqEwbWbGXBGpD007JoczFwGCray0iHPNlPAfzLY6i
         lyEpREPKRv3xhGCfhKUAURVnTlr0f9eCeafHkbjRlcccYtJDUL+2WbF6irqkTzO3bk
         2cZtQ/rU8Zf+4hLJQWsX7i9YkkEVGWRzVI/2x5hk=
Date:   Fri, 11 Sep 2020 16:59:13 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Assume write fault on S1PTW permission fault
 on instruction fetch
Message-ID: <20200911155912.GB20527@willie-the-truck>
References: <20200909210527.1926996-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909210527.1926996-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 09, 2020 at 10:05:27PM +0100, Marc Zyngier wrote:
> KVM currently assumes that an instruction abort can never be a write.
> This is in general true, except when the abort is triggered by
> a S1PTW on instruction fetch that tries to update the S1 page tables
> (to set AF, for example).
> 
> This can happen if the page tables have been paged out and brought
> back in without seeing a direct write to them (they are thus marked
> read only), and the fault handling code will make the PT executable(!)
> instead of writable. The guest gets stuck forever.
> 
> In these conditions, the permission fault must be considered as
> a write so that the Stage-1 update can take place. This is essentially
> the I-side equivalent of the problem fixed by 60e21a0ef54c ("arm64: KVM:
> Take S1 walks into account when determining S2 write faults").
> 
> Update both kvm_is_write_fault() to return true on IABT+S1PTW, as well
> as kvm_vcpu_trap_is_iabt() to return false in the same conditions.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> This could do with some cleanup (kvm_vcpu_dabt_iss1tw has nothing to do
> with data aborts), but I've chosen to keep the patch simple in order to
> ease backporting.
> 
>  arch/arm64/include/asm/kvm_emulate.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index d21676409a24..33d7e16edaa3 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -480,7 +480,8 @@ static __always_inline u8 kvm_vcpu_trap_get_class(const struct kvm_vcpu *vcpu)
>  
>  static inline bool kvm_vcpu_trap_is_iabt(const struct kvm_vcpu *vcpu)
>  {
> -	return kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_IABT_LOW;
> +	return (kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_IABT_LOW &&
> +		!kvm_vcpu_dabt_iss1tw(vcpu));
>  }
>  
>  static __always_inline u8 kvm_vcpu_trap_get_fault(const struct kvm_vcpu *vcpu)
> @@ -520,6 +521,9 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
>  
>  static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
>  {
> +	if (kvm_vcpu_dabt_iss1tw(vcpu))
> +		return true;
> +

Hmm, I'm a bit uneasy about the interaction of this with
kvm_handle_guest_abort() if we take an S1PTW fault on instruction fetch
with our page-tables sitting in a read-only memslot. In this case, I
think we'll end up injecting a data abort into the guest instead of an
instruction abort. It hurts my brain thinking about it though.

Overall, I'd be inclined to:

  1. Rename kvm_vcpu_dabt_iss1tw() to kvm_vcpu_abt_iss1tw()

  2. Introduce something like kvm_is_exec_fault() as:

	return kvm_vcpu_trap_is_iabt() && !kvm_vcpu_abt_iss1tw();

  3. Use that new function in user_mem_abort() to assign 'exec_fault'

  4. Hack kvm_is_write_fault() as you have done above.

Which I _think_ should work (famous last words)...

The only nasty bit is that we then duplicate the kvm_vcpu_dabt_iss1tw()
check in both kvm_is_write_fault() and kvm_vcpu_dabt_iswrite(). Perhaps
we could remove the latter function in favour of the first? Anyway,
obviously this sort of cleanup isn't for stable.

Will
