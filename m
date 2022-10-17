Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69638600625
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 07:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJQFNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 01:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiJQFNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 01:13:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AF352E68;
        Sun, 16 Oct 2022 22:13:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86BCE60F27;
        Mon, 17 Oct 2022 05:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4A1C433C1;
        Mon, 17 Oct 2022 05:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665983591;
        bh=ZqgErE7muddqjbqtbJjD8f13r1lgMR9XHIq4ojJjmSU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=huXSEITc9QD3UANEHESQhhmhyaBjEPjJ2Tdr7HHqBSz6boI6CEtsRkkL2YE5cVdub
         KFUK9MgZt7njqmnNS1o5aPpKUMmREStR2yodsVZvDIDwce1jya4nSnsTUPiTYWxna6
         C81OGPPXbkjffVAO7j9NS1/EUk9kdyPFrAuo6suY=
Date:   Mon, 17 Oct 2022 07:13:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc:     Lukas Wunner <lukas@wunner.de>, stable@vger.kernel.org,
        Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Roosen Henri <Henri.Roosen@ginzinger.com>,
        linux-serial@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Daisuke Mizobuchi <mizo@atmark-techno.com>
Subject: Re: [PATCH 5.10 2/2] serial: Deassert Transmit Enable on probe in
 driver-specific way
Message-ID: <Y0zklpPzrpG2i7Cm@kroah.com>
References: <20221017013807.34614-1-dominique.martinet@atmark-techno.com>
 <20221017013908.34770-2-dominique.martinet@atmark-techno.com>
 <Y0y2pPwf2yxA2tQe@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0y2pPwf2yxA2tQe@atmark-techno.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 10:57:56AM +0900, Dominique Martinet wrote:
> Dominique Martinet wrote on Mon, Oct 17, 2022 at 10:39:10AM +0900:
> > diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
> > index a2c4eab0b470..5ca61fa50efd 100644
> > --- a/drivers/tty/serial/fsl_lpuart.c
> > +++ b/drivers/tty/serial/fsl_lpuart.c
> > @@ -2667,10 +2667,6 @@ static int lpuart_probe(struct platform_device *pdev)
> >  	if (ret)
> >  		goto failed_irq_request;
> >  
> > -	ret = uart_add_one_port(&lpuart_reg, &sport->port);
> > -	if (ret)
> > -		goto failed_attach_port;
> > -
> >  	ret = uart_get_rs485_mode(&sport->port);
> >  	if (ret)
> >  		goto failed_get_rs485;
> > @@ -2683,6 +2679,9 @@ static int lpuart_probe(struct platform_device *pdev)
> >  		dev_err(&pdev->dev, "driver doesn't support RTS delays\n");
> >  
> >  	sport->port.rs485_config(&sport->port, &sport->port.rs485);
> 
> Ah, I've been quick on the review, sorry: this rs485_config() should
> probably be removed.
> (the similar uart_rs485_config() was removed in the upstream patch)
> 
> I'll send a v2 after this has gotten another review or when prompted,
> sorry for the trouble.

Please fix up and resend a v2.

thanks,

greg k-h
