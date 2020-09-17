Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDC926E3F1
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 20:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgIQSie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 14:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:32772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgIQRTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 13:19:48 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 145A8221E3;
        Thu, 17 Sep 2020 17:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600363187;
        bh=21Q34AOs8zDD3/feAv29bl5fXW+Jkv/vzpLdXHQugjU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pWc2jfeNPJrr5Y0o2P93Y7tbpoCAOwUOSngPay4RQ1bh4VbLgLYwTxs2VTes6qsse
         0kC0jMMhFaZJaDcxS8xWsfOt/w/Bg+bTLPxehAh8ZqjIxxkEACqV/m6/nRBpRhgdsU
         Xoq8pBaePp6h9+Jo4nd9vif/0G6P+qCZEzmyt0eQ=
Date:   Thu, 17 Sep 2020 18:19:42 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v2] iio: trigger: Don't use RT priority
Message-ID: <20200917181942.0d5db535@archlinux>
In-Reply-To: <20200917120333.2337-1-ceggers@arri.de>
References: <20200917120333.2337-1-ceggers@arri.de>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Sep 2020 14:03:33 +0200
Christian Eggers <ceggers@arri.de> wrote:

> Triggers may raise transactions on slow busses like I2C.  Using the
> original RT priority of a threaded IRQ may prevent other important IRQ
> handlers from being run.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: stable@vger.kernel.org
> ---
> In my particular case (on a RT kernel), the RT priority of the sysfstrig
> threaded IRQ handler caused (temporarily) raising the prio of a user
> space process which was holding the I2C bus mutex.
> 
> Due to a bug in the i2c-imx driver, this process spent 500 ms in a busy-wait
> loop and prevented all threaded IRQ handlers from being run during this
> time.
I'm not sure I fully understand the impacts of this yet.

What is the impact on cases where we don't have any nasty side affects
due to users of the trigger?

I presume reducing the priority will cause some reduction in
performance?  If so is there any chance that would count as a regression?

Jonathan

> 
> v2:
> - Use sched_set_normal() instead of sched_setscheduler_nocheck()
> 
>  drivers/iio/industrialio-trigger.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/iio/industrialio-trigger.c b/drivers/iio/industrialio-trigger.c
> index 6f16357fd732..7ed00ad695c7 100644
> --- a/drivers/iio/industrialio-trigger.c
> +++ b/drivers/iio/industrialio-trigger.c
> @@ -9,7 +9,10 @@
>  #include <linux/err.h>
>  #include <linux/device.h>
>  #include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/irqdesc.h>
>  #include <linux/list.h>
> +#include <linux/sched.h>
>  #include <linux/slab.h>
>  
>  #include <linux/iio/iio.h>
> @@ -245,6 +248,7 @@ int iio_trigger_attach_poll_func(struct iio_trigger *trig,
>  	int ret = 0;
>  	bool notinuse
>  		= bitmap_empty(trig->pool, CONFIG_IIO_CONSUMERS_PER_TRIGGER);
> +	struct irq_desc *irq_desc;
>  
>  	/* Prevent the module from being removed whilst attached to a trigger */
>  	__module_get(pf->indio_dev->driver_module);
> @@ -264,6 +268,12 @@ int iio_trigger_attach_poll_func(struct iio_trigger *trig,
>  	if (ret < 0)
>  		goto out_put_irq;
>  
> +	/* Triggers may raise transactions on slow busses like I2C.  Using the original RT priority
> +	 * of a threaded IRQ may prevent other threaded IRQ handlers from being run.
> +	 */
> +	irq_desc = irq_to_desc(pf->irq);
> +	sched_set_normal(irq_desc->action->thread, 0);
> +
>  	/* Enable trigger in driver */
>  	if (trig->ops && trig->ops->set_trigger_state && notinuse) {
>  		ret = trig->ops->set_trigger_state(trig, true);

