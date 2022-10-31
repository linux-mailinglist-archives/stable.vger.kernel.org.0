Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456EC613155
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiJaHmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiJaHmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:42:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC2365EF
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 00:42:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 234A060FFF
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 07:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3523EC433C1;
        Mon, 31 Oct 2022 07:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667202150;
        bh=1+riR0KFIgYReetD4Za293COMQ2UlNbOhkT/yMgNgrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cV4nE08TCakSA1OgDXwm6hyCe3V7/HbEDl28hHM6GR9xYxDS3FNm5Zxo0vh+Fx5z/
         atk8g6dns3OdHsBpgvJzpMrS9r0K7m9N/NTngohH21G/svQUFM70LM1QCeRJY/A6Xz
         xe2bcqWcVkKjXGSHUxc0yW5w8okxnHQ9y6nMtcpY=
Date:   Mon, 31 Oct 2022 08:43:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Tomasz =?utf-8?Q?Mo=C5=84?= <tomasz.mon@camlingroup.com>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Sasha Levin <sashal@kernel.org>, Han Xu <han.xu@nxp.com>,
        kernel <kernel@pengutronix.de>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH RESEND stable 5.10] mtd: rawnand: gpmi: Set
 WAIT_FOR_READY timeout based on program/erase times
Message-ID: <Y198nomOpDZ9SUq/@kroah.com>
References: <20221028213315.4171685-1-tharvey@gateworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221028213315.4171685-1-tharvey@gateworks.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 28, 2022 at 02:33:15PM -0700, Tim Harvey wrote:
> From: Sascha Hauer <s.hauer@pengutronix.de>
> 
> 06781a5026350 Fixes the calculation of the DEVICE_BUSY_TIMEOUT register
> value from busy_timeout_cycles. busy_timeout_cycles is calculated wrong
> though: It is calculated based on the maximum page read time, but the
> timeout is also used for page write and block erase operations which
> require orders of magnitude bigger timeouts.
> 
> Fix this by calculating busy_timeout_cycles from the maximum of
> tBERS_max and tPROG_max.
> 
> This is for now the easiest and most obvious way to fix the driver.
> There's room for improvements though: The NAND_OP_WAITRDY_INSTR tells us
> the desired timeout for the current operation, so we could program the
> timeout dynamically for each operation instead of setting a fixed
> timeout. Also we could wire up the interrupt handler to actually detect
> and forward timeouts occurred when waiting for the chip being ready.
> 
> As a sidenote I verified that the change in 06781a5026350 is really
> correct. I wired up the interrupt handler in my tree and measured the
> time between starting the operation and the timeout interrupt handler
> coming in. The time increases 41us with each step in the timeout
> register which corresponds to 4096 clock cycles with the 99MHz clock
> that I have.
> 
> Fixes: 06781a5026350 ("mtd: rawnand: gpmi: Fix setting busy timeout setting")
> Fixes: b1206122069aa ("mtd: rawniand: gpmi: use core timings instead of an empirical derivation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Acked-by: Han Xu <han.xu@nxp.com>
> Tested-by: Tomasz Moń <tomasz.mon@camlingroup.com>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
> stable-5.10

You did not sign-off on this backport.  Please fix that up and resend
and also give us a hint as to what the upstream commit id is here.

thanks,

greg k-h
