Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042D356FF3F
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiGKKkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiGKKkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:40:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7812941D19;
        Mon, 11 Jul 2022 02:49:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAFA0B80E7F;
        Mon, 11 Jul 2022 09:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87566C34115;
        Mon, 11 Jul 2022 09:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657532945;
        bh=Bcrn+Ht8XgMok5yKFUWEZ0ZpHn+vZRkiMqyjeeMZ8oo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KLoO4otbf4O21ONGYCKKEBa3An0pyLc/+YZbbXUu9J6bUPcHhJswM4nstlnVkqPMl
         eoS9I5iE5PaLe9MQeedyddnZnmyc7dVRRUbxwQIrtus6J7uE3Ukk+eXxVhsfnhW9N1
         gRfILnGQXMdf7toATPxiXsSAsmZkjwJSKkBI3EW4LVDs0uCy1LKuS88k/q5vet/e7z
         FnasEWb8fVo6C1141pU2zTzWY0r34uCOV9d8LP407Yot+/IAkYbj9/EoI+9+jclLUZ
         XsZqgwJjsFD1EtNjAsEQvmmIFGw1WZld38WQGj+d9nfPQka9jvdgWoRUlhVSmFDX/T
         ErxmpVfgTRODg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oAq2L-0006mg-KV; Mon, 11 Jul 2022 11:49:06 +0200
Date:   Mon, 11 Jul 2022 11:49:05 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH] media: flexcop-usb: fix endpoint type check
Message-ID: <YsvyEexuZsINiARm@hovoldconsulting.com>
References: <20220609135341.19941-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609135341.19941-1-johan@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 09, 2022 at 03:53:41PM +0200, Johan Hovold wrote:
> Commit d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint
> type") tried to add an endpoint type sanity check for the single
> isochronous endpoint but instead broke the driver by checking the wrong
> descriptor or random data beyond the last endpoint descriptor.
> 
> Make sure to check the right endpoint descriptor.
> 
> Fixes: d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint type")
> Cc: Oliver Neukum <oneukum@suse.com>
> Cc: stable@vger.kernel.org	# 5.9
> Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---

I haven't received any notification about this one being added to any
tree and the status is still set to "NEW" in the patch tracker so
sending a reminder.

>  drivers/media/usb/b2c2/flexcop-usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
> index 7835bb0f32fc..e012b21c4fd7 100644
> --- a/drivers/media/usb/b2c2/flexcop-usb.c
> +++ b/drivers/media/usb/b2c2/flexcop-usb.c
> @@ -511,7 +511,7 @@ static int flexcop_usb_init(struct flexcop_usb *fc_usb)
>  
>  	if (fc_usb->uintf->cur_altsetting->desc.bNumEndpoints < 1)
>  		return -ENODEV;
> -	if (!usb_endpoint_is_isoc_in(&fc_usb->uintf->cur_altsetting->endpoint[1].desc))
> +	if (!usb_endpoint_is_isoc_in(&fc_usb->uintf->cur_altsetting->endpoint[0].desc))
>  		return -ENODEV;
>  
>  	switch (fc_usb->udev->speed) {

Johan
