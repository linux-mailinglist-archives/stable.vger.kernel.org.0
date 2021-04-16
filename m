Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F71A36283C
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 21:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240420AbhDPTGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 15:06:23 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:60217 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239901AbhDPTGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 15:06:23 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618599958; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=rLW2TDeU0Ndoi+Jgm2T0k+opB3RGan5znN4IbWOu1Yw=; b=jTloFo4T++CylfzIxdnVPPfSaTfF34jrq84HKPc4j9Nr44wC+9MxPdqB2bPgTPOsgaWEQbIL
 wckM0/SMJnJLXK5lx3/9QPs0p2JNqSGu/6cIftFsSPZC7wDy6iqvU5F92r3skD7gzraFFKAY
 jYZ3jEb4sGHOxyqFgH6YtEP7u8Y=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 6079e010215b831afbe5efc9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 16 Apr 2021 19:05:52
 GMT
Sender: wcheng=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CE34CC43463; Fri, 16 Apr 2021 19:05:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.110.95.130] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wcheng)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B25FEC433CA;
        Fri, 16 Apr 2021 19:05:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B25FEC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=wcheng@codeaurora.org
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
To:     Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
 <87zgxymrph.fsf@kernel.org>
From:   Wesley Cheng <wcheng@codeaurora.org>
Message-ID: <63f0d8c2-1272-51a5-8f0b-8ae663ab5b94@codeaurora.org>
Date:   Fri, 16 Apr 2021 12:05:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <87zgxymrph.fsf@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/16/2021 3:47 AM, Felipe Balbi wrote:
> 
> Hi,
> 
> Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
> 
>> From: Yu Chen <chenyu56@huawei.com>
>> From: John Stultz <john.stultz@linaro.org>
>>
>> According to the programming guide, to switch mode for DRD controller,
>> the driver needs to do the following.
>>
>> To switch from device to host:
>> 1. Reset controller with GCTL.CoreSoftReset
>> 2. Set GCTL.PrtCapDir(host mode)
>> 3. Reset the host with USBCMD.HCRESET
>> 4. Then follow up with the initializing host registers sequence
>>
>> To switch from host to device:
>> 1. Reset controller with GCTL.CoreSoftReset
>> 2. Set GCTL.PrtCapDir(device mode)
>> 3. Reset the device with DCTL.CSftRst
>> 4. Then follow up with the initializing registers sequence
>>
>> Currently we're missing step 1) to do GCTL.CoreSoftReset and step 3) of
>> switching from host to device. John Stult reported a lockup issue seen
>> with HiKey960 platform without these steps[1]. Similar issue is observed
>> with Ferry's testing platform[2].
>>
>> So, apply the required steps along with some fixes to Yu Chen's and John
>> Stultz's version. The main fixes to their versions are the missing wait
>> for clocks synchronization before clearing GCTL.CoreSoftReset and only
>> apply DCTL.CSftRst when switching from host to device.
>>
>> [1] https://lore.kernel.org/linux-usb/20210108015115.27920-1-john.stultz@linaro.org/
>> [2] https://lore.kernel.org/linux-usb/0ba7a6ba-e6a7-9cd4-0695-64fc927e01f1@gmail.com/
>>
>> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
>> Cc: Ferry Toth <fntoth@gmail.com>
>> Cc: Wesley Cheng <wcheng@codeaurora.org>
>> Cc: <stable@vger.kernel.org>
>> Fixes: 41ce1456e1db ("usb: dwc3: core: make dwc3_set_mode() work properly")
>> Signed-off-by: Yu Chen <chenyu56@huawei.com>
>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> 
> I still have concerns about the soft reset, but I won't block you guys
> from fixing Hikey's problem :-)
> 
> The only thing I would like to confirm is that this has been verified
> with hundreds of swaps happening as quickly as possible. DWC3 should
> still be functional after several hundred swaps.
> 
> Can someone confirm this is the case? (I'm assuming this can be
> scripted)
> 
Hi Thinh/Felipe,

Thanks Thinh for this change.  Will verify this on our platform as well
with a mode switch loop over the weekend.

Thanks
Wesley Cheng
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
