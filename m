Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9541E7EF2
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 15:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgE2Nlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 09:41:50 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:38157 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbgE2Nlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 May 2020 09:41:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590759710; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=KViCm2Ho/mcj5qFjh4q+UnAauXXP2sX2JGE/9Ofp+R8=; b=CyXqFCYw3axxTp+Uk06EI/vEMMMDb3nOMMBANFLyTSnJxWBPQ55Isu3DJ9p5qGsvoHwJsJ+H
 Cj3wDUYwNlM8wp7UpPDPWWKZJ0e9ETBV8CF32EqSYqktfhXH6I1qxcRrZkLRETqRE7wAvCQf
 4zDUtkUXOObxrQsZ8uS4KygAKGU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5ed1111cc0031c71c28b4539 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 May 2020 13:41:48
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B5B47C43387; Fri, 29 May 2020 13:41:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.0.106] (unknown [183.83.65.109])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: vbadigan)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 42EFEC433C9;
        Fri, 29 May 2020 13:41:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 42EFEC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=vbadigan@codeaurora.org
Subject: Re: [PATCH V1] mmc: sdhci-msm: Clear tuning done flag while hs400
 tuning
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>, Andy Gross <agross@kernel.org>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>
References: <1590678838-18099-1-git-send-email-vbadigan@codeaurora.org>
 <CAPDyKFpC+C32oa4ucNLWeEGJ8PDwzi+X55Lp7UqrHR--Yc47mw@mail.gmail.com>
From:   Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
Message-ID: <d4724d37-e762-ee07-f222-83bd6ac44e28@codeaurora.org>
Date:   Fri, 29 May 2020 19:11:36 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <CAPDyKFpC+C32oa4ucNLWeEGJ8PDwzi+X55Lp7UqrHR--Yc47mw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 5/29/2020 4:05 PM, Ulf Hansson wrote:
> On Thu, 28 May 2020 at 17:14, Veerabhadrarao Badiganti
> <vbadigan@codeaurora.org> wrote:
>> Clear tuning_done flag while executing tuning to ensure vendor
>> specific HS400 settings are applied properly when the controller
>> is re-initialized in HS400 mode.
>>
>> Without this, re-initialization of the qcom SDHC in HS400 mode fails
>> while resuming the driver from runtime-suspend or system-suspend.
>>
>> Fixes: ff06ce4 ("mmc: sdhci-msm: Add HS400 platform support")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
> Applied for next, thanks!
>
> Kind regards
> Uffe
Thanks Ulf.
I see a mail on this patch, that SHA in the commit text should be 12 digit.
Let me know if i have to re-post this patch by correcting it.
>> ---
>>   drivers/mmc/host/sdhci-msm.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
>> index 95cd973..b277dd7 100644
>> --- a/drivers/mmc/host/sdhci-msm.c
>> +++ b/drivers/mmc/host/sdhci-msm.c
>> @@ -1174,6 +1174,12 @@ static int sdhci_msm_execute_tuning(struct mmc_host *mmc, u32 opcode)
>>          msm_host->use_cdr = true;
>>
>>          /*
>> +        * Clear tuning_done flag before tuning to ensure proper
>> +        * HS400 settings.
>> +        */
>> +       msm_host->tuning_done = 0;
>> +
>> +       /*
>>           * For HS400 tuning in HS200 timing requires:
>>           * - select MCLK/2 in VENDOR_SPEC
>>           * - program MCLK to 400MHz (or nearest supported) in GCC
>> --
>> Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc., is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
>>
