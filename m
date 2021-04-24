Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B9036A036
	for <lists+stable@lfdr.de>; Sat, 24 Apr 2021 10:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbhDXIiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Apr 2021 04:38:11 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:33357 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbhDXIiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Apr 2021 04:38:10 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619253453; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=tOdeQlxOG0ea0KSqy8XicLj+TJYpvhk7DXB3N0ZtQmU=; b=FuMNfmlhpolXHFfohAloZ26/8OgaDFwV8OVDnO7ITUlQ8F5caGGKXNmtfxWp3WBtxz5LjSus
 xE39hdey6lpHNmkDDhiHe9z7Rem+ZR07YQczdOJ10xVTbEYw4JP4bWYQFzrAnBrrTrtm99Ge
 4BW9zuNiZ24tdpHBEXK8FAzozWc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 6083d8cc2cbba88980c56a66 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 24 Apr 2021 08:37:32
 GMT
Sender: wcheng=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7E05DC43460; Sat, 24 Apr 2021 08:37:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [10.110.54.5] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wcheng)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1EA9DC433F1;
        Sat, 24 Apr 2021 08:37:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1EA9DC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=wcheng@codeaurora.org
Subject: Re: [PATCH v2] usb: gadget: Fix double free of device descriptor
 pointers
To:     Felipe Balbi <balbi@kernel.org>, gregkh@linuxfoundation.org,
        peter.chen@kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>, stable@vger.kernel.org
References: <1619034452-17334-1-git-send-email-wcheng@codeaurora.org>
 <87lf9amvl5.fsf@kernel.org>
 <c5599433-3eb0-3918-d93b-6860f7951e92@codeaurora.org>
 <69253e54-771b-3b1c-1765-77bfb6288715@codeaurora.org>
 <87sg3gksyy.fsf@kernel.org>
From:   Wesley Cheng <wcheng@codeaurora.org>
Message-ID: <029267dd-69fb-1f07-b6ff-3384d56c9f89@codeaurora.org>
Date:   Sat, 24 Apr 2021 01:37:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <87sg3gksyy.fsf@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/24/2021 1:05 AM, Felipe Balbi wrote:
> 
> Hi,
> 
> Wesley Cheng <wcheng@codeaurora.org> writes:
>>>>> From: Hemant Kumar <hemantk@codeaurora.org>
>>>>>
>>>>> Upon driver unbind usb_free_all_descriptors() function frees all
>>>>> speed descriptor pointers without setting them to NULL. In case
>>>>> gadget speed changes (i.e from super speed plus to super speed)
>>>>> after driver unbind only upto super speed descriptor pointers get
>>>>> populated. Super speed plus desc still holds the stale (already
>>>>> freed) pointer. Fix this issue by setting all descriptor pointers
>>>>> to NULL after freeing them in usb_free_all_descriptors().
>>>>
>>>> could you describe this a little better? How can one trigger this case?
>>>> Is the speed demotion happening after unbinding? It's not clear how to
>>>> cause this bug.
>>>>
>>> Hi Felipe,
>>>
>>> Internally, we have a mechanism to switch the DWC3 core maximum speed
>>> parameter dynamically for displayport use cases.  This issue happens
>>> whenever we have a maximum speed change occur on the USB gadget, which
>>> for DWC3 happens whenever we call gadget init.  When we switch in and
>>> out of host mode, gadget init is being executed, leading to the change
>>> in the USB gadget max speed parameter:
>>>
>>> dwc->gadget->max_speed		= dwc->maximum_speed;
>>>
>>> I know that configFS gadget has the max_speed sysfs file, which is a
>>> similar mechanism, but I haven't tried to see if we can reproduce the
>>> same issue with it.  Let me see if we can reproduce this with that
>>> configfs speed setting.
>>>
>>> Thanks
>>> Wesley Cheng
>>>
>>
>> Hi Felipe,
>>
>> So I tried with doing it through the configFS max_speed, but it doesn't
>> have the same effect, as the setting done in dwc3_gadget_init() will
>> still be assigning the composite/UDC device's maximum speed to SSP/SS.
>> This is what the usb_assign_descriptor() uses to determine whether or
>> not to copy the SSP and SS descriptors.
>>
>> So in summary, at least for a DWC3 based subsystem, the only way to
>> reproduce it is if there is a way to dynamically switch the DWC3 core
>> max speed parameter.
> 
> Could it be that you have a bug in your out-of-tree changes? Perhaps
> there's some assumption which your changes aren't guaranteeing.
> 
Hi Felipe,

Unless there is a limitation on how the USB gadget max speed can be
used, i.e. the USB gadget max speed MUST stay the same throughout a
device's boot period, then our out of tree changes may have the wrong
assumptions.  However, I don't see that stated anywhere, and I still
feel the current usb_assign_descriptors() and usb_free_all_descriptors()
aren't aligned with one another.  One API decides which descriptors to
copy based on a parameter, whereas the other just frees all of them
irrespective.

Thanks
Wesley Cheng


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
