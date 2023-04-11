Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1AF6DDC72
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjDKNnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjDKNnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:43:41 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CFA1BC;
        Tue, 11 Apr 2023 06:43:40 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pmEHX-0008Tm-W6; Tue, 11 Apr 2023 15:43:36 +0200
Message-ID: <9404a5a4-ef72-3583-4966-e7619340679f@leemhuis.info>
Date:   Tue, 11 Apr 2023 15:43:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] pinctrl: amd: Disable and mask interrupts on resume
Content-Language: en-US, de-DE
To:     =?UTF-8?Q?Kornel_Dul=c4=99ba?= <korneld@chromium.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     gregkh@linuxfoundation.org,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        upstream@semihalf.com, rad@semihalf.com, mattedavis@google.com,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        "Gong, Richard" <richard.gong@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230320093259.845178-1-korneld@chromium.org>
 <d1d39179-33a0-d35b-7593-e0a02aa3b10a@amd.com>
 <ed840be8-b27b-191e-4122-72f62d8f1b7b@amd.com>
 <37178398-497c-900b-361a-34b1b77517aa@leemhuis.info>
 <CAD=NsqzFiQBxtVDmCiJ24HD0YZiwZ4PQkojHHic775EKfeuiaQ@mail.gmail.com>
 <36c7638f-964b-bee6-b44b-c8406e71dfec@leemhuis.info>
 <CAD=Nsqx2Gy08HHzjRoWxS7u559hUgi_GGRis0UDFxrUqLYjTfg@mail.gmail.com>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <CAD=Nsqx2Gy08HHzjRoWxS7u559hUgi_GGRis0UDFxrUqLYjTfg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1681220620;3ea3adfd;
