Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F82D5F9B6D
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 10:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiJJIxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 04:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJJIxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 04:53:09 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D18B4DF20;
        Mon, 10 Oct 2022 01:53:07 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 3CCCC100DA1C2;
        Mon, 10 Oct 2022 10:53:06 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id F31103E543; Mon, 10 Oct 2022 10:53:05 +0200 (CEST)
Date:   Mon, 10 Oct 2022 10:53:05 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Dominique MARTINET <dominique.martinet@atmark-techno.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] serial: Deassert Transmit Enable on probe in
 driver-specific way
Message-ID: <20221010085305.GA32599@wunner.de>
References: <2de36eba3fbe11278d5002e4e501afe0ceaca039.1663863805.git.lukas@wunner.de>
 <Y0O46rcQap99fZVC@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0O46rcQap99fZVC@atmark-techno.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 10, 2022 at 03:17:14PM +0900, Dominique MARTINET wrote:
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
[...]
> We also noticed rs485 DE was initially wrong last week and I noticed
> this when I was about to send a patch that just inverted the
> SER_RS485_RTS_AFTER_SEND check in uart_configure_port, but after reading
> the commit message here it's a lot more complicated than that depending
> on the serial driver...

Yes, sorry for the breakage.

> Unfortunately you've marked this for v4.14+ stable, but it doesn't even
> apply to 5.19.14
[...]
> What would you like to do for stable branches?
> Would you be able to send a patch that applies on older 5.10 and 5.15
> where commit d3b3404df318 ("serial: Fix incorrect rs485 polarity on uart
> open") has been backported?

Greg will try to apply it to stable kernels (probably after the merge
window closes) and send an e-mail that it failed.  I was going to wait
for that to happen and then look into backporting the patch.

Basically what needs to be done is replace calls to uart_rs485_config()
with a direct invocation of port->rs485_config().  Plus carefully checking
that nothing is missing or breaks.  That's probably simpler than just
backporting additional patches or reverting stuff.  If you want to take
a stab at it, go ahead. :)

Thanks,

Lukas
