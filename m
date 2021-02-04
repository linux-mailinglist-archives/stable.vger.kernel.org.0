Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D088030F005
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 10:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbhBDJzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 04:55:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:43014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234600AbhBDJzn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 04:55:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A997064F46;
        Thu,  4 Feb 2021 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612432502;
        bh=6GS1Oj2S2vEZKlcHYCYmO7hqCEnMei8WJEz2ukGolfo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qUnpTfZxIKo0TNU5CQyB0iCkXoynIR4R8UgFiBKvl40Gfsrgk24C/omXSuxDCLAm5
         n8SFeSVZYu2SWodIYj2tuC2wOa0yx50tr4/iVSstpoUgzZ0sr966HKnatoQzJomiaO
         +JDhQyeljmJoruGeyocpNQY5QAGFmdIV0LpG5scewWxs1nI2lnZcjNNyXHYn7buNO/
         fMXOlIHd2y+nAZMeZahi6Zbqup0MixDnCVyA3Hm4y5ZacZy/6jzlshVUJeGPQotPoe
         3Mo4iFrzr+IR2IvAVvaa5lxtQRRdfvY7MNgzB+XyJCjb2KNROpo0JEv9adou8Cdl1K
         +7weHqr/r5jqg==
Date:   Thu, 4 Feb 2021 09:54:58 +0000
From:   Will Deacon <will@kernel.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Subject: Re: [PATCH] arm64: Extend workaround for erratum 1024718 to all
 versions of Cortex-A55
Message-ID: <20210204095457.GA20361@willie-the-truck>
References: <20210203230057.3961239-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203230057.3961239-1-suzuki.poulose@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Suzuki,

On Wed, Feb 03, 2021 at 11:00:57PM +0000, Suzuki K Poulose wrote:
> The erratum 1024718 affects Cortex-A55 r0p0 to r2p0. However
> we apply the work around for r0p0 - r1p0. Unfortunately this
> won't be fixed for the future revisions for the CPU. Thus
> extend the work around for all versions of A55, to cover
> for r2p0 and any future revisions.
> 
> Cc: stable@vger.kernel.org
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: James Morse <james.morse@arm.com>
> Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/kernel/cpufeature.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index e99eddec0a46..db400ca77427 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1455,7 +1455,7 @@ static bool cpu_has_broken_dbm(void)
>  	/* List of CPUs which have broken DBM support. */
>  	static const struct midr_range cpus[] = {
>  #ifdef CONFIG_ARM64_ERRATUM_1024718
> -		MIDR_RANGE(MIDR_CORTEX_A55, 0, 0, 1, 0),  // A55 r0p0 -r1p0
> +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),

I think we have bigger problems with this erratum, since cpu_has_hw_af()
doesn't taken this erratum into account at all, meaning that
arch_faults_on_old_pte() will return the wrong value on any system with an
A55.

Please can you fix that along with this patch? You'll need to pay extra
attention to the stuff I've queued on for-next/faultaround, where we will
actually want arch_wants_old_prefaulted_pte() to return 'true' if any of the
CPUs have DBM, since it's a pure performance thing.

Cheers,

Will
