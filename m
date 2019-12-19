Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA232126FF1
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 22:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfLSVrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 16:47:10 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:47174 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbfLSVrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 16:47:09 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 47f57Y1ptfz1rfPj;
        Thu, 19 Dec 2019 22:47:05 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 47f57Y0qsWz1qr2L;
        Thu, 19 Dec 2019 22:47:05 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 8yaAPI4GqET6; Thu, 19 Dec 2019 22:47:03 +0100 (CET)
X-Auth-Info: 1hwxtGEbUucigG4e/a2ZeNDNRl3Jd1grguVEnD2LKuM=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 19 Dec 2019 22:47:03 +0100 (CET)
Subject: Re: [PATCH] can: m_can: Fix default pinmux glitch at init
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-can@vger.kernel.org
Cc:     Bich Hemon <bich.hemon@st.com>,
        "J . D . Schroeder" <jay.schroeder@garmin.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Roger Quadros <rogerq@ti.com>,
        linux-stable <stable@vger.kernel.org>
References: <20191217100740.2687835-1-marex@denx.de>
 <8b2e0a40-cf23-58a5-4f52-215015c61ea8@ti.com>
 <3c48dd07-154e-bc47-4aff-73769d9efa22@denx.de>
 <be0d0b55-c287-3252-e188-cbaedd5d426c@ti.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <b875d2a3-a39d-b00b-3558-96cab1e00165@denx.de>
Date:   Thu, 19 Dec 2019 22:47:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <be0d0b55-c287-3252-e188-cbaedd5d426c@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/19/19 2:37 PM, Grygorii Strashko wrote:
> 
> 
> On 17/12/2019 12:55, Marek Vasut wrote:
>> On 12/17/19 11:42 AM, Grygorii Strashko wrote:
>>>
>>>
>>> On 17/12/2019 12:07, Marek Vasut wrote:
>>>> The current code causes a slight glitch on the pinctrl settings when
>>>> used.
>>>> Since commit ab78029 (drivers/pinctrl: grab default handles from
>>>> device core),
>>>> the device core will automatically set the default pins. This causes
>>>> the pins
>>>> to be momentarily set to the default and then to the sleep state in
>>>> register_m_can_dev(). By adding an optional "enable" state, boards can
>>>> set the
>>>> default pin state to be disabled and avoid the glitch when the switch
>>>> from
>>>> default to sleep first occurs. If the "enable" state is not available
>>>> pinctrl_get_select() falls back to using the "default" pinctrl state.
>>>>
>>>> Fixes: c9b3bce18da4 ("can: m_can: select pinctrl state in each
>>>> suspend/resume function")
>>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>>> Cc: Bich Hemon <bich.hemon@st.com>
>>>> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
>>>> Cc: J.D. Schroeder <jay.schroeder@garmin.com>
>>>> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
>>>> Cc: Roger Quadros <rogerq@ti.com>
>>>> Cc: linux-stable <stable@vger.kernel.org>
>>>> To: linux-can@vger.kernel.org
>>>> ---
>>>> NOTE: This is commit 033365191136 ("can: c_can: Fix default pinmux
>>>> glitch at init")
>>>>         adapted for m_can driver.
>>>> ---
>>>>    drivers/net/can/m_can/m_can.c | 8 ++++++++
>>>>    1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/drivers/net/can/m_can/m_can.c
>>>> b/drivers/net/can/m_can/m_can.c
>>>> index 02c5795b73936..afb6760b17427 100644
>>>> --- a/drivers/net/can/m_can/m_can.c
>>>> +++ b/drivers/net/can/m_can/m_can.c
>>>> @@ -1243,12 +1243,20 @@ static void m_can_chip_config(struct
>>>> net_device *dev)
>>>>    static void m_can_start(struct net_device *dev)
>>>>    {
>>>>        struct m_can_classdev *cdev = netdev_priv(dev);
>>>> +    struct pinctrl *p;
>>>>          /* basic m_can configuration */
>>>>        m_can_chip_config(dev);
>>>>          cdev->can.state = CAN_STATE_ERROR_ACTIVE;
>>>>    +    /* Attempt to use "active" if available else use "default" */
>>>> +    p = pinctrl_get_select(cdev->dev, "active");
>>>> +    if (!IS_ERR(p))
>>>> +        pinctrl_put(p);
>>>> +    else
>>>> +        pinctrl_pm_select_default_state(cdev->dev);
>>>> +
>>>>        m_can_enable_all_interrupts(cdev);
>>>>    }
>>>>   
>>>
>>> May be init state should be used - #define PINCTRL_STATE_INIT "init"
>>> instead?
>>
>> I'm not sure I quite understand -- how ?
>>
> 
> Sry, for delayed reply.
> 
> I've looked at m_can code and think issue is a little bit deeper
>  (but I might be wrong as i'm not can expert and below based on code
> review).
> 
> First, what going on:
> probe:
>  really_probe()
>   pinctrl_bind_pins()
>         if (IS_ERR(dev->pins->init_state)) {
>         ret = pinctrl_select_state(dev->pins->p,
>                        dev->pins->default_state);
>     } else {
>         ret = pinctrl_select_state(dev->pins->p, dev->pins->init_state);
>     }
>   [GS] So at this point default_state or init_state is set
> 
>   ret = dev->bus->probe(dev);
>        m_can_plat_probe()
>      m_can_class_register()
>         m_can_clk_start()
>           pm_runtime_get_sync()
>         m_can_runtime_resume()
>   [GS] Still default_state or init_state is active
> 
>        register_m_can_dev()
>   [GS] at this point m_can netdev is registered, which may lead to
> .ndo_open = m_can_open() call
> 
>          m_can_clk_stop()
>            pm_runtime_put_sync()
>   [GS] if .ndo_open() was called before it will be a nop
>         m_can_runtime_suspend()
>          m_can_class_suspend()
> 
>             if (netif_running(ndev)) {
>                 netif_stop_queue(ndev);
>                 netif_device_detach(ndev);
>                 m_can_stop(ndev);
>                 m_can_clk_stop(cdev);
>   [GS] if .ndo_open() was called before it will lead to deadlock here
>       So, most probably, it will cause deadlock in case of "ifconfig
> <m_can_dev> up down" case
>             }
> 
>             pinctrl_pm_select_sleep_state(dev);
>   [GS] at this point sleep_state will be set - i assume it's the root
> cause of your glitch.
>        Note - As per code, the pinctrl default_state will never ever
> configured again, so if after
>        probe m_can will go through PM runtime suspend/resume cycle it
> will not work any more.
> 
>   pinctrl_init_done()
>   [GS] will do nothing in case !init_state
> 
> As per above, if sleep_state is defined the m_can seems should not work
> at all without your patch,
> as there is no code path to switch back sleep_state->default_state.
> And over all PM runtime m_can code is mixed with System suspend code and
> so not correct.
> 
> Also, the very good question - Is it really required to toggle pinctrl
> states as part of PM runtime?
> (usually it's enough to handle it only during System suspend).

I suspect this discussion is somewhat a separate topic from what this
patch is trying to fix ?
