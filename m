Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7EF2A6929
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 17:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgKDQLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 11:11:49 -0500
Received: from foss.arm.com ([217.140.110.172]:39538 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728683AbgKDQLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 11:11:49 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F0BB139F;
        Wed,  4 Nov 2020 08:11:48 -0800 (PST)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A41E03F718;
        Wed,  4 Nov 2020 08:11:47 -0800 (PST)
Date:   Wed, 4 Nov 2020 16:11:44 +0000
From:   Dave Martin <Dave.Martin@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     maz@kernel.org, xu910121@sina.com, kvmarm@lists.cs.columbia.edu,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] KVM: arm64: Don't hide ID registers from userspace
Message-ID: <20201104161142.GA6882@arm.com>
References: <20201102185037.49248-1-drjones@redhat.com>
 <20201102185037.49248-2-drjones@redhat.com>
 <20201103111816.GG6882@arm.com>
 <20201103133215.rfgjcv6fvh4rgzdg@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201103133215.rfgjcv6fvh4rgzdg@kamzik.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 02:32:15PM +0100, Andrew Jones wrote:
> On Tue, Nov 03, 2020 at 11:18:19AM +0000, Dave Martin wrote:
> > On Mon, Nov 02, 2020 at 07:50:35PM +0100, Andrew Jones wrote:
> > > ID registers are RAZ until they've been allocated a purpose, but
> > > that doesn't mean they should be removed from the KVM_GET_REG_LIST
> > > list. So far we only have one register, SYS_ID_AA64ZFR0_EL1, that
> > > is hidden from userspace when its function is not present. Removing
> > > the userspace visibility checks is enough to reexpose it, as it
> > > already behaves as RAZ when the function is not present.
> > 
> > Pleae state what the patch does.  (The subject line serves as a summary
> > of that, but the commit message should make sense without it.)
> 
> I don't like "This patch ..." type of sentences in the commit message,
> but unless you have a better suggestion, then I'd just add a sentence
> like
> 
> "This patch ensures we still expose sysreg '3, 0, 0, 4, 4'
> (ID_AA64ZFR0_EL1) to userspace as RAZ when SVE is not implemented."

I'm not sure the sysreg encoding number is really needed.
submitting-patches.rst also says such statements should be in the
imperative.  Why not delete the "Removing the userspace visibility
checks..." sentence above and writing:

	Expose ID_AA64ZFR0_EL1 to userspace as RAZ when SVE is not
	implemented.

	Removing the userspace visibility checks is enough to reexpose it,
	as it already behaves as RAZ for the guest when SVE is not present.

(The background to this gripe is that "traditional" mailers may invoke a
standalone editor on the message body when composing reply, so the
subject line may not be visible...)

> 
> > 
> > Also, how exactly !vcpu_has_sve() causes ID_AA64ZFR0_EL1 to behave as
> > RAZ with this change?  (I'm not saying it doesn't, but the code is not
> > trivial to follow...)
> 
> guest_id_aa64zfr0_el1() returns zero for the register when !vcpu_has_sve(),
> and all the accessors (userspace and guest) build on it.
> 
> I'm not sure how helpful it would be to add that sentence to the commit
> message though.

No worries, I don't think you need to add anthing.  I figured out how
this works after my previously reply, so you can put my question down to
me being slow on the uptake...

> 
> > 
> > > 
> > > Fixes: 73433762fcae ("KVM: arm64/sve: System register context switch and access support")
> > > Cc: <stable@vger.kernel.org> # v5.2+
> > > Reported-by: 张东旭 <xu910121@sina.com>
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > ---
> > >  arch/arm64/kvm/sys_regs.c | 18 +-----------------
> > >  1 file changed, 1 insertion(+), 17 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index fb12d3ef423a..6ff0c15531ca 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -1195,16 +1195,6 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
> > >  	return REG_HIDDEN_USER | REG_HIDDEN_GUEST;
> > >  }
> > >  
> > > -/* Visibility overrides for SVE-specific ID registers */
> > > -static unsigned int sve_id_visibility(const struct kvm_vcpu *vcpu,
> > > -				      const struct sys_reg_desc *rd)
> > > -{
> > > -	if (vcpu_has_sve(vcpu))
> > > -		return 0;
> > > -
> > > -	return REG_HIDDEN_USER;
> > 
> > In light of this change, I think that REG_HIDDEN_GUEST and
> > REG_HIDDEN_USER are always either both set or both clear.  Given the
> > discussion on this issue, I'm thinking it probably doesn't even make
> > sense for these to be independent (?)
> > 
> > If REG_HIDDEN_USER is really redundant, I suggest stripping it out and
> > simplifying the code appropriately.
> > 
> > (In effect, I think your RAZ flag will do correctly what REG_HIDDEN_USER
> > was trying to achieve.)
> 
> We could consolidate REG_HIDDEN_GUEST and REG_HIDDEN_USER into REG_HIDDEN,
> which ZCR_EL1 and ptrauth registers will still use.

Sounds good to me.  Getting rid of _both_ the old names well help avoid
accidents too.

[...]

Cheers
---Dave
