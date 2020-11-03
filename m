Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4E12A43E1
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 12:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgKCLSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 06:18:24 -0500
Received: from foss.arm.com ([217.140.110.172]:46920 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgKCLSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 06:18:24 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6AB62101E;
        Tue,  3 Nov 2020 03:18:23 -0800 (PST)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FEAE3F66E;
        Tue,  3 Nov 2020 03:18:22 -0800 (PST)
Date:   Tue, 3 Nov 2020 11:18:19 +0000
From:   Dave Martin <Dave.Martin@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, xu910121@sina.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] KVM: arm64: Don't hide ID registers from userspace
Message-ID: <20201103111816.GG6882@arm.com>
References: <20201102185037.49248-1-drjones@redhat.com>
 <20201102185037.49248-2-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201102185037.49248-2-drjones@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 02, 2020 at 07:50:35PM +0100, Andrew Jones wrote:
> ID registers are RAZ until they've been allocated a purpose, but
> that doesn't mean they should be removed from the KVM_GET_REG_LIST
> list. So far we only have one register, SYS_ID_AA64ZFR0_EL1, that
> is hidden from userspace when its function is not present. Removing
> the userspace visibility checks is enough to reexpose it, as it
> already behaves as RAZ when the function is not present.

Pleae state what the patch does.  (The subject line serves as a summary
of that, but the commit message should make sense without it.)

Also, how exactly !vcpu_has_sve() causes ID_AA64ZFR0_EL1 to behave as
RAZ with this change?  (I'm not saying it doesn't, but the code is not
trivial to follow...)

> 
> Fixes: 73433762fcae ("KVM: arm64/sve: System register context switch and access support")
> Cc: <stable@vger.kernel.org> # v5.2+
> Reported-by: 张东旭 <xu910121@sina.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 18 +-----------------
>  1 file changed, 1 insertion(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index fb12d3ef423a..6ff0c15531ca 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1195,16 +1195,6 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
>  	return REG_HIDDEN_USER | REG_HIDDEN_GUEST;
>  }
>  
> -/* Visibility overrides for SVE-specific ID registers */
> -static unsigned int sve_id_visibility(const struct kvm_vcpu *vcpu,
> -				      const struct sys_reg_desc *rd)
> -{
> -	if (vcpu_has_sve(vcpu))
> -		return 0;
> -
> -	return REG_HIDDEN_USER;

In light of this change, I think that REG_HIDDEN_GUEST and
REG_HIDDEN_USER are always either both set or both clear.  Given the
discussion on this issue, I'm thinking it probably doesn't even make
sense for these to be independent (?)

If REG_HIDDEN_USER is really redundant, I suggest stripping it out and
simplifying the code appropriately.

(In effect, I think your RAZ flag will do correctly what REG_HIDDEN_USER
was trying to achieve.)

> -}
> -
>  /* Generate the emulated ID_AA64ZFR0_EL1 value exposed to the guest */
>  static u64 guest_id_aa64zfr0_el1(const struct kvm_vcpu *vcpu)
>  {
> @@ -1231,9 +1221,6 @@ static int get_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
>  {
>  	u64 val;
>  
> -	if (WARN_ON(!vcpu_has_sve(vcpu)))
> -		return -ENOENT;
> -
>  	val = guest_id_aa64zfr0_el1(vcpu);
>  	return reg_to_user(uaddr, &val, reg->id);
>  }
> @@ -1246,9 +1233,6 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
>  	int err;
>  	u64 val;
>  
> -	if (WARN_ON(!vcpu_has_sve(vcpu)))
> -		return -ENOENT;
> -
>  	err = reg_from_user(&val, uaddr, id);
>  	if (err)
>  		return err;
> @@ -1518,7 +1502,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	ID_SANITISED(ID_AA64PFR1_EL1),
>  	ID_UNALLOCATED(4,2),
>  	ID_UNALLOCATED(4,3),
> -	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, .visibility = sve_id_visibility },
> +	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, },
>  	ID_UNALLOCATED(4,5),
>  	ID_UNALLOCATED(4,6),
>  	ID_UNALLOCATED(4,7),

Otherwise looks reasonable.

Cheers
---Dave
