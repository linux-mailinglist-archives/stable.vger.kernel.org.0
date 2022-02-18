Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 694994BB490
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 09:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiBRIrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 03:47:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbiBRIrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 03:47:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C882A070F
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 00:47:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF60FB820E1
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 08:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F166AC340E9;
        Fri, 18 Feb 2022 08:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645174020;
        bh=wJWJQ4uK5WlEzf0FuFCGdYq5OdVJTDtsepSsco2Zqa0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bmz9OIq1eWceAxb+QXFmZ2zv4AnFOjFBTAL5/94sknhPP4qdZdLJbLX0QRrMakRZt
         pNHU+MF7wG/Qo/T/DHTuqDy4Qw6MV2mQtTO1NJSJVnARszzCseskSKccvjFLq1Y+zf
         afEMqR9cWsfG8nf4yXz38btl1DlL2axrvCWayx60=
Date:   Fri, 18 Feb 2022 09:46:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mickael GARDET <m.gardet@overkiz.com>
Cc:     stable@vger.kernel.org,
        =?iso-8859-1?Q?K=E9vin?= Raymond <k.raymond@overkiz.com>,
        Tudor.Ambarus@microchip.com
Subject: Re: Atmel UART with dma enabled does not work on branch 5.4.Y from
 version 5.4.174.
Message-ID: <Yg9dAZI3hSbD9Epl@kroah.com>
References: <b8147153-5bcc-8a6d-7aac-5c0abbd43379@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8147153-5bcc-8a6d-7aac-5c0abbd43379@overkiz.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 09:40:55AM +0100, Mickael GARDET wrote:
> Hi,
> 
> we observed a regression on our atmel platforms on branch 5.4.Y from version
> 5.4.174.
> uarts are no longer functional if DMA is enabled.
> 
> the following patch
> Commit e6af9b05bec63cd4d1de2a33968cd0be2a91282a dmaengine: at_xdmac: Start
> transfer for cyclic channels in issue_pending
> Link:
> https://lore.kernel.org/r/20211215110115.191749-3-tudor.ambarus@microchip.com
> has not been backported but is needed if the patch
> Commit 4f4b9b5895614eb2e2b5f4cab7858f44bd113e1b tty: serial: atmel: Call
> dma_async_issue_pending()
> Link:
> https://lore.kernel.org/r/20211125090028.786832-4-tudor.ambarus@microchip.com
> is applied.
> 
> enclosed commit fix this issue and work for me.
> 
> Best regards,
> Mickael GARDET
> 
> From 9877f93c066be8c2f4e33a6edd4dfa3d6d6974d9 Mon Sep 17 00:00:00 2001
> From: Tudor Ambarus <tudor.ambarus@microchip.com>
> Date: Wed, 15 Dec 2021 13:01:05 +0200
> Subject: [PATCH] dmaengine: at_xdmac: Start transfer for cyclic channels in
> issue_pending
> 
> commit e6af9b05bec63cd4d1de2a33968cd0be2a91282a upstream.
> 
> Cyclic channels must too call issue_pending in order to start a transfer.
> Start the transfer in issue_pending regardless of the type of channel.
> This wrongly worked before, because in the past the transfer was started
> at tx_submit level when only a desc in the transfer list.
> 
> Fixes: e1f7c9eee707 ("dmaengine: at_xdmac: creation of the atmel eXtended
> DMA Controller driver")
> Change-Id: If1bf3e13329cebb9904ae40620f6cf2b7f06fe9f
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> Link:
> https://lore.kernel.org/r/20211215110115.191749-3-tudor.ambarus@microchip.com
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> ---
> drivers/dma/at_xdmac.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
> index f63d141481a3..9aae6b3da356 100644
> --- a/drivers/dma/at_xdmac.c
> +++ b/drivers/dma/at_xdmac.c
> @@ -1726,11 +1726,13 @@ static irqreturn_t at_xdmac_interrupt(int irq,
> void *dev_id)
> static void at_xdmac_issue_pending(struct dma_chan *chan)
> {
> struct at_xdmac_chan *atchan = to_at_xdmac_chan(chan);
> +    unsigned long flags;
> 
> dev_dbg(chan2dev(&atchan->chan), "%s\n", __func__);
> 
> -    if (!at_xdmac_chan_is_cyclic(atchan))
> -        at_xdmac_advance_work(atchan);
> +    spin_lock_irqsave(&atchan->lock, flags);
> +    at_xdmac_advance_work(atchan);
> +    spin_unlock_irqrestore(&atchan->lock, flags);
> 
> return;
> }
> 
> base-commit: 7b3eb66d0daf61e91cccdb2fe5d271ae5adc5a76
> 
> -- 
> 2.35.1
> 

The patch is whitespace damaged and can not be applied at all :(

Can you try fixing your email client up, or worst case, attach the
patch, and we can take it from there?

Also be sure to sign-off on the patch, as you have modified it to work
properly on this branch.

thanks,

greg k-h
