Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490A62E97D9
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 15:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbhADO6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 09:58:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727042AbhADO6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 09:58:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC455221E5;
        Mon,  4 Jan 2021 14:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609772256;
        bh=cSXzlo1VyJZrkqHZffSxyzkWsUgpaaQcutjOd2D9uZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DwlATMyYCk5YmwHSDlDw6M/qzKh+Ag+cxfR8AQn7bzgjyuxpWIqFEzAWaouVYiPQP
         rhBqns+RM5ERN8yWFWNNjRoaun0i3jFAXOVBor5qWbpXb16pnSrrGi6a+N0VQ4N1NE
         3SfBTuu/lqfgKeePemo0xRgs8Nr1P5cPxpWUhg44=
Date:   Mon, 4 Jan 2021 15:59:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: usblp: fix DMA to stack
Message-ID: <X/MtNtTd96S39HQL@kroah.com>
References: <20210104145302.2087-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104145302.2087-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 03:53:02PM +0100, Johan Hovold wrote:
> Stack-allocated buffers cannot be used for DMA (on all architectures).
> 
> Replace the HP-channel macro with a helper function that allocates a
> dedicated transfer buffer so that it can continue to be used with
> arguments from the stack.
> 
> Note that the buffer is cleared on allocation as usblp_ctrl_msg()
> returns success also on short transfers (the buffer is only used for
> debugging).
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/usb/class/usblp.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
> index 67cbd42421be..134dc2005ce9 100644
> --- a/drivers/usb/class/usblp.c
> +++ b/drivers/usb/class/usblp.c
> @@ -274,8 +274,25 @@ static int usblp_ctrl_msg(struct usblp *usblp, int request, int type, int dir, i
>  #define usblp_reset(usblp)\
>  	usblp_ctrl_msg(usblp, USBLP_REQ_RESET, USB_TYPE_CLASS, USB_DIR_OUT, USB_RECIP_OTHER, 0, NULL, 0)
>  
> -#define usblp_hp_channel_change_request(usblp, channel, buffer) \
> -	usblp_ctrl_msg(usblp, USBLP_REQ_HP_CHANNEL_CHANGE_REQUEST, USB_TYPE_VENDOR, USB_DIR_IN, USB_RECIP_INTERFACE, channel, buffer, 1)
> +static int usblp_hp_channel_change_request(struct usblp *usblp, int channel, u8 *new_channel)
> +{
> +	u8 *buf;
> +	int ret;
> +
> +	buf = kzalloc(1, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	ret = usblp_ctrl_msg(usblp, USBLP_REQ_HP_CHANNEL_CHANGE_REQUEST,
> +			USB_TYPE_VENDOR, USB_DIR_IN, USB_RECIP_INTERFACE,
> +			channel, buf, 1);
> +	if (ret == 0)
> +		*new_channel = buf[0];
> +
> +	kfree(buf);
> +
> +	return ret;
> +}

Wow, no one uses this driver anymore it seems, this should have
triggered a runtime warning on newer kernels :(

Thanks for this, will queue it up soon.

greg k-h
