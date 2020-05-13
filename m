Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C6B1D17DF
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 16:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388806AbgEMOs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 10:48:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58963 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1732972AbgEMOs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 10:48:27 -0400
Received: (qmail 19438 invoked by uid 500); 13 May 2020 10:48:26 -0400
Date:   Wed, 13 May 2020 10:48:26 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Peter Chen <peter.chen@nxp.com>
Cc:     mathias.nyman@intel.com, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, dl-linux-imx <linux-imx@nxp.com>,
        Jun Li <jun.li@nxp.com>, Baolin Wang <baolin.wang@linaro.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] usb: host: xhci-plat: keep runtime active when
 remove host
Message-ID: <20200513144826.GA14570@rowland.harvard.edu>
References: <20200512023547.31164-1-peter.chen@nxp.com>
 <Pine.LNX.4.44L0.2005120931060.21033-100000@netrider.rowland.org>
 <AM7PR04MB7157DA1F920529E2D59AA4B28BBF0@AM7PR04MB7157.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM7PR04MB7157DA1F920529E2D59AA4B28BBF0@AM7PR04MB7157.eurprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 11:08:13AM +0000, Peter Chen wrote:
>  
>  
> > > diff --git a/drivers/usb/host/xhci-plat.c
> > > b/drivers/usb/host/xhci-plat.c index 1d4f6f85f0fe..f38d53528c96 100644
> > > --- a/drivers/usb/host/xhci-plat.c
> > > +++ b/drivers/usb/host/xhci-plat.c
> > > @@ -362,6 +362,7 @@ static int xhci_plat_remove(struct platform_device *dev)
> > >  	struct clk *reg_clk = xhci->reg_clk;
> > >  	struct usb_hcd *shared_hcd = xhci->shared_hcd;
> > >
> > > +	pm_runtime_get_sync(&dev->dev);
> > >  	xhci->xhc_state |= XHCI_STATE_REMOVING;
> > >
> > >  	usb_remove_hcd(shared_hcd);
> > 
> > You mustn't add a pm_runtime_get call without a corresponding pm_runtime_put
> > call.
> > 
> > With just this one call, if the role switched from host to device and then back to host,
> > then the host would never be able to go into runtime suspend.
> > 
> 
> I may not consider carefully for other cases, for my case, the xhci-plat device
> will be removed, and re-created. But if we remove the driver using modprobe,
> it may have issues.
> 
> > In this case the correspondence between the get's and the put's will probably be
> > obscure; some comments would help.
> > 
> 
> I explained at the reply for Mathias's, but I am not 100% it is the root cause.

Okay, but there's something you may not know: pm_runtime_set_suspended() 
should be called _after_ pm_runtime_disable().  If you try to set the 
state to "suspended" while the device is enabled for runtime PM, the 
call may very well fail.

In this case, if all you want to do is block callbacks to the xHCI 
suspend routine, pm_runtime_disable() is probably all you need.

Alan Stern
