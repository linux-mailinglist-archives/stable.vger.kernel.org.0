Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFED3C332E
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 08:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhGJG0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 02:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229690AbhGJG0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 02:26:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4856B6135E;
        Sat, 10 Jul 2021 06:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625898233;
        bh=um1mjck2OpH0dlbxwBVsj3YOXSr1yh5jhoDQmozzXs0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jTakte/qWz55fN3YJjEFur1kfnRc8U2b/y6n3jrXj+9wcNNjDpSJHTJmf8wiU/dmA
         myZo59fjwT+HEvWww9rZZHHOjX8BsLVoiCk9qjwscDwYC2vmVaQ0T98kO72lOiWzRI
         +iU8i20nBKfMokDYKTd0czVucwdBclLk02E/9T80=
Date:   Sat, 10 Jul 2021 08:23:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Johan Hovold <johan@kernel.org>,
        syzbot+7dbcd9ff34dc4ed45240@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 062/114] USB: core: Avoid WARNings for
 0-length descriptor requests
Message-ID: <YOk89mYb8p0Dm23k@kroah.com>
References: <20210710021748.3167666-1-sashal@kernel.org>
 <20210710021748.3167666-62-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710021748.3167666-62-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 09, 2021 at 10:16:56PM -0400, Sasha Levin wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> [ Upstream commit 60dfe484cef45293e631b3a6e8995f1689818172 ]
> 
> The USB core has utility routines to retrieve various types of
> descriptors.  These routines will now provoke a WARN if they are asked
> to retrieve 0 bytes (USB "receive" requests must not have zero
> length), so avert this by checking the size argument at the start.
> 
> CC: Johan Hovold <johan@kernel.org>
> Reported-and-tested-by: syzbot+7dbcd9ff34dc4ed45240@syzkaller.appspotmail.com
> Reviewed-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Link: https://lore.kernel.org/r/20210607152307.GD1768031@rowland.harvard.edu
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/usb/core/message.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
> index 30e9e680c74c..4d59d927ae3e 100644
> --- a/drivers/usb/core/message.c
> +++ b/drivers/usb/core/message.c
> @@ -783,6 +783,9 @@ int usb_get_descriptor(struct usb_device *dev, unsigned char type,
>  	int i;
>  	int result;
>  
> +	if (size <= 0)		/* No point in asking for no data */
> +		return -EINVAL;
> +
>  	memset(buf, 0, size);	/* Make sure we parse really received data */
>  
>  	for (i = 0; i < 3; ++i) {
> @@ -832,6 +835,9 @@ static int usb_get_string(struct usb_device *dev, unsigned short langid,
>  	int i;
>  	int result;
>  
> +	if (size <= 0)		/* No point in asking for no data */
> +		return -EINVAL;
> +
>  	for (i = 0; i < 3; ++i) {
>  		/* retry on length 0 or stall; some devices are flakey */
>  		result = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
> -- 
> 2.30.2
> 

This patch should be dropped from all of the autosel branches it was
picked to, as I do not think the USB core has been fixed up, along with
all of the different drivers that we noticed doing this, in the stable
trees.

So please drop from everywhere at this time.

thanks,

greg k-h
