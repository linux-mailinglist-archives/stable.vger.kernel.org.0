Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EE03A77C4
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 09:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhFOHRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 03:17:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229983AbhFOHRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 03:17:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B054661410;
        Tue, 15 Jun 2021 07:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623741304;
        bh=5I69aLkfh7wRBLYUEPesd4Ifny0KH1GH0zZzxOMwnPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M+8zIGk2vZ8olyNM2MkoaWHRzPN3cP2hVii1FBQ6FkceUPdYodypCLJliyCfhDka7
         rm2QHYawDh7ZarGXeoHxkMNe96WAdS56B1jfyhSHnl/oSnNLjW2YMSL/q+8Dr1XSY9
         qPRyAvFL9npDbzSFJY+/kgW+e9rkldcmiBtk/ric=
Date:   Tue, 15 Jun 2021 09:15:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Moritz Fischer <mdf@kernel.org>
Cc:     maz@kernel.org, vkoul@kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@intel.com>
Subject: Re: [PATCH] usb: renesas-xhci: Fix handling of unknown ROM state
Message-ID: <YMhTddYjJwDcNau/@kroah.com>
References: <20210615022514.245274-1-mdf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615022514.245274-1-mdf@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 07:25:14PM -0700, Moritz Fischer wrote:
> If the ROM status returned is unknown (RENESAS_ROM_STATUS_NO_RESULT)
> we need to attempt loading the firmware rather than just skipping
> it all together.

How can this happen?  Can you provide more information here?

> 
> Cc: stable@vger.kernel.org
> Cc: Mathias Nyman <mathias.nyman@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Fixes: 2478be82de44 ("usb: renesas-xhci: Add ROM loader for uPD720201")
> Signed-off-by: Moritz Fischer <mdf@kernel.org>
> ---
>  drivers/usb/host/xhci-pci-renesas.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-pci-renesas.c b/drivers/usb/host/xhci-pci-renesas.c
> index f97ac9f52bf4..dfe54f0afc4b 100644
> --- a/drivers/usb/host/xhci-pci-renesas.c
> +++ b/drivers/usb/host/xhci-pci-renesas.c
> @@ -207,7 +207,8 @@ static int renesas_check_rom_state(struct pci_dev *pdev)
>  			return 0;
>  
>  		case RENESAS_ROM_STATUS_NO_RESULT: /* No result yet */
> -			return 0;
> +			dev_dbg(&pdev->dev, "Unknown ROM status ...\n");
> +			break;
>  
>  		case RENESAS_ROM_STATUS_ERROR: /* Error State */
>  		default: /* All other states are marked as "Reserved states" */
> @@ -224,13 +225,11 @@ static int renesas_fw_check_running(struct pci_dev *pdev)
>  	u8 fw_state;
>  	int err;
>  
> -	/* Check if device has ROM and loaded, if so skip everything */
> -	err = renesas_check_rom(pdev);
> -	if (err) { /* we have rom */
> -		err = renesas_check_rom_state(pdev);
> -		if (!err)
> -			return err;
> -	}
> +	/* Only if device has ROM and loaded FW we can skip loading and
> +	 * return success. Otherwise (even unknown state), attempt to load FW.
> +	 */

Nit, but please use the correct comment style format, like is used a few
lines below:

> +	if (renesas_check_rom(pdev) && !renesas_check_rom_state(pdev))
> +		return 0;
>  
>  	/*
>  	 * Test if the device is actually needing the firmware. As most

This isn't the networking tree :)

thanks,

greg k-h
