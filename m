Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A464AA8A2
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 13:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379830AbiBEMPt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 5 Feb 2022 07:15:49 -0500
Received: from aposti.net ([89.234.176.197]:56588 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379808AbiBEMP0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Feb 2022 07:15:26 -0500
Date:   Sat, 05 Feb 2022 12:15:15 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH v3 1/1] clk: jz4725b: fix mmc0 clock gating
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Siarhei Volkau <lis8215@gmail.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-mips@vger.kernel.org,
        linux-clk@vger.kernel.org, stable@vger.kernel.org
Message-Id: <FDZT6R.4ATV1Z4FNCP21@crapouillou.net>
In-Reply-To: <Yf5KlvxlRwM9JsZr@kroah.com>
References: <4FSS6R.0A48V2ZMZD7X1@crapouillou.net>
        <20220205094531.676371-1-lis8215@gmail.com>
        <20220205094531.676371-2-lis8215@gmail.com> <Yf5KlvxlRwM9JsZr@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Le sam., févr. 5 2022 at 10:59:50 +0100, Greg KH 
<gregkh@linuxfoundation.org> a écrit :
> On Sat, Feb 05, 2022 at 12:45:31PM +0300, Siarhei Volkau wrote:
>>  The mmc0 clock gate bit was mistakenly assigned to "i2s" clock.
>>  You can find that the same bit is assigned to "mmc0" too.
>>  It leads to mmc0 hang for a long time after any sound activity
>>  also it  prevented PM_SLEEP to work properly.
>>  I guess it was introduced by copy-paste from jz4740 driver
>>  where it is really controls I2S clock gate.
>> 
>>  Fixes: 226dfa4726eb ("clk: Add Ingenic jz4725b CGU driver")
>>  Signed-off-by: Siarhei Volkau <lis8215@gmail.com>
>>  Tested-by: Siarhei Volkau <lis8215@gmail.com>
>>  Reviewed-by: Paul Cercueil <paul@crapouillou.net>
>>  ---
>>   drivers/clk/ingenic/jz4725b-cgu.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>> 
>>  diff --git a/drivers/clk/ingenic/jz4725b-cgu.c 
>> b/drivers/clk/ingenic/jz4725b-cgu.c
>>  index 744d136..15d6179 100644
>>  --- a/drivers/clk/ingenic/jz4725b-cgu.c
>>  +++ b/drivers/clk/ingenic/jz4725b-cgu.c
>>  @@ -139,11 +139,10 @@ static const struct ingenic_cgu_clk_info 
>> jz4725b_cgu_clocks[] = {
>>   	},
>> 
>>   	[JZ4725B_CLK_I2S] = {
>>  -		"i2s", CGU_CLK_MUX | CGU_CLK_DIV | CGU_CLK_GATE,
>>  +		"i2s", CGU_CLK_MUX | CGU_CLK_DIV,
>>   		.parents = { JZ4725B_CLK_EXT, JZ4725B_CLK_PLL_HALF, -1, -1 },
>>   		.mux = { CGU_REG_CPCCR, 31, 1 },
>>   		.div = { CGU_REG_I2SCDR, 0, 1, 9, -1, -1, -1 },
>>  -		.gate = { CGU_REG_CLKGR, 6 },
>>   	},
>> 
>>   	[JZ4725B_CLK_SPI] = {
>>  --
>>  2.35.1
>> 
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     
> https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>

What's wrong with this patch exactly? It looks good to me.

Cheers,
-Paul


