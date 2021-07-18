Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6083CC70D
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 02:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhGRAmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 20:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230259AbhGRAmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 20:42:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83B5D610CD;
        Sun, 18 Jul 2021 00:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626568747;
        bh=UjYo2V0cXJyspi9AgX26xgd83MEXg3QGm8D9TQwRIt8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fxyf2mO8PJrZSzLuZk/HO6MeLoe8dkSgzwBezY1Son2QTPNBIiecYq7zse6MO+x7Z
         mzHZE0xYxsn9kgnclS2Dm+v0tgC2iAAwpneW88yWWecalj5AzUkML7G169iyGkvSby
         +uGeOKpCiIvqrgQcYkjgMpXmS1W2+ppybzeTwfA6NvC7YmwNeF43ciqmnhFusN71sE
         +3b/z/BFaaVgUWbFlR2RMZUJWAZQ+AuGpm0D8DXJZ86Z0X3a1qVeg5UIX2BnjIMSGf
         X5rIJErSoWBctNIvem62E3o5ER/Y8qCxfO9obRrJmekasJG7aFLsur10vK4qYuJzVk
         XDAKESYWndqEQ==
Date:   Sat, 17 Jul 2021 20:39:06 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jim Quinlan <jim2101024@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Al Cooper <alcooperx@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 013/114] serial: 8250: of: Check for
 CONFIG_SERIAL_8250_BCM7271
Message-ID: <YPN4KiU/50HGeXHj@sashalap>
References: <20210710021748.3167666-1-sashal@kernel.org>
 <20210710021748.3167666-13-sashal@kernel.org>
 <b431c751-0a45-47f1-c5c6-7ca02581ad57@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b431c751-0a45-47f1-c5c6-7ca02581ad57@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 09, 2021 at 07:33:25PM -0700, Florian Fainelli wrote:
>
>
>On 7/9/2021 7:16 PM, Sasha Levin wrote:
>>From: Jim Quinlan <jim2101024@gmail.com>
>>
>>[ Upstream commit f5b08386dee439c7a9e60ce0a4a4a705f3a60dff ]
>>
>>Our SoC's have always had a NS16650A UART core and older SoC's would
>>have a compatible string of: 'compatible = ""ns16550a"' and use the
>>8250_of driver. Our newer SoC's have added enhancements to the base
>>core to add support for DMA and accurate high speed baud rates and use
>>this newer 8250_bcm7271 driver. The Device Tree node for our enhanced
>>UARTs has a compatible string of: 'compatible = "brcm,bcm7271-uart",
>>"ns16550a"''. With both drivers running and the link order setup so
>>that the 8250_bcm7217 driver is initialized before the 8250_of driver,
>>we should bind the 8250_bcm7271 driver to the enhanced UART, or for
>>upstream kernels that don't have the 8250_bcm7271 driver, we bind to
>>the 8250_of driver.
>>
>>The problem is that when both the 8250_of and 8250_bcm7271 drivers
>>were running, occasionally the 8250_of driver would be bound to the
>>enhanced UART instead of the 8250_bcm7271 driver. This was happening
>>because we use SCMI based clocks which come up late in initialization
>>and cause probe DEFER's when the two drivers get their clocks.
>>
>>Occasionally the SCMI clock would become ready between the 8250_bcm7271
>>probe and the 8250_of probe and the 8250_of driver would be bound. To
>>fix this we decided to config only our 8250_bcm7271 driver and added
>>"ns16665a0" to the compatible string so the driver would work on our
>>older system.
>>
>>This commit has of_platform_serial_probe() check specifically for the
>>"brcm,bcm7271-uart" and whether its companion driver is enabled. If it
>>is the case, and the clock provider is not ready, we want to make sure
>>that when the 8250_bcm7271.c driver returns EPROBE_DEFER, we are not
>>getting the UART registered via 8250_of.c.
>>
>>Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
>>Signed-off-by: Jim Quinlan <jim2101024@gmail.com>
>>Signed-off-by: Al Cooper <alcooperx@gmail.com>
>>Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>Link: https://lore.kernel.org/r/20210423183206.3917725-1-f.fainelli@gmail.com
>>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This commit is only relevant with 
>41a469482de257ea8db43cf74b6311bd055de030 ("serial: 8250: Add new 
>8250-core based Broadcom STB driver") which is included in v5.13 and 
>newer. You would want to drop that commit from the 5.12, 5.10 and 5.4 
>auto-selection.

I'll drop it from 5.12 and older, thanks!

-- 
Thanks,
Sasha
