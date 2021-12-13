Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8616472CEF
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 14:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhLMNNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 08:13:35 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58778 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbhLMNNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 08:13:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4EBBCE101B;
        Mon, 13 Dec 2021 13:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA35C34601;
        Mon, 13 Dec 2021 13:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639401207;
        bh=X4bmoQapJ0I3TPfC8ZUVwe2ESJb201VT5dzLbVKlLUE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fLo6I/ChI1VxCsP9vbh4N8wIid9BZqxyg3ASkQb7yUdj8nu1j2LHV7vfW1AMr7eqx
         CgV3Gl1VcQcl2Gbs+4hXrP6MQoItug+OgVWjGtCp3h6N9q6ASGU6kX4LK2+vnDBPA2
         PZMqKmCMOYHArRXHzJSB4MQp0pJbyzs/iz8rGSANxH+7vZ52IZoLb7oa9F88q7TCtx
         GIUpILO3I2zUhMe7qOUypRcydG56hgCDpDFCbxgkSZtgUW8Qsk05gD2T1+9Mkf7gP3
         Ja4c/FYIeCoEGK3naHg7NgSdonrmqyq02l54MDPPVoxmh4nj1kV2sCsxu80D+zF3PK
         Baz6LitRWGTRQ==
Date:   Mon, 13 Dec 2021 21:13:18 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, jianhe@ambarella.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdnsp: Fix incorrect calling of cdnsp_died function
Message-ID: <20211213131318.GB5346@Peter>
References: <20211210112945.660-1-pawell@gli-login.cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210112945.660-1-pawell@gli-login.cadence.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-12-10 12:29:45, Pawel Laszczak wrote:
> From: Pawel Laszczak <pawell@cadence.com>
> 
> Patch restrict calling of cdnsp_died function during removing modules
> or software disconnect.
> This function was called because after transition controller to HALT
> state the driver starts handling the deferred interrupt.
> In this case such interrupt can be simple ignored.
> 
> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> cc: <stable@vger.kernel.org>
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
>  drivers/usb/cdns3/cdnsp-ring.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
> index e8f5ecbb5c75..e45c3d6e1536 100644
> --- a/drivers/usb/cdns3/cdnsp-ring.c
> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> @@ -1525,7 +1525,14 @@ irqreturn_t cdnsp_thread_irq_handler(int irq, void *data)
>  	spin_lock_irqsave(&pdev->lock, flags);
>  
>  	if (pdev->cdnsp_state & (CDNSP_STATE_HALTED | CDNSP_STATE_DYING)) {
> -		cdnsp_died(pdev);
> +		/*
> +		 * While removing or stopping driver there may still be deferred
> +		 * not handled interrupt which should not be treated as error.
> +		 * Driver should simply ignore it.
> +		 */
> +		if (pdev->gadget_driver)
> +			cdnsp_died(pdev);
> +

Reviewed-by: Peter Chen <peter.chen@kernel.org>

-- 

Thanks,
Peter Chen

