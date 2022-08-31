Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550EE5A7F3E
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 15:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiHaNuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 09:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiHaNux (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 09:50:53 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44799F18A;
        Wed, 31 Aug 2022 06:50:51 -0700 (PDT)
Received: from [IPV6:2405:201:10:389d:42df:ae4c:c047:294c] (unknown [IPv6:2405:201:10:389d:42df:ae4c:c047:294c])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: shreeya)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 2A19266015AB;
        Wed, 31 Aug 2022 14:50:47 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1661953850;
        bh=qrAOSFiudT5hLLoyAKQTuL5l0pWRMOhoiKTCH02kSHA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kXdIIWLqOs5QXlLV3w07O4cJu8gd8C0rqDl8/pEQKKypLt7mGZcancOeRqhM0rhEk
         J0nJw2iSCQ02phR2J7zdxvYih4ZhzgCiAP8MOat9djBjfSuRHwews2nujiKuAj+OI0
         F3Yk9IohyZb+eD83xQaPXpIwuPvu9XktfzQ9NnTg1bmRtM04W46XwYuBD+k+YfPQLD
         B/S37rhAFp3gORYibum6Lz+bOuUw0Z0J7bqjtMFsBPgx0IPGBMAlWp6qy9wWt+v3ZO
         yqMR+GR2wsRz51a/wWnzhwQEN1y6bxd5WfVQtp/MK3qJsmB0Ar3Z7ZlnITmBimfoL9
         DTTlysGxVe+jA==
Message-ID: <2bbbd71a-904f-2bdf-8dda-f699e38265f8@collabora.com>
Date:   Wed, 31 Aug 2022 19:20:38 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2] iio: light: tsl2583: Fix module unloading
Content-Language: en-US
To:     Jonathan Cameron <jic23@kernel.org>
Cc:     lars@metafoo.de, krisman@collabora.com,
        dmitry.osipenko@collabora.com, kernel@collabora.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220826122352.288438-1-shreeya.patel@collabora.com>
 <20220828173327.7949ad73@jic23-huawei>
From:   Shreeya Patel <shreeya.patel@collabora.com>
In-Reply-To: <20220828173327.7949ad73@jic23-huawei>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 28/08/22 22:03, Jonathan Cameron wrote:
> On Fri, 26 Aug 2022 17:53:52 +0530
> Shreeya Patel <shreeya.patel@collabora.com> wrote:
>
>> tsl2583 uses devm_iio_device_register() function and
>> calling iio_device_unregister() in remove breaks the
>> module unloading.
>> Fix this by using iio_device_register() instead of
>> devm_iio_device_register() function in probe.
> Not sure why you are wrapping at 55 chars. I rewrapped this whilst applying.
>
> Reworded it a little too as I was touching it anyway.
>
> Applied to the fixes-togreg branch of iio.git.
>
>> Cc: stable@vger.kernel.org
>> Fixes: 371894f5d1a0 ("iio: tsl2583: add runtime power management support")
> I took a look at this patch and it introduces the issue I just pointed
> out in replying to your v1 by dropping the
> /* Make sure the chip is on */
> Which was correct even with runtime pm because it covered the case of
> runtime_pm being disabled.   We probably need to bring that back as well,
> perhaps as part of a cleanup patch taking this fully devm_

Hi Jonathan,

I can work on fixing some of the issues with this driver in my free time.
Thanks for taking a look at the patch and letting me know.

FYI, I am also planning to work on ADT7316 driver to move out of staging.
I have the adt7516 eval board with me which I'll be using for testing.


Thanks,
Shreeya Patel

> This driver has another issue for working if runtime PM isn't built into
> the kernel which is that it checks the return of pm_runtime_put_autosuspend()
> which calls
>
> static inline int __pm_runtime_suspend(struct device *dev, int rpmflags)
> {
> 	return -ENOSYS;
> }
>
> I've been meaning to do an audit for drivers that have this problem for
> a while, but not yet gotten to it.
>
> An ideal IIO driver needs to work correctly whether or not CONFIG_PM is
> enabled.
>
> Jonathan
>
>
>> Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
>> ---
>> Changes in v2
>>    - Use iio_device_register() instead of devm_iio_device_register()
>>    - Add fixes and stable tags
>>
>>   drivers/iio/light/tsl2583.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/iio/light/tsl2583.c b/drivers/iio/light/tsl2583.c
>> index 82662dab87c0..94d75ec687c3 100644
>> --- a/drivers/iio/light/tsl2583.c
>> +++ b/drivers/iio/light/tsl2583.c
>> @@ -858,7 +858,7 @@ static int tsl2583_probe(struct i2c_client *clientp,
>>   					 TSL2583_POWER_OFF_DELAY_MS);
>>   	pm_runtime_use_autosuspend(&clientp->dev);
>>   
>> -	ret = devm_iio_device_register(indio_dev->dev.parent, indio_dev);
>> +	ret = iio_device_register(indio_dev);
>>   	if (ret) {
>>   		dev_err(&clientp->dev, "%s: iio registration failed\n",
>>   			__func__);
>
