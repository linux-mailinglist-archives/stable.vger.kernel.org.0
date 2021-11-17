Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A97454E75
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 21:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236577AbhKQUXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 15:23:39 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:15576 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240688AbhKQUXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 15:23:37 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1637180438; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=iDW0/PpVzqBrIpTiOg/sl2+bkXDtQf2fndlxXuRKWJA=; b=WirtO2inwAN62sMRWU/ZUgOtwj6LYuB0PQV0gf2raNheFXwgYOlfvFIhqYNxbaNhm+htCqeY
 wqKpV/+CV5T4PzHwfwBAmjwWbL2jPQUc71eYtXwG9PGAfmHt6Du09msCsdvBFuABi3BrzY8P
 F+WvjIzr3dT0uHiFwDt8BDUuM6c=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 61956415b920912d576b0038 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 17 Nov 2021 20:20:37
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0074FC43616; Wed, 17 Nov 2021 20:20:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [10.110.120.20] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5879FC4338F;
        Wed, 17 Nov 2021 20:20:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 5879FC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Subject: Re: [PATCH v2] bus: mhi: Fix race while handling SYS_ERR at power up
To:     Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        mhi@lists.linux.dev
Cc:     aleksander@aleksander.es, loic.poulain@linaro.org,
        thomas.perrot@bootlin.com, bbhatt@codeaurora.org,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org
References: <20211108174954.60569-1-manivannan.sadhasivam@linaro.org>
 <51338f3b-4c85-17b6-971b-44a50d59a262@codeaurora.org>
 <c6fd34ff-7f19-2ab1-ee3c-f6be178bf9a2@quicinc.com>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <53240ad1-06e0-fdec-c8f6-33a83e6ae2af@codeaurora.org>
Date:   Wed, 17 Nov 2021 12:20:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c6fd34ff-7f19-2ab1-ee3c-f6be178bf9a2@quicinc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/17/2021 9:24 AM, Jeffrey Hugo wrote:
> On 11/8/2021 12:06 PM, Hemant Kumar wrote:
>> Adding same comment in v2
>> On 11/8/2021 9:49 AM, Manivannan Sadhasivam wrote:
>>> Some devices tend to trigger SYS_ERR interrupt while the host handling
>>> SYS_ERR state of the device during power up. This creates a race
>>> condition and causes a failure in booting up the device.
>>>
>>> The issue is seen on the Sierra Wireless EM9191 modem during SYS_ERR
>>> handling in mhi_async_power_up(). Once the host detects that the device
>>> is in SYS_ERR state, it issues MHI_RESET and waits for the device to
>>> process the reset request. During this time, the device triggers SYS_ERR
>> Device is not triggering the SYS_ERR interrupt, interrupt was 
>> triggered due to MHI RESET was getting cleared by device.
> 
> Shouldn't the device state be RESET and not SYS_ERR at that point?
> 
> The device will enter SYS_ERR (and trigger an interrupt for that).  Host 
> issues MHI_RESET.  Device is expected to clear SYS_ERR and enter the 
> RESET state.  Then the device clears MHI_RESET.  Device can then trigger 
> an interrupt to signal the state change (per the updated spec).
Dmesg log was showing first sys err was triggered by device, as part of 
sys error handling host was setting MHI_RESET and expecting to get BHI 
Intvec. When BHI intvec was triggered by device, host handled it by 
checking the MHI status register. MHi status was still showing SYS_ERR 
being set (which was supposed to get cleared after host issuing MHI 
RESET). Due to that host side bhi intvec threaded handler took diff path 
to handle sys error again. This is what we are trying to avoid as we 
think for some reason device is not behaving as per spec and either 
setting sys err again or not clearing it by the time bhi intvec (for 
reset clear) is handled by host.
> 
> I was going to add my reviewed-by, but I'm confused by your comment.
> 
[..]

Thanks,
Hemant

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, a Linux Foundation Collaborative Project
