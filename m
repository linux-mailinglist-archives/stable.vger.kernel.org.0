Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C9C467D41
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 19:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382697AbhLCS3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 13:29:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41616 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbhLCS3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 13:29:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCBB562C76;
        Fri,  3 Dec 2021 18:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8857C53FCD;
        Fri,  3 Dec 2021 18:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638555945;
        bh=WA0ZVVfQNTglvNP8ymTxkNfa/jq89vMugL/9ZZdaots=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=saQsg9jXMa85GoHKy8Xc/QdPiFE75zKPPEBx20op4x6Bi2XYlmGZIz3J/hqujpd/K
         jIRp3ncFf8aN2AdVr4aRHYeJUq0aWhFF9i/894fUGsTescMD0CUStuE9CHaJptgXse
         sSmMl1G/6Tf2RE1P8CBV2zxhgN8yB+cfZw/R50rM/453Wfxlgi7WR6xiYSy2Qat5Eg
         h2r2js01Ukzc45223S4qZgQzcGPlUZ5SoGiQBqLY5jcEfViPi5JPO9x0sXUdGEhFof
         TZpw2V3vxYF9g6LOKh6xM/uUITiTXUvN8W5bkHlL4rx1Ood9EGuQeH4L3zqea2rwoL
         5fFUXOVLnc1KA==
Date:   Fri, 3 Dec 2021 13:25:43 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Joerie de Gram <j.de.gram@gmail.com>,
        "Natikar, Basavaraj" <Basavaraj.Natikar@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.10 10/28] pinctrl: amd: Fix wakeups when IRQ is
 shared with SCI
Message-ID: <YaphJ+SGgR3t2ags@sashalap>
References: <20211126023343.442045-1-sashal@kernel.org>
 <20211126023343.442045-10-sashal@kernel.org>
 <SA0PR12MB4510E32F459655B6387A8660E2669@SA0PR12MB4510.namprd12.prod.outlook.com>
 <SA0PR12MB4510FEE100D5555F655C7EA0E2669@SA0PR12MB4510.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <SA0PR12MB4510FEE100D5555F655C7EA0E2669@SA0PR12MB4510.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 06:53:01PM +0000, Limonciello, Mario wrote:
