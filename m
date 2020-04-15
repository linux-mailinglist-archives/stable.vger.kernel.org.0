Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8C91A9360
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 08:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390393AbgDOGkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 02:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389993AbgDOGko (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 02:40:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4FCB206F9;
        Wed, 15 Apr 2020 06:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586932842;
        bh=uMxupTWL0PONrde+ztLpDT0vDuErYXTTqUmbqYdPYWE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z69j4X1eioItwMQn79geGrNHHyhVQLc7pEUets6VOSKzK2mxdid6hDiXKBcaPFZil
         sa+0MmMSDJS4dVosELR4WKR0CZoPqgD+n5+OD51CBB1FCBFON5aQk8HntsYvcmNEJV
         51z51GFqg3pr7aoS6En1y2Q22zQp2UVpVqbBBhi8=
Date:   Wed, 15 Apr 2020 08:40:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Daniel Walker <danielwa@cisco.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [v5.5] mmc: sdhci-of-esdhc: fix esdhc_reset() for different
 controller versions
Message-ID: <20200415064040.GA2498844@kroah.com>
References: <20200415035212.19139-1-yangbo.lu@nxp.com>
 <20200415035212.19139-2-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415035212.19139-2-yangbo.lu@nxp.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 11:52:12AM +0800, Yangbo Lu wrote:
> commit 2aa3d826adb578b26629a79b775a552cfe3fedf7 upstream.
> 
> This patch is to fix operating in esdhc_reset() for different
> controller versions, and to add bus-width restoring after data
> reset for eSDHC (verdor version <= 2.2).
> 
> Also add annotation for understanding.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Link: https://lore.kernel.org/r/20200108040713.38888-1-yangbo.lu@nxp.com
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>  drivers/mmc/host/sdhci-of-esdhc.c | 43 +++++++++++++++++++++++++++++++++++----
>  1 file changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
> index fcfb50f..fd1251e 100644
> --- a/drivers/mmc/host/sdhci-of-esdhc.c
> +++ b/drivers/mmc/host/sdhci-of-esdhc.c
> @@ -734,23 +734,58 @@ static void esdhc_reset(struct sdhci_host *host, u8 mask)
>  {
>  	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>  	struct sdhci_esdhc *esdhc = sdhci_pltfm_priv(pltfm_host);
> -	u32 val;
> +	u32 val, bus_width = 0;
>  
> +	/*
> +	 * Add delay to make sure all the DMA transfers are finished
> +	 * for quirk.
> +	 */
>  	if (esdhc->quirk_delay_before_data_reset &&
>  	    (mask & SDHCI_RESET_DATA) &&
>  	    (host->flags & SDHCI_REQ_USE_DMA))
>  		mdelay(5);
>  
> +	/*
> +	 * Save bus-width for eSDHC whose vendor version is 2.2
> +	 * or lower for data reset.
> +	 */
> +	if ((mask & SDHCI_RESET_DATA) &&
> +	    (esdhc->vendor_ver <= VENDOR_V_22)) {
> +		val = sdhci_readl(host, ESDHC_PROCTL);
> +		bus_width = val & ESDHC_CTRL_BUSWIDTH_MASK;
> +	}
> +
>  	sdhci_reset(host, mask);
>  
> -	sdhci_writel(host, host->ier, SDHCI_INT_ENABLE);
> -	sdhci_writel(host, host->ier, SDHCI_SIGNAL_ENABLE);
> +	/*
> +	 * Restore bus-width setting and interrupt registers for eSDHC
> +	 * whose vendor version is 2.2 or lower for data reset.
> +	 */
> +	if ((mask & SDHCI_RESET_DATA) &&
> +	    (esdhc->vendor_ver <= VENDOR_V_22)) {
> +		val = sdhci_readl(host, ESDHC_PROCTL);
> +		val &= ~ESDHC_CTRL_BUSWIDTH_MASK;
> +		val |= bus_width;
> +		sdhci_writel(host, val, ESDHC_PROCTL);
> +
> +		sdhci_writel(host, host->ier, SDHCI_INT_ENABLE);
> +		sdhci_writel(host, host->ier, SDHCI_SIGNAL_ENABLE);
> +	}
>  
> -	if (mask & SDHCI_RESET_ALL) {
> +	/*
> +	 * Some bits have to be cleaned manually for eSDHC whose spec
> +	 * version is higher than 3.0 for all reset.
> +	 */
> +	if ((mask & SDHCI_RESET_ALL) &&
> +	    (esdhc->spec_ver >= SDHCI_SPEC_300)) {
>  		val = sdhci_readl(host, ESDHC_TBCTL);
>  		val &= ~ESDHC_TB_EN;
>  		sdhci_writel(host, val, ESDHC_TBCTL);
>  
> +		/*
> +		 * Initialize eSDHC_DLLCFG1[DLL_PD_PULSE_STRETCH_SEL] to
> +		 * 0 for quirk.
> +		 */
>  		if (esdhc->quirk_unreliable_pulse_detection) {
>  			val = sdhci_readl(host, ESDHC_DLLCFG1);
>  			val &= ~ESDHC_DLL_PD_PULSE_STRETCH_SEL;
> -- 
> 2.7.4
> 

Now applied to 5.5.y and 5.4.y, thanks.

greg k-h
