Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044CE62BAAB
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 12:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiKPLCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 06:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiKPLBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 06:01:41 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862331570D;
        Wed, 16 Nov 2022 02:49:36 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id B3666849CD;
        Wed, 16 Nov 2022 11:49:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1668595775;
        bh=/RKFfzPIDJxjayT8Q6/3VwncSgZG64bhHeq7pBCHSnA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TOMraKeo5PIXkAxKSEL5gxonyxHgglRaYWwca+KPliAyOnpzMUypspmazZYYFgWSv
         zVUFGC97rOQpr+iTdULLFDukZHgK04QdbmWY1MmJdMoYNIAqn0Yrut+tiy6mjOvR2F
         vaDcphuKbob1UeQTE73UcYouwN1bnwRBuJZfDGpFwpFDWm8myRWgRfEnDB7lzBvAaA
         bO8DpeYowwmh5epa5XaKQP47h9j1XQ0l2mNn+35T3AED3d2n9CM1UIfoMMQq3pTg6S
         ZjMZTj24fNNieuuBS1jMpWxxs6Fk6yoit9OIv/dYbW0B+4xNIJ1fBzfkuYxCfyMKTy
         +IZ/m2Zoa01lQ==
Message-ID: <c0aeb578-611b-d008-cdc6-148f99bf19c2@denx.de>
Date:   Wed, 16 Nov 2022 11:49:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v3] spi: spi-imx: Fix spi_bus_clk if requested clock is
 higher than input clock
Content-Language: en-US
To:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        Frieder Schrempf <frieder@fris.de>,
        David Jander <david@protonic.nl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Baruch Siach <baruch.siach@siklu.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20221115181002.2068270-1-frieder@fris.de>
 <7b31dd4d-a74c-1013-491f-81538001917e@denx.de>
 <01bce6c9-7825-2995-44fb-ddebbbd7b482@kontron.de>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <01bce6c9-7825-2995-44fb-ddebbbd7b482@kontron.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/22 09:17, Frieder Schrempf wrote:
> On 16.11.22 00:49, Marek Vasut wrote:
>> On 11/15/22 19:10, Frieder Schrempf wrote:
>>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>>
>>> In case the requested bus clock is higher than the input clock, the
>>> correct
>>> dividers (pre = 0, post = 0) are returned from mx51_ecspi_clkdiv(), but
>>> *fres is left uninitialized and therefore contains an arbitrary value.
>>>
>>> This causes trouble for the recently introduced PIO polling feature as
>>> the
>>> value in spi_imx->spi_bus_clk is used there to calculate for which
>>> transfers to enable PIO polling.
>>>
>>> Fix this by setting *fres even if no clock dividers are in use.
>>>
>>> This issue was observed on Kontron BL i.MX8MM with an SPI peripheral
>>> clock set
>>> to 50 MHz by default and a requested SPI bus clock of 80 MHz for the
>>> SPI NOR
>>> flash.
>>>
>>> With the fix applied the debug message from mx51_ecspi_clkdiv() now
>>> prints the
>>> following:
>>>
>>> spi_imx 30820000.spi: mx51_ecspi_clkdiv: fin: 50000000, fspi: 50000000,
>>> post: 0, pre: 0
>>>
>>> Fixes: 6fd8b8503a0d ("spi: spi-imx: Fix out-of-order CS/SCLK operation
>>> at low speeds")
>>> Fixes: 07e759387788 ("spi: spi-imx: add PIO polling support")
>>> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
>>> Cc: David Jander <david@protonic.nl>
>>> Cc: Fabio Estevam <festevam@gmail.com>
>>> Cc: Mark Brown <broonie@kernel.org>
>>> Cc: Marek Vasut <marex@denx.de>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
>>> Tested-by: Fabio Estevam <festevam@gmail.com>
>>> ---
>>>
>>> Changes for v3:
>>>
>>> * Add back the Fixes tag for commit 6fd8b8503a0d
>>> * Add Fabio's Tested-by (Thanks!)
>>>
>>> Changes for v2:
>>>
>>> * Remove the reference and the Fixes tag for commit 6fd8b8503a0d as it is
>>>     incorrect.
>>> ---
>>>    drivers/spi/spi-imx.c | 3 +--
>>>    1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
>>> index 30d82cc7300b..468ce0a2b282 100644
>>> --- a/drivers/spi/spi-imx.c
>>> +++ b/drivers/spi/spi-imx.c
>>> @@ -444,8 +444,7 @@ static unsigned int mx51_ecspi_clkdiv(struct
>>> spi_imx_data *spi_imx,
>>>        unsigned int pre, post;
>>>        unsigned int fin = spi_imx->spi_clk;
>>>    -    if (unlikely(fspi > fin))
>>> -        return 0;
>>> +    fspi = min(fspi, fin);
>>>          post = fls(fin) - fls(fspi);
>>>        if (fin > fspi << post)
>>
>> Can you also test the SPI flash at some 100 kHz, just to see whether it
>> still works properly ? (to retain behavior fixed first in 6fd8b8503a0dc
>> ("spi: spi-imx: Fix out-of-order CS/SCLK operation at low speeds") )
>>
>> The fix here does look fine by me however.
> 
> I successfully tested at 100 kHZ SPI bus clock. As in this case fspi is
> lower than fin, the patch doesn't change anything in the code path and
> therefore the behavior introduced in 6fd8b8503a0dc stays the same as
> without the patch.

Acked-by: Marek Vasut <marex@denx.de>

Thanks for the extra check !
