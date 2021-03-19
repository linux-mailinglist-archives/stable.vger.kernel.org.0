Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE756341CED
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhCSM1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhCSM11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 08:27:27 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B34C06174A;
        Fri, 19 Mar 2021 05:27:27 -0700 (PDT)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4F237K6NRyz1rwmj;
        Fri, 19 Mar 2021 13:27:25 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4F237K5SLrz1sP6p;
        Fri, 19 Mar 2021 13:27:25 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id MU9L8Oh3MJrv; Fri, 19 Mar 2021 13:27:24 +0100 (CET)
X-Auth-Info: bYCrlARcTWfl6al/iUdn1szIH6OAWhWOabP4GkDjfyk=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 19 Mar 2021 13:27:24 +0100 (CET)
Subject: Re: [PATCH 5.11 12/31] gpiolib: Read "gpio-line-names" from a
 firmware node
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Roman Guskov <rguskov@dh-electronics.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
References: <20210319121747.203523570@linuxfoundation.org>
 <20210319121747.594813307@linuxfoundation.org>
From:   Marek Vasut <marex@denx.de>
Message-ID: <5c3f2fb9-c1bf-5939-2e83-8cd0fa6d0c20@denx.de>
Date:   Fri, 19 Mar 2021 13:27:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210319121747.594813307@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/19/21 1:19 PM, Greg Kroah-Hartman wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> [ Upstream commit b41ba2ec54a70908067034f139aa23d0dd2985ce ]
> 
> On STM32MP1, the GPIO banks are subnodes of pin-controller@50002000,
> see arch/arm/boot/dts/stm32mp151.dtsi. The driver for
> pin-controller@50002000 is in drivers/pinctrl/stm32/pinctrl-stm32.c
> and iterates over all of its DT subnodes when registering each GPIO
> bank gpiochip. Each gpiochip has:
> 
>    - gpio_chip.parent = dev,
>      where dev is the device node of the pin controller
>    - gpio_chip.of_node = np,
>      which is the OF node of the GPIO bank
> 
> Therefore, dev_fwnode(chip->parent) != of_fwnode_handle(chip.of_node),
> i.e. pin-controller@50002000 != pin-controller@50002000/gpio@5000*000.
> 
> The original code behaved correctly, as it extracted the "gpio-line-names"
> from of_fwnode_handle(chip.of_node) = pin-controller@50002000/gpio@5000*000.
> 
> To achieve the same behaviour, read property from the firmware node.

I think we agreed to drop this one for now before, see
[PATCH 5.10 081/290] gpiolib: Read "gpio-line-names" from a firmware node
Message-ID: <YFIo3A14Fb4Hty4O@kroah.com>
