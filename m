Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DA265ADFE
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 09:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbjABIUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 03:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbjABIUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 03:20:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2859C1141;
        Mon,  2 Jan 2023 00:20:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1C92B80C83;
        Mon,  2 Jan 2023 08:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2B2C433D2;
        Mon,  2 Jan 2023 08:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672647631;
        bh=8MiLsIlCg85ximPPgt6+OfpmqpnRCZNjJOkwEjVlJWc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ThpIClg38fWqbyst3BIkwjW4HDaPl07kyYYj+yb+bNaDD93FW+F35DazEXnq04Bn3
         x+8Yztj6DKeWulW6AHXYfpY8l10ADdsoVxVNHzOV+c4LRs4K6EpAejo0JvP470jDEW
         vowrLnAntjgHk+pUTFAdvTO1ggAaeWeIHN5IgS2zYBFa8Mb+FAcgsf6yrh7YH9FDnx
         0PfDhzHdaaJOX8rPWEvHWLyLmNw/EGI35RKEosqfYzRYfCyiOdbluxLDjo1eu7spvG
         uRTrOXztIvI/Wa/Pd9DcUc0AkQVN8Wt8ubqrQzB40OH61W7/Lkrd31eVnqbjVYdnsk
         FYa4l4CTL/rUQ==
Date:   Mon, 2 Jan 2023 16:20:21 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdnsp: : add scatter gather support for ISOC
 endpoint
Message-ID: <20230102082021.GB40748@nchen-desktop>
References: <20221222090934.145140-1-pawell@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222090934.145140-1-pawell@cadence.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22-12-22 04:09:34, Pawel Laszczak wrote:
> Patch implements scatter gather support for isochronous endpoint.
> This fix is forced by 'commit e81e7f9a0eb9
> ("usb: gadget: uvc: add scatter gather support")'.
> After this fix CDNSP driver stop working with UVC class.
> 
> cc: <stable@vger.kernel.org>
> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
>  drivers/usb/cdns3/cdnsp-gadget.c |   2 +-
>  drivers/usb/cdns3/cdnsp-gadget.h |   4 +-
>  drivers/usb/cdns3/cdnsp-ring.c   | 110 +++++++++++++++++--------------
>  3 files changed, 63 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
> index a8640516c895..e81dca0e62a8 100644
> --- a/drivers/usb/cdns3/cdnsp-gadget.c
> +++ b/drivers/usb/cdns3/cdnsp-gadget.c
> @@ -382,7 +382,7 @@ int cdnsp_ep_enqueue(struct cdnsp_ep *pep, struct cdnsp_request *preq)
>  		ret = cdnsp_queue_bulk_tx(pdev, preq);
>  		break;
>  	case USB_ENDPOINT_XFER_ISOC:
> -		ret = cdnsp_queue_isoc_tx_prepare(pdev, preq);
> +		ret = cdnsp_queue_isoc_tx(pdev, preq);
>  	}
>  
>  	if (ret)
> diff --git a/drivers/usb/cdns3/cdnsp-gadget.h b/drivers/usb/cdns3/cdnsp-gadget.h
> index f740fa6089d8..e1b5801fdddf 100644
> --- a/drivers/usb/cdns3/cdnsp-gadget.h
> +++ b/drivers/usb/cdns3/cdnsp-gadget.h
> @@ -1532,8 +1532,8 @@ void cdnsp_queue_stop_endpoint(struct cdnsp_device *pdev,
>  			       unsigned int ep_index);
>  int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq);
>  int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq);
> -int cdnsp_queue_isoc_tx_prepare(struct cdnsp_device *pdev,
> -				struct cdnsp_request *preq);
> +int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
> +			struct cdnsp_request *preq);

Why you re-name this function?

Other changes are ok for me.

Peter

