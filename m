Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF84A472D49
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 14:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237561AbhLMNaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 08:30:07 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:34656 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235637AbhLMNaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 08:30:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EE243CE101C;
        Mon, 13 Dec 2021 13:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67355C34601;
        Mon, 13 Dec 2021 13:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639402203;
        bh=sRU8BNAdNf2xyfnyW5j/+kAV8EwcPrmJ6lESbKeGPxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y5+rb59S15gUX3TKeSQHKHW0SBmnGiK9aiNCk2YzPMT+JYRrETpLh1Ywf1oVk258J
         CHxhqTViJDArMbuKlu5Epp3aMRD2O/pzsVBOAO9k3Q5dPprlvYdSIzgjuAWzd7VKsI
         km99CcLAWoHR2QK1l21o2PS7NiYUhtbIF8v6dT3WCQ7dTC29fW4ayrRGDBO6s8D3Kr
         1dxHKps3K7H48ipR7uk5ZcZbQexSNMQGKWsevLbXYRk+7V9GCEREvfXMcxLZXUSFC3
         717ADrHpe7RCDNYk02d1RbhPIkgU4fq2mAt8bvckKCEn0m0D7QZYw8lBW+/0L3Xy1+
         I6hJtWYaiHO2w==
Date:   Mon, 13 Dec 2021 21:29:46 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, jianhe@ambarella.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdnsp: Fix lack of
 spin_lock_irqsave/spin_lock_restore
Message-ID: <20211213132946.GD5346@Peter>
References: <20211213122001.47370-1-pawell@gli-login.cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213122001.47370-1-pawell@gli-login.cadence.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-12-13 13:20:01, Pawel Laszczak wrote:
> From: Pawel Laszczak <pawell@cadence.com>
> 
> Patch puts content of cdnsp_gadget_pullup function inside
> spin_lock_irqsave and spin_lock_restore section.
> This construction is required here to keep the data consistency,
> otherwise some data can be changed e.g. from interrupt context.
> 
> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> Reported-by: Ken (Jian) He <jianhe@ambarella.com>
> cc: <stable@vger.kernel.org>
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
>  drivers/usb/cdns3/cdnsp-gadget.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
> index f6d231760a6a..d0c040556984 100644
> --- a/drivers/usb/cdns3/cdnsp-gadget.c
> +++ b/drivers/usb/cdns3/cdnsp-gadget.c
> @@ -1544,8 +1544,10 @@ static int cdnsp_gadget_pullup(struct usb_gadget *gadget, int is_on)
>  {
>  	struct cdnsp_device *pdev = gadget_to_cdnsp(gadget);
>  	struct cdns *cdns = dev_get_drvdata(pdev->dev);
> +	unsigned long flags;
>  
>  	trace_cdnsp_pullup(is_on);
> +	spin_lock_irqsave(&pdev->lock, flags);

If the interrupt bottom half is pending, the consistent issue may still
exist, you may let the bottom half has finished first, eg: calling
disable_irq before spin_lock_irqsave.

Peter
>  
>  	if (!is_on) {
>  		cdnsp_reset_device(pdev);
> @@ -1553,6 +1555,9 @@ static int cdnsp_gadget_pullup(struct usb_gadget *gadget, int is_on)
>  	} else {
>  		cdns_set_vbus(cdns);
>  	}
> +
> +	spin_unlock_irqrestore(&pdev->lock, flags);
> +
>  	return 0;
>  }
>  
> -- 
> 2.25.1
> 

-- 

Thanks,
Peter Chen

