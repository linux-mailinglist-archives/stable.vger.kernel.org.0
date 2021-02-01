Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0BB30A1FB
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 07:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhBAGeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 01:34:19 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:20157 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231636AbhBAGYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 01:24:12 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612160571; h=Message-ID: Subject: Cc: To: From: Date:
 Content-Transfer-Encoding: Content-Type: MIME-Version: Sender;
 bh=Jh17zm3LJ/fkvFZiP2D/oYzmhX3zrbE4xBRWshtxx68=; b=rww3hPpdWNwmx25GoZW587BShVdmqamIdVcgJ1KQbz+6fv+cerkdQcFuyzbsM/DDVM8CKkYZ
 TCXbEQW//XwWfcuVyCh0BZVu5LASy2CJLvWCDF+KymmRlcj/Ev6lrUjqqo8Jbzl1gpRpjli2
 oYDZnKa6vw6kNc6Q59ZyWdBqNxM=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 6017976aab96aecb9f17f400 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 01 Feb 2021 05:53:46
 GMT
Sender: saiprakash.ranjan=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 75039C43462; Mon,  1 Feb 2021 05:53:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: saiprakash.ranjan)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A7E24C433CA;
        Mon,  1 Feb 2021 05:53:45 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 01 Feb 2021 11:23:45 +0530
From:   Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
To:     "Jorge Ramirez-Ortiz, Foundries" <jorge@foundries.io>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-watchdog@vger.kernel.org,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] watchdog: qcom: Remove incorrect usage of
 QCOM_WDT_ENABLE_IRQ
Message-ID: <7e30acdb750c44d30d5903e0d2afa641@codeaurora.org>
X-Sender: saiprakash.ranjan@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-01-31 22:33, Jorge Ramirez-Ortiz, Foundries wrote:
> On 28/01/21, Sai Prakash Ranjan wrote:
>> On 2021-01-28 13:49, Jorge Ramirez-Ortiz, Foundries wrote:
>> > On 26/01/21, Sai Prakash Ranjan wrote:
>> > > As per register documentation, QCOM_WDT_ENABLE_IRQ which is BIT(1)
>> > > of watchdog control register is wakeup interrupt enable bit and
>> > > not related to bark interrupt at all, BIT(0) is used for that.
>> > > So remove incorrect usage of this bit when supporting bark irq for
>> > > pre-timeout notification. Currently with this bit set and bark
>> > > interrupt specified, pre-timeout notification and/or watchdog
>> > > reset/bite does not occur.
>> > >
>> > > Fixes: 36375491a439 ("watchdog: qcom: support pre-timeout when the
>> > > bark irq is available")
>> > > Cc: stable@vger.kernel.org
>> > > Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
>> > > ---
>> > >
>> > > Reading the conversations from when qcom pre-timeout support was
>> > > added [1], Bjorn already had mentioned it was not right to touch this
>> > > bit, not sure which SoC the pre-timeout was tested on at that time,
>> > > but I have tested this on SDM845, SM8150, SC7180 and watchdog bark
>> > > and bite does not occur with enabling this bit with the bark irq
>> > > specified in DT.
>> >
>> > this was tested on QCS404. have you validated there? unfortunately I
>> > no longer have access to that hardware or the documentation
>> >
>> 
>> I didn't validate on qcs404 yet since I didn't have access to it.
>> But now that you mention it, let me arrange for a setup and test it
>> there as well. Note: I did not see bark irq entry in upstream qcs404
>> dtsi, so you must have had some local change when you tested?
> 
> TBH I dont quite remember. I suppose that if those with access to the
> documents and hardware are OK with this change then it shouldnt cause
> regressions (I just cant check from my end)
> 

No worries, I got the documentation access now and it is the same as
other SoCs which I have tested above, meaning the BIT(1) is not related
to bark irq. I am arranging a setup as well now, it took some time as
I don't work on QCS* chipsets but I can confirm by this week.

Thanks,
Sai

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a 
member
of Code Aurora Forum, hosted by The Linux Foundation
