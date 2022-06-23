Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1DD8557F8D
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiFWQPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiFWQPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:15:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77232F66D
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 09:15:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 501DA61F29
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 16:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C97C3411B;
        Thu, 23 Jun 2022 16:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656000944;
        bh=mjcnbOPQGSY9AkomTcqP0iCZk6tyDvcrc2w+ZvE2Ay0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jUVpUQDcA3auU1o0xK9/W7iHCQPcwghBY/613fOReL7vkAGfvuOTNuW1sd2t2jXJP
         c6a5YIB2Vj4aR82l2gryiDMud6y0xSPPfVGSkttCu+7R/iLvhQpjO8mOHLKf3Z1VNA
         5dK1vO99bRzNhB+VXro0rBO9SfOytk8l0r4fr1w8=
Date:   Thu, 23 Jun 2022 18:15:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc:     stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Su Bao Cheng <baocheng.su@siemens.com>,
        Daisuke Mizobuchi <mizo@atmark-techno.com>
Subject: Re: [PATCH v5.10] serial: core: Initialize rs485 RTS polarity
 already on probe
Message-ID: <YrSRrfHP45YGb2/r@kroah.com>
References: <20220623005858.1907788-1-dominique.martinet@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623005858.1907788-1-dominique.martinet@atmark-techno.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 09:58:58AM +0900, Dominique Martinet wrote:
> From: Lukas Wunner <lukas@wunner.de>
> 
> Core part of commit 2dd8a74fddd21b95dcc60a2d3c9eaec993419d69 upstream:
> the PL011 driver does not support RS485 in the 5.10 tree yet so drop
> that bit.
> 
> RTS polarity of rs485-enabled ports is currently initialized on uart
> open via:
> 
> tty_port_open()
>   tty_port_block_til_ready()
>     tty_port_raise_dtr_rts()  # if (C_BAUD(tty))
>       uart_dtr_rts()
>         uart_port_dtr_rts()
> 
> There's at least three problems here:
> 
> First, if no baud rate is set, RTS polarity is not initialized.
> That's the right thing to do for rs232, but not for rs485, which
> requires that RTS is deasserted unconditionally.
> 
> Second, if the DeviceTree property "linux,rs485-enabled-at-boot-time" is
> present, RTS should be deasserted as early as possible, i.e. on probe.
> Otherwise it may remain asserted until first open.
> 
> Third, even though RTS is deasserted on open and close, it may
> subsequently be asserted by uart_throttle(), uart_unthrottle() or
> uart_set_termios() because those functions aren't rs485-aware.
> (Only uart_tiocmset() is.)
> 
> To address these issues, move RTS initialization from uart_port_dtr_rts()
> to uart_configure_port().  Prevent subsequent modification of RTS
> polarity by moving the existing rs485 check from uart_tiocmget() to
> uart_update_mctrl().
> 
> That way, RTS is initialized on probe and then remains unmodified unless
> the uart transmits data.  If rs485 is enabled at runtime (instead of at
> boot) through a TIOCSRS485 ioctl(), RTS is initialized by the uart
> driver's ->rs485_config() callback and then likewise remains unmodified.
> 
> The PL011 driver initializes RTS on uart open and prevents subsequent
> modification in its ->set_mctrl() callback.  That code is obsoleted by
> the present commit, so drop it.
> 
> Cc: Jan Kiszka <jan.kiszka@siemens.com>
> Cc: Su Bao Cheng <baocheng.su@siemens.com>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Link: https://lore.kernel.org/r/2d2acaf3a69e89b7bf687c912022b11fd29dfa1e.1642909284.git.lukas@wunner.de
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org # 5.10
> Reported-by: Daisuke Mizobuchi <mizo@atmark-techno.com>
> Tested-by: Daisuke Mizobuchi <mizo@atmark-techno.com>
> Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
> ---
> Notes:
>  - as said in commit message, I've dropped the PL011 part of the
> original patch as it is orthogonal to this change. We need this
> serial core fix for the imx serial tty driver.
> 
> - I wasn't really sure what to do with tags in the commit message,
> everything below the 'Cc: stable' tag apply to the backport:
> Mizobuchi-san tested the backport on the 5.10 branch with the imx
> driver.
> 
> - I'm not quite sure how far back it is relevant, for imx I assume
> rs485 is broken since 58362d5be352 ("serial: imx: implement handshaking
> using gpios with the mctrl_gpio helper") (4.5), and we did have that
> problem all the way back in our older 4.9 product tree... but core
> support back then wasn't as extensive for RS485 so we have a different
> imx specific workaround there.
> 
>  - I do not use 5.15 but either version of this patch apply cleanly
> there; I'd assume it'd be more appropriate to get the original
> 2dd8a74fddd21b cherry-picked in this case for 5.15.

Now queued up, thanks.

greg k-h
