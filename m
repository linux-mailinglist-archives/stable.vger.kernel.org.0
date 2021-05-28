Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDDA393C81
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 06:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhE1E5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 00:57:22 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:41131 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhE1E5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 May 2021 00:57:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622177748; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=QjyA6rEH+Y4lxZCRKVeB1fd2Js19Cr+UydtbIw/v8Gg=;
 b=uIxVTD3zM9RK7rRYoC0U4W0cyr3yZufhqyl53L0awsl8YcyW5h8uCgTsfjeGngWJct5ejUsV
 L/j47DBrMhpT4gZKhXCc7LrBHumTFiX/GnZ76sckwpnB/JWYKgkI8uD9/VC3/e9StOpXzYZ2
 VFyP5lQuc0gXBlymXdWHkeFxCyQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 60b077bee27c0cc77f6ae161 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 28 May 2021 04:55:26
 GMT
Sender: jackp=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 82827C4338A; Fri, 28 May 2021 04:55:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: jackp)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 96EEEC433D3;
        Fri, 28 May 2021 04:55:24 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 27 May 2021 21:55:24 -0700
From:   jackp@codeaurora.org
To:     Peter Chen <peter.chen@kernel.org>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wesley Cheng <wcheng@codeaurora.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: gadget: Bail from dwc3_gadget_exit() if
 dwc->gadget is NULL
In-Reply-To: <20210528041210.GA20937@nchen>
References: <20210525042922.15591-1-jackp@codeaurora.org>
 <20210528041210.GA20937@nchen>
Message-ID: <788e5aead5b2e85b31296b15acb4a564@codeaurora.org>
X-Sender: jackp@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-05-27 21:12, Peter Chen wrote:
> On 21-05-24 21:29:22, Jack Pham wrote:
>> There exists a possible scenario in which dwc3_gadget_init() can fail:
>> during during host -> peripheral mode switch in dwc3_set_mode(), and
>> a pending gadget driver fails to bind.  Then, if the DRD undergoes
>> another mode switch from peripheral->host the resulting
>> dwc3_gadget_exit() will attempt to reference an invalid and dangling
>> dwc->gadget pointer as well as call dma_free_coherent() on unmapped
>> DMA pointers.
>> 
>> The exact scenario can be reproduced as follows:
>>  - Start DWC3 in peripheral mode
>>  - Configure ConfigFS gadget with FunctionFS instance (or use g_ffs)
>>  - Run FunctionFS userspace application (open EPs, write descriptors, 
>> etc)
>>  - Bind gadget driver to DWC3's UDC
>>  - Switch DWC3 to host mode
>>    => dwc3_gadget_exit() is called. usb_del_gadget() will put the
>> 	ConfigFS driver instance on the gadget_driver_pending_list
>>  - Stop FunctionFS application (closes the ep files)
>>  - Switch DWC3 to peripheral mode
>>    => dwc3_gadget_init() fails as usb_add_gadget() calls
>> 	check_pending_gadget_drivers() and attempts to rebind the UDC
>> 	to the ConfigFS gadget but fails with -19 (-ENODEV) because the
>> 	FFS instance is not in FFS_READY state.
> 
> There is no such state at enum ffs_state, you mean flag desc_ready is 
> not
> true, right?

Ah sorry! I meant FFS_ACTIVE, but you are also correct, it would be 
equivalent to
ffs_dev::desc_ready. Shall I amend this commit description?

>>  - Switch DWC3 back to host mode
>>    => dwc3_gadget_exit() is called again, but this time dwc->gadget
>> 	is invalid.
>> 
>> Although it can be argued that userspace should take responsibility
>> for ensuring that the FunctionFS application be ready prior to
>> allowing the composite driver bind to the UDC, failure to do so
>> should not result in a panic from the kernel driver.
>> 
>> Fix this by setting dwc->gadget to NULL in the failure path of
>> dwc3_gadget_init() and add a check to dwc3_gadget_exit() to bail out
>> unless the gadget pointer is valid.
>> 
>> Fixes: e81a7018d93a ("usb: dwc3: allocate gadget structure 
>> dynamically")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Jack Pham <jackp@codeaurora.org>
> 
> Reviewed-by: Peter Chen <peter.chen@kernel.org>

Thank you Peter!

>> ---
>> Hi Felipe,
>> 
>> Although I marked the 'Fixes' tag above to e81a7018d93a, the problem
>> theoretically exists prior to Peter's change. But I'm not sure how
>> best to fix on versions prior to this change since dwc->gadget used
>> to be an embedded struct so we can't do a simple NULL check as below.
>> Suggestions on alternative approaches welcome if we want to proceed
>> with backporting to older (pre-5.9) stable releases.
>> 
>> Thanks,
>> Jack
>> 
>>  drivers/usb/dwc3/gadget.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
>> index 612825a39f82..65d9b7227752 100644
>> --- a/drivers/usb/dwc3/gadget.c
>> +++ b/drivers/usb/dwc3/gadget.c
>> @@ -4046,6 +4046,7 @@ int dwc3_gadget_init(struct dwc3 *dwc)
>>  	dwc3_gadget_free_endpoints(dwc);
>>  err4:
>>  	usb_put_gadget(dwc->gadget);
>> +	dwc->gadget = NULL;
>>  err3:
>>  	dma_free_coherent(dwc->sysdev, DWC3_BOUNCE_SIZE, dwc->bounce,
>>  			dwc->bounce_addr);
>> @@ -4065,6 +4066,9 @@ int dwc3_gadget_init(struct dwc3 *dwc)
>> 
>>  void dwc3_gadget_exit(struct dwc3 *dwc)
>>  {
>> +	if (!dwc->gadget)
>> +		return;
>> +
>>  	usb_del_gadget(dwc->gadget);
>>  	dwc3_gadget_free_endpoints(dwc);
>>  	usb_put_gadget(dwc->gadget);
>> --
>> 2.24.0
>> 