>
>
>> -----Original Message-----
>> From: Limonciello, Mario
>> Sent: Monday, November 29, 2021 08:48
>> To: Sasha Levin <sashal@kernel.org>; linux-kernel@vger.kernel.org;
>> stable@vger.kernel.org
>> Cc: Joerie de Gram <j.de.gram@gmail.com>; Natikar, Basavaraj
>> <Basavaraj.Natikar@amd.com>; Linus Walleij <linus.walleij@linaro.org>; S-k,
>> Shyam-sundar <Shyam-sundar.S-k@amd.com>; linux-gpio@vger.kernel.org
>> Subject: RE: [PATCH AUTOSEL 5.10 10/28] pinctrl: amd: Fix wakeups when IRQ
>> is shared with SCI
>>
>>
>>
>> > -----Original Message-----
>> > From: Sasha Levin <sashal@kernel.org>
>> > Sent: Thursday, November 25, 2021 20:33
>> > To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
>> > Cc: Limonciello, Mario <Mario.Limonciello@amd.com>; Joerie de Gram
>> > <j.de.gram@gmail.com>; Natikar, Basavaraj
>> <Basavaraj.Natikar@amd.com>;
>> > Linus Walleij <linus.walleij@linaro.org>; Sasha Levin <sashal@kernel.org>;
>> S-
>> > k, Shyam-sundar <Shyam-sundar.S-k@amd.com>; linux-
>> > gpio@vger.kernel.org
>> > Subject: [PATCH AUTOSEL 5.10 10/28] pinctrl: amd: Fix wakeups when IRQ
>> is
>> > shared with SCI
>> >
>> > From: Mario Limonciello <mario.limonciello@amd.com>
>> >
>> > [ Upstream commit 2d54067fcd23aae61e23508425ae5b29e973573d ]
>> >
>> > On some Lenovo AMD Gen2 platforms the IRQ for the SCI and pinctrl
>> drivers
>> > are shared.  Due to how the s2idle loop handling works, this case needs
>> > an extra explicit check whether the interrupt was caused by SCI or by
>> > the GPIO controller.
>> >
>> > To fix this rework the existing IRQ handler function to function as a
>> > checker and an IRQ handler depending on the calling arguments.
>> >
>> > BugLink:
>> >
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitla
>> > b.freedesktop.org%2Fdrm%2Famd%2F-
>> >
>> %2Fissues%2F1738&amp;data=04%7C01%7Cmario.limonciello%40amd.com%
>> >
>> 7Ce14b7ddf8d1143b6649208d9b0853519%7C3dd8961fe4884e608e11a82d994
>> >
>> e183d%7C0%7C0%7C637734908448086367%7CUnknown%7CTWFpbGZsb3d8
>> >
>> eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3
>> >
>> D%7C3000&amp;sdata=BHHY3gLu2pQIJ1nvSE0VNQOaioTC0QdBM44ze3HXrtk
>> > %3D&amp;reserved=0
>> > Reported-by: Joerie de Gram <j.de.gram@gmail.com>
>> > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>> > Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
>> > Link:
>> >
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.
>> > kernel.org%2Fr%2F20211101014853.6177-2-
>> >
>> mario.limonciello%40amd.com&amp;data=04%7C01%7Cmario.limonciello%4
>> >
>> 0amd.com%7Ce14b7ddf8d1143b6649208d9b0853519%7C3dd8961fe4884e608
>> >
>> e11a82d994e183d%7C0%7C0%7C637734908448086367%7CUnknown%7CTWF
>> >
>> pbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXV
>> >
>> CI6Mn0%3D%7C3000&amp;sdata=zUkTF851CdUmrY1z3YZbYrnVrjHQaVfb1%
>> > 2Bg2dx28ZNA%3D&amp;reserved=0
>> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>> > ---
>> >  drivers/pinctrl/pinctrl-amd.c | 29 ++++++++++++++++++++++++++---
>> >  1 file changed, 26 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
>> > index e20bcc835d6a8..54dfa0244422c 100644
>> > --- a/drivers/pinctrl/pinctrl-amd.c
>> > +++ b/drivers/pinctrl/pinctrl-amd.c
>> > @@ -520,14 +520,14 @@ static struct irq_chip amd_gpio_irqchip = {
>> >
>> >  #define PIN_IRQ_PENDING	(BIT(INTERRUPT_STS_OFF) |
>> > BIT(WAKE_STS_OFF))
>> >
>> > -static irqreturn_t amd_gpio_irq_handler(int irq, void *dev_id)
>> > +static bool do_amd_gpio_irq_handler(int irq, void *dev_id)
>> >  {
>> >  	struct amd_gpio *gpio_dev = dev_id;
>> >  	struct gpio_chip *gc = &gpio_dev->gc;
>> > -	irqreturn_t ret = IRQ_NONE;
>> >  	unsigned int i, irqnr;
>> >  	unsigned long flags;
>> >  	u32 __iomem *regs;
>> > +	bool ret = false;
>> >  	u32  regval;
>> >  	u64 status, mask;
>> >
>> > @@ -549,6 +549,14 @@ static irqreturn_t amd_gpio_irq_handler(int irq,
>> void
>> > *dev_id)
>> >  		/* Each status bit covers four pins */
>> >  		for (i = 0; i < 4; i++) {
>> >  			regval = readl(regs + i);
>> > +			/* caused wake on resume context for shared IRQ */
>> > +			if (irq < 0 && (regval & BIT(WAKE_STS_OFF))) {
>> > +				dev_dbg(&gpio_dev->pdev->dev,
>> > +					"Waking due to GPIO %d: 0x%x",
>> > +					irqnr + i, regval);
>> > +				return true;
>> > +			}
>> > +
>> >  			if (!(regval & PIN_IRQ_PENDING) ||
>> >  			    !(regval & BIT(INTERRUPT_MASK_OFF)))
>> >  				continue;
>> > @@ -574,9 +582,12 @@ static irqreturn_t amd_gpio_irq_handler(int irq,
>> void
>> > *dev_id)
>> >  			}
>> >  			writel(regval, regs + i);
>> >  			raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
>> > -			ret = IRQ_HANDLED;
>> > +			ret = true;
>> >  		}
>> >  	}
>> > +	/* did not cause wake on resume context for shared IRQ */
>> > +	if (irq < 0)
>> > +		return false;
>> >
>> >  	/* Signal EOI to the GPIO unit */
>> >  	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
>> > @@ -588,6 +599,16 @@ static irqreturn_t amd_gpio_irq_handler(int irq,
>> void
>> > *dev_id)
>> >  	return ret;
>> >  }
>> >
>> > +static irqreturn_t amd_gpio_irq_handler(int irq, void *dev_id)
>> > +{
>> > +	return IRQ_RETVAL(do_amd_gpio_irq_handler(irq, dev_id));
>> > +}
>> > +
>> > +static bool __maybe_unused amd_gpio_check_wake(void *dev_id)
>> > +{
>> > +	return do_amd_gpio_irq_handler(-1, dev_id);
>> > +}
>> > +
>> >  static int amd_get_groups_count(struct pinctrl_dev *pctldev)
>> >  {
>> >  	struct amd_gpio *gpio_dev = pinctrl_dev_get_drvdata(pctldev);
>> > @@ -958,6 +979,7 @@ static int amd_gpio_probe(struct platform_device
>> > *pdev)
>> >  		goto out2;
>> >
>> >  	platform_set_drvdata(pdev, gpio_dev);
>> > +	acpi_register_wakeup_handler(gpio_dev->irq,
>> > amd_gpio_check_wake, gpio_dev);
>> >
>> >  	dev_dbg(&pdev->dev, "amd gpio driver loaded\n");
>> >  	return ret;
>> > @@ -975,6 +997,7 @@ static int amd_gpio_remove(struct platform_device
>> > *pdev)
>> >  	gpio_dev = platform_get_drvdata(pdev);
>> >
>> >  	gpiochip_remove(&gpio_dev->gc);
>> > +	acpi_unregister_wakeup_handler(amd_gpio_check_wake,
>> > gpio_dev);
>> >
>> >  	return 0;
>> >  }
>> > --
>> > 2.33.0
>>
>> Sasha,
>>
>> No concerns for me to 5.10, but would you mind also sending this to 5.14.y
>> and 5.15.y too?  I didn't see it sent up for either.

5.14 was EOL at that time.

>One more thought on this - please also take this (which wasn't part of autosel)
>when this comes back:
>
>e9380df85187 ACPI: Add stubs for wakeup handler functions
>
>That prevents some compile errors in certain configurations.

I'll grab it, thanks!

-- 
Thanks,
Sasha
