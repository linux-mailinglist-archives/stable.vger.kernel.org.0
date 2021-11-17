Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29040454BE9
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 18:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhKQR1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 12:27:51 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:62600 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhKQR1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 12:27:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1637169888; x=1668705888;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=XnPCJf0THVJ9hRVhF4BPjBGLBcwuLrt5ifTcsrDfG9g=;
  b=AMBQ/dccJ+uy2Qvxnu56umLsNGxPXiJlET3CsZx8n/DS1NEAhwkxJ/2Z
   4ueX7lPGANUBTmZXMoa62aPH+qDr46MGjiOivsXCLmwyENlVzWsfIzF1W
   WK/U3Z9rttt3Q2tDgcaoBFXU/jWhOlxbFCD0LuZvFhWeq+KnDFkqNatZP
   8=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 17 Nov 2021 09:24:47 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 09:24:46 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Wed, 17 Nov 2021 09:24:46 -0800
Received: from [10.226.59.216] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Wed, 17 Nov
 2021 09:24:45 -0800
Subject: Re: [PATCH v2] bus: mhi: Fix race while handling SYS_ERR at power up
To:     Hemant Kumar <hemantk@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        <mhi@lists.linux.dev>
CC:     <aleksander@aleksander.es>, <loic.poulain@linaro.org>,
        <thomas.perrot@bootlin.com>, <bbhatt@codeaurora.org>,
        <linux-arm-msm@vger.kernel.org>, <stable@vger.kernel.org>
References: <20211108174954.60569-1-manivannan.sadhasivam@linaro.org>
 <51338f3b-4c85-17b6-971b-44a50d59a262@codeaurora.org>
From:   Jeffrey Hugo <quic_jhugo@quicinc.com>
Message-ID: <c6fd34ff-7f19-2ab1-ee3c-f6be178bf9a2@quicinc.com>
Date:   Wed, 17 Nov 2021 10:24:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <51338f3b-4c85-17b6-971b-44a50d59a262@codeaurora.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/8/2021 12:06 PM, Hemant Kumar wrote:
> Adding same comment in v2
> On 11/8/2021 9:49 AM, Manivannan Sadhasivam wrote:
>> Some devices tend to trigger SYS_ERR interrupt while the host handling
>> SYS_ERR state of the device during power up. This creates a race
>> condition and causes a failure in booting up the device.
>>
>> The issue is seen on the Sierra Wireless EM9191 modem during SYS_ERR
>> handling in mhi_async_power_up(). Once the host detects that the device
>> is in SYS_ERR state, it issues MHI_RESET and waits for the device to
>> process the reset request. During this time, the device triggers SYS_ERR
> Device is not triggering the SYS_ERR interrupt, interrupt was triggered 
> due to MHI RESET was getting cleared by device.

Shouldn't the device state be RESET and not SYS_ERR at that point?

The device will enter SYS_ERR (and trigger an interrupt for that).  Host 
issues MHI_RESET.  Device is expected to clear SYS_ERR and enter the 
RESET state.  Then the device clears MHI_RESET.  Device can then trigger 
an interrupt to signal the state change (per the updated spec).

I was going to add my reviewed-by, but I'm confused by your comment.

>> interrupt to the host and host starts handling SYS_ERR execution.
> "As interrupts are setup, MHI reset results in device clearing the reset 
> and it sends incoming BHI interrupt with state still seen as SYS_ERROR 
> instead of READY."
> 
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
>> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>> ---
> [..]

