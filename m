Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C1965C2CB
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 16:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbjACPOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 10:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbjACPOR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 10:14:17 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19640FAC2;
        Tue,  3 Jan 2023 07:14:16 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 65CA641F72;
        Tue,  3 Jan 2023 15:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1672758854; bh=1PSEtOTX/u4zPRzwJty5aY47xeibawU7cSRmZalIq0s=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To;
        b=PCr0/NgFTVxGU9raXFFVI2266XRVCHaknQA7vpdbmUXaotZuJwwnC8nkcZXMK2nEl
         mxmFHfr5PFqfMLQ8LurLxeni2a+4gGZ7w4GmWARXg1pvzk1MLKVnW1TKHM4SG4P2rs
         VGk9SvJ/Z4nOroH0eYutwJn1mTE6U9X3GUqq/hb5MWQOH4SZ6fuN58S3FS1G9uDSe5
         wNhnSQVZ8eUx6J9IFxFjdb3awmh+6qsNreu40Ikfd19MoAqxI/hFgGtINV1ObQ158/
         z0YRWCVva3++ezXNZqcOjAiGtt2ZhQUNTZq12zb+Y2ofFXeZ59gguwX/azbx4xP29P
         HULXsWro1YBAw==
Message-ID: <ec2c2712-04fa-751d-9817-23ff4e0b7fb4@marcan.st>
Date:   Wed, 4 Jan 2023 00:14:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Eric Curtin <ecurtin@redhat.com>
References: <20230103114427.1825-1-marcan@marcan.st>
 <ff77ba1c-8b67-4697-d713-0392d3b1d77a@linaro.org>
 <95a4cfde-490f-d26d-163e-7ab1400e7380@marcan.st>
 <Y7REcpXjxTlxv1Fp@shell.armlinux.org.uk>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH v2] nvmem: core: Fix race in nvmem_register()
In-Reply-To: <Y7REcpXjxTlxv1Fp@shell.armlinux.org.uk>
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

On 04/01/2023 00.06, Russell King (Oracle) wrote:
> Hi Hector,
> 
> On Tue, Jan 03, 2023 at 10:48:52PM +0900, Hector Martin wrote:
>>>> @@ -822,11 +822,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
>>>>   		break;
>>>>   	}
>>>>
>>>> -	if (rval) {
>>>> -		ida_free(&nvmem_ida, nvmem->id);
>>>> -		kfree(nvmem);
>>>> -		return ERR_PTR(rval);
>>>> -	}
>>>> +	if (rval)
>>>> +		goto err_gpiod_put;
>>>
>>> Why was gpiod changes added to this patch, that should be a separate 
>>> patch/discussion, as this is not relevant to the issue that you are 
>>> reporting.
>>
>> Because freeing the device also does a gpiod_put in the destructor, so
>> doing this is correct in every other instance below and maintains
>> existing behavior, and it just so happens that this instance converges
>> into the same codepath so it is correct to merge it, and it just so
>> happens that the gpiod put was missing in this path to begin with so
>> this becomes a drive-by bugfix.
>>
>> If you don't like it I can remove it (i.e. reintroduce the bug for no
>> good reason) and you can submit this fix yourself, because I have no
>> incentive to waste time submitting a separate patch to fix a GPIO leak
>> in an error path corner case in a subsystem I don't own and I have much
>> bigger things to spend my (increasingly lower and lower) willingness to
>> fight for upstream submissions than this.
>>
>> Seriously, what is wrong with y'all kernel people. No other open source
>> project wastes contributors' time with stupid nitpicks like this. I
>> found a bug, I fixed it, I then fixed the issues you pointed out, and I
>> don't have the time nor energy to fight over this kind of nonsense next.
>> Do you want bugs fixed or not?
> 
> This is not nonsense. We have always had a policy of one fix/change
> per patch, and in this case it makes complete and utter sense. Of
> course, the interpretation of "one change" is a matter of opinion.

The change here is the race condition fix. That change involves adding
an error cleanup path that involves a gpio_put(). Therefore it seems
logical to actually use it in that one extra case that should've used it
anyway, a few lines above.

Now,

> 
> Your patch contains two bug fixes for problems:
> 1) publication of nvmem_device before it's fully setup (leading to the
>    race) which has been around since the inception of nvmem stuff.
> 2) fixing a memory leak for gpiod stuff, caused by a recent patch
>    5544e90c8126 ("nvmem: core: add error handling for dev_set_name")
>    from September 2022.

That's a fair argument for having two patches (I didn't know the gpiod
leak was introduced later). However, the backport is nontrivial anyway
if you want clean code, because if we merge the codepaths the fix would
end up being different in backports and mainline. Which means we now
need 3 patches for them to apply properly. Which is more effort than I'm
willing to put in for an issue I don't care about.

But the bigger problem is that this isn't what Srini replied with, he's
now saying my patch is outright broken, and I'm tired of this nonsense.

- Hector
