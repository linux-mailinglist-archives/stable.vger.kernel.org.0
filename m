Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C67638D4F7
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 11:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhEVJ4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 05:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230298AbhEVJ4E (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 May 2021 05:56:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4091761261;
        Sat, 22 May 2021 09:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621677277;
        bh=1id7JO5kkP8rqGxR/9LR0zPSgXCJ1HO45UaR4koWk24=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uRwPSQ5887CTttHF1I/VvjgC6VMMhzvJGcALODoMlUFJ3Csnhj0RyRb+g9NfCN4Y3
         W++qIqR7i/1Nr3w3k+yIUmJ+35AfgW0NpjejkTIydJ6Xe/hUGSMzPatCs9aLM1SSIA
         dRwpir+8F9bi6wrTHrMw0CrJLMgCk64VOfU/YgwqSciYJzTVwh4lj/YIR+5VPrSP9f
         g6MgNqW8orHU40UTEGmvDUTAIEBkxha0T7W0VSkD2aMfUhGztX9pNvw0Qp81VwsUlS
         UJiyFKv34TwfbXqJ/DKvYrJ4vtWBtFKnSSR8NDrHKKjkBPc19tG626pwdlFeC5UlXX
         6l2Mqo2Af4LnA==
Date:   Sat, 22 May 2021 17:54:32 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        kurahul@cadence.com, stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdnsp: Fix deadlock issue in
 cdnsp_thread_irq_handler
Message-ID: <20210522095432.GA12415@b29397-desktop>
References: <20210520094224.14099-1-pawell@gli-login.cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520094224.14099-1-pawell@gli-login.cadence.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-05-20 11:42:24, Pawel Laszczak wrote:
> From: Pawel Laszczak <pawell@cadence.com>
> 
> Patch fixes the critical issue caused by deadlock which has been detected
> during testing NCM class.
> 
> The root cause of issue is spin_lock/spin_unlock instruction instead
> spin_lock_irqsave/spin_lock_irqrestore in cdnsp_thread_irq_handler
> function.

Pawel, would you please explain more about why the deadlock occurs with
current code, and why this patch could fix it?

Peter
> 
> Cc: stable@vger.kernel.org
> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
>  drivers/usb/cdns3/cdnsp-ring.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
> index 5f0513c96c04..68972746e363 100644
> --- a/drivers/usb/cdns3/cdnsp-ring.c
> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> @@ -1517,13 +1517,14 @@ irqreturn_t cdnsp_thread_irq_handler(int irq, void *data)
>  {
>  	struct cdnsp_device *pdev = (struct cdnsp_device *)data;
>  	union cdnsp_trb *event_ring_deq;
> +	unsigned long flags;
>  	int counter = 0;
>  
> -	spin_lock(&pdev->lock);
> +	spin_lock_irqsave(&pdev->lock, flags);
>  
>  	if (pdev->cdnsp_state & (CDNSP_STATE_HALTED | CDNSP_STATE_DYING)) {
>  		cdnsp_died(pdev);
> -		spin_unlock(&pdev->lock);
> +		spin_unlock_irqrestore(&pdev->lock, flags);
>  		return IRQ_HANDLED;
>  	}
>  
> @@ -1539,7 +1540,7 @@ irqreturn_t cdnsp_thread_irq_handler(int irq, void *data)
>  
>  	cdnsp_update_erst_dequeue(pdev, event_ring_deq, 1);
>  
> -	spin_unlock(&pdev->lock);
> +	spin_unlock_irqrestore(&pdev->lock, flags);
>  
>  	return IRQ_HANDLED;
>  }
> -- 
> 2.25.1
> 

-- 

Thanks,
Peter Chen

