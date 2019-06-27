Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1B0958600
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 17:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfF0Phw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 11:37:52 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:40525 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfF0Phv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 11:37:51 -0400
X-Originating-IP: 92.137.69.152
Received: from localhost (alyon-656-1-672-152.w92-137.abo.wanadoo.fr [92.137.69.152])
        (Authenticated sender: gregory.clement@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id D9B4720007;
        Thu, 27 Jun 2019 15:37:47 +0000 (UTC)
From:   Gregory CLEMENT <gregory.clement@bootlin.com>
To:     Joshua Scott <joshua.scott@alliedtelesis.co.nz>,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc:     Joshua Scott <joshua.scott@alliedtelesis.co.nz>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart serial node
In-Reply-To: <20190625221108.21455-1-joshua.scott@alliedtelesis.co.nz>
References: <20190625221108.21455-1-joshua.scott@alliedtelesis.co.nz>
Date:   Thu, 27 Jun 2019 17:37:47 +0200
Message-ID: <87sgrvghtg.fsf@FE-laptop>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Joshua Scott <joshua.scott@alliedtelesis.co.nz> writes:

> Switch to the "marvell,armada-38x-uart" driver variant to empty
> the UART buffer before writing to the UART_LCR register.
>
> Signed-off-by: Joshua Scott <joshua.scott@alliedtelesis.co.nz>
> Tested-by: Andrew Lunn <andrew@lunn.ch>
> Acked-by: Gregory CLEMENT <gregory.clement@bootlin.com>.
> Cc: stable@vger.kernel.org
> Fixes: 43e28ba87708 ("ARM: dts: Use armada-370-xp as a base for
> armada-xp-98dx3236")

Applied on mvebu/fixes

Thanks,

Gregory


>
> ---
> Changes in v3:
>
> Updated title, added tested-by, and Fixes tag
>
> Changes in v2:
>
> Andrew Lunn was able to test on a Marvell 370RD reference design, and
> the character loss issue did not occur.
>
> The fix has now been changed to only affect the following SOCs:
>  * 98DX323x
>  * 98DX3333
>  * 98DX4251
>
> v1 message:
>
> We have found that like the armada 38x, other Marvell SOCs can lose
> characters when the UART_LCR register is written to without first
> waiting for the buffer to empty.
>
> We have observed this behaviour on the following Marvell switch SOCs:
>
>  * 98DX323x
>  * 98DX3333
>  * 98DX4251
>
> However, we do not currently have access to non-switch SOCs which share
> the same parent device-tree.
>
> The question we have is, should the fix be applied to the common
> armada-370-xp device-tree, or should it be restricted to only affect the
> SOCs listed above.
>
> If anybody is able to check, we would like to find out if the issue
> affects other armada-xp / armada-370 based SOCs.
>
> The issue can be reproduced, if logging in using the serial port, with:
>     resize && echo "hello world"
>
> On affected devices, the first couple letters of "hello world" are
> lost. On some SOCs this can be seen at 115200 baud, and on others
> we have had to slow down to 9600 to see the issue.
>
> Cheers,
> Joshua Scott
> ---
>  arch/arm/boot/dts/armada-xp-98dx3236.dtsi | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/arm/boot/dts/armada-xp-98dx3236.dtsi b/arch/arm/boot/dts/armada-xp-98dx3236.dtsi
> index 59753470cd34..267d0c178e55 100644
> --- a/arch/arm/boot/dts/armada-xp-98dx3236.dtsi
> +++ b/arch/arm/boot/dts/armada-xp-98dx3236.dtsi
> @@ -336,3 +336,11 @@
>  	status = "disabled";
>  };
>  
> +&uart0 {
> +	compatible = "marvell,armada-38x-uart";
> +};
> +
> +&uart1 {
> +	compatible = "marvell,armada-38x-uart";
> +};
> +
> -- 
> 2.21.0
>

-- 
Gregory Clement, Bootlin
Embedded Linux and Kernel engineering
http://bootlin.com
