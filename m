Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B0043791B
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 16:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbhJVOhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 10:37:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232949AbhJVOhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Oct 2021 10:37:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1AE36109F;
        Fri, 22 Oct 2021 14:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634913291;
        bh=vMehTnw/7CbFMS0uyscUo0WBYVQACSfaEfUP4lmMBVU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mnf6wNkuVg2gYby8Xyi4CbBh+85x2Y9DUG6my3CnR70fe2PcqP+KBseVYIc5gSj4b
         eMfLi1xW8AZ0M7LMUbk+8zEDYTOoxUbI0XbjkQPlJWuFWalhEVAQyAfHryYo3UAYsV
         LJA7HBepLeIi2zKcnZ7jmKSfE5AyTINRRXGXF7l0=
Date:   Fri, 22 Oct 2021 16:34:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Perrot <thomas.perrot@bootlin.com>
Cc:     linux-spi@vger.kernel.org, broonie@kernel.org,
        linus.walleij@linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH] spi: spl022: fix Microwire full duplex mode
Message-ID: <YXLMBPje3zMPYH8S@kroah.com>
References: <20211022142104.1386379-1-thomas.perrot@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022142104.1386379-1-thomas.perrot@bootlin.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 22, 2021 at 04:21:04PM +0200, Thomas Perrot wrote:
> There are missing braces in the function that verify controller parameters,
> then an error is always returned when the parameter to select Microwire
> frames operation is used on devices allowing it.
> 
> Signed-off-by: Thomas Perrot <thomas.perrot@bootlin.com>
> ---
>  drivers/spi/spi-pl022.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
> index feebda66f56e..e4484ace584e 100644
> --- a/drivers/spi/spi-pl022.c
> +++ b/drivers/spi/spi-pl022.c
> @@ -1716,12 +1716,13 @@ static int verify_controller_parameters(struct pl022 *pl022,
>  				return -EINVAL;
>  			}
>  		} else {
> -			if (chip_info->duplex != SSP_MICROWIRE_CHANNEL_FULL_DUPLEX)
> +			if (chip_info->duplex != SSP_MICROWIRE_CHANNEL_FULL_DUPLEX) {
>  				dev_err(&pl022->adev->dev,
>  					"Microwire half duplex mode requested,"
>  					" but this is only available in the"
>  					" ST version of PL022\n");
> -			return -EINVAL;
> +				return -EINVAL;
> +			}
>  		}
>  	}
>  	return 0;
> -- 
> 2.31.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
