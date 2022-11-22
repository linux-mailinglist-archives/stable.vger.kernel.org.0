Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFDC634039
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 16:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiKVPe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 10:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKVPe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 10:34:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EE4682B7
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 07:34:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FE1E6175E
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 15:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721BFC433C1;
        Tue, 22 Nov 2022 15:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669131295;
        bh=xHcmQ07Uz72BL9Ngkbtqa6FZhbdDPBBU1byiLpXt5XQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b8TwMMHG+WCuiSXWC4m+IgpkZvCtiBuSRbz7zxPzj5ZIytlRMSfSXjBdFf561F0iu
         Wk9UpvwJUXqrN2GIhPRXxEPiM8xsUCGItrX7wHt84PoVqOsjFYATRI56rKQirVo7BD
         EgtLLofpr/Em2/QlWGYymFaM2L5UG2GT7si0+ttQ=
Date:   Tue, 22 Nov 2022 16:34:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH backport to 4.19 and below 1/1] serial: 8250: Flush DMA
 Rx on RLSI
Message-ID: <Y3zsHfjEUKZNEHqf@kroah.com>
References: <1b9ac2f-d4a7-1efd-fb6f-c7f8e014ca19@linux.intel.com>
 <Y3zDOjgx8LtUMfjj@kroah.com>
 <6b75c9c-7ccf-435a-4247-62e2a08a6ea@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6b75c9c-7ccf-435a-4247-62e2a08a6ea@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 22, 2022 at 03:14:10PM +0200, Ilpo Järvinen wrote:
> commit 1980860e0c8299316cddaf0992dd9e1258ec9d88 upstream.
> 
> Returning true from handle_rx_dma() without flushing DMA first creates
> a data ordering hazard. If DMA Rx has handled any character at the
> point when RLSI occurs, the non-DMA path handles any pending characters
> jumping them ahead of those characters that are pending under DMA.
> 
> Fixes: 75df022b5f89 ("serial: 8250_dma: Fix RX handling")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Link: https://lore.kernel.org/r/20221108121952.5497-5-ilpo.jarvinen@linux.intel.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/tty/serial/8250/8250_port.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
> index cab3a74281ef..8aee43fe488a 100644
> --- a/drivers/tty/serial/8250/8250_port.c
> +++ b/drivers/tty/serial/8250/8250_port.c
> @@ -1802,10 +1802,9 @@ static bool handle_rx_dma(struct uart_8250_port *up, unsigned int iir)
>  		if (!up->dma->rx_running)
>  			break;
>  		/* fall-through */
> +	case UART_IIR_RLSI:
>  	case UART_IIR_RX_TIMEOUT:
>  		serial8250_rx_dma_flush(up);
> -		/* fall-through */
> -	case UART_IIR_RLSI:
>  		return true;
>  	}
>  	return up->dma->rx_dma(up);
> -- 
> 2.30.2


Now queued up, thanks.

greg k-h
