Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86A1540398
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 18:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245726AbiFGQRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 12:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344956AbiFGQRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 12:17:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297CE1021F0;
        Tue,  7 Jun 2022 09:17:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE8EC617D1;
        Tue,  7 Jun 2022 16:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E86AC34115;
        Tue,  7 Jun 2022 16:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654618623;
        bh=cltI8ipIsU1EiWWqS+Ft3aujMmumfLUmHhvGFk8ZlpY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f/vz7QL6T+zVVKU9X8kiEPNnHx+W17JHRcfBcrYqHXEeF6Ia5HgkwGpLLcy4aSiak
         l0q4tXbfuqYfZsJGuLLuKHgk9WdS5N9tPm7J65BgLAj2vWpODet5nFPSH6nM7Tmt7/
         sVq4H8Eux8iDZqt0G9rfJkXHj9qMrGPastWlA9Eco05qQcDYuTi8QVGrMrSds9fjaZ
         +CopbgAVP4MY+FIM107gkwr2Al2NDl93a8VnBhXKq28Mwb5zniXmeaFRegYOBTKKSL
         oig6xX6PL6iedPLbHJcaQtS5kj1f9j+3r9K6rS/f8OyOMVrIiRo2B/Z655jp8+8B4A
         xwAjB7PUGXq/w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nybt3-00029y-R7; Tue, 07 Jun 2022 18:16:57 +0200
Date:   Tue, 7 Jun 2022 18:16:57 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Ian Abbott <abbotti@mev.co.uk>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] comedi: vmk80xx: fix expression for tx buffer size
Message-ID: <Yp95+QKSqeH5AG0a@hovoldconsulting.com>
References: <20220606105237.13937-1-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606105237.13937-1-abbotti@mev.co.uk>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 06, 2022 at 11:52:37AM +0100, Ian Abbott wrote:
> The expression for setting the size of the allocated bulk TX buffer
> (`devpriv->usb_tx_buf`) is calling `usb_endpoint_maxp(devpriv->ep_rx)`,
> which is using the wrong endpoint (should be `devpriv->ep_tx`).  Fix it.

Bah. Good catch.

> Fixes: a23461c47482 ("comedi: vmk80xx: fix transfer-buffer overflow")
> Cc: Johan Hovold <johan@kernel.org>
> Cc: stable@vger.kernel.org # 5.10, 5.15+

I believe this one is needed in all stable trees (e.g. 4.9+).

> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  drivers/comedi/drivers/vmk80xx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/comedi/drivers/vmk80xx.c b/drivers/comedi/drivers/vmk80xx.c
> index 46023adc5395..4536ed43f65b 100644
> --- a/drivers/comedi/drivers/vmk80xx.c
> +++ b/drivers/comedi/drivers/vmk80xx.c
> @@ -684,7 +684,7 @@ static int vmk80xx_alloc_usb_buffers(struct comedi_device *dev)
>  	if (!devpriv->usb_rx_buf)
>  		return -ENOMEM;
>  
> -	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
> +	size = max(usb_endpoint_maxp(devpriv->ep_tx), MIN_BUF_SIZE);
>  	devpriv->usb_tx_buf = kzalloc(size, GFP_KERNEL);
>  	if (!devpriv->usb_tx_buf)
>  		return -ENOMEM;

Looks good otherwise:

Reviewed-by: Johan Hovold <johan@kernel.org>
