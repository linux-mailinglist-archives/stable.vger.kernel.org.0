Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C8647D07D
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 12:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244386AbhLVLF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 06:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244385AbhLVLF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 06:05:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318D5C061401;
        Wed, 22 Dec 2021 03:05:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4192B817BF;
        Wed, 22 Dec 2021 11:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4B7C36AE5;
        Wed, 22 Dec 2021 11:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640171155;
        bh=BlYs20lEZccLaHd2OMNWc0vtKEchOII0ZXaugipd8IM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YDr92TP2Z6urs4t+X0S5irZw7CHMK2WBanAp2RYiMn6A6FJAkol1/2/BCNFKXfaes
         JIGLisXhraZ5doX9r1lwfBe+j0yFrfSFhsd7IaxbmavthLQhHP8FODZf0kD5Yubp+7
         aOmjgNvC9SDNpEqCLakfepUAKuCek+LwAxWr1TCs=
Date:   Wed, 22 Dec 2021 12:05:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
        David E Box <david.e.box@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] platform/x86: intel_pmc_core: fix memleak on
 registration failure
Message-ID: <YcMGkaGP2m4wyCYi@kroah.com>
References: <20211222105023.6205-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211222105023.6205-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 22, 2021 at 11:50:23AM +0100, Johan Hovold wrote:
> In case device registration fails during module initialisation, the
> platform device structure needs to be freed using platform_device_put()
> to properly free all resources (e.g. the device name).
> 
> Fixes: 938835aa903a ("platform/x86: intel_pmc_core: do not create a static struct device")
> Cc: stable@vger.kernel.org      # 5.9
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/platform/x86/intel/pmc/pltdrv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/intel/pmc/pltdrv.c b/drivers/platform/x86/intel/pmc/pltdrv.c
> index 73797680b895..15ca8afdd973 100644
> --- a/drivers/platform/x86/intel/pmc/pltdrv.c
> +++ b/drivers/platform/x86/intel/pmc/pltdrv.c
> @@ -65,7 +65,7 @@ static int __init pmc_core_platform_init(void)
>  
>  	retval = platform_device_register(pmc_core_device);
>  	if (retval)
> -		kfree(pmc_core_device);
> +		platform_device_put(pmc_core_device);
>  
>  	return retval;
>  }
> -- 
> 2.32.0
> 

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
