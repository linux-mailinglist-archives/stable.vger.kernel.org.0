Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D608320DB8
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 21:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhBUUwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 15:52:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51628 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230375AbhBUUwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Feb 2021 15:52:53 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lDvhz-007il1-Q2; Sun, 21 Feb 2021 21:52:03 +0100
Date:   Sun, 21 Feb 2021 21:52:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mvebu-dt] ARM: dts: turris-omnia: configure LED[2]/INTn
 pin as interrupt pin
Message-ID: <YDLH8z9R7EQHFEkU@lunn.ch>
References: <20210220231144.32325-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210220231144.32325-1-kabel@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 21, 2021 at 12:11:44AM +0100, Marek Behún wrote:
> Use the `marvell,reg-init` DT property to configure the LED[2]/INTn pin
> of the Marvell 88E1514 ethernet PHY on Turris Omnia into interrupt mode.
> 
> Without this the pin is by default in LED[2] mode, and the Marvell PHY
> driver configures LED[2] into "On - Link, Blink - Activity" mode.
> 
> This fixes the issue where the pca9538 GPIO/interrupt controller (which
> can't mask interrupts in HW) received too many interrupts and after a
> time started ignoring the interrupt with error message:
>   IRQ 71: nobody cared
> 
> There is a work in progress to have the Marvell PHY driver support
> parsing PHY LED nodes from OF and registering the LEDs as Linux LED
> class devices. Once this is done the PHY driver can also automatically
> set the pin into INTn mode if it does not find LED[2] in OF.
> 
> Until then, though, we fix this via `marvell,reg-init` DT property.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Reported-by: Rui Salvaterra <rsalvaterra@gmail.com>
> Fixes: 26ca8b52d6e1 ("ARM: dts: add support for Turris Omnia")
> Cc: Uwe Kleine-König <uwe@kleine-koenig.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory CLEMENT <gregory.clement@bootlin.com>
> Cc: <stable@vger.kernel.org>

Hi Marek

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

> This patch fixes bug introduced with the commit that added Turris
> Omnia's DTS (26ca8b52d6e1), but will not apply cleanly because there is
> commit 8ee4a5f4f40d which changed node name and node compatible
> property and this commit did not go into stable.
> 
> So either commit 8ee4a5f4f40d has also to go into stable before this, or
> this patch has to be fixed a little in order to apply to 4.14+.

Once this has made it into Linus's tree, you can give GregKH a version
which will apply cleanly to 4.14.  Reference the upstream version so
they can be linked together.

     Andrew