>  void cdnsp_queue_configure_endpoint(struct cdnsp_device *pdev,
>  				    dma_addr_t in_ctx_ptr);
>  void cdnsp_queue_reset_ep(struct cdnsp_device *pdev, unsigned int ep_index);
> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
> index b23e543b3a3d..07f6068342d4 100644
> --- a/drivers/usb/cdns3/cdnsp-ring.c
> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> @@ -1333,6 +1333,20 @@ static int cdnsp_handle_tx_event(struct cdnsp_device *pdev,
>  					 ep_ring->dequeue, td->last_trb,
>  					 ep_trb_dma);
>  
> +		desc = td->preq->pep->endpoint.desc;
> +
> +		if (ep_seg) {
> +			ep_trb = &ep_seg->trbs[(ep_trb_dma - ep_seg->dma)
> +					       / sizeof(*ep_trb)];
> +
> +			trace_cdnsp_handle_transfer(ep_ring,
> +					(struct cdnsp_generic_trb *)ep_trb);
> +
> +			if (pep->skip && usb_endpoint_xfer_isoc(desc) &&
> +			    td->last_trb != ep_trb)
> +				return -EAGAIN;
> +		}
> +
>  		/*
>  		 * Skip the Force Stopped Event. The event_trb(ep_trb_dma)
>  		 * of FSE is not in the current TD pointed by ep_ring->dequeue
> @@ -1347,7 +1361,6 @@ static int cdnsp_handle_tx_event(struct cdnsp_device *pdev,
>  			goto cleanup;
>  		}
>  
> -		desc = td->preq->pep->endpoint.desc;
>  		if (!ep_seg) {
>  			if (!pep->skip || !usb_endpoint_xfer_isoc(desc)) {
>  				/* Something is busted, give up! */
> @@ -1374,12 +1387,6 @@ static int cdnsp_handle_tx_event(struct cdnsp_device *pdev,
>  			goto cleanup;
>  		}
>  
> -		ep_trb = &ep_seg->trbs[(ep_trb_dma - ep_seg->dma)
> -				       / sizeof(*ep_trb)];
> -
> -		trace_cdnsp_handle_transfer(ep_ring,
> -					    (struct cdnsp_generic_trb *)ep_trb);
> -
>  		if (cdnsp_trb_is_noop(ep_trb))
>  			goto cleanup;
>  
> @@ -1726,11 +1733,6 @@ static unsigned int count_sg_trbs_needed(struct cdnsp_request *preq)
>  	return num_trbs;
>  }
>  
> -static unsigned int count_isoc_trbs_needed(struct cdnsp_request *preq)
> -{
> -	return cdnsp_count_trbs(preq->request.dma, preq->request.length);
> -}
> -
>  static void cdnsp_check_trb_math(struct cdnsp_request *preq, int running_total)
>  {
>  	if (running_total != preq->request.length)
> @@ -2192,28 +2194,48 @@ static unsigned int
>  }
>  
>  /* Queue function isoc transfer */
> -static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
> -			       struct cdnsp_request *preq)
> +int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
> +			struct cdnsp_request *preq)
>  {
> -	int trb_buff_len, td_len, td_remain_len, ret;
> +	unsigned int trb_buff_len, td_len, td_remain_len, block_len;
>  	unsigned int burst_count, last_burst_pkt;
>  	unsigned int total_pkt_count, max_pkt;
>  	struct cdnsp_generic_trb *start_trb;
> +	struct scatterlist *sg = NULL;
>  	bool more_trbs_coming = true;
>  	struct cdnsp_ring *ep_ring;
> +	unsigned int num_sgs = 0;
>  	int running_total = 0;
>  	u32 field, length_field;
> +	u64 addr, send_addr;
>  	int start_cycle;
>  	int trbs_per_td;
> -	u64 addr;
> -	int i;
> +	int i, sent_len, ret;
>  
>  	ep_ring = preq->pep->ring;
> +
> +	td_len = preq->request.length;
> +
> +	if (preq->request.num_sgs) {
> +		num_sgs = preq->request.num_sgs;
> +		sg = preq->request.sg;
> +		addr = (u64)sg_dma_address(sg);
> +		block_len = sg_dma_len(sg);
> +		trbs_per_td = count_sg_trbs_needed(preq);
> +	} else {
> +		addr = (u64)preq->request.dma;
> +		block_len = td_len;
> +		trbs_per_td = count_trbs_needed(preq);
> +	}
> +
> +	ret = cdnsp_prepare_transfer(pdev, preq, trbs_per_td);
> +	if (ret)
> +		return ret;
> +
>  	start_trb = &ep_ring->enqueue->generic;
>  	start_cycle = ep_ring->cycle_state;
> -	td_len = preq->request.length;
> -	addr = (u64)preq->request.dma;
>  	td_remain_len = td_len;
> +	send_addr = addr;
>  
>  	max_pkt = usb_endpoint_maxp(preq->pep->endpoint.desc);
>  	total_pkt_count = DIV_ROUND_UP(td_len, max_pkt);
> @@ -2225,11 +2247,6 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
>  	burst_count = cdnsp_get_burst_count(pdev, preq, total_pkt_count);
>  	last_burst_pkt = cdnsp_get_last_burst_packet_count(pdev, preq,
>  							   total_pkt_count);
> -	trbs_per_td = count_isoc_trbs_needed(preq);
> -
> -	ret = cdnsp_prepare_transfer(pdev, preq, trbs_per_td);
> -	if (ret)
> -		goto cleanup;
>  
>  	/*
>  	 * Set isoc specific data for the first TRB in a TD.
> @@ -2248,6 +2265,7 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
>  
>  		/* Calculate TRB length. */
>  		trb_buff_len = TRB_BUFF_LEN_UP_TO_BOUNDARY(addr);
> +		trb_buff_len = min(trb_buff_len, block_len);
>  		if (trb_buff_len > td_remain_len)
>  			trb_buff_len = td_remain_len;
>  
> @@ -2256,7 +2274,8 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
>  					       trb_buff_len, td_len, preq,
>  					       more_trbs_coming, 0);
>  
> -		length_field = TRB_LEN(trb_buff_len) | TRB_INTR_TARGET(0);
> +		length_field = TRB_LEN(trb_buff_len) | TRB_TD_SIZE(remainder) |
> +			TRB_INTR_TARGET(0);
>  
>  		/* Only first TRB is isoc, overwrite otherwise. */
>  		if (i) {
> @@ -2281,12 +2300,27 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
>  		}
>  
>  		cdnsp_queue_trb(pdev, ep_ring, more_trbs_coming,
> -				lower_32_bits(addr), upper_32_bits(addr),
> +				lower_32_bits(send_addr), upper_32_bits(send_addr),
>  				length_field, field);
>  
>  		running_total += trb_buff_len;
>  		addr += trb_buff_len;
>  		td_remain_len -= trb_buff_len;
> +
> +		sent_len = trb_buff_len;
> +		while (sg && sent_len >= block_len) {
> +			/* New sg entry */
> +			--num_sgs;
> +			sent_len -= block_len;
> +			if (num_sgs != 0) {
> +				sg = sg_next(sg);
> +				block_len = sg_dma_len(sg);
> +				addr = (u64)sg_dma_address(sg);
> +				addr += sent_len;
> +			}
> +		}
> +		block_len -= sent_len;
> +		send_addr = addr;
>  	}
>  
>  	/* Check TD length */
> @@ -2324,30 +2358,6 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
>  	return ret;
>  }
>  
> -int cdnsp_queue_isoc_tx_prepare(struct cdnsp_device *pdev,
> -				struct cdnsp_request *preq)
> -{
> -	struct cdnsp_ring *ep_ring;
> -	u32 ep_state;
> -	int num_trbs;
> -	int ret;
> -
> -	ep_ring = preq->pep->ring;
> -	ep_state = GET_EP_CTX_STATE(preq->pep->out_ctx);
> -	num_trbs = count_isoc_trbs_needed(preq);
> -
> -	/*
> -	 * Check the ring to guarantee there is enough room for the whole
> -	 * request. Do not insert any td of the USB Request to the ring if the
> -	 * check failed.
> -	 */
> -	ret = cdnsp_prepare_ring(pdev, ep_ring, ep_state, num_trbs, GFP_ATOMIC);
> -	if (ret)
> -		return ret;
> -
> -	return cdnsp_queue_isoc_tx(pdev, preq);
> -}
> -
>  /****		Command Ring Operations		****/
>  /*
>   * Generic function for queuing a command TRB on the command ring.
> -- 
> 2.25.1
> 

-- 

Thanks,
Peter Chen
