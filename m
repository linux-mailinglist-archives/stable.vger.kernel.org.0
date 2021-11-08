Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C588449BB4
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 19:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbhKHSgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 13:36:46 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:13147 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbhKHSgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 13:36:45 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1636396440; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=YNYLKOcQzfrLGLWCR+JmGKCT7Y7yNqhgbxyW8muIYjs=; b=MgusSY/0eyjtofCmamgCBaEqnzjsw9FvwiNVBU58cA9zJnWSG9TW2YyaYXFx+uFPwHFgM1wC
 cJEyTh+FjaDkWIatyPuzS2I4NdvnBkm/ArX+6+hb++cPt7rcWy0xeKkanSts1DQ33M11Mopa
 +/Q6KwSt9oIrlFQsG7uaVcZjb2Q=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 61896d886b778b5a19e40e01 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Nov 2021 18:33:44
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 36833C43617; Mon,  8 Nov 2021 18:33:44 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.1.5] (cpe-76-176-73-171.san.res.rr.com [76.176.73.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A9117C43460;
        Mon,  8 Nov 2021 18:33:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org A9117C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Subject: Re: [PATCH] bus: mhi: Fix race while handling SYS_ERR at power up
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        mhi@lists.linux.dev
Cc:     aleksander@aleksander.es, loic.poulain@linaro.org,
        thomas.perrot@bootlin.com, bbhatt@codeaurora.org,
        quic_jhugo@quicinc.com, linux-arm-msm@vger.kernel.org,
        stable@vger.kernel.org
References: <20211108174142.52835-1-manivannan.sadhasivam@linaro.org>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <3f6350a1-860a-1f57-0128-c92d348220d3@codeaurora.org>
Date:   Mon, 8 Nov 2021 10:33:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211108174142.52835-1-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/8/2021 9:41 AM, Manivannan Sadhasivam wrote:
> Some devices tend to trigger SYS_ERR interrupt while the host handling
> SYS_ERR state of the device during power up. This creates a race
> condition and causes a failure in booting up the device.
> 
> The issue is seen on the Sierra Wireless EM9191 modem during SYS_ERR
> handling in mhi_async_power_up(). Once the host detects that the device
> is in SYS_ERR state, it issues MHI_RESET and waits for the device to
> process the reset request. During this time, the device triggers SYS_ERR
Device is not triggering the SYS_ERR interrupt, interrupt was triggered 
due to MHI RESET was getting cleared by device.
> interrupt to the host and host starts handling SYS_ERR execution.


"As interrupts are setup, MHI reset results in device clearing the reset 
and it sends incoming BHI interrupt with state still seen as SYS_ERROR 
instead of READY."

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
[..]
Thanks,
Hemant
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, a Linux Foundation Collaborative Project
