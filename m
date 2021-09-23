Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F7E4159C1
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 10:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbhIWIH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 04:07:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235983AbhIWIH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Sep 2021 04:07:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1385611C6;
        Thu, 23 Sep 2021 08:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632384387;
        bh=WmBmb6i0i7239EXCGN+BOz5nInIBrgdqOjVqXfYBJyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GLiDPZs1LHeivfhM9LAWCRMtpap2mbhfhTwfBJ2cEU3ReN0qGytmZ+X9Gl/a+pUFt
         7QMv2N3Ge8xC0oQfTHoQi8YChR4h+gT5gkyixHFmAds9cSRv0GgquieQIGA1c2LmbY
         onWEyQ2JCRPdsrTUwdczIqvAVQIr8ihFieHXOEJk=
Date:   Thu, 23 Sep 2021 10:06:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Russell King <linux@armlinux.org.uk>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH stable 5.10] ARM: Qualify enabling of swiotlb_init()
Message-ID: <YUw1gSB2vo8XMUon@kroah.com>
References: <20210923001425.414046-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923001425.414046-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 22, 2021 at 05:14:24PM -0700, Florian Fainelli wrote:
> commit fcf044891c84e38fc90eb736b818781bccf94e38 upstream
> 
> We do not need a SWIOTLB unless we have DRAM that is addressable beyond
> the arm_dma_limit. Compare max_pfn with arm_dma_pfn_limit to determine
> whether we do need a SWIOTLB to be initialized.
> 
> Fixes: ad3c7b18c5b3 ("arm: use swiotlb for bounce buffering on LPAE configs")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/arm/mm/init.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index d54d69cf1732..75f3ab531bdf 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -378,7 +378,11 @@ static void __init free_highpages(void)
>  void __init mem_init(void)
>  {
>  #ifdef CONFIG_ARM_LPAE
> -	swiotlb_init(1);
> +	if (swiotlb_force == SWIOTLB_FORCE ||
> +	    max_pfn > arm_dma_pfn_limit)
> +		swiotlb_init(1);
> +	else
> +		swiotlb_force = SWIOTLB_NO_FORCE;
>  #endif
>  
>  	set_max_mapnr(pfn_to_page(max_pfn) - mem_map);
> -- 
> 2.25.1
> 

Both now queued up, thanks.

greg k-h
