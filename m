Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B1638F9B4
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 06:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhEYEzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 00:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhEYEzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 00:55:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14480613D5;
        Tue, 25 May 2021 04:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621918427;
        bh=GRH0ZGob/FeTHCSyWJkfn0PLPzWOlODok015OVhPi7U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UqPI53eKn8a37lfXrhV4A5BxYp6gTaiMoG2uDvGCo0hUWh/+ViqGPtWs/PcZv/vza
         WKFRdHR+agFIl2+PlgA2YCBYCAghYWDaI/04SmxSIq//mMj+zsu84bZIYDzICqoCfF
         vHcPwV2ms+EBhWmik9L8qSTwkeXbg27h3am47OO8=
Date:   Tue, 25 May 2021 06:53:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jack Pham <jackp@codeaurora.org>
Cc:     balbi@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.9] usb: dwc3: gadget: Enable suspend events
Message-ID: <YKyC1/4AROA75lli@kroah.com>
References: <1621239162239146@kroah.com>
 <20210525044732.31660-1-jackp@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525044732.31660-1-jackp@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 09:47:32PM -0700, Jack Pham wrote:
> commit d1d90dd27254c44d087ad3f8b5b3e4fff0571f45 upstream.
> 
> commit 72704f876f50 ("dwc3: gadget: Implement the suspend entry event
> handler") introduced (nearly 5 years ago!) an interrupt handler for
> U3/L1-L2 suspend events.  The problem is that these events aren't
> currently enabled in the DEVTEN register so the handler is never
> even invoked.  Fix this simply by enabling the corresponding bit
> in dwc3_gadget_enable_irq() using the same revision check as found
> in the handler.
> 
> Fixes: 72704f876f50 ("dwc3: gadget: Implement the suspend entry event handler")
> Acked-by: Felipe Balbi <balbi@kernel.org>
> Signed-off-by: Jack Pham <jackp@codeaurora.org>
> Cc: stable <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20210428090111.3370-1-jackp@codeaurora.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/usb/dwc3/gadget.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index e822ba03d3cc..0fb4b29a2962 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -2112,6 +2112,10 @@ static void dwc3_gadget_enable_irq(struct dwc3 *dwc)
>  	if (DWC3_VER_IS_PRIOR(DWC3, 250A))
>  		reg |= DWC3_DEVTEN_ULSTCNGEN;
>  
> +	/* On 2.30a and above this bit enables U3/L2-L1 Suspend Events */
> +	if (!DWC3_VER_IS_PRIOR(DWC3, 230A))
> +		reg |= DWC3_DEVTEN_EOPFEN;
> +
>  	dwc3_writel(dwc->regs, DWC3_DEVTEN, reg);
>  }
>  
> -- 
> 2.24.0
> 

5.9 is long end-of-life, please see the "Releases" page on kernel.org,
or just the front page itself, for the active kernels that we are
currently supporting.

thanks,

greg k-h
