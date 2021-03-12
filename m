Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381AD338819
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 09:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhCLI7B convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 12 Mar 2021 03:59:01 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:33133 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbhCLI6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 03:58:36 -0500
Received: from localhost (lfbn-lyo-1-1912-141.w90-65.abo.wanadoo.fr [90.65.91.141])
        (Authenticated sender: gregory.clement@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 8628924000B;
        Fri, 12 Mar 2021 08:58:34 +0000 (UTC)
From:   Gregory CLEMENT <gregory.clement@bootlin.com>
To:     Marek =?utf-8?Q?Beh=C3=BAn?= <kabel@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, pali@kernel.org,
        Marek =?utf-8?Q?Beh=C3=BAn?= <kabel@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH mvebu + mvebu/dt64 4/4] arm64: dts: marvell:
 armada-37xx: move firmware node to generic dtsi file
In-Reply-To: <20210308153703.23097-4-kabel@kernel.org>
References: <20210308153703.23097-1-kabel@kernel.org>
 <20210308153703.23097-4-kabel@kernel.org>
Date:   Fri, 12 Mar 2021 09:58:34 +0100
Message-ID: <87czw4kath.fsf@BL-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Marek,

> From: Pali Rohár <pali@kernel.org>
>
> Move the turris-mox-rwtm firmware node from Turris MOX' device tree into
> the generic armada-37xx.dtsi file.

I disagree with this patch. This firmware is specific to Turris MOX so
it is not something that should be exposed to all the Armada 3700 based
boards.

If you want you still can create an dtsi for this and include it when
needed.

Gregory

>
> The Turris MOX rWTM firmware can be used on any Armada 37xx device,
> giving them access to the rWTM hardware random number generator, which
> is otherwise unavailable.
>
> This change allows Linux to load the turris-mox-rwtm.ko module on these
> boards.
>
> Tested on ESPRESSObin v5 with both default Marvell WTMI firmware and
> CZ.NIC's firmware. With default WTMI firmware the turris-mox-rwtm fails
> to probe, while with CZ.NIC's firmware it registers the HW random number
> generator.
>
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: <stable@vger.kernel.org> # 5.4+: 46d2f6d0c99f ("arm64: dts: armada-3720-turris-mox: add firmware node")
> ---
>  arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts | 8 --------
>  arch/arm64/boot/dts/marvell/armada-37xx.dtsi           | 8 ++++++++
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
> index d239ab70ed99..8447f303a294 100644
> --- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
> +++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
> @@ -107,14 +107,6 @@ sfp: sfp {
>  		/* enabled by U-Boot if SFP module is present */
>  		status = "disabled";
>  	};
> -
> -	firmware {
> -		turris-mox-rwtm {
> -			compatible = "cznic,turris-mox-rwtm";
> -			mboxes = <&rwtm 0>;
> -			status = "okay";
> -		};
> -	};
>  };
>  
>  &i2c0 {
> diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
> index 7a2df148c6a3..31126f1ffe5b 100644
> --- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
> +++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
> @@ -503,4 +503,12 @@ pcie_intc: interrupt-controller {
>  			};
>  		};
>  	};
> +
> +	firmware {
> +		turris-mox-rwtm {
> +			compatible = "cznic,turris-mox-rwtm";
> +			mboxes = <&rwtm 0>;
> +			status = "okay";
> +		};
> +	};
>  };
> -- 
> 2.26.2
>

-- 
Gregory Clement, Bootlin
Embedded Linux and Kernel engineering
http://bootlin.com
