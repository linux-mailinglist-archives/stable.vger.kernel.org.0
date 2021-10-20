Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AE6434AEB
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 14:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhJTMPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 08:15:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230092AbhJTMPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 08:15:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1D93611C7;
        Wed, 20 Oct 2021 12:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634731975;
        bh=83tJ8okr7Nb8oaN1QT8DQRxlDJU01xHK7au8CQWVuhs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=12YA3V/EF/8H9/cgjLDrvYtT6UX2AZRZwG8Ndm9mudI1o6Ti1B7pOAX56Ae0+fYpp
         hem2axAi5KLFhcPO/cQZxNXLKvBfLclNN2vZn6b8U4T3LHmRebAQVcFd4PlUVowVis
         52HpcZPMxGufEk7exC0+fCxviTvb/HR6QBo64nc8=
Date:   Wed, 20 Oct 2021 14:12:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     krzysztof.kozlowski@canonical.com, vz@mleia.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: s5p-sss - Add error handling in
 s5p_aes_probe()
Message-ID: <YXAHxNWkttb0V6BV@kroah.com>
References: <20211020110624.47696-1-tangbin@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020110624.47696-1-tangbin@cmss.chinamobile.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 20, 2021 at 07:06:24PM +0800, Tang Bin wrote:
> The function s5p_aes_probe() does not perform sufficient error
> checking after executing platform_get_resource(), thus fix it.
> 
> Fixes: c2afad6c6105 ("crypto: s5p-sss - Add HASH support for Exynos")
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
> Changes from v1
>  - add fixed title
> ---
>  drivers/crypto/s5p-sss.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 55aa3a711..7717e9e59 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -2171,6 +2171,8 @@ static int s5p_aes_probe(struct platform_device *pdev)
>  
>  	variant = find_s5p_sss_version(pdev);
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -EINVAL;
>  
>  	/*
>  	 * Note: HASH and PRNG uses the same registers in secss, avoid
> -- 
> 2.20.1.windows.1
> 
> 
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
