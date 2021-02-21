Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEEF320E56
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 23:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhBUWlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 17:41:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230388AbhBUWlD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Feb 2021 17:41:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B90B464DEC;
        Sun, 21 Feb 2021 22:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613947222;
        bh=baXjPoBQbqjfVUYjCiZRD8nOg7OnrLQQYrPT4lQChgo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uSxc5btfZ0mg83/kIVoO1jrg3sFcnECNFv/9gzlAZfwJFgPm086Ma+WrA7Tyh0gzR
         mExG+9urn98IOOfUGsWqqxGtPHEPxcnAXZZva/Cxv2/jk5exl/EsnBqngcVCK9R8tP
         8CP1VP3zhW3zmoQHGlbN3vtNtPGfob8BI+RWj1OZxA0jHxNvcoZQzgDhFpfKcW0W5I
         0O1DN94wvkQYpMLCe/GxBRm5xN6X2qvxzMoKRUnOePeU1j7F82lJS2XDxXU8lrmsOz
         322fjfz1zmtAuJG8zMgbE2Jvdm0urVZ3VGFZEmfbjf1ZrrTO08rJV5vaRqT3ZafMWK
         vyDAO1bx78LTA==
Date:   Sun, 21 Feb 2021 23:40:19 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <uwe@kleine-koenig.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mvebu-dt] ARM: dts: turris-omnia: configure LED[2]/INTn
 pin as interrupt pin
Message-ID: <20210221234019.53284201@kernel.org>
In-Reply-To: <YDLOOMW+VEhchh7n@lunn.ch>
References: <20210220231144.32325-1-kabel@kernel.org>
        <YDGlESUA6pOAm9JL@lunn.ch>
        <20210221014756.7c444c08@kernel.org>
        <YDLOOMW+VEhchh7n@lunn.ch>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 21 Feb 2021 22:18:48 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> > BTW do you have some experience where pca9538 or compatible cause
> > errors when used for interrupts? Because I am thinking about trying
> > to update the pca953x driver to support IRQs via the gpio_chip it
> > registers, instead of a separate irq_chip.  
> 
> I had a board which just died at boot with an interrupt storm. It was
> probably a PCA9554, at least, i have that datasheet in my collection.

But why did an interrupt storm kill it? The interrupt handler was called
too many times?

> First off, the hardware needs to designed correctly. All unused pins
> need a pull up/down since they default to inputs, and hence will
> trigger interrupts. Or you need to make unused pins outputs before you
> enable interrupts. And that probably goes against the design of the
> GPIO subsystem. I don't think you actually know when a pin is unused.

Omnia has proper pull ups/downs on all 8 pins on this device.
5 of these pins are used from SFP cage, 1 as interrupt from PHY and 2
are unused. Only the interrupt pin was causing problems because marvell
PHY driver configured it as blink on activity LED.

> I'm not sure i would want to touch this driver. Given how badly this
> device implements interrupts, any board which does successfully use it
> for interrupts might regress if you make code changes. And then you
> are going to have to try to figure out what you actually changed and
> why it regressed.

The problem in this driver is:
- interrupt handler is called every time an input pin changes
- not all input pins must be used as interrupt sources
- if at least one input pin is used as an interrupt source,
  the interrupt handler is being called on every change of every input
  pin
- but if the change occurs on a pin that is not used as an interrupt
  source, the interrupt handler returns IRQ_NONE
- a simple scenario to achieve error:
  1. use pin P0 as interrupt source and P1 as GPIO input; other
     pins as outputs
  2. connect P1 to something that changes value
  3. after 10000 changes of P1 (more if there was a change on P0 at the
     same time) the interrupt handler will return IRQ_NONE 10000 times
     and kernel will start ignoring interrupts from this driver because
     it was returning IRQ_NONE
I think this needs to be fixed in this driver. Either this function
should return IRQ_HANDLED in this case, or there should be a third
option to return, something like IRQ_NONE_BUT_THATS_OK

Marek
