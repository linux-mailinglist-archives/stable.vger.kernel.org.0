Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9442249C6DB
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 10:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239361AbiAZJtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 04:49:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239366AbiAZJtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 04:49:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B73C06161C;
        Wed, 26 Jan 2022 01:49:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7F16B81620;
        Wed, 26 Jan 2022 09:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E9AC340E9;
        Wed, 26 Jan 2022 09:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643190560;
        bh=eSBUUZ4PU2/loOQTmfkpoEAdrelpmbjY6oI5SaDsVD4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sIQbu9FwtedPwomYSW3kdBu4cDrKrqHQNPbj0w1T3QCBpmTtWB+reqI9qwLIneilR
         aiPDH+S01ahHAhtOzXUtnV5QommkjEaurmpzKloCxebZGHuVgCvUUZZNLymQZW4/zZ
         Wg7ck7DpPka99UbU7lbMNhtfrSoxE5FOXYtLpdKU=
Date:   Wed, 26 Jan 2022 10:49:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hongyu Xie <xy521521@gmail.com>
Cc:     mathias.nyman@intel.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, 125707942@qq.com,
        Hongyu Xie <xiehongyu1@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH -next] xhci: fix two places when dealing with return
 value of function xhci_check_args
Message-ID: <YfEZFtf9K8pFC8Mw@kroah.com>
References: <20220126094126.923798-1-xy521521@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126094126.923798-1-xy521521@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 05:41:26PM +0800, Hongyu Xie wrote:
> From: Hongyu Xie <xiehongyu1@kylinos.cn>
> 
> xhci_check_args returns 4 types of value, -ENODEV, -EINVAL, 1 and 0.
> xhci_urb_enqueue and xhci_check_streams_endpoint return -EINVAL if
> the return value of xhci_check_args <= 0.
> This will cause a problem.

What problem?

> For example, r8152_submit_rx calling usb_submit_urb in
> drivers/net/usb/r8152.c.
> r8152_submit_rx will never get -ENODEV after submiting an urb
> when xHC is halted,
> because xhci_urb_enqueue returns -EINVAL in the very beginning.
> 
> Fixes: 203a86613fb3 ("xhci: Avoid NULL pointer deref when host dies.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
> ---
>  drivers/usb/host/xhci.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index dc357cabb265..a7a55dd206fe 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -1604,9 +1604,12 @@ static int xhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
>  	struct urb_priv	*urb_priv;
>  	int num_tds;
>  
> -	if (!urb || xhci_check_args(hcd, urb->dev, urb->ep,
> -					true, true, __func__) <= 0)
> +	if (!urb)
>  		return -EINVAL;
> +	ret = xhci_check_args(hcd, urb->dev, urb->ep,
> +					true, true, __func__);
> +	if (ret <= 0)
> +		return ret;

So if 0 is returned, you will now return that here, is that ok?
That is a change in functionality.

But this can only ever be the case for a root hub, is that ok?

>  
>  	slot_id = urb->dev->slot_id;
>  	ep_index = xhci_get_endpoint_index(&urb->ep->desc);
> @@ -3323,7 +3326,7 @@ static int xhci_check_streams_endpoint(struct xhci_hcd *xhci,
>  		return -EINVAL;
>  	ret = xhci_check_args(xhci_to_hcd(xhci), udev, ep, 1, true, __func__);
>  	if (ret <= 0)
> -		return -EINVAL;
> +		return ret;

Again, this means all is good?  Why is this being called for a root hub?

thanks,

greg k-h
