Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D72F5F986F
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 08:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiJJGh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 02:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiJJGhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 02:37:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0382C133;
        Sun,  9 Oct 2022 23:37:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69FE960E06;
        Mon, 10 Oct 2022 06:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE1AC433C1;
        Mon, 10 Oct 2022 06:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665383843;
        bh=f7TUwhED30rYlN8Zh9xxNfX8TQGwIH1NDESbnSqlL4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FHweNmEEUxR18sM1vvImRlo6Wc9+tYX3pTSfWlhx4cGk6LMZ+LdZRf72xxWO7Lrqx
         Ba6d2YDNfSr1F2BREUrQRUzp6YwqsWsfRxinPN/MKktImwtZo4QxN1RGy7juMPJ+kf
         SWteHBXIa3Hedo7vvsb7loP5Ae3nPMPgS0esSGZw=
Date:   Mon, 10 Oct 2022 08:38:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dominique MARTINET <dominique.martinet@atmark-techno.com>
Cc:     Lukas Wunner <lukas@wunner.de>, linux-serial@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] serial: Deassert Transmit Enable on probe in
 driver-specific way
Message-ID: <Y0O9z3dg5K6qQrRm@kroah.com>
References: <2de36eba3fbe11278d5002e4e501afe0ceaca039.1663863805.git.lukas@wunner.de>
 <Y0O46rcQap99fZVC@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0O46rcQap99fZVC@atmark-techno.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 10, 2022 at 03:17:14PM +0900, Dominique MARTINET wrote:
> +Cc stable
> 
> Lukas Wunner wrote on Thu, Sep 22, 2022 at 06:27:33PM +0200:
> > When a UART port is newly registered, uart_configure_port() seeks to
> > deassert RS485 Transmit Enable by setting the RTS bit in port->mctrl.
> > However a number of UART drivers interpret a set RTS bit as *assertion*
> > instead of deassertion:  Affected drivers include those using
> > serial8250_em485_config() (except 8250_bcm2835aux.c) and some using
> > mctrl_gpio (e.g. imx.c).
> > 
> > Since the interpretation of the RTS bit is driver-specific, it is not
> > suitable as a means to centrally deassert Transmit Enable in the serial
> > core.  Instead, the serial core must call on drivers to deassert it in
> > their driver-specific way.  One way to achieve that is to call
> > ->rs485_config().  It implicitly deasserts Transmit Enable.
> > 
> > So amend uart_configure_port() and uart_resume_port() to invoke
> > uart_rs485_config().  That allows removing calls to uart_rs485_config()
> > from drivers' ->probe() hooks and declaring the function static.
> > 
> > Skip any invocation of ->set_mctrl() if RS485 is enabled.  RS485 has no
> > hardware flow control, so the modem control lines are irrelevant and
> > need not be touched.  When leaving RS485 mode, reset the modem control
> > lines to the state stored in port->mctrl.  That way, UARTs which are
> > muxed between RS485 and RS232 transceivers drive the lines correctly
> > when switched to RS232.  (serial8250_do_startup() historically raises
> > the OUT1 modem signal because otherwise interrupts are not signaled on
> > ancient PC UARTs, but I believe that no longer applies to modern,
> > RS485-capable UARTs and is thus safe to be skipped.)
> > 
> > imx.c modifies port->mctrl whenever Transmit Enable is asserted and
> > deasserted.  Stop it from doing that so port->mctrl reflects the RS232
> > line state.
> > 
> > 8250_omap.c deasserts Transmit Enable on ->runtime_resume() by calling
> > ->set_mctrl().  Because that is now a no-op in RS485 mode, amend the
> > function to call serial8250_em485_stop_tx().
> > 
> > fsl_lpuart.c retrieves and applies the RS485 device tree properties
> > after registering the UART port.  Because applying now happens on
> > registration in uart_configure_port(), move retrieval of the properties
> > ahead of uart_add_one_port().
> > 
> > Fixes: d3b3404df318 ("serial: Fix incorrect rs485 polarity on uart open")
> 
> Thanks for this fix!
> We also noticed rs485 DE was initially wrong last week and I noticed
> this when I was about to send a patch that just inverted the
> SER_RS485_RTS_AFTER_SEND check in uart_configure_port, but after reading
> the commit message here it's a lot more complicated than that depending
> on the serial driver...
> (fixing commit 2dd8a74fddd2 ("serial: core: Initialize rs485 RTS
> polarity already on probe"), but it's actually the same problem in the
> opposite direction)
> 
> 
> Unfortunately you've marked this for v4.14+ stable, but it doesn't even
> apply to 5.19.14 due to (at least) commit d8fcd9cfbde5 ("serial: core:
> move sanitizing of RS485 delays into own function"), so it hasn't been
> picked up yet; since quite a bit of code was cleaned up/moved one will
> need to pay a bit attention when doing that.
> 
> What would you like to do for stable branches?
> Would you be able to send a patch that applies on older 5.10 and 5.15
> where commit d3b3404df318 ("serial: Fix incorrect rs485 polarity on uart
> open") has been backported?
> 
> If that sounds too complicated we could probably just revert a handful
> of serial_core/rs485 commits, but going forward sounds more future-proof
> to me.
> 
> Thanks!
> (nothing below, leaving quote for stable@)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
