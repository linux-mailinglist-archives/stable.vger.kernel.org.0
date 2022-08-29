Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07765A40F5
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 04:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiH2CMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Aug 2022 22:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiH2CME (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Aug 2022 22:12:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420A03C8E6;
        Sun, 28 Aug 2022 19:12:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8974A60F5B;
        Mon, 29 Aug 2022 02:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB54C433D6;
        Mon, 29 Aug 2022 02:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661739102;
        bh=iPHpnFFFhEmExAFu6fo9NAw9+JDwOLa2mLzrei/+1AI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OeufEYILgSZ9+rs45WPuApZezIEsAyC0p8mdj9GRb2hq5fNUMcnjTZlfbghEJ9tMm
         EO7RTDUs6fLCaHljlaNO5n6WdRxpE1l7UtRgk9pSQ7+JxkdQp3WOzE5T0PBUQzoOmR
         WAYX+PVoAm53EEReLyPGvZODE79z2YXl7r0wHAJOOE8uYw9FAsla12+yCWb6Da44IC
         zkw9PKkNGMvJzP7KPdrLOZlRHKquvYJE+ym+Ei/V18bsHMK+Hoqng3vjMnq+JfDdaD
         IiOmGWOuI00ZtdhvIB9CpWfIbZJhc6FsWqkdwi5Xl9jYXdIm0ZUeHbixYaxnS5bfEX
         /4M7haMnzoiJg==
Date:   Mon, 29 Aug 2022 10:11:35 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        felipe.balbi@linux.intel.com, rogerq@kernel.org,
        a-govindraju@ti.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdns3: fix issue with rearming ISO OUT endpoint
Message-ID: <20220829021135.GA32228@nchen-desktop>
References: <20220825062137.5766-1-pawell@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825062137.5766-1-pawell@cadence.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22-08-25 08:21:37, Pawel Laszczak wrote:
> ISO OUT endpoint is enabled during queuing first usb request
> in transfer ring and disabled when TRBERR is reported by controller.
> After TRBERR and before next transfer added to TR driver must again
> reenable endpoint but does not.
> To solve this issue during processing TRBERR event driver must
> set the flag EP_UPDATE_EP_TRBADDR in priv_ep->flags field.
> 
> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> cc: <stable@vger.kernel.org>
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>

Acked-by: Peter Chen <peter.chen@kernel.org>

> ---
>  drivers/usb/cdns3/cdns3-gadget.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
> index 682ceba25765..fa8263951e63 100644
> --- a/drivers/usb/cdns3/cdns3-gadget.c
> +++ b/drivers/usb/cdns3/cdns3-gadget.c
> @@ -1689,6 +1689,7 @@ static int cdns3_check_ep_interrupt_proceed(struct cdns3_endpoint *priv_ep)
>  				ep_cfg &= ~EP_CFG_ENABLE;
>  				writel(ep_cfg, &priv_dev->regs->ep_cfg);
>  				priv_ep->flags &= ~EP_QUIRK_ISO_OUT_EN;
> +				priv_ep->flags |= EP_UPDATE_EP_TRBADDR;
>  			}
>  			cdns3_transfer_completed(priv_dev, priv_ep);
>  		} else if (!(priv_ep->flags & EP_STALLED) &&
> -- 
> 2.25.1
> 

-- 

Thanks,
Peter Chen
