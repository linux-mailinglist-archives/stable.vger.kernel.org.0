Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B0E26DEC8
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 16:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgIQOxS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 17 Sep 2020 10:53:18 -0400
Received: from mailout09.rmx.de ([94.199.88.74]:42461 "EHLO mailout09.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbgIQOv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 10:51:28 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout09.rmx.de (Postfix) with ESMTPS id 4Bsf9R3fS6zbhsy;
        Thu, 17 Sep 2020 16:14:35 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4Bsf925k8gz2xcC;
        Thu, 17 Sep 2020 16:14:14 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.36) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 17 Sep
 2020 16:13:51 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
CC:     Oleksij Rempel <linux@rempel-privat.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Date:   Thu, 17 Sep 2020 16:13:50 +0200
Message-ID: <16013235.tl8pWZfNaG@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20200917140235.igfq2hq63f4qqhrr@pengutronix.de>
References: <20200917122029.11121-1-ceggers@arri.de> <20200917122029.11121-2-ceggers@arri.de> <20200917140235.igfq2hq63f4qqhrr@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [192.168.54.36]
X-RMX-ID: 20200917-161416-4Bsf925k8gz2xcC-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Uwe,

On Thursday, 17 September 2020, 16:02:35 CEST, Uwe Kleine-König wrote:
> Hello,
> 
> On Thu, Sep 17, 2020 at 02:20:27PM +0200, Christian Eggers wrote:
> ...
> >  		/* check for arbitration lost */
> >  		if (temp & I2SR_IAL) {
> >  			temp &= ~I2SR_IAL;
> > +			temp |= (i2c_imx->hwdata->i2sr_clr_opcode & I2SR_IAL);
> >  			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
> >  			return -EAGAIN;
> ...

> This looks strange. First the flag is cleared and then it is (in some
> cases) set again.
i.MX controllers require writing a 0 to clear these bits. Vybrid controllers
need writing a 1 for the same.

> If I2SR_IIF is set in temp you ack this irq without handling it. (Which
> might happen if atomic is set and irqs are off?!)
This patch is only about using the correct processor specific value for 
acknowledging an IRQ... But I think that returning EAGAIN (which aborts the
transfer) should be handling enough. At the next transfer, the controller will
be set back to master mode.

> I see this idiom is used in a few more places in the driver already, I
> didn't check but these might have the same problem maybe?

Best regards
Christian



