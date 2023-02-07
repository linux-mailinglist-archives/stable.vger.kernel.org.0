Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAEBF68D526
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 12:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjBGLIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 06:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjBGLIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 06:08:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EF939BA3
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 03:08:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D726B817F6
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 11:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C34FC433EF;
        Tue,  7 Feb 2023 11:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675768115;
        bh=g5ofmab+hqv3eFt2oiFHw8Em1RRutwDG7pfLjLEqL1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F1oUrqgXfrBNp9/cjsVu/Q+uYe5yvf21rK+5L90mJ7DFXGGvb3pYh8PfNbxwhnxOZ
         G0sLNMSs4YfrW7nrIbQESnx6eOj18InyvN/SRcFiQtydfLLcCk/sN0B5V/8TteYXwe
         /3SX+nbr7zfIB4m2Xb0GxfRehVpfdqR0Mx3QWggU=
Date:   Tue, 7 Feb 2023 12:08:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     stable@vger.kernel.org, Gilles BULOZ <gilles.buloz@kontron.com>
Subject: Re: [PATCH backport to 6.1 1/2] serial: 8250_dma: Fix DMA Rx
 completion race
Message-ID: <Y+IxMTr6afTorhG8@kroah.com>
References: <20230207094717.27197-1-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230207094717.27197-1-ilpo.jarvinen@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 11:47:16AM +0200, Ilpo Järvinen wrote:
> [ Upstream commit 31352811e13dc2313f101b890fd4b1ce760b5fe7 ]
> 
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
> Link: https://lore.kernel.org/r/20230130114841.25749-2-ilpo.jarvinen@linux.intel.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/tty/serial/8250/8250_dma.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)

Thanks, both queued up now.

greg k-h
