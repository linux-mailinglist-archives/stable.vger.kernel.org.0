Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E14030431D
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 16:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391851AbhAZPy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 10:54:29 -0500
Received: from a1.mail.mailgun.net ([198.61.254.60]:20218 "EHLO
        a1.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403872AbhAZPyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 10:54:13 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611676429; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=mzFvspRxkqW9r0yBnxFG0ENYSFgGVzgg2SkmuFkOpd4=;
 b=cJlcaAxKWd0b2k0JO2HaovSY667+lKojQRAZW97nZ7o3ohpYsz+GpgVvFASgIDX2jRx8Nu+6
 +GtgAj+65+koiWNMtuWIdJ1eMNSjyDi0iCHCht/WSzTqkYJPQ/CKVc9Dn8/tG8K4Fin6+DWL
 ZR1mP/jKM4uONmofQFXx7A/BXPw=
X-Mailgun-Sending-Ip: 198.61.254.60
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60103aea2c36b2106d328e43 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 26 Jan 2021 15:53:14
 GMT
Sender: saiprakash.ranjan=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CDED8C43465; Tue, 26 Jan 2021 15:53:13 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: saiprakash.ranjan)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0B9C8C433ED;
        Tue, 26 Jan 2021 15:53:12 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 26 Jan 2021 21:23:12 +0530
From:   Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-watchdog@vger.kernel.org,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        jorge@foundries.io, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH] watchdog: qcom: Remove incorrect usage of
 QCOM_WDT_ENABLE_IRQ
In-Reply-To: <1c9d5e19-7ddd-345d-aa2d-b4fb48d9b4df@roeck-us.net>
References: <20210126150241.10009-1-saiprakash.ranjan@codeaurora.org>
 <1c9d5e19-7ddd-345d-aa2d-b4fb48d9b4df@roeck-us.net>
Message-ID: <65015f8aa75efa6ead7dd7df45eb31d7@codeaurora.org>
X-Sender: saiprakash.ranjan@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-01-26 20:53, Guenter Roeck wrote:
> On 1/26/21 7:02 AM, Sai Prakash Ranjan wrote:
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
> 
> Assuming that pretimeout _does_ work with this patch applied,
> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> 

Thanks Guenter. Yes I have patchset ready and tested [1] on 4
different SoCs on which pretimeout works with this patch and without
this, watchdog functionality would be broken on all those platforms
and possibly more(the ones I couldn't get access to) if we add bark
irq to the watchdog DT node.

[1] https://lore.kernel.org/patchwork/cover/1371270/

Thanks,
Sai

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a 
member
of Code Aurora Forum, hosted by The Linux Foundation
