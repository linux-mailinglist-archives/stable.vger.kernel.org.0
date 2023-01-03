Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6E165C11D
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 14:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237500AbjACNtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 08:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237436AbjACNtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 08:49:00 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B22BF6E;
        Tue,  3 Jan 2023 05:48:59 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 4E4D641F72;
        Tue,  3 Jan 2023 13:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1672753737; bh=8n36c0uhPa4GCq6GVU7dGRSTlMsuFomxAw3sKvckInY=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To;
        b=N4WeXIoirWV56nCuevFVZCXoBP7Bhe5UCd8MonyZBTYWqe4d+y1+1vpD6DtlP2Lcz
         8V8bUAMNVqiPX2nDmloA7C4nHLZj6xQDZgr2yTVK7VTVPheNAk2iOXNhuLCFiP6eug
         FFZZpYD++qHNUajSW4LXk3gndefvulixTChPJlqDl1AnJ1Tf8VDQbxLg2qzbuhVxYz
         mr/D0AyZIJuFk+4WpE0ZOwx0eIARXniRjd5D95enrDhLeh/7EEc61MOXHcUvJBGafS
         3SZhNdF38qS35kP0Mr7JGphCs69D/NGer8dkoiYbTRMLDTE/txEqUoCnYupPmJbmkN
         0QN+DAl4xH0Iw==
Message-ID: <95a4cfde-490f-d26d-163e-7ab1400e7380@marcan.st>
Date:   Tue, 3 Jan 2023 22:48:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Eric Curtin <ecurtin@redhat.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
References: <20230103114427.1825-1-marcan@marcan.st>
 <ff77ba1c-8b67-4697-d713-0392d3b1d77a@linaro.org>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH v2] nvmem: core: Fix race in nvmem_register()
In-Reply-To: <ff77ba1c-8b67-4697-d713-0392d3b1d77a@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/01/2023 21.41, Srinivas Kandagatla wrote:
> 
> 
> On 03/01/2023 11:44, Hector Martin wrote:
>> nvmem_register() currently registers the device before adding the nvmem
>> cells, which creates a race window where consumers may find the nvmem
>> device (and not get PROBE_DEFERred), but then fail to find the cells and
>> error out.
>>
>> Move device registration to the end of nvmem_register(), to close the
>> race.
>>
>> Observed when the stars line up on Apple Silicon machines with the (not
>> yet upstream, but trivial) spmi nvmem driver and the macsmc-rtc client:
>>
>> [    0.487375] macsmc-rtc macsmc-rtc: error -ENOENT: Failed to get rtc_offset NVMEM cell
>>
>> Fixes: eace75cfdcf7 ("nvmem: Add a simple NVMEM framework for nvmem providers")
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Eric Curtin <ecurtin@redhat.com>
>> Signed-off-by: Hector Martin <marcan@marcan.st>
>> ---
> 
> What has changed since v1?

What you told me to. I'm trying to get a silly bug fixed after you
ignored my original patch until Russell independently discovered and
submitted a fix for the same thing. I think we've wasted enough
developer time here already.

> 
>>   drivers/nvmem/core.c | 32 +++++++++++++++++---------------
>>   1 file changed, 17 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
>> index 321d7d63e068..606f428d6292 100644
>> --- a/drivers/nvmem/core.c
>> +++ b/drivers/nvmem/core.c
>> @@ -822,11 +822,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
>>   		break;
>>   	}
>>
>> -	if (rval) {
>> -		ida_free(&nvmem_ida, nvmem->id);
>> -		kfree(nvmem);
>> -		return ERR_PTR(rval);
>> -	}
>> +	if (rval)
>> +		goto err_gpiod_put;
> 
> Why was gpiod changes added to this patch, that should be a separate 
> patch/discussion, as this is not relevant to the issue that you are 
> reporting.

Because freeing the device also does a gpiod_put in the destructor, so
doing this is correct in every other instance below and maintains
existing behavior, and it just so happens that this instance converges
into the same codepath so it is correct to merge it, and it just so
happens that the gpiod put was missing in this path to begin with so
this becomes a drive-by bugfix.

If you don't like it I can remove it (i.e. reintroduce the bug for no
good reason) and you can submit this fix yourself, because I have no
incentive to waste time submitting a separate patch to fix a GPIO leak
in an error path corner case in a subsystem I don't own and I have much
bigger things to spend my (increasingly lower and lower) willingness to
fight for upstream submissions than this.

Seriously, what is wrong with y'all kernel people. No other open source
project wastes contributors' time with stupid nitpicks like this. I
found a bug, I fixed it, I then fixed the issues you pointed out, and I
don't have the time nor energy to fight over this kind of nonsense next.
Do you want bugs fixed or not?

>>
>>   	nvmem->read_only = device_property_present(config->dev, "read-only") ||
>>   			   config->read_only || !nvmem->reg_write;
>> @@ -837,20 +834,16 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
>>
>>   	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
>>
>> -	rval = device_register(&nvmem->dev);
>> -	if (rval)
>> -		goto err_put_device;
>> -
>>   	if (nvmem->nkeepout) {
>>   		rval = nvmem_validate_keepouts(nvmem);
>>   		if (rval)
>> -			goto err_device_del;
>> +			goto err_gpiod_put;
>>   	}
>>
>>   	if (config->compat) {
>>   		rval = nvmem_sysfs_setup_compat(nvmem, config);
>>   		if (rval)
>> -			goto err_device_del;
>> +			goto err_gpiod_put;
>>   	}
>>
>>   	if (config->cells) {
>> @@ -867,6 +860,15 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
>>   	if (rval)
>>   		goto err_remove_cells;
>>
>> +	rval = device_register(&nvmem->dev);
>> +	if (rval) {
>> +		nvmem_device_remove_all_cells(nvmem);
>> +		if (config->compat)
>> +			nvmem_sysfs_remove_compat(nvmem, config);
>> +		put_device(&nvmem->dev);
>> +		return ERR_PTR(rval);
>> +	}
>> +
>>   	blocking_notifier_call_chain(&nvmem_notifier, NVMEM_ADD, nvmem);
>>
>>   	return nvmem;
>> @@ -876,10 +878,10 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
>>   err_teardown_compat:
>>   	if (config->compat)
>>   		nvmem_sysfs_remove_compat(nvmem, config);
>> -err_device_del:
>> -	device_del(&nvmem->dev);
>> -err_put_device:
>> -	put_device(&nvmem->dev);
>> +err_gpiod_put:
>> +	gpiod_put(nvmem->wp_gpio);
>> +	ida_free(&nvmem_ida, nvmem->id);
>> +	kfree(nvmem);
>>
>>   	return ERR_PTR(rval);
>>   }
>> --
>> 2.35.1
>>
> 


- Hector
