Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C97F17CDA3
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 11:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgCGK2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 05:28:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgCGK2j (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Mar 2020 05:28:39 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 046572070A;
        Sat,  7 Mar 2020 10:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583576919;
        bh=Auhh6iI/DDfWNI7n3u+arTdUTgq4hpvsJQwbTY+e7Rk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y8l0ANS7LCE+9KcwoW4Og8IwYAj/1Te2Qz0I8fnP5Gwk0rkpj8+pX7CY03taEnIxX
         vyg7AlqOhCjUY1qO1X0h7ZSXzK9yqkwsZvIqYFpobzPDkCX88jqXcUATIZeZf0529a
         P5TCHEglOLftfmGitq4rdWs387WiyKaPY8Qz7Vq8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jAWhB-00AoVk-9Y; Sat, 07 Mar 2020 10:28:37 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 07 Mar 2020 10:28:37 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, Lina Iyer <ilina@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>, stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: qcom: Guard irq_eoi()
In-Reply-To: <20200307010617.GV1214176@minitux>
References: <20200306121221.1231296-1-linus.walleij@linaro.org>
 <20200307010617.GV1214176@minitux>
Message-ID: <192755295564e420cba667e58bbb915f@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: bjorn.andersson@linaro.org, linus.walleij@linaro.org, linux-gpio@vger.kernel.org, ilina@codeaurora.org, swboyd@chromium.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-03-07 01:06, Bjorn Andersson wrote:
> On Fri 06 Mar 04:12 PST 2020, Linus Walleij wrote:
> 
>> In the commit setting up the qcom/msm pin controller to
>> be hierarchical some callbacks were careful to check that
>> d->parent_data on irq_data was valid before calling the
>> parent function, however irq_chip_eoi_parent() was called
>> unconditionally which doesn't work with elder Qualcomm
>> platforms such as APQ8060.
>> 
>> When the drivers/mfd/qcom-pm8xxx.c driver calls
>> chained_irq_exit() that call will in turn call chip->irq_eoi()
>> which is set to irq_chip_eoi_parent() by default on a
>> hierachical IRQ chip, and the parent is pinctrl-msm.c
>> so that will in turn unconditionally call
>> irq_chip_eoi_parent() again, but its parent is invalid
>> so we get the following crash:
>> 
>>  Unnable to handle kernel NULL pointer dereference at
>>  virtual address 00000010
>>  pgd = (ptrval)
>>  [00000010] *pgd=00000000
>>  Internal error: Oops: 5 [#1] PREEMPT SMP ARM
>>  (...)
>>  PC is at irq_chip_eoi_parent+0x4/0x10
>>  LR is at pm8xxx_irq_handler+0x1b4/0x2d8
>> 
>> Implement a local stub just avoiding to call down to
>> irq_chip_eoi_parent() if d->parent_data is not set.
>> 
>> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
>> Cc: Lina Iyer <ilina@codeaurora.org>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Stephen Boyd <swboyd@chromium.org>
>> Cc: stable@vger.kernel.org
>> Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>>  drivers/pinctrl/qcom/pinctrl-msm.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c 
>> b/drivers/pinctrl/qcom/pinctrl-msm.c
>> index 9a8daa256a32..511f596cf2c3 100644
>> --- a/drivers/pinctrl/qcom/pinctrl-msm.c
>> +++ b/drivers/pinctrl/qcom/pinctrl-msm.c
>> @@ -828,6 +828,12 @@ static void msm_gpio_irq_unmask(struct irq_data 
>> *d)
>>  	msm_gpio_irq_clear_unmask(d, false);
>>  }
>> 
>> +static void msm_gpio_irq_eoi(struct irq_data *d)
> 
> I find it odd that the pinctrl-msm driver would be the only place that
> needs this. But let's start with this.

This driver does something very odd: depending on the SoC and/or the
configuration, some interrupts are either forwarded to a parent
interrupt controller, or terminated at GPIO level for some reason
(probably because it is then signaled as a chained interrupt, or
somehow triggers something else locally). In the latter case, there is
obviously no interrupt parent to talk about.

To my knowledge, this is the only example of such an exotic design
in the tree. Please, let's make sure it stays that way... :-/

         M.
-- 
Jazz is not dead. It just smells funny...
