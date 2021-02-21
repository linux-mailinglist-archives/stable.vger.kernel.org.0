Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A7E320DDB
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 22:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhBUVTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 16:19:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51658 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbhBUVTf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Feb 2021 16:19:35 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lDw7s-007j2k-TV; Sun, 21 Feb 2021 22:18:48 +0100
Date:   Sun, 21 Feb 2021 22:18:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mvebu-dt] ARM: dts: turris-omnia: configure LED[2]/INTn
 pin as interrupt pin
Message-ID: <YDLOOMW+VEhchh7n@lunn.ch>
References: <20210220231144.32325-1-kabel@kernel.org>
 <YDGlESUA6pOAm9JL@lunn.ch>
 <20210221014756.7c444c08@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210221014756.7c444c08@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> BTW do you have some experience where pca9538 or compatible cause
> errors when used for interrupts? Because I am thinking about trying
> to update the pca953x driver to support IRQs via the gpio_chip it
> registers, instead of a separate irq_chip.

I had a board which just died at boot with an interrupt storm. It was
probably a PCA9554, at least, i have that datasheet in my collection.

First off, the hardware needs to designed correctly. All unused pins
need a pull up/down since they default to inputs, and hence will
trigger interrupts. Or you need to make unused pins outputs before you
enable interrupts. And that probably goes against the design of the
GPIO subsystem. I don't think you actually know when a pin is unused.

I'm not sure i would want to touch this driver. Given how badly this
device implements interrupts, any board which does successfully use it
for interrupts might regress if you make code changes. And then you
are going to have to try to figure out what you actually changed and
why it regressed.

    Andrew
