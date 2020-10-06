Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08047284BA4
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 14:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgJFMbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 08:31:55 -0400
Received: from mailout02.rmx.de ([62.245.148.41]:57880 "EHLO mailout02.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726241AbgJFMby (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Oct 2020 08:31:54 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout02.rmx.de (Postfix) with ESMTPS id 4C5H060bwnzNl5N;
        Tue,  6 Oct 2020 14:31:50 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4C5Gzj2lCWz2xbl;
        Tue,  6 Oct 2020 14:31:29 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.66) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 6 Oct
 2020 14:30:56 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     David Laight <David.Laight@aculab.com>
CC:     Oleksij Rempel <linux@rempel-privat.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v3 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Date:   Tue, 6 Oct 2020 14:30:55 +0200
Message-ID: <2080355.2eSLTprjVn@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <f8f1a9f54e0e426dbe27cc13a3b9de8d@AcuMS.aculab.com>
References: <20201006060528.drh2yoo2dklyntez@pengutronix.de> <20201006105135.28985-2-ceggers@arri.de> <f8f1a9f54e0e426dbe27cc13a3b9de8d@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.66]
X-RMX-ID: 20201006-143135-4C5Gzj2lCWz2xbl-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi David,

On Tuesday, 6 October 2020, 14:06:36 CEST, David Laight wrote:
> From: Christian Eggers
> > +static void i2c_imx_clear_irq(struct imx_i2c_struct *i2c_imx, unsigned
> > int bits) +{
> > +	unsigned int temp;
> > +
> > +	/*
> > +	 * i2sr_clr_opcode is the value to clear all interrupts.
> > +	 * Here we want to clear only <bits>, so we write
> > +	 * ~i2sr_clr_opcode with just <bits> toggled.
> > +	 */
> > +	temp = ~i2c_imx->hwdata->i2sr_clr_opcode ^ bits;
> > +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
> > +}
> 
> That looks either wrong or maybe just overcomplicated.
Yes, it looks so.

> Why isn't:
> 	imx_i2c_write_reg(bits, i2c_imx, IMX_I2C_I2SR);
> enough?
i.MX requires W1C and Vybrid requires W0C in order to clear status bits.

> More usually you just write back the read value of such
> 'write 1 to clear' status registers and then act on all
> the set bits.
This pattern has been suggested by Uwe Klein-Koenig. It works because write 
access to read-only register bits is ignored, independent whether 0 or 1 is 
written. W0C is quite unusual, but I didn't design the hardware... The pattern 
ensures that not accidentally more status bits are cleared than desired.

> That ensures you clear all interrupts that were pending.
I think that Uwe's intention was not clearing bits which are not handled at 
this place. Otherwise events may get lost.

> If you need to avoid writes of bits that aren't in the
> 'clear all interrupts' value then you just need:
> 	bits &= i2c_imx->hwdata->i2sr_clr_opcode;
> prior to the write.
I think this wouldn't fit the W0C case for Vybrid.

Best regards
Christian