X-HE-SMSGID: 1pmEHX-0008Tm-W6
X-Spam-Status: No, score=-2.2 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11.04.23 15:35, Kornel Dulęba wrote:
> On Tue, Apr 11, 2023 at 3:29 PM Linux regression tracking (Thorsten
> Leemhuis) <regressions@leemhuis.info> wrote:
>>
>> On 11.04.23 15:09, Kornel Dulęba wrote:
>>> On Tue, Apr 11, 2023 at 2:50 PM Linux regression tracking (Thorsten
>>> Leemhuis) <regressions@leemhuis.info> wrote:
>>>> On 10.04.23 17:29, Gong, Richard wrote:
>>>>> On 4/10/2023 12:03 AM, Mario Limonciello wrote:
>>>>>> On 3/20/23 04:32, Kornel Dulęba wrote:
>>>>>>
>>>>>>> This fixes a similar problem to the one observed in:
>>>>>>> commit 4e5a04be88fe ("pinctrl: amd: disable and mask interrupts on
>>>>>>> probe").
>>>>>>>
>>>>>>> On some systems, during suspend/resume cycle firmware leaves
>>>>>>> an interrupt enabled on a pin that is not used by the kernel.
>>>>>>> This confuses the AMD pinctrl driver and causes spurious interrupts.
>>>>>>>
>>>>>>> The driver already has logic to detect if a pin is used by the kernel.
>>>>>>> Leverage it to re-initialize interrupt fields of a pin only if it's not
>>>>>>> used by us.
>>>>>>>
>>>>>>> Signed-off-by: Kornel Dulęba <korneld@chromium.org>
>>>>>>> ---
>>>>>>>   drivers/pinctrl/pinctrl-amd.c | 36 +++++++++++++++++++----------------
>>>>>>>   1 file changed, 20 insertions(+), 16 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/pinctrl/pinctrl-amd.c
>>>>>>> b/drivers/pinctrl/pinctrl-amd.c
>>>>>>> index 9236a132c7ba..609821b756c2 100644
>>>>>>> --- a/drivers/pinctrl/pinctrl-amd.c
>>>>>>> +++ b/drivers/pinctrl/pinctrl-amd.c
>>>>>>> @@ -872,32 +872,34 @@ static const struct pinconf_ops amd_pinconf_ops
>>>>>>> = {
>>>>>>>       .pin_config_group_set = amd_pinconf_group_set,
>>>>>>>   };
>>>>>>>   -static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
>>>>>>> +static void amd_gpio_irq_init_pin(struct amd_gpio *gpio_dev, int pin)
>>>>>>>   {
>>>>>>> -    struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
>>>>>>> +    const struct pin_desc *pd;
>>>>>>>       unsigned long flags;
>>>>>>>       u32 pin_reg, mask;
>>>>>>> -    int i;
>>>>>>>         mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3) |
>>>>>>>           BIT(INTERRUPT_MASK_OFF) | BIT(INTERRUPT_ENABLE_OFF) |
>>>>>>>           BIT(WAKE_CNTRL_OFF_S4);
>>>>>>>   -    for (i = 0; i < desc->npins; i++) {
>>>>>>> -        int pin = desc->pins[i].number;
>>>>>>> -        const struct pin_desc *pd = pin_desc_get(gpio_dev->pctrl, pin);
>>>>>>> -
>>>>>>> -        if (!pd)
>>>>>>> -            continue;
>>>>>>> +    pd = pin_desc_get(gpio_dev->pctrl, pin);
>>>>>>> +    if (!pd)
>>>>>>> +        return;
>>>>>>>   -        raw_spin_lock_irqsave(&gpio_dev->lock, flags);
>>>>>>> +    raw_spin_lock_irqsave(&gpio_dev->lock, flags);
>>>>>>> +    pin_reg = readl(gpio_dev->base + pin * 4);
>>>>>>> +    pin_reg &= ~mask;
>>>>>>> +    writel(pin_reg, gpio_dev->base + pin * 4);
>>>>>>> +    raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
>>>>>>> +}
>>>>>>>   -        pin_reg = readl(gpio_dev->base + i * 4);
>>>>>>> -        pin_reg &= ~mask;
>>>>>>> -        writel(pin_reg, gpio_dev->base + i * 4);
>>>>>>> +static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
>>>>>>> +{
>>>>>>> +    struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
>>>>>>> +    int i;
>>>>>>>   -        raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
>>>>>>> -    }
>>>>>>> +    for (i = 0; i < desc->npins; i++)
>>>>>>> +        amd_gpio_irq_init_pin(gpio_dev, i);
>>>>>>>   }
>>>>>>>     #ifdef CONFIG_PM_SLEEP
>>>>>>> @@ -950,8 +952,10 @@ static int amd_gpio_resume(struct device *dev)
>>>>>>>       for (i = 0; i < desc->npins; i++) {
>>>>>>>           int pin = desc->pins[i].number;
>>>>>>>   -        if (!amd_gpio_should_save(gpio_dev, pin))
>>>>>>> +        if (!amd_gpio_should_save(gpio_dev, pin)) {
>>>>>>> +            amd_gpio_irq_init_pin(gpio_dev, pin);
>>>>>>>               continue;
>>>>>>> +        }
>>>>>>>             raw_spin_lock_irqsave(&gpio_dev->lock, flags);
>>>>>>>           gpio_dev->saved_regs[i] |= readl(gpio_dev->base + pin * 4)
>>>>>>> & PIN_IRQ_PENDING;
>>>>>>
>>>>>> Hello Kornel,
>>>>>>
>>>>>> I've found that this commit which was included in 6.3-rc5 is causing a
>>>>>> regression waking up from lid on a Lenovo Z13.
>>>>> observed "unable to wake from power button" on AMD based Dell platform.
>>>>
>>>> This sounds like something that we want to fix quickly.
>>>>
>>>>> Reverting "pinctrl: amd: Disable and mask interrupts on resume" on the
>>>>> top of 6.3-rc6 does fix the issue.
>>>>>>
>>>>>> Reverting it on top of 6.3-rc6 resolves the problem.
>>>>>>
>>>>>> I've collected what I can into this bug report:
>>>>>>
>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=217315
>>>>>>
>>>>>> Linus Walleij,
>>>>>>
>>>>>> It looks like this was CC to stable.  If we can't get a quick solution
>>>>>> we might want to pull this from stable.
>>>>>
>>>>> this commit landed into 6.1.23 as well
>>>>>
>>>>>         d9c63daa576b2 pinctrl: amd: Disable and mask interrupts on resume
>>>>
>>>> It made it back up to 5.10.y afaics.
>>>>
>>>> The culprit has no fixes tag, which makes me wonder: should we quickly
>>>> (e.g. today) revert this in mainline to get back to the previous state,
>>>> so that Greg can pick up the revert for the next stable releases he
>>>> apparently currently prepares?
>>>>
>>>> Greg, is there another way to make you quickly fix this in the stable
>>>> trees? One option obviously would be "revert this now in stable, reapply
>>>> it later together with a fix ". But I'm under the impression that this
>>>> is too much of a hassle and thus something you only do in dire situations?
>>>>
>>>> I'm asking because I over time noticed that quite a few regressions are
>>>> in a similar situation -- and quite a few of them take quite some time
>>>> to get fixed even when a developer provided a fix, because reviewing and
>>>> mainlining the fix takes a week or two (sometimes more). And that is a
>>>> situation that is more and more hitting a nerve here. :-/
>>>
>>> I've looked into this and at this moment I can't really find a quick fix.
>>> See https://bugzilla.kernel.org/show_bug.cgi?id=217315#c3.
>>> It seems that reverting this might be the best solution for now.
>>
>> Great, thx for the update (and BTW: Greg, thx for your answer, too).
>>
>> To speed things up a quick question:
>>
>> Linusw, what's your preferred course to realize this revert quickly?
>>
>>  * someone (Kornel?) sends a revert with a commit msg for review, which
>> you then apply and pass on to the other Linus?
>>
>>  * someone (Kornel?) sends a revert with a commit msg for review that
>> immediately asks the other Linus to pick this up directly?
>>
>>  * we ask the other Linus directly to revert this (who then has to come
>> up with a commit msg on his own)?
> 
> Would you like me to send a reverting change?
> I can do this right away.

Guess it would be helpful, as then we are down to option one or two.
Many thx!

> The commit message would contain something like:
> 
> This patch introduces a regression on Lenovo Z13, which can't wake
> from the lid with it applied.

Maybe add "; and some unspecified AMD based Dell platforms are unable to
wake from hitting the power button". (see Richard's mail earlier in the
thread).

Ciao, Thorsten
