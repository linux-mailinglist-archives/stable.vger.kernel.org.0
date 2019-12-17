Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2534F122915
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 11:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfLQKmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 05:42:32 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:60470 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfLQKmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 05:42:31 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xBHAgJkS114920;
        Tue, 17 Dec 2019 04:42:19 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1576579339;
        bh=1sfeqeM1+RlzcS5+Ym9j8OrAQauzgkDn7TOStWh03YU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=rO0dXs4lZWI/ZQuYF+5sPVqgaezfyFJZq8Xq1AbhwYcWEVLe7UBWgqEnXbuEnD1am
         oOyG8lkuZOPSnvYLZciwrCW8kY7HpVZrdm67NGjRBrHhJv1Q88zBrs3VuKMJmiwyFw
         Vn4ra7INbkE7b8RlxFvne8MS9t7lKH1NnmAXHx9Y=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xBHAgJVd053999
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Dec 2019 04:42:19 -0600
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 17
 Dec 2019 04:42:19 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 17 Dec 2019 04:42:19 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xBHAgHJ9006314;
        Tue, 17 Dec 2019 04:42:18 -0600
Subject: Re: [PATCH] can: m_can: Fix default pinmux glitch at init
To:     Marek Vasut <marex@denx.de>, <linux-can@vger.kernel.org>
CC:     Bich Hemon <bich.hemon@st.com>,
        "J . D . Schroeder" <jay.schroeder@garmin.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Roger Quadros <rogerq@ti.com>,
        linux-stable <stable@vger.kernel.org>
References: <20191217100740.2687835-1-marex@denx.de>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <8b2e0a40-cf23-58a5-4f52-215015c61ea8@ti.com>
Date:   Tue, 17 Dec 2019 12:42:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191217100740.2687835-1-marex@denx.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 17/12/2019 12:07, Marek Vasut wrote:
> The current code causes a slight glitch on the pinctrl settings when used.
> Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
> the device core will automatically set the default pins. This causes the pins
> to be momentarily set to the default and then to the sleep state in
> register_m_can_dev(). By adding an optional "enable" state, boards can set the
> default pin state to be disabled and avoid the glitch when the switch from
> default to sleep first occurs. If the "enable" state is not available
> pinctrl_get_select() falls back to using the "default" pinctrl state.
> 
> Fixes: c9b3bce18da4 ("can: m_can: select pinctrl state in each suspend/resume function")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Bich Hemon <bich.hemon@st.com>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Cc: J.D. Schroeder <jay.schroeder@garmin.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: Roger Quadros <rogerq@ti.com>
> Cc: linux-stable <stable@vger.kernel.org>
> To: linux-can@vger.kernel.org
> ---
> NOTE: This is commit 033365191136 ("can: c_can: Fix default pinmux glitch at init")
>        adapted for m_can driver.
> ---
>   drivers/net/can/m_can/m_can.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 02c5795b73936..afb6760b17427 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1243,12 +1243,20 @@ static void m_can_chip_config(struct net_device *dev)
>   static void m_can_start(struct net_device *dev)
>   {
>   	struct m_can_classdev *cdev = netdev_priv(dev);
> +	struct pinctrl *p;
>   
>   	/* basic m_can configuration */
>   	m_can_chip_config(dev);
>   
>   	cdev->can.state = CAN_STATE_ERROR_ACTIVE;
>   
> +	/* Attempt to use "active" if available else use "default" */
> +	p = pinctrl_get_select(cdev->dev, "active");
> +	if (!IS_ERR(p))
> +		pinctrl_put(p);
> +	else
> +		pinctrl_pm_select_default_state(cdev->dev);
> +
>   	m_can_enable_all_interrupts(cdev);
>   }
>   
> 

May be init state should be used - #define PINCTRL_STATE_INIT "init" instead?

-- 
Best regards,
grygorii
