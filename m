Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B41E43DE26
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 11:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhJ1JyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 05:54:19 -0400
Received: from smtp87.iad3a.emailsrvr.com ([173.203.187.87]:43716 "EHLO
        smtp87.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230126AbhJ1JyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Oct 2021 05:54:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1635414317;
        bh=CYy7x/FF6kwpFQYSiYAtB0kHpztDGzB1vTD/96AEPg8=;
        h=Subject:To:From:Date:From;
        b=FDTxiCaaJnXoxqw9cDWA2M+IDVnckJavRHQyXpNQOwVtHclsjIyctXQv5HE6UJtCG
         1YFHTJTNlnvatPee2UClM8jJjAxLS3ZyZSfSdmwGohjP2dsX2UIVFQNVHq5PHY3JGF
         e6Y+kdFFttt/GUBVB9pf2NFq73VWFtErtfmxU+K0=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp19.relay.iad3a.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 34BC043C2;
        Thu, 28 Oct 2021 05:45:16 -0400 (EDT)
Subject: Re: [PATCH v2 2/2] comedi: dt9812: fix DMA buffers on stack
To:     Johan Hovold <johan@kernel.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20211027093529.30896-1-johan@kernel.org>
 <20211027093529.30896-3-johan@kernel.org>
From:   Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd.
Message-ID: <7b6d9a85-c2a5-2f3d-5385-81df0ef7f195@mev.co.uk>
Date:   Thu, 28 Oct 2021 10:45:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211027093529.30896-3-johan@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Classification-ID: 2228fac0-5ceb-4e0c-b35a-279f4d924c94-1-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/10/2021 10:35, Johan Hovold wrote:
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
>   drivers/comedi/drivers/dt9812.c | 115 ++++++++++++++++++++++++--------
>   1 file changed, 86 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/comedi/drivers/dt9812.c b/drivers/comedi/drivers/dt9812.c
> index 634f57730c1e..704b04d2980d 100644
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
> @@ -237,22 +238,42 @@ static int dt9812_read_info(struct comedi_device *dev,
>   {
>   	struct usb_device *usb = comedi_to_usb_dev(dev);
>   	struct dt9812_private *devpriv = dev->private;
> -	struct dt9812_usb_cmd cmd;
> +	struct dt9812_usb_cmd *cmd;
> +	size_t tbuf_size;
>   	int count, ret;
> +	void *tbuf;
>   
> -	cmd.cmd = cpu_to_le32(DT9812_R_FLASH_DATA);
> -	cmd.u.flash_data_info.address =
> +	tbuf_size = max(sizeof(*cmd), buf_size);
> +
> +	tbuf = kzalloc(tbuf_size, GFP_KERNEL);
> +	if (!tbuf)
> +		return -ENOMEM;
> +
> +	cmd = tbuf;
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
>   	if (ret)
> -		return ret;
> +		goto out;
> +
> +	ret = usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
> +			   tbuf, buf_size, &count, DT9812_USB_TIMEOUT);
> +	if (!ret) {
> +		if (count == buf_size)
> +			memcpy(buf, tbuf, buf_size);
> +		else
> +			ret = -EREMOTEIO;
> +	}
> +out:
> +	kfree(tbuf);
>   
> -	return usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
> -			    buf, buf_size, &count, DT9812_USB_TIMEOUT);
> +	return ret;
>   }
>   
>   static int dt9812_read_multiple_registers(struct comedi_device *dev,
> @@ -261,22 +282,42 @@ static int dt9812_read_multiple_registers(struct comedi_device *dev,
>   {
>   	struct usb_device *usb = comedi_to_usb_dev(dev);
>   	struct dt9812_private *devpriv = dev->private;
> -	struct dt9812_usb_cmd cmd;
> +	struct dt9812_usb_cmd *cmd;
>   	int i, count, ret;
> +	size_t buf_size;
> +	void *buf;
>   
> -	cmd.cmd = cpu_to_le32(DT9812_R_MULTI_BYTE_REG);
> -	cmd.u.read_multi_info.count = reg_count;
> +	buf_size = max_t(size_t, sizeof(*cmd), reg_count);
> +
> +	buf = kzalloc(buf_size, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	cmd = buf;
> +
> +	cmd->cmd = cpu_to_le32(DT9812_R_MULTI_BYTE_REG);
> +	cmd->u.read_multi_info.count = reg_count;
>   	for (i = 0; i < reg_count; i++)
> -		cmd.u.read_multi_info.address[i] = address[i];
> +		cmd->u.read_multi_info.address[i] = address[i];
>   
>   	/* DT9812 only responds to 32 byte writes!! */
>   	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
> -			   &cmd, 32, &count, DT9812_USB_TIMEOUT);
> +			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
>   	if (ret)
> -		return ret;
> +		goto out;
> +
> +	ret = usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
> +			   buf, reg_count, &count, DT9812_USB_TIMEOUT);
> +	if (!ret) {
> +		if (count == reg_count)
> +			memcpy(value, buf, reg_count);
> +		else
> +			ret = -EREMOTEIO;
> +	}
> +out:
> +	kfree(buf);
>   
> -	return usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
> -			    value, reg_count, &count, DT9812_USB_TIMEOUT);
> +	return ret;
>   }
>   
>   static int dt9812_write_multiple_registers(struct comedi_device *dev,
> @@ -285,19 +326,27 @@ static int dt9812_write_multiple_registers(struct comedi_device *dev,
>   {
>   	struct usb_device *usb = comedi_to_usb_dev(dev);
>   	struct dt9812_private *devpriv = dev->private;
> -	struct dt9812_usb_cmd cmd;
> +	struct dt9812_usb_cmd *cmd;
>   	int i, count;
> +	int ret;
> +
> +	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +	if (!cmd)
> +		return -ENOMEM;
>   
> -	cmd.cmd = cpu_to_le32(DT9812_W_MULTI_BYTE_REG);
> -	cmd.u.read_multi_info.count = reg_count;
> +	cmd->cmd = cpu_to_le32(DT9812_W_MULTI_BYTE_REG);
> +	cmd->u.read_multi_info.count = reg_count;
>   	for (i = 0; i < reg_count; i++) {
> -		cmd.u.write_multi_info.write[i].address = address[i];
> -		cmd.u.write_multi_info.write[i].value = value[i];
> +		cmd->u.write_multi_info.write[i].address = address[i];
> +		cmd->u.write_multi_info.write[i].value = value[i];
>   	}
>   
>   	/* DT9812 only responds to 32 byte writes!! */
> -	return usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
> -			    &cmd, 32, &count, DT9812_USB_TIMEOUT);
> +	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
> +			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
> +	kfree(cmd);
> +
> +	return ret;
>   }
>   
>   static int dt9812_rmw_multiple_registers(struct comedi_device *dev,
> @@ -306,17 +355,25 @@ static int dt9812_rmw_multiple_registers(struct comedi_device *dev,
>   {
>   	struct usb_device *usb = comedi_to_usb_dev(dev);
>   	struct dt9812_private *devpriv = dev->private;
> -	struct dt9812_usb_cmd cmd;
> +	struct dt9812_usb_cmd *cmd;
>   	int i, count;
> +	int ret;
> +
> +	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +	if (!cmd)
> +		return -ENOMEM;
>   
> -	cmd.cmd = cpu_to_le32(DT9812_RMW_MULTI_BYTE_REG);
> -	cmd.u.rmw_multi_info.count = reg_count;
> +	cmd->cmd = cpu_to_le32(DT9812_RMW_MULTI_BYTE_REG);
> +	cmd->u.rmw_multi_info.count = reg_count;
>   	for (i = 0; i < reg_count; i++)
> -		cmd.u.rmw_multi_info.rmw[i] = rmw[i];
> +		cmd->u.rmw_multi_info.rmw[i] = rmw[i];
>   
>   	/* DT9812 only responds to 32 byte writes!! */
> -	return usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
> -			    &cmd, 32, &count, DT9812_USB_TIMEOUT);
> +	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
> +			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
> +	kfree(cmd);
> +
> +	return ret;
>   }
>   
>   static int dt9812_digital_in(struct comedi_device *dev, u8 *bits)
> 

Looks great, thanks!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-
