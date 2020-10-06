Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E587284C02
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 14:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgJFMwS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 6 Oct 2020 08:52:18 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:26865 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbgJFMwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 08:52:18 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-175-iBaE_rrVMleJghRdH_nzjQ-1; Tue, 06 Oct 2020 13:52:14 +0100
X-MC-Unique: iBaE_rrVMleJghRdH_nzjQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 6 Oct 2020 13:52:13 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 6 Oct 2020 13:52:13 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     =?iso-8859-1?Q?=27Uwe_Kleine-K=F6nig=27?= 
        <u.kleine-koenig@pengutronix.de>
CC:     'Christian Eggers' <ceggers@arri.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: RE: [PATCH v3 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Thread-Topic: [PATCH v3 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Thread-Index: AQHWm9AgZjObf1H2UEeBlb1lAcQDOamKeLbg///8MQCAABElQA==
Date:   Tue, 6 Oct 2020 12:52:13 +0000
Message-ID: <0ccbfc8fe2a44796a61e59d1527fe6be@AcuMS.aculab.com>
References: <20201006060528.drh2yoo2dklyntez@pengutronix.de>
 <20201006105135.28985-1-ceggers@arri.de>
 <20201006105135.28985-2-ceggers@arri.de>
 <f8f1a9f54e0e426dbe27cc13a3b9de8d@AcuMS.aculab.com>
 <20201006124602.oxfyzb3atoju7sva@pengutronix.de>
In-Reply-To: <20201006124602.oxfyzb3atoju7sva@pengutronix.de>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König
> Sent: 06 October 2020 13:46
...
> > > +static void i2c_imx_clear_irq(struct imx_i2c_struct *i2c_imx, unsigned int bits)
> > > +{
> > > +	unsigned int temp;
> > > +
> > > +	/*
> > > +	 * i2sr_clr_opcode is the value to clear all interrupts.
> > > +	 * Here we want to clear only <bits>, so we write
> > > +	 * ~i2sr_clr_opcode with just <bits> toggled.
> > > +	 */
> > > +	temp = ~i2c_imx->hwdata->i2sr_clr_opcode ^ bits;
> > > +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
> > > +}
> >
> > That looks either wrong or maybe just overcomplicated.
> > Why isn't:
> > 	imx_i2c_write_reg(bits, i2c_imx, IMX_I2C_I2SR);
> > enough?
> 
> Your question suggests you either didn't read the comment or the comment
> is not good enough. Maybe once you understood the complication (see
> Christian's mail) you could suggest a better wording? Maybe we have to
> mention that this handles both W1C and W0C.

Yes, the comment should just say that some devices are W1C and
other W0C.
It isn't obvious from that code fragment at all.

Now for the 3rd variant which zeros the bits when they are read :-)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

