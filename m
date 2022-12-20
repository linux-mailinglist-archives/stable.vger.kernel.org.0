Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33A2651D95
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 10:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiLTJig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 04:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbiLTJie (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 04:38:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669B1E7
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 01:38:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C569612A8
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 09:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62CCC433EF;
        Tue, 20 Dec 2022 09:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671529113;
        bh=zLtVd3AV5ep7sTy4T0lyDMZkRmn8dQKepv4hGZFlmsk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A1FsY8FWradH2/t+ATlgoDuf8GtNgiAXx4Dtjs71AfAJ05iIjDD1Dr3VaYOG1n1LL
         uCYGh8sf1FUmMdnY+qxmSvHTrX2R86MSP89QrLBQrByJX4STit0cRrpRSFkDgAM2yq
         5UYTFgJp+ymzHccKqDBmNEifNrrNs0hypAtbtLgA=
Date:   Tue, 20 Dec 2022 10:38:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Lukas Wunner <lukas@wunner.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: Re: commit b079d3775237 in 5.15.y
Message-ID: <Y6GCluSzwrnmoENo@kroah.com>
References: <38a93e7d-f716-e908-7fba-7570299a6fd3@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38a93e7d-f716-e908-7fba-7570299a6fd3@prevas.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 20, 2022 at 10:16:38AM +0100, Rasmus Villemoes wrote:
> Hi,
> 
> I think something went slightly wrong when 7c7f9bc98 (serial: Deassert
> Transmit Enable on probe in driver-specific way) got backported to
> 5.15.y. In fsl_lpuart.c, the original had this
> 
>  failed_irq_request:
> -failed_get_rs485:
>         uart_remove_one_port(&lpuart_reg, &sport->port);
>  failed_attach_port:
> +failed_get_rs485:
>  failed_reset:
>         lpuart_disable_clks(sport);
>         return ret;
> 
> in the error path, but that is missing in the backport. So if we now hit
> the 'goto failed_get_rs485;', we'll do uart_remove_one_port() while
> uart_add_one_port() hasn't been done.

Ick, can you send a patch to fix this up?

thanks,

greg k-h
