Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71397369EB6
	for <lists+stable@lfdr.de>; Sat, 24 Apr 2021 06:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhDXERN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Apr 2021 00:17:13 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:61157 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231781AbhDXERM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Apr 2021 00:17:12 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619237795; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: References: Cc: To: From:
 Subject: Sender; bh=1GO/BHrD+uoX9nHzeuPKjOTdCUh7DzWsv7hYDHfSgzs=; b=PaH5o9AqSWRxkA/7a/HdJy5WzOOodK4BKswuL7oZx5AoQ30vmUgKsN1hINEZkWJ8akyp0yr1
 DJ8UMx06bac5YX2tZyUS6eJaijjjWg/vfThwjxeMCAznojMy+FkrqTKQZuQqgDI1bbUGJOd1
 c73B3TzJGSIHlkn9GX1+UKikpEg=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60839b9c2cc44d3aeaa71c7b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 24 Apr 2021 04:16:28
 GMT
Sender: wcheng=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9F92BC433F1; Sat, 24 Apr 2021 04:16:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [10.110.110.218] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wcheng)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 38F36C433F1;
        Sat, 24 Apr 2021 04:16:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 38F36C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=wcheng@codeaurora.org
Subject: Re: [PATCH v2] usb: gadget: Fix double free of device descriptor
 pointers
From:   Wesley Cheng <wcheng@codeaurora.org>
To:     Felipe Balbi <balbi@kernel.org>, gregkh@linuxfoundation.org,
        peter.chen@kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>, stable@vger.kernel.org
References: <1619034452-17334-1-git-send-email-wcheng@codeaurora.org>
 <87lf9amvl5.fsf@kernel.org>
 <c5599433-3eb0-3918-d93b-6860f7951e92@codeaurora.org>
Message-ID: <69253e54-771b-3b1c-1765-77bfb6288715@codeaurora.org>
Date:   Fri, 23 Apr 2021 21:16:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <c5599433-3eb0-3918-d93b-6860f7951e92@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/23/2021 12:10 PM, Wesley Cheng wrote:
> 
> 
> On 4/22/2021 4:01 AM, Felipe Balbi wrote:
>>
>> Hi,
>>
>> Wesley Cheng <wcheng@codeaurora.org> writes:
>>
>>> From: Hemant Kumar <hemantk@codeaurora.org>
>>>
>>> Upon driver unbind usb_free_all_descriptors() function frees all
>>> speed descriptor pointers without setting them to NULL. In case
>>> gadget speed changes (i.e from super speed plus to super speed)
>>> after driver unbind only upto super speed descriptor pointers get
>>> populated. Super speed plus desc still holds the stale (already
>>> freed) pointer. Fix this issue by setting all descriptor pointers
>>> to NULL after freeing them in usb_free_all_descriptors().
>>
>> could you describe this a little better? How can one trigger this case?
>> Is the speed demotion happening after unbinding? It's not clear how to
>> cause this bug.
>>
> Hi Felipe,
> 
> Internally, we have a mechanism to switch the DWC3 core maximum speed
> parameter dynamically for displayport use cases.  This issue happens
> whenever we have a maximum speed change occur on the USB gadget, which
> for DWC3 happens whenever we call gadget init.  When we switch in and
> out of host mode, gadget init is being executed, leading to the change
> in the USB gadget max speed parameter:
> 
> dwc->gadget->max_speed		= dwc->maximum_speed;
> 
> I know that configFS gadget has the max_speed sysfs file, which is a
> similar mechanism, but I haven't tried to see if we can reproduce the
> same issue with it.  Let me see if we can reproduce this with that
> configfs speed setting.
> 
> Thanks
> Wesley Cheng
> 

Hi Felipe,

So I tried with doing it through the configFS max_speed, but it doesn't
have the same effect, as the setting done in dwc3_gadget_init() will
still be assigning the composite/UDC device's maximum speed to SSP/SS.
This is what the usb_assign_descriptor() uses to determine whether or
not to copy the SSP and SS descriptors.

So in summary, at least for a DWC3 based subsystem, the only way to
reproduce it is if there is a way to dynamically switch the DWC3 core
max speed parameter.

Thanks
Wesley Cheng

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
