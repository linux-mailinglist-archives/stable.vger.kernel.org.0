Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F1E2A4698
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 14:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgKCNc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 08:32:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42835 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729398AbgKCNc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 08:32:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604410344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rs0ZCqo1W7PUbdiD3y1cTUQWLQZfVMeq5dfEesPbjL8=;
        b=BFWsy+YhI511MYwP+9BXyrG0evp+9c6UoxiiEGImhp0o8lSSEebYmHSRxKJc8UWcYXAWAj
        mOLruuv2ZtsOYQJ2j+lR9SmnXCEmwxvRQBRnJU6wtQFBVSmmXaoM2ofpta/7p+XX8Hthz4
        q0iVRbwQgcbucjnxpwCyUY7fr4gZLM4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-n45QBk_QNPiXRuCJPecqjg-1; Tue, 03 Nov 2020 08:32:22 -0500
X-MC-Unique: n45QBk_QNPiXRuCJPecqjg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 202FB8058A4;
        Tue,  3 Nov 2020 13:32:20 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D340C5B4A1;
        Tue,  3 Nov 2020 13:32:17 +0000 (UTC)
Date:   Tue, 3 Nov 2020 14:32:15 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Dave Martin <Dave.Martin@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, xu910121@sina.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] KVM: arm64: Don't hide ID registers from userspace
Message-ID: <20201103133215.rfgjcv6fvh4rgzdg@kamzik.brq.redhat.com>
References: <20201102185037.49248-1-drjones@redhat.com>
 <20201102185037.49248-2-drjones@redhat.com>
 <20201103111816.GG6882@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201103111816.GG6882@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 11:18:19AM +0000, Dave Martin wrote:
> On Mon, Nov 02, 2020 at 07:50:35PM +0100, Andrew Jones wrote:
> > ID registers are RAZ until they've been allocated a purpose, but
> > that doesn't mean they should be removed from the KVM_GET_REG_LIST
> > list. So far we only have one register, SYS_ID_AA64ZFR0_EL1, that
> > is hidden from userspace when its function is not present. Removing
> > the userspace visibility checks is enough to reexpose it, as it
> > already behaves as RAZ when the function is not present.
> 
> Pleae state what the patch does.  (The subject line serves as a summary
> of that, but the commit message should make sense without it.)

I don't like "This patch ..." type of sentences in the commit message,
but unless you have a better suggestion, then I'd just add a sentence
like

"This patch ensures we still expose sysreg '3, 0, 0, 4, 4'
(ID_AA64ZFR0_EL1) to userspace as RAZ when SVE is not implemented."

> 
> Also, how exactly !vcpu_has_sve() causes ID_AA64ZFR0_EL1 to behave as
> RAZ with this change?  (I'm not saying it doesn't, but the code is not
> trivial to follow...)

guest_id_aa64zfr0_el1() returns zero for the register when !vcpu_has_sve(),
and all the accessors (userspace and guest) build on it.

I'm not sure how helpful it would be to add that sentence to the commit
message though.

> 
> > 
> > Fixes: 73433762fcae ("KVM: arm64/sve: System register context switch and access support")
> > Cc: <stable@vger.kernel.org> # v5.2+
> > Reported-by: 张东旭 <xu910121@sina.com>
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 18 +-----------------
> >  1 file changed, 1 insertion(+), 17 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index fb12d3ef423a..6ff0c15531ca 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1195,16 +1195,6 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
> >  	return REG_HIDDEN_USER | REG_HIDDEN_GUEST;
> >  }
> >  
> > -/* Visibility overrides for SVE-specific ID registers */
> > -static unsigned int sve_id_visibility(const struct kvm_vcpu *vcpu,
> > -				      const struct sys_reg_desc *rd)
> > -{
> > -	if (vcpu_has_sve(vcpu))
> > -		return 0;
> > -
> > -	return REG_HIDDEN_USER;
> 
> In light of this change, I think that REG_HIDDEN_GUEST and
> REG_HIDDEN_USER are always either both set or both clear.  Given the
> discussion on this issue, I'm thinking it probably doesn't even make
> sense for these to be independent (?)
> 
> If REG_HIDDEN_USER is really redundant, I suggest stripping it out and
> simplifying the code appropriately.
> 
> (In effect, I think your RAZ flag will do correctly what REG_HIDDEN_USER
> was trying to achieve.)

We could consolidate REG_HIDDEN_GUEST and REG_HIDDEN_USER into REG_HIDDEN,
which ZCR_EL1 and ptrauth registers will still use.

> 
> > -}
> > -
> >  /* Generate the emulated ID_AA64ZFR0_EL1 value exposed to the guest */
> >  static u64 guest_id_aa64zfr0_el1(const struct kvm_vcpu *vcpu)
> >  {
> > @@ -1231,9 +1221,6 @@ static int get_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> >  {
> >  	u64 val;
> >  
> > -	if (WARN_ON(!vcpu_has_sve(vcpu)))
> > -		return -ENOENT;
> > -
> >  	val = guest_id_aa64zfr0_el1(vcpu);
> >  	return reg_to_user(uaddr, &val, reg->id);
> >  }
> > @@ -1246,9 +1233,6 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> >  	int err;
> >  	u64 val;
> >  
> > -	if (WARN_ON(!vcpu_has_sve(vcpu)))
> > -		return -ENOENT;
> > -
> >  	err = reg_from_user(&val, uaddr, id);
> >  	if (err)
> >  		return err;
> > @@ -1518,7 +1502,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> >  	ID_SANITISED(ID_AA64PFR1_EL1),
> >  	ID_UNALLOCATED(4,2),
> >  	ID_UNALLOCATED(4,3),
> > -	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, .visibility = sve_id_visibility },
> > +	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, },
> >  	ID_UNALLOCATED(4,5),
> >  	ID_UNALLOCATED(4,6),
> >  	ID_UNALLOCATED(4,7),
> 
> Otherwise looks reasonable.
>

Thanks,
drew

