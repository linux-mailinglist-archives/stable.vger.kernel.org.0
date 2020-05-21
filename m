Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC93E1DCFBE
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgEUObF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:31:05 -0400
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:23089 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727985AbgEUObF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:31:05 -0400
Received: from [192.168.42.210] ([93.22.132.254])
        by mwinf5d47 with ME
        id hSX12200Q5VUqNM03SX1Ps; Thu, 21 May 2020 16:31:02 +0200
X-ME-Helo: [192.168.42.210]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 21 May 2020 16:31:02 +0200
X-ME-IP: 93.22.132.254
Subject: Re: [PATCH 3.16 35/99] pxa168fb: Fix the function used to release
 some memory in an error handling path
From:   Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lubomir Rintel <lkundrak@v3.sk>
References: <lsq.1589984008.562400019@decadent.org.uk>
 <95e4cf2d-5f50-e7bd-6e1e-a1d172eb24b6@wanadoo.fr>
Message-ID: <104d4c9f-48d8-19b1-d529-a34fcc1e5606@wanadoo.fr>
Date:   Thu, 21 May 2020 16:31:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <95e4cf2d-5f50-e7bd-6e1e-a1d172eb24b6@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

sorry for the noise, I have messed up my 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ usage.
I thought I was looking at the 3.16.83 branch, but I was not.

The patch looks good to me.

CJ

Le 21/05/2020 à 16:09, Marion & Christophe JAILLET a écrit :
> Hi,
>
> I don't think that this one is applicable to 3.16.x
>
> The remove function and the error handling path of the probe function 
> both use 'dma_free_wc'.
> I've not look in details, but it looks consistent and the patch would 
> not apply as-is anyway.
>
> just my 2c.
>
> CJ
>
> Le 20/05/2020 à 16:14, Ben Hutchings a écrit :
>> 3.16.84-rc1 review patch.  If anyone has any objections, please let 
>> me know.
>>
>> ------------------
>>
>> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>
>> commit 3c911fe799d1c338d94b78e7182ad452c37af897 upstream.
>>
>> In the probe function, some resources are allocated using 
>> 'dma_alloc_wc()',
>> they should be released with 'dma_free_wc()', not 'dma_free_coherent()'.
>>
>> We already use 'dma_free_wc()' in the remove function, but not in the
>> error handling path of the probe function.
>>
>> Also, remove a useless 'PAGE_ALIGN()'. 'info->fix.smem_len' is already
>> PAGE_ALIGNed.
>>
>> Fixes: 638772c7553f ("fb: add support of LCD display controller on 
>> pxa168/910 (base layer)")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> Reviewed-by: Lubomir Rintel <lkundrak@v3.sk>
>> CC: YueHaibing <yuehaibing@huawei.com>
>> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>> Link: 
>> https://patchwork.freedesktop.org/patch/msgid/20190831100024.3248-1-christophe.jaillet@wanadoo.fr
>> [bwh: Backported to 3.16: Use dma_free_writecombine().]
>> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>> ---
>>   drivers/video/fbdev/pxa168fb.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> --- a/drivers/video/fbdev/pxa168fb.c
>> +++ b/drivers/video/fbdev/pxa168fb.c
>> @@ -772,8 +772,8 @@ failed_free_cmap:
>>   failed_free_clk:
>>       clk_disable(fbi->clk);
>>   failed_free_fbmem:
>> -    dma_free_coherent(fbi->dev, info->fix.smem_len,
>> -            info->screen_base, fbi->fb_start_dma);
>> +    dma_free_writecombine(fbi->dev, info->fix.smem_len,
>> +                  info->screen_base, fbi->fb_start_dma);
>>   failed_free_info:
>>       kfree(info);
>>   failed_put_clk:
>> @@ -809,7 +809,7 @@ static int pxa168fb_remove(struct platfo
>>         irq = platform_get_irq(pdev, 0);
>>   -    dma_free_writecombine(fbi->dev, PAGE_ALIGN(info->fix.smem_len),
>> +    dma_free_writecombine(fbi->dev, info->fix.smem_len,
>>                   info->screen_base, info->fix.smem_start);
>>         clk_disable(fbi->clk);
>>
