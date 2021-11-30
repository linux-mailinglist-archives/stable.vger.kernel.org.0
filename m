Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E15462951
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 01:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbhK3A6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 19:58:19 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:14509 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234229AbhK3A6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 19:58:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1638233701; h=Message-ID: References: In-Reply-To: Reply-To:
 Subject: Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Si6o8utt9hx7y8YzH3OhVdkira7dpL45F1uP7ReREDA=;
 b=oiwHYZF8qX37vCQyORTezRKZjUMdmVFH4bhrGrZ2/TbZ2TbCiEBz8jtHKTircSuKnuJvdS9O
 etMizqte0Ygbg5MsiUUwjS5wc/2BWqbDq9AsCjT9RUMfDngZap0gkr90DU7CBBkEyn5mkNeL
 eGfHE2+diVPBin8uT12uqrNNqDc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 61a576641abc6f02d055b808 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 30 Nov 2021 00:55:00
 GMT
Sender: quic_bbhatt=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 52347C43619; Tue, 30 Nov 2021 00:55:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbhatt)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 35796C4338F;
        Tue, 30 Nov 2021 00:54:59 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 29 Nov 2021 16:54:59 -0800
From:   Bhaumik Bhatt <quic_bbhatt@quicinc.com>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     mhi@lists.linux.dev, quic_jhugo@quicinc.com,
        hemantk@codeaurora.org, bbhatt@codeaurora.org,
        aleksander@aleksander.es, loic.poulain@linaro.org,
        thomas.perrot@bootlin.com, linux-arm-msm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] bus: mhi: Fix race while handling SYS_ERR at power up
Organization: Qualcomm Innovation Center, Inc.
Reply-To: quic_bbhatt@quicinc.com
Mail-Reply-To: quic_bbhatt@quicinc.com
In-Reply-To: <20211126030144.GC5859@thinkpad>
References: <20211124132221.44915-1-manivannan.sadhasivam@linaro.org>
 <20211126030144.GC5859@thinkpad>
