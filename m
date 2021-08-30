Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB153FB37D
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 11:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhH3J6B convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 30 Aug 2021 05:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229901AbhH3J6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 05:58:00 -0400
Received: from jic23-huawei (cpc108967-cmbg20-2-0-cust86.5-4.cable.virginm.net [81.101.6.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50A6660525;
        Mon, 30 Aug 2021 09:57:03 +0000 (UTC)
Date:   Mon, 30 Aug 2021 11:00:15 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     "Sa, Nuno" <Nuno.Sa@analog.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 02/16] iio: adc: max1027: Fix the number of max1X31
 channels
Message-ID: <20210830110015.787e0abe@jic23-huawei>
In-Reply-To: <SJ0PR03MB63596A655409A24A442977F199C19@SJ0PR03MB6359.namprd03.prod.outlook.com>
References: <20210818111139.330636-1-miquel.raynal@bootlin.com>
        <20210818111139.330636-3-miquel.raynal@bootlin.com>
        <SJ0PR03MB63596A655409A24A442977F199C19@SJ0PR03MB6359.namprd03.prod.outlook.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Aug 2021 07:03:40 +0000
"Sa, Nuno" <Nuno.Sa@analog.com> wrote:

> > -----Original Message-----
> > From: Miquel Raynal <miquel.raynal@bootlin.com>
> > Sent: Wednesday, August 18, 2021 1:11 PM
> > To: Jonathan Cameron <jic23@kernel.org>; Lars-Peter Clausen
> > <lars@metafoo.de>
> > Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>; linux-
> > iio@vger.kernel.org; linux-kernel@vger.kernel.org; Miquel Raynal
> > <miquel.raynal@bootlin.com>; stable@vger.kernel.org
> > Subject: [PATCH 02/16] iio: adc: max1027: Fix the number of max1X31
> > channels
> > 
> > [External]
> > 
> > The macro MAX1X29_CHANNELS() already calls
> > MAX1X27_CHANNELS().
> > Calling MAX1X27_CHANNELS() before MAX1X29_CHANNELS() in the
> > definition
> > of MAX1X31_CHANNELS() declares the first 8 channels twice. So drop
> > this
> > extra call from the MAX1X31 channels list definition.
> > 
> > Fixes: 7af5257d8427 ("iio: adc: max1027: Prepare the introduction of
> > different resolutions")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  drivers/iio/adc/max1027.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/iio/adc/max1027.c b/drivers/iio/adc/max1027.c
> > index 4a42d140a4b0..b753658bb41e 100644
> > --- a/drivers/iio/adc/max1027.c
> > +++ b/drivers/iio/adc/max1027.c
> > @@ -142,7 +142,6 @@ MODULE_DEVICE_TABLE(of,
> > max1027_adc_dt_ids);
> >  	MAX1027_V_CHAN(11, depth)
> > 
> >  #define MAX1X31_CHANNELS(depth)			\
> > -	MAX1X27_CHANNELS(depth),		\
> >  	MAX1X29_CHANNELS(depth),		\
> >  	MAX1027_V_CHAN(12, depth),		\
> >  	MAX1027_V_CHAN(13, depth),		\
> > --
> > 2.27.0  
> 
> Reviewed-by: Nuno Sá <nuno.sa@analog.com>
> 
I guess we don't have many users of these devices as I would have expected
this to blow up spectacularly.  Ah well.  

Applied to the fixes-togreg branch of iio.git

Thanks,

Jonathan
