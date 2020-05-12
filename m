Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0A71CF5E7
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 15:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgELNf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 09:35:29 -0400
Received: from netrider.rowland.org ([192.131.102.5]:39805 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727783AbgELNf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 09:35:29 -0400
Received: (qmail 21977 invoked by uid 500); 12 May 2020 09:35:28 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 12 May 2020 09:35:28 -0400
Date:   Tue, 12 May 2020 09:35:28 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To:     Peter Chen <peter.chen@nxp.com>
cc:     mathias.nyman@intel.com, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-imx@nxp.com>,
        Li Jun <jun.li@nxp.com>, Baolin Wang <baolin.wang@linaro.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] usb: host: xhci-plat: keep runtime active when remove
 host
In-Reply-To: <20200512023547.31164-1-peter.chen@nxp.com>
Message-ID: <Pine.LNX.4.44L0.2005120931060.21033-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 May 2020, Peter Chen wrote:

> From: Li Jun <jun.li@nxp.com>
> 
> While remove host(e.g. for USB role switch from host to device), if
> runtime pm is enabled by user, below oops are occurs at dwc3
> and cdns3 platform. Keep the xhci-plat device being active during
> remove host fixes them.

...

> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 1d4f6f85f0fe..f38d53528c96 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -362,6 +362,7 @@ static int xhci_plat_remove(struct platform_device *dev)
>  	struct clk *reg_clk = xhci->reg_clk;
>  	struct usb_hcd *shared_hcd = xhci->shared_hcd;
>  
> +	pm_runtime_get_sync(&dev->dev);
>  	xhci->xhc_state |= XHCI_STATE_REMOVING;
>  
>  	usb_remove_hcd(shared_hcd);

You mustn't add a pm_runtime_get call without a corresponding 
pm_runtime_put call.

With just this one call, if the role switched from host to device and 
then back to host, then the host would never be able to go into runtime 
suspend.

In this case the correspondence between the get's and the put's will 
probably be obscure; some comments would help.

Alan Stern

