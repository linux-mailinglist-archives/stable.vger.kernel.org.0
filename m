Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75A8307463
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 12:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhA1LEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 06:04:54 -0500
Received: from a1.mail.mailgun.net ([198.61.254.60]:54136 "EHLO
        a1.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhA1LEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 06:04:52 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611831865; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=j55mBQJ/9hjcHEw/ph7PjcJzIdxKFmME8IhZNJftkic=;
 b=FbDNzQuoN0C+nomt6YNm/+l3PagRArabwzHN1vwWbOuhvePzQ37kswDTENa8n5folUZIFeKu
 DXcU5CMRt6w/kIyg9YbUu1FbPkFWBLlzWqrR4KaY7guxLkDeu5CrovIhldjQdKCnuttAVcvR
 L9lqwvfReuCcN+1vBaCfXdPreFI=
X-Mailgun-Sending-Ip: 198.61.254.60
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 60129a20beacd1a25210f0d7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 28 Jan 2021 11:04:00
 GMT
Sender: saiprakash.ranjan=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7D6F4C43464; Thu, 28 Jan 2021 11:03:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: saiprakash.ranjan)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 74BD2C433ED;
        Thu, 28 Jan 2021 11:03:58 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 28 Jan 2021 16:33:58 +0530
From:   Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        jorge@foundries.io, linux-watchdog@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] watchdog: qcom: Remove incorrect usage of
 QCOM_WDT_ENABLE_IRQ
In-Reply-To: <161179763694.76967.7406861246436700530@swboyd.mtv.corp.google.com>
References: <20210126150241.10009-1-saiprakash.ranjan@codeaurora.org>
 <161179763694.76967.7406861246436700530@swboyd.mtv.corp.google.com>
Message-ID: <e3e9e4a9ef8adcf78d32f7996dc66083@codeaurora.org>
X-Sender: saiprakash.ranjan@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-01-28 07:03, Stephen Boyd wrote:
> Quoting Sai Prakash Ranjan (2021-01-26 07:02:41)
>> As per register documentation, QCOM_WDT_ENABLE_IRQ which is BIT(1)
>> of watchdog control register is wakeup interrupt enable bit and
>> not related to bark interrupt at all, BIT(0) is used for that.
>> So remove incorrect usage of this bit when supporting bark irq for
>> pre-timeout notification. Currently with this bit set and bark
>> interrupt specified, pre-timeout notification and/or watchdog
>> reset/bite does not occur.
> 
> It looks like the QCOM_WDT_ENABLE_IRQ bit is to catch a problem where a
> pending irq is unmasked but the watchdog irq isn't handled in time? So
> some sort of irq storm?
> 

In sleep mode, this bit is used to enable unmasked irq to wakeup
watchdog timer. The watchdog counter can be brought out of
reset either by writing 1 to WDOG_RESET or setting this BIT(1) to 1.

>> 
>> Fixes: 36375491a439 ("watchdog: qcom: support pre-timeout when the 
>> bark irq is available")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
>> ---
> 
> Reviewed-by: Stephen Boyd <swboyd@chromium.org>
> 

Thanks,
Sai

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a 
member
of Code Aurora Forum, hosted by The Linux Foundation
