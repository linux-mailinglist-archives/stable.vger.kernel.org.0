Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8619135D176
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 21:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237848AbhDLTu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 15:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237406AbhDLTu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 15:50:27 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E55EC061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 12:50:09 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id c3so5987457ils.5
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 12:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U8V+SQQ2oxdowqY3VA2h5BAZHsYF3xTADFxaCRfNN2U=;
        b=AgVvOGCrBuWV7tIznQr5JstSKcSWmaiJTlj+VXDNp12mIGq6MdtxtozdL3eNq1wOnm
         a8KalA4YC++F7+OqAUG4viRTP7A3CCxRRsGdTOBtQq2Nq6n5ymlHB78yB0NckyFatFpg
         fXxMzvjECXL/Q7f5jamFYTmFw7o9C9CDaXx3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U8V+SQQ2oxdowqY3VA2h5BAZHsYF3xTADFxaCRfNN2U=;
        b=FtF2XunQrSiMoQRuaFKlfY9lR/wqFBIIYQHNTlAPQ86uIjTR9567teurrmezm0pstg
         QjQi7j6L/U9gO76z3dXURhoyPSaD/g2sVL0PlzSM13LygSgcGPgO0F8TMr5fKV/azbPu
         qG+suNk/Avn3SDqj0ZpbmpLAzrhDkKZL9H5uXHUrXWq2J8FHb2Xe/JBWu8u6B15E0mRz
         SxPlZyw2yI/RUVc40ea8q2KMRFU+ywHLSgIkJRf0vyVMKSNI/nR6NMzl1SEPtovaSJxb
         DsnNBtDMXvWtyDls6R0sBoQmEpqThkFE2mp+1Ga2oLCCqo069FW6Nv42qOpDU/pf1m/O
         eNmg==
X-Gm-Message-State: AOAM5337xBWPnDjBDB3i2S+jQziHCKz33guQrg9D0B8LAve2Ru+Scr9O
        0/zCJyiA1kO5Ytr+MXxQGsPGAg==
X-Google-Smtp-Source: ABdhPJzINtlkSIrjvehiCFFPVdi6AvqWKtRoOcvGek1eq3VBcrUuzTc341d5qACxxnmFIXDnWemXSg==
X-Received: by 2002:a92:6e0e:: with SMTP id j14mr24207663ilc.90.1618257008866;
        Mon, 12 Apr 2021 12:50:08 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id f9sm5853015iol.23.2021.04.12.12.50.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 12:50:08 -0700 (PDT)
Subject: Re: [PATCH] usbip: Fix incorrect double assignment to udc->ud.tcp_rx
To:     Tom Seewald <tseewald@gmail.com>, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210412185902.27755-1-tseewald@gmail.com>
 <4fc29f02-2284-70a2-2995-407f5c45b11f@gmail.com>
 <0a4197a2-d417-dca5-20fe-908bb5e76b55@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <108528e1-da05-19c0-a189-4ec4a69166ef@linuxfoundation.org>
Date:   Mon, 12 Apr 2021 13:50:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <0a4197a2-d417-dca5-20fe-908bb5e76b55@linuxfoundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/21 1:25 PM, Shuah Khan wrote:
> On 4/12/21 1:06 PM, Tom Seewald wrote:
>> On 4/12/21 1:59 PM, Tom Seewald wrote:
>>
>>> commit 9858af27e69247c5d04c3b093190a93ca365f33d upstream.
>>>
>>> Currently udc->ud.tcp_rx is being assigned twice, the second assignment
>>> is incorrect, it should be to udc->ud.tcp_tx instead of rx. Fix this.
>>>
>>> Fixes: 46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races 
>>> leading to gpf")
>>> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>> Cc: stable <stable@vger.kernel.org>
>>> Addresses-Coverity: ("Unused value")
>>> Link: 
>>> https://lore.kernel.org/r/20210311104445.7811-1-colin.king@canonical.com
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Signed-off-by: Tom Seewald <tseewald@gmail.com>
>>> ---
>>>   drivers/usb/usbip/vudc_sysfs.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/usb/usbip/vudc_sysfs.c 
>>> b/drivers/usb/usbip/vudc_sysfs.c
>>> index f44d98eeb36a..51cc5258b63e 100644
>>> --- a/drivers/usb/usbip/vudc_sysfs.c
>>> +++ b/drivers/usb/usbip/vudc_sysfs.c
>>> @@ -187,7 +187,7 @@ static ssize_t store_sockfd(struct device *dev,
>>>           udc->ud.tcp_socket = socket;
>>>           udc->ud.tcp_rx = tcp_rx;
>>> -        udc->ud.tcp_rx = tcp_tx;
>>> +        udc->ud.tcp_tx = tcp_tx;
>>>           udc->ud.status = SDEV_ST_USED;
>>>           spin_unlock_irq(&udc->ud.lock);
>> I sent this because I believe this patch needs to be backported to the
>> 4.9.y and 4.14.y stable trees.
>>
> 
> Tom,
> 
> Correct. This needs proting to 4.14 and 4.9. However, you have to also
> backport the patch it fixes to 4.14 and 4.9
> 
> 46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races leading to gpf")
> 

Sorry for the noise. I see this patch fro you and that it was pulled in.

> You can combine the two patches when you backport to 4.14 and 4.9 and
> add both upstream commits in the change log.
> 

No need to combine. Thanks for backport.

thanks,
-- Shuah

