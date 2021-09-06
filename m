Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C0F401837
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 10:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241358AbhIFIsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 04:48:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241544AbhIFIrS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 04:47:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6ACE60F21;
        Mon,  6 Sep 2021 08:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630917974;
        bh=4rmPg62aQaqdkQzyXS6zLr5QZI0Kw9eL0Ak7KOoGkKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iDWnVyZW3WV/lKap9EMlOK9vFzQwOA0os6XckgsDuiLg4P+yan9zYhbJ6/UDVQ0SS
         Rma2VpzfG9DLK63EALtYfnWLqd75xck2rOQgSurg3eWhRA/3fT2pdCGA62Z0aNDFGe
         urDaSh8KBiTZ4WEaV3acwmpZM/YAWspbeiBvvtaU=
Date:   Mon, 6 Sep 2021 10:46:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH for 5.10.y] serial: 8250: 8250_omap: Fix possible array
 out of bounds access
Message-ID: <YTXVUwK7BaLqdtj5@kroah.com>
References: <20210906060512.2913106-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906060512.2913106-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 06, 2021 at 03:05:12PM +0900, Nobuhiro Iwamatsu wrote:
> From: Vignesh Raghavendra <vigneshr@ti.com>
> 
> commit d4548b14dd7e5c698f81ce23ce7b69a896373b45 upstream.
> 
> k3_soc_devices array is missing a sentinel entry which may result in out
> of bounds access as reported by kernel KASAN.
> 
> Fix this by adding a sentinel entry.
> 
> Fixes: 439c7183e5b9 ("serial: 8250: 8250_omap: Disable RX interrupt after DMA enable")
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
> Link: https://lore.kernel.org/r/20201111112653.2710-1-vigneshr@ti.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/tty/serial/8250/8250_omap.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
> index 95e2d6de4f2134..ad0549dac7d792 100644
> --- a/drivers/tty/serial/8250/8250_omap.c
> +++ b/drivers/tty/serial/8250/8250_omap.c
> @@ -1211,6 +1211,7 @@ static int omap8250_no_handle_irq(struct uart_port *port)
>  static const struct soc_device_attribute k3_soc_devices[] = {
>  	{ .family = "AM65X",  },
>  	{ .family = "J721E", .revision = "SR1.0" },
> +	{ /* sentinel */ }
>  };
>  
>  static struct omap8250_dma_params am654_dma = {
> -- 
> 2.33.0
> 
> 

Now queued up, thanks.

greg k-h
