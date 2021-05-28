Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A17393C41
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 06:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhE1EOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 00:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230127AbhE1ENx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 May 2021 00:13:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 897AB613DA;
        Fri, 28 May 2021 04:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622175134;
        bh=sGy+yPwaz4u8x61YWOZA7C/3qLwToefQtmB7y2f4mZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=etkA9ahkQxEDIamZ5DXA+3LrwxjkcIk+3ZgXiD0iv2k+ggQ45S7fhacbE07W8X9px
         XskdBYYBm1o4PQ3PTl2cCs1dzzMsZP2KYt7qIkHd9ySCfrzJbSyTsgNpoRXkSFaxxy
         NmDwG4XmD8xPL1tKx6KRH7/ZZzEbFReG+k4qxlDZcG84JW5jmeZ6BMnMNXbqdc/wZM
         oIEkjqQKrrjJfHJtoXR3wUMAt7uNPgxlBzt0qSCarDeOOJ8o75qkGcARIUv6QeA9AN
         XNjCVdtI7M7PpT+k/6ei5gDKGuqB76GLPD4trAOgEVv066kUpdIuXVdMCH4pjN/X8w
         ARjCSLLj2Xw6Q==
Date:   Fri, 28 May 2021 12:12:10 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Jack Pham <jackp@codeaurora.org>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wesley Cheng <wcheng@codeaurora.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: gadget: Bail from dwc3_gadget_exit() if
 dwc->gadget is NULL
Message-ID: <20210528041210.GA20937@nchen>
References: <20210525042922.15591-1-jackp@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525042922.15591-1-jackp@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-05-24 21:29:22, Jack Pham wrote:
> There exists a possible scenario in which dwc3_gadget_init() can fail:
> during during host -> peripheral mode switch in dwc3_set_mode(), and
> a pending gadget driver fails to bind.  Then, if the DRD undergoes
> another mode switch from peripheral->host the resulting
> dwc3_gadget_exit() will attempt to reference an invalid and dangling
> dwc->gadget pointer as well as call dma_free_coherent() on unmapped
> DMA pointers.
> 
> The exact scenario can be reproduced as follows:
>  - Start DWC3 in peripheral mode
>  - Configure ConfigFS gadget with FunctionFS instance (or use g_ffs)
>  - Run FunctionFS userspace application (open EPs, write descriptors, etc)
>  - Bind gadget driver to DWC3's UDC
>  - Switch DWC3 to host mode
>    => dwc3_gadget_exit() is called. usb_del_gadget() will put the
> 	ConfigFS driver instance on the gadget_driver_pending_list
>  - Stop FunctionFS application (closes the ep files)
>  - Switch DWC3 to peripheral mode
>    => dwc3_gadget_init() fails as usb_add_gadget() calls
> 	check_pending_gadget_drivers() and attempts to rebind the UDC
> 	to the ConfigFS gadget but fails with -19 (-ENODEV) because the
> 	FFS instance is not in FFS_READY state.

There is no such state at enum ffs_state, you mean flag desc_ready is not
true, right?

>  - Switch DWC3 back to host mode
>    => dwc3_gadget_exit() is called again, but this time dwc->gadget
> 	is invalid.
> 
> Although it can be argued that userspace should take responsibility
> for ensuring that the FunctionFS application be ready prior to
> allowing the composite driver bind to the UDC, failure to do so
> should not result in a panic from the kernel driver.
> 
> Fix this by setting dwc->gadget to NULL in the failure path of
> dwc3_gadget_init() and add a check to dwc3_gadget_exit() to bail out
> unless the gadget pointer is valid.
> 
> Fixes: e81a7018d93a ("usb: dwc3: allocate gadget structure dynamically")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jack Pham <jackp@codeaurora.org>

Reviewed-by: Peter Chen <peter.chen@kernel.org>

Peter

> ---
> Hi Felipe,
> 
> Although I marked the 'Fixes' tag above to e81a7018d93a, the problem
> theoretically exists prior to Peter's change. But I'm not sure how
> best to fix on versions prior to this change since dwc->gadget used
> to be an embedded struct so we can't do a simple NULL check as below.
> Suggestions on alternative approaches welcome if we want to proceed
> with backporting to older (pre-5.9) stable releases.
> 
> Thanks,
> Jack
> 
>  drivers/usb/dwc3/gadget.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 612825a39f82..65d9b7227752 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -4046,6 +4046,7 @@ int dwc3_gadget_init(struct dwc3 *dwc)
>  	dwc3_gadget_free_endpoints(dwc);
>  err4:
>  	usb_put_gadget(dwc->gadget);
> +	dwc->gadget = NULL;
>  err3:
>  	dma_free_coherent(dwc->sysdev, DWC3_BOUNCE_SIZE, dwc->bounce,
>  			dwc->bounce_addr);
> @@ -4065,6 +4066,9 @@ int dwc3_gadget_init(struct dwc3 *dwc)
>  
>  void dwc3_gadget_exit(struct dwc3 *dwc)
>  {
> +	if (!dwc->gadget)
> +		return;
> +
>  	usb_del_gadget(dwc->gadget);
>  	dwc3_gadget_free_endpoints(dwc);
>  	usb_put_gadget(dwc->gadget);
> -- 
> 2.24.0
> 

-- 

Thanks,
Peter Chen

