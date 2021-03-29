Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80A834D6DA
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 20:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhC2SSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 14:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231389AbhC2SSM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 14:18:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BF7E6192B;
        Mon, 29 Mar 2021 18:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617041892;
        bh=nRlv7oKiyPTUscVlNKur+n5RxWjp9uMyiKtRCJqtWNk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GhtaFj1Nrjtf5xwsmRRkQLDLVweInLjp1vpPBeoxrqXTbxbKdV04MEg5J6gua8oYl
         0PFRZRoy4ejU4Zhsj0lkGGugBjvKoxbmf/7JEp43a6a/S9qZv5tz6VvrLCsQYw7/nn
         wwZTphqhcC8kCSglNIWSBu8GSXz0bbG2tV2bFots=
Date:   Mon, 29 Mar 2021 20:18:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Annaliese McDermond <nh6z@nh6z.net>
Cc:     "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "team@nwdigitalradio.com" <team@nwdigitalradio.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] sc16is7xx: Defer probe if device read fails
Message-ID: <YGIZ4bOX/4DF0KQ4@kroah.com>
References: <20210329154013.408967-1-nh6z@nh6z.net>
 <010101787ea4d8c4-08608e8d-9755-4a88-9908-af95233a4f8e-000000@us-west-2.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <010101787ea4d8c4-08608e8d-9755-4a88-9908-af95233a4f8e-000000@us-west-2.amazonses.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 03:40:35PM +0000, Annaliese McDermond wrote:
> A test was added to the probe function to ensure the device was
> actually connected and working before successfully completing a
> probe.  If the device was actually there, but the I2C bus was not
> ready yet for whatever reason, the probe fails permanently.
> 
> Change the probe so that we defer the probe on a regmap read
> failure so that we try the probe again when the dependent drivers
> are potentially loaded.  This should not affect the case where the
> device truly isn't present because the probe will never successfully
> complete.
> 
> Fixes: 2aa916e ("sc16is7xx: Read the LSR register for basic device presence check")

Please use the full 12 characters of the git commit id, as the
documentation asks for.  This should be:

Fixes: 2aa916e67db3 ("sc16is7xx: Read the LSR register for basic device presence check")

> Cc: stable@vger.kernel.org
> Signed-off-by: Annaliese McDermond <nh6z@nh6z.net>
> ---
>  drivers/tty/serial/sc16is7xx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
> index f86ec2d2635b..9adb8362578c 100644
> --- a/drivers/tty/serial/sc16is7xx.c
> +++ b/drivers/tty/serial/sc16is7xx.c
> @@ -1196,7 +1196,7 @@ static int sc16is7xx_probe(struct device *dev,
>  	ret = regmap_read(regmap,
>  			  SC16IS7XX_LSR_REG << SC16IS7XX_REG_SHIFT, &val);
>  	if (ret < 0)
> -		return ret;
> +		return -EPROBE_DEFER;
>  
>  	/* Alloc port structure */
>  	s = devm_kzalloc(dev, struct_size(s, p, devtype->nr_uart), GFP_KERNEL);
> -- 
> 2.27.0

Any reason you did not cc: the tty maintainer with this change?

thanks,

greg k-h
