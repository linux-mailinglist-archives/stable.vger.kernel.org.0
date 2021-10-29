Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEA843F9DB
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 11:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhJ2Jb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 05:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231464AbhJ2Jb0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Oct 2021 05:31:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A330160F55;
        Fri, 29 Oct 2021 09:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635499737;
        bh=AgJYIDpZ57iquVgVaiONgxk72S9zLac+q6InUmY0xAM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aaFtQ4DTfoCkoN66tmWqaYFo8ucOr6d33q6TpAgWnSc8W2OMIQW3t2hDElokrwZnd
         SLCiGLot5Ptz9oJ8bbF1NuuvQ2vrjmEVKGfXSeo/+xji8PK3NEWr2EFJ7sCnACmEez
         b0biGCrDwXNAZ/VA4QGwx722AVczxCm+x3Sj+X21pKCLyg55JfYnBoLTr2NzNiv8wZ
         lZf8vVUlhChkIRHon2oO3vH1pUMKwoODZ8Bcm+MPGnz6ga1OblkpyVykDAOLCBzWUY
         /Ag6O6GEg7rO9ktvE6U5Jr6rdN/cQ0iHKJVmmzIulQqu5dtzFQJZ/IHwlpLlyejTSr
         2DNexHjfTbmjg==
Date:   Fri, 29 Oct 2021 14:58:06 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, hemantk@codeaurora.org,
        bbhatt@codeaurora.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mhi: pci_generic: Graceful shutdown on freeze
Message-ID: <20211029092806.GB4945@thinkpad>
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

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

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
