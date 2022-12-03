Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C10764170C
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 14:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiLCNhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 08:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLCNhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 08:37:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681C0E02C
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 05:37:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5DFC601BE
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 13:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDB6C433D6;
        Sat,  3 Dec 2022 13:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670074663;
        bh=t4ArHHIwrmlapzf4XV0Waa9/7j7j6XoY6aIQqWNitn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aPsnomRVoxDVeOZz9h6V5/Mu4Qa3ageEhXXgONQ3B0uxUvR2T1McgITHZO41hhjiR
         ZNIwESb3nE/BOyEEemAxX3LfIU/uBooGyeCzZUOB6Kg7JoXnFn6FfOlF30UV359zeN
         C3tPwA20dquW8dQgSG35i9RVOPRzASaEzzS/m8u8=
Date:   Sat, 3 Dec 2022 14:37:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Sherry Sun <sherry.sun@nxp.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH proper backport to 5.15 1/1] tty: serial: fsl_lpuart:
 don't break the on-going transfer when global reset
Message-ID: <Y4tRI3CQL/PZj7Di@kroah.com>
References: <1b26798d-fdbd-9e21-b745-1ed335e75b@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b26798d-fdbd-9e21-b745-1ed335e75b@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 01, 2022 at 10:54:08AM +0200, Ilpo Järvinen wrote:
> [ Upstream commit 76bad3f88750f8cc465c489e6846249e0bc3d8f5 ]
> 
> lpuart_global_reset() shouldn't break the on-going transmit engine, need
> to recover the on-going data transfer after reset.
> 
> This can help earlycon here, since commit 60f361722ad2 ("serial:
> fsl_lpuart: Reset prior to registration") moved lpuart_global_reset()
> before uart_add_one_port(), earlycon is writing during global reset,
> as global reset will disable the TX and clear the baud rate register,
> which caused the earlycon cannot work any more after reset, needs to
> restore the baud rate and re-enable the transmitter to recover the
> earlycon write.
> 
> Also move the lpuart_global_reset() down, then we can reuse the
> lpuart32_tx_empty() without declaration.
> 
> Fixes: bd5305dcabbc ("tty: serial: fsl_lpuart: do software reset for imx7ulp and imx8qxp")
> Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
> Link: https://lore.kernel.org/r/20221024085844.22786-1-sherry.sun@nxp.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> Hi stable folks,
> 
> These two stable-deps seem to be pulled into stable only due to diff 
> context:
> 
> 07481f448b63 ("serial: fsl_lpuart: Fill in rs485_supported")
> 8925c31c1ac2 ("serial: Add rs485_supported to uart_port")
> 
> I think those two should be dropped from the stable queue and the queued 
> fix for 76bad3f88750 ("tty: serial: fsl_lpuart: don't break the on-going 
> transfer when global reset") replaced with this backport.

As the above are already applied, can you send a fix-up patch to resolve
the problems in the backport that you found?

thanks,

greg k-h
