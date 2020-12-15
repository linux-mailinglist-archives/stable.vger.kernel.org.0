Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1051B2DA8DC
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 09:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgLOIE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 03:04:57 -0500
Received: from mga17.intel.com ([192.55.52.151]:59479 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgLOIEr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Dec 2020 03:04:47 -0500
IronPort-SDR: iMSO8qop0vBUw73olcszh6hOc18CAY01VComXn0smvo87d8Ug3m1OvhAKLIXDByslBpwcQYLJz
 a7hLZRnZ8gEA==
X-IronPort-AV: E=McAfee;i="6000,8403,9835"; a="154649322"
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="154649322"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 00:04:05 -0800
IronPort-SDR: X7w60umHBYVcg81LO00WjKgRfF1of3r81LUUCqpVwXv7b2knWPLG8UHmjWQoo5S6v5+8SEv6ng
 j9cPVQfU3mQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="558613651"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.94]) ([10.237.72.94])
  by fmsmga005.fm.intel.com with ESMTP; 15 Dec 2020 00:04:02 -0800
Subject: Re: [PATCH] mmc: sdhci-xenon: fix 1.8v regulator stabilization
To:     Marcin Wojtas <mw@semihalf.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Cc:     ulf.hansson@linaro.org, huziji@marvell.com, jaz@semihalf.com,
        tn@semihalf.com, kostap@marvell.com,
        Alex Leibovich <alexl@marvell.com>, stable@vger.kernel.org
References: <20201211141656.24915-1-mw@semihalf.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <f6d0f22c-2a19-d1dc-b370-4238a7d2d9b3@intel.com>
Date:   Tue, 15 Dec 2020 10:03:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201211141656.24915-1-mw@semihalf.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/12/20 4:16 pm, Marcin Wojtas wrote:
> From: Alex Leibovich <alexl@marvell.com>
> 
> Automatic Clock Gating is a feature used for the power
> consumption optimisation. It turned out that
> during early init phase it may prevent the stable voltage
> switch to 1.8V - due to that on some platfroms an endless

platfroms -> platforms

> printout in dmesg can be observed:
> "mmc1: 1.8V regulator output did not became stable"
> Fix the problem by disabling the ACG at very beginning
> of the sdhci_init and let that be enabled later.
> 
> Fixes: 3a3748dba881 ("mmc: sdhci-xenon: Add Marvell Xenon SDHC core functionality")
> Signed-off-by: Alex Leibovich <alexl@marvell.com>
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> Cc: stable@vger.kernel.org

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/mmc/host/sdhci-xenon.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/sdhci-xenon.c b/drivers/mmc/host/sdhci-xenon.c
> index c67611fdaa8a..4b05f6fdefb4 100644
> --- a/drivers/mmc/host/sdhci-xenon.c
> +++ b/drivers/mmc/host/sdhci-xenon.c
> @@ -168,7 +168,12 @@ static void xenon_reset_exit(struct sdhci_host *host,
>  	/* Disable tuning request and auto-retuning again */
>  	xenon_retune_setup(host);
>  
> -	xenon_set_acg(host, true);
> +	/*
> +	 * The ACG should be turned off at the early init time, in order
> +	 * to solve a possile issues with the 1.8V regulator stabilization.

a possile -> possible

> +	 * The feature is enabled in later stage.
> +	 */
> +	xenon_set_acg(host, false);
>  
>  	xenon_set_sdclk_off_idle(host, sdhc_id, false);
>  
> 

