Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7D7364D7E
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 00:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhDSWHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 18:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhDSWHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 18:07:21 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B90C06174A
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 15:06:51 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id u16so19699211oiu.7
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 15:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hvkdFKwxBitYVV/su1cCNWAnDNUCJkj8yx9FW2pWWVw=;
        b=W3o8oHMGscEs2UH//4tfAPnlj4iZ8q+MRhH/a6ceCwPErxw4I5IbEagdkqO3QhrMFI
         gMWRsTGHemy8V9MMlhXnKvNqNtvx72lkMhEHTnBvx2JiowirZ0Dzif5vy7HfZkks3DFU
         56FXs0iA/Z+gSyJoymJAZEOLpMV4A9/mMlMbU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hvkdFKwxBitYVV/su1cCNWAnDNUCJkj8yx9FW2pWWVw=;
        b=oaZL6N9Hzp9P3QONU8fBafogmntk7pLzYXnzAZfT6NS+NAVulyJzPRLaCDTQI31Aof
         s4qSE6vswaWDW9jpsPysiWwy22cxM5TJZB7NwjH/QvPlUpVUaFrrzl3QK5XqRUeFZG/L
         qfys0OHO1F2GOTOFS64owPlBvAvzc7ffCY6Pq6peg9rspb7tShzMEy8h7sQfXc7itse9
         GwAQv7Fmbv0hYfhO0Q75C7eKX8e33o8/xezLG+VQ3C8Gyl77bzrPhIYhNaHl9Bb7RDpl
         AJfCeUqYRlJHl5OMqII93a+HNFir4G5j7SIa/9Rk0KZMGQqkhnwZTJ+EPNnfh1isqy3P
         qnYw==
X-Gm-Message-State: AOAM532Ey1Kf5o82yRfvk0MIblLGlklpk692hUnsp+/jgnFfd6GnbRCN
        dxIla+qvjzoSC87KpQ0BuNz5Gg==
X-Google-Smtp-Source: ABdhPJz4LARCuwJDr2q66eT+KmlcZlH2OT/7XHZeWnAUq02qRyhTVJqkcz8P05Nbhe37we1Vhqwilg==
X-Received: by 2002:a05:6808:13d0:: with SMTP id d16mr851849oiw.169.1618870011032;
        Mon, 19 Apr 2021 15:06:51 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x24sm1701356otk.16.2021.04.19.15.06.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 15:06:50 -0700 (PDT)
Subject: Re: [PATCH] usbip: Fix incorrect double assignment to udc->ud.tcp_rx
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Tom Seewald <tseewald@gmail.com>, stable@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210412185902.27755-1-tseewald@gmail.com>
 <f3e734e4-afc2-4d7c-8d02-714935b45764@linuxfoundation.org>
 <YH121CyWCD18M3hA@kroah.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8726436e-49ab-df18-724f-d87625949773@linuxfoundation.org>
Date:   Mon, 19 Apr 2021 16:06:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YH121CyWCD18M3hA@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/19/21 6:25 AM, Greg Kroah-Hartman wrote:
> On Fri, Apr 16, 2021 at 09:32:35AM -0600, Shuah Khan wrote:
>> On 4/12/21 12:59 PM, Tom Seewald wrote:
>>> commit 9858af27e69247c5d04c3b093190a93ca365f33d upstream.
>>>
>>> Currently udc->ud.tcp_rx is being assigned twice, the second assignment
>>> is incorrect, it should be to udc->ud.tcp_tx instead of rx. Fix this.
>>>
>>> Fixes: 46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races leading to gpf")
>>> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>> Cc: stable <stable@vger.kernel.org>
>>> Addresses-Coverity: ("Unused value")
>>> Link: https://lore.kernel.org/r/20210311104445.7811-1-colin.king@canonical.com
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Signed-off-by: Tom Seewald <tseewald@gmail.com>
>>> ---
>>>    drivers/usb/usbip/vudc_sysfs.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
>>> index f44d98eeb36a..51cc5258b63e 100644
>>> --- a/drivers/usb/usbip/vudc_sysfs.c
>>> +++ b/drivers/usb/usbip/vudc_sysfs.c
>>> @@ -187,7 +187,7 @@ static ssize_t store_sockfd(struct device *dev,
>>>    		udc->ud.tcp_socket = socket;
>>>    		udc->ud.tcp_rx = tcp_rx;
>>> -		udc->ud.tcp_rx = tcp_tx;
>>> +		udc->ud.tcp_tx = tcp_tx;
>>>    		udc->ud.status = SDEV_ST_USED;
>>>    		spin_unlock_irq(&udc->ud.lock);
>>>
>>
>> Greg,
>>
>> Please pick this up for 4.9 and 4.14
> 
> Why?  The commit it says it fixes, 46613c9dfa96 ("usbip: fix vudc
> usbip_sockfd_store races leading to gpf"), is not in any kernel older
> than 4.19.y at the moment.
> 

Tom back ported this one a couple of weeks ago to 4.14.y and 4.9.y

I see this commit in 4.14 (checked on 4.14.231)
e9c1341b4c948c20f030b6b146fa82575e2fc37b


I see this commit in 4.9.267 as well.

fe9e15a30be666ec8071f325a39fe13e2251b51d

This fix can go on top of these commits.

thanks,
-- Shuah

