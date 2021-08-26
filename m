Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F963F8E2A
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 20:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243386AbhHZSwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 14:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231453AbhHZSwB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 14:52:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA68860E08;
        Thu, 26 Aug 2021 18:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630003874;
        bh=1sBw6wh87JJ1PmDt2g16fO0S/CpK5Fnm5aKmdW+HMNU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BgjnFRKGrkZA0vZw607rmUkgORuR6hn6vMfw5V/tL1oPVmulD6p1QZe8tFN2jMlYr
         EcVQWQHP9I6+WTgCo0opaz0QbL6WFWi2ANXb4UDSg2mKWeNTRC+KTN/fIz2HuFOCnU
         GPk/LPM7Ksp0GxpOfsNA0p9wgXqsKGw1JlCJ3e3D8UOL7RUxsZSk0kdMRgoECCz6X7
         K2h9PKN+7vKwCK89fFbykLdYELZaWaNoMhxgZk8RHJfxclNfBjuJXCck4eVq3KL4GA
         mM4QnyiPplOC5VV+Bc1Dhkuotmo5Z9WS+ww7OerWk03pXo3H73NUeUsWrDUCmxwiDe
         jEZljJvLVf9iA==
Date:   Thu, 26 Aug 2021 14:51:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     sbhanu@codeaurora.org, stable@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: FAILED: Patch "mmc: sdhci-msm: Update the software timeout value
 for sdhc" failed to apply to 5.4-stable tree
Message-ID: <YSfioM5cEnvD3pGb@sashalap>
References: <20210824025754.658394-1-sashal@kernel.org>
 <CAE-0n53zk0ogf=TUknMoCAPDd97=jq3Czpp6b1c9E29ormuCSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAE-0n53zk0ogf=TUknMoCAPDd97=jq3Czpp6b1c9E29ormuCSQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 26, 2021 at 07:51:45AM +0000, Stephen Boyd wrote:
>From cd5d41c802f7b3e20c0c0ebd6bf0cb335954fd89 Mon Sep 17 00:00:00 2001
>From: Shaik Sajida Bhanu <sbhanu@codeaurora.org>
>Date: Fri, 16 Jul 2021 17:16:14 +0530
>Subject: [PATCH] mmc: sdhci-msm: Update the software timeout value for sdhc
>
>commit 67b13f3e221ed81b46a657e2b499bf8b20162476 upstream.
>
>Whenever SDHC run at clock rate 50MHZ or below, the hardware data
>timeout value will be 21.47secs, which is approx. 22secs and we have
>a current software timeout value as 10secs. We have to set software
>timeout value more than the hardware data timeout value to avioid seeing
>the below register dumps.
>
>[  332.953670] mmc2: Timeout waiting for hardware interrupt.
>[  332.959608] mmc2: sdhci: ============ SDHCI REGISTER DUMP ===========
>[  332.966450] mmc2: sdhci: Sys addr:  0x00000000 | Version:  0x00007202
>[  332.973256] mmc2: sdhci: Blk size:  0x00000200 | Blk cnt:  0x00000001
>[  332.980054] mmc2: sdhci: Argument:  0x00000000 | Trn mode: 0x00000027
>[  332.986864] mmc2: sdhci: Present:   0x01f801f6 | Host ctl: 0x0000001f
>[  332.993671] mmc2: sdhci: Power:     0x00000001 | Blk gap:  0x00000000
>[  333.000583] mmc2: sdhci: Wake-up:   0x00000000 | Clock:    0x00000007
>[  333.007386] mmc2: sdhci: Timeout:   0x0000000e | Int stat: 0x00000000
>[  333.014182] mmc2: sdhci: Int enab:  0x03ff100b | Sig enab: 0x03ff100b
>[  333.020976] mmc2: sdhci: ACmd stat: 0x00000000 | Slot int: 0x00000000
>[  333.027771] mmc2: sdhci: Caps:      0x322dc8b2 | Caps_1:   0x0000808f
>[  333.034561] mmc2: sdhci: Cmd:       0x0000183a | Max curr: 0x00000000
>[  333.041359] mmc2: sdhci: Resp[0]:   0x00000900 | Resp[1]:  0x00000000
>[  333.048157] mmc2: sdhci: Resp[2]:   0x00000000 | Resp[3]:  0x00000000
>[  333.054945] mmc2: sdhci: Host ctl2: 0x00000000
>[  333.059657] mmc2: sdhci: ADMA Err:  0x00000000 | ADMA Ptr:
>0x0000000ffffff218
>[  333.067178] mmc2: sdhci_msm: ----------- VENDOR REGISTER DUMP
>-----------
>[  333.074343] mmc2: sdhci_msm: DLL sts: 0x00000000 | DLL cfg:
>0x6000642c | DLL cfg2: 0x0020a000
>[  333.083417] mmc2: sdhci_msm: DLL cfg3: 0x00000000 | DLL usr ctl:
>0x00000000 | DDR cfg: 0x80040873
>[  333.092850] mmc2: sdhci_msm: Vndr func: 0x00008a9c | Vndr func2 :
>0xf88218a8 Vndr func3: 0x02626040
>[  333.102371] mmc2: sdhci: ============================================
>
>So, set software timeout value more than hardware timeout value.
>
>Signed-off-by: Shaik Sajida Bhanu <sbhanu@codeaurora.org>
>Acked-by: Adrian Hunter <adrian.hunter@intel.com>
>Cc: stable@vger.kernel.org
>Link: https://lore.kernel.org/r/1626435974-14462-1-git-send-email-sbhanu@codeaurora.org
>Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>Signed-off-by: Stephen Boyd <swboyd@chromium.org>
>---
> drivers/mmc/host/sdhci-msm.c | 18 ++++++++++++++++++
> 1 file changed, 18 insertions(+)
>
>diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
>index 8bed81cf03ad..8ab963055238 100644
>--- a/drivers/mmc/host/sdhci-msm.c
>+++ b/drivers/mmc/host/sdhci-msm.c
>@@ -1589,6 +1589,23 @@ static void sdhci_msm_set_clock(struct
>sdhci_host *host, unsigned int clock)

I've queued this up, thanks!

Note that the patch was linewrapped (see above).

-- 
Thanks,
Sasha
