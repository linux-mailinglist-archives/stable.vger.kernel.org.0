Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7469317E33C
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 16:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgCIPPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 11:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgCIPPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 11:15:44 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3B8A20873;
        Mon,  9 Mar 2020 15:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583766943;
        bh=quEnf7o9ePOvW7/JvEJ1rn16TxHwkckC3hM8f5iwEHU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bXxWKFVgDR3hPZVYSs8nxGgDeJrgdRz1fkXalBUzER63p/R1HdfwIhENE+HKsbdna
         HgN2Tz1103epA6mjl33Jd23Wpx0h+wTux11dqoL/SaGHxlvCDScoIEc1eKqtJyE/PB
         qyzflaOIS6/wEgVSEjLRZj211LcTcKMaC8kWio+w=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jBK86-00BJOQ-0T; Mon, 09 Mar 2020 15:15:42 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 09 Mar 2020 15:15:41 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] pinctrl: qcom: Assign irq_disable/eoi conditionally
In-Reply-To: <CACRpkdamdgMh-z6AHqEptAw_o9JtCu1-RXDVWkqVJsoQTpc2NQ@mail.gmail.com>
References: <20200309125207.571840-1-linus.walleij@linaro.org>
 <1be9151d00160ef26a3900e0e6a5fd14@kernel.org>
 <CACRpkdamdgMh-z6AHqEptAw_o9JtCu1-RXDVWkqVJsoQTpc2NQ@mail.gmail.com>
Message-ID: <5f0252c4ac13e2fdca31cede5bf22c29@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: linus.walleij@linaro.org, linux-gpio@vger.kernel.org, bjorn.andersson@linaro.org, ilina@codeaurora.org, swboyd@chromium.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-03-09 15:03, Linus Walleij wrote:
> On Mon, Mar 9, 2020 at 3:54 PM Marc Zyngier <maz@kernel.org> wrote:
> 
>> On 2020-03-09 12:52, Linus Walleij wrote:
> 
>> > ChangeLog v1->v2:
>> > - Noticed that the previous solution doesn't actually work,
>> >   the machine hangs and reboots intead (even if it got rid of
>> >   the most obvious crash). Make a more thorough solution that
>> >   completely avoids using these callbacks if we don't have
>> >   a parent.
>> 
>> What is the problem with disable exactly?
> 
> There is no problem with .irq_disable, the system still works
> if I keep that. But since the original patch added these two
> callbacks for hierarchical I just moved them both to be
> conditional.
> 
> The .irq_eoi callback is the culprit.
> 
>> >       pctrl->irq_chip.name = "msmgpio";
>> >       pctrl->irq_chip.irq_enable = msm_gpio_irq_enable;
>> > -     pctrl->irq_chip.irq_disable = msm_gpio_irq_disable;
>> 
>> I find it really odd to have the enable callback, but not the disable.
>> What is the rational for that? Can we drop the enable as well for old
>> platforms and only use mask/unmask instead?
> 
> Hm I'm just working with the regression, and before the
> patch I'm fixing the driver actually had just the .irq_enable
> callback, so I'm restoring that state.
> 
> Would you prefer a patch where I just move the assignment
> of the .irq_eoi callback to be conditional?

I'd rather we have the minimal change that makes your system runnable.
If making irq_eoi depend on some QC magic, fine by me. Having an 
unbalanced
enable/disable setup looks pretty fragile.

> I have no idea *why* .irq_eoi() locks up the system, I suspect
> one of those irqchip internal semantics that are sometimes
> not entirely clear.

I don't think anyone knows what they are outside of the usual QC 
circles.

         M.
-- 
Jazz is not dead. It just smells funny...
