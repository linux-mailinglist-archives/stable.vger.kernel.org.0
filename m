Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5694FA1B3
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 04:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbiDIChq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 22:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbiDIChq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 22:37:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC083BF503;
        Fri,  8 Apr 2022 19:35:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FEED6227F;
        Sat,  9 Apr 2022 02:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBB0C385A3;
        Sat,  9 Apr 2022 02:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649471739;
        bh=baxJuU2shTq7S7OigpyIL7+rpR1k+DrGoYlD1evcj6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eyKlDu7laGkgX9RjAFY2r2eyQsofxiVETjwKHwIQ2Ycu2dND/t+y5u5GoKRh4pFL5
         0tauhoRe3m4aHbDumCmT+h1Wh7p/G9gGX+bZH/sg+/aNxskDoL68EPM2MnvIAqm3es
         w3nnJefPIcn45D30Cxqi2/xu6RrpAlLxZr59rALDvFfsUUiNEhmCQqvmDmVUesEb0t
         +U+byDN329gKME7P7vrOgVb54IkOrA4MB5qhkoMEiyVWQxoss4xUTN1BKqOXHWN0L5
         pOEAysE+jIMrTNTXeVVdMJOzayGKexNaSXmQUl7G69woHOp79aBj09yAS7R2eQxzcu
         yrn5BsGoTho9w==
Date:   Sat, 9 Apr 2022 10:35:31 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     rogerq@kernel.org, a-govindraju@ti.com, gregkh@linuxfoundation.org,
        felipe.balbi@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdns3: Fix issue for clear halt endpoint
Message-ID: <20220409023531.GA3818@Peter>
References: <20220329084605.4022-1-pawell@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329084605.4022-1-pawell@cadence.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22-03-29 10:46:05, Pawel Laszczak wrote:
> Path fixes bug which occurs during resetting endpoint in

%s/Path/Patch, otherwise:

Acked-by: Peter Chen <peter.chen@kernel.org>

> __cdns3_gadget_ep_clear_halt function. During resetting endpoint
> controller will change HW/DMA owned TRB. It set Abort flag in
> trb->control and will change trb->length field. If driver want
> to use the aborted trb it must update the changed field in
> TRB.
> 
> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> cc: <stable@vger.kernel.org>
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
>  drivers/usb/cdns3/cdns3-gadget.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
> index 80aaab159e58..3a9f0968fd24 100644
> --- a/drivers/usb/cdns3/cdns3-gadget.c
> +++ b/drivers/usb/cdns3/cdns3-gadget.c
> @@ -2682,6 +2682,7 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
>  	struct usb_request *request;
>  	struct cdns3_request *priv_req;
>  	struct cdns3_trb *trb = NULL;
> +	struct cdns3_trb trb_tmp;
>  	int ret;
>  	int val;
>  
> @@ -2691,8 +2692,10 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
>  	if (request) {
>  		priv_req = to_cdns3_request(request);
>  		trb = priv_req->trb;
> -		if (trb)
> +		if (trb) {
> +			trb_tmp = *trb;
>  			trb->control = trb->control ^ cpu_to_le32(TRB_CYCLE);
> +		}
>  	}
>  
>  	writel(EP_CMD_CSTALL | EP_CMD_EPRST, &priv_dev->regs->ep_cmd);
> @@ -2707,7 +2710,7 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
>  
>  	if (request) {
>  		if (trb)
> -			trb->control = trb->control ^ cpu_to_le32(TRB_CYCLE);
> +			*trb = trb_tmp;
>  
>  		cdns3_rearm_transfer(priv_ep, 1);
>  	}
> -- 
> 2.25.1
> 

-- 

Thanks,
Peter Chen

