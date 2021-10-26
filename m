Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E8043B45E
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 16:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236754AbhJZOjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 10:39:19 -0400
Received: from smtp71.ord1c.emailsrvr.com ([108.166.43.71]:39247 "EHLO
        smtp71.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236825AbhJZOjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 10:39:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1635258435;
        bh=ygMxfHxoiBiJdno19BOD9W/2ZmzB4nrg+CxY+1M83Oc=;
        h=Subject:To:From:Date:From;
        b=b7kc31AKRuIW7MUJFJq1+/EhUiYSHYYAEy2tSs7ePZLT7pWivTeesLhki+rNGoyn1
         Pt15TlXKXAobqAADdJ+F3wSoXajaN5SEGAKV0+6SVQ28e0OYDDY0xmOsB9x68esY/O
         ulAT/RgSwAGWi1BIfrXYc24qhUm95wAZs70Hil1Q=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp9.relay.ord1c.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 6A98C200FB;
        Tue, 26 Oct 2021 10:27:14 -0400 (EDT)
Subject: Re: [PATCH 2/5] comedi: dt9812: fix DMA buffers on stack
To:     Johan Hovold <johan@kernel.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20211025114532.4599-1-johan@kernel.org>
 <20211025114532.4599-3-johan@kernel.org>
From:   Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd.
Message-ID: <ecdee752-72c3-c48a-fee2-49dccf115d71@mev.co.uk>
Date:   Tue, 26 Oct 2021 15:27:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211025114532.4599-3-johan@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Classification-ID: e21ebda7-67d4-45a0-b931-c527437faa1d-1-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/10/2021 12:45, Johan Hovold wrote:
> USB transfer buffers are typically mapped for DMA and must not be
> allocated on the stack or transfers will fail.
> 
> Allocate proper transfer buffers in the various command helpers and
> return an error on short transfers instead of acting on random stack
> data.
> 
> Note that this also fixes a stack info leak on systems where DMA is not
> used as 32 bytes are always sent to the device regardless of how short
> the command is.
> 
> Fixes: 63274cd7d38a ("Staging: comedi: add usb dt9812 driver")
> Cc: stable@vger.kernel.org      # 2.6.29
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>   drivers/comedi/drivers/dt9812.c | 109 ++++++++++++++++++++++++--------
>   1 file changed, 82 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/comedi/drivers/dt9812.c b/drivers/comedi/drivers/dt9812.c
> index 634f57730c1e..f15c306f2d06 100644
> --- a/drivers/comedi/drivers/dt9812.c
> +++ b/drivers/comedi/drivers/dt9812.c
> @@ -32,6 +32,7 @@
>   #include <linux/kernel.h>
>   #include <linux/module.h>
>   #include <linux/errno.h>
> +#include <linux/slab.h>
>   #include <linux/uaccess.h>
>   
>   #include "../comedi_usb.h"
> @@ -237,22 +238,41 @@ static int dt9812_read_info(struct comedi_device *dev,
>   {
>   	struct usb_device *usb = comedi_to_usb_dev(dev);
>   	struct dt9812_private *devpriv = dev->private;
> -	struct dt9812_usb_cmd cmd;
> +	struct dt9812_usb_cmd *cmd;
>   	int count, ret;
> +	u8 *tbuf;
>   
> -	cmd.cmd = cpu_to_le32(DT9812_R_FLASH_DATA);
> -	cmd.u.flash_data_info.address =
> +	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +	if (!cmd)
> +		return -ENOMEM;
> +
> +	cmd->cmd = cpu_to_le32(DT9812_R_FLASH_DATA);
> +	cmd->u.flash_data_info.address =
>   	    cpu_to_le16(DT9812_DIAGS_BOARD_INFO_ADDR + offset);
> -	cmd.u.flash_data_info.numbytes = cpu_to_le16(buf_size);
> +	cmd->u.flash_data_info.numbytes = cpu_to_le16(buf_size);
>   
>   	/* DT9812 only responds to 32 byte writes!! */
>   	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
> -			   &cmd, 32, &count, DT9812_USB_TIMEOUT);
> +			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
> +	kfree(cmd);
>   	if (ret)
>   		return ret;
>   
> -	return usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
> -			    buf, buf_size, &count, DT9812_USB_TIMEOUT);
> +	tbuf = kmalloc(buf_size, GFP_KERNEL);
> +	if (!tbuf)
> +		return -ENOMEM;
> +
> +	ret = usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
> +			   tbuf, buf_size, &count, DT9812_USB_TIMEOUT);
> +	if (!ret) {
> +		if (count == buf_size)
> +			memcpy(buf, tbuf, buf_size);
> +		else
> +			ret = -EREMOTEIO;
> +	}
> +	kfree(tbuf);
> +
> +	return ret;
>   }

I suggest doing all the allocations up front so it doesn't leave an 
unread reply message in the unlikely event that the tbuf allocation 
fails.  (It could even allocate a single buffer for both the command and 
the reply since they are not needed at the same time.)

Ditto for the other functions in the patch.

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-
