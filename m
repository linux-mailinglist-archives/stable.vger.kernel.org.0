Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF48F128916
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 13:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfLUMlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 07:41:20 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:46506 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbfLUMlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Dec 2019 07:41:20 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xBLCf7Xg109349;
        Sat, 21 Dec 2019 06:41:07 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1576932067;
        bh=ylxwaTSAG+cOBwJ+yPOXKXSz8xVSA7UX8Heq4AaHuk8=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=jXbYDG40bjv58NZ+I+DtibgntmEb0qnMvxrHCrevqeCy0ACmY5Fidk99twQ1+sUwR
         LzSTBX38KAE231L1G8zk5WKrjZ13oJEg0p5QAf9DvUuC7q2nFk0RF7R0xuPTVEyK6E
         q3RtAvViE101BXdx98QROrH/EXdxI2nyNq9Cfltg=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xBLCf7JH107347
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 21 Dec 2019 06:41:07 -0600
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Sat, 21
 Dec 2019 06:41:06 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Sat, 21 Dec 2019 06:41:06 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xBLCf3ae000331;
        Sat, 21 Dec 2019 06:41:04 -0600
Subject: Re: [PATCH] can: m_can: Fix default pinmux glitch at init
To:     Marek Vasut <marex@denx.de>, <linux-can@vger.kernel.org>
CC:     Bich Hemon <bich.hemon@st.com>,
        "J . D . Schroeder" <jay.schroeder@garmin.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Roger Quadros <rogerq@ti.com>,
        linux-stable <stable@vger.kernel.org>
References: <20191217100740.2687835-1-marex@denx.de>
 <8b2e0a40-cf23-58a5-4f52-215015c61ea8@ti.com>
 <3c48dd07-154e-bc47-4aff-73769d9efa22@denx.de>
 <be0d0b55-c287-3252-e188-cbaedd5d426c@ti.com>
 <b875d2a3-a39d-b00b-3558-96cab1e00165@denx.de>
 <be6bad41-4893-6e2c-4fab-411125ab5d94@ti.com>
 <c419f0f2-9cfe-ec4c-db36-626ca3c57d32@denx.de>
 <f3ecc2b7-b380-79af-5887-0c2f3360534f@ti.com>
 <3adc4188-c175-a3e7-a104-82bb2e073a35@denx.de>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <4abc1597-cbc6-a18c-e369-2989b3d73be9@ti.com>
