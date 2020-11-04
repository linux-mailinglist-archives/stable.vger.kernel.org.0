Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD002A6B3C
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 17:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731982AbgKDQ62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 11:58:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731914AbgKDQ6U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 11:58:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53F7A2071A;
        Wed,  4 Nov 2020 16:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604509099;
        bh=QIj3mUi6dnNp24MrN+jow7RA7sXtf+hEvdx3gUP8jUQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eC3tJVhBcWUlG40LcNytaB6zXPO677N39CnOxxYyWv6WdEYJEDQ9A5/rOww4n+SxY
         EB+Bt1KsC/Tuhom3OEuqmRVR3bDyjrlhT6IFA76gUO3JrpB4xl6HQVevoBnsIIrBDP
         6h30Z3aJZIzKaJAmq+YY346g7f6D4c3fIId9OtRU=
Date:   Wed, 4 Nov 2020 17:59:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: serial: mos7720: fix parallel-port state restore
Message-ID: <20201104165910.GA2342981@kroah.com>
References: <20201104164727.26351-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104164727.26351-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 05:47:27PM +0100, Johan Hovold wrote:
> The parallel-port restore operations is called when a driver claims the
> port and is supposed to restore the provided state (e.g. saved when
> releasing the port).
> 
> Fixes: b69578df7e98 ("USB: usbserial: mos7720: add support for parallel port on moschip 7715")
> Cc: stable <stable@vger.kernel.org>     # 2.6.35
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/usb/serial/mos7720.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
> index 5eed1078fac8..5a5d2a95070e 100644
> --- a/drivers/usb/serial/mos7720.c
> +++ b/drivers/usb/serial/mos7720.c
> @@ -639,6 +639,8 @@ static void parport_mos7715_restore_state(struct parport *pp,
>  		spin_unlock(&release_lock);
>  		return;
>  	}
> +	mos_parport->shadowDCR = s->u.pc.ctr;
> +	mos_parport->shadowECR = s->u.pc.ecr;

Wow that's old code.  I'm guessing no one uses these devices really :(

Anyway, nice work:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

>  	write_parport_reg_nonblock(mos_parport, MOS7720_DCR,
>  				   mos_parport->shadowDCR);
>  	write_parport_reg_nonblock(mos_parport, MOS7720_ECR,
> -- 
> 2.26.2
> 
