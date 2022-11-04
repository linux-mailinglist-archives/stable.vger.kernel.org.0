Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE19961983A
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 14:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiKDNgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 09:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKDNgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 09:36:51 -0400
X-Greylist: delayed 445 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 04 Nov 2022 06:36:50 PDT
Received: from smtp112.iad3b.emailsrvr.com (smtp112.iad3b.emailsrvr.com [146.20.161.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15162A402
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 06:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1667568559;
        bh=84c2Xts5TFIfcuNxFxNSo1CmLRqVLks8CTtQ1S5Zmy8=;
        h=Date:Subject:To:From:From;
        b=b9ZfyI+U+qfARJ7Tp5bZspnmr7j6nTt1iTCWs8AXOt0Q2jxhEbtPmtI7ElG04EV+0
         UOgnV7Qi1/dX20JPy39cp0w8QrT9QaYfYs9cdoW0OBo5Xp+dOFuzdoGyYWeSbam3Ex
         CU9wMmFNcSFtyj6CEbUkvagyTjfDs8+VaCYLg7ls=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp15.relay.iad3b.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 193C2C009C;
        Fri,  4 Nov 2022 09:29:18 -0400 (EDT)
Message-ID: <b367fe74-25e1-6c33-b7bc-104686096519@mev.co.uk>
Date:   Fri, 4 Nov 2022 13:29:23 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] rtc: ds1347: fix value written to century register
To:     linux-rtc@vger.kernel.org
Cc:     Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        stable@vger.kernel.org
References: <20221027163249.447416-1-abbotti@mev.co.uk>
Content-Language: en-GB
From:   Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd.
In-Reply-To: <20221027163249.447416-1-abbotti@mev.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: ee9a6868-458b-4417-8104-08a8a09d8153-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/10/2022 17:32, Ian Abbott wrote:
> In `ds1347_set_time()`, the wrong value is being written to the
> `DS1347_CENTURY_REG` register.  It needs to be converted to BCD.  Fix
> it.
> 
> Fixes: 147dae76dbb9 ("rtc: ds1347: handle century register")
> Cc: <stable@vger.kernel.org> # v5.5+
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>   drivers/rtc/rtc-ds1347.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/rtc/rtc-ds1347.c b/drivers/rtc/rtc-ds1347.c
> index 157bf5209ac4..a40c1a52df65 100644
> --- a/drivers/rtc/rtc-ds1347.c
> +++ b/drivers/rtc/rtc-ds1347.c
> @@ -112,7 +112,7 @@ static int ds1347_set_time(struct device *dev, struct rtc_time *dt)
>   		return err;
>   
>   	century = (dt->tm_year / 100) + 19;
> -	err = regmap_write(map, DS1347_CENTURY_REG, century);
> +	err = regmap_write(map, DS1347_CENTURY_REG, bin2bcd(century));
>   	if (err)
>   		return err;
>   

I'm sure this isn't a commonly used driver, but I'd just like to mention 
that I consider it critically broken without this bug fix.  Any dates in 
the 21st century written to the RTC end up being in the 15th century 
inside the chip, and the kernel treats it as invalid when it is read 
back.  (The times are out of range of a 32-bit Unix time.  I'm not sure 
if 64-bit Unix times from the RTC before 1970 are supported or not.)

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-

