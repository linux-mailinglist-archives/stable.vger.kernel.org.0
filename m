Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F0D5E589D
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 04:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiIVCfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 22:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiIVCft (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 22:35:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4092AAC241;
        Wed, 21 Sep 2022 19:35:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE6CA63145;
        Thu, 22 Sep 2022 02:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3B3C433C1;
        Thu, 22 Sep 2022 02:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663814147;
        bh=MMR3itBbBFn5YCH6vdTlQK8K7HWibMf9yzQoXvTYVEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hIqWKxXYZjn7/Jjw3/xH+MDezC/8RCEcp0obY7usoYmPRaMB3kw1HPFO7gI1ujDb9
         /ZKdw2SnrdnYds/JI2UnzLRaf4zidVumyw8aetrSnE18N6axKidj5tIYdgbI4NVcMd
         yEmUZxUo8XObwSW0BXvHnPE43aQPWSRwJVS8F+F1+MfuDCTXMPhevSDXUaU/KEuiAe
         Y2yF6WVSkUAlQNaCqXBRvv3bY10oWkHhhOnVh4gRjPWH+Ss0MTGzmBNypPnMUcYQQ0
         rA2xCckdk+4MQcoXnMc36wyEcLjBRfqcKV4EIphd1ECtODubfC19f3Yl31IHzsQbIT
         zDCiYyufiWQQg==
Date:   Thu, 22 Sep 2022 08:05:42 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Michael Trimarchi <michael@amarulasolutions.com>,
        linux-amarula@amarulasolutions.com,
        Robin Murphy <robin.murphy@arm.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6] dmaengine: mxs: use platform_driver_register
Message-ID: <YyvJ/hwu17gC9E/z@matsya>
References: <20220921170556.1055962-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921170556.1055962-1-dario.binacchi@amarulasolutions.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-09-22, 19:05, Dario Binacchi wrote:
> Driver registration fails on SOC imx8mn as its supplier, the clock
> control module, is probed later than subsys initcall level. This driver
> uses platform_driver_probe which is not compatible with deferred probing
> and won't be probed again later if probe function fails due to clock not
> being available at that time.
> 
> This patch replaces the use of platform_driver_probe with
> platform_driver_register which will allow probing the driver later again
> when the clock control module will be available.
> 
> The __init annotation has been dropped because it is not compatible with
> deferred probing. The code is not executed once and its memory cannot be
> freed.

Applied, thanks

-- 
~Vinod
