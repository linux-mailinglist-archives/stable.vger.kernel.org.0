Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329C16D84B9
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 19:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjDERQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 13:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjDERQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 13:16:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA02729B;
        Wed,  5 Apr 2023 10:16:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 766B962994;
        Wed,  5 Apr 2023 17:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A078C433EF;
        Wed,  5 Apr 2023 17:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680714957;
        bh=o/nD3UDCAjQj6GuMbLEV3rvKINq6cixlJz9FttSS+8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BCsZED6zC5244u/pBr4KMVoMPc23L7ReWq32yYvYTazDGmUgVnmHnW4wTXryGnoUH
         o7z+L0/C46qLNU6tu9oe/qxaZW8RZUcUGPTu3shMv/5raQ4ccjDMhBRmYmQASDYzTn
         737q0KXUlML2gwQwx9PhD8mtbgli1Q1EvlGyZ7XU=
Date:   Wed, 5 Apr 2023 19:15:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     stern@rowland.harvard.edu, colin.i.king@gmail.com,
        xuetao09@huawei.com, quic_eserrao@quicinc.com,
        water.zhangjiantao@huawei.com, peter.chen@freescale.com,
        balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1 2/2] usb: gadget: udc: core: Prevent redundant calls
 to pullup
Message-ID: <2023040520-corned-recluse-d191@gregkh>
References: <20230405093133.1858140-1-badhri@google.com>
 <20230405093133.1858140-2-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405093133.1858140-2-badhri@google.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 09:31:33AM +0000, Badhri Jagan Sridharan wrote:
> usb_gadget_connect calls gadget->ops->pullup without
> checking whether gadget->connected was previously set.
> Make this symmetric to usb_gadget_disconnect by returning
> early if gadget->connected is already set.
> 
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> Fixes: 5a1da544e572 ("usb: gadget: core: do not try to disconnect gadget if it is not connected")

Same changelog comment as before.

> ---
>  drivers/usb/gadget/udc/core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
> index 890f92cb6344..7eeaf7dbb350 100644
> --- a/drivers/usb/gadget/udc/core.c
> +++ b/drivers/usb/gadget/udc/core.c
> @@ -708,6 +708,9 @@ int usb_gadget_connect(struct usb_gadget *gadget)
>  		goto out;
>  	}
>  
> +	if (gadget->connected)
> +		goto out;
> +

What prevents this connected value from changing right after you check
this?

thanks,

greg k-h
