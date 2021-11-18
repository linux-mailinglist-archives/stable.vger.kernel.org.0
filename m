Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645C04554AF
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 07:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243300AbhKRGUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 01:20:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242971AbhKRGUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 01:20:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A779D61B3E;
        Thu, 18 Nov 2021 06:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637216244;
        bh=Xzshs3GwTTe02XCa8lBARrgbMzeMx8OQRMkwoa+TE/s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RIX7Pcq9/r5eIYLMkeViJkcUUvAIuNN3clEXjRMGzZVPiMN8Ty5DJhGmH3+m0EH8z
         jylT+scDmRTnzwzv5q1I1/8pG3T2XiQ5OzlAdd3FLce5HwfoamOStDNoq/lSVUChsX
         eu870tXWhczuVXqmhs2DsFy9O1rg6tj0eCzjWVfwIirGNc+DMXwXIawFqdlvibRKw6
         M7qzOQDQ5gjdjh0jM7kAAk0xnYja5gNpIn9Er2st5HTxsBpk3WUNHH6KqIiLykZe3x
         iH5uCc3U4HauiRmPdz9MsFdTktFmatfNMODPRazzYxrrNXtfliZnE3WIrXqHfSTOWi
         jKpWa6deAcH/g==
Date:   Thu, 18 Nov 2021 11:47:18 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, hemantk@codeaurora.org,
        bbhatt@codeaurora.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mhi: pci_generic: Graceful shutdown on freeze
Message-ID: <20211118061718.GE6461@thinkpad>
References: <1635268180-13699-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1635268180-13699-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 26, 2021 at 07:09:40PM +0200, Loic Poulain wrote:
> There is no reason for shutting down MHI ungracefully on freeze,
> this causes the MHI host stack & device stack to not be aligned
> anymore since the proper MHI reset sequence is not performed for
> ungraceful shutdown.
> 
> Cc: stable@vger.kernel.org
> Fixes: 5f0c2ee1fe8d ("bus: mhi: pci-generic: Fix hibernation")
> Suggested-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Reviewed-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
> Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>

Applied to mhi-next!

Thanks,
Mani

> ---
>  v2: Forgot to mention this change comes from a Bhaumik suggestion
> 
>  drivers/bus/mhi/pci_generic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
> index 6a42425..d4a3ce2 100644
> --- a/drivers/bus/mhi/pci_generic.c
> +++ b/drivers/bus/mhi/pci_generic.c
> @@ -1018,7 +1018,7 @@ static int __maybe_unused mhi_pci_freeze(struct device *dev)
>  	 * context.
>  	 */
>  	if (test_and_clear_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status)) {
> -		mhi_power_down(mhi_cntrl, false);
> +		mhi_power_down(mhi_cntrl, true);
>  		mhi_unprepare_after_power_down(mhi_cntrl);
>  	}
>  
> -- 
> 2.7.4
> 
