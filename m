Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC102133FFD
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 12:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgAHLNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 06:13:02 -0500
Received: from foss.arm.com ([217.140.110.172]:42490 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgAHLNB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 06:13:01 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15B3630E;
        Wed,  8 Jan 2020 03:13:01 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9ECDF3F703;
        Wed,  8 Jan 2020 03:12:59 -0800 (PST)
Date:   Wed, 8 Jan 2020 11:12:53 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        maz@kernel.org, Drew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: correct PSTATE on exception entry
Message-ID: <20200108111253.GA49203@lakrids.cambridge.arm.com>
References: <20191220150549.31948-1-mark.rutland@arm.com>
 <20191220150549.31948-2-mark.rutland@arm.com>
 <bace4197-a723-5312-3990-84232aab30d9@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bace4197-a723-5312-3990-84232aab30d9@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Alex,

On Fri, Dec 27, 2019 at 01:01:57PM +0000, Alexandru Elisei wrote:
> On 12/20/19 3:05 PM, Mark Rutland wrote:
> > When KVM injects an exception into a guest, it generates the PSTATE
> > value from scratch, configuring PSTATE.{M[4:0],DAIF}, and setting all
> > other bits to zero.
> >
> > This isn't correct, as the architecture specifies that some PSTATE bits
> > are (conditionally) cleared or set upon an exception, and others are
> > unchanged from the original context.
> >
> > This patch adds logic to match the architectural behaviour. To make this
> > simple to follow/audit/extend, documentation references are provided,
> > and bits are configured in order of their layout in SPSR_EL2. This
> > layout can be seen in the diagram on ARM DDI 0487E.a page C5-429.

> > +/*
> > + * When an exception is taken, most PSTATE fields are left unchanged in the
> > + * handler. However, some are explicitly overridden (e.g. M[4:0]). Luckily all
> > + * of the inherited bits have the same position in the AArch64/AArch32 SPSR_ELx
> > + * layouts, so we don't need to shuffle these for exceptions from AArch32 EL0.
> > + *
> > + * For the SPSR_ELx layout for AArch64, see ARM DDI 0487E.a page C5-429.
> > + * For the SPSR_ELx layout for AArch32, see ARM DDI 0487E.a page C5-426.
> 
> The commit message mentions only the SPSR_ELx layout for AArch64.

That was intentional; there I was only providing rationale for how to
review the patch...

> > + * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
> > + * MSB to LSB.

... as also commented here.

I can drop the reference from the commit message, if that's confusing?

> > + */
> > +static unsigned long get_except64_pstate(struct kvm_vcpu *vcpu)
> > +{
> > +	unsigned long sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> > +	unsigned long old, new;
> > +
> > +	old = *vcpu_cpsr(vcpu);
> > +	new = 0;
> > +
> > +	new |= (old & PSR_N_BIT);
> > +	new |= (old & PSR_Z_BIT);
> > +	new |= (old & PSR_C_BIT);
> > +	new |= (old & PSR_V_BIT);
> > +
> > +	// TODO: TCO (if/when ARMv8.5-MemTag is exposed to guests)
> > +
> > +	new |= (old & PSR_DIT_BIT);
> > +
> > +	// PSTATE.UAO is set to zero upon any exception to AArch64
> > +	// See ARM DDI 0487E.a, page D5-2579.
> > +
> > +	// PSTATE.PAN is unchanged unless overridden by SCTLR_ELx.SPAN
> > +	// See ARM DDI 0487E.a, page D5-2578.
> > +	new |= (old & PSR_PAN_BIT);
> > +	if (sctlr & SCTLR_EL1_SPAN)
> > +		new |= PSR_PAN_BIT;
> 
> On page D13-3264, it is stated that the PAN bit is set unconditionally if
> SCTLR_EL1.SPAN is clear, not set.

very good spot, and that's a much better reference. 

I had mistakenly assumed SPAN took effect when 0b1, since it wasn't
called nSPAN, and page D5-2578 doesn't mention the polarity of the bit:

| When ARMv8.1-PAN is implemented, the SCTLR_EL1.SPAN and SCTLR_EL2.SPAN
| bits are used to control whether the PAN bit is set on an exception to
| EL1 or EL2. 

I've updated this to be:

|	// PSTATE.PAN is unchanged unless SCTLR_ELx.SPAN == 0b0
|	// SCTLR_ELx.SPAN is RES1 when ARMv8.1-PAN is not implemented
|	// See ARM DDI 0487E.a, page D13-3264.
|	new |= (old & PSR_PAN_BIT);
|	if (!(sctlr & SCTLR_EL1_SPAN))
|		new |= PSR_PAN_BIT;

[...]

> I've also checked the ARM ARM pages mentioned in the comments, and the
> references are correct. The SPSR_EL2 layouts for exceptions taken from AArch64,
> respectively AArch32, states are compatible with the way we create the SPSR_EL2
> that will be used for eret'ing to the guest, just like the comment says.

Thanks for confirming this!
 
> I have a suggestion. I think that in ARM ARM, shuffling things between sections
> happens a lot less often than adding/removing things from one particular
> section, so the pages referenced are more likely to change in later versions.
> How about referencing the section instead of the exact page? Something like:
> "This layout can be seen in the diagram on ARM DDI 0487E.a, section C5.2.18,
> when an exception is taken from AArch64 state"?

I did something like that initially, but the comments got very verbose,
and so I moved to doc + page/section numbers alone.

The section numbers and headings also vary between revisions of the ARM
ARM, so I'd prefer to leave this as-is for now. I think it's always
going to be necessary to look at the referenced version of the ARM ARM
(in addition to a subsequent revision when updating things).

Thanks,
Mark
