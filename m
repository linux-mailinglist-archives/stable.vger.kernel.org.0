Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48404F227B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 07:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiDEFPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 01:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiDEFPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 01:15:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C1910D7;
        Mon,  4 Apr 2022 22:13:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CFCD614A9;
        Tue,  5 Apr 2022 05:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F124C340F0;
        Tue,  5 Apr 2022 05:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649135610;
        bh=gzBnPQhgt7hKdTf+skwtyiSuTPfPsygMmBGkkzjl02o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LtInykM4PT/T21Q97BXJfPBdC/cYlhZRnM+yGFuxt86EtQAOFjPy1zJtZvnhJ3UdR
         i68LDLHlBy7kYKzax0rnp3ECdoBSoJ+IMS1CcRZEZ8z8+Wt8gINPoEuXlE4YuPgJLa
         xf4XetFuFvPjCifsUH9wtFjjkYtItUikcfPN7eIw=
Date:   Tue, 5 Apr 2022 07:13:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, stable@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: Re: [PATCH] can: m_can: m_can_tx_handler(): fix use after free of skb
Message-ID: <YkvP+JrdkTVAkQ2n@kroah.com>
References: <20220404190830.1241263-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404190830.1241263-1-mkl@pengutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 04, 2022 at 09:08:30PM +0200, Marc Kleine-Budde wrote:
> commit 2e8e79c416aae1de224c0f1860f2e3350fa171f8 upstream.
> 
> can_put_echo_skb() will clone skb then free the skb. Move the
> can_put_echo_skb() for the m_can version 3.0.x directly before the
> start of the xmit in hardware, similar to the 3.1.x branch.
> 
> Fixes: 80646733f11c ("can: m_can: update to support CAN FD features")
> Link: https://lore.kernel.org/all/20220317081305.739554-1-mkl@pengutronix.de
> Cc: stable@vger.kernel.org
> Reported-by: Hangyu Hua <hbh25y@gmail.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
> Hello Greg, hello Sasha,
> 
> This is
> 
> | 2e8e79c416aa can: m_can: m_can_tx_handler(): fix use after free of skb
> 
> ported to v5.10.109.
> 
> regards,
> Marc
> 
>  drivers/net/can/m_can/m_can.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 19a7e4adb933..52386460fe92 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1491,8 +1491,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
>  					 M_CAN_FIFO_DATA(i / 4),
>  					 *(u32 *)(cf->data + i));
>  
> -		can_put_echo_skb(skb, dev, 0);
> -
>  		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD) {
>  			cccr = m_can_read(cdev, M_CAN_CCCR);
>  			cccr &= ~(CCCR_CMR_MASK << CCCR_CMR_SHIFT);
> @@ -1509,6 +1507,9 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
>  			m_can_write(cdev, M_CAN_CCCR, cccr);
>  		}
>  		m_can_write(cdev, M_CAN_TXBTIE, 0x1);
> +
> +		can_put_echo_skb(skb, dev, 0, 0);

You didn't build this patch :(

I'll go fix this by hand...

greg k-h
