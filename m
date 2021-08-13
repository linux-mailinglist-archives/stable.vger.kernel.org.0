Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A0D3EB2DD
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 10:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239018AbhHMIuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 04:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238757AbhHMIuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 04:50:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C9C06103E;
        Fri, 13 Aug 2021 08:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628844595;
        bh=FWQ8ntvLd7fzz4RjeP8rev4pCecxLAJgVQzlpJqeXWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q7sJlI0AAgGxI1s8IT5AzZ8aGP9J/ROW3mDMi/RfPtpmXj2E4+Mlk7eVs68xEwcZN
         ZSV+NgtKcCBnBiJt6gdqvgjz4qT83FV+O7GjHwjXR/CrkK+wQUVeJkNSH4mt5aIs5J
         wARylX52RV5XsAQ6Bsr1YfxkiQ/MDsNh7C8YNqUc=
Date:   Fri, 13 Aug 2021 10:49:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sam Protsenko <semen.protsenko@linaro.org>
Cc:     stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: Re: [PATCH 5.4 0/7] usb: dwc3: Fix DRD role switch
Message-ID: <YRYyMZXrLnkK072Z@kroah.com>
References: <20210812171652.23803-1-semen.protsenko@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812171652.23803-1-semen.protsenko@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 12, 2021 at 08:16:45PM +0300, Sam Protsenko wrote:
> This patch series pulls the patch ae7e86108b12 ("usb: dwc3: Stop active
> transfers before halting the controller") and some fixes/dependencies
> for that patch. It's needed to fix the actual panic I observed when
> doing role switch with USB2.0 Dual Role Device controller. Next
> procedure can be used to reproduce the panic:
> 
> 1. Boot in peripheral role
> 2. Configure RNDIS gadget, perform ping, stop ping
> 3. Switch to host role
> 4. Kernel panic occurs
> 
> Kernel panic happens because gadget->udc->driver->disconnect() (which
> is configfs_composite_disconnect()) is not called from
> usb_gadget_disconnect() function, due to timeout condition in
> dwc3_gadget_run_stop(), which leads to not called rndis_disable(). And
> although previously created endpoints are not valid anymore,
> eth_start_xmit() gets called and tries to use those, which leads to
> invalid memory access. This patch fixes timeout condition, so next
> call chain doesn't fail anymore, and RNDIS uninitialized properly on
> gadget to host role switch:
> 
> <<<<<<<<<<<<<<<<<<<< cut here >>>>>>>>>>>>>>>>>>>
>     usb_role_switch_set_role()
>         v
>     dwc3_usb_role_switch_set()
>         v
>     dwc3_set_mode()
>         v
>     __dwc3_set_mode()
>         v
>     dwc3_gadget_exit()
>         v
>     usb_del_gadget_udc()
>         v
>     usb_gadget_remove_driver()
>         v
>     usb_gadget_disconnect()
>         v
>     // THIS IS NOT CALLED because gadget->ops->pullup() =
>     // dwc3_gadget_pullup() returns -ETIMEDOUT (-110)
>     gadget->udc->driver->disconnect()
>     // = configfs_composite_disconnect()
>         v
>     composite_disconnect()
>         v
>     reset_config()
>         v
>     foreach (f : function) : f->disable
>         v
>     rndis_disable()
>         v
>     gether_disconnect()
>         v
>     usb_ep_disable(),
>     dev->port_usb = NULL
> <<<<<<<<<<<<<<<<<<<< cut here >>>>>>>>>>>>>>>>>>>
> 
> Most of these patches are already applied in stable-5.10.
> 
> Wesley Cheng (7):
>   usb: dwc3: Stop active transfers before halting the controller
>   usb: dwc3: gadget: Allow runtime suspend if UDC unbinded
>   usb: dwc3: gadget: Restart DWC3 gadget when enabling pullup
>   usb: dwc3: gadget: Prevent EP queuing while stopping transfers
>   usb: dwc3: gadget: Clear DEP flags after stop transfers in ep disable
>   usb: dwc3: gadget: Disable gadget IRQ during pullup disable
>   usb: dwc3: gadget: Avoid runtime resume if disabling pullup
> 
>  drivers/usb/dwc3/ep0.c    |   2 +-
>  drivers/usb/dwc3/gadget.c | 118 +++++++++++++++++++++++++++++++-------
>  2 files changed, 99 insertions(+), 21 deletions(-)
> 
> -- 
> 2.30.2

Now queued up.  In the future, please put your own signed-off-by on
these patches, as you were forwarding them on to us.

thanks,

greg k-h
