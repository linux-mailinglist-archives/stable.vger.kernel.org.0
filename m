Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEBC13989B
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 19:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgAMSQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 13:16:04 -0500
Received: from [167.172.186.51] ([167.172.186.51]:33636 "EHLO shell.v3.sk"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726934AbgAMSQE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jan 2020 13:16:04 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 37BFEDFE00;
        Mon, 13 Jan 2020 18:16:06 +0000 (UTC)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id GQk6v_fn2iS5; Mon, 13 Jan 2020 18:16:05 +0000 (UTC)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 8F5BBDF241;
        Mon, 13 Jan 2020 18:16:05 +0000 (UTC)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3XGmZ5XrTaCr; Mon, 13 Jan 2020 18:16:05 +0000 (UTC)
Received: from nedofet.lan (unknown [109.183.109.54])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 282ECDFE19;
        Mon, 13 Jan 2020 18:16:05 +0000 (UTC)
Message-ID: <d292dfbb9b10129c76f7a282c5a1015b04b775dd.camel@v3.sk>
Subject: Re: [PATCH] media: usbtv: fix control-message timeouts
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Johan Hovold <johan@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Date:   Mon, 13 Jan 2020 19:15:56 +0100
In-Reply-To: <20200113171818.30715-1-johan@kernel.org>
References: <20200113171818.30715-1-johan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-01-13 at 18:18 +0100, Johan Hovold wrote:
> The driver was issuing synchronous uninterruptible control requests
> without using a timeout. This could lead to the driver hanging on
> various user requests due to a malfunctioning (or malicious) device
> until the device is physically disconnected.
> 
> The USB upper limit of five seconds per request should be more than
> enough.
> 
> Fixes: f3d27f34fdd7 ("[media] usbtv: Add driver for Fushicai USBTV007 video frame grabber")
> Fixes: c53a846c48f2 ("[media] usbtv: add video controls")
> Cc: stable <stable@vger.kernel.org>     # 3.11
> Cc: Lubomir Rintel <lkundrak@v3.sk>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Acked-by: Lubomir Rintel <lkundrak@v3.sk>

Thank you,
Lubo

> ---
>  drivers/media/usb/usbtv/usbtv-core.c  | 2 +-
>  drivers/media/usb/usbtv/usbtv-video.c | 5 +++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
> index 5095c380b2c1..ee9c656d121f 100644
> --- a/drivers/media/usb/usbtv/usbtv-core.c
> +++ b/drivers/media/usb/usbtv/usbtv-core.c
> @@ -56,7 +56,7 @@ int usbtv_set_regs(struct usbtv *usbtv, const u16 regs[][2], int size)
>  
>  		ret = usb_control_msg(usbtv->udev, pipe, USBTV_REQUEST_REG,
>  			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> -			value, index, NULL, 0, 0);
> +			value, index, NULL, 0, USB_CTRL_GET_TIMEOUT);
>  		if (ret < 0)
>  			return ret;
>  	}
> diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
> index 3d9284a09ee5..b249f037900c 100644
> --- a/drivers/media/usb/usbtv/usbtv-video.c
> +++ b/drivers/media/usb/usbtv/usbtv-video.c
> @@ -800,7 +800,8 @@ static int usbtv_s_ctrl(struct v4l2_ctrl *ctrl)
>  		ret = usb_control_msg(usbtv->udev,
>  			usb_rcvctrlpipe(usbtv->udev, 0), USBTV_CONTROL_REG,
>  			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> -			0, USBTV_BASE + 0x0244, (void *)data, 3, 0);
> +			0, USBTV_BASE + 0x0244, (void *)data, 3,
> +			USB_CTRL_GET_TIMEOUT);
>  		if (ret < 0)
>  			goto error;
>  	}
> @@ -851,7 +852,7 @@ static int usbtv_s_ctrl(struct v4l2_ctrl *ctrl)
>  	ret = usb_control_msg(usbtv->udev, usb_sndctrlpipe(usbtv->udev, 0),
>  			USBTV_CONTROL_REG,
>  			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> -			0, index, (void *)data, size, 0);
> +			0, index, (void *)data, size, USB_CTRL_SET_TIMEOUT);
>  
>  error:
>  	if (ret < 0)

