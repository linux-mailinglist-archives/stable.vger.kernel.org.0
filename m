Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE4CF17E39C
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 16:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgCIP3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 11:29:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgCIP3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 11:29:08 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F393B2067C;
        Mon,  9 Mar 2020 15:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583767748;
        bh=kW5EWHEjH+t8ZtAWxHLeMNA7nNZgMG7o5IyY82yDSP8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=caGbDoYgL5aLDVOE4HELBRIZL9Q5jvfHvwsd32cznFn1utJCLSow4iSDqvC027AzN
         hQZGzgNk9a32fMHqnHSP3SVWrw6QNeZHhnK3W+tv8eaiyskmr4FFzdUercT1GE0Lc+
         z12UOOybmNWiFiX+ELOeuD6PnkFeLaWVY94JzBkk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jBKL4-00BJZQ-AH; Mon, 09 Mar 2020 15:29:06 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 09 Mar 2020 15:29:06 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-gpio@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>, stable@vger.kernel.org
Subject: Re: [PATCH v4] pinctrl: qcom: Assign irq_eoi conditionally
In-Reply-To: <20200309152604.585112-1-linus.walleij@linaro.org>
References: <20200309152604.585112-1-linus.walleij@linaro.org>
Message-ID: <4812b6956e06997f82697d3b518d8964@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: linus.walleij@linaro.org, linux-gpio@vger.kernel.org, david@ixit.cz, bjorn.andersson@linaro.org, ilina@codeaurora.org, swboyd@chromium.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-03-09 15:26, Linus Walleij wrote:
> The hierarchical parts of MSM pinctrl/GPIO is only
> used when the device tree has a "wakeup-parent" as
> a phandle, but the .irq_eoi is anyway assigned leading
> to semantic problems on elder Qualcomm chipsets.
> 
> When the drivers/mfd/qcom-pm8xxx.c driver calls
> chained_irq_exit() that call will in turn call chip->irq_eoi()
> which is set to irq_chip_eoi_parent() by default on a
> hierachical IRQ chip, and the parent is pinctrl-msm.c
> so that will in turn unconditionally call
> irq_chip_eoi_parent() again, but its parent is invalid
> so we get the following crash:
> 
>  Unnable to handle kernel NULL pointer dereference at
>  virtual address 00000010
>  pgd = (ptrval)
>  [00000010] *pgd=00000000
>  Internal error: Oops: 5 [#1] PREEMPT SMP ARM
>  (...)
>  PC is at irq_chip_eoi_parent+0x4/0x10
>  LR is at pm8xxx_irq_handler+0x1b4/0x2d8
> 
> If we solve this crash by avoiding to call up to
> irq_chip_eoi_parent(), the machine will hang and get
> reset by the watchdog, because of semantic issues,
> probably inside irq_chip.
> 
> As a solution, just assign the .irq_eoi conditionally if
> we are actually using a wakeup parent.
> 
> Cc: David Heidelberg <david@ixit.cz>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Lina Iyer <ilina@codeaurora.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Stephen Boyd <swboyd@chromium.org>
> Cc: stable@vger.kernel.org
> Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
> Link:
> https://lore.kernel.org/r/20200306121221.1231296-1-linus.walleij@linaro.org
> Link: 
> https://lore.kernel.org/r/20200309125207.571840-1-linus.walleij@linaro.org
> Tested-by: David Heidelberg <david@ixit.cz>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Marc Zyngier <maz@kernel.org>

         M.
-- 
Jazz is not dead. It just smells funny...
