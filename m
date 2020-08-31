Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F971257BF6
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgHaPP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:15:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:55587 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728143AbgHaPP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 11:15:27 -0400
Received: (qmail 552468 invoked by uid 1000); 31 Aug 2020 11:15:26 -0400
Date:   Mon, 31 Aug 2020 11:15:26 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        mthierer@gmail.com, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: Fix out of sync data toggle if a configured device
 is reconfigured
Message-ID: <20200831151526.GA550151@rowland.harvard.edu>
References: <20200831114649.24183-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831114649.24183-1-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 31, 2020 at 02:46:49PM +0300, Mathias Nyman wrote:
> Userspace drivers that use a SetConfiguration() request to "lightweight"
> reset a already configured usb device might cause data toggles to get out
> of sync between the device and host, and the device becomes unusable.
> 
> The xHCI host requires endpoints to be dropped and added back to reset the
> toggle. USB core avoids these otherwise extra steps if the current active
> configuration is the same as the new requested configuration.

You should mention usb_reset_configuration() here.  After all, that's
where most of the changes in this patch occur.

> 
> A SetConfiguration() request will reset the device side data toggles.
> Make sure usb core drops and adds back the endpoints in this case.
> 
> To avoid code duplication split the current usb_disable_device() function
> and reuse the endpoint specific part.
> 
> Cc: stable <stable@vger.kernel.org>
> Tested-by: Martin Thierer <mthierer@gmail.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---

> @@ -1589,8 +1579,12 @@ int usb_reset_configuration(struct usb_device *dev)
>  			USB_REQ_SET_CONFIGURATION, 0,
>  			config->desc.bConfigurationValue, 0,
>  			NULL, 0, USB_CTRL_SET_TIMEOUT);
> -	if (retval < 0)
> -		goto reset_old_alts;
> +	if (retval < 0) {
> +		retval = usb_hcd_alloc_bandwidth(dev, NULL, NULL, NULL);
> +		usb_enable_lpm(dev);
> +		mutex_unlock(hcd->bandwidth_mutex);
> +		return retval;

That's not right; we want to return the original error code.  Not 0,
which usb_hcd_alloc_bandwidth() will probably give us.  Just remove
the "retval =" from the call above.

Alan Stern
