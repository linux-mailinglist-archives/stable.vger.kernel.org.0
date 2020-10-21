Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE6629502A
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 17:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436663AbgJUPtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 11:49:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436657AbgJUPtP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Oct 2020 11:49:15 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7324B2177B;
        Wed, 21 Oct 2020 15:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603295355;
        bh=rySyaPMonK0bqxfFaAUtQ7LAHYi4FnVE4UcUlHXiTls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vsk6Suxjr7k7JPvQTveIDd8YChDcEAo8OCCWDFRLcy01l8vZnqCkSi7DFxHBx/CRY
         w1UgbwsC0oL/nU94eID2Hz+iM+hCKRUQtWLF2ELjwM1CwG0MJGAf6iJhXV6nNEj/xK
         qNUFC9UIlm5LN84eQtqZ+DgPb6r1G2xr1VulrV/E=
Date:   Wed, 21 Oct 2020 16:49:09 +0100
From:   Will Deacon <will@kernel.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andre Przywara <andre.przywara@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return
 SMCCC_RET_NOT_REQUIRED
Message-ID: <20201021154909.GD18071@willie-the-truck>
References: <20201020214544.3206838-1-swboyd@chromium.org>
 <20201020214544.3206838-2-swboyd@chromium.org>
 <20201021075722.GA17230@willie-the-truck>
 <160329383454.884498.3396883189907056188@swboyd.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160329383454.884498.3396883189907056188@swboyd.mtv.corp.google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 21, 2020 at 08:23:54AM -0700, Stephen Boyd wrote:
> Quoting Will Deacon (2020-10-21 00:57:23)
> > On Tue, Oct 20, 2020 at 02:45:43PM -0700, Stephen Boyd wrote:
> > > According to the SMCCC spec (7.5.2 Discovery) the
> > > ARM_SMCCC_ARCH_WORKAROUND_1 function id only returns 0, 1, and
> > > SMCCC_RET_NOT_SUPPORTED corresponding to "workaround required",
> > > "workaround not required but implemented", and "who knows, you're on
> > > your own" respectively. For kvm hypercalls (hvc), we've implemented this
> > > function id to return SMCCC_RET_NOT_SUPPORTED, 1, and
> > > SMCCC_RET_NOT_REQUIRED. The SMCCC_RET_NOT_REQUIRED return value is not a
> > > thing for this function id, and is probably copy/pasted from the
> > > SMCCC_ARCH_WORKAROUND_2 function id that does support it.
> > > 
> > > Clean this up by returning 0, 1, and SMCCC_RET_NOT_SUPPORTED
> > > appropriately. Changing this exposes the problem that
> > > spectre_v2_get_cpu_fw_mitigation_state() assumes a
> > > SMCCC_RET_NOT_SUPPORTED return value means we are vulnerable, but really
> > > it means we have no idea and should assume we can't do anything about
> > > mitigation. Put another way, it better be unaffected because it can't be
> > > mitigated in the firmware (in this case kvm) as the call isn't
> > > implemented!
> > > 
> > > Cc: Andre Przywara <andre.przywara@arm.com>
> > > Cc: Steven Price <steven.price@arm.com>
> > > Cc: Marc Zyngier <maz@kernel.org>
> > > Cc: stable@vger.kernel.org
> > > Fixes: c118bbb52743 ("arm64: KVM: Propagate full Spectre v2 workaround state to KVM guests")
> > > Fixes: 73f381660959 ("arm64: Advertise mitigation of Spectre-v2, or lack thereof")
> > > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > > ---
> > > 
> > > This will require a slightly different backport to stable kernels, but
> > > at least it looks like this is a problem given that this return value
> > > isn't valid per the spec and we've been going around it by returning
> > > something invalid for some time.
> > > 
> > >  arch/arm64/kernel/proton-pack.c | 3 +--
> > >  arch/arm64/kvm/hypercalls.c     | 2 +-
> > >  2 files changed, 2 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
> > > index 68b710f1b43f..00bd54f63f4f 100644
> > > --- a/arch/arm64/kernel/proton-pack.c
> > > +++ b/arch/arm64/kernel/proton-pack.c
> > > @@ -149,10 +149,9 @@ static enum mitigation_state spectre_v2_get_cpu_fw_mitigation_state(void)
> > >       case SMCCC_RET_SUCCESS:
> > >               return SPECTRE_MITIGATED;
> > >       case SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED:
> > > +     case SMCCC_RET_NOT_SUPPORTED: /* Good luck w/ the Gatekeeper of Gozer */
> > >               return SPECTRE_UNAFFECTED;
> > 
> > Hmm, I'm not sure this is correct. The SMCCC spec is terrifically
> > unhelpful:
> > 
> >   NOT_SUPPORTED:
> >   Either:
> >   * None of the PEs in the system require firmware mitigation for CVE-2017-5715.
> >   * The system contains at least 1 PE affected by CVE-2017-5715 that has no firmware
> >     mitigation available.
> >   * The firmware does not provide any information about whether firmware mitigation is
> >     required.
> > 
> > so we can't tell whether the thing is vulnerable or not in this case, and
> > have to assume that it is.
> 
> If I'm reading the TF-A code correctly it looks like this will return
> SMC_UNK if the platform decides that "This flag can be set to 0 by the
> platform if none of the PEs in the system need the workaround." Where
> the flag is WORKAROUND_CVE_2017_5715 and the call handler returns 1 if
> the errata doesn't apply but the config is enabled, 0 if the errata
> applies and the config is enabled, or SMC_UNK (I guess this is
> NOT_SUPPORTED?) if the config is disabled[2].
> 
> So TF-A could disable this config and then the kernel would think it is
> vulnerable when it actually isn't? The spec is a pile of ectoplasma
> here.

Yes, but there's not a lot we can do in that case as we rely on the
firmware to tell us whether or not we're affected. We do have the
"safelist" as a last resort, but that's about it.

> > >       default:
> > > -             fallthrough;
> > > -     case SMCCC_RET_NOT_SUPPORTED:
> > >               return SPECTRE_VULNERABLE;
> > >       }
> > >  }
> > > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > > index 9824025ccc5c..868486957808 100644
> > > --- a/arch/arm64/kvm/hypercalls.c
> > > +++ b/arch/arm64/kvm/hypercalls.c
> > > @@ -31,7 +31,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> > >                               val = SMCCC_RET_SUCCESS;
> > >                               break;
> > >                       case SPECTRE_UNAFFECTED:
> > > -                             val = SMCCC_RET_NOT_REQUIRED;
> > > +                             val = SMCCC_RET_NOT_SUPPORTED;
> > 
> > Which means we need to return SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED here, I
> > suppose?
> > 
> 
> Does the kernel implement a workaround in the case that no guest PE is
> affected? If so then returning 1 sounds OK to me, but otherwise
> NOT_SUPPORTED should work per the spec.

I don't follow you here. The spec says that "SMCCC_RET_NOT_SUPPORTED" is
valid return code in the case that "The system contains at least 1 PE
affected by CVE-2017-5715 that has no firmware mitigation available."
and do the guest would end up in the "vulnerable" state.

Will
