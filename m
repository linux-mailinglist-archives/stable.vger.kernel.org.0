Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCAD44AA802
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 10:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359424AbiBEJ7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 04:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbiBEJ7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 04:59:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A52BC061346;
        Sat,  5 Feb 2022 01:59:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E3B560ADD;
        Sat,  5 Feb 2022 09:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A91C340E8;
        Sat,  5 Feb 2022 09:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644055193;
        bh=W5YmqexkL6b0U2LlECgOXWwtWCfw0QjpKZw0Ip+T2xI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DL2JNS8XmdlEEPAGoDHitCg7jF06NjQDTc7v8sY7/WebGhFkHaLcUBH5FmC4rDu+Y
         7c3MVahAfx5OcEP97BuruVwQYciernb6GT0HTiDK54XXBUdQgjmDnxXXP4RjLe/QAO
         N4IbMQR9nng1/Vd52yglT76E/v9pRWgFClkT5BQ8=
Date:   Sat, 5 Feb 2022 10:59:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Siarhei Volkau <lis8215@gmail.com>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-mips@vger.kernel.org,
        linux-clk@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/1] clk: jz4725b: fix mmc0 clock gating
Message-ID: <Yf5KlvxlRwM9JsZr@kroah.com>
References: <4FSS6R.0A48V2ZMZD7X1@crapouillou.net>
 <20220205094531.676371-1-lis8215@gmail.com>
 <20220205094531.676371-2-lis8215@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220205094531.676371-2-lis8215@gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 05, 2022 at 12:45:31PM +0300, Siarhei Volkau wrote:
> The mmc0 clock gate bit was mistakenly assigned to "i2s" clock.
> You can find that the same bit is assigned to "mmc0" too.
> It leads to mmc0 hang for a long time after any sound activity
> also it  prevented PM_SLEEP to work properly.
> I guess it was introduced by copy-paste from jz4740 driver
> where it is really controls I2S clock gate.
> 
> Fixes: 226dfa4726eb ("clk: Add Ingenic jz4725b CGU driver")
> Signed-off-by: Siarhei Volkau <lis8215@gmail.com>
> Tested-by: Siarhei Volkau <lis8215@gmail.com>
> Reviewed-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  drivers/clk/ingenic/jz4725b-cgu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/ingenic/jz4725b-cgu.c b/drivers/clk/ingenic/jz4725b-cgu.c
> index 744d136..15d6179 100644
> --- a/drivers/clk/ingenic/jz4725b-cgu.c
> +++ b/drivers/clk/ingenic/jz4725b-cgu.c
> @@ -139,11 +139,10 @@ static const struct ingenic_cgu_clk_info jz4725b_cgu_clocks[] = {
>  	},
>  
>  	[JZ4725B_CLK_I2S] = {
> -		"i2s", CGU_CLK_MUX | CGU_CLK_DIV | CGU_CLK_GATE,
> +		"i2s", CGU_CLK_MUX | CGU_CLK_DIV,
>  		.parents = { JZ4725B_CLK_EXT, JZ4725B_CLK_PLL_HALF, -1, -1 },
>  		.mux = { CGU_REG_CPCCR, 31, 1 },
>  		.div = { CGU_REG_I2SCDR, 0, 1, 9, -1, -1, -1 },
> -		.gate = { CGU_REG_CLKGR, 6 },
>  	},
>  
>  	[JZ4725B_CLK_SPI] = {
> -- 
> 2.35.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
