Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE2E47418C
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 12:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbhLNLh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 06:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbhLNLh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 06:37:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2646FC061574;
        Tue, 14 Dec 2021 03:37:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6AA5B8189C;
        Tue, 14 Dec 2021 11:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AA7C34601;
        Tue, 14 Dec 2021 11:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639481846;
        bh=Oappbukov3UQnAjv69yWrBNllmlybdQiKY575a0/fwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MwoUBIgxhmXvND8+XN4wLT/kAzYYpWUH+pQQWVqul52URFpWpv4lX/PLcWBhO2D00
         3QfbMRBKJxHPSwyEFE40Yu+MEQt9/hmhf7WGLQQehiCvPqU9m18F2ZjRBxIAIJRt9V
         50KiisYgFgcoCQxgNyLcNXgTvPOptyl2C2zd2U9Tjm0Fpq+DE5Lvl5ea0agq/+68Sn
         wWiPspMs3nJsLxlnkSZkX+CBoX43iK7983L61R76TBu1tkKh/rgrVXU2Z+GMrExjQM
         Uuwpy78SHupNIun6pXiog5+9yqQXWvsbBqnZWnS30v+CrWXo3YtWV8PbKvn2YbdIbt
         KkgyMle++y9EQ==
Date:   Tue, 14 Dec 2021 19:37:21 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, jianhe@ambarella.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: cdnsp: Fix lack of
 spin_lock_irqsave/spin_lock_restore
Message-ID: <20211214113721.GA4527@Peter>
References: <20211214045527.26823-1-pawell@gli-login.cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214045527.26823-1-pawell@gli-login.cadence.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-12-14 05:55:27, Pawel Laszczak wrote:
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

Reviewed-by: Peter Chen <peter.chen@kernel.org>

> --
> 
> Changelog:
> v2:
> - added disable_irq/enable_irq as sugester by Peter Chen
> 
>  drivers/usb/cdns3/cdnsp-gadget.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
> index f6d231760a6a..e07a65b980af 100644
> --- a/drivers/usb/cdns3/cdnsp-gadget.c
> +++ b/drivers/usb/cdns3/cdnsp-gadget.c
> @@ -1544,15 +1544,27 @@ static int cdnsp_gadget_pullup(struct usb_gadget *gadget, int is_on)
>  {
>  	struct cdnsp_device *pdev = gadget_to_cdnsp(gadget);
>  	struct cdns *cdns = dev_get_drvdata(pdev->dev);
> +	unsigned long flags;
>  
>  	trace_cdnsp_pullup(is_on);
>  
> +	/*
> +	 * Disable events handling while controller is being
> +	 * enabled/disabled.
> +	 */
> +	disable_irq(cdns->dev_irq);
> +	spin_lock_irqsave(&pdev->lock, flags);
> +
>  	if (!is_on) {
>  		cdnsp_reset_device(pdev);
>  		cdns_clear_vbus(cdns);
>  	} else {
>  		cdns_set_vbus(cdns);
>  	}
> +
> +	spin_unlock_irqrestore(&pdev->lock, flags);
> +	enable_irq(cdns->dev_irq);
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

