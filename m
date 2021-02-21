Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F9C3207C8
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 01:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhBUALu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Feb 2021 19:11:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51014 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229819AbhBUALq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Feb 2021 19:11:46 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lDcKv-007boz-Mi; Sun, 21 Feb 2021 01:10:57 +0100
Date:   Sun, 21 Feb 2021 01:10:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mvebu-dt] ARM: dts: turris-omnia: configure LED[2]/INTn
 pin as interrupt pin
Message-ID: <YDGlESUA6pOAm9JL@lunn.ch>
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

Hi Marek

The pca9538 and alike are a poor choice for interrupts. As you said,
you cannot mask interrupts, and input are interrupt sources.

With this change, does it actually work reliably? It looks like all
the inputs you have support polling. And because this devices is so
unreliable with interrupts, interrupt support is mostly not built. I
would not expect a distribution kernel to enable interrupt support for
this driver. Does all the code correctly fall back to polling when
interrupts are not available?

So although the patch looks O.K, i'm just wonder if it is worth it, or
the better fix is to remove the interrupt configuration from the
pca9538 node.

	Andrew
