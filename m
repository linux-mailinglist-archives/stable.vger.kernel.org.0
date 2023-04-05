Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553426D84D4
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 19:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbjDERYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 13:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjDERX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 13:23:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9448359E6;
        Wed,  5 Apr 2023 10:23:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3144562725;
        Wed,  5 Apr 2023 17:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F569C433EF;
        Wed,  5 Apr 2023 17:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680715437;
        bh=+23YZI4FA2opcooepIGmO0ta8rwHQwWSwbc2NVkm61Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tFcl0Lm25/Eef1bguECV1FJQaP9eZRoLXe/GZJ10S62y4tkuUer1WRqMECjRjgkwU
         JwrUHPx+qCZRnXqaWW9DgwYsJ3HSZn1MvwFFWq+6BhTUi5ZB7JFo3fgc7ktU1EBKW/
         +8/n5OxFChoG+nr/K25NAE0ML6eMUgQIMkKkP4Nk=
Date:   Wed, 5 Apr 2023 19:23:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     peter.chen@kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdnsp: Fixes error: uninitialized symbol 'len'
Message-ID: <2023040514-outspoken-librarian-3cde@gregkh>
References: <20230331090600.454674-1-pawell@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331090600.454674-1-pawell@cadence.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 31, 2023 at 05:06:00AM -0400, Pawel Laszczak wrote:
> The patch 5bc38d33a5a1: "usb: cdnsp: Fixes issue with redundant
> Status Stage" leads to the following Smatch static checker warning:
> 
>   drivers/usb/cdns3/cdnsp-ep0.c:470 cdnsp_setup_analyze()
>   error: uninitialized symbol 'len'.

Are you sure this is correct?

> 
> cc: <stable@vger.kernel.org>
> Fixes: 5bc38d33a5a1 ("usb: cdnsp: Fixes issue with redundant Status Stage")
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
>  drivers/usb/cdns3/cdnsp-ep0.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/cdns3/cdnsp-ep0.c b/drivers/usb/cdns3/cdnsp-ep0.c
> index d63d5d92f255..f317d3c84781 100644
> --- a/drivers/usb/cdns3/cdnsp-ep0.c
> +++ b/drivers/usb/cdns3/cdnsp-ep0.c
> @@ -414,7 +414,7 @@ static int cdnsp_ep0_std_request(struct cdnsp_device *pdev,
>  void cdnsp_setup_analyze(struct cdnsp_device *pdev)
>  {
>  	struct usb_ctrlrequest *ctrl = &pdev->setup;
> -	int ret = 0;
> +	int ret = -EINVAL;
>  	u16 len;
>  
>  	trace_cdnsp_ctrl_req(ctrl);
> @@ -424,7 +424,6 @@ void cdnsp_setup_analyze(struct cdnsp_device *pdev)
>  
>  	if (pdev->gadget.state == USB_STATE_NOTATTACHED) {
>  		dev_err(pdev->dev, "ERR: Setup detected in unattached state\n");
> -		ret = -EINVAL;

That's a nice change, but I don't see the original error here that you
are saying this change fixes.

What am I missing?

thanks,

greg k-h
