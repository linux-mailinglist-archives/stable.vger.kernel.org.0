Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D183FB374
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 11:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhH3Jz1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 30 Aug 2021 05:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229901AbhH3JzX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 05:55:23 -0400
Received: from jic23-huawei (cpc108967-cmbg20-2-0-cust86.5-4.cable.virginm.net [81.101.6.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57EFE61041;
        Mon, 30 Aug 2021 09:54:27 +0000 (UTC)
Date:   Mon, 30 Aug 2021 10:57:38 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     "Sa, Nuno" <Nuno.Sa@analog.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 01/16] iio: adc: max1027: Fix wrong shift with 12-bit
 devices
Message-ID: <20210830105738.472b5f69@jic23-huawei>
In-Reply-To: <SJ0PR03MB6359CD425BDE36688DC9265299C19@SJ0PR03MB6359.namprd03.prod.outlook.com>
References: <20210818111139.330636-1-miquel.raynal@bootlin.com>
        <20210818111139.330636-2-miquel.raynal@bootlin.com>
        <SJ0PR03MB6359CD425BDE36688DC9265299C19@SJ0PR03MB6359.namprd03.prod.outlook.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Aug 2021 07:02:54 +0000
"Sa, Nuno" <Nuno.Sa@analog.com> wrote:

> > -----Original Message-----
> > From: Miquel Raynal <miquel.raynal@bootlin.com>
> > Sent: Wednesday, August 18, 2021 1:11 PM
> > To: Jonathan Cameron <jic23@kernel.org>; Lars-Peter Clausen
> > <lars@metafoo.de>
> > Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>; linux-
> > iio@vger.kernel.org; linux-kernel@vger.kernel.org; Miquel Raynal
> > <miquel.raynal@bootlin.com>; stable@vger.kernel.org
> > Subject: [PATCH 01/16] iio: adc: max1027: Fix wrong shift with 12-bit
> > devices
> > 
> > [External]
> > 
> > 10-bit devices must shift the value twice.
> > This is not needed anymore on 12-bit devices.
> > 
> > Fixes: ae47d009b508 ("iio: adc: max1027: Introduce 12-bit devices
> > support")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  drivers/iio/adc/max1027.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/iio/adc/max1027.c b/drivers/iio/adc/max1027.c
> > index 655ab02d03d8..4a42d140a4b0 100644
> > --- a/drivers/iio/adc/max1027.c
> > +++ b/drivers/iio/adc/max1027.c
> > @@ -103,7 +103,7 @@ MODULE_DEVICE_TABLE(of,
> > max1027_adc_dt_ids);
> >  			.sign = 'u',					\
> >  			.realbits = depth,				\
> >  			.storagebits = 16,				\
> > -			.shift = 2,					\
> > +			.shift = (depth == 10) ? 2 : 0,			\
> >  			.endianness = IIO_BE,				\
> >  		},							\
> >  	}
> > --
> > 2.27.0  
> 
> Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Ouch.  I briefly wondered if we should dot his as 12 - depth, but given we are unlikely
to ever see a 9 or 11 bit device and it doesn't make much sense for anything 8 or less
what you have here is effectively the same.

Applied to the fixes-togreg branch of iio.git

Jonathan

> 

