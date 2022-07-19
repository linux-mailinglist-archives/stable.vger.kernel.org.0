Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4006857979B
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 12:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiGSKZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 06:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbiGSKZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 06:25:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAB965FB;
        Tue, 19 Jul 2022 03:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658226338; x=1689762338;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=o4UkXWVncsf5NlHgJbAtNT6K7mnE/rm+QaA7Sbcg8tQ=;
  b=LPQkGTDw46RRtLWeE/PbBQ3zj1PV92d57h69jjlGtCyDx3G7N7ZDHWqe
   9O6XKIyfOTmYRRMrOhvPSCP78DR7X9eldUl7FpOpZtishuaXbFJqCW0ZU
   4SFTZmCnsy+Dzsye6IQvde6gWV3uceEwF9WnOjpK7Jl99UsEXkZ/8WfHl
   JMAtR4g2Q741l+nL4nqu3gY71+m4PWTm6eu//ewXnkjd5AoEk+L8/KfEG
   UWAvKl8tue+cm1g4DHAAf0l/rIBZhHgvkzmwl5lCmYLiZ7R3gXHQ8OIDE
   ddS/uG2PuyDA/EGZhQNLAsNs0qWUdiP+3gc4V1mF+9q/qMieDougWjJcd
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="266856253"
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="266856253"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 03:25:38 -0700
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="655700133"
Received: from gegelmee-mobl1.ger.corp.intel.com ([10.252.42.45])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 03:25:36 -0700
Date:   Tue, 19 Jul 2022 13:25:34 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH V2 1/1] serial: fsl_lpuart: zero out parity bit in CS7
 mode
In-Reply-To: <20220714185858.615373-1-shenwei.wang@nxp.com>
Message-ID: <bf982c0-403c-1677-b8a-5098f7e85b82@linux.intel.com>
References: <20220714185858.615373-1-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Jul 2022, Shenwei Wang wrote:

> The LPUART hardware doesn't zero out the parity bit on the received
> characters. This behavior won't impact the use cases of CS8 because
> the parity bit is the 9th bit which is not currently used by software.
> But the parity bit for CS7 must be zeroed out by software in order to
> get the correct raw data.

This problem only occurs with the lpuart32 variant? Or should the other 
functions be changed as well?

-- 
 i.


> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> ---
> changes in v2
> - remove the "inline" keyword from the function of lpuart_tty_insert_flip_string;
> 
> changes in v1
> - fix the code indent and whitespace issue;
> 
>  drivers/tty/serial/fsl_lpuart.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
> index fc7d235a1e270..afa0f941c862f 100644
> --- a/drivers/tty/serial/fsl_lpuart.c
> +++ b/drivers/tty/serial/fsl_lpuart.c
> @@ -274,6 +274,8 @@ struct lpuart_port {
>  	int			rx_dma_rng_buf_len;
>  	unsigned int		dma_tx_nents;
>  	wait_queue_head_t	dma_wait;
> +	bool			is_cs7; /* Set to true when character size is 7 */
> +					/* and the parity is enabled		*/
>  };
> 
>  struct lpuart_soc_data {
> @@ -1022,6 +1024,9 @@ static void lpuart32_rxint(struct lpuart_port *sport)
>  				flg = TTY_OVERRUN;
>  		}
> 
> +		if (sport->is_cs7)
> +			rx &= 0x7F;
> +
>  		if (tty_insert_flip_char(port, rx, flg) == 0)
>  			sport->port.icount.buf_overrun++;
>  	}
> @@ -1107,6 +1112,17 @@ static void lpuart_handle_sysrq(struct lpuart_port *sport)
>  	}
>  }
> 
> +static int lpuart_tty_insert_flip_string(struct tty_port *port,
> +	unsigned char *chars, size_t size, bool is_cs7)
> +{
> +	int i;
> +
> +	if (is_cs7)
> +		for (i = 0; i < size; i++)
> +			chars[i] &= 0x7F;
> +	return tty_insert_flip_string(port, chars, size);
> +}
> +
>  static void lpuart_copy_rx_to_tty(struct lpuart_port *sport)
>  {
>  	struct tty_port *port = &sport->port.state->port;
> @@ -1217,7 +1233,8 @@ static void lpuart_copy_rx_to_tty(struct lpuart_port *sport)
>  	if (ring->head < ring->tail) {
>  		count = sport->rx_sgl.length - ring->tail;
> 
> -		copied = tty_insert_flip_string(port, ring->buf + ring->tail, count);
> +		copied = lpuart_tty_insert_flip_string(port, ring->buf + ring->tail,
> +					count, sport->is_cs7);
>  		if (copied != count)
>  			sport->port.icount.buf_overrun++;
>  		ring->tail = 0;
> @@ -1227,7 +1244,8 @@ static void lpuart_copy_rx_to_tty(struct lpuart_port *sport)
>  	/* Finally we read data from tail to head */
>  	if (ring->tail < ring->head) {
>  		count = ring->head - ring->tail;
> -		copied = tty_insert_flip_string(port, ring->buf + ring->tail, count);
> +		copied = lpuart_tty_insert_flip_string(port, ring->buf + ring->tail,
> +					count, sport->is_cs7);
>  		if (copied != count)
>  			sport->port.icount.buf_overrun++;
>  		/* Wrap ring->head if needed */
> @@ -2066,6 +2084,7 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
>  	ctrl = old_ctrl = lpuart32_read(&sport->port, UARTCTRL);
>  	bd = lpuart32_read(&sport->port, UARTBAUD);
>  	modem = lpuart32_read(&sport->port, UARTMODIR);
> +	sport->is_cs7 = false;
>  	/*
>  	 * only support CS8 and CS7, and for CS7 must enable PE.
>  	 * supported mode:
> @@ -2184,6 +2203,9 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
>  	lpuart32_write(&sport->port, ctrl, UARTCTRL);
>  	/* restore control register */
> 
> +	if ((ctrl & (UARTCTRL_PE | UARTCTRL_M)) == UARTCTRL_PE)
> +		sport->is_cs7 = true;
> +
>  	if (old && sport->lpuart_dma_rx_use) {
>  		if (!lpuart_start_rx_dma(sport))
>  			rx_dma_timer_init(sport);
> --
> 2.25.1
> 
