Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAAE296B91
	for <lists+stable@lfdr.de>; Fri, 23 Oct 2020 10:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460888AbgJWI4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 04:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S460803AbgJWI4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Oct 2020 04:56:45 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39D452080C;
        Fri, 23 Oct 2020 08:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603443404;
        bh=4KEVAiPKewQ3ELMKz9lG4c1x1gh3bFJLao1TR0qk730=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FwTQ6lEcv6Zbp4ju5Iondq0OESB31nvnehOUH/zijd0zr/VRE8AcyzPo4sgbqMsra
         C6osYMZwSGY4zmU+As0RVUtJ92tjozzTXS1Tnbc2S9bsEAPxL7nOR5L69pTEsvdnQX
         nHoIHlgVvBtlenzC5062LJy/JYwdz89BpjdzyMjo=
Date:   Fri, 23 Oct 2020 09:56:39 +0100
From:   Will Deacon <will@kernel.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andre Przywara <andre.przywara@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't
 return SMCCC_RET_NOT_REQUIRED
Message-ID: <20201023085638.GB20821@willie-the-truck>
References: <20201022032958.265621-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022032958.265621-1-swboyd@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 21, 2020 at 08:29:58PM -0700, Stephen Boyd wrote:
> According to the SMCCC spec[1](7.5.2 Discovery) the
> ARM_SMCCC_ARCH_WORKAROUND_1 function id only returns 0, 1, and
> SMCCC_RET_NOT_SUPPORTED.
> 
>  0 is "workaround required and safe to call this function"
>  1 is "workaround not required but safe to call this function"
>  SMCCC_RET_NOT_SUPPORTED is "might be vulnerable or might not be, who knows, I give up!"
> 
> SMCCC_RET_NOT_SUPPORTED might as well mean "workaround required, except
> calling this function may not work because it isn't implemented in some
> cases". Wonderful. We map this SMC call to
> 
>  0 is SPECTRE_MITIGATED
>  1 is SPECTRE_UNAFFECTED
>  SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE
> 
> For KVM hypercalls (hvc), we've implemented this function id to return
> SMCCC_RET_NOT_SUPPORTED, 0, and SMCCC_RET_NOT_REQUIRED. One of those
> isn't supposed to be there. Per the code we call
> arm64_get_spectre_v2_state() to figure out what to return for this
> feature discovery call.
> 
>  0 is SPECTRE_MITIGATED
>  SMCCC_RET_NOT_REQUIRED is SPECTRE_UNAFFECTED
>  SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE
> 
> Let's clean this up so that KVM tells the guest this mapping:
> 
>  0 is SPECTRE_MITIGATED
>  1 is SPECTRE_UNAFFECTED
>  SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE
> 
> (Note: Moving SMCCC_RET_NOT_AFFECTED to a header is left out of this
> patch as it would need to move from proton-pack.c which isn't in stable
> trees and the name isn't actually part of the SMCCC spec)

Given that -rc1 is just round the corner, let's pick this up for -rc2 and
stick the #define into asm/spectre.h at the same time. The #define is called
'SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED' to make it clear that it's specific
to the "ARCH_WORKAROUND" bits.

Will
