Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4647C5A40D4
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 03:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiH2B5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Aug 2022 21:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiH2B5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Aug 2022 21:57:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0179313DEA;
        Sun, 28 Aug 2022 18:57:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E71360F3C;
        Mon, 29 Aug 2022 01:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53884C433D6;
        Mon, 29 Aug 2022 01:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661738267;
        bh=z4Bsz7dg3CXBuuS7BKupLqvnSwB7N9ZMKDxr/arv4F4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=giTuMv1usF4fqZ0UCoaw/l+51imegL7fu0L+qgl0Uw9nVgv31FhzET0MTmonXUN/L
         4sbqIzOv4S5rnPbJY4dZpV3EpmUJ9RdrwlSChpreOuc3TQeVFTiUYeb2mxsJE8IkXx
         wB3AGXTP3Jte0ORqL9Lt6JSA/BBmQfYQUyd4yVyuvf9zFFKsbXR+l4XE/jQxEM4yNc
         jp4h4+pwETT2QzUs5DU/FoNxxnWe9kzH/xgjphwN6Oxjq2zd01ba4x89lNXvdnlQ17
         i53DQaJUrEvFuKSWB/WxKa2eD+hfT6b71PaC8yXU7yDRh4ACpW4POsqjLsQhfadNia
         UrWVIZZXTOKQw==
Date:   Mon, 29 Aug 2022 09:57:41 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        felipe.balbi@linux.intel.com, rogerq@kernel.org,
        a-govindraju@ti.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdns3: fix incorrect handling TRB_SMM flag for ISOC
 transfer
Message-ID: <20220829015741.GA32096@nchen-desktop>
References: <20220825062207.5824-1-pawell@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220825062207.5824-1-pawell@cadence.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22-08-25 08:22:07, Pawel Laszczak wrote:
> The TRB_SMM flag indicates that DMA has completed the TD service with
> this TRB. Usually it’s a last TRB in TD. In case of ISOC transfer for
> bInterval > 1 each ISOC transfer contains more than one TD associated
> with usb request (one TD per ITP). In such case the TRB_SMM flag will
> be set in every TD and driver will recognize the end of transfer after
> processing the first TD with TRB_SMM. In result driver stops updating
> request->actual and returns incorrect actual length.
> To fix this issue driver additionally must check TRB_CHAIN which is not
> used for isochronous transfers.
> 
> Fixes: 249f0a25e8be ("usb: cdns3: gadget: handle sg list use case at completion correctly")
> cc: <stable@vger.kernel.org>
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>

Acked-by: Peter Chen <peter.chen@kernel.org>

> ---
>  drivers/usb/cdns3/cdns3-gadget.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
> index fa8263951e63..a6618a922c61 100644
> --- a/drivers/usb/cdns3/cdns3-gadget.c
> +++ b/drivers/usb/cdns3/cdns3-gadget.c
> @@ -1529,7 +1529,8 @@ static void cdns3_transfer_completed(struct cdns3_device *priv_dev,
>  						TRB_LEN(le32_to_cpu(trb->length));
>  
>  				if (priv_req->num_of_trb > 1 &&
> -					le32_to_cpu(trb->control) & TRB_SMM)
> +					le32_to_cpu(trb->control) & TRB_SMM &&
> +					le32_to_cpu(trb->control) & TRB_CHAIN)
>  					transfer_end = true;
>  
>  				cdns3_ep_inc_deq(priv_ep);
> -- 
> 2.25.1
> 

-- 

Thanks,
Peter Chen
