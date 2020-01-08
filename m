Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D39E13409F
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 12:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgAHLhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 06:37:23 -0500
Received: from foss.arm.com ([217.140.110.172]:43024 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727205AbgAHLhW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 06:37:22 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4765D31B;
        Wed,  8 Jan 2020 03:37:22 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D005F3F703;
        Wed,  8 Jan 2020 03:37:20 -0800 (PST)
Date:   Wed, 8 Jan 2020 11:37:18 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        maz@kernel.org, Drew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: arm/arm64: correct CPSR on exception entry
Message-ID: <20200108113718.GC49203@lakrids.cambridge.arm.com>
References: <20191220150549.31948-1-mark.rutland@arm.com>
 <20191220150549.31948-3-mark.rutland@arm.com>
 <775a6053-ad90-bf2f-43f0-11f71d34f4a1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <775a6053-ad90-bf2f-43f0-11f71d34f4a1@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 27, 2019 at 03:42:34PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On 12/20/19 3:05 PM, Mark Rutland wrote:
> > When KVM injects an exception into a guest, it generates the CPSR value
> > from scratch, configuring CPSR.{M,A,I,T,E}, and setting all other
> > bits to zero.
> >
> > This isn't correct, as the architecture specifies that some CPSR bits
> > are (conditionally) cleared or set upon an exception, and others are
> > unchanged from the original context.
> >
> > This patch adds logic to match the architectural behaviour. To make this
> > simple to follow/audit/extend, documentation references are provided,
> > and bits are configured in order of their layout in SPSR_EL2. This
> 
> This patch applies equally well to 32bit KVM, where we have a SPSR register.

Indeed. The above wasn't intended to imply otherwise, but I'll add the
following to make that clear:

| Note that this code is used by both arm and arm64, and is intended to
| fuction with the SPSR_EL2 and SPSR_hyp layouts.

[...]

> >  /* arm64 compatibility macros */
> > +#define PSR_AA32_MODE_FIQ	FIQ_MODE
> > +#define PSR_AA32_MODE_SVC	SVC_MODE
> >  #define PSR_AA32_MODE_ABT	ABT_MODE
> >  #define PSR_AA32_MODE_UND	UND_MODE
> >  #define PSR_AA32_T_BIT		PSR_T_BIT
> > +#define PSR_AA32_F_BIT		PSR_F_BIT
> >  #define PSR_AA32_I_BIT		PSR_I_BIT
> >  #define PSR_AA32_A_BIT		PSR_A_BIT
> >  #define PSR_AA32_E_BIT		PSR_E_BIT
> >  #define PSR_AA32_IT_MASK	PSR_IT_MASK
> > +#define PSR_AA32_GE_MASK	0x000f0000
> > +#define PSR_AA32_PAN_BIT	0x00400000
> > +#define PSR_AA32_SSBS_BIT	0x00800000
> > +#define PSR_AA32_DIT_BIT	0x01000000
> 
> This is actually PSR_J_BIT on arm. Maybe it's worth defining it like that to
> make the overlap obvious.

Another bug! These are intended to match the SPSR_hyp view, where DIT is
bit 21, and so this should be:

#define PSR_AA32_DIT_BIT	0x0x00200000

... placed immediately before the PAN bit.

We don't need a macro for the J bit as it was obsoleted and made RES0 by
the ARMv7 virtualization extensions.

[...]

> > +	// CPSR.PAN is unchanged unless overridden by SCTLR.SPAN
> > +	// See ARM DDI 0487E.a, page G8-6246
> > +	new |= (old & PSR_AA32_PAN_BIT);
> > +	if (sctlr & BIT(23))
> > +		new |= PSR_AA32_PAN_BIT;
> 
> PSTATE.PAN is unconditionally set when SCTLR.SPAN is clear.

Indeed, and this time the reference is explicit about that. :/

I've updated this to:

|	// CPSR.PAN is unchanged unless SCTLR.SPAN == 0b0
|	// SCTLR.SPAN is RES1 when ARMv8.1-PAN is not implemented
|	// See ARM DDI 0487E.a, page G8-6246
|	new |= (old & PSR_AA32_PAN_BIT);
|	if (!(sctlr & BIT(23)))
|		new |= PSR_AA32_PAN_BIT;

[...]

> I've also checked that the ARM documentation references match the code.

Thanks, your review is much appreciated!

Mark.
