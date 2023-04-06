Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8748E6D8F92
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 08:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbjDFGhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 02:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235208AbjDFGhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 02:37:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5725B8A6F;
        Wed,  5 Apr 2023 23:37:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF68262BE3;
        Thu,  6 Apr 2023 06:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5BAC433D2;
        Thu,  6 Apr 2023 06:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680763030;
        bh=vq6kY+dugOOAccH81P3M0ANBZyroiFKbkpLxZ/jFuJE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ejWK0ZtEJPBoEPNXKh7IG/KEcweD5pQjgKfNDiyvF8hsLLomw6JghcL2BLFiiHbso
         JihpWmbjVhgsg0BYEJ4QABnboCa93r5zojzsSneDBUaRv3mDSAybkmIRH3fYcv01VY
         1oMmfnedzjigXwQIKMXN53ASf9Hz8l/sakUWD2e0=
Date:   Thu, 6 Apr 2023 08:37:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     stern@rowland.harvard.edu, colin.i.king@gmail.com,
        xuetao09@huawei.com, quic_eserrao@quicinc.com,
        water.zhangjiantao@huawei.com, peter.chen@freescale.com,
        balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] usb: gadget: udc: core: Invoke usb_gadget_connect
 only when started
Message-ID: <2023040639-lair-risotto-4693@gregkh>
References: <20230406062549.2461917-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406062549.2461917-1-badhri@google.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 06, 2023 at 06:25:48AM +0000, Badhri Jagan Sridharan wrote:
> usb_udc_connect_control does not check to see if the udc has already
> been started. This causes gadget->ops->pullup to be called through
> usb_gadget_connect when invoked from usb_udc_vbus_handler even before
> usb_gadget_udc_start is called. Guard this by checking for udc->started
> in usb_udc_connect_control before invoking usb_gadget_connect.
> 
> Guarding udc->vbus, udc->started, gadget->connect, gadget->deactivate
> related functions with connect_lock. usb_gadget_connect_locked,
> usb_gadget_disconnect_locked, usb_udc_connect_control_locked,
> usb_gadget_udc_start_locked, usb_gadget_udc_stop_locked are called with
> this lock held as they can be simulataneously invoked from different code
> paths.
> 
> Adding an additional check to make sure udc is started(udc->started)
> before pullup callback is invoked.
> 
> Cc: stable@vger.kernel.org
> Fixes: 628ef0d273a6 ("usb: udc: add usb_udc_vbus_handler")
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> ---
> * Fixed commit message comments.
> * Renamed udc_connect_control_lock to connect_lock and made it per
> device.
> * udc->vbus, udc->started, gadget->connect, gadget->deactivate are all
> now guarded by connect_lock.
> * Code now checks for udc->started to be set before invoking pullup
> callback.
> ---
>  drivers/usb/gadget/udc/core.c | 140 +++++++++++++++++++++++-----------
>  1 file changed, 96 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
> index 3dcbba739db6..41d3a1998cff 100644
> --- a/drivers/usb/gadget/udc/core.c
> +++ b/drivers/usb/gadget/udc/core.c
> @@ -37,6 +37,10 @@ static struct bus_type gadget_bus_type;
>   * @vbus: for udcs who care about vbus status, this value is real vbus status;
>   * for udcs who do not care about vbus status, this value is always true
>   * @started: the UDC's started state. True if the UDC had started.
> + * @connect_lock: protects udc->vbus, udc->started, gadget->connect, gadget->deactivate related
> + * functions. usb_gadget_connect_locked, usb_gadget_disconnect_locked,
> + * usb_udc_connect_control_locked, usb_gadget_udc_start_locked, usb_gadget_udc_stop_locked are
> + * called with this lock held.
>   *
>   * This represents the internal data structure which is used by the UDC-class
>   * to hold information about udc driver and gadget together.
> @@ -48,6 +52,7 @@ struct usb_udc {
>  	struct list_head		list;
>  	bool				vbus;
>  	bool				started;
> +	struct mutex			connect_lock;
>  };
>  
>  static struct class *udc_class;
> @@ -687,17 +692,8 @@ int usb_gadget_vbus_disconnect(struct usb_gadget *gadget)
>  }
>  EXPORT_SYMBOL_GPL(usb_gadget_vbus_disconnect);
>  
> -/**
> - * usb_gadget_connect - software-controlled connect to USB host
> - * @gadget:the peripheral being connected
> - *
> - * Enables the D+ (or potentially D-) pullup.  The host will start
> - * enumerating this gadget when the pullup is active and a VBUS session
> - * is active (the link is powered).
> - *
> - * Returns zero on success, else negative errno.
> - */
> -int usb_gadget_connect(struct usb_gadget *gadget)
> +/* Internal version of usb_gadget_connect needs to be called with udc_connect_control_lock held. */

Shouldn't you just use the __must_hold() marking here to document this
so that the tools can properly check and validate it as well?

thanks,

greg k-h
