Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1B1280E6A
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 10:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgJBICU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 2 Oct 2020 04:02:20 -0400
Received: from mailout04.rmx.de ([94.199.90.94]:35400 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgJBICT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Oct 2020 04:02:19 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4C2jBv40lMz3qvQv;
        Fri,  2 Oct 2020 10:02:15 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4C2jBV62Vyz2TRjV;
        Fri,  2 Oct 2020 10:01:54 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.43) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 2 Oct
 2020 10:01:31 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
CC:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Date:   Fri, 2 Oct 2020 10:01:30 +0200
Message-ID: <3615207.ozermb6hxN@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20200925081101.dthsj4hokqz2vsgp@pengutronix.de>
References: <20200917122029.11121-1-ceggers@arri.de> <16013235.tl8pWZfNaG@n95hx1g2> <20200925081101.dthsj4hokqz2vsgp@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [192.168.54.43]
X-RMX-ID: 20201002-100156-4C2jBV62Vyz2TRjV-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Uwe,

On Friday, 25 September 2020, 10:11:01 CEST, Uwe Kleine-König wrote:
> On Thu, Sep 17, 2020 at 04:13:50PM +0200, Christian Eggers wrote:
> > On Thursday, 17 September 2020, 16:02:35 CEST, Uwe Kleine-König wrote:
> > > On Thu, Sep 17, 2020 at 02:20:27PM +0200, Christian Eggers wrote:
> > > ...
> > > 
> > > >             /* check for arbitration lost */
> > > >             if (temp & I2SR_IAL) {
> > > >             
> > > >                     temp &= ~I2SR_IAL;
> > > > 
> > > > +                   temp |= (i2c_imx->hwdata->i2sr_clr_opcode & I2SR_IAL);
> > > > 
> > > >                     imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
> > > >                     return -EAGAIN;
> > > 
> > > ...
> > > 
> > > This looks strange. First the flag is cleared and then it is (in some
> > > cases) set again.
> > 
> > i.MX controllers require writing a 0 to clear these bits. Vybrid
> > controllers need writing a 1 for the same.
> 
> Yes, I understood that.
> 
> > > If I2SR_IIF is set in temp you ack this irq without handling it. (Which
> > > might happen if atomic is set and irqs are off?!)
> > 
> > This patch is only about using the correct processor specific value for
> > acknowledging an IRQ... But I think that returning EAGAIN (which aborts
> > the
> > transfer) should be handling enough. At the next transfer, the controller
> > will be set back to master mode.
> 
> Either you didn't understand what I meant, or I don't understand why you
> consider your patch right anyhow. 
Probably both.

> So I try to explain in other and more words.
> 
> IMHO the intention here (and also what happens on i.MX) is that exactly
> the AL interrupt pending bit should be cleared and the IF irq is
> supposed to be untouched.
Yes.

> Given there are only two irq flags in the I2SR register (which is called
> IBSR on Vybrid) ...

Vybrid:
=======
+-------+-----+------+-----+------+-----+-----+------+------+
| BIT   |  7  |  6   |  5  |  4   |  3  |  2  |  1   |  0   |
+-------+-----+------+-----+------+-----+-----+------+------+
| READ  | TCF | IAAS | IBB | IBAL |  0  | SRW | IBIF | RXAK |
+-------+-----+------+-----+------+-----+-----+------+------+
| WRITE |  -  |  -   |  -  | W1C  |  -  |  -  | W1C  |  -   |
+-------+-----+------+-----+-^^^--+-----+-----+-^^^--+------+

i.MX:
=======
+-------+-----+------+-----+------+-----+-----+------+------+
| BIT   |  7  |  6   |  5  |  4   |  3  |  2  |  1   |  0   |
+-------+-----+------+-----+------+-----+-----+------+------+
| READ  | ICF | IAAS | IBB | IAL  |  0  | SRW | IIF  | RXAK |
+-------+-----+------+-----+------+-----+-----+------+------+
| WRITE |  -  |  -   |  -  | W0C  |  -  |  -  | W0C  |  -   |
+-------+-----+------+-----+-^^^--+-----+-----+-^^^--+------+


> ... the status quo (i.e. without your patch) is:
> 
>   On i.MX IAL is cleared
Yes

>   On Vybrid IIF (which is called IBIF there) is cleared.
If IBIF is set, then it's cleared (probably by accident).
But in the "if (temp & I2SR_IAL)" condition, I focus on 
the IBAL flag, not IBIF.

> With your patch we get:
> 
>   On i.MX IAL is cleared
Yes

>   On Vybrid both IIF (aka IBIF) and IAL (aka IBAL) are cleared.
Agree. IBAL is cleared by intention, IBIF by accident (if set).
Do you see any problem if IBIF is also cleared?


> To get it right for both SoC types you have to do (e.g.):
> 
> 	temp = ~i2c_imx->hwdata->i2sr_clr_opcode ^ I2SR_IAL;
Sorry, even if this is correct, it looks hard to understand for me.

> (and in i2c_imx_isr() the same using I2SR_IIF instead of I2SR_IAL
> because there currently IAL might be cleared by mistake on Vybrid).
> 
> I considered creating a patch, but as I don't have a Vybrid on my desk
> and on i.MX there is no change, I let you do this.
I also don't own a Vybrid system. I consider my patch correct in terms of
clearing the IBAL flag (which was wrong before). Additional work may be
useful for NOT clearing the other status flag. I also would like to keep
this task for somebody who owns a Vybrid system. But the other patches
in this series fixes some more important problems, so maybe you could
give your acknowledge anyhow.

Best regards
Christian




