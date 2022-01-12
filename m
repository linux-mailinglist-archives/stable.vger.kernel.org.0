Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0144448C442
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 13:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240670AbiALM40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 07:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240649AbiALM4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 07:56:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93898C06173F;
        Wed, 12 Jan 2022 04:56:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30DC36189A;
        Wed, 12 Jan 2022 12:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80705C36AE5;
        Wed, 12 Jan 2022 12:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641992184;
        bh=25exskXbMuH0/ANkBgfQoC39mz6jhEbI7zTs38nzR/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rpEGKvgp9g6HB1Zs1hXqFJQorUstW3JCF7s9VawkBeeZZDCvDOfdTr6U9uw9uxm3i
         7gZYh7X908sABdlCrnYDhJEDGal29D1h/JDDfW/oRF7qCIH5ZqnNhIXbON9kNnkt1B
         OOpFr3Ya0Goee+OrYVQwxdn3cxkkvwb3viUuC5TYBywD+eMJp08EYYkC7bYXdPew0d
         TeAF2ZN0kOYTZZZWlOB4cs8EUMpZKbTe3od+e6Eh6nrbaUFlBL71I4AXdW3zRM34Ms
         blNpTPWauUBtOyEVIhUHZkBUxN+KrmDbb9jdW06u/fyMbV61xcm0VFwk3Ss4AKUg8u
         r/OlCZFyqET4A==
Date:   Wed, 12 Jan 2022 20:56:15 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     a-govindraju@ti.com, frank.li@nxp.com, rogerq@kernel.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdnsp: Fix segmentation fault in cdns_lost_power
 function
Message-ID: <20220112125615.GC3796@Peter>
References: <20220111090737.10345-1-pawell@gli-login.cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111090737.10345-1-pawell@gli-login.cadence.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22-01-11 10:07:37, Pawel Laszczak wrote:
> From: Pawel Laszczak <pawell@cadence.com>
> 
> CDNSP driver read not initialized cdns->otg_v0_regs
> which lead to segmentation fault. Patch fixes this issue.
> 
> Fixes: 2cf2581cd229 ("usb: cdns3: add power lost support for system resume")
> cc: <stable@vger.kernel.org>
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
>  drivers/usb/cdns3/drd.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/cdns3/drd.c b/drivers/usb/cdns3/drd.c
> index 55c73b1d8704..d00ff98dffab 100644
> --- a/drivers/usb/cdns3/drd.c
> +++ b/drivers/usb/cdns3/drd.c
> @@ -483,11 +483,11 @@ int cdns_drd_exit(struct cdns *cdns)
>  /* Indicate the cdns3 core was power lost before */
>  bool cdns_power_is_lost(struct cdns *cdns)
>  {
> -	if (cdns->version == CDNS3_CONTROLLER_V1) {
> -		if (!(readl(&cdns->otg_v1_regs->simulate) & BIT(0)))
> +	if (cdns->version == CDNS3_CONTROLLER_V0) {
> +		if (!(readl(&cdns->otg_v0_regs->simulate) & BIT(0)))
>  			return true;
>  	} else {
> -		if (!(readl(&cdns->otg_v0_regs->simulate) & BIT(0)))
> +		if (!(readl(&cdns->otg_v1_regs->simulate) & BIT(0)))
>  			return true;
>  	}
>  	return false;
> -- 

Pawel, may this lead cdns driver segment fault?

-- 

Thanks,
Peter Chen

