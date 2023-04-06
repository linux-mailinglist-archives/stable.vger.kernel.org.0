Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2516D8CB9
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 03:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbjDFB32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 21:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjDFB31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 21:29:27 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id DA6F67281
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 18:29:25 -0700 (PDT)
Received: (qmail 420619 invoked by uid 1000); 5 Apr 2023 21:29:25 -0400
Date:   Wed, 5 Apr 2023 21:29:25 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     gregkh@linuxfoundation.org, colin.i.king@gmail.com,
        xuetao09@huawei.com, quic_eserrao@quicinc.com,
        water.zhangjiantao@huawei.com, peter.chen@freescale.com,
        balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] usb: gadget: udc: core: Invoke usb_gadget_connect
 only when started
Message-ID: <56abca17-7240-4bd5-98db-ef48059ff315@rowland.harvard.edu>
References: <20230405093133.1858140-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405093133.1858140-1-badhri@google.com>
X-Spam-Status: No, score=0.2 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 09:31:32AM +0000, Badhri Jagan Sridharan wrote:
> usb_udc_connect_control does not check to see if the udc
> has already been started. This causes gadget->ops->pullup
> to be called through usb_gadget_connect when invoked
> from usb_udc_vbus_handler even before usb_gadget_udc_start
> is called. Guard this by checking for udc->started in
> usb_udc_connect_control before invoking usb_gadget_connect.
> 
> Guarding udc_connect_control, udc->started and udc->vbus
> with its own mutex as usb_udc_connect_control_locked
> can be simulataneously invoked from different code paths.
> 
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> Fixes: 628ef0d273a6 ("usb: udc: add usb_udc_vbus_handler")

There's a problem with this patch.

> ---
>  drivers/usb/gadget/udc/core.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
> index 3dcbba739db6..890f92cb6344 100644
> --- a/drivers/usb/gadget/udc/core.c
> +++ b/drivers/usb/gadget/udc/core.c

> @@ -1140,14 +1145,18 @@ static inline int usb_gadget_udc_start(struct usb_udc *udc)
>  {
>  	int ret;
>  
> +	mutex_lock(&udc_connect_control_lock);
>  	if (udc->started) {
>  		dev_err(&udc->dev, "UDC had already started\n");
> +		mutex_unlock(&udc_connect_control_lock);
>  		return -EBUSY;
>  	}
>  
>  	ret = udc->gadget->ops->udc_start(udc->gadget, udc->driver);
>  	if (!ret)
>  		udc->started = true;
> +	usb_udc_connect_control_locked(udc);
> +	mutex_unlock(&udc_connect_control_lock);

You moved the connect_control call up here, into usb_gadget_udc_start().

>  	return ret;
>  }
> @@ -1165,13 +1174,17 @@ static inline int usb_gadget_udc_start(struct usb_udc *udc)
>   */
>  static inline void usb_gadget_udc_stop(struct usb_udc *udc)
>  {
> +	mutex_lock(&udc_connect_control_lock);
>  	if (!udc->started) {
>  		dev_err(&udc->dev, "UDC had already stopped\n");
> +		mutex_unlock(&udc_connect_control_lock);
>  		return;
>  	}
>  
>  	udc->gadget->ops->udc_stop(udc->gadget);
>  	udc->started = false;
> +	usb_udc_connect_control_locked(udc);
> +	mutex_unlock(&udc_connect_control_lock);
>  }
>  
>  /**
> @@ -1527,7 +1540,6 @@ static int gadget_bind_driver(struct device *dev)
>  	if (ret)
>  		goto err_start;
>  	usb_gadget_enable_async_callbacks(udc);
> -	usb_udc_connect_control(udc);

This is where it used to be.

The problem is that in the gadget_bind_driver pathway, 
usb_gadget_enable_async_callbacks() has to run _before_ the gadget 
connects.  Maybe you can fix this by leaving the function call in its 
original location and protecting it with the new mutex?

There may be a similar problem with disconnecting and the 
gadget_unbind_driver pathway (usb_gadget_disable_async_callbacks() has to 
run _after_ the disconnect occurs).  I haven't tried to follow the patch 
in enough detail to see whether that's an issue.

Alan Stern

>  
>  	kobject_uevent(&udc->dev.kobj, KOBJ_CHANGE);
>  	return 0;
> 
> base-commit: d629c0e221cd99198b843d8351a0a9bfec6c0423
> -- 
> 2.40.0.348.gf938b09366-goog
> 
