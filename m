Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2D85ADECA
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 07:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiIFFBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 01:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiIFFBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 01:01:20 -0400
Received: from smtp.smtpout.orange.fr (smtp08.smtpout.orange.fr [80.12.242.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6635F122
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 22:01:18 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id VQi4oZE6nXFXxVQi4ovvAL; Tue, 06 Sep 2022 07:01:16 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 06 Sep 2022 07:01:16 +0200
X-ME-IP: 90.11.190.129
Message-ID: <11d7fc32-000f-68a2-99a0-68b0cb3bc4a0@wanadoo.fr>
Date:   Tue, 6 Sep 2022 07:01:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Patch "clk: bcm: rpi: Use correct order for the parameters of
 devm_kcalloc()" has been added to the 5.15-stable tree
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>
References: <20220906032831.1115256-1-sashal@kernel.org>
From:   Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220906032831.1115256-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Le 06/09/2022 à 05:28, Sasha Levin a écrit :
> This is a note to let you know that I've just added the patch titled
>
>      clk: bcm: rpi: Use correct order for the parameters of devm_kcalloc()
>
> to the 5.15-stable tree which can be found at:
>      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>       clk-bcm-rpi-use-correct-order-for-the-parameters-of-.patch
> and it can be found in the queue-5.15 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Hi,

I'm not sure that such a patch deserve a backport.

It is correct, but it is just a clean-up that will be a no-op at runtime.
Should it help future potential backport, why not, but otherwise, IMHO, 
it could be dropped.

It is also in the 5.10 backport queue.

Just my 2c,

CJ


> commit f731681dfb26866e5e4130d27d27e00766f7e9d1
> Author: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Date:   Fri May 20 23:20:58 2022 +0200
>
>      clk: bcm: rpi: Use correct order for the parameters of devm_kcalloc()
>      
>      [ Upstream commit b7fa6242f3e035308a76284560e4f918dad9b017 ]
>      
>      We should have 'n', then 'size', not the opposite.
>      This is harmless because the 2 values are just multiplied, but having
>      the correct order silence a (unpublished yet) smatch warning.
>      
>      Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>      Link: https://lore.kernel.org/r/49d726d11964ca0e3757bdb5659e3b3eaa1572b5.1653081643.git.christophe.jaillet@wanadoo.fr
>      Signed-off-by: Stephen Boyd <sboyd@kernel.org>
>      Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> diff --git a/drivers/clk/bcm/clk-raspberrypi.c b/drivers/clk/bcm/clk-raspberrypi.c
> index fda78a2f9ac50..97612860ce0e1 100644
> --- a/drivers/clk/bcm/clk-raspberrypi.c
> +++ b/drivers/clk/bcm/clk-raspberrypi.c
> @@ -252,7 +252,7 @@ static int raspberrypi_discover_clocks(struct raspberrypi_clk *rpi,
>   	int ret;
>   
>   	clks = devm_kcalloc(rpi->dev,
> -			    sizeof(*clks), RPI_FIRMWARE_NUM_CLK_ID,
> +			    RPI_FIRMWARE_NUM_CLK_ID, sizeof(*clks),
>   			    GFP_KERNEL);
>   	if (!clks)
>   		return -ENOMEM;
