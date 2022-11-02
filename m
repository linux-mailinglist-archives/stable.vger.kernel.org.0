Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6355615711
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 02:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiKBBmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 21:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKBBmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 21:42:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD4FA1A6;
        Tue,  1 Nov 2022 18:42:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C9B6617A4;
        Wed,  2 Nov 2022 01:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E20C433C1;
        Wed,  2 Nov 2022 01:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667353322;
        bh=+h1ieg0MXUfvfUIKkeABzyYb/mRio7rObzvwsIHvRxM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QlZSjY+2wD76srEmnhL0/72Yobksx/MLezni/gHkvO+gqVIsp1U3TixAvlE4DdJWh
         cJNw2dDKrB+8Xo3S8cXUKkUpZ74qmDBHXFjFbftuHxXoT769EE36gDrQEe5yI3sLCp
         BpSDY09eaLsNuZhipJcDofG2oBqa8wKtfgpmwFOo=
Date:   Wed, 2 Nov 2022 02:42:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc:     Lukas Wunner <lukas@wunner.de>, stable@vger.kernel.org,
        Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Roosen Henri <Henri.Roosen@ginzinger.com>,
        linux-serial@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Daisuke Mizobuchi <mizo@atmark-techno.com>
Subject: Re: [PATCH 5.15 2/2] serial: Deassert Transmit Enable on probe in
 driver-specific way
Message-ID: <Y2HLIAoUYQt+okYw@kroah.com>
References: <20221027001943.637449-1-dominique.martinet@atmark-techno.com>
 <20221027001943.637449-2-dominique.martinet@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221027001943.637449-2-dominique.martinet@atmark-techno.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 09:19:43AM +0900, Dominique Martinet wrote:
> From: Lukas Wunner <lukas@wunner.de>
> 
> When a UART port is newly registered, uart_configure_port() seeks to
> deassert RS485 Transmit Enable by setting the RTS bit in port->mctrl.
> However a number of UART drivers interpret a set RTS bit as *assertion*
> instead of deassertion:  Affected drivers include those using
> serial8250_em485_config() (except 8250_bcm2835aux.c) and some using
> mctrl_gpio (e.g. imx.c).
> 
> Since the interpretation of the RTS bit is driver-specific, it is not
> suitable as a means to centrally deassert Transmit Enable in the serial
> core.  Instead, the serial core must call on drivers to deassert it in
> their driver-specific way.  One way to achieve that is to call
> ->rs485_config().  It implicitly deasserts Transmit Enable.
> 
> So amend uart_configure_port() and uart_resume_port() to invoke
> uart_rs485_config().  That allows removing calls to uart_rs485_config()
> from drivers' ->probe() hooks and declaring the function static.
> 
> Skip any invocation of ->set_mctrl() if RS485 is enabled.  RS485 has no
> hardware flow control, so the modem control lines are irrelevant and
> need not be touched.  When leaving RS485 mode, reset the modem control
> lines to the state stored in port->mctrl.  That way, UARTs which are
> muxed between RS485 and RS232 transceivers drive the lines correctly
> when switched to RS232.  (serial8250_do_startup() historically raises
> the OUT1 modem signal because otherwise interrupts are not signaled on
> ancient PC UARTs, but I believe that no longer applies to modern,
> RS485-capable UARTs and is thus safe to be skipped.)
> 
> imx.c modifies port->mctrl whenever Transmit Enable is asserted and
> deasserted.  Stop it from doing that so port->mctrl reflects the RS232
> line state.
> 
> 8250_omap.c deasserts Transmit Enable on ->runtime_resume() by calling
> ->set_mctrl().  Because that is now a no-op in RS485 mode, amend the
> function to call serial8250_em485_stop_tx().
> 
> fsl_lpuart.c retrieves and applies the RS485 device tree properties
> after registering the UART port.  Because applying now happens on
> registration in uart_configure_port(), move retrieval of the properties
> ahead of uart_add_one_port().
> 
> [ Upstream commit 7c7f9bc986e698873b489c371a08f206979d06b7 ]
> Link: https://lkml.kernel.org/r/20221017051737.51727-2-dominique.martinet@atmark-techno.com
> Link: https://lore.kernel.org/all/20220329085050.311408-1-matthias.schiffer@ew.tq-group.com/
> Link: https://lore.kernel.org/all/8f538a8903795f22f9acc94a9a31b03c9c4ccacb.camel@ginzinger.com/
> Fixes: d3b3404df318 ("serial: Fix incorrect rs485 polarity on uart open")
> Cc: stable@vger.kernel.org # v4.14+
> Reported-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> Reported-by: Roosen Henri <Henri.Roosen@ginzinger.com>
> Tested-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Link: https://lore.kernel.org/r/2de36eba3fbe11278d5002e4e501afe0ceaca039.1663863805.git.lukas@wunner.de
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Daisuke Mizobuchi <mizo@atmark-techno.com>
> Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
> ---
> 
> 5.15 version of the 5.10 patch:
> https://lkml.kernel.org/r/20221017051737.51727-2-dominique.martinet@atmark-techno.com
> (only build tested)

Both now queued up, thanks.

greg k-h
