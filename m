Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEB73B4DC2
	for <lists+stable@lfdr.de>; Sat, 26 Jun 2021 10:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhFZI7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Jun 2021 04:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhFZI7Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Jun 2021 04:59:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94AF661920;
        Sat, 26 Jun 2021 08:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624697823;
        bh=qmG1JfvdGzsA0YlwqYbabUV+AHbdvuyoe9DUjculXA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZMUoH0PVIaYf1Uix6rrjUT5KrcQKsvOWAgPMXRrykwR0NU+uTmfW6bZRysxzxn8P0
         OiBKET2vFg0BZ2lqa9qIW15uFYVQY7mVULDZDAG6GAjLAjjoxzVlHQHhJqPrFkrEhy
         npHIeNS17+gXb4XfgioqT8jv9DcrcgRaKRrJd7bVMzkqSq1a0GeiI5Fxa+QRD/dnnx
         +CIpI1Qj7+TtWOoVUuaSIVe6OHGrAtrCYgM+jMqMuJKflN1vx4cWH6bGQY2ZSFyyl/
         GgJEb8RDnTFOPnkTGJWC+k3LIts337H4K72bdNPjNcb1nAuHeqfccqy0PD+cMV1LHZ
         +yQJ3gato9zCw==
Date:   Sat, 26 Jun 2021 16:56:55 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     rogerq@kernel.org, a-govindraju@ti.com, gregkh@linuxfoundation.org,
        felipe.balbi@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com, kurahul@cadence.com,
        sparmar@cadence.com, stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdns3: Fixed incorrect gadget state
Message-ID: <20210626085655.GA13671@Peter>
References: <20210623070247.46151-1-pawell@gli-login.cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623070247.46151-1-pawell@gli-login.cadence.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-06-23 09:02:47, Pawel Laszczak wrote:
> From: Pawel Laszczak <pawell@cadence.com>
> 
> For delayed status phase, the usb_gadget->state was set
> to USB_STATE_ADDRESS and it has never been updated to
> USB_STATE_CONFIGURED.
> Patch updates the gadget state to correct USB_STATE_CONFIGURED.
> As a result of this bug the controller was not able to enter to
> Test Mode while using MSC function.

Pawel, would you please describe more about this issue? I remember the cdns3
controller at i.mx series SoC could enter test mode by using current
code.

Peter

> 
> Cc: <stable@vger.kernel.org>
> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
>  drivers/usb/cdns3/cdns3-ep0.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/cdns3/cdns3-ep0.c b/drivers/usb/cdns3/cdns3-ep0.c
> index 9a17802275d5..ec5bfd8944c3 100644
> --- a/drivers/usb/cdns3/cdns3-ep0.c
> +++ b/drivers/usb/cdns3/cdns3-ep0.c
> @@ -731,6 +731,7 @@ static int cdns3_gadget_ep0_queue(struct usb_ep *ep,
>  		request->actual = 0;
>  		priv_dev->status_completion_no_call = true;
>  		priv_dev->pending_status_request = request;
> +		usb_gadget_set_state(&priv_dev->gadget, USB_STATE_CONFIGURED);
>  		spin_unlock_irqrestore(&priv_dev->lock, flags);
>  
>  		/*
> -- 
> 2.25.1
> 

-- 

Thanks,
Peter Chen

