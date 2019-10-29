Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E96C7E874D
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 12:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbfJ2LkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 07:40:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbfJ2LkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 07:40:02 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39E53217D9;
        Tue, 29 Oct 2019 11:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572349201;
        bh=b0Yx/pOD5w63B522OXKc4nLFXgNhCQem4ZHf05cCJ/g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZmaImj/3fhMnxq2LJucsm59PXeqHQgfZdnKGWM3z08zi1lSOJM6NqcZfdRb0MtxXa
         U+z49SFHLkVTLSkePIR15C+hnvOLdZa9MwpR8XToJkzrtTEdsNdz5EguB9DH9PLqOQ
         p4aS4h+HcZc4G4k6QhPXz1ZwG3PmNOigtBkTEXNY=
Date:   Tue, 29 Oct 2019 11:39:57 +0000
From:   Will Deacon <will@kernel.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] arm64: cpufeature: Enable Qualcomm erratas
Message-ID: <20191029113956.GC12103@willie-the-truck>
References: <20191029060432.1208859-1-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029060432.1208859-1-bjorn.andersson@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 28, 2019 at 11:04:32PM -0700, Bjorn Andersson wrote:
> With the introduction of 'cce360b54ce6 ("arm64: capabilities: Filter the
> entries based on a given mask")' the Qualcomm erratas are no long
> applied.
> 
> The result of not applying errata 1003 is that MSM8996 runs into various
> RCU stalls and fails to boot most of the times.
> 
> Give both 1003 and 1009 a "type" to ensure they are not filtered out in
> update_cpu_capabilities().

Oh nasty. Thanks for debugging and fixing this.

> Fixes: cce360b54ce6 ("arm64: capabilities: Filter the entries based on a given mask")
> Cc: stable@vger.kernel.org
> Reported-by: Mark Brown <broonie@kernel.org>
> Suggested-by: Will Deacon <will@kernel.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  arch/arm64/kernel/cpu_errata.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index df9465120e2f..cdd8df033536 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -780,6 +780,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>  	{
>  		.desc = "Qualcomm Technologies Falkor/Kryo erratum 1003",
>  		.capability = ARM64_WORKAROUND_QCOM_FALKOR_E1003,
> +		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
>  		.matches = cpucap_multi_entry_cap_matches,

This should probably be ARM64_CPUCAP_LOCAL_CPU_ERRATUM instead, but I'll
want Suzuki's ack before I take the change.

>  		.match_list = qcom_erratum_1003_list,
>  	},
> @@ -788,6 +789,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>  	{
>  		.desc = "Qualcomm erratum 1009, ARM erratum 1286807",
>  		.capability = ARM64_WORKAROUND_REPEAT_TLBI,
> +		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
>  		ERRATA_MIDR_RANGE_LIST(arm64_repeat_tlbi_cpus),

ERRATA_MIDR_RANGE_LIST sets the type already, so I think this is redundant.

Will
