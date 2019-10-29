Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FDEE8E59
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 18:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbfJ2RjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 13:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729470AbfJ2RjV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 13:39:21 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95A02208E3;
        Tue, 29 Oct 2019 17:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572370761;
        bh=tsXvNgMCLtR2kuqm1evXZDlLqqX0YULzlHhwJ/E5i/s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2dU3cm7PgO/ow0TadOq/6Bwc7XtLUensNccc5tmNmofFREhKLD/vngdmbLG3JE3KO
         69XR/Lsd/xToVK/LJnacwXJKdbHTZyMcxMDH19YML2B7YS9NgPCVYJ05Z6hNzW0LGz
         2+m+vTxOI3/O2ikGt2SZgt03eq+C2Xjtm9vEjQps=
Date:   Tue, 29 Oct 2019 17:39:15 +0000
From:   Will Deacon <will@kernel.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2] arm64: cpufeature: Enable Qualcomm Falkor/Kryo errata
 1003
Message-ID: <20191029173915.GC13281@willie-the-truck>
References: <20191029171539.1374553-1-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029171539.1374553-1-bjorn.andersson@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 10:15:39AM -0700, Bjorn Andersson wrote:
> With the introduction of 'cce360b54ce6 ("arm64: capabilities: Filter the
> entries based on a given mask")' the Qualcomm Falkor/Kryo errata 1003 is
> no long applied.
> 
> The result of not applying errata 1003 is that MSM8996 runs into various
> RCU stalls and fails to boot most of the times.
> 
> Give 1003 a "type" to ensure they are not filtered out in
> update_cpu_capabilities().
> 
> Fixes: cce360b54ce6 ("arm64: capabilities: Filter the entries based on a given mask")
> Cc: stable@vger.kernel.org
> Reported-by: Mark Brown <broonie@kernel.org>
> Suggested-by: Will Deacon <will@kernel.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
> 
> Changes since v1:
> - s/ARM64_CPUCAP_SCOPE_LOCAL_CPU/ARM64_CPUCAP_LOCAL_CPU_ERRATUM/
> - Dropped 1009 "fix" as it already had a type from ERRATA_MIDR_RANGE_LIST()
> 
>  arch/arm64/kernel/cpu_errata.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index df9465120e2f..3facd5ca52ed 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -780,6 +780,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>  	{
>  		.desc = "Qualcomm Technologies Falkor/Kryo erratum 1003",
>  		.capability = ARM64_WORKAROUND_QCOM_FALKOR_E1003,
> +		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
>  		.matches = cpucap_multi_entry_cap_matches,
>  		.match_list = qcom_erratum_1003_list,
>  	},
> -- 
> 2.23.0

Thanks, I'll pick this up as a fix.

Will
