Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466D03C80EF
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 11:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238123AbhGNJHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 05:07:36 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3392 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238113AbhGNJHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 05:07:36 -0400
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GPrmn11kbz6D8yT;
        Wed, 14 Jul 2021 16:50:17 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 11:04:43 +0200
Received: from localhost (10.47.88.217) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 14 Jul
 2021 10:04:42 +0100
Date:   Wed, 14 Jul 2021 10:04:22 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        frank zago <frank@zago.net>
Subject: Re: [PATCH 5.10 073/593] iio: light: tcs3472: do not free
 unallocated IRQ
Message-ID: <20210714100422.000051a2@Huawei.com>
In-Reply-To: <20210713213128.GA23770@amd>
References: <20210712060843.180606720@linuxfoundation.org>
        <20210712060851.173417192@linuxfoundation.org>
        <20210713213128.GA23770@amd>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.88.217]
X-ClientProxiedBy: lhreml750-chm.china.huawei.com (10.201.108.200) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 13 Jul 2021 23:31:28 +0200
Pavel Machek <pavel@denx.de> wrote:

> Hi!
> 
> > commit 7cd04c863f9e1655d607705455e7714f24451984 upstream.
> > 
> > Allocating an IRQ is conditional to the IRQ existence, but freeing it
> > was not. If no IRQ was allocate, the driver would still try to free
> > IRQ 0. Add the missing checks.
> > 
> > This fixes the following trace when the driver is removed:
> > 
> > [  100.667788] Trying to free already-free IRQ 0  
> 
> AFAICT this will need more fixing, because IRQ == 0 is a valid
> IRQ. NO_IRQ (aka -1) should be safe to use for "no irq assigned".
> 

I thought we had long put this to bed.  IRQ == 0 is not a valid irq number.
If there is an error in parsing DT (e.g. no irq specified) it returns 0
not NO_IRQ.  Naturally irq chips can have a 0, but that's pre translation to
virtual IRQ space.

Many years ago, ARM did have 0 as as valid IRQ, but that got cleaned up
to make it easier to do generic code like this.

Jonathan


> Best regards,
> 								Pavel
> 
> > +++ b/drivers/iio/light/tcs3472.c
> > @@ -531,7 +531,8 @@ static int tcs3472_probe(struct i2c_clie
> >  	return 0;
> >  
> >  free_irq:
> > -	free_irq(client->irq, indio_dev);
> > +	if (client->irq)
> > +		free_irq(client->irq, indio_dev);
> >  buffer_cleanup:
> >  	iio_triggered_buffer_cleanup(indio_dev);
> >  	return ret;  
> 

