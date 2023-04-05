Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8386D84B6
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 19:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbjDERPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 13:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbjDERPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 13:15:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F50729F;
        Wed,  5 Apr 2023 10:15:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F249625DB;
        Wed,  5 Apr 2023 17:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2297CC433D2;
        Wed,  5 Apr 2023 17:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680714920;
        bh=P2xekpx7trrXdthOyb3oSuUkeDbCS/EOeNTqftfy1vI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H+qVsfIr9j6xG1UGiwbaRsEZsV0Z6WrAOdcaIsSV3vSfHjT13mvccgk4etDBuSsFH
         jJgHPyKPiCzgjXGM1P8eLII8sG2KAAfG6dH/cSRYoh45Sld9hbcxeWTmVzMUAMcwqa
         NI8ansTcv+O7uqtSpxpDH35DHRzmvbl+V7lHrLtI=
Date:   Wed, 5 Apr 2023 19:15:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     stern@rowland.harvard.edu, colin.i.king@gmail.com,
        xuetao09@huawei.com, quic_eserrao@quicinc.com,
        water.zhangjiantao@huawei.com, peter.chen@freescale.com,
        balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] usb: gadget: udc: core: Invoke usb_gadget_connect
 only when started
Message-ID: <2023040541-gladly-refold-38a6@gregkh>
References: <20230405093133.1858140-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405093133.1858140-1-badhri@google.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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

You have a full 72 columns, please use them all :)

> 
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> Fixes: 628ef0d273a6 ("usb: udc: add usb_udc_vbus_handler")

No blank line after cc: stable, and put the fixes above your
signed-off-by line please.

> ---
>  drivers/usb/gadget/udc/core.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
> index 3dcbba739db6..890f92cb6344 100644
> --- a/drivers/usb/gadget/udc/core.c
> +++ b/drivers/usb/gadget/udc/core.c
> @@ -56,6 +56,8 @@ static LIST_HEAD(udc_list);
>  /* Protects udc_list, udc->driver, driver->is_bound, and related calls */
>  static DEFINE_MUTEX(udc_lock);
>  
> +/* Protects udc->vbus, udc-started and udc_connect_control_locked */
> +static DEFINE_MUTEX(udc_connect_control_lock);

Why a global lock?  Shouldn't this be a per-device lock?


>  /* ------------------------------------------------------------------------- */
>  
>  /**
> @@ -1078,9 +1080,10 @@ EXPORT_SYMBOL_GPL(usb_gadget_set_state);
>  
>  /* ------------------------------------------------------------------------- */
>  
> -static void usb_udc_connect_control(struct usb_udc *udc)
> +/* Acquire udc_connect_control_lock before calling this function. */
> +static void usb_udc_connect_control_locked(struct usb_udc *udc)
>  {
> -	if (udc->vbus)
> +	if (udc->vbus && udc->started)
>  		usb_gadget_connect(udc->gadget);
>  	else
>  		usb_gadget_disconnect(udc->gadget);
> @@ -1099,10 +1102,12 @@ void usb_udc_vbus_handler(struct usb_gadget *gadget, bool status)
>  {
>  	struct usb_udc *udc = gadget->udc;
>  
> +	mutex_lock(&udc_connect_control_lock);
>  	if (udc) {
>  		udc->vbus = status;
> -		usb_udc_connect_control(udc);
> +		usb_udc_connect_control_locked(udc);
>  	}
> +	mutex_unlock(&udc_connect_control_lock);
>  }
>  EXPORT_SYMBOL_GPL(usb_udc_vbus_handler);
>  
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
>  
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

Why drop this call here?

thanks,

greg k-h
