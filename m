Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43703207DC
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 01:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhBUAsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Feb 2021 19:48:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229811AbhBUAsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Feb 2021 19:48:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2750E64EEC;
        Sun, 21 Feb 2021 00:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613868480;
        bh=r14iUsjUvnohout+zDvHf58KhX6qgwjdyP6eV/RkbAM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rRAslTVA6aCbhpQFBDCTygRPzLmQKYyE7HbzPXQ5vOCeC3TXG+VnMdSCLPQsgjpF9
         oUK5JMvBHrVDLQn03lxB0Rq3Nv1g9l2uL4HQm4a4V+ukvuVDhy7dFHw8DHkHT4yD5Z
         OnxqJige04464iGGJF60GregC0BEop7cgQ4q4sJLbUUqn29kLNs9mSdxhf0fzNX9/C
         VDx8hiPLFkitRLKWR1L0JdRRvZisyxe7M3p0bG34eDmEynfy1SePVJf+E2B3qytGor
         pAyLMj4wLRFcYYX60kLug3PTLNhNcM1enzvrvajydvIn5THwvCKAjMtX72MPEjlVNa
         N87y2Gp4GYrbw==
Date:   Sun, 21 Feb 2021 01:47:56 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <uwe@kleine-koenig.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mvebu-dt] ARM: dts: turris-omnia: configure LED[2]/INTn
 pin as interrupt pin
Message-ID: <20210221014756.7c444c08@kernel.org>
In-Reply-To: <YDGlESUA6pOAm9JL@lunn.ch>
References: <20210220231144.32325-1-kabel@kernel.org>
        <YDGlESUA6pOAm9JL@lunn.ch>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 21 Feb 2021 01:10:57 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Sun, Feb 21, 2021 at 12:11:44AM +0100, Marek Beh=C3=BAn wrote:
> > Use the `marvell,reg-init` DT property to configure the LED[2]/INTn pin
> > of the Marvell 88E1514 ethernet PHY on Turris Omnia into interrupt mode.
> >=20
> > Without this the pin is by default in LED[2] mode, and the Marvell PHY
> > driver configures LED[2] into "On - Link, Blink - Activity" mode.
> >=20
> > This fixes the issue where the pca9538 GPIO/interrupt controller (which
> > can't mask interrupts in HW) received too many interrupts and after a
> > time started ignoring the interrupt with error message:
> >   IRQ 71: nobody cared =20
>=20
> Hi Marek
>=20
> The pca9538 and alike are a poor choice for interrupts. As you said,
> you cannot mask interrupts, and input are interrupt sources.
>=20
> With this change, does it actually work reliably? It looks like all
> the inputs you have support polling. And because this devices is so
> unreliable with interrupts, interrupt support is mostly not built. I
> would not expect a distribution kernel to enable interrupt support for
> this driver. Does all the code correctly fall back to polling when
> interrupts are not available?
>=20
> So although the patch looks O.K, i'm just wonder if it is worth it, or
> the better fix is to remove the interrupt configuration from the
> pca9538 node.
>=20
> 	Andrew

Hi Andrew,

- we already discussed this and you explained to me that pca9538 is poor
  as an interrupt source. That is why I did not send patch adding
  interrupt-source to the PHY node last time. We are polling the PHY
  for interrupts for now

- I would like to try this though, and see whether it will cause
  problems. Unfortunately I forgot to do this last time

- nonetheless the pin is connected as an interrupt on the board, so I
  think that the PHY driver should configure it that way, even if the
  INT signal is not used

- removing the interrupts property from the pca9538 controller node
  would solve the issue as well. The other pins on the controller are
  used for SFP cage GPIOs and the way the pca953x driver is written,
  the GPIOs are polled anyway - the interrupt is not used for them

All in all I think for now this solution is best (since the pin is
_meant_ to be used as an interrupt pin on the board and the issue is
solved by this patch).

BTW do you have some experience where pca9538 or compatible cause
errors when used for interrupts? Because I am thinking about trying
to update the pca953x driver to support IRQs via the gpio_chip it
registers, instead of a separate irq_chip.

Marek
