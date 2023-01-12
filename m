Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215D4667270
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjALMmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbjALMmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:42:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB4A25F;
        Thu, 12 Jan 2023 04:41:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 459B660A6D;
        Thu, 12 Jan 2023 12:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06122C433D2;
        Thu, 12 Jan 2023 12:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673527311;
        bh=5i96I7lJYPSdvRdopyQ24odQpyZbyCYnrM+K0gVY9aM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uacag1GKVlmDoTP1KpheK9tbXGq/5Dk3sUlnPY8+4T2ywSDJYhNbshU2HN66187zw
         3Qk3bxVWJLTbWkCCc78A/PhhNObN88IgCNC5J+iaUcUXutu2Zsow6iXraRhCqKOlAr
         0KcggReYtj0S/RdMtKfbQF63ClOP5wkLS35Tgp0E=
Date:   Thu, 12 Jan 2023 13:41:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Jiri Slaby <jirislaby@kernel.org>, Lukas Wunner <lukas@wunner.de>,
        Dominique Martinet <dominique.martinet@atmark-techno.com>,
        Daisuke Mizobuchi <mizo@atmark-techno.com>,
        Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        linux-serial@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.15.y v2] serial: fixup backport of "serial: Deassert
 Transmit Enable on probe in driver-specific way"
Message-ID: <Y8AADD1b19FsTMRD@kroah.com>
References: <20221220102316.1280393-1-linux@rasmusvillemoes.dk>
 <20221222114414.1886632-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222114414.1886632-1-linux@rasmusvillemoes.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 22, 2022 at 12:44:14PM +0100, Rasmus Villemoes wrote:
> When 7c7f9bc986e6 ("serial: Deassert Transmit Enable on probe in
> driver-specific way") got backported to 5.15.y, there known as
> b079d3775237, some hunks were accidentally left out.
> 
> In fsl_lpuart.c, this amounts to uart_remove_one_port() being called
> in an error path despite uart_add_one_port() not having been called.
> 
> In serial_core.c, it is possible that the omission in
> uart_suspend_port() is harmless, but the backport did have the
> corresponding hunk in uart_resume_port(), it runs counter to the
> original commit's intention of
> 
>   Skip any invocation of ->set_mctrl() if RS485 is enabled.
> 
> and it's certainly better to be aligned with upstream.
> 
> Fixes: b079d3775237 ("serial: Deassert Transmit Enable on probe in driver-specific way")
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
> 
> v2: Also amend uart_suspend_port(), update commit log accordingly.

Now queued up, thanks.

greg k-h
