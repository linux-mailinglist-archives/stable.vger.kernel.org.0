Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEC83B307A
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 15:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhFXNxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 09:53:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhFXNxI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 09:53:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACE4F613C7;
        Thu, 24 Jun 2021 13:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624542648;
        bh=PI0GARfg9sF2LDn+ZRFhnJyGiPmktprzIN0jKCHNYiU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gPZqRVWafqMPZrVexzVhsxE2duBXI641s/PD9f33KpDJVVOnfxSsZk2i2gYlZlfpN
         K7REhiEzNdBLQZCoBKYfHO1rEbrXg3UkRfoiTUurjBmcyMLT+95VYeZ4hJvkn5Pi4n
         JnqvSohSjzMg7PbTQSQmRtHECnfkgy4/fQm7Y56A=
Date:   Thu, 24 Jun 2021 15:50:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     hemantk@codeaurora.org, bbhatt@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        loic.poulain@linaro.org, stable@vger.kernel.org,
        Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: Re: [PATCH 1/8] bus: mhi: core: Validate channel ID when processing
 command completions
Message-ID: <YNSNtQxVaegArG2f@kroah.com>
References: <20210621161616.77524-1-manivannan.sadhasivam@linaro.org>
 <20210621161616.77524-2-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621161616.77524-2-manivannan.sadhasivam@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 09:46:09PM +0530, Manivannan Sadhasivam wrote:
> From: Bhaumik Bhatt <bbhatt@codeaurora.org>
> 
> MHI reads the channel ID from the event ring element sent by the
> device which can be any value between 0 and 255. In order to
> prevent any out of bound accesses, add a check against the maximum
> number of channels supported by the controller and those channels
> not configured yet so as to skip processing of that event ring
> element.
> 
> Cc: stable@vger.kernel.org
> Fixes: 1d3173a3bae7 ("bus: mhi: core: Add support for processing events from client device")
> Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
> Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
> Link: https://lore.kernel.org/r/1619481538-4435-1-git-send-email-bbhatt@codeaurora.org
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  drivers/bus/mhi/core/main.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
> index 22acde118bc3..ed07421c4870 100644
> --- a/drivers/bus/mhi/core/main.c
> +++ b/drivers/bus/mhi/core/main.c
> @@ -773,11 +773,16 @@ static void mhi_process_cmd_completion(struct mhi_controller *mhi_cntrl,
>  	cmd_pkt = mhi_to_virtual(mhi_ring, ptr);
>  
>  	chan = MHI_TRE_GET_CMD_CHID(cmd_pkt);
> -	mhi_chan = &mhi_cntrl->mhi_chan[chan];
> -	write_lock_bh(&mhi_chan->lock);
> -	mhi_chan->ccs = MHI_TRE_GET_EV_CODE(tre);
> -	complete(&mhi_chan->completion);
> -	write_unlock_bh(&mhi_chan->lock);
> +	WARN_ON(chan >= mhi_cntrl->max_chan);

What can ever trigger this WARN_ON()?  Do you mean to reboot a machine
if panic-on-warn is set?

If this can actually happen, then check for it and recover properly,
don't just blindly warn and then keep on going.

thanks,

greg k-h
