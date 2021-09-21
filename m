Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAAA413853
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 19:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhIURd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 13:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhIURdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 13:33:03 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55D9C061574;
        Tue, 21 Sep 2021 10:31:33 -0700 (PDT)
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 77B4F832AD;
        Tue, 21 Sep 2021 19:31:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1632245489;
        bh=e+yPbo4fafWFxb6MVPrE7e9eDwpFOH2agg9WR2G9PLk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=AlEDMZm4EdAkkgDdttyNxp5kAZ+Q57nOZbBsHYjeRADT28QaHSFtV6AytjRu3crly
         KSfcOUuMPo2EV8U7nPJOmJHYWvHSqneQOZWlLyat7CjGFyVuZj9z8Mnt77DkvNMaDT
         C8KSD9ueULP4oGjlVr5zc2QP2UV/q5ZCkabAWauyRo8y09q51zu+4AnGDT5xZndoHu
         jD5IzMPxTrujqdq2jxV0sZgLkFldwWbSdGc24ofFGeoF9P8X1h0wamfGR8R8PVrPUV
         6bdse02Gz/D4x3ssiBr5tfEzFdz8SKADvKoGJhGJF3XY4kHX6aZ38hl+x3+MJSoGuS
         l/BUXhJspBrig==
Subject: Re: [PATCH V2] video: backlight: Drop maximum brightness override for
 brightness zero
To:     Lee Jones <lee.jones@linaro.org>
Cc:     dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        stable@vger.kernel.org,
        Meghana Madhyastha <meghana.madhyastha@gmail.com>,
        Sean Paul <seanpaul@chromium.org>,
        Thierry Reding <treding@nvidia.com>,
        Sam Ravnborg <sam@ravnborg.org>
References: <20210713191633.121317-1-marex@denx.de>
 <072e01b7-8554-de4f-046a-da11af3958d6@denx.de> <YUnfIFllpOMnie4l@google.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <3799d8fe-0ff3-f3df-e963-b40d825f8e95@denx.de>
Date:   Tue, 21 Sep 2021 19:31:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YUnfIFllpOMnie4l@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/21/21 3:33 PM, Lee Jones wrote:
> On Sat, 11 Sep 2021, Marek Vasut wrote:
> 
>> On 7/13/21 9:16 PM, Marek Vasut wrote:
>>> The note in c2adda27d202f ("video: backlight: Add of_find_backlight helper
>>> in backlight.c") says that gpio-backlight uses brightness as power state.
>>> This has been fixed since in ec665b756e6f7 ("backlight: gpio-backlight:
>>> Correct initial power state handling") and other backlight drivers do not
>>> require this workaround. Drop the workaround.
>>>
>>> This fixes the case where e.g. pwm-backlight can perfectly well be set to
>>> brightness 0 on boot in DT, which without this patch leads to the display
>>> brightness to be max instead of off.
>>>
>>> Fixes: c2adda27d202f ("video: backlight: Add of_find_backlight helper in backlight.c")
>>> Acked-by: Noralf Trønnes <noralf@tronnes.org>
>>> Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
>>> Cc: <stable@vger.kernel.org> # 5.4+
>>> Cc: <stable@vger.kernel.org> # 4.19.x: ec665b756e6f7: backlight: gpio-backlight: Correct initial power state handling
>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>> Cc: Daniel Thompson <daniel.thompson@linaro.org>
>>> Cc: Meghana Madhyastha <meghana.madhyastha@gmail.com>
>>> Cc: Noralf Trønnes <noralf@tronnes.org>
>>> Cc: Sean Paul <seanpaul@chromium.org>
>>> Cc: Thierry Reding <treding@nvidia.com>
>>> ---
>>> V2: Add AB/RB, CC stable
>>> ---
>>>    drivers/video/backlight/backlight.c | 6 ------
>>>    1 file changed, 6 deletions(-)
>>>
>>> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
>>> index 537fe1b376ad7..fc990e576340b 100644
>>> --- a/drivers/video/backlight/backlight.c
>>> +++ b/drivers/video/backlight/backlight.c
>>> @@ -688,12 +688,6 @@ static struct backlight_device *of_find_backlight(struct device *dev)
>>>    			of_node_put(np);
>>>    			if (!bd)
>>>    				return ERR_PTR(-EPROBE_DEFER);
>>> -			/*
>>> -			 * Note: gpio_backlight uses brightness as
>>> -			 * power state during probe
>>> -			 */
>>> -			if (!bd->props.brightness)
>>> -				bd->props.brightness = bd->props.max_brightness;
>>>    		}
>>>    	}
>>>
>>
>> Any news on this ?
>>
>> Expanding CC list.
> 
> Looks like I was left off of the original submission.
> 
> I can't apply a quoted patch.  Please re-submit.

I see. It seems the patch is available in both Lore and Patchwork:

https://lore.kernel.org/all/072e01b7-8554-de4f-046a-da11af3958d6@denx.de/T/

https://patchwork.freedesktop.org/patch/443823/
