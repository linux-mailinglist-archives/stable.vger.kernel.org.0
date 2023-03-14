Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461326B9C7E
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 18:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjCNRIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 13:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCNRIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 13:08:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17D54C34;
        Tue, 14 Mar 2023 10:08:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CA1CB81A59;
        Tue, 14 Mar 2023 17:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF92C433D2;
        Tue, 14 Mar 2023 17:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678813726;
        bh=JNIQSdUCIjiAkwlMaJ5Xo54AjCtVj7uDpQv8Jko/3v8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zRW/YC8Hqi6/kG16phZuWE2YXQbfFss98KwxlWkloeanfPbQtndD7JFdYWnvyZoyK
         5wTB5y0nYdzjy4mUAr9Eqg7vKTGbu9xTLukuFqqrHbGmq5rixupxtnE0WRbNYfUTaZ
         +kAN6o1d5anD5UyWckK+TEEMYo3pQImNR8Ky+GFQ=
Date:   Tue, 14 Mar 2023 18:08:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Danila Chernetsov <listdansp@mail.ru>
Cc:     stable@vger.kernel.org, Bin Liu <b-liu@ti.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org, Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH 5.10 1/1] usb: musb: core: drop redundant checks
Message-ID: <ZBCqHJz8zYeXQ3Q7@kroah.com>
References: <20230314170113.11968-1-listdansp@mail.ru>
 <20230314170113.11968-2-listdansp@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314170113.11968-2-listdansp@mail.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 14, 2023 at 05:01:13PM +0000, Danila Chernetsov wrote:
> From: Sergey Shtylyov <s.shtylyov@omp.ru>
> 
> commit b0ec7e55fce65f125bd1d7f02e2dc4de62abee34 upstream. 

Nit, trailing whitespace, please fix your editor to show this up easier.

> 
> In musb_{save|restore}_context() the expression '&musb->endpoints[i]' just
> cannot be NULL, so the checks have no sense at all -- after dropping them,
> the local variables 'hw_ep' are no longer necessary, so drop them as well.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE static
> analysis tool.
> 
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> Link: https://lore.kernel.org/r/3f8f60d9-f1b5-6b2c-1222-39b156151a22@omp.ru
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
> ---
>  drivers/usb/musb/musb_core.c | 16 ++--------------
>  1 file changed, 2 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> index 4c8f0112481f..605f5cc0f18b 100644
> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -2673,13 +2673,7 @@ static void musb_save_context(struct musb *musb)
>  	musb->context.devctl = musb_readb(musb_base, MUSB_DEVCTL);
>  
>  	for (i = 0; i < musb->config->num_eps; ++i) {
> -		struct musb_hw_ep	*hw_ep;
> -
> -		hw_ep = &musb->endpoints[i];
> -		if (!hw_ep)
> -			continue;
> -
> -		epio = hw_ep->regs;
> +		epio = musb->endpoints[i].regs;

Why is this needed in the stable releases?  It just seems to remove
unused code, but does not change any logic at all, so why backport it?

thanks,

greg k-h
