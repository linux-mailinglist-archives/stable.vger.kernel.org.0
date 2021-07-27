Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149AF3D767B
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbhG0N34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:29:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232268AbhG0N2V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:28:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 884A361A60;
        Tue, 27 Jul 2021 13:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627392502;
        bh=INvQri55joG33IWmMLux0huoNxZaF8kK3K11aKpnvPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZVhx53+sl8wU1q7ufcmKEDrQcp4iUdQJhYtBZDvrfkAHU5wBE7RyQ2gns+7kpSV62
         sO+bfd/z3hcY7TdX7ndQpbsSV8/ohlHxdHpKOf6Mc85UbTimr0NJxOMpWXYbCG4Dr9
         ra+mNuvPz56KgDDl6jKb89HejxXG5MCm+ErgSOpQ=
Date:   Tue, 27 Jul 2021 15:28:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        syzbot+72af3105289dcb4c055b@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 06/21] USB: core: Fix incorrect pipe
 calculation in do_proc_control()
Message-ID: <YQAJ9LzK8S7tJqwR@kroah.com>
References: <20210727131908.834086-1-sashal@kernel.org>
 <20210727131908.834086-6-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727131908.834086-6-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 09:18:53AM -0400, Sasha Levin wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> [ Upstream commit b0863f1927323110e3d0d69f6adb6a91018a9a3c ]
> 
> When the user submits a control URB via usbfs, the user supplies the
> bRequestType value and the kernel uses it to compute the pipe value.
> However, do_proc_control() performs this computation incorrectly in
> the case where the bRequestType direction bit is set to USB_DIR_IN and
> the URB's transfer length is 0: The pipe's direction is also set to IN
> but it should be OUT, which is the direction the actual transfer will
> use regardless of bRequestType.
> 
> Commit 5cc59c418fde ("USB: core: WARN if pipe direction != setup
> packet direction") added a check to compare the direction bit in the
> pipe value to a control URB's actual direction and to WARN if they are
> different.  This can be triggered by the incorrect computation
> mentioned above, as found by syzbot.
> 
> This patch fixes the computation, thus avoiding the WARNing.
> 
> Reported-and-tested-by: syzbot+72af3105289dcb4c055b@syzkaller.appspotmail.com
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Link: https://lore.kernel.org/r/20210712185436.GB326369@rowland.harvard.edu
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/usb/core/devio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index 2218941d35a3..73b60f013b20 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -1133,7 +1133,7 @@ static int do_proc_control(struct usb_dev_state *ps,
>  		"wIndex=%04x wLength=%04x\n",
>  		ctrl->bRequestType, ctrl->bRequest, ctrl->wValue,
>  		ctrl->wIndex, ctrl->wLength);
> -	if (ctrl->bRequestType & 0x80) {
> +	if ((ctrl->bRequestType & USB_DIR_IN) && ctrl->wLength) {
>  		pipe = usb_rcvctrlpipe(dev, 0);
>  		snoop_urb(dev, NULL, pipe, ctrl->wLength, tmo, SUBMIT, NULL, 0);
>  
> -- 
> 2.30.2
> 

This is not needed in any kernel that does not also have 5cc59c418fde
("USB: core: WARN if pipe direction != setup packet direction"), which
showed up in 5.14-rc1, so please drop this from all of the AUTOSEL
trees.

thanks,

greg k-h
