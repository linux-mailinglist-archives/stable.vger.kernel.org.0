Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27740633CBE
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 13:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiKVMkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 07:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiKVMkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 07:40:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8882D12D33
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 04:40:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2659D616D2
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 12:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7DCC433C1;
        Tue, 22 Nov 2022 12:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669120830;
        bh=bkll66KHEYpwNEBqnujaNaEs32GiTI3KpcUg8R5SSpY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cYTJl8JK9J3PB0dXG3SOAkEJd0o2fj/7iMnf10U6xfutbYY8zZ5XxB9OdE5flc2A6
         d8u5SDCJfSdqTmnnaPN0aab3FEJo2IvIEPVZPzFQrRbn2muVfSzsb0z0bqmMkV6uWu
         eFF8i/FSThskXWafIHE1jUjtm6GaUoSqTVTmNtg0=
Date:   Tue, 22 Nov 2022 13:40:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH backport to 5.4 and below 1/1] serial: 8250: Flush DMA Rx
 on RLSI
Message-ID: <Y3zDOjgx8LtUMfjj@kroah.com>
References: <1b9ac2f-d4a7-1efd-fb6f-c7f8e014ca19@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b9ac2f-d4a7-1efd-fb6f-c7f8e014ca19@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 21, 2022 at 02:49:25PM +0200, Ilpo Järvinen wrote:
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

Applied to 5.4.y only.  Fails to apply to 4.9.y, 4.14.y, or 4.19.y :(

