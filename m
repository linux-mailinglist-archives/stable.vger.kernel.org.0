Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAAA713400E
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 12:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgAHLPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 06:15:41 -0500
Received: from foss.arm.com ([217.140.110.172]:42548 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbgAHLPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 06:15:41 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D05D30E;
        Wed,  8 Jan 2020 03:15:41 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5EDA3F703;
        Wed,  8 Jan 2020 03:15:39 -0800 (PST)
Date:   Wed, 8 Jan 2020 11:15:37 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Drew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: correct PSTATE on exception entry
Message-ID: <20200108111537.GB49203@lakrids.cambridge.arm.com>
References: <20191220150549.31948-1-mark.rutland@arm.com>
 <20191220150549.31948-2-mark.rutland@arm.com>
 <bace4197-a723-5312-3990-84232aab30d9@arm.com>
 <86zhfbgnzf.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zhfbgnzf.wl-maz@kernel.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 03:17:40PM +0000, Marc Zyngier wrote:
> On Fri, 27 Dec 2019 13:01:57 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > On 12/20/19 3:05 PM, Mark Rutland wrote:
> > > +	// PSTATE.PAN is unchanged unless overridden by SCTLR_ELx.SPAN
> > > +	// See ARM DDI 0487E.a, page D5-2578.
> > > +	new |= (old & PSR_PAN_BIT);
> > > +	if (sctlr & SCTLR_EL1_SPAN)
> > > +		new |= PSR_PAN_BIT;
> > 
> > On page D13-3264, it is stated that the PAN bit is set unconditionally if
> > SCTLR_EL1.SPAN is clear, not set.
> 
> Indeed. Given that when ARMv8.1-PAN is not implemented, SCTLR_EL1[23]
> is RES1, it seems surprising to force PAN based on this bit being set.
> 
> I've now dropped this series from my tree until Mark has a chance to
> clarify this.

Sorry for the mess; I'm fixing up the patches now and looking out for
any similar mistakes.

I'll try to have a v2 out by the end of today.

Thanks,
Mark.