Date:   Sat, 21 Dec 2019 14:41:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3adc4188-c175-a3e7-a104-82bb2e073a35@denx.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 21/12/2019 13:47, Marek Vasut wrote:
> On 12/21/19 12:12 PM, Grygorii Strashko wrote:
>>
>>
>> On 21/12/2019 13:00, Marek Vasut wrote:
>>> On 12/21/19 11:53 AM, Grygorii Strashko wrote:
>>>>
>>>>
>>>> On 19/12/2019 23:47, Marek Vasut wrote:
>>>>> On 12/19/19 2:37 PM, Grygorii Strashko wrote:
>>>>>>
>>>>>>
>>>>>> On 17/12/2019 12:55, Marek Vasut wrote:
>>>>>>> On 12/17/19 11:42 AM, Grygorii Strashko wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 17/12/2019 12:07, Marek Vasut wrote:
>>>>>>>>> The current code causes a slight glitch on the pinctrl settings
>>>>>>>>> when
>>>>>>>>> used.
>>>>>>>>> Since commit ab78029 (drivers/pinctrl: grab default handles from
>>>>>>>>> device core),
>>>>>>>>> the device core will automatically set the default pins. This
>>>>>>>>> causes
>>>>>>>>> the pins
>>>>>>>>> to be momentarily set to the default and then to the sleep state in
>>>>>>>>> register_m_can_dev(). By adding an optional "enable" state, boards
>>>>>>>>> can
>>>>>>>>> set the
>>>>>>>>> default pin state to be disabled and avoid the glitch when the
>>>>>>>>> switch
>>>>>>>>> from
>>>>>>>>> default to sleep first occurs. If the "enable" state is not
>>>>>>>>> available
>>>>>>>>> pinctrl_get_select() falls back to using the "default" pinctrl
>>>>>>>>> state.
>>>>>>>>>
>>>>>>>>> Fixes: c9b3bce18da4 ("can: m_can: select pinctrl state in each
>>>>>>>>> suspend/resume function")
>>>>>>>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>>>>>>>> Cc: Bich Hemon <bich.hemon@st.com>
>>>>>>>>> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
>>>>>>>>> Cc: J.D. Schroeder <jay.schroeder@garmin.com>
>>>>>>>>> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
>>>>>>>>> Cc: Roger Quadros <rogerq@ti.com>
>>>>>>>>> Cc: linux-stable <stable@vger.kernel.org>
>>>>>>>>> To: linux-can@vger.kernel.org
>>>>>>>>> ---
>>>>>>>>> NOTE: This is commit 033365191136 ("can: c_can: Fix default pinmux
>>>>>>>>> glitch at init")
>>>>>>>>>            adapted for m_can driver.
>>>>>>>>> ---
>>>>>>>>>       drivers/net/can/m_can/m_can.c | 8 ++++++++
>>>>>>>>>       1 file changed, 8 insertions(+)
>>>>>>>>>
>>>>>>>>> diff --git a/drivers/net/can/m_can/m_can.c
>>>>>>>>> b/drivers/net/can/m_can/m_can.c
>>>>>>>>> index 02c5795b73936..afb6760b17427 100644
>>>>>>>>> --- a/drivers/net/can/m_can/m_can.c
>>>>>>>>> +++ b/drivers/net/can/m_can/m_can.c
>>>>>>>>> @@ -1243,12 +1243,20 @@ static void m_can_chip_config(struct
>>>>>>>>> net_device *dev)
>>>>>>>>>       static void m_can_start(struct net_device *dev)
>>>>>>>>>       {
>>>>>>>>>           struct m_can_classdev *cdev = netdev_priv(dev);
>>>>>>>>> +    struct pinctrl *p;
>>>>>>>>>             /* basic m_can configuration */
>>>>>>>>>           m_can_chip_config(dev);
>>>>>>>>>             cdev->can.state = CAN_STATE_ERROR_ACTIVE;
>>>>>>>>>       +    /* Attempt to use "active" if available else use
>>>>>>>>> "default" */
>>>>>>>>> +    p = pinctrl_get_select(cdev->dev, "active");
>>>>>>>>> +    if (!IS_ERR(p))
>>>>>>>>> +        pinctrl_put(p);
>>>>>>>>> +    else
>>>>>>>>> +        pinctrl_pm_select_default_state(cdev->dev);
>>>>>>>>> +
>>>>>>>>>           m_can_enable_all_interrupts(cdev);
>>>>>>>>>       }
>>>>>>>>>      
>>>>>>>>
>>>>>>>> May be init state should be used - #define PINCTRL_STATE_INIT "init"
>>>>>>>> instead?
>>>>>>>
>>>>>>> I'm not sure I quite understand -- how ?
>>>>>>>
>>>>>>
>>>>>> Sry, for delayed reply.
>>>>>>
>>>>>> I've looked at m_can code and think issue is a little bit deeper
>>>>>>     (but I might be wrong as i'm not can expert and below based on code
>>>>>> review).
>>>>>>
>>>>>> First, what going on:
>>>>>> probe:
>>>>>>     really_probe()
>>>>>>      pinctrl_bind_pins()
>>>>>>            if (IS_ERR(dev->pins->init_state)) {
>>>>>>            ret = pinctrl_select_state(dev->pins->p,
>>>>>>                           dev->pins->default_state);
>>>>>>        } else {
>>>>>>            ret = pinctrl_select_state(dev->pins->p,
>>>>>> dev->pins->init_state);
>>>>>>        }
>>>>>>      [GS] So at this point default_state or init_state is set
>>>>>>
>>>>>>      ret = dev->bus->probe(dev);
>>>>>>           m_can_plat_probe()
>>>>>>         m_can_class_register()
>>>>>>            m_can_clk_start()
>>>>>>              pm_runtime_get_sync()
>>>>>>            m_can_runtime_resume()
>>>>>>      [GS] Still default_state or init_state is active
>>>>>>
>>>>>>           register_m_can_dev()
>>>>>>      [GS] at this point m_can netdev is registered, which may lead to
>>>>>> .ndo_open = m_can_open() call
>>>>>>
>>>>>>             m_can_clk_stop()
>>>>>>               pm_runtime_put_sync()
>>>>>>      [GS] if .ndo_open() was called before it will be a nop
>>>>>>            m_can_runtime_suspend()
>>>>>>             m_can_class_suspend()
>>>>>>
>>>>>>                if (netif_running(ndev)) {
>>>>>>                    netif_stop_queue(ndev);
>>>>>>                    netif_device_detach(ndev);
>>>>>>                    m_can_stop(ndev);
>>>>>>                    m_can_clk_stop(cdev);
>>>>>>      [GS] if .ndo_open() was called before it will lead to deadlock
>>>>>> here
>>>>>>          So, most probably, it will cause deadlock in case of "ifconfig
>>>>>> <m_can_dev> up down" case
>>>>>>                }
>>>>>>
>>>>>>                pinctrl_pm_select_sleep_state(dev);
>>>>>>      [GS] at this point sleep_state will be set - i assume it's the
>>>>>> root
>>>>>> cause of your glitch.
>>>>>>           Note - As per code, the pinctrl default_state will never ever
>>>>>> configured again, so if after
>>>>>>           probe m_can will go through PM runtime suspend/resume
>>>>>> cycle it
>>>>>> will not work any more.
>>>>>>
>>>>>>      pinctrl_init_done()
>>>>>>      [GS] will do nothing in case !init_state
>>>>>>
>>>>>> As per above, if sleep_state is defined the m_can seems should not
>>>>>> work
>>>>>> at all without your patch,
>>>>>> as there is no code path to switch back sleep_state->default_state.
>>>>>> And over all PM runtime m_can code is mixed with System suspend
>>>>>> code and
>>>>>> so not correct.
>>>>>>
>>>>>> Also, the very good question - Is it really required to toggle pinctrl
>>>>>> states as part of PM runtime?
>>>>>> (usually it's enough to handle it only during System suspend).
>>>>>
>>>>> I suspect this discussion is somewhat a separate topic from what this
>>>>> patch is trying to fix ?
>>>>>
>>>>
>>>> Not exactly.
>>>
>>> I see ?
>>>
>>>> The reason you need this patch is misuse of PM runtime vs
>>>> pin control
>>>> in this driver. And this has to be fixed first of all.
>>>
>>> But then the C_CAN also misuses the PM runtime ? I mean, this patch does
>>> literally what the same patch for C_CAN does, so maybe this is a more
>>> general problem and needs a separate fix -- unless tristating the pins
>>> when the block if disabled is the right thing to do, which it might be.
>>>
>>>> I feel that just removing of m_can_class_suspend() call from
>>>> m_can_runtime_suspend()
>>>> will fix things for you - it will toggle pin states only during Suspend
>>>> to RAM cycle.
>>>
>>> I need to configure the pins on boot, this has nothing to do with
>>> suspend/resume.
>>>
>>
>> Then just use default_state in DT and do not define sleep state.
>> Sry, I see no reason for your patch at all.
> 
> Sry, my board does not work without this patch, so I see reason enough.
> Presumably the author of the C_CAN patch did see similar reason.

You continue referring to C_CAN, but it's implemented in a different way.
1) It has no PM runtime callbacks in c_can_platform.c
2) it manually switches the pin states in .ndo_open()/close
3) it has requirement to enable pins after HW IP is enabled


> 
> Mind you, STM32MP1 does define both states already.
> 
>> And please, try my proposal - don't make me feel I wasted my time doing
>> all above analysis.
> 
> But your proposal stops switching the pin states when the core is
> suspended, I don't think that's what's it supposed to do.

Right, but a) it expected to fix your issue b) fix deadlock on if config down

And:
What exactly do you mean by "core is suspended"?
And how is expected to work from you point of view -
can interface dowm-> sleep pins; can interface up -> default/active pins;? smth else?
How has it worked before c_can_platform.c was introduced?
And what other people should after your patch - add non documented "active" state to every m_can DT node?

I understand you issue, but your patch is not a fix -
it's w/a and root cause has to be fixed.

 From this discussion, it seems that right way to fix it could be:
1) fix m_can_runtime_suspend() as per above
2) move pinctrl_pm_select_xx() in m_can.c .ndo_open/ndo_close() some where
3) add "init" state == "sleep" state and in m_can_class_register() (or register_m_can_dev())
   force "sleep" state. m_can should be kept in "sleep" state this way
   until m_can.c .ndo_open() is called.

[1] commit ef0eebc05130 ("drivers/pinctrl: Add the concept of an "init" state")

-- 
Best regards,
grygorii
