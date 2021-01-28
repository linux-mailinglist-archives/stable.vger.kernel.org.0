Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E69B307472
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 12:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhA1LI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 06:08:57 -0500
Received: from a1.mail.mailgun.net ([198.61.254.60]:49758 "EHLO
        a1.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhA1LI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 06:08:56 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611832118; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=7S5azOzwX8e049MI5M6Veu02TXu2AvF+W2vCd/OZNWw=;
 b=j0WwNGovY43otpZHyNRgHrKNaYI9vwtCLjBN+ZC9iz/CNFQK25DmUzT0U+yg11kAHRLqb22a
 8DVdDCpl3LXt78SC3t3NIIjod8Zy5D92XTZ0nHrXw73KfD83nj+nmAJmFNBYY8RMLdAeTbtO
 JGMKmq85wwKl4UMiDYEwy1rV0PQ=
X-Mailgun-Sending-Ip: 198.61.254.60
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60129b1583b274b0af07cef9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 28 Jan 2021 11:08:05
 GMT
Sender: saiprakash.ranjan=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EE464C43463; Thu, 28 Jan 2021 11:08:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: saiprakash.ranjan)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 27706C433CA;
        Thu, 28 Jan 2021 11:08:04 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 28 Jan 2021 16:38:04 +0530
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
In-Reply-To: <20210128081924.GA30289@trex>
References: <20210126150241.10009-1-saiprakash.ranjan@codeaurora.org>
 <20210128081924.GA30289@trex>
Message-ID: <72cdf644c431b7b605f9d15a4a7fb7b8@codeaurora.org>
X-Sender: saiprakash.ranjan@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-01-28 13:49, Jorge Ramirez-Ortiz, Foundries wrote:
> On 26/01/21, Sai Prakash Ranjan wrote:
>> As per register documentation, QCOM_WDT_ENABLE_IRQ which is BIT(1)
>> of watchdog control register is wakeup interrupt enable bit and
>> not related to bark interrupt at all, BIT(0) is used for that.
>> So remove incorrect usage of this bit when supporting bark irq for
>> pre-timeout notification. Currently with this bit set and bark
>> interrupt specified, pre-timeout notification and/or watchdog
>> reset/bite does not occur.
>> 
>> Fixes: 36375491a439 ("watchdog: qcom: support pre-timeout when the 
>> bark irq is available")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
>> ---
>> 
>> Reading the conversations from when qcom pre-timeout support was
>> added [1], Bjorn already had mentioned it was not right to touch this
>> bit, not sure which SoC the pre-timeout was tested on at that time,
>> but I have tested this on SDM845, SM8150, SC7180 and watchdog bark
>> and bite does not occur with enabling this bit with the bark irq
>> specified in DT.
> 
> this was tested on QCS404. have you validated there? unfortunately I
> no longer have access to that hardware or the documentation
> 

I didn't validate on qcs404 yet since I didn't have access to it.
But now that you mention it, let me arrange for a setup and test it
there as well. Note: I did not see bark irq entry in upstream qcs404
dtsi, so you must have had some local change when you tested?

Thanks,
Sai

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a 
member
of Code Aurora Forum, hosted by The Linux Foundation
