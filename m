Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C39135AD88
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 15:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhDJNVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 09:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbhDJNVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 09:21:15 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA79C061762;
        Sat, 10 Apr 2021 06:21:01 -0700 (PDT)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4FHbGz2nZ8z1s0B4;
        Sat, 10 Apr 2021 15:20:59 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4FHbGz1hMrz1qqwx;
        Sat, 10 Apr 2021 15:20:59 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id mgvrU88JaMk4; Sat, 10 Apr 2021 15:20:57 +0200 (CEST)
X-Auth-Info: W0f32ZT/85jov75Dav2mYoBVk+0+67dwybr4FQ8tpVk=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 10 Apr 2021 15:20:57 +0200 (CEST)
Subject: Re: [PATCH stable] gpiolib: Read "gpio-line-names" from a firmware
 node
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org, Roman Guskov <rguskov@dh-electronics.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <20210410090919.3157-1-brgl@bgdev.pl> <YHGVE1hMDUiK0P2A@kroah.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <e76d59f9-37ff-b31e-0131-113a1eedd786@denx.de>
Date:   Sat, 10 Apr 2021 15:20:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YHGVE1hMDUiK0P2A@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/10/21 2:07 PM, Greg Kroah-Hartman wrote:
> On Sat, Apr 10, 2021 at 11:09:19AM +0200, Bartosz Golaszewski wrote:
>> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>>
>> On STM32MP1, the GPIO banks are subnodes of pin-controller@50002000,
>> see arch/arm/boot/dts/stm32mp151.dtsi. The driver for
>> pin-controller@50002000 is in drivers/pinctrl/stm32/pinctrl-stm32.c
>> and iterates over all of its DT subnodes when registering each GPIO
>> bank gpiochip. Each gpiochip has:
>>
>>    - gpio_chip.parent = dev,
>>      where dev is the device node of the pin controller
>>    - gpio_chip.of_node = np,
>>      which is the OF node of the GPIO bank
>>
>> Therefore, dev_fwnode(chip->parent) != of_fwnode_handle(chip.of_node),
>> i.e. pin-controller@50002000 != pin-controller@50002000/gpio@5000*000.
>>
>> The original code behaved correctly, as it extracted the "gpio-line-names"
>> from of_fwnode_handle(chip.of_node) = pin-controller@50002000/gpio@5000*000.
>>
>> To achieve the same behaviour, read property from the firmware node.
>>
>> Fixes: 7cba1a4d5e162 ("gpiolib: generalize devprop_gpiochip_set_names() for device properties")
>> Cc: stable@vger.kernel.org
>> Reported-by: Marek Vasut <marex@denx.de>
>> Reported-by: Roman Guskov <rguskov@dh-electronics.com>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Tested-by: Marek Vasut <marex@denx.de>
>> Reviewed-by: Marek Vasut <marex@denx.de>
>> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>> ---
>> Hi Greg,
>>
>> This patch somehow got lost and never made its way into stable. Could you
>> please apply it?
> 
> This has been added and removed more times than I can remember already.
> 
> Are you all _SURE_ this is safe for a stable kernel release?  Look in
> the archives for complaints when we added this in the past.

I now tested this on stm32mp1, which was the original platform that got 
affected by the problem this is supposed to fix, and I can confirm this 
patch fixes the problem there.

So for what it's worth
Tested-by: Marek Vasut <marex@denx.de> # on stm32mp1
