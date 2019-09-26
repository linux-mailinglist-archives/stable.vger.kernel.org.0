Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD664BEB75
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 06:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391926AbfIZEzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 00:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391864AbfIZEzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Sep 2019 00:55:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35321222BF;
        Thu, 26 Sep 2019 04:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569473702;
        bh=Dy3FWgnLF2rRHcTZKnQU1WGAzQbabQgxU3nhizjPzMY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p0lpho/NYwDFBUrB/wdbmkktU3lh8S06jMi5TcKHj6MwV+sH7V19G9z7lNtk0qGl3
         yQKRnZ+X3CKrzG55YUYfosfyLidXlVSpaXkoHWoP7OKIBUplShzswNBT4gsJPqMmRu
         aR7tc61SIpi3J4ZwwwYZsLkhgnivE9B25jF6vp9c=
Date:   Thu, 26 Sep 2019 06:54:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chris Brandt <chris.brandt@renesas.com>
Cc:     Wolfram Sang <wsa@the-dreams.de>, stable@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chien Nguyen <chien.nguyen.eb@rvc.renesas.com>
Subject: Re: [PATCH] i2c: riic: Clear NACK in tend isr
Message-ID: <20190926045459.GA1560081@kroah.com>
References: <20190925194327.28109-1-chris.brandt@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925194327.28109-1-chris.brandt@renesas.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 25, 2019 at 02:43:27PM -0500, Chris Brandt wrote:
> The NACKF flag should be cleared in INTRIICNAKI interrupt processing as
> description in HW manual.
> 
> This issue shows up quickly when PREEMPT_RT is applied and a device is
> probed that is not plugged in (like a touchscreen controller). The result
> is endless interrupts that halt system boot.
> 
> Fixes: 310c18a41450 ("i2c: riic: add driver")
> Reported-by: Chien Nguyen <chien.nguyen.eb@rvc.renesas.com>
> Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
> ---
>  drivers/i2c/busses/i2c-riic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/i2c/busses/i2c-riic.c b/drivers/i2c/busses/i2c-riic.c
> index f31413fd9521..800414886f6b 100644
> --- a/drivers/i2c/busses/i2c-riic.c
> +++ b/drivers/i2c/busses/i2c-riic.c
> @@ -202,6 +202,7 @@ static irqreturn_t riic_tend_isr(int irq, void *data)
>  	if (readb(riic->base + RIIC_ICSR2) & ICSR2_NACKF) {
>  		/* We got a NACKIE */
>  		readb(riic->base + RIIC_ICDRR);	/* dummy read */
> +		riic_clear_set_bit(riic, ICSR2_NACKF, 0, RIIC_ICSR2);
>  		riic->err = -ENXIO;
>  	} else if (riic->bytes_left) {
>  		return IRQ_NONE;
> -- 
> 2.23.0
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
