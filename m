Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B433B163B
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 10:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhFWIyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 04:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229833AbhFWIyW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 04:54:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8822611AD;
        Wed, 23 Jun 2021 08:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624438325;
        bh=q1/pZ+8XNyXmDYADtZuYnclhptwzKj9U01waM05X9kM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G3Q2NGpduDsEzBbm+JtSbBOWO8IxUb5//355wIoeaDmbU6jQ2dj1m7J336hvTIpZ7
         xWomRwFI2rkCcJvbpp3DG4ewNXRHSBaoI0YdSXwgb0jcYY25U4WeeCxYreT1C4047X
         ivvm/aFuHyTN8aazHHb76orlBvrUt0REJTBl1jNU/gF4ggfxNaHwffhfaJ31qnj8PZ
         TdD+ujwj5I6itPUFrN5dnMzrxlPF9ErQ+DQH9An5dRAxxnD21s/qRq6XXZLC+8thta
         dJzgCzejV/VGrHIzAAZX17La7HiBni1JWoibGmgqESqAsfdt+BXOP3+j6r12kcWfkC
         orP1bJ3ou1Scg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lvyc8-0001tR-79; Wed, 23 Jun 2021 10:52:04 +0200
Date:   Wed, 23 Jun 2021 10:52:04 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Wolfram Sang <wsa@kernel.org>
Cc:     linux-i2c@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+9d7dadd15b8819d73f41@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] i2c: robotfuzz-osif: fix control-request directions
Message-ID: <YNL2NLSpBQqnc2bH@hovoldconsulting.com>
References: <20210524090912.3989-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524090912.3989-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 11:09:12AM +0200, Johan Hovold wrote:
> The direction of the pipe argument must match the request-type direction
> bit or control requests may fail depending on the host-controller-driver
> implementation.
> 
> Control transfers without a data stage are treated as OUT requests by
> the USB stack and should be using usb_sndctrlpipe(). Failing to do so
> will now trigger a warning.
> 
> Fix the OSIFI2C_SET_BIT_RATE and OSIFI2C_STOP requests which erroneously
> used the osif_usb_read() helper and set the IN direction bit.
> 
> Reported-by: syzbot+9d7dadd15b8819d73f41@syzkaller.appspotmail.com
> Fixes: 83e53a8f120f ("i2c: Add bus driver for for OSIF USB i2c device.")
> Cc: stable@vger.kernel.org      # 3.14
> Cc: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---

Wolfram, can you pick this one up for 5.14?

Johan

>  drivers/i2c/busses/i2c-robotfuzz-osif.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-robotfuzz-osif.c b/drivers/i2c/busses/i2c-robotfuzz-osif.c
> index a39f7d092797..66dfa211e736 100644
> --- a/drivers/i2c/busses/i2c-robotfuzz-osif.c
> +++ b/drivers/i2c/busses/i2c-robotfuzz-osif.c
> @@ -83,7 +83,7 @@ static int osif_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs,
>  			}
>  		}
>  
> -		ret = osif_usb_read(adapter, OSIFI2C_STOP, 0, 0, NULL, 0);
> +		ret = osif_usb_write(adapter, OSIFI2C_STOP, 0, 0, NULL, 0);
>  		if (ret) {
>  			dev_err(&adapter->dev, "failure sending STOP\n");
>  			return -EREMOTEIO;
> @@ -153,7 +153,7 @@ static int osif_probe(struct usb_interface *interface,
>  	 * Set bus frequency. The frequency is:
>  	 * 120,000,000 / ( 16 + 2 * div * 4^prescale).
>  	 * Using dev = 52, prescale = 0 give 100KHz */
> -	ret = osif_usb_read(&priv->adapter, OSIFI2C_SET_BIT_RATE, 52, 0,
> +	ret = osif_usb_write(&priv->adapter, OSIFI2C_SET_BIT_RATE, 52, 0,
>  			    NULL, 0);
>  	if (ret) {
>  		dev_err(&interface->dev, "failure sending bit rate");
