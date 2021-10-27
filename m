Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD8743C615
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 11:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239921AbhJ0JI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 05:08:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232132AbhJ0JI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 05:08:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2199461039;
        Wed, 27 Oct 2021 09:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635325561;
        bh=hBNFBmosy980W50NwGoL+Bn47zg/HLrLHxp0wsfh1TM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fAgpILfQAHf+tHoZMPMLWTYoqWLaBWiBeFTxJNucFW7qiin6IWgtWHEYUpG7tY9wE
         QmrfdpyaZLm+e/WXJzAwzhJDbD6NoQVzI0S2E9XNqKrLDli9vntedVqPJ/rwmB629q
         +xZ0w2sOLHRSyj34lzybXbQOBbI5ZkJIMZOalf71JP6YYqSB2+nF0ezrakHF9IRlhK
         i98CR6XhkZ9Bs+PA5yIUX1w4ly4WlwEehBeHoi5OWCCtUF1a+f7UivX8AuCUPqfxsx
         lC1bLjascYh7hAoPUqEoUnnxuFOFwPS+ZcihignJ1HSeB7nfPCWUW+Cfx8ey7uLrWp
         NYtAOtUZxlj9w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfesT-00038K-BI; Wed, 27 Oct 2021 11:05:45 +0200
Date:   Wed, 27 Oct 2021 11:05:45 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Ian Abbott <abbotti@mev.co.uk>
Cc:     H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/5] comedi: dt9812: fix DMA buffers on stack
Message-ID: <YXkWaREjhd1+Law+@hovoldconsulting.com>
References: <20211025114532.4599-1-johan@kernel.org>
 <20211025114532.4599-3-johan@kernel.org>
 <ecdee752-72c3-c48a-fee2-49dccf115d71@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecdee752-72c3-c48a-fee2-49dccf115d71@mev.co.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 26, 2021 at 03:27:13PM +0100, Ian Abbott wrote:
> On 25/10/2021 12:45, Johan Hovold wrote:
> > USB transfer buffers are typically mapped for DMA and must not be
> > allocated on the stack or transfers will fail.
> > 
> > Allocate proper transfer buffers in the various command helpers and
> > return an error on short transfers instead of acting on random stack
> > data.
> > 
> > Note that this also fixes a stack info leak on systems where DMA is not
> > used as 32 bytes are always sent to the device regardless of how short
> > the command is.
> > 
> > Fixes: 63274cd7d38a ("Staging: comedi: add usb dt9812 driver")
> > Cc: stable@vger.kernel.org      # 2.6.29
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >   drivers/comedi/drivers/dt9812.c | 109 ++++++++++++++++++++++++--------
> >   1 file changed, 82 insertions(+), 27 deletions(-)
> > 
> > diff --git a/drivers/comedi/drivers/dt9812.c b/drivers/comedi/drivers/dt9812.c
> > index 634f57730c1e..f15c306f2d06 100644
> > --- a/drivers/comedi/drivers/dt9812.c
> > +++ b/drivers/comedi/drivers/dt9812.c
> > @@ -32,6 +32,7 @@
> >   #include <linux/kernel.h>
> >   #include <linux/module.h>
> >   #include <linux/errno.h>
> > +#include <linux/slab.h>
> >   #include <linux/uaccess.h>
> >   
> >   #include "../comedi_usb.h"
> > @@ -237,22 +238,41 @@ static int dt9812_read_info(struct comedi_device *dev,
> >   {
> >   	struct usb_device *usb = comedi_to_usb_dev(dev);
> >   	struct dt9812_private *devpriv = dev->private;
> > -	struct dt9812_usb_cmd cmd;
> > +	struct dt9812_usb_cmd *cmd;
> >   	int count, ret;
> > +	u8 *tbuf;
> >   
> > -	cmd.cmd = cpu_to_le32(DT9812_R_FLASH_DATA);
> > -	cmd.u.flash_data_info.address =
> > +	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> > +	if (!cmd)
> > +		return -ENOMEM;
> > +
> > +	cmd->cmd = cpu_to_le32(DT9812_R_FLASH_DATA);
> > +	cmd->u.flash_data_info.address =
> >   	    cpu_to_le16(DT9812_DIAGS_BOARD_INFO_ADDR + offset);
> > -	cmd.u.flash_data_info.numbytes = cpu_to_le16(buf_size);
> > +	cmd->u.flash_data_info.numbytes = cpu_to_le16(buf_size);
> >   
> >   	/* DT9812 only responds to 32 byte writes!! */
> >   	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
> > -			   &cmd, 32, &count, DT9812_USB_TIMEOUT);
> > +			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
> > +	kfree(cmd);
> >   	if (ret)
> >   		return ret;
> >   
> > -	return usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
> > -			    buf, buf_size, &count, DT9812_USB_TIMEOUT);
> > +	tbuf = kmalloc(buf_size, GFP_KERNEL);
> > +	if (!tbuf)
> > +		return -ENOMEM;
> > +
> > +	ret = usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
> > +			   tbuf, buf_size, &count, DT9812_USB_TIMEOUT);
> > +	if (!ret) {
> > +		if (count == buf_size)
> > +			memcpy(buf, tbuf, buf_size);
> > +		else
> > +			ret = -EREMOTEIO;
> > +	}
> > +	kfree(tbuf);
> > +
> > +	return ret;
> >   }
> 
> I suggest doing all the allocations up front so it doesn't leave an 
> unread reply message in the unlikely event that the tbuf allocation 
> fails.  (It could even allocate a single buffer for both the command and 
> the reply since they are not needed at the same time.)

These small allocations will currently never fail, but if they ever were
to, there are other allocations done in the I/O path which would have
the same effect if they failed. And if this ever happens, you certainly
have bigger problems than worrying about the state of this device. :)

That said, I'll see if I can reuse a single buffer without things
getting too messy.

Johan
