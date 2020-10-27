Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EB129A46F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 07:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506171AbgJ0GEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 02:04:12 -0400
Received: from z5.mailgun.us ([104.130.96.5]:58918 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506170AbgJ0GEL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 02:04:11 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603778650; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=seJtKEfy2PjEDmV0fkPjUuKiYBaNPY4Fk2XrqHU+wXM=; b=k7E5F5uy4t/jRM6TOyOMN9iT17gcuz+B3HNuJpdFImrUTYcQq/Iexsd/bPvAm/ou/XBx969V
 ONgpU/jQRAM7HLfUPrWyPiQK1ZWXlFp4ljMUq+MH0iyHQRkgaXjCJJddy/4zQ8fSfACxoocD
 bmONrpjHsVz8lFwF4ZMh6mS/EYk=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f97b859fcd46a2b76b2dbed (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 27 Oct 2020 06:04:09
 GMT
Sender: sallenki=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D847DC433C9; Tue, 27 Oct 2020 06:04:09 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.0
Received: from [192.168.0.105] (unknown [103.110.145.213])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sallenki)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 99DC7C433F0;
        Tue, 27 Oct 2020 06:04:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 99DC7C433F0
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sallenki@codeaurora.org
Subject: Re: [PATCH] usb: typec: Prevent setting invalid opmode value
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, jackp@codeaurora.org,
        mgautam@codeaurora.org, stable@vger.kernel.org
References: <1603359734-2931-1-git-send-email-sallenki@codeaurora.org>
 <20201026130522.GC1442058@kuha.fi.intel.com>
From:   Sriharsha Allenki <sallenki@codeaurora.org>
Message-ID: <c82b0b9d-209e-2fbd-2e3b-85e8fc688f5f@codeaurora.org>
Date:   Tue, 27 Oct 2020 11:34:04 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201026130522.GC1442058@kuha.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Heikki,

Thanks a lot for the review.

On 10/26/2020 6:35 PM, Heikki Krogerus wrote:
> On Thu, Oct 22, 2020 at 03:12:14PM +0530, Sriharsha Allenki wrote:
>> Setting opmode to invalid values would lead to a
>> paging fault failure when there is an access to the
>> power_operation_mode.
>>
>> Prevent this by checking the validity of the value
>> that the opmode is being set.
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: fab9288428ec ("usb: USB Type-C connector class")
>> Signed-off-by: Sriharsha Allenki <sallenki@codeaurora.org>
>> ---
>>  drivers/usb/typec/class.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
>> index 35eec70..63efe16 100644
>> --- a/drivers/usb/typec/class.c
>> +++ b/drivers/usb/typec/class.c
>> @@ -1427,7 +1427,8 @@ void typec_set_pwr_opmode(struct typec_port *port,
>>  {
>>  	struct device *partner_dev;
>>  
>> -	if (port->pwr_opmode == opmode)
>> +	if ((port->pwr_opmode == opmode) || (opmode < TYPEC_PWR_MODE_USB) ||
> You don't need to check if opmode < anything. opmode is enum which
> apparently means that GCC handles it as unsigned. Since
> TYPEC_PWR_MODE_USB is 0 it means opmode < TYPEC_PWR_MODE_USB is never
> true.
>
>> +						(opmode > TYPEC_PWR_MODE_PD))
>>  		return;
> You really need to print an error at the very least. Otherwise we will
> just silently hide possible driver bugs.
>
> To be honest, I'm not a big fan of this kind of checks. They have
> created more problems than they have fixed in more than one occasion
> to me. For example, there really is no guarantee that the maximum will
> always be TYPEC_PWR_MODE_PD, which means we probable should have
> something like TYPEC_PWR_MODE_MAX defined somewhere that you compare
> the opmode value to instead of TYPEC_PWR_MODE_PD to play it safe, but
> let's not bother with that for now (it will create other problems).
>
> Basically, with functions like this, especially since it doesn't
> return anything, the responsibility of checking the validity of the
> parameters that the caller supplies to it belongs to the caller IMO,
> not the function itself. I would be happy to explain that in the
> kernel doc style comment of the function.
>
> If you still feel that this change is really necessary, meaning you
> have some actual case where the caller can _not_ check the range
> before calling this function, then explain the case you have carefully
> in the commit message and add the check as a separate condition:
We had a bug that was setting this out of index opmode leading to the
mentioned paging fault, and as you have suggested we could have added
the range check there and prevented this. But there are many calls to
this function, and I thought it would be a good idea to abstract that
range check into this function to prevent adding multiple range checks
over the driver. And further motivation was also to prevent any
potential unknown bugs.

I will resend the patch with the suggested changes; separate condition and
anerror statement if the above justification is acceptable, else will
propose a patch to improve the documentation.

Thanks,
Sriharsha
>
> diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
> index 35eec707cb512..7de6913d90f9c 100644
> --- a/drivers/usb/typec/class.c
> +++ b/drivers/usb/typec/class.c
> @@ -1430,6 +1430,11 @@ void typec_set_pwr_opmode(struct typec_port *port,
>         if (port->pwr_opmode == opmode)
>                 return;
>  
> +       if (opmode > TYPEC_PWR_OPMODE_PD) {
> +               dev_err(&port->dev, "blah-blah-blah\n");
> +               return;
> +       }
> +
>         port->pwr_opmode = opmode;
>         sysfs_notify(&port->dev.kobj, NULL, "power_operation_mode");
>         kobject_uevent(&port->dev.kobj, KOBJ_CHANGE);
>
> Otherwise you can just propose a patch that improves the documentation
> of this function, explaining that it does not take any responsibility
> over the parameters passed to it for now.
>
>
> thanks,
>
-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