Message-ID: <020937096d9039a295b97d71994a6d5a@quicinc.com>
X-Sender: quic_bbhatt@quicinc.com
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-11-25 07:01 PM, Manivannan Sadhasivam wrote:
> On Wed, Nov 24, 2021 at 06:52:21PM +0530, Manivannan Sadhasivam wrote:
>> Some devices tend to trigger SYS_ERR interrupt while the host handling
>> SYS_ERR state of the device during power up. This creates a race
>> condition and causes a failure in booting up the device.
>> 
>> The issue is seen on the Sierra Wireless EM9191 modem during SYS_ERR
>> handling in mhi_async_power_up(). Once the host detects that the 
>> device
>> is in SYS_ERR state, it issues MHI_RESET and waits for the device to
>> process the reset request. During this time, the device triggers 
>> SYS_ERR
>> interrupt to the host and host starts handling SYS_ERR execution.
Since device does not actually trigger a SYS_ERR interrupt, we could say 
"device
triggers BHI interrupt acknowledging the MHI RESET sent by host but does 
not clear
the MHI state to reset or ready and leaves it as SYS_ERR" or any such 
wording.
>> 
>> So by the time the device has completed reset, host starts SYS_ERR
>> handling. This causes the race condition and the modem fails to boot.
>> 
>> Hence, register the IRQ handler only after handling the SYS_ERR check
>> to avoid getting spurious IRQs from the device.
>> 
>> Cc: stable@vger.kernel.org
>> Fixes: e18d4e9fa79b ("bus: mhi: core: Handle syserr during power_up")
>> Reported-by: Aleksander Morgado <aleksander@aleksander.es>
>> Signed-off-by: Manivannan Sadhasivam 
>> <manivannan.sadhasivam@linaro.org>
> 
> Hemant, Bhaumik, Jeff: Can you please do the review again?
> 
> Thanks,
> Mani
> 
>> ---
>> 
>> Changes in v4:
>> 
>> * Reverted the change that moved BHI_INTVEC as that was causing issue 
>> as
>>   reported by Aleksander.
>> 
>> Changes in v3:
>> 
>> * Moved BHI_INTVEC setup after irq setup
>> * Used interval_us as the delay for the polling API
>> 
>> Changes in v2:
>> 
>> * Switched to "mhi_poll_reg_field" for detecting MHI reset in device.
>> 
>>  drivers/bus/mhi/core/pm.c | 33 +++++++++++----------------------
>>  1 file changed, 11 insertions(+), 22 deletions(-)
>> 
>> diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
>> index fb99e3727155..21484a61bbed 100644
>> --- a/drivers/bus/mhi/core/pm.c
>> +++ b/drivers/bus/mhi/core/pm.c
>> @@ -1038,7 +1038,7 @@ int mhi_async_power_up(struct mhi_controller 
>> *mhi_cntrl)
>>  	enum mhi_ee_type current_ee;
>>  	enum dev_st_transition next_state;
>>  	struct device *dev = &mhi_cntrl->mhi_dev->dev;
>> -	u32 val;
>> +	u32 interval_us = 25000; /* poll register field every 25 
>> milliseconds */
>>  	int ret;
>> 
>>  	dev_info(dev, "Requested to power ON\n");
>> @@ -1055,10 +1055,6 @@ int mhi_async_power_up(struct mhi_controller 
>> *mhi_cntrl)
>>  	mutex_lock(&mhi_cntrl->pm_mutex);
>>  	mhi_cntrl->pm_state = MHI_PM_DISABLE;
>> 
>> -	ret = mhi_init_irq_setup(mhi_cntrl);
>> -	if (ret)
>> -		goto error_setup_irq;
>> -
>>  	/* Setup BHI INTVEC */
>>  	write_lock_irq(&mhi_cntrl->pm_lock);
>>  	mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
>> @@ -1072,7 +1068,7 @@ int mhi_async_power_up(struct mhi_controller 
>> *mhi_cntrl)
>>  		dev_err(dev, "%s is not a valid EE for power on\n",
>>  			TO_MHI_EXEC_STR(current_ee));
>>  		ret = -EIO;
>> -		goto error_async_power_up;
>> +		goto error_setup_irq;
We're using the label "error_setup_irq" even though there has not been 
any prior IRQ
setup done. Can we use the label "error_async_power_up" instead?
>>  	}
>> 
>>  	state = mhi_get_mhi_state(mhi_cntrl);
>> @@ -1081,20 +1077,12 @@ int mhi_async_power_up(struct mhi_controller 
>> *mhi_cntrl)
>> 
>>  	if (state == MHI_STATE_SYS_ERR) {
>>  		mhi_set_mhi_state(mhi_cntrl, MHI_STATE_RESET);
>> -		ret = wait_event_timeout(mhi_cntrl->state_event,
>> -				MHI_PM_IN_FATAL_STATE(mhi_cntrl->pm_state) ||
>> -					mhi_read_reg_field(mhi_cntrl,
>> -							   mhi_cntrl->regs,
>> -							   MHICTRL,
>> -							   MHICTRL_RESET_MASK,
>> -							   MHICTRL_RESET_SHIFT,
>> -							   &val) ||
>> -					!val,
>> -				msecs_to_jiffies(mhi_cntrl->timeout_ms));
>> -		if (!ret) {
>> -			ret = -EIO;
>> +		ret = mhi_poll_reg_field(mhi_cntrl, mhi_cntrl->regs, MHICTRL,
>> +				 MHICTRL_RESET_MASK, MHICTRL_RESET_SHIFT, 0,
>> +				 interval_us);
>> +		if (ret) {
>>  			dev_info(dev, "Failed to reset MHI due to syserr state\n");
>> -			goto error_async_power_up;
>> +			goto error_setup_irq;
Same here
>>  		}
>> 
>>  		/*
>> @@ -1104,6 +1092,10 @@ int mhi_async_power_up(struct mhi_controller 
>> *mhi_cntrl)
>>  		mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
>>  	}
>> 
>> +	ret = mhi_init_irq_setup(mhi_cntrl);
>> +	if (ret)
>> +		goto error_setup_irq;
And here
>> +
>>  	/* Transition to next state */
>>  	next_state = MHI_IN_PBL(current_ee) ?
>>  		DEV_ST_TRANSITION_PBL : DEV_ST_TRANSITION_READY;
>> @@ -1116,9 +1108,6 @@ int mhi_async_power_up(struct mhi_controller 
>> *mhi_cntrl)
>> 
>>  	return 0;
>> 
>> -error_async_power_up:
>> -	mhi_deinit_free_irq(mhi_cntrl);
>> -
>>  error_setup_irq:
s/error_setup_irq/error_async_power_up
>>  	mhi_cntrl->pm_state = MHI_PM_DISABLE;
>>  	mutex_unlock(&mhi_cntrl->pm_mutex);
>> --
>> 2.25.1
>> 

-- 
Thanks,
Bhaumik
