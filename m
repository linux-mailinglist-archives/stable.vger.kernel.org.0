Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B7F2953EB
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 23:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505842AbgJUVNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 17:13:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505841AbgJUVNe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Oct 2020 17:13:34 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69C0821D24;
        Wed, 21 Oct 2020 21:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603314813;
        bh=BtKiZxDK41Nclw/9t2jRmKjztnbi4BYxCL4GQBmJpk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vPM+cNOTqKbsob17ev4ihDQyFzprwiBMsI1EwcD+zOaYEdm1uLOkrgma179cxNPHw
         z+211X7JQvp8KLPRi4aCJ4zks6VSi0oE0iKZiIF+KX+h52yiMAQaweuyFFRWbkvlVF
         ArCyRfSv6YLxbf12cfQF1QemFkfVVx5wN5EvG9gw=
Date:   Wed, 21 Oct 2020 22:13:26 +0100
From:   Will Deacon <will@kernel.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andre Przywara <andre.przywara@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return
 SMCCC_RET_NOT_REQUIRED
Message-ID: <20201021211326.GA18548@willie-the-truck>
References: <20201020214544.3206838-1-swboyd@chromium.org>
 <20201020214544.3206838-2-swboyd@chromium.org>
 <20201021075722.GA17230@willie-the-truck>
 <160329383454.884498.3396883189907056188@swboyd.mtv.corp.google.com>
 <20201021154909.GD18071@willie-the-truck>
 <160329672229.884498.3370140649393072677@swboyd.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160329672229.884498.3370140649393072677@swboyd.mtv.corp.google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 21, 2020 at 09:12:02AM -0700, Stephen Boyd wrote:
> Quoting Will Deacon (2020-10-21 08:49:09)
> > On Wed, Oct 21, 2020 at 08:23:54AM -0700, Stephen Boyd wrote:
> > > 
> > > If I'm reading the TF-A code correctly it looks like this will return
> > > SMC_UNK if the platform decides that "This flag can be set to 0 by the
> > > platform if none of the PEs in the system need the workaround." Where
> > > the flag is WORKAROUND_CVE_2017_5715 and the call handler returns 1 if
> > > the errata doesn't apply but the config is enabled, 0 if the errata
> > > applies and the config is enabled, or SMC_UNK (I guess this is
> > > NOT_SUPPORTED?) if the config is disabled[2].
> > > 
> > > So TF-A could disable this config and then the kernel would think it is
> > > vulnerable when it actually isn't? The spec is a pile of ectoplasma
> > > here.
> > 
> > Yes, but there's not a lot we can do in that case as we rely on the
> > firmware to tell us whether or not we're affected. We do have the
> > "safelist" as a last resort, but that's about it.
> 
> There are quite a few platforms that set this config to 0. Should they
> be setting it to 1?
> 
>  tf-a $ git grep WORKAROUND_CVE_2017_5715 -- **/platform.mk | wc -l
>  17

A quick skim suggests that most (all?) of these are A53-based, so that's
on the safelist and will be fine.

> This looks like a disconnect between kernel and TF-A but I'm not aware
> of all the details here.

I think it's alright, as it's just a legacy problem (newer cores should
have CSV2 set) and older cores are safelisted.

> > > Does the kernel implement a workaround in the case that no guest PE is
> > > affected? If so then returning 1 sounds OK to me, but otherwise
> > > NOT_SUPPORTED should work per the spec.
> > 
> > I don't follow you here. The spec says that "SMCCC_RET_NOT_SUPPORTED" is
> > valid return code in the case that "The system contains at least 1 PE
> > affected by CVE-2017-5715 that has no firmware mitigation available."
> > and do the guest would end up in the "vulnerable" state.
> > 
> 
> Returning 1 says "SMCCC_ARCH_WORKAROUND_1 can be invoked safely on all
> PEs in the system" so I am not sure that invoking it is from a guest is
> safe on systems that don't require the workaround? If it is always safe
> to invoke the call from guest to host then returning 1 should be fine
> here.

I think it's fine, as KVM will pick that up.

> My read of the spec was that the intent is to remove the call at some
> point and have the removal of the call mean that it isn't vulnerable.

No, the CSV2 field in whichever ID register is for that. We check that in
spectre_v2_get_cpu_hw_mitigation_state().

> Because NOT_SUPPORTED per the spec means "not needed", "maybe needed",
> or "firmware doesn't know". Aha maybe they wanted us to make the call on
> each CPU (i.e. PE) and then if any of them return 0 we should consider
> it vulnerable and if they return NOT_SUPPORTED we should keep calling
> for each CPU until we are sure we don't see a 0 and only see a 1 or
> NOT_SUPPORTED? Looks like a saturating value sort of thing, across CPUs
> that we care/know about.

The mitigation state is always per-cpu because of big/little systems, there
just isn't a short-cut for the firmware to say "all CPUs are unaffected"
like there is for SMCCC_ARCH_WORKAROUND_2 with its "NOT_REQUIRED" return
code.

Will
