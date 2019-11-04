Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB159EE172
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 14:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbfKDNlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 08:41:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727332AbfKDNlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 08:41:08 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8A6320B7C;
        Mon,  4 Nov 2019 13:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572874867;
        bh=N/dxJHnIbOAdDxn7tKF4Wf9VCMiJYAsFQp+sr3QkQg0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ypdgNGrK07W1clllLPKgJE0fLYcHEFH0aPUE+zn5PRMosXAvh4doUDIVtQwKQ84o+
         D+lOfSVhBjWBzgygv9hcu0KPCVEW9eUZrfw89W4ukujG4zKHDZzQ98MpfRJ4l6v4Nm
         mcfHqTYQ5a+jknjJPhBEdCd5P2rjB2l2zJKV8+UA=
Date:   Mon, 4 Nov 2019 13:41:03 +0000
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     bjorn.andersson@linaro.org, broonie@kernel.org,
        stable@vger.kernel.org, suzuki.poulose@arm.com
Subject: Re: FAILED: patch "[PATCH] arm64: cpufeature: Enable Qualcomm
 Falkor/Kryo errata 1003" failed to apply to 4.19-stable tree
Message-ID: <20191104134102.GA24520@willie-the-truck>
References: <157285926713032@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157285926713032@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

[+Suzuki]

On Mon, Nov 04, 2019 at 10:21:07AM +0100, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From d4af3c4b81f4cd5662baa6f1492f998d89783318 Mon Sep 17 00:00:00 2001
> From: Bjorn Andersson <bjorn.andersson@linaro.org>
> Date: Tue, 29 Oct 2019 10:15:39 -0700
> Subject: [PATCH] arm64: cpufeature: Enable Qualcomm Falkor/Kryo errata 1003
> 
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

I think this Fixes tag is actually wrong, and so this patch isn't required
for the 4.19-stable tree or earlier.

The bug appears to have been introduced by a3dcea2c8512 ("arm64: capabilities:
Merge duplicate entries for Qualcomm erratum 1003") in v5.0.

Thanks,

Will

> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index 6c3b10a41bd8..7f9b699969c7 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -816,6 +816,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>  	{
>  		.desc = "Qualcomm Technologies Falkor/Kryo erratum 1003",
>  		.capability = ARM64_WORKAROUND_QCOM_FALKOR_E1003,
> +		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
>  		.matches = cpucap_multi_entry_cap_matches,
>  		.match_list = qcom_erratum_1003_list,
>  	},
> 
