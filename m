Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC2235E26A
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 17:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241439AbhDMPNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 11:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhDMPNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 11:13:36 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F764C061574
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 08:13:15 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id j26so17393987iog.13
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 08:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HDhrWlT81BJwp2zqeb/NNu8YaIEms7HozQSjto4jdwE=;
        b=W2FEKVJVyz/ivVz8w7vvenisPKJQbqnSW2lsjEDLcGF9bkRLcj0QzTuJ+jOKNoP2+A
         q0Szcrq23dZXV3kf+ZgtS+w0KcYpolQfrQddZGQSP92ECXuPKaY2CTirinfAAmPszcHi
         VGQEvRML5PnC+/xWIliUX+2xctO0YTopthDAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HDhrWlT81BJwp2zqeb/NNu8YaIEms7HozQSjto4jdwE=;
        b=RyDc+AzMAlGB3g45eAwCVG3V8AEwnltpacQMBBy2E3FPgMwTzU58z/7R6baPj6fPAm
         T99OImBo4wjf+PGTtLc3a027Hu5V62mxjcDse3wEFT0qR2UG9pCIcDxxdb8SXGFruH/A
         QprA591LEPpYVFsDsjt8Y6iAvb0/jgylWP0J5smhKoeIvRIPOr8NNJi9hvsDDANKemEC
         zcNRObw8gAW28WCtfB/P30i31RfeLyaMbCiLBVx0Wchayq1p9PUUfFLJNDpzLxqWXJB9
         zASiMQA5iNAfJLQnFTRTieT1296S/Q/BP0eTiRNIptf6zKq/vNWVXkTolR4ecXs4f7uq
         q6qg==
X-Gm-Message-State: AOAM533jfCFEpHwlV1JPLs9UMQfGZXnjq7ZL3ZjtfE6Tk2HSEX3wqunt
        i5Ikw+PLBd6ymVrURlB0WOq4HGl1t5u3Sw==
X-Google-Smtp-Source: ABdhPJy4x1LASNj9wiWXIGxyn3D90Dy6zSWZCVJ2Ny1jKE5LxC5DO3usoaNSnToXYrUbbEPBg5LdZg==
X-Received: by 2002:a02:211c:: with SMTP id e28mr11861981jaa.39.1618326794918;
        Tue, 13 Apr 2021 08:13:14 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g26sm6921906iom.14.2021.04.13.08.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 08:13:14 -0700 (PDT)
Subject: Re: [PATCH] usbip: Fix incorrect double assignment to udc->ud.tcp_rx
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Tom Seewald <tseewald@gmail.com>, stable@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210412185902.27755-1-tseewald@gmail.com>
 <4fc29f02-2284-70a2-2995-407f5c45b11f@gmail.com>
 <0a4197a2-d417-dca5-20fe-908bb5e76b55@linuxfoundation.org>
 <YHVIeWbZCu7RvQmM@kroah.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <dee26352-9911-c046-41ba-c992cb2f38f7@linuxfoundation.org>
Date:   Tue, 13 Apr 2021 09:13:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YHVIeWbZCu7RvQmM@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/13/21 1:30 AM, Greg Kroah-Hartman wrote:
> On Mon, Apr 12, 2021 at 01:25:20PM -0600, Shuah Khan wrote:
>> On 4/12/21 1:06 PM, Tom Seewald wrote:
>>> On 4/12/21 1:59 PM, Tom Seewald wrote:
>>>
>>>> commit 9858af27e69247c5d04c3b093190a93ca365f33d upstream.
>>>>
>>>> Currently udc->ud.tcp_rx is being assigned twice, the second assignment
>>>> is incorrect, it should be to udc->ud.tcp_tx instead of rx. Fix this.
>>>>
>>>> Fixes: 46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races leading to gpf")
>>>> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
>>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>>> Cc: stable <stable@vger.kernel.org>
>>>> Addresses-Coverity: ("Unused value")
>>>> Link: https://lore.kernel.org/r/20210311104445.7811-1-colin.king@canonical.com
>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>> Signed-off-by: Tom Seewald <tseewald@gmail.com>
>>>> ---
>>>>    drivers/usb/usbip/vudc_sysfs.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
>>>> index f44d98eeb36a..51cc5258b63e 100644
>>>> --- a/drivers/usb/usbip/vudc_sysfs.c
>>>> +++ b/drivers/usb/usbip/vudc_sysfs.c
>>>> @@ -187,7 +187,7 @@ static ssize_t store_sockfd(struct device *dev,
>>>>    		udc->ud.tcp_socket = socket;
>>>>    		udc->ud.tcp_rx = tcp_rx;
>>>> -		udc->ud.tcp_rx = tcp_tx;
>>>> +		udc->ud.tcp_tx = tcp_tx;
>>>>    		udc->ud.status = SDEV_ST_USED;
>>>>    		spin_unlock_irq(&udc->ud.lock);
>>> I sent this because I believe this patch needs to be backported to the
>>> 4.9.y and 4.14.y stable trees.
>>>
>>
>> Tom,
>>
>> Correct. This needs proting to 4.14 and 4.9. However, you have to also
>> backport the patch it fixes to 4.14 and 4.9
>>
>> 46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races leading to gpf")
>>
>> You can combine the two patches when you backport to 4.14 and 4.9 and
>> add both upstream commits in the change log.
> 
> Please do not ever combine patches for stable submissions, we want to
> keep things as close as to what happened in Linus's tree as possible as
> we track commit ids and putting 2 together is pretty impossible to
> manage over time.
> 

Good point. Thank you.

thanks,
-- Shuah

