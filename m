Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D8C449C1C
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 20:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbhKHTEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 14:04:20 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:64044 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbhKHTEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 14:04:20 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1636398095; h=Message-ID: References: In-Reply-To: Reply-To:
 Subject: Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=QPpk7Qd6kOpF1J1BpdrBm+F1teLdtEDhSGNniOL7dWc=;
 b=Yb22cGBh4O41lzUKr192PbWqs7Z1Jp2HMcRfyVLoedkwzoEJKnvovOS10Z/n6ABZsRP1/mzM
 tpQu1UygJwfqlF+L7cN83HetmA1prienExmA0RZOb0U5DkNa1MwILOBdajIAwO/RLTSuoTBk
 cgdXUUn1fbQbwyn3FSc82ZdURkM=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 61897400facd20d7959ffe6a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Nov 2021 19:01:20
 GMT
Sender: bbhatt=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 26F74C43460; Mon,  8 Nov 2021 19:01:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbhatt)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 17A2AC4338F;
        Mon,  8 Nov 2021 19:01:17 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 08 Nov 2021 11:01:17 -0800
From:   Bhaumik Bhatt <bbhatt@codeaurora.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     mhi@lists.linux.dev, aleksander@aleksander.es,
        loic.poulain@linaro.org, thomas.perrot@bootlin.com,
        hemantk@codeaurora.org, quic_jhugo@quicinc.com,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] bus: mhi: Fix race while handling SYS_ERR at power up
Organization: Qualcomm Innovation Center, Inc.
Reply-To: bbhatt@codeaurora.org
Mail-Reply-To: bbhatt@codeaurora.org
In-Reply-To: <20211108174954.60569-1-manivannan.sadhasivam@linaro.org>
References: <20211108174954.60569-1-manivannan.sadhasivam@linaro.org>
Message-ID: <b94e394edf531d0e0e1ad675cdd65d75@codeaurora.org>
X-Sender: bbhatt@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-11-08 09:49 AM, Manivannan Sadhasivam wrote:
> Some devices tend to trigger SYS_ERR interrupt while the host handling
> SYS_ERR state of the device during power up. This creates a race
> condition and causes a failure in booting up the device.
> 
> The issue is seen on the Sierra Wireless EM9191 modem during SYS_ERR
> handling in mhi_async_power_up(). Once the host detects that the device
> is in SYS_ERR state, it issues MHI_RESET and waits for the device to
> process the reset request. During this time, the device triggers 
> SYS_ERR
> interrupt to the host and host starts handling SYS_ERR execution.
> 
> So by the time the device has completed reset, host starts SYS_ERR
> handling. This causes the race condition and the modem fails to boot.
> 
> Hence, register the IRQ handler only after handling the SYS_ERR check
> to avoid getting spurious IRQs from the device.
> 
> Cc: stable@vger.kernel.org
> Fixes: e18d4e9fa79b ("bus: mhi: core: Handle syserr during power_up")
> Reported-by: Aleksander Morgado <aleksander@aleksander.es>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
> 
> Changes in v2:
> 
> * Switched to "mhi_poll_reg_field" for detecting MHI reset in device.
> 
>  drivers/bus/mhi/core/pm.c | 32 ++++++++++----------------------
>  1 file changed, 10 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
> index fb99e3727155..3c347fe9b10d 100644
> --- a/drivers/bus/mhi/core/pm.c
> +++ b/drivers/bus/mhi/core/pm.c
> @@ -1038,7 +1038,6 @@ int mhi_async_power_up(struct mhi_controller 
> *mhi_cntrl)
>  	enum mhi_ee_type current_ee;
>  	enum dev_st_transition next_state;
>  	struct device *dev = &mhi_cntrl->mhi_dev->dev;
> -	u32 val;
u32 interval_us = 25000; /* poll register field every 25 milliseconds */
>  	int ret;
> 
>  	dev_info(dev, "Requested to power ON\n");
> @@ -1055,10 +1054,6 @@ int mhi_async_power_up(struct mhi_controller 
> *mhi_cntrl)
>  	mutex_lock(&mhi_cntrl->pm_mutex);
>  	mhi_cntrl->pm_state = MHI_PM_DISABLE;
> 
> -	ret = mhi_init_irq_setup(mhi_cntrl);
> -	if (ret)
> -		goto error_setup_irq;
> -
>  	/* Setup BHI INTVEC */
>  	write_lock_irq(&mhi_cntrl->pm_lock);
>  	mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
Let's also set the BHI INTVEC up _after_ the IRQ setup is done. I 
believe doing
this before setting up IRQs may be racy.
> @@ -1072,7 +1067,7 @@ int mhi_async_power_up(struct mhi_controller 
> *mhi_cntrl)
>  		dev_err(dev, "%s is not a valid EE for power on\n",
>  			TO_MHI_EXEC_STR(current_ee));
>  		ret = -EIO;
> -		goto error_async_power_up;
> +		goto error_setup_irq;
>  	}
> 
>  	state = mhi_get_mhi_state(mhi_cntrl);
> @@ -1081,20 +1076,12 @@ int mhi_async_power_up(struct mhi_controller 
> *mhi_cntrl)
> 
>  	if (state == MHI_STATE_SYS_ERR) {
>  		mhi_set_mhi_state(mhi_cntrl, MHI_STATE_RESET);
> -		ret = wait_event_timeout(mhi_cntrl->state_event,
> -				MHI_PM_IN_FATAL_STATE(mhi_cntrl->pm_state) ||
> -					mhi_read_reg_field(mhi_cntrl,
> -							   mhi_cntrl->regs,
> -							   MHICTRL,
> -							   MHICTRL_RESET_MASK,
> -							   MHICTRL_RESET_SHIFT,
> -							   &val) ||
> -					!val,
> -				msecs_to_jiffies(mhi_cntrl->timeout_ms));
> -		if (!ret) {
> -			ret = -EIO;
> +		ret = mhi_poll_reg_field(mhi_cntrl, mhi_cntrl->regs, MHICTRL,
> +				 MHICTRL_RESET_MASK, MHICTRL_RESET_SHIFT, 0,
> +				 msecs_to_jiffies(mhi_cntrl->timeout_ms));
Use "interval_us" as the last argument here since this API takes the 
polling interval
value in microseconds as the last argument.
> +		if (ret) {
>  			dev_info(dev, "Failed to reset MHI due to syserr state\n");
> -			goto error_async_power_up;
> +			goto error_setup_irq;
>  		}
> 
>  		/*
> @@ -1104,6 +1091,10 @@ int mhi_async_power_up(struct mhi_controller 
> *mhi_cntrl)
>  		mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
>  	}
> 
> +	ret = mhi_init_irq_setup(mhi_cntrl);
> +	if (ret)
> +		goto error_setup_irq;
> +
>  	/* Transition to next state */
>  	next_state = MHI_IN_PBL(current_ee) ?
>  		DEV_ST_TRANSITION_PBL : DEV_ST_TRANSITION_READY;
> @@ -1116,9 +1107,6 @@ int mhi_async_power_up(struct mhi_controller 
> *mhi_cntrl)
> 
>  	return 0;
> 
> -error_async_power_up:
> -	mhi_deinit_free_irq(mhi_cntrl);
> -
>  error_setup_irq:
>  	mhi_cntrl->pm_state = MHI_PM_DISABLE;
>  	mutex_unlock(&mhi_cntrl->pm_mutex);

Thanks,
Bhaumik
---
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
