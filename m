Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60862689386
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 10:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbjBCJW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 04:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbjBCJWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 04:22:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B6B9B71C
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 01:21:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E073461E21
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 09:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD231C433D2;
        Fri,  3 Feb 2023 09:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675416085;
        bh=KF2wlR04/M83dbmoFCR4NL2EHkGN3pivX2y3AT/Ohq4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a+SpTuT6zBBMySOa+oWJTU23OGUm4xTBarcE8q2cy98zogTiFOnNxHyvkoFel3lJd
         awD9/ZC3UqOuBZzHnuuzRHfBsOCIJ+Pq4sLdlej+TqvhfjFv0jJbKOsxl+4KjaJHFz
         ATh+TvgeLJKP7YLx/LvsydQiHRikvJkmjBAfeO64=
Date:   Fri, 3 Feb 2023 10:21:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Build failures in v4.19.y.queue
Message-ID: <Y9zSEltcNitcd7R6@kroah.com>
References: <4b9007db-923d-8394-175f-22b16c078d51@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b9007db-923d-8394-175f-22b16c078d51@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 31, 2023 at 08:16:58PM -0800, Guenter Roeck wrote:
> Hi,
> 
> I see a number of build failures in v4.19.y.queue.
> 
> Building arm:allmodconfig ... failed
> --------------
> drivers/memory/atmel-sdramc.c: In function 'atmel_ramc_probe':
> drivers/memory/atmel-sdramc.c:62:23: error: implicit declaration of function 'devm_clk_get_enabled'

Offending patch now dropped.

> 
> Building arm:imx_v6_v7_defconfig ... failed
> --------------
> Error log:
> drivers/mmc/host/sdhci-esdhc-imx.c: In function 'sdhci_esdhc_imx_hwinit':
> drivers/mmc/host/sdhci-esdhc-imx.c:1187:31: error: implicit declaration of function 'cqhci_readl'
> 
> drivers/mmc/host/sdhci-esdhc-imx.c:1187:52: error: 'CQHCI_IS' undeclared (first use in this function)
>  1187 |                         tmp = cqhci_readl(cq_host, CQHCI_IS);
> 
> drivers/mmc/host/sdhci-esdhc-imx.c:1188:25: error: implicit declaration of function 'cqhci_writel'; did you mean 'sdhci_writel'? [-Werror=implicit-function-declaration]
>  1188 |                         cqhci_writel(cq_host, tmp, CQHCI_IS);
> 
> drivers/mmc/host/sdhci-esdhc-imx.c:1189:47: error: 'CQHCI_HALT' undeclared (first use in this function)
>  1189 |                         cqhci_writel(cq_host, CQHCI_HALT, CQHCI_CTL);
>       |                                               ^~~~~~~~~~
> drivers/mmc/host/sdhci-esdhc-imx.c:1189:59: error: 'CQHCI_CTL' undeclared (first use in this function)
>  1189 |                         cqhci_writel(cq_host, CQHCI_HALT, CQHCI_CTL);
> 
> Other builds fail with the same errors.

Offending patches now dropped, thanks.

greg k-h
