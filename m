Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB9EE8810C
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 19:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407548AbfHIRUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 13:20:54 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:33776 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405999AbfHIRUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Aug 2019 13:20:54 -0400
Received: from penelope.horms.nl (unknown [66.60.152.14])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 12A2E25AD78;
        Sat, 10 Aug 2019 03:20:52 +1000 (AEST)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 33539E21A9A; Fri,  9 Aug 2019 19:20:50 +0200 (CEST)
Date:   Fri, 9 Aug 2019 10:20:50 -0700
From:   Simon Horman <horms@verge.net.au>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     gregkh@linuxfoundation.org, mathias.nyman@intel.com,
        linux-usb@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: host: xhci-rcar: Fix timeout in xhci_suspend()
Message-ID: <20190809172042.ce5oxx2iwj4r7s4k@verge.net.au>
References: <1564734815-17964-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564734815-17964-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 05:33:35PM +0900, Yoshihiro Shimoda wrote:
> When a USB device is connected to the host controller and
> the system enters suspend, the following error happens
> in xhci_suspend():
> 
> 	xhci-hcd ee000000.usb: WARN: xHC CMD_RUN timeout
> 
> Since the firmware/internal CPU control the USBSTS.STS_HALT
> and the process speed is down when the roothub port enters U3,
> long delay for the handshake of STS_HALT is neeed in xhci_suspend().
> So, this patch adds to set the XHCI_SLOW_SUSPEND.
> 
> Fixes: 435cc1138ec9 ("usb: host: xhci-plat: set resume_quirk() for R-Car controllers")
> Cc: <stable@vger.kernel.org> # v4.12+
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>

> ---
>  drivers/usb/host/xhci-rcar.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-rcar.c b/drivers/usb/host/xhci-rcar.c
> index 671bce1..8616c52 100644
> --- a/drivers/usb/host/xhci-rcar.c
> +++ b/drivers/usb/host/xhci-rcar.c
> @@ -238,10 +238,15 @@ int xhci_rcar_init_quirk(struct usb_hcd *hcd)
>  	 * pointers. So, this driver clears the AC64 bit of xhci->hcc_params
>  	 * to call dma_set_coherent_mask(dev, DMA_BIT_MASK(32)) in
>  	 * xhci_gen_setup().
> +	 *
> +	 * And, since the firmware/internal CPU control the USBSTS.STS_HALT
> +	 * and the process speed is down when the roothub port enters U3,
> +	 * long delay for the handshake of STS_HALT is neeed in xhci_suspend().
>  	 */
>  	if (xhci_rcar_is_gen2(hcd->self.controller) ||
> -			xhci_rcar_is_gen3(hcd->self.controller))
> -		xhci->quirks |= XHCI_NO_64BIT_SUPPORT;
> +			xhci_rcar_is_gen3(hcd->self.controller)) {
> +		xhci->quirks |= XHCI_NO_64BIT_SUPPORT | XHCI_SLOW_SUSPEND;
> +	}


nit: As there is still only one line guarded by the conditional I don't
think that { } need to be added.

>  
>  	if (!xhci_rcar_wait_for_pll_active(hcd))
>  		return -ETIMEDOUT;
> -- 
> 2.7.4
> 
