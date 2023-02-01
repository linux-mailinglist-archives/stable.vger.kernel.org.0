Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5AA68609C
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 08:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbjBAHbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 02:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjBAHbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 02:31:47 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E3127D56;
        Tue, 31 Jan 2023 23:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675236706; x=1706772706;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=eRiSlPgbw5gdrVkB44EWzW53fRepFsBpI0nB3aDL76o=;
  b=coPPzcHzZtWG53ackoxlIblmZitZMKiV8Sgb7Dl/k7ZFBjmI6ieEc06a
   Lu1Z6l128IrRBnX037TjACsSkayFFwfZT9cwJlSWWEWANZEqrDgP6qx0F
   QRlNbFluwDXyd2oqLcFWb3Qz5GHBvUJslpPY5V3hYd1yGizoAVH61SmIQ
   DzU9wTd60y9gz9+0Lxc8ksy/QaijdhL+RSIp42JYxJoWNGhCLzusFF3B8
   P3Nta1XCPOIYW178mMVwelNL0oliWyZOU2B4Qh7jTYLbN1/Fqu1t87QZF
   6maqjK5thBzX9v3R4Ph6p8+LkixCJXsdKIJTNx4neQS1WjwaFs0IanJb3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="329368987"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="329368987"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 23:31:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="807465084"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="807465084"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 31 Jan 2023 23:31:40 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Wed, 01 Feb 2023 09:31:39 +0200
Date:   Wed, 1 Feb 2023 09:31:39 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gilles BULOZ <gilles.buloz@kontron.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] serial: 8250_dma: Fix DMA Rx completion race
Message-ID: <Y9oVW8J6cFYnqawn@kuha.fi.intel.com>
References: <20230130114841.25749-1-ilpo.jarvinen@linux.intel.com>
 <20230130114841.25749-2-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230130114841.25749-2-ilpo.jarvinen@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 30, 2023 at 01:48:40PM +0200, Ilpo Järvinen wrote:
> __dma_rx_complete() is called from two places:
>   - Through the DMA completion callback dma_rx_complete()
>   - From serial8250_rx_dma_flush() after IIR_RLSI or IIR_RX_TIMEOUT
> The former does not hold port's lock during __dma_rx_complete() which
> allows these two to race and potentially insert the same data twice.
> 
> Extend port's lock coverage in dma_rx_complete() to prevent the race
> and check if the DMA Rx is still pending completion before calling
> into __dma_rx_complete().
> 
> Reported-by: Gilles BULOZ <gilles.buloz@kontron.com>
> Tested-by: Gilles BULOZ <gilles.buloz@kontron.com>
> Fixes: 9ee4b83e51f7 ("serial: 8250: Add support for dmaengine")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

FWIW:

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/tty/serial/8250/8250_dma.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
> index 37d6af2ec427..5594883a96f8 100644
> --- a/drivers/tty/serial/8250/8250_dma.c
> +++ b/drivers/tty/serial/8250/8250_dma.c
> @@ -62,9 +62,14 @@ static void dma_rx_complete(void *param)
>  	struct uart_8250_dma *dma = p->dma;
>  	unsigned long flags;
>  
> -	__dma_rx_complete(p);
> -
>  	spin_lock_irqsave(&p->port.lock, flags);
> +	if (dma->rx_running)
> +		__dma_rx_complete(p);
> +
> +	/*
> +	 * Cannot be combined with the previous check because __dma_rx_complete()
> +	 * changes dma->rx_running.
> +	 */
>  	if (!dma->rx_running && (serial_lsr_in(p) & UART_LSR_DR))
>  		p->dma->rx_dma(p);
>  	spin_unlock_irqrestore(&p->port.lock, flags);
> -- 
> 2.30.2

-- 
heikki
