Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2C717FF99
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgCJN5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:57:02 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37852 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726770AbgCJN5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 09:57:01 -0400
Received: (qmail 1774 invoked by uid 2102); 10 Mar 2020 09:57:00 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 10 Mar 2020 09:57:00 -0400
Date:   Tue, 10 Mar 2020 09:57:00 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Peter Chen <peter.chen@kernel.org>
cc:     gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        Peter Chen <peter.chen@nxp.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] usb: chipidea: udc: fix sleeping function called
 from invalid context
In-Reply-To: <20200310065926.17746-2-peter.chen@kernel.org>
Message-ID: <Pine.LNX.4.44L0.2003100952060.1651-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Mar 2020, Peter Chen wrote:

> From: Peter Chen <peter.chen@nxp.com>
> 
> The code calls pm_runtime_get_sync with irq disabled, it causes below
> warning:
> 
> BUG: sleeping function called from invalid context at
> wer/runtime.c:1075
> in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid:
> er/u8:1

...

> Tested-by: Dmitry Osipenko <digetx@gmail.com>
> Cc: <stable@vger.kernel.org> #v5.5
> Fixes: 72dc8df7920f ("usb: chipidea: udc: protect usb interrupt enable")
> Reported-by: Dmitry Osipenko <digetx@gmail.com>
> Signed-off-by: Peter Chen <peter.chen@nxp.com>
> ---
>  drivers/usb/chipidea/udc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
> index ffaf46f5d062..1fa587ec52fc 100644
> --- a/drivers/usb/chipidea/udc.c
> +++ b/drivers/usb/chipidea/udc.c
> @@ -1539,9 +1539,11 @@ static void ci_hdrc_gadget_connect(struct usb_gadget *_gadget, int is_active)
>  		if (ci->driver) {
>  			hw_device_state(ci, ci->ep0out->qh.dma);
>  			usb_gadget_set_state(_gadget, USB_STATE_POWERED);
> +			spin_unlock_irqrestore(&ci->lock, flags);
>  			usb_udc_vbus_handler(_gadget, true);
> +		} else {
> +			spin_unlock_irqrestore(&ci->lock, flags);
>  		}
> -		spin_unlock_irqrestore(&ci->lock, flags);

There's something strange about this patch.

Do you really know that interrupts will be enabled following the 
spin_unlock_irqrestore()?  In other words, do you know that interrupts 
were enabled upon entry to this routine?

If they were, then why use spin_lock_irqsave/spin_unlock_irqrestore?  
Why not use spin_lock_irq and spin_unlock_irq?

Alan Stern

