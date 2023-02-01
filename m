Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64B368609F
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 08:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjBAHcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 02:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjBAHcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 02:32:18 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A405F3B3DD;
        Tue, 31 Jan 2023 23:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675236737; x=1706772737;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=WJdQDU6eYutrslnH2q1zwP0EX/AmFfykvUUq2z/VDt0=;
  b=LUQDvIvcWa96TD+G82PBZB2/q+ZZpMAQmUy22TJu8Ex6elxKZkDUR+zE
   Q/fnxBWbGURpfpcAaGKK50D8fLVS0CC2W0z/okrwPz9JU83bHBP0ng35g
   m6Hwqu2pSBxKMFRxub3YRs7CkGHOl6qOUiBpvHco17k5waAINZTsd9Fnc
   H6rQneOqIHMfBy4kCvKLLOEoQEI/TgRowd/DQS9viKVNBps26QPC4qVYC
   9X7pQHjzuzB0ckd1iKbKcoJK11yISAUVvvjXIi2GcT6N/f2pGY6pWBxwp
   /rmyagypwVIyND6SomObG4BnRqjprgIJBsj7bt0raVilfSWUkghv7ZnE2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="329369102"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="329369102"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 23:32:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="807465249"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="807465249"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 31 Jan 2023 23:32:13 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Wed, 01 Feb 2023 09:32:12 +0200
Date:   Wed, 1 Feb 2023 09:32:12 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gilles BULOZ <gilles.buloz@kontron.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] serial: 8250_dma: Fix DMA Rx rearm race
Message-ID: <Y9oVfAmJpJfDSP1+@kuha.fi.intel.com>
References: <20230130114841.25749-1-ilpo.jarvinen@linux.intel.com>
 <20230130114841.25749-3-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230130114841.25749-3-ilpo.jarvinen@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 30, 2023 at 01:48:41PM +0200, Ilpo Järvinen wrote:
> As DMA Rx can be completed from two places, it is possible that DMA Rx
> completes before DMA completion callback had a chance to complete it.
> Once the previous DMA Rx has been completed, a new one can be started
> on the next UART interrupt. The following race is possible
> (uart_unlock_and_check_sysrq_irqrestore() replaced with
> spin_unlock_irqrestore() for simplicity/clarity):
> 
> CPU0					CPU1
> 					dma_rx_complete()
> serial8250_handle_irq()
>   spin_lock_irqsave(&port->lock)
>   handle_rx_dma()
>     serial8250_rx_dma_flush()
>       __dma_rx_complete()
>         dma->rx_running = 0
>         // Complete DMA Rx
>   spin_unlock_irqrestore(&port->lock)
> 
> serial8250_handle_irq()
>   spin_lock_irqsave(&port->lock)
>   handle_rx_dma()
>     serial8250_rx_dma()
>       dma->rx_running = 1
>       // Setup a new DMA Rx
>   spin_unlock_irqrestore(&port->lock)
> 
> 					  spin_lock_irqsave(&port->lock)
> 					  // sees dma->rx_running = 1
> 					  __dma_rx_complete()
> 					    dma->rx_running = 0
> 					    // Incorrectly complete
> 					    // running DMA Rx
> 
> This race seems somewhat theoretical to occur for real but handle it
> correctly regardless. Check what is the DMA status before complething
> anything in __dma_rx_complete().
> 
> Reported-by: Gilles BULOZ <gilles.buloz@kontron.com>
> Tested-by: Gilles BULOZ <gilles.buloz@kontron.com>
> Fixes: 9ee4b83e51f7 ("serial: 8250: Add support for dmaengine")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/tty/serial/8250/8250_dma.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
> index 5594883a96f8..7fa66501792d 100644
> --- a/drivers/tty/serial/8250/8250_dma.c
> +++ b/drivers/tty/serial/8250/8250_dma.c
> @@ -43,15 +43,23 @@ static void __dma_rx_complete(struct uart_8250_port *p)
>  	struct uart_8250_dma	*dma = p->dma;
>  	struct tty_port		*tty_port = &p->port.state->port;
>  	struct dma_tx_state	state;
> +	enum dma_status		dma_status;
>  	int			count;
>  
> -	dma->rx_running = 0;
> -	dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
> +	/*
> +	 * New DMA Rx can be started during the completion handler before it
> +	 * could acquire port's lock and it might still be ongoing. Don't to
> +	 * anything in such case.
> +	 */
> +	dma_status = dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
> +	if (dma_status == DMA_IN_PROGRESS)
> +		return;
>  
>  	count = dma->rx_size - state.residue;
>  
>  	tty_insert_flip_string(tty_port, dma->rx_buf, count);
>  	p->port.icount.rx += count;
> +	dma->rx_running = 0;
>  
>  	tty_flip_buffer_push(tty_port);
>  }
> -- 
> 2.30.2

-- 
heikki
