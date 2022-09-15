Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEEB5BA0F3
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 20:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiIOSsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 14:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiIOSsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 14:48:12 -0400
Received: from smtp.smtpout.orange.fr (smtp05.smtpout.orange.fr [80.12.242.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B229A955
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 11:48:08 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id Ytu9odoZWiBgAYtu9oYJpl; Thu, 15 Sep 2022 20:48:06 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 15 Sep 2022 20:48:06 +0200
X-ME-IP: 90.11.190.129
Message-ID: <92e8f14b-04f4-88a1-6071-fc87117ba5a1@wanadoo.fr>
Date:   Thu, 15 Sep 2022 20:48:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Patch "hwmon: (pmbus) Use dev_err_probe() to filter -EPROBE_DEFER
 error messages" has been added to the 5.10-stable tree
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <jdelvare@suse.com>
References: <20220915124557.591485-1-sashal@kernel.org>
From:   Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220915124557.591485-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Le 15/09/2022 à 14:45, Sasha Levin a écrit :
> This is a note to let you know that I've just added the patch titled
>
>      hwmon: (pmbus) Use dev_err_probe() to filter -EPROBE_DEFER error messages
>
> to the 5.10-stable tree which can be found at:
>      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>       hwmon-pmbus-use-dev_err_probe-to-filter-eprobe_defer.patch
> and it can be found in the queue-5.10 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
>
Hi,

I'm not sure that this one makes a real sense for backport.

It can't hurt, but it does not fix a real issue, it just voids a 
potential spurious message.

In my original mail, there is no "stable@" or "fix" or "bug" keywords or 
"Fixes:" tag.
There is also apparently no patch in this backport serie that relies on 
this patch.

Why has it been selected?

(same for 5.15 and 5.19)

CJ


>
> commit d20abd39a7843f50e07b6487c205d775f3361ac1
> Author: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Date:   Wed Aug 17 15:04:00 2022 +0200
>
>      hwmon: (pmbus) Use dev_err_probe() to filter -EPROBE_DEFER error messages
>      
>      [ Upstream commit 09e52d17b72d3a4bf6951a90ccd8c97fae04e5cf ]
>      
>      devm_regulator_register() can return -EPROBE_DEFER, so better use
>      dev_err_probe() instead of dev_err(), it is less verbose in such a case.
>      
>      It is also more informative, which can't hurt.
>      
>      Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>      Link: https://lore.kernel.org/r/3adf1cea6e32e54c0f71f4604b4e98d992beaa71.1660741419.git.christophe.jaillet@wanadoo.fr
>      Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>      Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
> index 117e3ce9c76ad..6d8ace96b0a73 100644
> --- a/drivers/hwmon/pmbus/pmbus_core.c
> +++ b/drivers/hwmon/pmbus/pmbus_core.c
> @@ -2322,11 +2322,10 @@ static int pmbus_regulator_register(struct pmbus_data *data)
>   
>   		rdev = devm_regulator_register(dev, &info->reg_desc[i],
>   					       &config);
> -		if (IS_ERR(rdev)) {
> -			dev_err(dev, "Failed to register %s regulator\n",
> -				info->reg_desc[i].name);
> -			return PTR_ERR(rdev);
> -		}
> +		if (IS_ERR(rdev))
> +			return dev_err_probe(dev, PTR_ERR(rdev),
> +					     "Failed to register %s regulator\n",
> +					     info->reg_desc[i].name);
>   	}
>   
>   	return 0;
