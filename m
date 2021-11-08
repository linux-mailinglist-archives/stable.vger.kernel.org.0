Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76586447D49
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 11:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbhKHKKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 05:10:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229966AbhKHKKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 05:10:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0619761075;
        Mon,  8 Nov 2021 10:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636366071;
        bh=yKXTOCidq/NCJEKTpKPeeIYIOZlzk4dULKbJT/WT+g8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bHB4nXzq1qfxPraM22E/jzzKlr/+ZL+rgWDsFkPAnFoKOhUa6AiY20A+fwo0UvlEo
         RcWPrgiywx5b8IUshSs+Jup8sW70mUdlcV5NunetYC3pKCFNAQx0xZeXcp+yUPhOdN
         eUrJibXSOaosFZH2QeYcNS+e4XWpXRdovvLEs86sT/mLEpHc7J1t/SlpB6fs7O1M1Z
         uGvgPGPuJ5tpon638MsYj5ohjgH5kyaqQGr5HjUmk4Ip9yOzmLK50TSgdv0O++iObT
         l+yuULaN5rjkBn0NH6IVTFeKbTChGwlAIL8wI2tuwhoDEAqKn0iUcnOpxFyjDA412C
         cVhkzOnZ6OXCg==
Date:   Mon, 8 Nov 2021 10:07:46 +0000
From:   Will Deacon <will@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com,
        catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
        stable@vger.kernel.org, suzuki.poulose@arm.com
Subject: Re: [PATCH] arm64/kvm: extract ESR_ELx.EC only
Message-ID: <20211108100745.GA2328@willie-the-truck>
References: <20211103110545.4613-1-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103110545.4613-1-mark.rutland@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 03, 2021 at 11:05:45AM +0000, Mark Rutland wrote:
> Since ARMv8.0 the upper 32 bits of ESR_ELx have been RES0, and recently
> some of the upper bits gained a meaning and can be non-zero. For
> example, when FEAT_LS64 is implemented, ESR_ELx[36:32] contain ISS2,
> which for an ST64BV or ST64BV0 can be non-zero. This can be seen in ARM
> DDI 0487G.b, page D13-3145, section D13.2.37.
> 
> Generally, we must not rely on RES0 bit remaining zero in future, and
> when extracting ESR_ELx.EC we must mask out all other bits.
> 
> All C code uses the ESR_ELx_EC() macro, which masks out the irrelevant
> bits, and therefore no alterations are required to C code to avoid
> consuming irrelevant bits.
> 
> In a couple of places the KVM assembly extracts ESR_ELx.EC using LSR on
> an X register, and so could in theory consume previously RES0 bits. In
> both cases this is for comparison with EC values ESR_ELx_EC_HVC32 and
> ESR_ELx_EC_HVC64, for which the upper bits of ESR_ELx must currently be
> zero, but this could change in future.
> 
> This patch adjusts the KVM vectors to use UBFX rather than LSR to
> extract ESR_ELx.EC, ensuring these are robust to future additions to
> ESR_ELx.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/esr.h   | 1 +
>  arch/arm64/kvm/hyp/hyp-entry.S | 2 +-
>  arch/arm64/kvm/hyp/nvhe/host.S | 2 +-
>  3 files changed, 3 insertions(+), 2 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
