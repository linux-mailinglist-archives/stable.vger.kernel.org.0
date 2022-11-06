Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A9961E127
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 10:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiKFJIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 04:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiKFJIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 04:08:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257F7A9;
        Sun,  6 Nov 2022 01:08:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 920DB60C07;
        Sun,  6 Nov 2022 09:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5EEC433C1;
        Sun,  6 Nov 2022 09:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667725700;
        bh=oSY2pB7T1Vm2y2VVy5D70U7pf0RgTlyiyzQ20GmbmMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k/pv7fMcaOv+eL7kiY75jtJZgr2H4SeF6Wk4jqIvV8QYy9yomZ9Ak2moOfhC9wcT+
         Cpjc3CIIwZQ7Gv0G1lwRWVS/iBYDKvmF8u7H8UQ7hIAMGwJdSSqhqIBVlC8e+go2/2
         aWV8wtBjgIrNkTmWMaNFQQ/MQxp/0nt5ABOx/T7xUXCoQzYa+FYJZxOH2YI3yiJLV9
         w/lqvMZ5i3tWqEPFrUZYgrkgz/jMoQ2byJbh00w/zsXjFZzPCm6ombAcSqs4nP/l9j
         Vp94ooQLvcQ+NBEeyapRt6JTbaw0RmY8GY10pgptlDJB8etr/xAJ0nK4vCHqTmQ4ug
         hcdEQvCGBzvTw==
Date:   Sun, 6 Nov 2022 17:08:15 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdnsp: Fix issue with Clear Feature Halt Endpoint
Message-ID: <20221106090815.GB152143@nchen-desktop>
References: <20221026093710.449809-1-pawell@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026093710.449809-1-pawell@cadence.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22-10-26 05:37:10, Pawel Laszczak wrote:
> During handling Clear Halt Endpoint Feature request driver invokes
> Reset Endpoint command. Because this command has some issue with

What are issues? Would you please explain more?

> transition endpoint from Running to Idle state the driver must
> stop the endpoint by using Stop Endpoint command.
> 
> cc: <stable@vger.kernel.org>
> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
>  drivers/usb/cdns3/cdnsp-gadget.c | 12 ++++--------
>  drivers/usb/cdns3/cdnsp-ring.c   |  3 ++-
>  2 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
> index e2e7d16f43f4..0576f9b0e4aa 100644
> --- a/drivers/usb/cdns3/cdnsp-gadget.c
> +++ b/drivers/usb/cdns3/cdnsp-gadget.c
> @@ -600,11 +600,11 @@ int cdnsp_halt_endpoint(struct cdnsp_device *pdev,
>  
>  	trace_cdnsp_ep_halt(value ? "Set" : "Clear");
>  
> -	if (value) {
> -		ret = cdnsp_cmd_stop_ep(pdev, pep);
> -		if (ret)
> -			return ret;
> +	ret = cdnsp_cmd_stop_ep(pdev, pep);
> +	if (ret)
> +		return ret;
>  

In your change ,it call cdnsp_cmd_stop_ep unconditionally, no matter
set or clear halt? Is it your expectation? If it is, why?

> +	if (value) {
>  		if (GET_EP_CTX_STATE(pep->out_ctx) == EP_STATE_STOPPED) {
>  			cdnsp_queue_halt_endpoint(pdev, pep->idx);
>  			cdnsp_ring_cmd_db(pdev);
> @@ -613,10 +613,6 @@ int cdnsp_halt_endpoint(struct cdnsp_device *pdev,
>  
>  		pep->ep_state |= EP_HALTED;
>  	} else {
> -		/*
> -		 * In device mode driver can call reset endpoint command
> -		 * from any endpoint state.
> -		 */
>  		cdnsp_queue_reset_ep(pdev, pep->idx);
>  		cdnsp_ring_cmd_db(pdev);
>  		ret = cdnsp_wait_for_cmd_compl(pdev);
> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
> index 25e5e51cf5a2..aa79bce89d8a 100644
> --- a/drivers/usb/cdns3/cdnsp-ring.c
> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> @@ -2081,7 +2081,8 @@ int cdnsp_cmd_stop_ep(struct cdnsp_device *pdev, struct cdnsp_ep *pep)
>  	u32 ep_state = GET_EP_CTX_STATE(pep->out_ctx);
>  	int ret = 0;
>  
> -	if (ep_state == EP_STATE_STOPPED || ep_state == EP_STATE_DISABLED) {
> +	if (ep_state == EP_STATE_STOPPED || ep_state == EP_STATE_DISABLED ||
> +	    ep_state == EP_STATE_HALTED) {
>  		trace_cdnsp_ep_stopped_or_disabled(pep->out_ctx);
>  		goto ep_stopped;
>  	}
> -- 
> 2.25.1
> 

-- 

Thanks,
Peter Chen
